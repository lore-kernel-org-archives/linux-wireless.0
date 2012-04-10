Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757476Ab2DJAuX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 20:50:23 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/11] iwlwifi: remove ack_check module parameter
Date: Mon,  9 Apr 2012 17:46:56 -0700
Message-Id: <1334018821-30416-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120410_025040_884170_A8CE668F)
In-Reply-To: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This defaults to false, and we don't recommend
to use it anywhere, so just remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c |   69 -----------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    3 -
 drivers/net/wireless/iwlwifi/iwl-shared.h |    2 -
 3 files changed, 0 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 0a8c3e6..ef3758d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -246,69 +246,6 @@ static int iwlagn_rx_beacon_notif(struct iwl_priv *priv,
 	return 0;
 }
 
-/* the threshold ratio of actual_ack_cnt to expected_ack_cnt in percent */
-#define ACK_CNT_RATIO (50)
-#define BA_TIMEOUT_CNT (5)
-#define BA_TIMEOUT_MAX (16)
-
-/**
- * iwl_good_ack_health - checks for ACK count ratios, BA timeout retries.
- *
- * When the ACK count ratio is low and aggregated BA timeout retries exceeding
- * the BA_TIMEOUT_MAX, reload firmware and bring system back to normal
- * operation state.
- */
-static bool iwlagn_good_ack_health(struct iwl_priv *priv,
-				struct statistics_tx *cur)
-{
-	int actual_delta, expected_delta, ba_timeout_delta;
-	struct statistics_tx *old;
-
-	if (priv->agg_tids_count)
-		return true;
-
-	lockdep_assert_held(&priv->statistics.lock);
-
-	old = &priv->statistics.tx;
-
-	actual_delta = le32_to_cpu(cur->actual_ack_cnt) -
-		       le32_to_cpu(old->actual_ack_cnt);
-	expected_delta = le32_to_cpu(cur->expected_ack_cnt) -
-			 le32_to_cpu(old->expected_ack_cnt);
-
-	/* Values should not be negative, but we do not trust the firmware */
-	if (actual_delta <= 0 || expected_delta <= 0)
-		return true;
-
-	ba_timeout_delta = le32_to_cpu(cur->agg.ba_timeout) -
-			   le32_to_cpu(old->agg.ba_timeout);
-
-	if ((actual_delta * 100 / expected_delta) < ACK_CNT_RATIO &&
-	    ba_timeout_delta > BA_TIMEOUT_CNT) {
-		IWL_DEBUG_RADIO(priv,
-			"deltas: actual %d expected %d ba_timeout %d\n",
-			actual_delta, expected_delta, ba_timeout_delta);
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-		/*
-		 * This is ifdef'ed on DEBUGFS because otherwise the
-		 * statistics aren't available. If DEBUGFS is set but
-		 * DEBUG is not, these will just compile out.
-		 */
-		IWL_DEBUG_RADIO(priv, "rx_detected_cnt delta %d\n",
-				priv->delta_stats.tx.rx_detected_cnt);
-		IWL_DEBUG_RADIO(priv,
-				"ack_or_ba_timeout_collision delta %d\n",
-				priv->delta_stats.tx.ack_or_ba_timeout_collision);
-#endif
-
-		if (ba_timeout_delta >= BA_TIMEOUT_MAX)
-			return false;
-	}
-
-	return true;
-}
-
 /**
  * iwl_good_plcp_health - checks for plcp error.
  *
@@ -368,12 +305,6 @@ static void iwlagn_recover_from_statistics(struct iwl_priv *priv,
 	if (msecs < 99)
 		return;
 
-	if (iwlagn_mod_params.ack_check && !iwlagn_good_ack_health(priv, tx)) {
-		IWL_ERR(priv, "low ack count detected, restart firmware\n");
-		if (!iwl_force_reset(priv, IWL_FW_RESET, false))
-			return;
-	}
-
 	if (iwlagn_mod_params.plcp_check &&
 	    !iwlagn_good_plcp_health(priv, cur_ofdm, cur_ofdm_ht, msecs))
 		iwl_force_reset(priv, IWL_RF_RESET, false);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2818148..20c6476 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2278,9 +2278,6 @@ MODULE_PARM_DESC(bt_ch_inhibition,
 module_param_named(plcp_check, iwlagn_mod_params.plcp_check, bool, S_IRUGO);
 MODULE_PARM_DESC(plcp_check, "Check plcp health (default: 1 [enabled])");
 
-module_param_named(ack_check, iwlagn_mod_params.ack_check, bool, S_IRUGO);
-MODULE_PARM_DESC(ack_check, "Check ack health (default: 0 [disabled])");
-
 module_param_named(wd_disable, iwlagn_mod_params.wd_disable, int, S_IRUGO);
 MODULE_PARM_DESC(wd_disable,
 		"Disable stuck queue watchdog timer 0=system default, "
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index c6de930..c6325c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -121,7 +121,6 @@ extern struct iwl_mod_params iwlagn_mod_params;
  * @antenna: both antennas (use diversity), default = 0
  * @restart_fw: restart firmware, default = 1
  * @plcp_check: enable plcp health check, default = true
- * @ack_check: disable ack health check, default = false
  * @wd_disable: enable stuck queue check, default = 0
  * @bt_coex_active: enable bt coex, default = true
  * @led_mode: system default, default = 0
@@ -141,7 +140,6 @@ struct iwl_mod_params {
 	int antenna;
 	int restart_fw;
 	bool plcp_check;
-	bool ack_check;
 	int  wd_disable;
 	bool bt_coex_active;
 	int led_mode;
-- 
1.7.0.4

