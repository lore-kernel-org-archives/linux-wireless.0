Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22419 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202AbYICDbb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:31 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 27/39] iwlwifi: rename ps_mode to sm_ps
Date: Wed,  3 Sep 2008 11:26:47 +0800
Message-Id: <1220412419-15404-28-git-send-email-yi.zhu@intel.com> (sfid-20080903_055044_048637_18959DA5)
In-Reply-To: <1220412419-15404-27-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-17-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-18-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-19-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-20-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-21-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-22-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-23-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-24-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-25-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-26-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-27-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch renames iwl_priv.ps_mode for clearer
iwl_priv.current_ht_config.sm_ps (spatial multiplexing power save).

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.c |   10 ++++++----
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 +-
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 74fe85a..aad0ddc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -564,8 +564,6 @@ static void iwl4965_ht_conf(struct iwl_priv *priv,
 	if (!iwl_conf->is_ht)
 		return;
 
-	priv->ps_mode = (u8)((ht_conf->cap & IEEE80211_HT_CAP_SM_PS) >> 2);
-
 	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_20)
 		iwl_conf->sgf |= HT_SHORT_GI_20MHZ;
 	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_40)
@@ -586,6 +584,8 @@ static void iwl4965_ht_conf(struct iwl_priv *priv,
 		iwl_conf->supported_chan_width = 0;
 	}
 
+	iwl_conf->sm_ps = (u8)((ht_conf->cap & IEEE80211_HT_CAP_SM_PS) >> 2);
+
 	memcpy(iwl_conf->supp_mcs_set, ht_conf->supp_mcs_set, 16);
 
 	iwl_conf->control_channel = ht_bss_conf->primary_channel;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index fa48615..b29c84a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -709,7 +709,8 @@ static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
 	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
 
 	/* # of Rx chains to use when expecting MIMO. */
-	if (is_single || (!is_cam && (priv->ps_mode == WLAN_HT_CAP_SM_PS_STATIC)))
+	if (is_single || (!is_cam && (priv->current_ht_config.sm_ps ==
+						 WLAN_HT_CAP_SM_PS_STATIC)))
 		return 2;
 	else
 		return 3;
@@ -720,7 +721,7 @@ static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
 	int idle_cnt;
 	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
 	/* # Rx chains when idling and maybe trying to save power */
-	switch (priv->ps_mode) {
+	switch (priv->current_ht_config.sm_ps) {
 	case WLAN_HT_CAP_SM_PS_STATIC:
 	case WLAN_HT_CAP_SM_PS_DYNAMIC:
 		idle_cnt = (is_cam) ? 2 : 1;
@@ -730,7 +731,8 @@ static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
 		break;
 	case WLAN_HT_CAP_SM_PS_INVALID:
 	default:
-		IWL_ERROR("invalide mimo ps mode %d\n", priv->ps_mode);
+		IWL_ERROR("invalide mimo ps mode %d\n",
+			   priv->current_ht_config.sm_ps);
 		WARN_ON(1);
 		idle_cnt = -1;
 		break;
@@ -908,7 +910,7 @@ int iwl_init_drv(struct iwl_priv *priv)
 	priv->iw_mode = IEEE80211_IF_TYPE_STA;
 
 	priv->use_ant_b_for_management_frame = 1; /* start with ant B */
-	priv->ps_mode = WLAN_HT_CAP_SM_PS_DISABLED;
+	priv->current_ht_config.sm_ps = WLAN_HT_CAP_SM_PS_DISABLED;
 
 	/* Choose which receivers/antennas to use */
 	iwl_set_rxon_chain(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1b11664..45ae68a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -412,6 +412,7 @@ struct iwl_ht_info {
 	/* self configuration data */
 	u8 is_ht;
 	u8 supported_chan_width;
+	u8 sm_ps;
 	u8 is_green_field;
 	u8 sgf;			/* HT_SHORT_GI_* short guard interval */
 	u8 max_amsdu_size;
@@ -996,7 +997,6 @@ struct iwl_priv {
 	 * hardware */
 	u16 assoc_id;
 	u16 assoc_capability;
-	u8 ps_mode;
 
 	struct iwl_qos_info qos_data;
 
-- 
1.5.3.6

