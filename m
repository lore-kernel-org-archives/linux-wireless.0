Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:41933 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3LXFTf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Dec 2013 00:19:35 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 07/11] ath9k: Identify baseband watchdog signatures
Date: Tue, 24 Dec 2013 10:44:23 +0530
Message-Id: <1387862067-25457-7-git-send-email-sujith@msujith.org> (sfid-20131224_062010_073506_441EAE38)
In-Reply-To: <1387862067-25457-1-git-send-email-sujith@msujith.org>
References: <1387862067-25457-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

A full HW reset is not required for all baseband watchdog
signatures. Some BB watchdog updates are benign and can
be discarded, some require re-programming of certain registers
and others require a chip reset.

This patch adds a routine to identify such signatures.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 62 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |  2 +
 drivers/net/wireless/ath/ath9k/hw.h         |  1 +
 3 files changed, 65 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index b020331..9b1494c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1814,6 +1814,68 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 	memcpy(ah->nf_regs, ar9300_cca_regs, sizeof(ah->nf_regs));
 }
 
+/*
+ * Baseband Watchdog signatures:
+ *
+ * 0x04000539: BB hang when operating in HT40 DFS Channel.
+ *             Full chip reset is not required, but a recovery
+ *             mechanism is needed.
+ *
+ * 0x1300000a: Related to CAC deafness.
+ *             Chip reset is not required.
+ *
+ * 0x0400000a: Related to CAC deafness.
+ *             Full chip reset is required.
+ *
+ * 0x04000b09: RX state machine gets into an illegal state
+ *             when a packet with unsupported rate is received.
+ *             Full chip reset is required and PHY_RESTART has
+ *             to be disabled.
+ *
+ * 0x04000409: Packet stuck on receive.
+ *             Full chip reset is required for all chips except AR9340.
+ */
+
+/*
+ * ar9003_hw_bb_watchdog_check(): Returns true if a chip reset is required.
+ */
+bool ar9003_hw_bb_watchdog_check(struct ath_hw *ah)
+{
+	u32 val;
+
+	switch(ah->bb_watchdog_last_status) {
+	case 0x04000539:
+		val = REG_READ(ah, AR_PHY_RADAR_0);
+		val &= (~AR_PHY_RADAR_0_FIRPWR);
+		val |= SM(0x7f, AR_PHY_RADAR_0_FIRPWR);
+		REG_WRITE(ah, AR_PHY_RADAR_0, val);
+		udelay(1);
+		val = REG_READ(ah, AR_PHY_RADAR_0);
+		val &= ~AR_PHY_RADAR_0_FIRPWR;
+		val |= SM(AR9300_DFS_FIRPWR, AR_PHY_RADAR_0_FIRPWR);
+		REG_WRITE(ah, AR_PHY_RADAR_0, val);
+
+		return false;
+	case 0x1300000a:
+		return false;
+	case 0x0400000a:
+	case 0x04000b09:
+		return true;
+	case 0x04000409:
+		if (AR_SREV_9340(ah))
+			return false;
+		else
+			return true;
+	default:
+		/*
+		 * For any other unknown signatures, do a
+		 * full chip reset.
+		 */
+		return true;
+	}
+}
+EXPORT_SYMBOL(ar9003_hw_bb_watchdog_check);
+
 void ar9003_hw_bb_watchdog_config(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 1b44171..94a8598 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -1334,4 +1334,6 @@
 #define AR_PHY_65NM_RXRF_AGC_AGC_OUT                   0x00000004
 #define AR_PHY_65NM_RXRF_AGC_AGC_OUT_S                 2
 
+#define AR9300_DFS_FIRPWR -28
+
 #endif  /* AR9003_PHY_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index cb930d6..7632509 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1044,6 +1044,7 @@ void ar9002_hw_enable_async_fifo(struct ath_hw *ah);
  * Code specific to AR9003, we stuff these here to avoid callbacks
  * for older families
  */
+bool ar9003_hw_bb_watchdog_check(struct ath_hw *ah);
 void ar9003_hw_bb_watchdog_config(struct ath_hw *ah);
 void ar9003_hw_bb_watchdog_read(struct ath_hw *ah);
 void ar9003_hw_bb_watchdog_dbg_info(struct ath_hw *ah);
-- 
1.8.5.2

