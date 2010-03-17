Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41117 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab0CQW2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 18:28:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 15/20] ath9k_hw: provide a helper for clearing the MIB counters
Date: Wed, 17 Mar 2010 18:28:08 -0400
Message-Id: <1268864893-11428-16-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
References: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MIB counters are cleared in a few places. Put that code into
a helper so that each chipset supported can implement its own call
later and we can share more code. While at it adds documentation for
the MIB cycle counters and the sleep cycle counters.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c |   64 +++++++++++++++++++++++++++++----
 1 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 02db5c5..a4e492d 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -781,6 +781,58 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 }
 EXPORT_SYMBOL(ath9k_hw_ani_monitor);
 
+
+/**
+ * ath9k_hw_clear_mib_counters - clears all MIB counters
+ *
+ * @ah: atheros hardware structure
+ *
+ * Used to clear all MIB counters for the OFDM and CCK filtered
+ * frames and also the clock cycle counters and clock cycles we
+ * have spent sleeping. Refer to ath9k_hw_update_phy_err_count()
+ * for more documentation on the filtered frames, below we cover
+ * the clock cycle counters and sleep cycle counters.
+ *
+ * 0x8250           32KHz Sleep MIB Count
+ * (Int Addr: 0x94, Access, R/W, cold_reset, Clock: clk)
+ *       SLPMIB1                 31:0    'h0     bit 31:0   SLPMIB_SLEEP_CNT
+ *
+ * 0x8254           32KHz Cycle MIB Count
+ *        (Int Addr: 0x95, Access, R/W, cold_reset, Clock: clk)
+ *        SLPMIB2                 31:0    'h0     bit 31:0   SLPMIB_CYCLE_CNT
+ *
+ * 0x8258           32KHz Mode MIB Control Status
+ *        (Int Addr: 0x96, Access, R/W, cold_reset, Clock: clk)
+ *        SLPMIB3                  1:0    'h0     bit 0      SLPMIB_CLR_CNT
+ *                                        'h0    bit 1      SLPMIB_PEND
+ *
+ * The SLPMIB_SLEEP_CNT counts the number of 32KHz clock cycles that
+ * the MAC has been asleep.  The SLPMIB_CYCLE_CNT is the counts the
+ * absolute number of 32KHz clock cycles.  When the SLPMIB_CYCLE_CNT
+ * bit 31 is 1, the sleep MIB interrupt will be asserted.  The
+ * SLPMIB_SLEEP_CNT and SLPMIB_CYCLE_CNT are saturating counters when
+ * the value of SLPMIB_CYCLE_CNT reaches 0xFFFF_FFFF both counters
+ * will stop incrementing.  The SLPMIB_CLR_CNT will clear both the
+ * SLPMIB_SLEEP_CNT and SLPMIB_CYCLE_CNT.  During the time that the
+ * clearing of these register are pending the SLPMIB_CLR_PEND will
+ * be asserted.  SLPMIB_SLEEP_CNT, SLPMIB_CYCLE_CNT, and
+ * SLPMIB_CLR_CNT are writable for diagnostic purposes.  Before every
+ * read/write, the SLPMIB_PEND bit should be polled to verify any
+ * pending write has cleared.
+ */
+static void ath9k_hw_clear_mib_counters(struct ath_hw *ah,
+					bool check_clock_cycles)
+{
+	REG_WRITE(ah, AR_FILT_OFDM, 0);
+	REG_WRITE(ah, AR_FILT_CCK, 0);
+
+	if (!check_clock_cycles)
+		return;
+
+	if (!(REG_READ(ah, AR_SLP_MIB_CTRL) & AR_SLP_MIB_PENDING))
+		REG_WRITE(ah, AR_SLP_MIB_CTRL, AR_SLP_MIB_CLEAR);
+}
+
 void ath9k_enable_mib_counters(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -788,9 +840,8 @@ void ath9k_enable_mib_counters(struct ath_hw *ah)
 	ath_print(common, ATH_DBG_ANI, "Enable MIB counters\n");
 
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
+	ath9k_hw_clear_mib_counters(ah, false);
 
-	REG_WRITE(ah, AR_FILT_OFDM, 0);
-	REG_WRITE(ah, AR_FILT_CCK, 0);
 	REG_WRITE(ah, AR_MIBC,
 		  ~(AR_MIBC_COW | AR_MIBC_FMC | AR_MIBC_CMC | AR_MIBC_MCS)
 		  & 0x0f);
@@ -807,8 +858,8 @@ void ath9k_hw_disable_mib_counters(struct ath_hw *ah)
 	REG_WRITE(ah, AR_MIBC, AR_MIBC_FMC);
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 	REG_WRITE(ah, AR_MIBC, AR_MIBC_CMC);
-	REG_WRITE(ah, AR_FILT_OFDM, 0);
-	REG_WRITE(ah, AR_FILT_CCK, 0);
+
+	ath9k_hw_clear_mib_counters(ah, false);
 }
 
 /*
@@ -821,10 +872,7 @@ void ath9k_hw_procmibevent(struct ath_hw *ah)
 	u32 phyCnt1, phyCnt2;
 
 	/* Reset these counters regardless */
-	REG_WRITE(ah, AR_FILT_OFDM, 0);
-	REG_WRITE(ah, AR_FILT_CCK, 0);
-	if (!(REG_READ(ah, AR_SLP_MIB_CTRL) & AR_SLP_MIB_PENDING))
-		REG_WRITE(ah, AR_SLP_MIB_CTRL, AR_SLP_MIB_CLEAR);
+	ath9k_hw_clear_mib_counters(ah, true);
 
 	/* Clear the mib counters and save them in the stats */
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
-- 
1.6.3.3

