Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53877 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612AbbA3NdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:33:02 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgy-004FiR-TJ
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:33:01 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 16/17] ath9k: Cleanup reg_wow.h
Date: Fri, 30 Jan 2015 19:05:36 +0530
Message-Id: <1422624937-4810-17-git-send-email-sujith@msujith.org> (sfid-20150130_143630_074785_DF68BE02)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

* Remove unnecessary comments.
* Remove unused macros.
* Indent the macros.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/reg_wow.h | 68 +++++++-------------------------
 1 file changed, 15 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg_wow.h b/drivers/net/wireless/ath/ath9k/reg_wow.h
index 780553a..e6de4a3 100644
--- a/drivers/net/wireless/ath/ath9k/reg_wow.h
+++ b/drivers/net/wireless/ath/ath9k/reg_wow.h
@@ -25,10 +25,8 @@
 #define AR_WOW_KEEP_ALIVE               0x827c
 #define AR_WOW_KEEP_ALIVE_DELAY         0x8288
 #define AR_WOW_PATTERN_MATCH            0x828c
-
 #define AR_WOW_LENGTH1                  0x8360
 #define AR_WOW_LENGTH2                  0X8364
-/* register to enable match for less than 256 bytes packets */
 #define AR_WOW_PATTERN_MATCH_LT_256B    0x8368
 
 #define AR_SW_WOW_CONTROL               0x20018
@@ -40,7 +38,6 @@
 #define AR_CLR_MAC_INTERRUPT            0x20
 #define AR_CLR_KA_INTERRUPT             0x40
 
-/* AR_WOW_PATTERN register values */
 #define AR_WOW_BACK_OFF_SHIFT(x)        ((x & 0xf) << 28) /* in usecs */
 #define AR_WOW_MAC_INTR_EN              0x00040000
 #define AR_WOW_MAGIC_EN                 0x00010000
@@ -63,69 +60,34 @@
                                                AR_WOW_BEACON_FAIL |	\
                                                AR_WOW_KEEP_ALIVE_FAIL))
 
-/* AR_WOW_COUNT register values */
 #define AR_WOW_AIFS_CNT(x)              (x & 0xff)
 #define AR_WOW_SLOT_CNT(x)              ((x & 0xff) << 8)
 #define AR_WOW_KEEP_ALIVE_CNT(x)        ((x & 0xff) << 16)
 
-/* AR_WOW_BCN_EN register */
 #define AR_WOW_BEACON_FAIL_EN           0x00000001
-
-/* AR_WOW_BCN_TIMO rgister */
-#define AR_WOW_BEACON_TIMO              0x40000000 /* valid if BCN_EN is set */
-
-/* AR_WOW_KEEP_ALIVE_TIMO register */
-#define AR_WOW_KEEP_ALIVE_TIMO_VALUE
+#define AR_WOW_BEACON_TIMO              0x40000000
 #define AR_WOW_KEEP_ALIVE_NEVER         0xffffffff
-
-/* AR_WOW_KEEP_ALIVE register  */
 #define AR_WOW_KEEP_ALIVE_AUTO_DIS      0x00000001
 #define AR_WOW_KEEP_ALIVE_FAIL_DIS      0x00000002
-
-/* AR_WOW_KEEP_ALIVE_DELAY register */
 #define AR_WOW_KEEP_ALIVE_DELAY_VALUE   0x000003e8 /* 1 msec */
-
-
-/*
- * keep it long for beacon workaround - ensure no false alarm
- */
 #define AR_WOW_BMISSTHRESHOLD           0x20
-
-/* AR_WOW_PATTERN_MATCH register */
 #define AR_WOW_PAT_END_OF_PKT(x)        (x & 0xf)
 #define AR_WOW_PAT_OFF_MATCH(x)         ((x & 0xf) << 8)
-
-/*
- * default values for Wow Configuration for backoff, aifs, slot, keep-alive
- * to be programmed into various registers.
- */
-#define AR_WOW_PAT_BACKOFF      0x00000004 /* AR_WOW_PATTERN_REG */
-#define AR_WOW_CNT_AIFS_CNT     0x00000022 /* AR_WOW_COUNT_REG */
-#define AR_WOW_CNT_SLOT_CNT     0x00000009 /* AR_WOW_COUNT_REG */
-/*
- * Keepalive count applicable for AR9280 2.0 and above.
- */
-#define AR_WOW_CNT_KA_CNT 0x00000008    /* AR_WOW_COUNT register */
-
-/* WoW - Transmit buffer for keep alive frames */
-#define AR_WOW_TRANSMIT_BUFFER  0xe000 /* E000 - EFFC */
-
-#define AR_WOW_TXBUF(i)         (AR_WOW_TRANSMIT_BUFFER + ((i) << 2))
-
-#define AR_WOW_KA_DESC_WORD2    0xe000
-
-#define AR_WOW_KA_DATA_WORD0    0xe030
-
-/* WoW Transmit Buffer for patterns */
-#define AR_WOW_TB_PATTERN(i)    (0xe100 + (i << 8))
-#define AR_WOW_TB_MASK(i)       (0xec00 + (i << 5))
-
-/* Currently Pattern 0-7 are supported - so bit 0-7 are set */
+#define AR_WOW_PAT_BACKOFF              0x00000004
+#define AR_WOW_CNT_AIFS_CNT             0x00000022
+#define AR_WOW_CNT_SLOT_CNT             0x00000009
+#define AR_WOW_CNT_KA_CNT               0x00000008
+
+#define AR_WOW_TRANSMIT_BUFFER          0xe000
+#define AR_WOW_TXBUF(i)                 (AR_WOW_TRANSMIT_BUFFER + ((i) << 2))
+#define AR_WOW_KA_DESC_WORD2            0xe000
+#define AR_WOW_TB_PATTERN(i)            (0xe100 + (i << 8))
+#define AR_WOW_TB_MASK(i)               (0xec00 + (i << 5))
 #define AR_WOW_PATTERN_SUPPORTED        0xff
 #define AR_WOW_LENGTH_MAX               0xff
-#define AR_WOW_LEN1_SHIFT(_i)   ((0x3 - ((_i) & 0x3)) << 0x3)
-#define AR_WOW_LENGTH1_MASK(_i) (AR_WOW_LENGTH_MAX << AR_WOW_LEN1_SHIFT(_i))
-#define AR_WOW_LEN2_SHIFT(_i)   ((0x7 - ((_i) & 0x7)) << 0x3)
-#define AR_WOW_LENGTH2_MASK(_i) (AR_WOW_LENGTH_MAX << AR_WOW_LEN2_SHIFT(_i))
+#define AR_WOW_LEN1_SHIFT(_i)           ((0x3 - ((_i) & 0x3)) << 0x3)
+#define AR_WOW_LENGTH1_MASK(_i)         (AR_WOW_LENGTH_MAX << AR_WOW_LEN1_SHIFT(_i))
+#define AR_WOW_LEN2_SHIFT(_i)           ((0x7 - ((_i) & 0x7)) << 0x3)
+#define AR_WOW_LENGTH2_MASK(_i)         (AR_WOW_LENGTH_MAX << AR_WOW_LEN2_SHIFT(_i))
 
 #endif /* REG_WOW_H */
-- 
2.2.2

