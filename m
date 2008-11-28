Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65084 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbYK1QyL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 11:54:11 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2008 08:54:11 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18736.8572.148719.831988@gargle.gargle.HOWL> (sfid-20081128_175415_822165_F8643566)
Date: Fri, 28 Nov 2008 22:21:08 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 5/5] ath9k: Add a debugfs file for dumping DMA status
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Debugfs file location: ath9k/<wiphy>/dma
Contains values in DMA debug registers.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |    1 -
 drivers/net/wireless/ath9k/beacon.c |    1 -
 drivers/net/wireless/ath9k/core.h   |    1 +
 drivers/net/wireless/ath9k/debug.c  |  100 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/mac.c    |   72 -------------------------
 drivers/net/wireless/ath9k/main.c   |    1 +
 6 files changed, 102 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 5b9bc54..9eaa3fc 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -1009,7 +1009,6 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints);
 
 /* MAC (PCU/QCU) */
 
-void ath9k_hw_dmaRegDump(struct ath_hal *ah);
 u32 ath9k_hw_gettxbuf(struct ath_hal *ah, u32 q);
 bool ath9k_hw_puttxbuf(struct ath_hal *ah, u32 q, u32 txdp);
 bool ath9k_hw_txstart(struct ath_hal *ah, u32 q);
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 88fbfe5..ca5782f 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -492,7 +492,6 @@ void ath9k_beacon_tasklet(unsigned long data)
 					DPRINTF(sc, ATH_DBG_BEACON,
 						"beacon is officially "
 						"stuck\n");
-					ath9k_hw_dmaRegDump(ah);
 				}
 			} else {
 				DPRINTF(sc, ATH_DBG_BEACON,
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 5b75558..8c11c0f 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -92,6 +92,7 @@ struct ath9k_debug {
 	int debug_mask;
 	struct dentry *debugfs_root;
 	struct dentry *debugfs_phy;
+	struct dentry *debugfs_dma;
 };
 
 void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...);
diff --git a/drivers/net/wireless/ath9k/debug.c b/drivers/net/wireless/ath9k/debug.c
index c146e48..da52812 100644
--- a/drivers/net/wireless/ath9k/debug.c
+++ b/drivers/net/wireless/ath9k/debug.c
@@ -15,6 +15,8 @@
  */
 
 #include "core.h"
+#include "reg.h"
+#include "hw.h"
 
 static unsigned int ath9k_debug = DBG_DEFAULT;
 module_param_named(debug, ath9k_debug, uint, 0);
@@ -34,6 +36,98 @@ void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...)
 	}
 }
 
