Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15724 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146Ab0GaQyq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 12:54:46 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 6/8] iwlwifi: track IBSS manager status
Date: Sat, 31 Jul 2010 08:34:10 -0700
Message-Id: <1280590452-10655-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Only the IBSS manager, ie. the station that sent
the IBSS beacon last, should be replying to probe
responses. This requires implementing the mac80211
tx_last_beacon callback, which we can do thanks to
the ucode beacon notification.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 +++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 ++++-
 6 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 32fdc5a..5f7af4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -770,10 +770,10 @@ static void iwl_bg_ucode_trace(unsigned long data)
 static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl4965_beacon_notif *beacon =
 		(struct iwl4965_beacon_notif *)pkt->u.raw;
+#ifdef CONFIG_IWLWIFI_DEBUG
 	u8 rate = iwl_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
 
 	IWL_DEBUG_RX(priv, "beacon status %x retries %d iss %d "
@@ -785,6 +785,8 @@ static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 		le32_to_cpu(beacon->low_tsf), rate);
 #endif
 
+	priv->ibss_manager = le32_to_cpu(beacon->ibss_mgr_status);
+
 	if ((priv->iw_mode == NL80211_IFTYPE_AP) &&
 	    (!test_bit(STATUS_EXIT_PENDING, &priv->status)))
 		queue_work(priv->workqueue, &priv->beacon_update);
@@ -3969,6 +3971,7 @@ static struct ieee80211_ops iwl_hw_ops = {
 	.sta_remove = iwl_mac_sta_remove,
 	.channel_switch = iwl_mac_channel_switch,
 	.flush = iwl_mac_flush,
+	.tx_last_beacon = iwl_mac_tx_last_beacon,
 };
 
 static void iwl_hw_detect(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 60725a5..9435fd9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2919,6 +2919,11 @@ struct iwl_scancomplete_notification {
  *
  *****************************************************************************/
 
+enum iwl_ibss_manager {
+	IWL_NOT_IBSS_MANAGER = 0,
+	IWL_IBSS_MANAGER = 1,
+};
+
 /*
  * BEACON_NOTIFICATION = 0x90 (notification only, not a command)
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 78d8eb8..6ed75e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1601,6 +1601,14 @@ int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 }
 EXPORT_SYMBOL(iwl_mac_conf_tx);
 
+int iwl_mac_tx_last_beacon(struct ieee80211_hw *hw)
+{
+	struct iwl_priv *priv = hw->priv;
+
+	return priv->ibss_manager == IWL_IBSS_MANAGER;
+}
+EXPORT_SYMBOL_GPL(iwl_mac_tx_last_beacon);
+
 static void iwl_ht_conf(struct iwl_priv *priv,
 			struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a166f3a..94f7298 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -358,6 +358,7 @@ struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 void iwl_activate_qos(struct iwl_priv *priv);
 int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		    const struct ieee80211_tx_queue_params *params);
+int iwl_mac_tx_last_beacon(struct ieee80211_hw *hw);
 void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt);
 int iwl_check_rxon_cmd(struct iwl_priv *priv);
 int iwl_full_rxon_required(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 3d9b656..aac7a87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1110,6 +1110,9 @@ struct iwl_priv {
 	u32 ucode_beacon_time;
 	int missed_beacon_threshold;
 
+	/* track IBSS manager (last beacon) status */
+	u32 ibss_manager;
+
 	/* storing the jiffies when the plcp error rate is received */
 	unsigned long plcp_jiffies;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d24eb47..61093dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -816,9 +816,9 @@ static void iwl3945_bg_beacon_update(struct work_struct *work)
 static void iwl3945_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl3945_beacon_notif *beacon = &(pkt->u.beacon_status);
+#ifdef CONFIG_IWLWIFI_DEBUG
 	u8 rate = beacon->beacon_notify_hdr.rate;
 
 	IWL_DEBUG_RX(priv, "beacon status %x retries %d iss %d "
@@ -830,6 +830,8 @@ static void iwl3945_rx_beacon_notif(struct iwl_priv *priv,
 		le32_to_cpu(beacon->low_tsf), rate);
 #endif
 
+	priv->ibss_manager = le32_to_cpu(beacon->ibss_mgr_status);
+
 	if ((priv->iw_mode == NL80211_IFTYPE_AP) &&
 	    (!test_bit(STATUS_EXIT_PENDING, &priv->status)))
 		queue_work(priv->workqueue, &priv->beacon_update);
@@ -3807,6 +3809,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.hw_scan = iwl_mac_hw_scan,
 	.sta_add = iwl3945_mac_sta_add,
 	.sta_remove = iwl_mac_sta_remove,
+	.tx_last_beacon = iwl_mac_tx_last_beacon,
 };
 
 static int iwl3945_init_drv(struct iwl_priv *priv)
-- 
1.7.0.4

