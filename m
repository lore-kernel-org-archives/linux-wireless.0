Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35160 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab2GIJQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:16:03 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20474.41220.832009.436301@gargle.gargle.HOWL> (sfid-20120709_111608_307822_0AE1060D)
Date: Mon, 9 Jul 2012 14:44:44 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 02/11] ath9k_hw: Cleanup ath9k_hw_set_tsfadjust
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  2 +-
 drivers/net/wireless/ath/ath9k/hw.c           |  4 ++--
 drivers/net/wireless/ath/ath9k/hw.h           |  2 +-
 drivers/net/wireless/ath/ath9k/main.c         | 10 ++--------
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 374c32e..69c5589 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1111,7 +1111,7 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 
 	if ((priv->ah->opmode == NL80211_IFTYPE_AP) &&
 	    !test_bit(OP_ANI_RUNNING, &priv->op_flags)) {
-		ath9k_hw_set_tsfadjust(priv->ah, 1);
+		ath9k_hw_set_tsfadjust(priv->ah, true);
 		ath9k_htc_start_ani(priv);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c1659d0..563366d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2908,9 +2908,9 @@ void ath9k_hw_reset_tsf(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_reset_tsf);
 
-void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
+void ath9k_hw_set_tsfadjust(struct ath_hw *ah, bool set)
 {
-	if (setting)
+	if (set)
 		ah->misc_mode |= AR_PCU_TX_ADD_TSF;
 	else
 		ah->misc_mode &= ~AR_PCU_TX_ADD_TSF;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 26da173..7a26723 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -943,7 +943,7 @@ u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 u64 ath9k_hw_gettsf64(struct ath_hw *ah);
 void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
 void ath9k_hw_reset_tsf(struct ath_hw *ah);
-void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting);
+void ath9k_hw_set_tsfadjust(struct ath_hw *ah, bool set);
 void ath9k_hw_init_global_settings(struct ath_hw *ah);
 u32 ar9003_get_pll_sqsum_dvc(struct ath_hw *ah);
 void ath9k_hw_set11nmac2040(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 19a2274..1265add 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -908,17 +908,15 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 
 	ath9k_calculate_iter_data(hw, vif, &iter_data);
 
-	/* Set BSSID mask. */
 	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
 	ath_hw_setbssidmask(common);
 
-	/* Set op-mode & TSF */
 	if (iter_data.naps > 0) {
-		ath9k_hw_set_tsfadjust(ah, 1);
+		ath9k_hw_set_tsfadjust(ah, true);
 		set_bit(SC_OP_TSF_RESET, &sc->sc_flags);
 		ah->opmode = NL80211_IFTYPE_AP;
 	} else {
-		ath9k_hw_set_tsfadjust(ah, 0);
+		ath9k_hw_set_tsfadjust(ah, false);
 		clear_bit(SC_OP_TSF_RESET, &sc->sc_flags);
 
 		if (iter_data.nmeshes)
@@ -931,9 +929,6 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 			ah->opmode = NL80211_IFTYPE_STATION;
 	}
 
-	/*
-	 * Enable MIB interrupts when there are hardware phy counters.
-	 */
 	if ((iter_data.nstations + iter_data.nadhocs + iter_data.nmeshes) > 0)
 		ah->imask |= ATH9K_INT_TSFOOR;
 	else
@@ -941,7 +936,6 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 
 	ath9k_hw_set_interrupts(ah);
 
-	/* Set up ANI */
 	if (iter_data.naps > 0) {
 		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
 
-- 
1.7.11.1

