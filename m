Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:54673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbYEJMKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:10:00 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1148254fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:09:59 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 06/16] rt2x00: trim skb_frame_desc to 32 bytes
Date: Sat, 10 May 2008 13:41:32 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101337.14536.IvDoorn@gmail.com>
In-Reply-To: <200805101337.14536.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805101341.32249.IvDoorn@gmail.com> (sfid-20080510_141016_975869_41B2DAA8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 1ec45cd3c479caeee822e02fc4f15c13f9143139 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Thu, 8 May 2008 23:10:31 +0200
Subject: [PATCH] rt2x00: trim skb_frame_desc to 32 bytes

Remove frame_type from skb_frame_desc and pass it
as argument to rt2x00debug_dump_frame().

Change data_len and desc_len to unsigned short
to save another 4 bytes in skb_frame_desc. Note that
this was the only location where the data_len and
desc_len was not yet treated as unsigned short.

This trim is required to help mac80211 with adding
the TX control and TX status informtation into the
skb->cb structure. When that happens, drivers will
have approximately 40 bytes left to use freely.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   13 ++++---------
 drivers/net/wireless/rt2x00/rt2x00lib.h   |    6 +++++-
 drivers/net/wireless/rt2x00/rt2x00queue.h |    7 ++-----
 4 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index bfab3b8..bd92cb8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -115,7 +115,7 @@ struct rt2x00debug_intf {
 };
 
 void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
-			    struct sk_buff *skb)
+			    enum rt2x00_dump_type type, struct sk_buff *skb)
 {
 	struct rt2x00debug_intf *intf = rt2x00dev->debugfs_intf;
 	struct skb_frame_desc *desc = get_skb_frame_desc(skb);
@@ -148,7 +148,7 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 	dump_hdr->chip_rt = cpu_to_le16(rt2x00dev->chip.rt);
 	dump_hdr->chip_rf = cpu_to_le16(rt2x00dev->chip.rf);
 	dump_hdr->chip_rev = cpu_to_le32(rt2x00dev->chip.rev);
-	dump_hdr->type = cpu_to_le16(desc->frame_type);
+	dump_hdr->type = cpu_to_le16(type);
 	dump_hdr->queue_index = desc->entry->queue->qid;
 	dump_hdr->entry_index = desc->entry->entry_idx;
 	dump_hdr->timestamp_sec = cpu_to_le32(timestamp.tv_sec);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 61510c5..1e7fefd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -28,7 +28,6 @@
 
 #include "rt2x00.h"
 #include "rt2x00lib.h"
-#include "rt2x00dump.h"
 
 /*
  * Link tuning handlers
@@ -540,11 +539,9 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	 * If send to mac80211, mac80211 will clean up the skb structure,
 	 * otherwise we have to do it ourself.
 	 */
-	skbdesc = get_skb_frame_desc(entry->skb);
-	skbdesc->frame_type = DUMP_FRAME_TXDONE;
-
-	rt2x00debug_dump_frame(rt2x00dev, entry->skb);
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TXDONE, entry->skb);
 
+	skbdesc = get_skb_frame_desc(entry->skb);
 	if (!(skbdesc->flags & FRAME_DESC_DRIVER_GENERATED))
 		ieee80211_tx_status_irqsafe(rt2x00dev->hw,
 					    entry->skb, &tx_status);
@@ -610,8 +607,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 	 * Send frame to mac80211 & debugfs.
 	 * mac80211 will clean up the skb structure.
 	 */
-	get_skb_frame_desc(entry->skb)->frame_type = DUMP_FRAME_RXDONE;
-	rt2x00debug_dump_frame(rt2x00dev, entry->skb);
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_RXDONE, entry->skb);
 	ieee80211_rx_irqsafe(rt2x00dev->hw, entry->skb, rx_status);
 	entry->skb = NULL;
 }
@@ -752,8 +748,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 * frame to the device, but we are going to push the
 	 * frame to debugfs here.
 	 */
-	skbdesc->frame_type = DUMP_FRAME_TX;
-	rt2x00debug_dump_frame(rt2x00dev, skb);
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TX, skb);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_write_tx_desc);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 41ee02c..c4ce534 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -26,6 +26,8 @@
 #ifndef RT2X00LIB_H
 #define RT2X00LIB_H
 
+#include "rt2x00dump.h"
+
 /*
  * Interval defines
  * Both the link tuner as the rfkill will be called once per second.
@@ -128,7 +130,8 @@ static inline void rt2x00lib_free_firmware(struct rt2x00_dev *rt2x00dev)
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 void rt2x00debug_register(struct rt2x00_dev *rt2x00dev);
 void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev);
-void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
+void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
+			    enum rt2x00_dump_type type, struct sk_buff *skb);
 #else
 static inline void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 {
@@ -139,6 +142,7 @@ static inline void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
 }
 
 static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
+					  enum rt2x00_dump_type type,
 					  struct sk_buff *skb)
 {
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index d1707a7..c3493ed 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -109,7 +109,6 @@ enum skb_frame_desc_flags {
  * this structure should not exceed the size of that array (48 bytes).
  *
  * @flags: Frame flags, see &enum skb_frame_desc_flags.
- * @frame_type: Frame type, see &enum rt2x00_dump_type.
  * @data: Pointer to data part of frame (Start of ieee80211 header).
  * @desc: Pointer to descriptor part of the frame.
  *	Note that this pointer could point to something outside
@@ -121,14 +120,12 @@ enum skb_frame_desc_flags {
 struct skb_frame_desc {
 	unsigned int flags;
 
-	unsigned int frame_type;
+	unsigned short data_len;
+	unsigned short desc_len;
 
 	void *data;
 	void *desc;
 
-	unsigned int data_len;
-	unsigned int desc_len;
-
 	struct queue_entry *entry;
 };
 
-- 
1.5.5.1

