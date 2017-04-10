Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:19637 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbdDJDir (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Apr 2017 23:38:47 -0400
Date: Mon, 10 Apr 2017 09:08:40 +0530
From: Aditya Shankar <aditya.shankar@microchip.com>
To: Greg KH <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>
CC: <linux-wireless@vger.kernel.org>, <ganesh.krishna@microchip.com>
Subject: Re: [PATCH] staging: wilc1000: Update handler assignment logic
Message-ID: <20170410090840.7386d08c@aditya-ubuntu> (sfid-20170410_053850_792593_B1A99823)
In-Reply-To: <20170408110015.GA30777@kroah.com>
References: <1491566045-9265-1-git-send-email-aditya.shankar@microchip.com>
        <20170408110015.GA30777@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 8 Apr 2017 13:00:15 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Apr 07, 2017 at 05:24:05PM +0530, Aditya Shankar wrote:
> > With this update, the host driver is consistent with the
> > implementation on the firmware side with respect to obtaining
> > the driver handler for all modes.
> > With this new format, the calls to set the wilc operation mode
> > is simplified.
> > 
> > Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
> > ---
> >  drivers/staging/wilc1000/host_interface.c         | 56 +++++++++++++++++++----
> >  drivers/staging/wilc1000/host_interface.h         |  9 +++-
> >  drivers/staging/wilc1000/linux_wlan.c             | 29 ++----------
> >  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
> >  drivers/staging/wilc1000/wilc_wlan_if.h           |  2 +-
> >  5 files changed, 61 insertions(+), 37 deletions(-)
> > 
> > diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> > index c3a8af0..c04643e 100644
> > --- a/drivers/staging/wilc1000/host_interface.c
> > +++ b/drivers/staging/wilc1000/host_interface.c
> > @@ -198,6 +198,7 @@ struct host_if_msg {
> >  	union message_body body;
> >  	struct wilc_vif *vif;
> >  	struct work_struct work;
> > +	void *drv_handler;
> >  };
> >  
> >  struct join_bss_param {
> > @@ -334,14 +335,44 @@ static void handle_set_wfi_drv_handler(struct wilc_vif *vif,
> >  {
> >  	int ret = 0;
> >  	struct wid wid;
> > +	u8 *currbyte;
> > +	struct host_if_drv *hif_drv = NULL;
> > +	int driver_handler_id = 0;
> > +	u8 *buffer = kzalloc(DRV_HANDLER_SIZE, GFP_ATOMIC);
> > +
> > +	if (!vif->hif_drv)
> > +		return;
> > +
> > +	if (!hif_drv_handler)
> > +		return;
> > +
> > +	hif_drv	= vif->hif_drv;
> > +
> > +	if (hif_drv)
> > +		driver_handler_id = hif_drv->driver_handler_id;
> > +	else
> > +		driver_handler_id = 0;
> > +
> > +	driver_handler_id = hif_drv->driver_handler_id;
> > +
> > +	currbyte = buffer;
> > +	*currbyte = driver_handler_id & DRV_HANDLER_MASK;
> > +	currbyte++;
> > +	*currbyte = (u32)0 & DRV_HANDLER_MASK;
> > +	currbyte++;
> > +	*currbyte = (u32)0 & DRV_HANDLER_MASK;
> > +	currbyte++;
> > +	*currbyte = (u32)0 & DRV_HANDLER_MASK;
> > +	currbyte++;
> > +	*currbyte = (hif_drv_handler->name | (hif_drv_handler->mode << 1));
> >  
> >  	wid.id = (u16)WID_SET_DRV_HANDLER;
> >  	wid.type = WID_STR;
> > -	wid.val = (s8 *)hif_drv_handler;
> > -	wid.size = sizeof(*hif_drv_handler);
> > +	wid.val = (s8 *)buffer;
> > +	wid.size = DRV_HANDLER_SIZE;
> >  
> >  	ret = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
> > -				   hif_drv_handler->handler);
> > +				   driver_handler_id);
> >  
> >  	if (!hif_drv_handler->handler)
> >  		complete(&hif_driver_comp);
> > @@ -2403,9 +2434,9 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
> >  
> >  	pu8CurrByte = wid.val;
> >  	*pu8CurrByte++ = (strHostIfSetMulti->enabled & 0xFF);
> > -	*pu8CurrByte++ = 0;
> > -	*pu8CurrByte++ = 0;
> > -	*pu8CurrByte++ = 0;
> > +	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 8) & 0xFF);
> > +	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 16) & 0xFF);
> > +	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 24) & 0xFF);
> >  
> >  	*pu8CurrByte++ = (strHostIfSetMulti->cnt & 0xFF);
> >  	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 8) & 0xFF);
> > @@ -3099,7 +3130,8 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
> >  	return 0;
> >  }
> >  
> > -int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx)
> > +int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode, char
> > +			     *ifname)
> >  {
> >  	int result = 0;
> >  	struct host_if_msg msg;
> > @@ -3107,9 +3139,14 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx)
> >  	memset(&msg, 0, sizeof(struct host_if_msg));
> >  	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
> >  	msg.body.drv.handler = index;
> > -	msg.body.drv.mac_idx = mac_idx;
> > +	msg.body.drv.mode = mode;
> >  	msg.vif = vif;
> >  
> > +	if (!memcmp(ifname, "wlan0", 5))
> > +	msg.body.drv.name = 1;
> > +	else if (!memcmp(ifname, "p2p0", 4))
> > +	msg.body.drv.name = 0;  
> 
> Does that code look correct to you?
> 
> Always use checkpatch before sending your patches out.
> 
> Also, your changelog is very vague, please explain what is happening
> in your patch much better.
> 
> thanks,
> 
> greg k-h

That's a mistake. I will re-send the patch with a new subject line 
as "staging: wilc1000: New cfg packet format in handle_set_wfi_drv_handler"
and an updated description instead of a v2 of the same change log.

Thanks,
Aditya 
