Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37089
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711AbXHNSOB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 14:14:01 -0400
Message-Id: <20070814181216.382473000@bu3sch.de>
References: <20070814181213.135874000@bu3sch.de>
Date: Tue, 14 Aug 2007 20:12:20 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 7/9] b43: Fix frame retry count for suppressed frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(u8)0 - 1 == 255
which is wrong. Should be 0.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/dma.c	2007-08-12 16:38:51.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/dma.c	2007-08-13 16:01:07.000000000 +0200
@@ -1276,12 +1276,15 @@ void b43_dma_handle_txstatus(struct b43_
 			if (status->acked) {
 				meta->txstat.flags |= IEEE80211_TX_STATUS_ACK;
 			} else {
-				if (!
-				    (meta->txstat.control.
-				     flags & IEEE80211_TXCTL_NO_ACK))
+				if (!(meta->txstat.control.flags
+				      & IEEE80211_TXCTL_NO_ACK))
 					meta->txstat.excessive_retries = 1;
 			}
-			meta->txstat.retry_count = status->frame_count - 1;
+			if (status->frame_count == 0) {
+				/* The frame was not transmitted at all. */
+				meta->txstat.retry_count = 0;
+			} else
+				meta->txstat.retry_count = status->frame_count - 1;
 			ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb,
 						    &(meta->txstat));
 			/* skb is freed by ieee80211_tx_status_irqsafe() */
Index: wireless-dev-new/drivers/net/wireless/b43/pio.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/pio.c	2007-08-12 16:38:52.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/pio.c	2007-08-13 16:02:24.000000000 +0200
@@ -469,7 +469,11 @@ void b43_pio_handle_txstatus(struct b43_
 		if (!(packet->txstat.control.flags & IEEE80211_TXCTL_NO_ACK))
 			packet->txstat.excessive_retries = 1;
 	}
-	packet->txstat.retry_count = status->frame_count - 1;
+	if (status->frame_count == 0) {
+		/* The frame was not transmitted at all. */
+		packet->txstat.retry_count = 0;
+	} else
+		packet->txstat.retry_count = status->frame_count - 1;
 	ieee80211_tx_status_irqsafe(dev->wl->hw, packet->skb,
 				    &(packet->txstat));
 	packet->skb = NULL;

-- 

