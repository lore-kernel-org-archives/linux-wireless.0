Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:37516 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZDYTL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 15:11:59 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] p54usb: remove some dead code
Date: Sat, 25 Apr 2009 21:11:55 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200904252111.56133.chunkeey@web.de> (sfid-20090425_211203_424965_B6427EEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since "p54: prevent upload of wrong firmwares" we no longer allow
outdated LM86 firmwares to be uploaded on ISL3887 (LM87) devices.
Therefore we can purge this buggy legacy code altogether.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 6cc6cbc..44ab3cc 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -206,53 +206,6 @@ static int p54u_init_urbs(struct ieee80211_hw *dev)
 	return ret;
 }
 
-static void p54u_tx_3887(struct ieee80211_hw *dev, struct sk_buff *skb)
-{
-	struct p54u_priv *priv = dev->priv;
-	struct urb *addr_urb, *data_urb;
-	int err = 0;
-
-	addr_urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!addr_urb)
-		return;
-
-	data_urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!data_urb) {
-		usb_free_urb(addr_urb);
-		return;
-	}
-
-	usb_fill_bulk_urb(addr_urb, priv->udev,
-			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
-			  &((struct p54_hdr *)skb->data)->req_id, 4,
-			  p54u_tx_dummy_cb, dev);
-	usb_fill_bulk_urb(data_urb, priv->udev,
-			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
-			  skb->data, skb->len, FREE_AFTER_TX(skb) ?
-			  p54u_tx_cb : p54u_tx_dummy_cb, skb);
-	addr_urb->transfer_flags |= URB_ZERO_PACKET;
-	data_urb->transfer_flags |= URB_ZERO_PACKET;
-
-	usb_anchor_urb(addr_urb, &priv->submitted);
-	err = usb_submit_urb(addr_urb, GFP_ATOMIC);
-	if (err) {
-		usb_unanchor_urb(addr_urb);
-		goto out;
-	}
-
-	usb_anchor_urb(data_urb, &priv->submitted);
-	err = usb_submit_urb(data_urb, GFP_ATOMIC);
-	if (err)
-		usb_unanchor_urb(data_urb);
-
- out:
-	usb_free_urb(addr_urb);
-	usb_free_urb(data_urb);
-
-	if (err)
-		p54_free_skb(dev, skb);
-}
-
 static __le32 p54u_lm87_chksum(const __le32 *data, size_t length)
 {
 	u32 chk = 0;
@@ -954,13 +907,10 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 	priv->common.stop = p54u_stop;
 	if (recognized_pipes < P54U_PIPE_NUMBER) {
 		priv->hw_type = P54U_3887;
+		dev->extra_tx_headroom += sizeof(struct lm87_tx_hdr);
+		priv->common.tx_hdr_len = sizeof(struct lm87_tx_hdr);
+		priv->common.tx = p54u_tx_lm87;
 		err = p54u_upload_firmware_3887(dev);
-		if (priv->common.fw_interface == FW_LM87) {
-			dev->extra_tx_headroom += sizeof(struct lm87_tx_hdr);
-			priv->common.tx_hdr_len = sizeof(struct lm87_tx_hdr);
-			priv->common.tx = p54u_tx_lm87;
-		} else
-			priv->common.tx = p54u_tx_3887;
 	} else {
 		priv->hw_type = P54U_NET2280;
 		dev->extra_tx_headroom += sizeof(struct net2280_tx_hdr);
