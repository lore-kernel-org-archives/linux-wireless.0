Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:57712 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbZASWiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 17:38:06 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Mon, 19 Jan 2009 23:38:09 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <494698AF.4020204@gmail.com> <200901191948.57069.chunkeey@web.de> <4974F63F.4050302@gmail.com>
In-Reply-To: <4974F63F.4050302@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_RDQdJ7HN6EobNgL"
Message-Id: <200901192338.09646.chunkeey@web.de> (sfid-20090119_233815_641468_6D7305ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_RDQdJ7HN6EobNgL
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 19 January 2009 22:53:03 Artur Skawina wrote:
> Christian Lamparter wrote:
> > On Monday 19 January 2009 19:15:09 Artur Skawina wrote:
> >> Christian Lamparter wrote:
> >>> On Monday 19 January 2009 00:27:02 Artur Skawina wrote:
> >>>> Artur Skawina wrote:
> >>>>> didn't trigger anything here, just the usual:
> >>>>>
> >>>>> BUG kmalloc-4096: Poison overwritten
> >>>> This is almost 100% reproducible; sometimes the machine freezes instead.
> >> Here's an interesting sequence:
> >>
> >> 1) a TX urb is submitted.
> >> 2) p54u_rx_cb() => p54_rx_frame_sent(), which does kfree_skb( the_skb_in_(1) ).
> >> 3) p54u_tx_cb() for (1) is called with the same, now freed, skb. kaboom.
> >>
> >> IOW the skb is freed before the usb completion runs.
> > 
> > Well, the sequence should be:
> > 
> > 1) p54_tx gets called
> > 1.1) one IRQ urb is submitted
> > 1.2) one BULK urb is submitted
> > 2) the firmware acks that it got the urbs
> > 2.1) p54u_tx_cb is called for the IRQ urb. which frees the small buffer
> > 2.2) p54u_tx_cb is called for the BULK urb. which only removes the net2280_tx_hdr from the skb.
> > [time passes]
> > 3) firmware is finished sending.
> > 3.1) p54u_rx_cb gets called
> >        => p54_rx_frame_sent passed the feedback to mac80211
> 
> That's what one would expect, and is probably why i couldn't see anything
> wrong in the code despite going over it several times. Until i got a crash
> which left no doubt as to what happened, and made me notice the "wrong"
> completion order, log attached [1].
> In theory, theory and practice do not differ, in practice...
> 
> >> Somehow i don't think this is the reason for the corruption, but it certainly
> >> seems to be responsible for some, if not all, of the crashes/panics.
> > dunno... we should see a bit more fallout, because skb_pull changes skb->data and skb->len. 
> 
> Doing an skb_pull in p54u_tx_cb on skbs that have already been given to mac80211
> cannot be good.
> We can move the FREE_AFTER_TX(skb) check from the completion to the submission
> path, right? Then find a way to do the pull _before_ giving away the skbs.
> I can't shutdown the machine where i can reproduce this today, so it will have
> to wait until at least tomorrow.
> 
> artur

Like this?

--Boundary-00=_RDQdJ7HN6EobNgL
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="p54-diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-diff"

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 3bfee58..364ef39 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -144,11 +144,8 @@ static void p54u_tx_cb(struct urb *urb)
 	struct sk_buff *skb = urb->context;
 	struct ieee80211_hw *dev = (struct ieee80211_hw *)
 		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
-	struct p54u_priv *priv = dev->priv;
 
-	skb_pull(skb, priv->common.tx_hdr_len);
-	if (FREE_AFTER_TX(skb))
-		p54_free_skb(dev, skb);
+	p54_free_skb(dev, skb);
 }
 
 static void p54u_tx_dummy_cb(struct urb *urb) { }
@@ -230,7 +227,8 @@ static void p54u_tx_3887(struct ieee80211_hw *dev, struct sk_buff *skb)
 			  p54u_tx_dummy_cb, dev);
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
-			  skb->data, skb->len, p54u_tx_cb, skb);
+			  skb->data, skb->len, FREE_AFTER_TX(skb) ?
+			  p54u_tx_cb : p54u_tx_dummy_cb, skb);
 
 	usb_anchor_urb(addr_urb, &priv->submitted);
 	err = usb_submit_urb(addr_urb, GFP_ATOMIC);
@@ -269,28 +267,24 @@ static void p54u_tx_lm87(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54u_priv *priv = dev->priv;
 	struct urb *data_urb;
-	struct lm87_tx_hdr *hdr;
-	__le32 checksum;
-	__le32 addr = ((struct p54_hdr *)skb->data)->req_id;
+	struct lm87_tx_hdr *hdr = (void *)skb->data - sizeof(*hdr);
 
 	data_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!data_urb)
 		return;
 
-	checksum = p54u_lm87_chksum((__le32 *)skb->data, skb->len);
-	hdr = (struct lm87_tx_hdr *)skb_push(skb, sizeof(*hdr));
-	hdr->chksum = checksum;
-	hdr->device_addr = addr;
+	hdr->chksum = p54u_lm87_chksum((__le32 *)skb->data, skb->len);
+	hdr->device_addr = ((struct p54_hdr *)skb->data)->req_id;
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
-			  skb->data, skb->len, p54u_tx_cb, skb);
+			  hdr, skb->len + sizeof(*hdr),  FREE_AFTER_TX(skb) ?
+			  p54u_tx_cb : p54u_tx_dummy_cb, skb);
 	data_urb->transfer_flags |= URB_ZERO_PACKET;
 
 	usb_anchor_urb(data_urb, &priv->submitted);
 	if (usb_submit_urb(data_urb, GFP_ATOMIC)) {
 		usb_unanchor_urb(data_urb);
-		skb_pull(skb, sizeof(*hdr));
 		p54_free_skb(dev, skb);
 	}
 	usb_free_urb(data_urb);
@@ -300,11 +294,9 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54u_priv *priv = dev->priv;
 	struct urb *int_urb, *data_urb;
-	struct net2280_tx_hdr *hdr;
+	struct net2280_tx_hdr *hdr = (void *)skb->data - sizeof(*hdr);
 	struct net2280_reg_write *reg;
 	int err = 0;
-	__le32 addr = ((struct p54_hdr *) skb->data)->req_id;
-	__le16 len = cpu_to_le16(skb->len);
 
 	reg = kmalloc(sizeof(*reg), GFP_ATOMIC);
 	if (!reg)
@@ -327,10 +319,9 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb)
 	reg->addr = cpu_to_le32(P54U_DEV_BASE);
 	reg->val = cpu_to_le32(ISL38XX_DEV_INT_DATA);
 
-	hdr = (void *)skb_push(skb, sizeof(*hdr));
 	memset(hdr, 0, sizeof(*hdr));
-	hdr->len = len;
-	hdr->device_addr = addr;
+	hdr->len = cpu_to_le16(skb->len);
+	hdr->device_addr = ((struct p54_hdr *) skb->data)->req_id;
 
 	usb_fill_bulk_urb(int_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV), reg, sizeof(*reg),
@@ -345,7 +336,8 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb)
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
-			  skb->data, skb->len, p54u_tx_cb, skb);
+			  hdr, skb->len + sizeof(*hdr), FREE_AFTER_TX(skb) ?
+			  p54u_tx_cb : p54u_tx_dummy_cb, skb);
 
 	usb_anchor_urb(int_urb, &priv->submitted);
 	err = usb_submit_urb(int_urb, GFP_ATOMIC);

--Boundary-00=_RDQdJ7HN6EobNgL--
