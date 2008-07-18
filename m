Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:54091 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbYGRF4Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 01:56:25 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 05/13] iwlwifi: use dtim_period from association, and set listen_interval
Date: Fri, 18 Jul 2008 13:53:01 +0800
Message-Id: <1216360389-5352-6-git-send-email-yi.zhu@intel.com> (sfid-20080718_075628_051473_4159CBEC)
In-Reply-To: <1216360389-5352-5-git-send-email-yi.zhu@intel.com>
References: <1216360389-5352-1-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-2-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-3-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-4-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch uses dtim_period from association, and sets the listen_interval.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    3 +--
 drivers/net/wireless/iwlwifi/iwl-core.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 6f3555f..74a8397 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -666,8 +666,7 @@ struct iwl4965_rxon_assoc_cmd {
 	__le16 reserved;
 } __attribute__ ((packed));
 
-
-
+#define IWL_CONN_LISTEN_INTERVAL	(0xA)
 
 /*
  * REPLY_RXON_TIMING = 0x14 (command, has simple generic response)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a44188b..b03b9cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -828,6 +828,7 @@ int iwl_setup_mac(struct iwl_priv *priv)
 		hw->ampdu_queues = priv->cfg->mod_params->num_of_ampdu_queues;
 
 	hw->conf.beacon_int = 100;
+	hw->conf.listen_interval = IWL_CONN_LISTEN_INTERVAL;
 
 	if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
 		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 2001b09..217d6c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -608,7 +608,6 @@ static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 }
 
 #define MAX_UCODE_BEACON_INTERVAL	4096
-#define INTEL_CONN_LISTEN_INTERVAL	__constant_cpu_to_le16(0xA)
 
 static __le16 iwl4965_adjust_beacon_interval(u16 beacon_val)
 {
@@ -638,7 +637,8 @@ static void iwl4965_setup_rxon_timing(struct iwl_priv *priv)
 	priv->rxon_timing.timestamp.dw[0] =
 				cpu_to_le32(priv->timestamp & 0xFFFFFFFF);
 
-	priv->rxon_timing.listen_interval = INTEL_CONN_LISTEN_INTERVAL;
+	priv->rxon_timing.listen_interval =
+		cpu_to_le16(priv->hw->conf.listen_interval);
 
 	tsf = priv->timestamp;
 
@@ -3102,6 +3102,7 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 		if (bss_conf->assoc) {
 			priv->assoc_id = bss_conf->aid;
 			priv->beacon_int = bss_conf->beacon_int;
+			priv->power_data.dtim_period = bss_conf->dtim_period;
 			priv->timestamp = bss_conf->timestamp;
 			priv->assoc_capability = bss_conf->assoc_capability;
 			priv->next_scan_jiffies = jiffies +
-- 
1.5.3.6

