Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:49716 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbYHMVi5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 17:38:57 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] p54u: reset skb's data/tail pointer on requeue
Date: Wed, 13 Aug 2008 23:41:48 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	navilein@hotmail.com, Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808132341.49402.chunkeey@web.de> (sfid-20080813_233859_790830_06C27483)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Only important for USB V1 Adaptors)

If an incoming frame wasn't accepted by p54_rx function
the skb will be reused for new frames...

But, we must not forget to set the skb's data pointers into
the same state in which it was initialized by p54u_init_urbs.

Otherwise we either end up with 16 bytes less on every requeue,
or if a new frame is worthy enough to be accepted, the data is
in the wrong place (urb->transfer_buffer wasn't updated!) and mac80211
has a hard time to recognize it...

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
--- a/drivers/net/wireless/p54/p54usb.c	2008-08-13 20:51:54.000000000 +0200
+++ b/drivers/net/wireless/p54/p54usb.c	2008-08-13 23:28:50.000000000 +0200
@@ -109,7 +109,17 @@ static void p54u_rx_cb(struct urb *urb)
 		urb->context = skb;
 		skb_queue_tail(&priv->rx_queue, skb);
 	} else {
+		if (!priv->hw_type)
+			skb_push(skb, sizeof(struct net2280_tx_hdr));
+
+		skb_reset_tail_pointer(skb);
 		skb_trim(skb, 0);
+		if (urb->transfer_buffer != skb_tail_pointer(skb)) {
+			/* this should not happen */ 
+			WARN_ON(1);
+			urb->transfer_buffer = skb_tail_pointer(skb);
+		}
+
 		skb_queue_tail(&priv->rx_queue, skb);
 	}
 

