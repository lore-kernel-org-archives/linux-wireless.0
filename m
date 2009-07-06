Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:38580 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbZGFNRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 09:17:55 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54usb: fix stalls caused by urb allocation failures
Date: Mon, 6 Jul 2009 15:17:56 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907061517.56201.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch squashes a few old bugs, which have been around since
the initial version of p54usb in one form or another.

we never freed a orphaned frame, when were denied the resources,
which are necessary to pass the data into the usb subsystem.
As a result we could end up with a full queue that wasn't emptied,
until the device was brought down.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 461d88f..e44460f 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -246,8 +246,10 @@ static void p54u_tx_lm87(struct ieee80211_hw *dev, struct sk_buff *skb)
 	struct lm87_tx_hdr *hdr = (void *)skb->data - sizeof(*hdr);
 
 	data_urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!data_urb)
+	if (!data_urb) {
+		p54_free_skb(dev, skb);
 		return;
+	}
 
 	hdr->chksum = p54u_lm87_chksum((__le32 *)skb->data, skb->len);
 	hdr->device_addr = ((struct p54_hdr *)skb->data)->req_id;
@@ -269,27 +271,22 @@ static void p54u_tx_lm87(struct ieee80211_hw *dev, struct sk_buff *skb)
 static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54u_priv *priv = dev->priv;
-	struct urb *int_urb, *data_urb;
+	struct urb *int_urb = NULL, *data_urb = NULL;
 	struct net2280_tx_hdr *hdr = (void *)skb->data - sizeof(*hdr);
-	struct net2280_reg_write *reg;
-	int err = 0;
+	struct net2280_reg_write *reg = NULL;
+	int err = -ENOMEM;
 
 	reg = kmalloc(sizeof(*reg), GFP_ATOMIC);
 	if (!reg)
-		return;
+		goto out;
 
 	int_urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!int_urb) {
-		kfree(reg);
-		return;
-	}
+	if (!int_urb)
+		goto out;
 
 	data_urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!data_urb) {
-		kfree(reg);
-		usb_free_urb(int_urb);
-		return;
-	}
+	if (!data_urb)
+		goto out;
 
 	reg->port = cpu_to_le16(NET2280_DEV_U32);
 	reg->addr = cpu_to_le32(P54U_DEV_BASE);
@@ -304,11 +301,12 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb)
 		p54u_tx_dummy_cb, dev);
 
 	/*
-	 * This flag triggers a code path in the USB subsystem that will
-	 * free what's inside the transfer_buffer after the callback routine
-	 * has completed.
+	 * URB_FREE_BUFFER triggers a code path in the USB subsystem that will
+	 * free what is inside the transfer_buffer after the last reference to
+	 * the int_urb is dropped.
 	 */
 	int_urb->transfer_flags |= URB_FREE_BUFFER | URB_ZERO_PACKET;
+	reg = NULL;
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
@@ -329,12 +327,12 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb)
 		usb_unanchor_urb(data_urb);
 		goto out;
 	}
- out:
+out:
 	usb_free_urb(int_urb);
 	usb_free_urb(data_urb);
 
 	if (err) {
-		skb_pull(skb, sizeof(*hdr));
+		kfree(reg);
 		p54_free_skb(dev, skb);
 	}
 }