+static int ath9k_debugfs_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t read_file_dma(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_hal *ah = sc->sc_ah;
+	char buf[1024];
+	unsigned int len = 0;
+	u32 val[ATH9K_NUM_DMA_DEBUG_REGS];
+	int i, qcuOffset = 0, dcuOffset = 0;
+	u32 *qcuBase = &val[0], *dcuBase = &val[4];
+
+	REG_WRITE(ah, AR_MACMISC,
+		  ((AR_MACMISC_DMA_OBS_LINE_8 << AR_MACMISC_DMA_OBS_S) |
+		   (AR_MACMISC_MISC_OBS_BUS_1 <<
+		    AR_MACMISC_MISC_OBS_BUS_MSB_S)));
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"Raw DMA Debug values:\n");
+
+	for (i = 0; i < ATH9K_NUM_DMA_DEBUG_REGS; i++) {
+		if (i % 4 == 0)
+			len += snprintf(buf + len, sizeof(buf) - len, "\n");
+
+		val[i] = REG_READ(ah, AR_DMADBG_0 + (i * sizeof(u32)));
+		len += snprintf(buf + len, sizeof(buf) - len, "%d: %08x ",
+				i, val[i]);
+	}
+
+	len += snprintf(buf + len, sizeof(buf) - len, "\n\n");
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"Num QCU: chain_st fsp_ok fsp_st DCU: chain_st\n");
+
+	for (i = 0; i < ATH9K_NUM_QUEUES; i++, qcuOffset += 4, dcuOffset += 5) {
+		if (i == 8) {
+			qcuOffset = 0;
+			qcuBase++;
+		}
+
+		if (i == 6) {
+			dcuOffset = 0;
+			dcuBase++;
+		}
+
+		len += snprintf(buf + len, sizeof(buf) - len,
+			"%2d          %2x      %1x     %2x           %2x\n",
+			i, (*qcuBase & (0x7 << qcuOffset)) >> qcuOffset,
+			(*qcuBase & (0x8 << qcuOffset)) >> (qcuOffset + 3),
+			val[2] & (0x7 << (i * 3)) >> (i * 3),
+			(*dcuBase & (0x1f << dcuOffset)) >> dcuOffset);
+	}
+
+	len += snprintf(buf + len, sizeof(buf) - len, "\n");
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"qcu_stitch state:   %2x    qcu_fetch state:        %2x\n",
+		(val[3] & 0x003c0000) >> 18, (val[3] & 0x03c00000) >> 22);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"qcu_complete state: %2x    dcu_complete state:     %2x\n",
+		(val[3] & 0x1c000000) >> 26, (val[6] & 0x3));
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"dcu_arb state:      %2x    dcu_fp state:           %2x\n",
+		(val[5] & 0x06000000) >> 25, (val[5] & 0x38000000) >> 27);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"chan_idle_dur:     %3d    chan_idle_dur_valid:     %1d\n",
+		(val[6] & 0x000003fc) >> 2, (val[6] & 0x00000400) >> 10);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"txfifo_valid_0:      %1d    txfifo_valid_1:          %1d\n",
+		(val[6] & 0x00000800) >> 11, (val[6] & 0x00001000) >> 12);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"txfifo_dcu_num_0:   %2d    txfifo_dcu_num_1:       %2d\n",
+		(val[6] & 0x0001e000) >> 13, (val[6] & 0x001e0000) >> 17);
+
+	len += snprintf(buf + len, sizeof(buf) - len, "pcu observe: 0x%x \n",
+			REG_READ(ah, AR_OBS_BUS_1));
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"AR_CR: 0x%x \n", REG_READ(ah, AR_CR));
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_dma = {
+	.read = read_file_dma,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE
+};
+
 int ath9k_init_debug(struct ath_softc *sc)
 {
 	sc->sc_debug.debug_mask = ath9k_debug;
@@ -47,6 +141,11 @@ int ath9k_init_debug(struct ath_softc *sc)
 	if (!sc->sc_debug.debugfs_phy)
 		goto err;
 
+	sc->sc_debug.debugfs_dma = debugfs_create_file("dma", S_IRUGO,
+				       sc->sc_debug.debugfs_phy, sc, &fops_dma);
+	if (!sc->sc_debug.debugfs_dma)
+		goto err;
+
 	return 0;
 err:
 	ath9k_exit_debug(sc);
@@ -55,6 +154,7 @@ err:
 
 void ath9k_exit_debug(struct ath_softc *sc)
 {
+	debugfs_remove(sc->sc_debug.debugfs_dma);
 	debugfs_remove(sc->sc_debug.debugfs_phy);
 	debugfs_remove(sc->sc_debug.debugfs_root);
 }
diff --git a/drivers/net/wireless/ath9k/mac.c b/drivers/net/wireless/ath9k/mac.c
index 8d2b139..a4e9898 100644
--- a/drivers/net/wireless/ath9k/mac.c
+++ b/drivers/net/wireless/ath9k/mac.c
@@ -40,78 +40,6 @@ static void ath9k_hw_set_txq_interrupts(struct ath_hal *ah,
 		      AR_IMR_S2_QCU_TXURN, ahp->ah_txUrnInterruptMask);
 }
 
