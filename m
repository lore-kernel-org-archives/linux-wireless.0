Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:62079 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab0H0Q4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/27] iwlagn: send RXON timing before associating
Date: Fri, 27 Aug 2010 09:59:49 -0700
Message-Id: <1282928395-32762-22-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The PAN functionality requires us to send the
timing including a valid DTIM period to the
microcode before associating, so request this
data from mac80211 and send it to the device.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 ++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 143c12a..79aff1f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -182,6 +182,21 @@ int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 	iwl_set_rxon_hwcrypto(priv, ctx, !priv->cfg->mod_params->sw_crypto);
 
+	if (new_assoc) {
+		if (WARN_ON(!ctx->vif))
+			return -EINVAL;
+		/*
+		 * First of all, before setting associated, we need to
+		 * send RXON timing so the device knows about the DTIM
+		 * period and other timing values
+		 */
+		ret = iwl_send_rxon_timing(priv, ctx->vif);
+		if (ret) {
+			IWL_ERR(priv, "Error setting RXON timing!\n");
+			return ret;
+		}
+	}
+
 	/* Apply the new configuration
 	 * RXON unassoc clears the station table in uCode so restoration of
 	 * stations is needed after it (the RXON command) completes
@@ -3355,6 +3370,7 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_AMPDU_AGGREGATION |
+		    IEEE80211_HW_NEED_DTIM_PERIOD |
 		    IEEE80211_HW_SPECTRUM_MGMT;
 
 	if (!priv->cfg->broken_powersave)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index fb9173b..04d7894 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -536,6 +536,8 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	rem = do_div(tsf, interval_tm);
 	ctx->timing.beacon_init_val = cpu_to_le32(interval_tm - rem);
 
+	ctx->timing.dtim_period = vif->bss_conf.dtim_period;
+
 	IWL_DEBUG_ASSOC(priv,
 			"beacon interval %d beacon timer %d beacon tim %d\n",
 			le16_to_cpu(ctx->timing.beacon_interval),
-- 
1.7.0.4

