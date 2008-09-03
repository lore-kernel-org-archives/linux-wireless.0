Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61765 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653AbYICDba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:30 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 26/39] iwlwifi: remove double definition of SM PS
Date: Wed,  3 Sep 2008 11:26:46 +0800
Message-Id: <1220412419-15404-27-git-send-email-yi.zhu@intel.com> (sfid-20080903_055042_281820_1B05097C)
In-Reply-To: <1220412419-15404-26-git-send-email-yi.zhu@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch removes iwlwifi definition of spatial power save modes,
already defined in ieee80211.h.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c   |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    5 -----
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 609ad1d..c1b70c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1154,7 +1154,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 		return -1;
 
 	if (((sta->ht_info.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
-						== IWL_MIMO_PS_STATIC)
+						== WLAN_HT_CAP_SM_PS_STATIC)
 		return -1;
 
 	/* Need both Tx chains/antennas to support MIMO */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e2f06aa..fa48615 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -400,7 +400,7 @@ static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 	ht_info->cap |= (u16)IEEE80211_HT_CAP_GRN_FLD;
 	ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_20;
 	ht_info->cap |= (u16)(IEEE80211_HT_CAP_SM_PS &
-			     (IWL_MIMO_PS_NONE << 2));
+			     (WLAN_HT_CAP_SM_PS_DISABLED << 2));
 
 	max_bit_rate = MAX_BIT_RATE_20_MHZ;
 	if (priv->hw_params.fat_channel & BIT(band)) {
@@ -709,7 +709,7 @@ static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
 	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
 
 	/* # of Rx chains to use when expecting MIMO. */
-	if (is_single || (!is_cam && (priv->ps_mode == IWL_MIMO_PS_STATIC)))
+	if (is_single || (!is_cam && (priv->ps_mode == WLAN_HT_CAP_SM_PS_STATIC)))
 		return 2;
 	else
 		return 3;
@@ -721,14 +721,14 @@ static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
 	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
 	/* # Rx chains when idling and maybe trying to save power */
 	switch (priv->ps_mode) {
-	case IWL_MIMO_PS_STATIC:
-	case IWL_MIMO_PS_DYNAMIC:
+	case WLAN_HT_CAP_SM_PS_STATIC:
+	case WLAN_HT_CAP_SM_PS_DYNAMIC:
 		idle_cnt = (is_cam) ? 2 : 1;
 		break;
-	case IWL_MIMO_PS_NONE:
+	case WLAN_HT_CAP_SM_PS_DISABLED:
 		idle_cnt = (is_cam) ? active_cnt : 1;
 		break;
-	case IWL_MIMO_PS_INVALID:
+	case WLAN_HT_CAP_SM_PS_INVALID:
 	default:
 		IWL_ERROR("invalide mimo ps mode %d\n", priv->ps_mode);
 		WARN_ON(1);
@@ -908,7 +908,7 @@ int iwl_init_drv(struct iwl_priv *priv)
 	priv->iw_mode = IEEE80211_IF_TYPE_STA;
 
 	priv->use_ant_b_for_management_frame = 1; /* start with ant B */
-	priv->ps_mode = IWL_MIMO_PS_NONE;
+	priv->ps_mode = WLAN_HT_CAP_SM_PS_DISABLED;
 
 	/* Choose which receivers/antennas to use */
 	iwl_set_rxon_chain(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ee38697..1b11664 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -650,11 +650,6 @@ struct iwl_kw {
 #define IWL_CHANNEL_WIDTH_20MHZ   0
 #define IWL_CHANNEL_WIDTH_40MHZ   1
 
-#define IWL_MIMO_PS_STATIC        0
-#define IWL_MIMO_PS_NONE          3
-#define IWL_MIMO_PS_DYNAMIC       1
-#define IWL_MIMO_PS_INVALID       2
-
 #define IWL_OPERATION_MODE_AUTO     0
 #define IWL_OPERATION_MODE_HT_ONLY  1
 #define IWL_OPERATION_MODE_MIXED    2
-- 
1.5.3.6

