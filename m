Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22816 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbYDUWmO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 18:42:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Guy Cohen <guy.cohen@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 07/11] iwlwifi: fix current channel is not scanned
Date: Mon, 21 Apr 2008 15:41:57 -0700
Message-Id: <1208817721-11333-8-git-send-email-reinette.chatre@intel.com> (sfid-20080422_004344_008479_BB43A050)
In-Reply-To: <1208817721-11333-7-git-send-email-reinette.chatre@intel.com>
References: <1208817721-11333-1-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-2-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-3-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-4-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-5-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-6-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

All channels should be scanned, including the current channel
when the client is associated.

Removed also unused flag to scan only active channels.

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   13 -------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   13 -------------
 4 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index fb3247b..fb96c62 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -742,7 +742,6 @@ struct iwl3945_priv {
 	u8 direct_ssid_len;
 	u8 direct_ssid[IW_ESSID_MAX_SIZE];
 	struct iwl3945_scan_cmd *scan;
-	u8 only_active_channel;
 
 	/* spinlock */
 	spinlock_t lock;	/* protect general shared data */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index aaec064..07209f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -998,7 +998,6 @@ struct iwl_priv {
 	u8 direct_ssid_len;
 	u8 direct_ssid[IW_ESSID_MAX_SIZE];
 	struct iwl4965_scan_cmd *scan;
-	u8 only_active_channel;
 
 	/* spinlock */
 	spinlock_t lock;	/* protect general shared data */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 94e6c49..7ba7b33 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4967,17 +4967,6 @@ static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv,
 		if (channels[i].flags & IEEE80211_CHAN_DISABLED)
 			continue;
 
-		if (channels[i].hw_value ==
-		    le16_to_cpu(priv->active_rxon.channel)) {
-			if (iwl3945_is_associated(priv)) {
-				IWL_DEBUG_SCAN
-				    ("Skipping current channel %d\n",
-				     le16_to_cpu(priv->active_rxon.channel));
-				continue;
-			}
-		} else if (priv->only_active_channel)
-			continue;
-
 		scan_ch->channel = channels[i].hw_value;
 
 		ch_info = iwl3945_get_channel_info(priv, band, scan_ch->channel);
@@ -7311,8 +7300,6 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 		return;
 	}
 
-	priv->only_active_channel = 0;
-
 	iwl3945_set_rate(priv);
 
 	mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 53c5c01..e35ab6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4373,17 +4373,6 @@ static int iwl4965_get_channels_for_scan(struct iwl_priv *priv,
 		if (channels[i].flags & IEEE80211_CHAN_DISABLED)
 			continue;
 
-		if (ieee80211_frequency_to_channel(channels[i].center_freq) ==
-		    le16_to_cpu(priv->active_rxon.channel)) {
-			if (iwl_is_associated(priv)) {
-				IWL_DEBUG_SCAN
-				    ("Skipping current channel %d\n",
-				     le16_to_cpu(priv->active_rxon.channel));
-				continue;
-			}
-		} else if (priv->only_active_channel)
-			continue;
-
 		scan_ch->channel = ieee80211_frequency_to_channel(channels[i].center_freq);
 
 		ch_info = iwl_get_channel_info(priv, band,
@@ -6799,8 +6788,6 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 		return;
 	}
 
-	priv->only_active_channel = 0;
-
 	iwl4965_set_rate(priv);
 
 	mutex_unlock(&priv->mutex);
-- 
1.5.3.4

