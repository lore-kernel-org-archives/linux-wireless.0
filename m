Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59924 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab0JGXIs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:48 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/22] iwlagn: rename iwl_commit_rxon
Date: Thu,  7 Oct 2010 16:07:40 -0700
Message-Id: <1286492881-15743-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

iwl_commit_rxon really should be named
iwlagn_commit_rxon, so rename it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    3 +++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 834c2f9..09db940 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2216,7 +2216,7 @@ static void iwl4965_cancel_deferred_work(struct iwl_priv *priv)
 
 static struct iwl_hcmd_ops iwl4965_hcmd = {
 	.rxon_assoc = iwl4965_send_rxon_assoc,
-	.commit_rxon = iwl_commit_rxon,
+	.commit_rxon = iwlagn_commit_rxon,
 	.set_rxon_chain = iwl_set_rxon_chain,
 	.send_bt_config = iwl_send_bt_config,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 9ca6c91..901452e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -360,7 +360,7 @@ static int iwlagn_set_pan_params(struct iwl_priv *priv)
 
 struct iwl_hcmd_ops iwlagn_hcmd = {
 	.rxon_assoc = iwlagn_send_rxon_assoc,
-	.commit_rxon = iwl_commit_rxon,
+	.commit_rxon = iwlagn_commit_rxon,
 	.set_rxon_chain = iwl_set_rxon_chain,
 	.set_tx_ant = iwlagn_send_tx_ant_config,
 	.send_bt_config = iwl_send_bt_config,
@@ -369,7 +369,7 @@ struct iwl_hcmd_ops iwlagn_hcmd = {
 
 struct iwl_hcmd_ops iwlagn_bt_hcmd = {
 	.rxon_assoc = iwlagn_send_rxon_assoc,
-	.commit_rxon = iwl_commit_rxon,
+	.commit_rxon = iwlagn_commit_rxon,
 	.set_rxon_chain = iwl_set_rxon_chain,
 	.set_tx_ant = iwlagn_send_tx_ant_config,
 	.send_bt_config = iwlagn_send_advance_bt_config,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a6dce61..b59ce92 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -91,14 +91,14 @@ static int iwlagn_ant_coupling;
 static bool iwlagn_bt_ch_announce = 1;
 
 /**
- * iwl_commit_rxon - commit staging_rxon to hardware
+ * iwlagn_commit_rxon - commit staging_rxon to hardware
  *
  * The RXON command in staging_rxon is committed to the hardware and
  * the active_rxon structure is updated with the new data.  This
  * function correctly transitions out of the RXON_ASSOC_MSK state if
  * a HW tune is required based on the RXON structure changes.
  */
-int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
+int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	/* cast away the const for active_rxon in this function */
 	struct iwl_rxon_cmd *active_rxon = (void *)&ctx->active;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index eb3812a..2a1c83b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -129,6 +129,9 @@ void iwlagn_txq_set_sched(struct iwl_priv *priv, u32 mask);
 void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 			    int sta_id, int tid, int freed);
 
+/* RXON */
+int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
+
 /* uCode */
 int iwlagn_load_ucode(struct iwl_priv *priv);
 void iwlagn_rx_calib_result(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6228b1c..d6d5bb0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -432,7 +432,6 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_bss_conf *bss_conf,
 				     u32 changes);
-int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 int iwl_mac_add_interface(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif);
 void iwl_mac_remove_interface(struct ieee80211_hw *hw,
-- 
1.7.0.4

