Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58877 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966065Ab2DLV6L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 19/24] iwlwifi: move iwl_force_rf_reset to iwl-agn-rx.c
Date: Thu, 12 Apr 2012 14:54:16 -0700
Message-Id: <1334267661-14654-20-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235823_465891_4FACD712)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Move this function as part of iwl-core.c cleanup.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c |   39 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c   |   39 -----------------------------
 2 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index aba1da2..93a6871 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -284,6 +284,45 @@ static bool iwlagn_good_plcp_health(struct iwl_priv *priv,
 	return true;
 }
 
+int iwl_force_rf_reset(struct iwl_priv *priv, bool external)
+{
+	struct iwl_rf_reset *rf_reset;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return -EAGAIN;
+
+	if (!iwl_is_any_associated(priv)) {
+		IWL_DEBUG_SCAN(priv, "force reset rejected: not associated\n");
+		return -ENOLINK;
+	}
+
+	rf_reset = &priv->rf_reset;
+	rf_reset->reset_request_count++;
+	if (!external && rf_reset->last_reset_jiffies &&
+	    time_after(rf_reset->last_reset_jiffies +
+		       IWL_DELAY_NEXT_FORCE_RF_RESET, jiffies)) {
+		IWL_DEBUG_INFO(priv, "RF reset rejected\n");
+		rf_reset->reset_reject_count++;
+		return -EAGAIN;
+	}
+	rf_reset->reset_success_count++;
+	rf_reset->last_reset_jiffies = jiffies;
+
+	/*
+	 * There is no easy and better way to force reset the radio,
+	 * the only known method is switching channel which will force to
+	 * reset and tune the radio.
+	 * Use internal short scan (single channel) operation to should
+	 * achieve this objective.
+	 * Driver should reset the radio when number of consecutive missed
+	 * beacon, or any other uCode error condition detected.
+	 */
+	IWL_DEBUG_INFO(priv, "perform radio reset.\n");
+	iwl_internal_short_hw_scan(priv);
+	return 0;
+}
+
+
 static void iwlagn_recover_from_statistics(struct iwl_priv *priv,
 				struct statistics_rx_phy *cur_ofdm,
 				struct statistics_rx_ht_phy *cur_ofdm_ht,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index ae542b7..26eb7fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -277,45 +277,6 @@ void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
 }
 #endif
 
-int iwl_force_rf_reset(struct iwl_priv *priv, bool external)
-{
-	struct iwl_rf_reset *rf_reset;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return -EAGAIN;
-
-	if (!iwl_is_any_associated(priv)) {
-		IWL_DEBUG_SCAN(priv, "force reset rejected: not associated\n");
-		return -ENOLINK;
-	}
-
-	rf_reset = &priv->rf_reset;
-	rf_reset->reset_request_count++;
-	if (!external && rf_reset->last_reset_jiffies &&
-	    time_after(rf_reset->last_reset_jiffies +
-		       IWL_DELAY_NEXT_FORCE_RF_RESET, jiffies)) {
-		IWL_DEBUG_INFO(priv, "RF reset rejected\n");
-		rf_reset->reset_reject_count++;
-		return -EAGAIN;
-	}
-	rf_reset->reset_success_count++;
-	rf_reset->last_reset_jiffies = jiffies;
-
-	/*
-	 * There is no easy and better way to force reset the radio,
-	 * the only known method is switching channel which will force to
-	 * reset and tune the radio.
-	 * Use internal short scan (single channel) operation to should
-	 * achieve this objective.
-	 * Driver should reset the radio when number of consecutive missed
-	 * beacon, or any other uCode error condition detected.
-	 */
-	IWL_DEBUG_INFO(priv, "perform radio reset.\n");
-	iwl_internal_short_hw_scan(priv);
-	return 0;
-}
-
-
 int iwl_cmd_echo_test(struct iwl_priv *priv)
 {
 	int ret;
-- 
1.7.0.4

