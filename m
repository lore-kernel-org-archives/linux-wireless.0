Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:49678 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab0DLQ3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 12:29:16 -0400
Received: by pzk42 with SMTP id 42so3903569pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 09:29:15 -0700 (PDT)
From: tom.leiming@gmail.com
To: Sujith.Manoharan@atheros.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ming Lei <tom.leiming@gmail.com>
Subject: [PATCHv2 1/4] ath9k-htc:respect usb buffer cacheline alignment in ath9k_hif_usb_alloc_rx_urbs
Date: Tue, 13 Apr 2010 00:28:53 +0800
Message-Id: <1271089733-7898-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

In ath9k_hif_usb_alloc_rx_urbs, ath9k-htc will pass skb->data into
usb hcd and usb hcd will do dma mapping and unmapping to the buffer
pointed by skb->data, so we should pass a cache-line aligned address.

This patch replace __dev_alloc_skb with alloc_skb to make skb->data
pointed to a cacheline aligned address simply since ath9k-htc does not
skb_push on the skb and pass it to mac80211, also use kfree_skb to free
the skbs allocated by alloc_skb(we can use kfree_skb safely in hardirq
context since skb->destructor is NULL always in the path).

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index e2117e7..178b11a 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -467,7 +467,7 @@ resubmit:
 
 	return;
 free:
-	dev_kfree_skb_any(skb);
+	kfree_skb(skb);
 }
 
 static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
@@ -625,7 +625,7 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 		}
 
 		/* Allocate buffer */
-		skb = __dev_alloc_skb(MAX_RX_BUF_SIZE, GFP_KERNEL);
+		skb = alloc_skb(MAX_RX_BUF_SIZE, GFP_KERNEL);
 		if (!skb) {
 			ret = -ENOMEM;
 			goto err_skb;
@@ -657,7 +657,7 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 	return 0;
 
 err_submit:
-	dev_kfree_skb_any(skb);
+	kfree_skb(skb);
 err_skb:
 	usb_free_urb(urb);
 err_urb:
-- 
1.6.2.5

