Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33291 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbbI0ISa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 04:18:30 -0400
Received: by wiclk2 with SMTP id lk2so68254495wic.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2015 01:18:29 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/6] staging: vt6656: remove RX complete locking.
Date: Sun, 27 Sep 2015 09:17:44 +0100
Message-Id: <1443341864-2756-6-git-send-email-tvboxspy@gmail.com> (sfid-20150927_101855_444486_03295B19)
In-Reply-To: <1443341864-2756-1-git-send-email-tvboxspy@gmail.com>
References: <1443341864-2756-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The lock in vnt_submit_rx_urb_complete is blocked by TX activity.

The lock comes from a time when RX needed to be synchronized with
other parts of the driver because the WLAN API was in driver.

Since this is now dealt with in mac80211 the lock is unnecessary.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index a5912dd..c975c3b 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -168,7 +168,6 @@ static void vnt_submit_rx_urb_complete(struct urb *urb)
 {
 	struct vnt_rcb *rcb = urb->context;
 	struct vnt_private *priv = rcb->priv;
-	unsigned long flags;
 
 	switch (urb->status) {
 	case 0:
@@ -184,8 +183,6 @@ static void vnt_submit_rx_urb_complete(struct urb *urb)
 	}
 
 	if (urb->actual_length) {
-		spin_lock_irqsave(&priv->lock, flags);
-
 		if (vnt_rx_data(priv, rcb, urb->actual_length)) {
 			rcb->skb = dev_alloc_skb(priv->rx_buf_sz);
 			if (!rcb->skb) {
@@ -193,7 +190,6 @@ static void vnt_submit_rx_urb_complete(struct urb *urb)
 					"Failed to re-alloc rx skb\n");
 
 				rcb->in_use = false;
-				spin_unlock_irqrestore(&priv->lock, flags);
 				return;
 			}
 		} else {
@@ -203,8 +199,6 @@ static void vnt_submit_rx_urb_complete(struct urb *urb)
 
 		urb->transfer_buffer = skb_put(rcb->skb,
 						skb_tailroom(rcb->skb));
-
-		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
 	if (usb_submit_urb(urb, GFP_ATOMIC)) {
-- 
2.5.0

