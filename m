Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:47645 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612AbbA3Nc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:32:59 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgv-004FiR-Tk
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:32:58 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 14/17] ath9k: Move WOW registers to reg_wow.h
Date: Fri, 30 Jan 2015 19:05:34 +0530
Message-Id: <1422624937-4810-15-git-send-email-sujith@msujith.org> (sfid-20150130_143630_548429_3069B3F8)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_wow.c |   1 +
 drivers/net/wireless/ath/ath9k/reg.h        | 120 ------------------------
 drivers/net/wireless/ath/ath9k/reg_wow.h    | 136 ++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+), 120 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/reg_wow.h

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_wow.c b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
index bb61417..6681a7b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_wow.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
@@ -17,6 +17,7 @@
 #include <linux/export.h>
 #include "ath9k.h"
 #include "reg.h"
+#include "reg_wow.h"
 #include "hw-ops.h"
 
 static void ath9k_hw_set_powermode_wow_sleep(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 3c0b180..b1b803d 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -2010,126 +2010,6 @@ enum {
 
 #define AR_WOW_BEACON_TIMO_MAX		0xffffffff
 
-/*
- * MAC WoW Registers
- */
-
-#define AR_WOW_PATTERN			0x825C
-#define AR_WOW_COUNT			0x8260
-#define AR_WOW_BCN_EN			0x8270
-#define AR_WOW_BCN_TIMO			0x8274
-#define AR_WOW_KEEP_ALIVE_TIMO		0x8278
-#define AR_WOW_KEEP_ALIVE		0x827c
-#define AR_WOW_US_SCALAR		0x8284
-#define AR_WOW_KEEP_ALIVE_DELAY		0x8288
-#define AR_WOW_PATTERN_MATCH		0x828c
-#define AR_WOW_PATTERN_OFF1		0x8290	/* pattern bytes 0 -> 3 */
-#define AR_WOW_PATTERN_OFF2		0x8294	/* pattern bytes 4 -> 7 */
-
-/* for AR9285 or later version of chips */
-#define AR_WOW_EXACT			0x829c
-#define AR_WOW_LENGTH1			0x8360
-#define AR_WOW_LENGTH2			0X8364
-/* register to enable match for less than 256 bytes packets */
-#define AR_WOW_PATTERN_MATCH_LT_256B	0x8368
-
-#define AR_SW_WOW_CONTROL		0x20018
-#define AR_SW_WOW_ENABLE		0x1
-#define AR_SWITCH_TO_REFCLK		0x2
-#define AR_RESET_CONTROL		0x4
-#define AR_RESET_VALUE_MASK		0x8
-#define AR_HW_WOW_DISABLE		0x10
-#define AR_CLR_MAC_INTERRUPT		0x20
-#define AR_CLR_KA_INTERRUPT		0x40
-
-/* AR_WOW_PATTERN register values */
-#define AR_WOW_BACK_OFF_SHIFT(x)	((x & 0xf) << 28) /* in usecs */
-#define AR_WOW_MAC_INTR_EN		0x00040000
-#define AR_WOW_MAGIC_EN			0x00010000
-#define AR_WOW_PATTERN_EN(x)		(x & 0xff)
-#define AR_WOW_PAT_FOUND_SHIFT	8
-#define AR_WOW_PATTERN_FOUND(x)		(x & (0xff << AR_WOW_PAT_FOUND_SHIFT))
-#define AR_WOW_PATTERN_FOUND_MASK	((0xff) << AR_WOW_PAT_FOUND_SHIFT)
-#define AR_WOW_MAGIC_PAT_FOUND		0x00020000
-#define AR_WOW_MAC_INTR			0x00080000
-#define AR_WOW_KEEP_ALIVE_FAIL		0x00100000
-#define AR_WOW_BEACON_FAIL		0x00200000
-
-#define AR_WOW_STATUS(x)		(x & (AR_WOW_PATTERN_FOUND_MASK | \
-					      AR_WOW_MAGIC_PAT_FOUND	| \
-					      AR_WOW_KEEP_ALIVE_FAIL	| \
-					      AR_WOW_BEACON_FAIL))
-#define AR_WOW_CLEAR_EVENTS(x)		(x & ~(AR_WOW_PATTERN_EN(0xff) | \
-					       AR_WOW_MAGIC_EN | \
-					       AR_WOW_MAC_INTR_EN | \
-					       AR_WOW_BEACON_FAIL | \
-					       AR_WOW_KEEP_ALIVE_FAIL))
-
-/* AR_WOW_COUNT register values */
-#define AR_WOW_AIFS_CNT(x)		(x & 0xff)
-#define AR_WOW_SLOT_CNT(x)		((x & 0xff) << 8)
-#define AR_WOW_KEEP_ALIVE_CNT(x)	((x & 0xff) << 16)
-
-/* AR_WOW_BCN_EN register */
-#define AR_WOW_BEACON_FAIL_EN		0x00000001
-
-/* AR_WOW_BCN_TIMO rgister */
-#define AR_WOW_BEACON_TIMO		0x40000000 /* valid if BCN_EN is set */
-
-/* AR_WOW_KEEP_ALIVE_TIMO register */
-#define AR_WOW_KEEP_ALIVE_TIMO_VALUE
-#define AR_WOW_KEEP_ALIVE_NEVER		0xffffffff
-
-/* AR_WOW_KEEP_ALIVE register  */
-#define AR_WOW_KEEP_ALIVE_AUTO_DIS	0x00000001
-#define AR_WOW_KEEP_ALIVE_FAIL_DIS	0x00000002
-
-/* AR_WOW_KEEP_ALIVE_DELAY register */
-#define AR_WOW_KEEP_ALIVE_DELAY_VALUE	0x000003e8 /* 1 msec */
-
-
-/*
- * keep it long for beacon workaround - ensure no false alarm
- */
-#define AR_WOW_BMISSTHRESHOLD		0x20
-
-/* AR_WOW_PATTERN_MATCH register */
-#define AR_WOW_PAT_END_OF_PKT(x)	(x & 0xf)
-#define AR_WOW_PAT_OFF_MATCH(x)		((x & 0xf) << 8)
-
-/*
- * default values for Wow Configuration for backoff, aifs, slot, keep-alive
- * to be programmed into various registers.
- */
-#define AR_WOW_PAT_BACKOFF	0x00000004 /* AR_WOW_PATTERN_REG */
-#define AR_WOW_CNT_AIFS_CNT	0x00000022 /* AR_WOW_COUNT_REG */
-#define AR_WOW_CNT_SLOT_CNT	0x00000009 /* AR_WOW_COUNT_REG */
-/*
- * Keepalive count applicable for AR9280 2.0 and above.
- */
-#define AR_WOW_CNT_KA_CNT 0x00000008    /* AR_WOW_COUNT register */
-
-/* WoW - Transmit buffer for keep alive frames */
-#define AR_WOW_TRANSMIT_BUFFER	0xe000 /* E000 - EFFC */
-
-#define AR_WOW_TXBUF(i)		(AR_WOW_TRANSMIT_BUFFER + ((i) << 2))
-
-#define AR_WOW_KA_DESC_WORD2	0xe000
-
-#define AR_WOW_KA_DATA_WORD0	0xe030
-
-/* WoW Transmit Buffer for patterns */
-#define AR_WOW_TB_PATTERN(i)	(0xe100 + (i << 8))
-#define AR_WOW_TB_MASK(i)	(0xec00 + (i << 5))
-
-/* Currently Pattern 0-7 are supported - so bit 0-7 are set */
-#define AR_WOW_PATTERN_SUPPORTED	0xff
-#define AR_WOW_LENGTH_MAX		0xff
-#define AR_WOW_LEN1_SHIFT(_i)	((0x3 - ((_i) & 0x3)) << 0x3)
-#define AR_WOW_LENGTH1_MASK(_i)	(AR_WOW_LENGTH_MAX << AR_WOW_LEN1_SHIFT(_i))
-#define AR_WOW_LEN2_SHIFT(_i)	((0x7 - ((_i) & 0x7)) << 0x3)
-#define AR_WOW_LENGTH2_MASK(_i)	(AR_WOW_LENGTH_MAX << AR_WOW_LEN2_SHIFT(_i))
-
 #define AR9271_CORE_CLOCK	117   /* clock to 117Mhz */
 #define AR9271_TARGET_BAUD_RATE	19200 /* 115200 */
 
