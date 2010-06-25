Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:44617 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756830Ab0FYWnJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 18:43:09 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/8] iwlwifi: update LQ for bcast station on channel change
Date: Fri, 25 Jun 2010 15:42:57 -0700
Message-Id: <1277505781-25268-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
References: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Halperin <dhalperi@cs.washington.edu>

The rate table in the bcast LQ is computed only when the station is
allocated, and chooses the lowest rate for the band. Because of when this
occurs, this is the 2.4 GHz band and uses the 0x420a (CCK, 1 Mbps) rate. In 5 GHz
beaconing mode, this rate will prevent beacons from being sent and any other
packets from being received.

We can fix this by re-initializing the bcast station's LQ command when the
channel is changed.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-6000.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 +++
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-sta.c  |   30 ++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.h  |    1 +
 8 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 24743b9..1daf159 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -217,6 +217,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 		.set_ct_kill = iwl1000_set_ct_threshold,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
+	.update_bcast_station = iwl_update_bcast_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 67526a1..1dd3bc4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2280,6 +2280,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.set_ct_kill = iwl4965_set_ct_threshold,
 	},
 	.manage_ibss_station = iwlagn_manage_ibss_station,
+	.update_bcast_station = iwl_update_bcast_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index fa2dbb5..b8f3e20 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -393,6 +393,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 		.set_ct_kill = iwl5000_set_ct_threshold,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
+	.update_bcast_station = iwl_update_bcast_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
@@ -455,6 +456,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 		.set_ct_kill = iwl5150_set_ct_threshold,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
+	.update_bcast_station = iwl_update_bcast_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index c909a9c..61cf0b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -318,6 +318,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.set_calib_version = iwl6000_set_calib_version,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
+	.update_bcast_station = iwl_update_bcast_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 329e510..f47a58f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2110,6 +2110,9 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		iwl_set_flags_for_band(priv, conf->channel->band, priv->vif);
 		spin_unlock_irqrestore(&priv->lock, flags);
 
+		if (priv->cfg->ops->lib->update_bcast_station)
+			ret = priv->cfg->ops->lib->update_bcast_station(priv);
+
  set_ch_out:
 		/* The list of supported rates and rate mask can be different
 		 * for each band; since the band may have changed, reset
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index cdcb51d..15930e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -196,6 +196,7 @@ struct iwl_lib_ops {
 	/* station management */
 	int (*manage_ibss_station)(struct iwl_priv *priv,
 				   struct ieee80211_vif *vif, bool add);
+	int (*update_bcast_station)(struct iwl_priv *priv);
 	/* recover from tx queue stall */
 	void (*recover_from_tx_stall)(unsigned long data);
 	/* check for plcp health */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 6a9cd08..9511f03 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1259,6 +1259,36 @@ int iwl_alloc_bcast_station(struct iwl_priv *priv, bool init_lq)
 }
 EXPORT_SYMBOL_GPL(iwl_alloc_bcast_station);
 
+/**
+ * iwl_update_bcast_station - update broadcast station's LQ command
+ *
+ * Only used by iwlagn. Placed here to have all bcast station management
+ * code together.
+ */
+int iwl_update_bcast_station(struct iwl_priv *priv)
+{
+	unsigned long flags;
+	struct iwl_link_quality_cmd *link_cmd;
+	u8 sta_id = priv->hw_params.bcast_sta_id;
+
+	link_cmd = iwl_sta_alloc_lq(priv, sta_id);
+	if (!link_cmd) {
+		IWL_ERR(priv, "Unable to initialize rate scaling for bcast station.\n");
+		return -ENOMEM;
+	}
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	if (priv->stations[sta_id].lq)
+		kfree(priv->stations[sta_id].lq);
+	else
+		IWL_DEBUG_INFO(priv, "Bcast station rate scaling has not been initialized yet.\n");
+	priv->stations[sta_id].lq = link_cmd;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iwl_update_bcast_station);
+
 void iwl_dealloc_bcast_station(struct iwl_priv *priv)
 {
 	unsigned long flags;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 619bb99..ba95b1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -60,6 +60,7 @@ void iwl_restore_stations(struct iwl_priv *priv);
 void iwl_clear_ucode_stations(struct iwl_priv *priv);
 int iwl_alloc_bcast_station(struct iwl_priv *priv, bool init_lq);
 void iwl_dealloc_bcast_station(struct iwl_priv *priv);
+int iwl_update_bcast_station(struct iwl_priv *priv);
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags);
-- 
1.7.0.4

