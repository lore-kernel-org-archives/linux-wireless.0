Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:4402 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758588Ab0EMLQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 07:16:42 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v3 04/10] rt2x00: Move rt2x00debug_dump_frame declaration to rt2x00.h.
Date: Thu, 13 May 2010 13:16:36 +0200
Message-Id: <1273749396-3199-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows rt2x00debug_dump_frame to be used from everywhere.

This is preparation for beacon writing clean ups.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---

v3: Handled Ivo's further comments.

---
 drivers/net/wireless/rt2x00/rt2x00.h      |   21 +++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00debug.c |    1 +
 drivers/net/wireless/rt2x00/rt2x00dump.h  |    7 ++++++-
 drivers/net/wireless/rt2x00/rt2x00lib.h   |   10 ----------
 4 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 6c1ff4c..c8e5fed 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -39,6 +39,7 @@
 #include <net/mac80211.h>
 
 #include "rt2x00debug.h"
+#include "rt2x00dump.h"
 #include "rt2x00leds.h"
 #include "rt2x00reg.h"
 #include "rt2x00queue.h"
@@ -1015,6 +1016,26 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 					  enum queue_index index);
 
 /*
+ * Debugfs handlers.
+ */
+/**
+ * rt2x00debug_dump_frame - Dump a frame to userspace through debugfs.
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @type: The type of frame that is being dumped.
+ * @skb: The skb containing the frame to be dumped.
+ */
+#ifdef CONFIG_RT2X00_LIB_DEBUGFS
+void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
+			    enum rt2x00_dump_type type, struct sk_buff *skb);
+#else
+static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
+					  enum rt2x00_dump_type type,
+					  struct sk_buff *skb)
+{
+}
+#endif /* CONFIG_RT2X00_LIB_DEBUGFS */
+
+/*
  * Interrupt context handlers.
  */
 void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 1e81eef..9dd8b7c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -210,6 +210,7 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 	if (!test_bit(FRAME_DUMP_FILE_OPEN, &intf->frame_dump_flags))
 		skb_queue_purge(&intf->frame_dump_skbqueue);
 }
+EXPORT_SYMBOL_GPL(rt2x00debug_dump_frame);
 
 static int rt2x00debug_file_open(struct inode *inode, struct file *file)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00dump.h b/drivers/net/wireless/rt2x00/rt2x00dump.h
index ed303b4..8fd342c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dump.h
+++ b/drivers/net/wireless/rt2x00/rt2x00dump.h
@@ -20,7 +20,12 @@
 
 /*
 	Module: rt2x00dump
-	Abstract: Data structures for the rt2x00debug & userspace.
+	Abstract:
+		Data structures for the rt2x00debug & userspace.
+		
+		The declarations in this file can be used by both rt2x00
+		and userspace and therefore should be kept together in
+		this file.
  */
 
 #ifndef RT2X00DUMP_H
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index be2e37f..0ca40e1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -27,8 +27,6 @@
 #ifndef RT2X00LIB_H
 #define RT2X00LIB_H
 
-#include "rt2x00dump.h"
-
 /*
  * Interval defines
  */
@@ -296,8 +294,6 @@ static inline void rt2x00lib_free_firmware(struct rt2x00_dev *rt2x00dev)
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 void rt2x00debug_register(struct rt2x00_dev *rt2x00dev);
 void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev);
-void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
-			    enum rt2x00_dump_type type, struct sk_buff *skb);
 void rt2x00debug_update_crypto(struct rt2x00_dev *rt2x00dev,
 			       struct rxdone_entry_desc *rxdesc);
 #else
@@ -309,12 +305,6 @@ static inline void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
 {
 }
 
-static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
-					  enum rt2x00_dump_type type,
-					  struct sk_buff *skb)
-{
-}
-
 static inline void rt2x00debug_update_crypto(struct rt2x00_dev *rt2x00dev,
 					     struct rxdone_entry_desc *rxdesc)
 {
-- 
1.7.1