diff --git a/drivers/net/wireless/ath/ath9k/reg_wow.h b/drivers/net/wireless/ath/ath9k/reg_wow.h
new file mode 100644
index 0000000..3dbe5db
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/reg_wow.h
@@ -0,0 +1,136 @@
+/*
+ * Copyright (c) 2015 Qualcomm Atheros Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef REG_WOW_H
+#define REG_WOW_H
+
+#define AR_WOW_PATTERN                  0x825C
+#define AR_WOW_COUNT                    0x8260
+#define AR_WOW_BCN_EN                   0x8270
+#define AR_WOW_BCN_TIMO                 0x8274
+#define AR_WOW_KEEP_ALIVE_TIMO          0x8278
+#define AR_WOW_KEEP_ALIVE               0x827c
+#define AR_WOW_US_SCALAR                0x8284
+#define AR_WOW_KEEP_ALIVE_DELAY         0x8288
+#define AR_WOW_PATTERN_MATCH            0x828c
+#define AR_WOW_PATTERN_OFF1             0x8290  /* pattern bytes 0 -> 3 */
+#define AR_WOW_PATTERN_OFF2             0x8294  /* pattern bytes 4 -> 7 */
+
+/* for AR9285 or later version of chips */
+#define AR_WOW_EXACT                    0x829c
+#define AR_WOW_LENGTH1                  0x8360
+#define AR_WOW_LENGTH2                  0X8364
+/* register to enable match for less than 256 bytes packets */
+#define AR_WOW_PATTERN_MATCH_LT_256B    0x8368
+
+#define AR_SW_WOW_CONTROL               0x20018
+#define AR_SW_WOW_ENABLE                0x1
+#define AR_SWITCH_TO_REFCLK             0x2
+#define AR_RESET_CONTROL                0x4
+#define AR_RESET_VALUE_MASK             0x8
+#define AR_HW_WOW_DISABLE               0x10
+#define AR_CLR_MAC_INTERRUPT            0x20
+#define AR_CLR_KA_INTERRUPT             0x40
+
+/* AR_WOW_PATTERN register values */
+#define AR_WOW_BACK_OFF_SHIFT(x)        ((x & 0xf) << 28) /* in usecs */
+#define AR_WOW_MAC_INTR_EN              0x00040000
+#define AR_WOW_MAGIC_EN                 0x00010000
+#define AR_WOW_PATTERN_EN(x)            (x & 0xff)
+#define AR_WOW_PAT_FOUND_SHIFT  8
+#define AR_WOW_PATTERN_FOUND(x)         (x & (0xff << AR_WOW_PAT_FOUND_SHIFT))
+#define AR_WOW_PATTERN_FOUND_MASK       ((0xff) << AR_WOW_PAT_FOUND_SHIFT)
+#define AR_WOW_MAGIC_PAT_FOUND          0x00020000
+#define AR_WOW_MAC_INTR                 0x00080000
+#define AR_WOW_KEEP_ALIVE_FAIL          0x00100000
+#define AR_WOW_BEACON_FAIL              0x00200000
+
+#define AR_WOW_STATUS(x)                (x & (AR_WOW_PATTERN_FOUND_MASK | \
+                                              AR_WOW_MAGIC_PAT_FOUND    | \
+                                              AR_WOW_KEEP_ALIVE_FAIL    | \
+                                              AR_WOW_BEACON_FAIL))
+#define AR_WOW_CLEAR_EVENTS(x)          (x & ~(AR_WOW_PATTERN_EN(0xff) | \
+                                               AR_WOW_MAGIC_EN |	\
+                                               AR_WOW_MAC_INTR_EN |	\
+                                               AR_WOW_BEACON_FAIL |	\
+                                               AR_WOW_KEEP_ALIVE_FAIL))
+
+/* AR_WOW_COUNT register values */
+#define AR_WOW_AIFS_CNT(x)              (x & 0xff)
+#define AR_WOW_SLOT_CNT(x)              ((x & 0xff) << 8)
+#define AR_WOW_KEEP_ALIVE_CNT(x)        ((x & 0xff) << 16)
+
+/* AR_WOW_BCN_EN register */
+#define AR_WOW_BEACON_FAIL_EN           0x00000001
+
+/* AR_WOW_BCN_TIMO rgister */
+#define AR_WOW_BEACON_TIMO              0x40000000 /* valid if BCN_EN is set */
+
+/* AR_WOW_KEEP_ALIVE_TIMO register */
+#define AR_WOW_KEEP_ALIVE_TIMO_VALUE
+#define AR_WOW_KEEP_ALIVE_NEVER         0xffffffff
+
+/* AR_WOW_KEEP_ALIVE register  */
+#define AR_WOW_KEEP_ALIVE_AUTO_DIS      0x00000001
+#define AR_WOW_KEEP_ALIVE_FAIL_DIS      0x00000002
+
+/* AR_WOW_KEEP_ALIVE_DELAY register */
+#define AR_WOW_KEEP_ALIVE_DELAY_VALUE   0x000003e8 /* 1 msec */
+
+
+/*
+ * keep it long for beacon workaround - ensure no false alarm
+ */
+#define AR_WOW_BMISSTHRESHOLD           0x20
+
+/* AR_WOW_PATTERN_MATCH register */
+#define AR_WOW_PAT_END_OF_PKT(x)        (x & 0xf)
+#define AR_WOW_PAT_OFF_MATCH(x)         ((x & 0xf) << 8)
+
+/*
+ * default values for Wow Configuration for backoff, aifs, slot, keep-alive
+ * to be programmed into various registers.
+ */
+#define AR_WOW_PAT_BACKOFF      0x00000004 /* AR_WOW_PATTERN_REG */
+#define AR_WOW_CNT_AIFS_CNT     0x00000022 /* AR_WOW_COUNT_REG */
+#define AR_WOW_CNT_SLOT_CNT     0x00000009 /* AR_WOW_COUNT_REG */
+/*
+ * Keepalive count applicable for AR9280 2.0 and above.
+ */
+#define AR_WOW_CNT_KA_CNT 0x00000008    /* AR_WOW_COUNT register */
+
+/* WoW - Transmit buffer for keep alive frames */
+#define AR_WOW_TRANSMIT_BUFFER  0xe000 /* E000 - EFFC */
+
+#define AR_WOW_TXBUF(i)         (AR_WOW_TRANSMIT_BUFFER + ((i) << 2))
+
+#define AR_WOW_KA_DESC_WORD2    0xe000
+
+#define AR_WOW_KA_DATA_WORD0    0xe030
+
+/* WoW Transmit Buffer for patterns */
+#define AR_WOW_TB_PATTERN(i)    (0xe100 + (i << 8))
+#define AR_WOW_TB_MASK(i)       (0xec00 + (i << 5))
+
+/* Currently Pattern 0-7 are supported - so bit 0-7 are set */
+#define AR_WOW_PATTERN_SUPPORTED        0xff
+#define AR_WOW_LENGTH_MAX               0xff
+#define AR_WOW_LEN1_SHIFT(_i)   ((0x3 - ((_i) & 0x3)) << 0x3)
+#define AR_WOW_LENGTH1_MASK(_i) (AR_WOW_LENGTH_MAX << AR_WOW_LEN1_SHIFT(_i))
+#define AR_WOW_LEN2_SHIFT(_i)   ((0x7 - ((_i) & 0x7)) << 0x3)
+#define AR_WOW_LENGTH2_MASK(_i) (AR_WOW_LENGTH_MAX << AR_WOW_LEN2_SHIFT(_i))
+
+#endif /* REG_WOW_H */
-- 
2.2.2

