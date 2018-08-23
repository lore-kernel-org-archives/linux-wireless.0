Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:48964 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730175AbeHWPhJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 11:37:09 -0400
Date: Thu, 23 Aug 2018 17:37:36 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Claudiu Beznea <Claudiu.Beznea@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>,
        <adham.abozaeid@microchip.com>
Subject: Re: [PATCH 24/24] staging: wilc1000: remove unnecessary static
 variable 'p2p_listen_state'
Message-ID: <20180823173736.5c54a432@ajaysk-VirtualBox> (sfid-20180823_140745_845900_3E20FBB0)
In-Reply-To: <f79b44e1-6a4a-6b7a-f0d7-25f1e3c8dc4a@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
        <1534229416-13254-25-git-send-email-ajay.kathat@microchip.com>
        <f79b44e1-6a4a-6b7a-f0d7-25f1e3c8dc4a@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 23 Aug 2018 11:13:04 +0300
Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:

> 
> 
> On 14.08.2018 09:50, Ajay Singh wrote:
> > Remove the use of unnecessary static variable 'p2p_listen_state'.
> > Already 'p2p_listen_state' is present in 'wilc_priv' struct. So
> > making use of that variable as its getting set in channel ready and
> > remain on channel expired callback.
> > 
> > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > ---
> >  drivers/staging/wilc1000/host_interface.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/staging/wilc1000/host_interface.c
> > b/drivers/staging/wilc1000/host_interface.c index d8cc08b..cf7ead5
> > 100644 --- a/drivers/staging/wilc1000/host_interface.c
> > +++ b/drivers/staging/wilc1000/host_interface.c
> > @@ -185,8 +185,6 @@ struct join_bss_param {
> >  	u8 start_time[4];
> >  };
> >  
> > -static u8 p2p_listen_state;
> > -
> >  /* 'msg' should be free by the caller for syc */
> >  static struct host_if_msg*
> >  wilc_alloc_work(struct wilc_vif *vif, void (*work_fun)(struct
> > work_struct *), @@ -2351,7 +2349,6 @@ static int
> > handle_remain_on_chan(struct wilc_vif *vif, netdev_err(vif->ndev,
> > "Failed to set remain on channel\n"); 
> >  error:
> > -	p2p_listen_state = 1;
> >  	hif_drv->remain_on_ch_timer_vif = vif;
> >  	mod_timer(&hif_drv->remain_on_ch_timer,
> >  		  jiffies +
> > msecs_to_jiffies(hif_remain_ch->duration)); @@ -2407,8 +2404,9 @@
> > static void handle_listen_state_expired(struct work_struct *work)
> > struct wid wid; int result;
> >  	struct host_if_drv *hif_drv = vif->hif_drv;
> > +	struct wilc_priv *priv =
> > wdev_priv(vif->ndev->ieee80211_ptr); 
> > -	if (p2p_listen_state) {
> > +	if (priv->p2p_listen_state) {
> >  		remain_on_chan_flag = false;
> >  		wid.id = WID_REMAIN_ON_CHAN;
> >  		wid.type = WID_STR;
> > @@ -2433,7 +2431,6 @@ static void
> > handle_listen_state_expired(struct work_struct *work)
> > hif_drv->remain_on_ch.expired(hif_drv->remain_on_ch.arg,
> > hif_remain_ch->id); }
> > -		p2p_listen_state = 0;
> 
> Is this useless at all?

Instead of using the static variable now making use of
'p2p_listen_state' variable already maintained in priv data.
'p2p_listen_state' variable is already getting set in the
wilc_wfi_remain_on_channel_ready() and
wilc_wfi_remain_on_channel_expired(). So I think setting it explicitly
not required as the callbacks will take care to set the flag.

> 
> >  	} else {
> >  		netdev_dbg(vif->ndev, "Not in listen state\n");
> >  	}
> > 
