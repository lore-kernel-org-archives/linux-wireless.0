Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab0CJFWG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:06 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/24] iwlwifi: remove STATUS_MODE_PENDING
Date: Tue,  9 Mar 2010 21:21:43 -0800
Message-Id: <1268198512-6572-16-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since rfkill integration, mac80211 can no
longer add an interface while the hardware
is not ready, so STATUS_MODE_PENDING can
never be set.

Also, remove another superfluous channel
sanity check and return the commit_rxon
return value in case it failed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3 --
 drivers/net/wireless/iwlwifi/iwl-core.c     |   53 ++++++++++-----------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    2 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 --
 5 files changed, 19 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b07c013..6c816d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2144,9 +2144,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
 
 	iwl_power_update_mode(priv, true);
 
-	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
-		iwl_set_mode(priv, priv->iw_mode);
-
 	return;
 
  restart:
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5fa1da1..a962fb3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2275,23 +2275,9 @@ int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(iwl_mac_beacon_update);
 
-int iwl_set_mode(struct iwl_priv *priv, int mode)
+static int iwl_set_mode(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
-	if (mode == NL80211_IFTYPE_ADHOC) {
-		const struct iwl_channel_info *ch_info;
-
-		ch_info = iwl_get_channel_info(priv,
-			priv->band,
-			le16_to_cpu(priv->staging_rxon.channel));
-
-		if (!ch_info || !is_channel_ibss(ch_info)) {
-			IWL_ERR(priv, "channel %d not IBSS channel\n",
-				  le16_to_cpu(priv->staging_rxon.channel));
-			return -EINVAL;
-		}
-	}
-
-	iwl_connection_init_rx_config(priv, mode);
+	iwl_connection_init_rx_config(priv, vif->type);
 
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
 		priv->cfg->ops->hcmd->set_rxon_chain(priv);
@@ -2300,18 +2286,10 @@ int iwl_set_mode(struct iwl_priv *priv, int mode)
 
 	iwl_clear_stations_table(priv);
 
-	/* dont commit rxon if rf-kill is on*/
-	if (!iwl_is_ready_rf(priv))
-		return -EAGAIN;
-
-	iwlcore_commit_rxon(priv);
-
-	return 0;
+	return iwlcore_commit_rxon(priv);
 }
-EXPORT_SYMBOL(iwl_set_mode);
 
-int iwl_mac_add_interface(struct ieee80211_hw *hw,
-				 struct ieee80211_vif *vif)
+int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
 	int err = 0;
@@ -2320,6 +2298,11 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
+	if (WARN_ON(!iwl_is_ready_rf(priv))) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (priv->vif) {
 		IWL_DEBUG_MAC80211(priv, "leave - vif != NULL\n");
 		err = -EOPNOTSUPP;
@@ -2329,15 +2312,17 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw,
 	priv->vif = vif;
 	priv->iw_mode = vif->type;
 
-	if (vif->addr) {
-		IWL_DEBUG_MAC80211(priv, "Set %pM\n", vif->addr);
-		memcpy(priv->mac_addr, vif->addr, ETH_ALEN);
-	}
+	IWL_DEBUG_MAC80211(priv, "Set %pM\n", vif->addr);
+	memcpy(priv->mac_addr, vif->addr, ETH_ALEN);
 
-	if (iwl_set_mode(priv, vif->type) == -EAGAIN)
-		/* we are not ready, will run again when ready */
-		set_bit(STATUS_MODE_PENDING, &priv->status);
+	err = iwl_set_mode(priv, vif);
+	if (err)
+		goto out_err;
+	goto out;
 
+ out_err:
+	priv->vif = NULL;
+	priv->iw_mode = NL80211_IFTYPE_STATION;
  out:
 	mutex_unlock(&priv->mutex);
 
@@ -2347,7 +2332,7 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw,
 EXPORT_SYMBOL(iwl_mac_add_interface);
 
 void iwl_mac_remove_interface(struct ieee80211_hw *hw,
-				     struct ieee80211_vif *vif)
+			      struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f493248..bec00c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -336,7 +336,6 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 				     u32 changes);
 int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb);
 int iwl_commit_rxon(struct iwl_priv *priv);
-int iwl_set_mode(struct iwl_priv *priv, int mode);
 int iwl_mac_add_interface(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif);
 void iwl_mac_remove_interface(struct ieee80211_hw *hw,
@@ -617,7 +616,6 @@ void iwlcore_free_geos(struct iwl_priv *priv);
 #define STATUS_SCAN_HW		15
 #define STATUS_POWER_PMI	16
 #define STATUS_FW_ERROR		17
-#define STATUS_MODE_PENDING	18
 
 
 static inline int iwl_is_ready(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 7bf44f1..fc084dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -560,8 +560,6 @@ static ssize_t iwl_dbgfs_status_read(struct file *file,
 		test_bit(STATUS_POWER_PMI, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_FW_ERROR:\t %d\n",
 		test_bit(STATUS_FW_ERROR, &priv->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_MODE_PENDING:\t %d\n",
-		test_bit(STATUS_MODE_PENDING, &priv->status));
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index bdd5fc7..2fd1b3d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2537,9 +2537,6 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	set_bit(STATUS_READY, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
 
-	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
-		iwl_set_mode(priv, priv->iw_mode);
-
 	return;
 
  restart:
-- 
1.6.3.3

