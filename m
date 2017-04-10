Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36404 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751140AbdDJVlE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 17:41:04 -0400
Received: by mail-wm0-f53.google.com with SMTP id o81so49224626wmb.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 14:41:03 -0700 (PDT)
Subject: Re: [PATCH v2] staging: wilc1000: New cfg packet format in
 handle_set_wfi_drv_handler
To: Aditya Shankar <aditya.shankar@microchip.com>,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org
References: <1491800506-26038-1-git-send-email-aditya.shankar@microchip.com>
Cc: ganesh.krishna@microchip.com, devel@driverdev.osuosl.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <04381e51-301a-e65a-09e8-54db4487f01a@broadcom.com> (sfid-20170410_234107_943433_5AB601C4)
Date: Mon, 10 Apr 2017 23:41:01 +0200
MIME-Version: 1.0
In-Reply-To: <1491800506-26038-1-git-send-email-aditya.shankar@microchip.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-4-2017 7:01, Aditya Shankar wrote:
> Change the config packet format used in handle_set_wfi_drv_handler()
> to align the host driver with the new format used in the wilc firmware.
> 
> The change updates the format in which the host driver provides the
> firmware with the drv_handler index and also uses two new
> fields viz. "mode" and 'name" in the config packet along with this index
> to directly provide details about the interface and its mode to the
> firmware instead of having multiple if-else statements in the host driver
> to decide which interface to configure.

changelog should move after Signed-off-by tag separated by '---' so it
does not end up in the commit message.

> Change in v2:
> Fixed build warning
> 
> Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
> ---
so put changelog here.
---
>  drivers/staging/wilc1000/host_interface.c         | 54 +++++++++++++++++++----
>  drivers/staging/wilc1000/host_interface.h         |  9 +++-
>  drivers/staging/wilc1000/linux_wlan.c             | 29 +++---------
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
>  drivers/staging/wilc1000/wilc_wlan_if.h           |  2 +-
>  5 files changed, 59 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index c3a8af0..ad1e625 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -198,6 +198,7 @@ struct host_if_msg {
>  	union message_body body;
>  	struct wilc_vif *vif;
>  	struct work_struct work;
> +	void *drv_handler;
>  };
>  
>  struct join_bss_param {
> @@ -334,14 +335,42 @@ static void handle_set_wfi_drv_handler(struct wilc_vif *vif,
>  {
>  	int ret = 0;
>  	struct wid wid;
> +	u8 *currbyte;
> +	struct host_if_drv *hif_drv = NULL;
> +	int driver_handler_id = 0;
> +	u8 *buffer = kzalloc(DRV_HANDLER_SIZE, GFP_ATOMIC);

I would only use constant initializers. So declare buffer and do
kzalloc() later. Also be prepared to deal with kzalloc() returning a
NULL pointer upon allocation failure.

> +	if (!vif->hif_drv)
> +		return;
> +
> +	if (!hif_drv_handler)
> +		return;
> +
> +	hif_drv	= vif->hif_drv;
> +
> +	if (hif_drv)

This if statement is bogus as you already checked vif->hif_drv earlier.

> +		driver_handler_id = hif_drv->driver_handler_id;
> +	else
> +		driver_handler_id = 0;
> +
> +	currbyte = buffer;
> +	*currbyte = driver_handler_id & DRV_HANDLER_MASK;

This will crash with null-deref if kzalloc() fails.

> +	currbyte++;
> +	*currbyte = (u32)0 & DRV_HANDLER_MASK;
> +	currbyte++;
> +	*currbyte = (u32)0 & DRV_HANDLER_MASK;
> +	currbyte++;
> +	*currbyte = (u32)0 & DRV_HANDLER_MASK;
> +	currbyte++;
> +	*currbyte = (hif_drv_handler->name | (hif_drv_handler->mode << 1));
>  
>  	wid.id = (u16)WID_SET_DRV_HANDLER;
>  	wid.type = WID_STR;
> -	wid.val = (s8 *)hif_drv_handler;
> -	wid.size = sizeof(*hif_drv_handler);
> +	wid.val = (s8 *)buffer;
> +	wid.size = DRV_HANDLER_SIZE;
>  
>  	ret = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
> -				   hif_drv_handler->handler);
> +				   driver_handler_id);
>  
>  	if (!hif_drv_handler->handler)
>  		complete(&hif_driver_comp);

[...]

> @@ -3099,7 +3128,8 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
>  	return 0;
>  }
>  
> -int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx)
> +int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode, char
> +			     *ifname)
>  {
>  	int result = 0;
>  	struct host_if_msg msg;
> @@ -3107,9 +3137,14 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx)
>  	memset(&msg, 0, sizeof(struct host_if_msg));
>  	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
>  	msg.body.drv.handler = index;
> -	msg.body.drv.mac_idx = mac_idx;
> +	msg.body.drv.mode = mode;
>  	msg.vif = vif;
>  
> +	if (!memcmp(ifname, "wlan0", 5))
> +		msg.body.drv.name = 1;
> +	else if (!memcmp(ifname, "p2p0", 4))
> +		msg.body.drv.name = 0;
> +

You really can not compare netdev names like that. User-space, eg.
udevd, determines the names. So you should find another way to map the
netdev to that name value. You could store the name value in the
structure you have in netdev_priv.

>  	result = wilc_enqueue_cmd(&msg);
>  	if (result) {
>  		netdev_err(vif->ndev, "wilc mq send fail\n");
> @@ -3330,6 +3365,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
>  	for (i = 0; i < wilc->vif_num; i++)
>  		if (dev == wilc->vif[i]->ndev) {
>  			wilc->vif[i]->hif_drv = hif_drv;
> +			hif_drv->driver_handler_id = i + 1;
>  			break;
>  		}
>  
> @@ -3403,7 +3439,7 @@ int wilc_deinit(struct wilc_vif *vif)
>  	del_timer_sync(&periodic_rssi);
>  	del_timer_sync(&hif_drv->remain_on_ch_timer);
>  
> -	wilc_set_wfi_drv_handler(vif, 0, 0);
> +	wilc_set_wfi_drv_handler(vif, 0, 0, 0);

That last parameter should really be NULL as it is a pointer type. But
that will give you a null-deref when you do the memcmp() of ifname.

>  	wait_for_completion(&hif_driver_comp);
>  
>  	if (hif_drv->usr_scan_req.scan_result) {
> diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
> index f36d3b5..77e7f26 100644
> --- a/drivers/staging/wilc1000/host_interface.h
> +++ b/drivers/staging/wilc1000/host_interface.h

[...]

> @@ -354,7 +358,8 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
>  			   void *user_arg);
>  int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id);
>  int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
> -int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx);
> +int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode, char
> +			     *ifname);

keep type and variable on same line.

>  int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
>  int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats);
>  void wilc_resolve_disconnect_aberration(struct wilc_vif *vif);

Regards,
Arend
