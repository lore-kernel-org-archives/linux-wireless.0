Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13185 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150AbYCECKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 21:10:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Guy Cohen <guy.cohen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 04/11] iwlwifi: 802.11n spec removes AUTO offset for FAT channel
Date: Tue,  4 Mar 2008 18:09:25 -0800
Message-Id: <1204682972-26004-5-git-send-email-reinette.chatre@intel.com> (sfid-20080305_021033_536617_CBFAC823)
In-Reply-To: <1204682972-26004-4-git-send-email-reinette.chatre@intel.com>
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-2-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

This patch adapts to 802.11 patch and remove AUTO offset for FAT
channel

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    8 +++-----
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    9 ++++-----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   10 ++++++++--
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 8b9c419..bb8f002 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4416,7 +4416,7 @@ static u8 iwl4965_is_channel_extension(struct iwl4965_priv *priv,
 	if (!is_channel_valid(ch_info))
 		return 0;
 
-	if (extension_chan_offset == IWL_EXT_CHANNEL_OFFSET_AUTO)
+	if (extension_chan_offset == IWL_EXT_CHANNEL_OFFSET_NONE)
 		return 0;
 
 	if ((ch_info->fat_extension_channel == extension_chan_offset) ||
@@ -4433,7 +4433,7 @@ static u8 iwl4965_is_fat_tx_allowed(struct iwl4965_priv *priv,
 
 	if ((!iwl_ht_conf->is_ht) ||
 	   (iwl_ht_conf->supported_chan_width != IWL_CHANNEL_WIDTH_40MHZ) ||
-	   (iwl_ht_conf->extension_chan_offset == IWL_EXT_CHANNEL_OFFSET_AUTO))
+	   (iwl_ht_conf->extension_chan_offset == IWL_EXT_CHANNEL_OFFSET_NONE))
 		return 0;
 
 	if (sta_ht_inf) {
@@ -4478,9 +4478,7 @@ void iwl4965_set_rxon_ht(struct iwl4965_priv *priv, struct iwl_ht_info *ht_info)
 	case IWL_EXT_CHANNEL_OFFSET_BELOW:
 		rxon->flags |= RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
 		break;
-	case IWL_EXT_CHANNEL_OFFSET_AUTO:
-		rxon->flags &= ~RXON_FLG_CHANNEL_MODE_MIXED_MSK;
-		break;
+	case IWL_EXT_CHANNEL_OFFSET_NONE:
 	default:
 		rxon->flags &= ~RXON_FLG_CHANNEL_MODE_MIXED_MSK;
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 4b3def3..de79816 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -798,11 +798,10 @@ struct iwl4965_kw {
 #define IWL_OPERATION_MODE_MIXED    2
 #define IWL_OPERATION_MODE_20MHZ    3
 
-#define IWL_EXT_CHANNEL_OFFSET_AUTO   0
-#define IWL_EXT_CHANNEL_OFFSET_ABOVE  1
-#define IWL_EXT_CHANNEL_OFFSET_       2
-#define IWL_EXT_CHANNEL_OFFSET_BELOW  3
-#define IWL_EXT_CHANNEL_OFFSET_MAX    4
+#define IWL_EXT_CHANNEL_OFFSET_NONE      0
+#define IWL_EXT_CHANNEL_OFFSET_ABOVE     1
+#define IWL_EXT_CHANNEL_OFFSET_RESERVE1  2
+#define IWL_EXT_CHANNEL_OFFSET_BELOW     3
 
 #define NRG_NUM_PREV_STAT_L     20
 #define NUM_RX_CHAINS           (3)
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 2ed6937..b0f6044 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7957,15 +7957,21 @@ static void iwl4965_ht_info_fill(struct ieee80211_conf *conf,
 	iwl_conf->is_green_field = !!(ht_conf->cap & IEEE80211_HT_CAP_GRN_FLD);
 	iwl_conf->max_amsdu_size =
 		!!(ht_conf->cap & IEEE80211_HT_CAP_MAX_AMSDU);
+
 	iwl_conf->supported_chan_width =
 		!!(ht_conf->cap & IEEE80211_HT_CAP_SUP_WIDTH);
+	iwl_conf->extension_chan_offset =
+		ht_bss_conf->bss_cap & IEEE80211_HT_IE_CHA_SEC_OFFSET;
+	/* If no above or below channel supplied disable FAT channel */
+	if (iwl_conf->extension_chan_offset != IWL_EXT_CHANNEL_OFFSET_ABOVE &&
+	    iwl_conf->extension_chan_offset != IWL_EXT_CHANNEL_OFFSET_BELOW)
+		iwl_conf->supported_chan_width = 0;
+
 	iwl_conf->tx_mimo_ps_mode =
 		(u8)((ht_conf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2);
 	memcpy(iwl_conf->supp_mcs_set, ht_conf->supp_mcs_set, 16);
 
 	iwl_conf->control_channel = ht_bss_conf->primary_channel;
-	iwl_conf->extension_chan_offset =
-		ht_bss_conf->bss_cap & IEEE80211_HT_IE_CHA_SEC_OFFSET;
 	iwl_conf->tx_chan_width =
 		!!(ht_bss_conf->bss_cap & IEEE80211_HT_IE_CHA_WIDTH);
 	iwl_conf->ht_protection =
-- 
1.5.3.4

