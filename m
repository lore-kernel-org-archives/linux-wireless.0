Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56324 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbYICDb1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:27 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 24/39] iwlwifi: change MIMO_PS to SM_PS
Date: Wed,  3 Sep 2008 11:26:44 +0800
Message-Id: <1220412419-15404-25-git-send-email-yi.zhu@intel.com> (sfid-20080903_055042_769274_B9F47C52)
In-Reply-To: <1220412419-15404-24-git-send-email-yi.zhu@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch follows 11n spec naming more accurately, replacing MIMO_PS
with SM_PS (Spatial Multiplexing Power Save).

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c    |    8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 90a2b6d..609ad1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1153,7 +1153,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	    !sta->ht_info.ht_supported)
 		return -1;
 
-	if (((sta->ht_info.cap & IEEE80211_HT_CAP_MIMO_PS) >> 2)
+	if (((sta->ht_info.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
 						== IWL_MIMO_PS_STATIC)
 		return -1;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 326ab01..74fe85a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -564,7 +564,7 @@ static void iwl4965_ht_conf(struct iwl_priv *priv,
 	if (!iwl_conf->is_ht)
 		return;
 
-	priv->ps_mode = (u8)((ht_conf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2);
+	priv->ps_mode = (u8)((ht_conf->cap & IEEE80211_HT_CAP_SM_PS) >> 2);
 
 	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_20)
 		iwl_conf->sgf |= HT_SHORT_GI_20MHZ;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e55a62d..e2f06aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -399,7 +399,7 @@ static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 
 	ht_info->cap |= (u16)IEEE80211_HT_CAP_GRN_FLD;
 	ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_20;
-	ht_info->cap |= (u16)(IEEE80211_HT_CAP_MIMO_PS &
+	ht_info->cap |= (u16)(IEEE80211_HT_CAP_SM_PS &
 			     (IWL_MIMO_PS_NONE << 2));
 
 	max_bit_rate = MAX_BIT_RATE_20_MHZ;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 6283a3a..3c0204c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -191,20 +191,20 @@ static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
 	if (!sta_ht_inf || !sta_ht_inf->ht_supported)
 		goto done;
 
-	mimo_ps_mode = (sta_ht_inf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2;
+	mimo_ps_mode = (sta_ht_inf->cap & IEEE80211_HT_CAP_SM_PS) >> 2;
 
 	sta_flags = priv->stations[index].sta.station_flags;
 
 	sta_flags &= ~(STA_FLG_RTS_MIMO_PROT_MSK | STA_FLG_MIMO_DIS_MSK);
 
 	switch (mimo_ps_mode) {
-	case WLAN_HT_CAP_MIMO_PS_STATIC:
+	case WLAN_HT_CAP_SM_PS_STATIC:
 		sta_flags |= STA_FLG_MIMO_DIS_MSK;
 		break;
-	case WLAN_HT_CAP_MIMO_PS_DYNAMIC:
+	case WLAN_HT_CAP_SM_PS_DYNAMIC:
 		sta_flags |= STA_FLG_RTS_MIMO_PROT_MSK;
 		break;
-	case WLAN_HT_CAP_MIMO_PS_DISABLED:
+	case WLAN_HT_CAP_SM_PS_DISABLED:
 		break;
 	default:
 		IWL_WARNING("Invalid MIMO PS mode %d\n", mimo_ps_mode);
-- 
1.5.3.6

