Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:1077 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757020Ab0EMJhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 05:37:04 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2 04/10] rt2x00: Move rt2x00debug_dump_frame declaration to rt2x00.h.
Date: Thu, 13 May 2010 11:36:52 +0200
Message-Id: <1273743418-28383-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>
References: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows rt2x00debug_dump_frame to be used from everywhere.

This is preparation for beacon writing clean ups.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |   35 +++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00debug.c |    1 +
 drivers/net/wireless/rt2x00/rt2x00dump.h  |   20 ----------------
 drivers/net/wireless/rt2x00/rt2x00lib.h   |   10 --------
 4 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 6c1ff4c..1329f6c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1015,6 +1015,41 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 					  enum queue_index index);
 
 /*
+ * Debugfs handlers.
+ */
+/**
+ * enum rt2x00_dump_type - Frame type
+ *
+ * These values are used for the indicate the type of frame that is being
+ * dumped:
+ * @DUMP_FRAME_RXDONE: This frame has been received by the hardware.
+ * @DUMP_FRAME_TX: This frame is queued for transmission to the hardware.
+ * @DUMP_FRAME_TXDONE: This frame indicates the device has handled
+ *	the tx event which has either succeeded or failed. A frame
+ *	with this type should also have been reported with as a
+ *	%DUMP_FRAME_TX frame.
+ * @DUMP_FRAME_BEACON: This beacon frame is queued for transmission to the
+ *	hardware.
+ */
+enum rt2x00_dump_type {
+	DUMP_FRAME_RXDONE = 1,
+	DUMP_FRAME_TX = 2,
+	DUMP_FRAME_TXDONE = 3,
+	DUMP_FRAME_BEACON = 4,
+};
+
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
index ed303b4..e803342 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dump.h
+++ b/drivers/net/wireless/rt2x00/rt2x00dump.h
@@ -53,26 +53,6 @@
  */
 
 /**
- * enum rt2x00_dump_type - Frame type
- *
- * These values are used for the @type member of &rt2x00dump_hdr.
- * @DUMP_FRAME_RXDONE: This frame has been received by the hardware.
- * @DUMP_FRAME_TX: This frame is queued for transmission to the hardware.
- * @DUMP_FRAME_TXDONE: This frame indicates the device has handled
- *	the tx event which has either succeeded or failed. A frame
- *	with this type should also have been reported with as a
- *	%DUMP_FRAME_TX frame.
- * @DUMP_FRAME_BEACON: This beacon frame is queued for transmission to the
- *	hardware.
- */
-enum rt2x00_dump_type {
-	DUMP_FRAME_RXDONE = 1,
-	DUMP_FRAME_TX = 2,
-	DUMP_FRAME_TXDONE = 3,
-	DUMP_FRAME_BEACON = 4,
-};
-
-/**
  * struct rt2x00dump_hdr - Dump frame header
  *
  * Each frame dumped to the debugfs file starts with this header
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

