Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:55072 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbZGDKLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 06:11:46 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
Date: Sat, 4 Jul 2009 12:11:48 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Max Filippov <jcmvbkbc@gmail.com>
References: <200907040053.05654.chunkeey@web.de> <4A4EBB68.6050502@lwfinger.net>
In-Reply-To: <4A4EBB68.6050502@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907041211.49115.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 04 July 2009 04:16:08 Larry Finger wrote:
> Christian Lamparter wrote:
> > This patch tries to address a long standing issue: 
> > how to survive serve memory starvation situations,
> > without losing the device due to missing transfer-buffers.
> > 
> > And with a flick of __GFP_NOWARN, we're able to handle ?all? memory
> > allocation failures on the rx-side during operation without much fuss.
> > 
> > However, there is still an issue within the xmit-part.
> > This is likely due to p54's demand for a large free headroom for
> > every outgoing frame:
> > 
> -- snip --
> 
> > diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
> > index 461d88f..c521bbc 100644
> > --- a/drivers/net/wireless/p54/p54usb.c
> > +++ b/drivers/net/wireless/p54/p54usb.c
> > @@ -120,37 +120,14 @@ static void p54u_rx_cb(struct urb *urb)
> >  	}
> >  
> >  	skb_put(skb, urb->actual_length);
> > +	skb = p54_rx(dev, skb);
> >  
> > -	if (priv->hw_type == P54U_NET2280)
> > -		skb_pull(skb, priv->common.tx_hdr_len);
> > -	if (priv->common.fw_interface == FW_LM87) {
> > -		skb_pull(skb, 4);
> > -		skb_put(skb, 4);
> > -	}
> > -
> > -	if (p54_rx(dev, skb)) {
> > -		skb = dev_alloc_skb(priv->common.rx_mtu + 32);
> > -		if (unlikely(!skb)) {
> > -			/* TODO check rx queue length and refill *somewhere* */
> > -			return;
> > -		}
> > +	info = (struct p54u_rx_info *) skb->cb;
> > +	info->urb = urb;
> > +	info->dev = dev;
> > +	urb->transfer_buffer = skb_tail_pointer(skb);
> > +	urb->context = skb;
> >  
> > -		info = (struct p54u_rx_info *) skb->cb;
> > -		info->urb = urb;
> > -		info->dev = dev;
> > -		urb->transfer_buffer = skb_tail_pointer(skb);
> > -		urb->context = skb;
> > -	} else {
> > -		if (priv->hw_type == P54U_NET2280)
> > -			skb_push(skb, priv->common.tx_hdr_len);
> > -		if (priv->common.fw_interface == FW_LM87) {
> > -			skb_push(skb, 4);
> > -			skb_put(skb, 4);
> > -		}
> > -		skb_reset_tail_pointer(skb);
> > -		skb_trim(skb, 0);
> > -		urb->transfer_buffer = skb_tail_pointer(skb);
> > -	}
> >  	skb_queue_tail(&priv->rx_queue, skb);
> >  	usb_anchor_urb(urb, &priv->submitted);
> >  	if (usb_submit_urb(urb, GFP_ATOMIC)) {
> > @@ -186,7 +163,7 @@ static int p54u_init_urbs(struct ieee80211_hw *dev)
> >  	int ret = 0;
> >  
> >  	while (skb_queue_len(&priv->rx_queue) < 32) {
> > -		skb = __dev_alloc_skb(priv->common.rx_mtu + 32, GFP_KERNEL);
> > +		skb = __dev_alloc_skb(priv->common.rx_mtu, GFP_KERNEL);
> >  		if (!skb) {
> >  			ret = -ENOMEM;
> >  			goto err;
> > @@ -927,14 +904,17 @@ static int __devinit p54u_probe(struct usb_interface *intf,
> >  #endif
> >  
> >  		priv->hw_type = P54U_3887;
> > +		priv->common.rx_wa_extra_tail_space = true;
> >  		dev->extra_tx_headroom += sizeof(struct lm87_tx_hdr);
> >  		priv->common.tx_hdr_len = sizeof(struct lm87_tx_hdr);
> > +		priv->common.rx_hdr_len = sizeof(struct lm87_rx_hdr);
> >  		priv->common.tx = p54u_tx_lm87;
> >  		priv->upload_fw = p54u_upload_firmware_3887;
> >  	} else {
> >  		priv->hw_type = P54U_NET2280;
> >  		dev->extra_tx_headroom += sizeof(struct net2280_tx_hdr);
> >  		priv->common.tx_hdr_len = sizeof(struct net2280_tx_hdr);
> > +		priv->common.rx_hdr_len = sizeof(struct net2280_tx_hdr);
>                                                                 ==
> Should this be rx rather than tx?
I hope not...
@@ -120,37 +120,14 @@ static void p54u_rx_cb(struct urb *urb)
   
  	skb_put(skb, urb->actual_length);
  
	if (priv->hw_type == P54U_NET2280)
		skb_pull(skb, priv->common.tx_hdr_len);

net2280_tx_hdr's name is misleading, as the rx urbs have the header as well.
will probably change that to net2280_hdr in the future. 

> -- skip --
> 
> I have a problem that is not new with this patch. Using p54usb with
> LM87 firmware and under the heavy load of building a kernel with the
> source tree mounted with NFS, the interface will go off-line and
> cannot reconnect. When the driver is unloaded and reloaded, it is
> unable to reload the firmware. My log is as follows:
> 
> usb 1-5: new high speed USB device using ehci_hcd and address 3
> usb 1-5: configuration #1 chosen from 1 choice
> cfg80211: Calling CRDA to update world regulatory domain
> usb 1-5: reset high speed USB device using ehci_hcd and address 3
> usb 1-5: firmware: requesting isl3887usb
> phy0: p54 detected a LM87 firmware
> p54: rx_mtu reduced from 3240 to 2380
> phy0: FW rev 2.13.24.0 - Softmac protocol 5.9
> phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> phy0: hwaddr 00:90:4b:d2:1f:cd, MAC:isl3892 RF:Xbow
> phy0: Selected rate control algorithm 'minstrel'
> Registered led device: p54-phy0::assoc
> Registered led device: p54-phy0::tx
> Registered led device: p54-phy0::rx
> Registered led device: p54-phy0::radio
> usb 1-5: is registered as 'phy0'
> usbcore: registered new interface driver p54usb
> wlan0: authenticate with AP 00:1a:70:46:ba:b1
> wlan0: authenticated
> wlan0: associate with AP 00:1a:70:46:ba:b1
> wlan0: RX AssocResp from 00:1a:70:46:ba:b1 (capab=0x431 status=0 aid=1)
> wlan0: associated
> wlan0: no probe response from AP 00:1a:70:46:ba:b1 - disassociating
> usbcore: deregistering interface driver p54usb
> cfg80211: Calling CRDA to update world regulatory domain
> usb 1-5: reset high speed USB device using ehci_hcd and address 3
> usb 1-5: firmware: requesting isl3887usb
> phy0: p54 detected a LM87 firmware
> p54: rx_mtu reduced from 3240 to 2380
> phy0: FW rev 2.13.24.0 - Softmac protocol 5.9
> phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> usb 1-5: (p54usb) firmware upload failed!
> p54usb: probe of 1-5:1.0 failed with error -110
> 

hmm, is it possible for you to log the usb transfer?
A excellent tool for this is usbmon (userspace)... can be found here: 
	http://git.sipsolutions.net/usbmon.git

usbmon -s 3000 -i $(USB_ID) (which is usually number between 1 and the amount of connected usb devices))  > dst

and set p54common nohwcrypt=1, if you don't want to show GK/TK around ;-)

Regards,
	Chr
