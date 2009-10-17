Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52896 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbZJQT4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2009 15:56:49 -0400
Received: by mail-fx0-f218.google.com with SMTP id 18so3633004fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2009 12:56:53 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] ar9170usb: atomic pending urbs counter
Date: Sat, 17 Oct 2009 21:56:51 +0200
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910172156.52108.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch follows "ar9170: atomic pending A-MPDU counter"
idea and converts another critical counter to atomic_*.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index e974e58..6bdcdf6 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -108,15 +108,15 @@ static void ar9170_usb_submit_urb(struct ar9170_usb *aru)
 		return ;
 
 	spin_lock_irqsave(&aru->tx_urb_lock, flags);
-	if (aru->tx_submitted_urbs >= AR9170_NUM_TX_URBS) {
+	if (atomic_read(&aru->tx_submitted_urbs) >= AR9170_NUM_TX_URBS) {
 		spin_unlock_irqrestore(&aru->tx_urb_lock, flags);
 		return ;
 	}
-	aru->tx_submitted_urbs++;
+	atomic_inc(&aru->tx_submitted_urbs);
 
 	urb = usb_get_from_anchor(&aru->tx_pending);
 	if (!urb) {
-		aru->tx_submitted_urbs--;
+		atomic_dec(&aru->tx_submitted_urbs);
 		spin_unlock_irqrestore(&aru->tx_urb_lock, flags);
 
 		return ;
@@ -133,7 +133,7 @@ static void ar9170_usb_submit_urb(struct ar9170_usb *aru)
 				err);
 
 		usb_unanchor_urb(urb);
-		aru->tx_submitted_urbs--;
+		atomic_dec(&aru->tx_submitted_urbs);
 		ar9170_tx_callback(&aru->common, urb->context);
 	}
 
@@ -151,7 +151,7 @@ static void ar9170_usb_tx_urb_complete_frame(struct urb *urb)
 		return ;
 	}
 
-	aru->tx_submitted_urbs--;
+	atomic_dec(&aru->tx_submitted_urbs);
 
 	ar9170_tx_callback(&aru->common, skb);
 
@@ -794,7 +794,7 @@ static int ar9170_usb_probe(struct usb_interface *intf,
 	spin_lock_init(&aru->tx_urb_lock);
 
 	aru->tx_pending_urbs = 0;
-	aru->tx_submitted_urbs = 0;
+	atomic_set(&aru->tx_submitted_urbs, 0);
 
 	aru->common.stop = ar9170_usb_stop;
 	aru->common.flush = ar9170_usb_flush;
diff --git a/drivers/net/wireless/ath/ar9170/usb.h b/drivers/net/wireless/ath/ar9170/usb.h
index d098f4d..a2ce3b1 100644
--- a/drivers/net/wireless/ath/ar9170/usb.h
+++ b/drivers/net/wireless/ath/ar9170/usb.h
@@ -67,7 +67,7 @@ struct ar9170_usb {
 	bool req_one_stage_fw;
 
 	spinlock_t tx_urb_lock;
-	unsigned int tx_submitted_urbs;
+	atomic_t tx_submitted_urbs;
 	unsigned int tx_pending_urbs;
 
 	struct completion cmd_wait;
