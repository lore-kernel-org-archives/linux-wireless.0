Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:57613 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216AbZATWLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 17:11:15 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org,
	John W Linville l <linville@tuxdriver.com>
Subject: [PATCH] p54usb: fix packet loss with first generation devices
Date: Tue, 20 Jan 2009 23:11:21 +0100
Cc: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901202311.21366.chunkeey@web.de> (sfid-20090120_231119_532120_D7CC9CF5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Artur Skawina confirmed that the first generation devices needs the same 
URB_ZERO_PACKET flag, in oder to finish the pending transfer properly.
The second generation has been successfully fixed by
"p54usb: fix random traffic stalls (LM87)" (43af18f06d5)

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index da3e918..bf264b1 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -229,6 +229,8 @@ static void p54u_tx_3887(struct ieee80211_hw *dev, struct sk_buff *skb)
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
 			  skb->data, skb->len, FREE_AFTER_TX(skb) ?
 			  p54u_tx_cb : p54u_tx_dummy_cb, skb);
+	addr_urb->transfer_flags |= URB_ZERO_PACKET;
+	data_urb->transfer_flags |= URB_ZERO_PACKET;
 
 	usb_anchor_urb(addr_urb, &priv->submitted);
 	err = usb_submit_urb(addr_urb, GFP_ATOMIC);
@@ -237,7 +239,7 @@ static void p54u_tx_3887(struct ieee80211_hw *dev, struct sk_buff *skb)
 		goto out;
 	}
 
-	usb_anchor_urb(addr_urb, &priv->submitted);
+	usb_anchor_urb(data_urb, &priv->submitted);
 	err = usb_submit_urb(data_urb, GFP_ATOMIC);
 	if (err)
 		usb_unanchor_urb(data_urb);
@@ -332,12 +334,13 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb)
 	 * free what's inside the transfer_buffer after the callback routine
 	 * has completed.
 	 */
-	int_urb->transfer_flags |= URB_FREE_BUFFER;
+	int_urb->transfer_flags |= URB_FREE_BUFFER | URB_ZERO_PACKET;
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
 			  hdr, skb->len + sizeof(*hdr), FREE_AFTER_TX(skb) ?
 			  p54u_tx_cb : p54u_tx_dummy_cb, skb);
+	data_urb->transfer_flags |= URB_ZERO_PACKET;
 
 	usb_anchor_urb(int_urb, &priv->submitted);
 	err = usb_submit_urb(int_urb, GFP_ATOMIC);
