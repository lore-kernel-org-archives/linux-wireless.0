Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44611 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3L1EWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Dec 2013 23:22:22 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/7] ath9k: Cleanup __ath9k_hw_init()
Date: Sat, 28 Dec 2013 09:47:12 +0530
Message-Id: <1388204235-14682-4-git-send-email-sujith@msujith.org> (sfid-20131228_052246_189045_90D039CE)
In-Reply-To: <1388204235-14682-1-git-send-email-sujith@msujith.org>
References: <1388204235-14682-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

* Move initialization of config variables to
  ath9k_hw_init_config().

* Move initialization of defaults to ath9k_hw_init_defaults().

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 64 ++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 536b9ec..8cc44e9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -346,6 +346,8 @@ static bool ath9k_hw_chip_test(struct ath_hw *ah)
 
 static void ath9k_hw_init_config(struct ath_hw *ah)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
+
 	ah->config.dma_beacon_response_time = 1;
 	ah->config.sw_beacon_response_time = 6;
 	ah->config.ack_6mb = 0x0;
@@ -372,6 +374,24 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	 */
 	if (num_possible_cpus() > 1)
 		ah->config.serialize_regmode = SER_REG_MODE_AUTO;
+
+	if (NR_CPUS > 1 && ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
+		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI ||
+		    ((AR_SREV_9160(ah) || AR_SREV_9280(ah) || AR_SREV_9287(ah)) &&
+		     !ah->is_pciexpress)) {
+			ah->config.serialize_regmode = SER_REG_MODE_ON;
+		} else {
+			ah->config.serialize_regmode = SER_REG_MODE_OFF;
+		}
+	}
+
+	ath_dbg(common, RESET, "serialize_regmode is %d\n",
+		ah->config.serialize_regmode);
+
+	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
+		ah->config.max_txtrig_level = MAX_TX_FIFO_THRESHOLD >> 1;
+	else
+		ah->config.max_txtrig_level = MAX_TX_FIFO_THRESHOLD;
 }
 
 static void ath9k_hw_init_defaults(struct ath_hw *ah)
@@ -384,15 +404,24 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	ah->hw_version.magic = AR5416_MAGIC;
 	ah->hw_version.subvendorid = 0;
 
-	ah->sta_id1_defaults =
-		AR_STA_ID1_CRPT_MIC_ENABLE |
-		AR_STA_ID1_MCAST_KSRCH;
+	ah->sta_id1_defaults = AR_STA_ID1_CRPT_MIC_ENABLE |
+			       AR_STA_ID1_MCAST_KSRCH;
 	if (AR_SREV_9100(ah))
 		ah->sta_id1_defaults |= AR_STA_ID1_AR9100_BA_FIX;
+
 	ah->slottime = ATH9K_SLOT_TIME_9;
 	ah->globaltxtimeout = (u32) -1;
 	ah->power_mode = ATH9K_PM_UNDEFINED;
 	ah->htc_reset_init = true;
+
+	ah->ani_function = ATH9K_ANI_ALL;
+	if (!AR_SREV_9300_20_OR_LATER(ah))
+		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
+
+	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
+		ah->tx_trig_level = (AR_FTRIG_256B >> AR_FTRIG_S);
+	else
+		ah->tx_trig_level = (AR_FTRIG_512B >> AR_FTRIG_S);
 }
 
 static int ath9k_hw_init_macaddr(struct ath_hw *ah)
@@ -531,26 +560,6 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 		return -EIO;
 	}
 
-	if (NR_CPUS > 1 && ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
-		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI ||
-		    ((AR_SREV_9160(ah) || AR_SREV_9280(ah) || AR_SREV_9287(ah)) &&
-		     !ah->is_pciexpress)) {
-			ah->config.serialize_regmode =
-				SER_REG_MODE_ON;
-		} else {
-			ah->config.serialize_regmode =
-				SER_REG_MODE_OFF;
-		}
-	}
-
-	ath_dbg(common, RESET, "serialize_regmode is %d\n",
-		ah->config.serialize_regmode);
-
-	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
-		ah->config.max_txtrig_level = MAX_TX_FIFO_THRESHOLD >> 1;
-	else
-		ah->config.max_txtrig_level = MAX_TX_FIFO_THRESHOLD;
-
 	if (AR_SREV_9271(ah) || AR_SREV_9100(ah) || AR_SREV_9340(ah) ||
 	    AR_SREV_9330(ah) || AR_SREV_9550(ah))
 		ah->is_pciexpress = false;
@@ -558,10 +567,6 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	ah->hw_version.phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
 	ath9k_hw_init_cal_settings(ah);
 
-	ah->ani_function = ATH9K_ANI_ALL;
-	if (!AR_SREV_9300_20_OR_LATER(ah))
-		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
-
 	if (!ah->is_pciexpress)
 		ath9k_hw_disablepcie(ah);
 
@@ -580,11 +585,6 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 		return r;
 	}
 
-	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
-		ah->tx_trig_level = (AR_FTRIG_256B >> AR_FTRIG_S);
-	else
-		ah->tx_trig_level = (AR_FTRIG_512B >> AR_FTRIG_S);
-
 	ath9k_hw_init_hang_checks(ah);
 
 	common->state = ATH_HW_INITIALIZED;
-- 
1.8.5.2