-void ath9k_hw_dmaRegDump(struct ath_hal *ah)
-{
-	u32 val[ATH9K_NUM_DMA_DEBUG_REGS];
-	int qcuOffset = 0, dcuOffset = 0;
-	u32 *qcuBase = &val[0], *dcuBase = &val[4];
-	int i;
-
-	REG_WRITE(ah, AR_MACMISC,
-		  ((AR_MACMISC_DMA_OBS_LINE_8 << AR_MACMISC_DMA_OBS_S) |
-		   (AR_MACMISC_MISC_OBS_BUS_1 <<
-		    AR_MACMISC_MISC_OBS_BUS_MSB_S)));
-
-	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO, "Raw DMA Debug values:\n");
-
-	for (i = 0; i < ATH9K_NUM_DMA_DEBUG_REGS; i++) {
-		if (i % 4 == 0)
-			DPRINTF(ah->ah_sc, ATH_DBG_REG_IO, "\n");
-
-		val[i] = REG_READ(ah, AR_DMADBG_0 + (i * sizeof(u32)));
-		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO, "%d: %08x ", i, val[i]);
-	}
-
-	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO, "\n\n");
-	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-		"Num QCU: chain_st fsp_ok fsp_st DCU: chain_st\n");
-
-	for (i = 0; i < ATH9K_NUM_QUEUES;
-	     i++, qcuOffset += 4, dcuOffset += 5) {
-		if (i == 8) {
-			qcuOffset = 0;
-			qcuBase++;
-		}
-
-		if (i == 6) {
-			dcuOffset = 0;
-			dcuBase++;
-		}
-
-		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-			"%2d          %2x      %1x     %2x           %2x\n",
-			i, (*qcuBase & (0x7 << qcuOffset)) >> qcuOffset,
-			(*qcuBase & (0x8 << qcuOffset)) >> (qcuOffset + 3),
-			val[2] & (0x7 << (i * 3)) >> (i * 3),
-			(*dcuBase & (0x1f << dcuOffset)) >> dcuOffset);
-	}
-
-	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO, "\n");
-	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-		"qcu_stitch state:   %2x    qcu_fetch state:        %2x\n",
-		(val[3] & 0x003c0000) >> 18, (val[3] & 0x03c00000) >> 22);
-	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-		"qcu_complete state: %2x    dcu_complete state:     %2x\n",
-		(val[3] & 0x1c000000) >> 26, (val[6] & 0x3));
-	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-		"dcu_arb state:      %2x    dcu_fp state:           %2x\n",
-		(val[5] & 0x06000000) >> 25, (val[5] & 0x38000000) >> 27);
-	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-		"chan_idle_dur:     %3d    chan_idle_dur_valid:     %1d\n",
-		(val[6] & 0x000003fc) >> 2, (val[6] & 0x00000400) >> 10);
-	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-		"txfifo_valid_0:      %1d    txfifo_valid_1:          %1d\n",
-		(val[6] & 0x00000800) >> 11, (val[6] & 0x00001000) >> 12);
-	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-		"txfifo_dcu_num_0:   %2d    txfifo_dcu_num_1:       %2d\n",
-		(val[6] & 0x0001e000) >> 13, (val[6] & 0x001e0000) >> 17);
-
-	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO, "pcu observe 0x%x \n",
-		REG_READ(ah, AR_OBS_BUS_1));
-	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-		"AR_CR 0x%x \n", REG_READ(ah, AR_CR));
-}
-
 u32 ath9k_hw_gettxbuf(struct ath_hal *ah, u32 q)
 {
 	return REG_READ(ah, AR_QTXDP(q));
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index aca7848..c590e9d 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -17,6 +17,7 @@
 #include <linux/nl80211.h>
 #include "core.h"
 #include "reg.h"
+#include "hw.h"
 
 #define ATH_PCI_VERSION "0.1"
 
-- 
1.6.0.3

