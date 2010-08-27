Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:6615 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340Ab0H0Q4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/27] iwlwifi: send PAN parameters
Date: Fri, 27 Aug 2010 09:59:51 -0700
Message-Id: <1282928395-32762-24-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order for the microcode to be able to handle
multiple interfaces, we need to give it the PAN
parameters that state how to allocate the time
between the two interfaces. Do this, and update
it wherever necessary.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |   75 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    5 ++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 ++
 drivers/net/wireless/iwlwifi/iwl-core.c     |    6 ++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    3 +
 6 files changed, 96 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 2d4cdb0..6fb52ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -270,12 +270,86 @@ static int iwlagn_calc_rssi(struct iwl_priv *priv,
 	return max_rssi - agc - IWLAGN_RSSI_OFFSET;
 }
 
+static int iwlagn_set_pan_params(struct iwl_priv *priv)
+{
+	struct iwl_wipan_params_cmd cmd;
+	struct iwl_rxon_context *ctx_bss, *ctx_pan;
+	int slot0 = 300, slot1 = 0;
+	int ret;
+
+	if (priv->valid_contexts == BIT(IWL_RXON_CTX_BSS))
+		return 0;
+
+	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
+
+	lockdep_assert_held(&priv->mutex);
+
+	ctx_bss = &priv->contexts[IWL_RXON_CTX_BSS];
+	ctx_pan = &priv->contexts[IWL_RXON_CTX_PAN];
+
+	memset(&cmd, 0, sizeof(cmd));
+
+	/* only 2 slots are currently allowed */
+	cmd.num_slots = 2;
+
+	cmd.slots[0].type = 0; /* BSS */
+	cmd.slots[1].type = 1; /* PAN */
+
+	if (ctx_bss->vif && ctx_pan->vif) {
+		int bcnint = ctx_pan->vif->bss_conf.beacon_int;
+
+		/* should be set, but seems unused?? */
+		cmd.flags |= cpu_to_le16(IWL_WIPAN_PARAMS_FLG_SLOTTED_MODE);
+
+		if (ctx_pan->vif->type == NL80211_IFTYPE_AP &&
+		    bcnint &&
+		    bcnint != ctx_bss->vif->bss_conf.beacon_int) {
+			IWL_ERR(priv,
+				"beacon intervals don't match (%d, %d)\n",
+				ctx_bss->vif->bss_conf.beacon_int,
+				ctx_pan->vif->bss_conf.beacon_int);
+		} else
+			bcnint = max_t(int, bcnint,
+				       ctx_bss->vif->bss_conf.beacon_int);
+		if (!bcnint)
+			bcnint = 100;
+		slot0 = bcnint / 2;
+		slot1 = bcnint - slot0;
+
+		if (test_bit(STATUS_SCAN_HW, &priv->status) ||
+		    (!ctx_bss->vif->bss_conf.idle &&
+		     !ctx_bss->vif->bss_conf.assoc)) {
+			slot0 = bcnint * 3 - 20;
+			slot1 = 20;
+		} else if (!ctx_pan->vif->bss_conf.idle &&
+                           !ctx_pan->vif->bss_conf.assoc) {
+			slot1 = bcnint * 3 - 20;
+			slot0 = 20;
+		}
+	} else if (ctx_pan->vif) {
+		slot0 = 0;
+		slot1 = max_t(int, 1, ctx_pan->vif->bss_conf.dtim_period) *
+					ctx_pan->vif->bss_conf.beacon_int;
+		slot1 = max_t(int, 100, slot1);
+	}
+
+	cmd.slots[0].width = cpu_to_le16(slot0);
+	cmd.slots[1].width = cpu_to_le16(slot1);
+
+	ret = iwl_send_cmd_pdu(priv, REPLY_WIPAN_PARAMS, sizeof(cmd), &cmd);
+	if (ret)
+		IWL_ERR(priv, "Error setting PAN parameters (%d)\n", ret);
+
+	return ret;
+}
+
 struct iwl_hcmd_ops iwlagn_hcmd = {
 	.rxon_assoc = iwlagn_send_rxon_assoc,
 	.commit_rxon = iwl_commit_rxon,
 	.set_rxon_chain = iwl_set_rxon_chain,
 	.set_tx_ant = iwlagn_send_tx_ant_config,
 	.send_bt_config = iwl_send_bt_config,
+	.set_pan_params = iwlagn_set_pan_params,
 };
 
 struct iwl_hcmd_ops iwlagn_bt_hcmd = {
@@ -284,6 +358,7 @@ struct iwl_hcmd_ops iwlagn_bt_hcmd = {
 	.set_rxon_chain = iwl_set_rxon_chain,
 	.set_tx_ant = iwlagn_send_tx_ant_config,
 	.send_bt_config = iwlagn_send_advance_bt_config,
+	.set_pan_params = iwlagn_set_pan_params,
 };
 
 struct iwl_hcmd_utils_ops iwlagn_hcmd_utils = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 7002d7d..a8f2adf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1424,6 +1424,11 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->len = cpu_to_le16(cmd.len);
 
 	set_bit(STATUS_SCAN_HW, &priv->status);
+
+	if (priv->cfg->ops->hcmd->set_pan_params &&
+	    priv->cfg->ops->hcmd->set_pan_params(priv))
+		goto done;
+
 	if (iwl_send_cmd_sync(priv, &cmd))
 		goto done;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8e07228..f2884b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -197,6 +197,12 @@ int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		}
 	}
 
+	if (priv->cfg->ops->hcmd->set_pan_params) {
+		ret = priv->cfg->ops->hcmd->set_pan_params(priv);
+		if (ret)
+			return ret;
+	}
+
 	/* Apply the new configuration
 	 * RXON unassoc clears the station table in uCode so restoration of
 	 * stations is needed after it (the RXON command) completes
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 04d7894..b61b838 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1931,6 +1931,12 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 				bss_conf->bssid);
 	}
 
+	if (changes & BSS_CHANGED_IDLE &&
+	    priv->cfg->ops->hcmd->set_pan_params) {
+		if (priv->cfg->ops->hcmd->set_pan_params(priv))
+			IWL_ERR(priv, "failed to update PAN params\n");
+	}
+
 	mutex_unlock(&priv->mutex);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d2ee55d..ab465c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -94,6 +94,7 @@ struct iwl_hcmd_ops {
 			       struct iwl_rxon_context *ctx);
 	int (*set_tx_ant)(struct iwl_priv *priv, u8 valid_tx_ant);
 	void (*send_bt_config)(struct iwl_priv *priv);
+	int (*set_pan_params)(struct iwl_priv *priv);
 };
 
 struct iwl_hcmd_utils_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 556dcaa..7727f09 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -572,6 +572,9 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 		iwlcore_commit_rxon(priv, ctx);
 
  out:
+	if (priv->cfg->ops->hcmd->set_pan_params)
+		priv->cfg->ops->hcmd->set_pan_params(priv);
+
 	mutex_unlock(&priv->mutex);
 
 	/*
-- 
1.7.0.4

