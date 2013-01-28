Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:20460 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab3A1Kzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 05:55:41 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	<netdev@vger.kernel.org>
Subject: Re: [PATCH] net: wireless/ath: Fix compile error seen with W=1
Date: Mon, 28 Jan 2013 12:55:37 +0200
Message-ID: <1368762.AOqRHlT7Ra@lx-vladimir> (sfid-20130128_115546_978625_BBB4C882)
In-Reply-To: <1359253568-15762-1-git-send-email-linux@roeck-us.net>
References: <1359253568-15762-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, January 26, 2013 06:26:08 PM Guenter Roeck wrote:
> make W=1 for x86_64 fails with
> 
> drivers/net/wireless/ath/wil6210/txrx.c: In function ‘wil_rx_fini’:
> drivers/net/wireless/ath/wil6210/txrx.c:550:7: error: variable ‘rc’ set but not
> used [-Werror=unused-but-set-variable]
> 
> Fix by dropping the variable.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/net/wireless/ath/wil6210/txrx.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
> index f29c294..b6e8042 100644
> --- a/drivers/net/wireless/ath/wil6210/txrx.c
> +++ b/drivers/net/wireless/ath/wil6210/txrx.c
> @@ -547,7 +547,6 @@ void wil_rx_fini(struct wil6210_priv *wil)
>  	struct vring *vring = &wil->vring_rx;
>  
>  	if (vring->va) {
> -		int rc;
>  		struct wmi_cfg_rx_chain_cmd cmd = {
>  			.action = cpu_to_le32(WMI_RX_CHAIN_DEL),
>  			.rx_sw_ring = {
> @@ -559,7 +558,7 @@ void wil_rx_fini(struct wil6210_priv *wil)
>  			struct wmi_cfg_rx_chain_done_event cfg;
>  		} __packed wmi_rx_cfg_reply;
>  
> -		rc = wmi_call(wil, WMI_CFG_RX_CHAIN_CMDID, &cmd, sizeof(cmd),
> +		(void)wmi_call(wil, WMI_CFG_RX_CHAIN_CMDID, &cmd, sizeof(cmd),
>  			      WMI_CFG_RX_CHAIN_DONE_EVENTID,
>  			      &wmi_rx_cfg_reply, sizeof(wmi_rx_cfg_reply),
>  			      100);
> 

Thanks for finding it.

I will send series of new patches shortly. This will include changes in
rx chain initialization that, among other, remove fragment you fixed.
Reason is firmware API changes.

Thanks, Vladimir
