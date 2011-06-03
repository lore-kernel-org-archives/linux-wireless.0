Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:23158 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab1FCPWw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 11:22:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/5] iwlagn: set smps mode after assoc for 1000 device
Date: Fri,  3 Jun 2011 07:54:13 -0700
Message-Id: <1307112856-20231-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110603_172256_845750_915BDDB5)
In-Reply-To: <1307112856-20231-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307112856-20231-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For some timing reason, 1000 device having problem to kick-in to aggregation
without sending rxon assoc command. This is a W/A until find the real reason

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    5 +++--
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 9940950..7aa240e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -222,6 +222,7 @@ static struct iwl_base_params iwl1000_base_params = {
 static struct iwl_ht_params iwl1000_ht_params = {
 	.ht_greenfield_support = true,
 	.use_rts_for_aggregation = true, /* use rts/cts protection */
+	.smps_mode = IEEE80211_SMPS_STATIC,
 };
 
 #define IWL_DEVICE_1000						\
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index afb2f20..5f562d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -291,6 +291,12 @@ static int iwlagn_rxon_connect(struct iwl_priv *priv,
 		IWL_ERR(priv, "Error sending TX power (%d)\n", ret);
 		return ret;
 	}
+
+	if ((ctx->vif && ctx->vif->type == NL80211_IFTYPE_STATION) &&
+	    priv->cfg->ht_params->smps_mode)
+		ieee80211_request_smps(ctx->vif,
+				       priv->cfg->ht_params->smps_mode);
+
 	return 0;
 }
 
@@ -395,6 +401,10 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		 * do it now if after settings changed.
 		 */
 		iwl_set_tx_power(priv, priv->tx_power_next, false);
+
+		/* make sure we are in the right PS state */
+		iwl_power_update_mode(priv, true);
+
 		return 0;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a87b54f..e430a4f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -224,7 +224,7 @@ struct iwl_base_params {
  * @ampdu_factor: Maximum A-MPDU length factor
  * @ampdu_density: Minimum A-MPDU spacing
  * @bt_sco_disable: uCode should not response to BT in SCO/ESCO mode
-*/
+ */
 struct iwl_bt_params {
 	bool advanced_bt_coexist;
 	u8 bt_init_traffic_load;
@@ -237,10 +237,11 @@ struct iwl_bt_params {
 };
 /*
  * @use_rts_for_aggregation: use rts/cts protection for HT traffic
-*/
+ */
 struct iwl_ht_params {
 	const bool ht_greenfield_support; /* if used set to true */
 	bool use_rts_for_aggregation;
+	enum ieee80211_smps_mode smps_mode;
 };
 
 /**
-- 
1.7.0.4

