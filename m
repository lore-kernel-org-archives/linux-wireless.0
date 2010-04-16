Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50641 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582Ab0DPVwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:46 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 19/21] iwlwifi: don't check monitor for scanning
Date: Fri, 16 Apr 2010 14:52:36 -0700
Message-Id: <1271454758-14351-20-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Monitor mode operation need not (and probably should
not) affect scanning this way since real monitoring
can not properly happen while scanning anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    2 --
 drivers/net/wireless/iwlwifi/iwl-core.c     |    3 +--
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ---
 4 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 2d00e83..ccf3357 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1458,8 +1458,6 @@ void iwlagn_request_scan(struct iwl_priv *priv)
 
 	}
 	scan->tx_cmd.len = cpu_to_le16(cmd_len);
-	if (iwl_is_monitor_mode(priv))
-		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
 
 	scan->filter_flags |= (RXON_FILTER_ACCEPT_GRP_MSK |
 			       RXON_FILTER_BCON_AWARE_MSK);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index aa86ef9..d282bef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -834,11 +834,10 @@ static u8 iwl_count_chain_bitmap(u32 chain_bitmap)
  * never called for monitor mode. The only way mac80211 informs us about
  * monitor mode is through configuring filters (call to configure_filter).
  */
-bool iwl_is_monitor_mode(struct iwl_priv *priv)
+static bool iwl_is_monitor_mode(struct iwl_priv *priv)
 {
 	return !!(priv->staging_rxon.filter_flags & RXON_FILTER_PROMISC_MSK);
 }
-EXPORT_SYMBOL(iwl_is_monitor_mode);
 
 /**
  * iwl_set_rxon_chain - Set up Rx chain usage in "staging" RXON image
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d9ec030..e267a21 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -351,7 +351,6 @@ void iwl_configure_filter(struct ieee80211_hw *hw,
 			  unsigned int changed_flags,
 			  unsigned int *total_flags, u64 multicast);
 int iwl_set_hw_params(struct iwl_priv *priv);
-bool iwl_is_monitor_mode(struct iwl_priv *priv);
 void iwl_post_associate(struct iwl_priv *priv);
 void iwl_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 64b20e7..e7263ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2963,9 +2963,6 @@ void iwl3945_request_scan(struct iwl_priv *priv)
 	/* select Rx antennas */
 	scan->flags |= iwl3945_get_antenna_flags(priv);
 
-	if (iwl_is_monitor_mode(priv))
-		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
-
 	scan->channel_count =
 		iwl3945_get_channels_for_scan(priv, band, is_active, n_probes,
 			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
-- 
1.6.3.3

