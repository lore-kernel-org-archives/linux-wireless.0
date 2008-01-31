Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6441 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbYAaGKd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 01:10:33 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Guy Cohen <guy.cohen@intel.com>
Subject: [PATCH 2/5] iwlwifi: Fix MIMO PS mode
Date: Wed, 30 Jan 2008 22:05:13 -0800
Message-Id: <1201759516-28963-3-git-send-email-reinette.chatre@intel.com> (sfid-20080131_061041_327724_6AAA16E5)
In-Reply-To: <1201759516-28963-2-git-send-email-reinette.chatre@intel.com>
References: <1201759516-28963-1-git-send-email-reinette.chatre@intel.com>
 <1201759516-28963-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch setups correctly MIMO PS mode flags

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   23 ++++++++++++++++++-----
 include/linux/ieee80211.h               |    6 ++++++
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 5bcee0d..79545d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4317,17 +4317,30 @@ void iwl4965_set_ht_add_station(struct iwl4965_priv *priv, u8 index,
 				struct ieee80211_ht_info *sta_ht_inf)
 {
 	__le32 sta_flags;
+	u8 mimo_ps_mode;
 
 	if (!sta_ht_inf || !sta_ht_inf->ht_supported)
 		goto done;
 
+	mimo_ps_mode = (sta_ht_inf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2;
+
 	sta_flags = priv->stations[index].sta.station_flags;
 
-	if (((sta_ht_inf->cap & IEEE80211_HT_CAP_MIMO_PS >> 2))
-						== IWL_MIMO_PS_DYNAMIC)
+	sta_flags &= ~(STA_FLG_RTS_MIMO_PROT_MSK | STA_FLG_MIMO_DIS_MSK);
+
+	switch (mimo_ps_mode) {
+	case WLAN_HT_CAP_MIMO_PS_STATIC:
+		sta_flags |= STA_FLG_MIMO_DIS_MSK;
+		break;
+	case WLAN_HT_CAP_MIMO_PS_DYNAMIC:
 		sta_flags |= STA_FLG_RTS_MIMO_PROT_MSK;
-	else
-		sta_flags &= ~STA_FLG_RTS_MIMO_PROT_MSK;
+		break;
+	case WLAN_HT_CAP_MIMO_PS_DISABLED:
+		break;
+	default:
+		IWL_WARNING("Invalid MIMO PS mode %d", mimo_ps_mode);
+		break;
+	}
 
 	sta_flags |= cpu_to_le32(
 	      (u32)sta_ht_inf->ampdu_factor << STA_FLG_MAX_AGG_SIZE_POS);
@@ -4338,7 +4351,7 @@ void iwl4965_set_ht_add_station(struct iwl4965_priv *priv, u8 index,
 	if (iwl4965_is_fat_tx_allowed(priv, sta_ht_inf))
 		sta_flags |= STA_FLG_FAT_EN_MSK;
 	else
-		sta_flags &= (~STA_FLG_FAT_EN_MSK);
+		sta_flags &= ~STA_FLG_FAT_EN_MSK;
 
 	priv->stations[index].sta.station_flags = sta_flags;
  done:
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 5de6d91..f577c8f 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -287,6 +287,12 @@ struct ieee80211_ht_addt_info {
 #define IEEE80211_HT_IE_NON_GF_STA_PRSNT	0x0004
 #define IEEE80211_HT_IE_NON_HT_STA_PRSNT	0x0010
 
+/* MIMO Power Save Modes */
+#define WLAN_HT_CAP_MIMO_PS_STATIC         0
+#define WLAN_HT_CAP_MIMO_PS_DYNAMIC        1
+#define WLAN_HT_CAP_MIMO_PS_INVALID        2
+#define WLAN_HT_CAP_MIMO_PS_DISABLED       3
+
 /* Authentication algorithms */
 #define WLAN_AUTH_OPEN 0
 #define WLAN_AUTH_SHARED_KEY 1
-- 
1.5.3.4

