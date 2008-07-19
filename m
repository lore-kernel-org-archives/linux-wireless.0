Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55510 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbYGSBl3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 21:41:29 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 05/13 V2] iwlwifi: use dtim_period from association, and set listen_interval
Date: Sat, 19 Jul 2008 04:41:24 +0300
Message-Id: <1216431684-10598-1-git-send-email-tomas.winkler@intel.com> (sfid-20080719_034148_114186_0E5EA3D6)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uses dtim_period from association, and sets the listen_interval.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    3 +--
 drivers/net/wireless/iwlwifi/iwl-core.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index cd6d668..5e57f3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -666,8 +666,7 @@ struct iwl4965_rxon_assoc_cmd {
 	__le16 reserved;
 } __attribute__ ((packed));
 
-
-
+#define IWL_CONN_MAX_LISTEN_INTERVAL	10
 
 /*
  * REPLY_RXON_TIMING = 0x14 (command, has simple generic response)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 7fa0e91..344c33a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -828,6 +828,7 @@ int iwl_setup_mac(struct iwl_priv *priv)
 		hw->ampdu_queues = priv->cfg->mod_params->num_of_ampdu_queues;
 
 	hw->conf.beacon_int = 100;
+	hw->max_listen_interval = IWL_CONN_MAX_LISTEN_INTERVAL;
 
 	if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
 		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 38488c0..7ca01cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -639,7 +639,6 @@ static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 }
 
 #define MAX_UCODE_BEACON_INTERVAL	4096
-#define INTEL_CONN_LISTEN_INTERVAL	__constant_cpu_to_le16(0xA)
 
 static __le16 iwl4965_adjust_beacon_interval(u16 beacon_val)
 {
@@ -669,7 +668,7 @@ static void iwl4965_setup_rxon_timing(struct iwl_priv *priv)
 	priv->rxon_timing.timestamp.dw[0] =
 				cpu_to_le32(priv->timestamp & 0xFFFFFFFF);
 
-	priv->rxon_timing.listen_interval = INTEL_CONN_LISTEN_INTERVAL;
+	priv->rxon_timing.listen_interval = cpu_to_le16(conf->listen_interval);
 
 	tsf = priv->timestamp;
 
@@ -2835,6 +2834,7 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 
 	spin_lock_irqsave(&priv->lock, flags);
 
+
 	/* if we are switching from ht to 2.4 clear flags
 	 * from any ht related info since 2.4 does not
 	 * support ht */
@@ -3151,6 +3151,7 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 		if (bss_conf->assoc) {
 			priv->assoc_id = bss_conf->aid;
 			priv->beacon_int = bss_conf->beacon_int;
+			priv->power_data.dtim_period = bss_conf->dtim_period;
 			priv->timestamp = bss_conf->timestamp;
 			priv->assoc_capability = bss_conf->assoc_capability;
 			priv->next_scan_jiffies = jiffies +
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

