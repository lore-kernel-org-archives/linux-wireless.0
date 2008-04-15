Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56235 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbYDOXCK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 19:02:10 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/11] iwlwifi: move rxon associated command to hcmd
Date: Tue, 15 Apr 2008 16:01:43 -0700
Message-Id: <1208300507-25628-8-git-send-email-reinette.chatre@intel.com> (sfid-20080416_000235_560513_0F120FD2)
In-Reply-To: <1208300507-25628-7-git-send-email-reinette.chatre@intel.com>
References: <1208300507-25628-1-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-2-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-3-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-4-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-5-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-6-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch run rxon associated command from hcmd handler

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   41 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.h     |    7 ++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   43 +-------------------------
 4 files changed, 51 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9fa803a..2e74712 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2884,6 +2884,46 @@ out:
 	return ret;
 }
 
+static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
+{
+	int ret = 0;
+	struct iwl4965_rxon_assoc_cmd rxon_assoc;
+	const struct iwl4965_rxon_cmd *rxon1 = &priv->staging_rxon;
+	const struct iwl4965_rxon_cmd *rxon2 = &priv->active_rxon;
+
+	if ((rxon1->flags == rxon2->flags) &&
+	    (rxon1->filter_flags == rxon2->filter_flags) &&
+	    (rxon1->cck_basic_rates == rxon2->cck_basic_rates) &&
+	    (rxon1->ofdm_ht_single_stream_basic_rates ==
+	     rxon2->ofdm_ht_single_stream_basic_rates) &&
+	    (rxon1->ofdm_ht_dual_stream_basic_rates ==
+	     rxon2->ofdm_ht_dual_stream_basic_rates) &&
+	    (rxon1->rx_chain == rxon2->rx_chain) &&
+	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
+		IWL_DEBUG_INFO("Using current RXON_ASSOC.  Not resending.\n");
+		return 0;
+	}
+
+	rxon_assoc.flags = priv->staging_rxon.flags;
+	rxon_assoc.filter_flags = priv->staging_rxon.filter_flags;
+	rxon_assoc.ofdm_basic_rates = priv->staging_rxon.ofdm_basic_rates;
+	rxon_assoc.cck_basic_rates = priv->staging_rxon.cck_basic_rates;
+	rxon_assoc.reserved = 0;
+	rxon_assoc.ofdm_ht_single_stream_basic_rates =
+	    priv->staging_rxon.ofdm_ht_single_stream_basic_rates;
+	rxon_assoc.ofdm_ht_dual_stream_basic_rates =
+	    priv->staging_rxon.ofdm_ht_dual_stream_basic_rates;
+	rxon_assoc.rx_chain_select_flags = priv->staging_rxon.rx_chain;
+
+	ret = iwl_send_cmd_pdu_async(priv, REPLY_RXON_ASSOC,
+				     sizeof(rxon_assoc), &rxon_assoc, NULL);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
+
 int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 {
 	int rc;
@@ -4907,6 +4947,7 @@ void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv)
 
 
 static struct iwl_hcmd_ops iwl4965_hcmd = {
+	.rxon_assoc = iwl4965_send_rxon_assoc,
 };
 
 static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 88d6246..2dfd982 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -289,3 +289,4 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags)
 	return iwl_send_cmd(priv, &cmd);
 }
 EXPORT_SYMBOL(iwl_send_statistics_request);
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 64bab66..e22563a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -83,6 +83,7 @@ struct iwl_cmd;
 #define IWL_SKU_N       0x8
 
 struct iwl_hcmd_ops {
+	int (*rxon_assoc)(struct iwl_priv *priv);
 };
 struct iwl_hcmd_utils_ops {
 	int (*enqueue_hcmd)(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
@@ -236,4 +237,10 @@ int iwlcore_low_level_notify(struct iwl_priv *priv,
 extern int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags);
 int iwl_send_lq_cmd(struct iwl_priv *priv,
 		    struct iwl_link_quality_cmd *lq, u8 flags);
+
+static inline int iwl_send_rxon_assoc(struct iwl_priv *priv)
+{
+	return priv->cfg->ops->hcmd->rxon_assoc(priv);
+}
+
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 249af41..745b462 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -749,45 +749,6 @@ static int iwl4965_full_rxon_required(struct iwl_priv *priv)
 	return 0;
 }
 
-static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
-{
-	int ret = 0;
-	struct iwl4965_rxon_assoc_cmd rxon_assoc;
-	const struct iwl4965_rxon_cmd *rxon1 = &priv->staging_rxon;
-	const struct iwl4965_rxon_cmd *rxon2 = &priv->active_rxon;
-
-	if ((rxon1->flags == rxon2->flags) &&
-	    (rxon1->filter_flags == rxon2->filter_flags) &&
-	    (rxon1->cck_basic_rates == rxon2->cck_basic_rates) &&
-	    (rxon1->ofdm_ht_single_stream_basic_rates ==
-	     rxon2->ofdm_ht_single_stream_basic_rates) &&
-	    (rxon1->ofdm_ht_dual_stream_basic_rates ==
-	     rxon2->ofdm_ht_dual_stream_basic_rates) &&
-	    (rxon1->rx_chain == rxon2->rx_chain) &&
-	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
-		IWL_DEBUG_INFO("Using current RXON_ASSOC.  Not resending.\n");
-		return 0;
-	}
-
-	rxon_assoc.flags = priv->staging_rxon.flags;
-	rxon_assoc.filter_flags = priv->staging_rxon.filter_flags;
-	rxon_assoc.ofdm_basic_rates = priv->staging_rxon.ofdm_basic_rates;
-	rxon_assoc.cck_basic_rates = priv->staging_rxon.cck_basic_rates;
-	rxon_assoc.reserved = 0;
-	rxon_assoc.ofdm_ht_single_stream_basic_rates =
-	    priv->staging_rxon.ofdm_ht_single_stream_basic_rates;
-	rxon_assoc.ofdm_ht_dual_stream_basic_rates =
-	    priv->staging_rxon.ofdm_ht_dual_stream_basic_rates;
-	rxon_assoc.rx_chain_select_flags = priv->staging_rxon.rx_chain;
-
-	ret = iwl_send_cmd_pdu_async(priv, REPLY_RXON_ASSOC,
-				     sizeof(rxon_assoc), &rxon_assoc, NULL);
-	if (ret)
-		return ret;
-
-	return ret;
-}
-
 /**
  * iwl4965_commit_rxon - commit staging_rxon to hardware
  *
@@ -819,7 +780,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	 * iwl4965_rxon_assoc_cmd which is used to reconfigure filter
 	 * and other flags for the current radio configuration. */
 	if (!iwl4965_full_rxon_required(priv)) {
-		rc = iwl4965_send_rxon_assoc(priv);
+		rc = iwl_send_rxon_assoc(priv);
 		if (rc) {
 			IWL_ERROR("Error setting RXON_ASSOC "
 				  "configuration (%d).\n", rc);
@@ -6756,7 +6717,7 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	} else if (changes && iwl_is_associated(priv) && priv->assoc_id) {
 			IWL_DEBUG_MAC80211("Associated Changes %d\n", changes);
-			iwl4965_send_rxon_assoc(priv);
+			iwl_send_rxon_assoc(priv);
 	}
 
 }
-- 
1.5.3.4

