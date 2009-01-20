Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:41432 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZATMcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 07:32:51 -0500
To: Artur Skawina <art.08.09@gmail.com>
Subject: [PATCH v2] p54usb: fix nasty use after free
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>
From: Christian Lamparter <chunkeey@web.de>
Date: Tue, 20 Jan 2009 13:32:54 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901201332.54435.chunkeey@web.de> (sfid-20090120_133257_659074_94887F6A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In theory, the firmware acks the received a data frame, before signaling the driver to free it again.
However Artur Skawina has shown that it can happen in reverse order as well.
This is very bad and could lead to memory corruptions, oopses and panics.
 
Thanks to Artur Skawina <art.08.09@gmail.com> for reporting and debugging this issue.

Tested-by: Artur Skawina <art.08.09@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
Changes:
	- removed a forgotten skb_pull from p54u_tx_net2280 error - path.
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 3bfee58..da3e918 100644
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
@@ -360,14 +352,12 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb)
 		usb_unanchor_urb(data_urb);
 		goto out;
 	}
- out:
+out:
 	usb_free_urb(int_urb);
 	usb_free_urb(data_urb);
 
-	if (err) {
-		skb_pull(skb, sizeof(*hdr));
+	if (err)
 		p54_free_skb(dev, skb);
-	}
 }
 
 static int p54u_write(struct p54u_priv *priv,
