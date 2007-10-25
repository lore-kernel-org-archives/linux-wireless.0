Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44560 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbXJYJW7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:59 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mabbas <mabbas@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 22/30] iwl4965: fix driver hang related to hardware scan
Date: Thu, 25 Oct 2007 17:15:43 +0800
Message-Id: <11933037831480-git-send-email-yi.zhu@intel.com> (sfid-20071025_104100_225619_02065AFC)
In-Reply-To: <11933037822284-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
 <1193303762680-git-send-email-yi.zhu@intel.com>
 <11933037641168-git-send-email-yi.zhu@intel.com>
 <11933037663659-git-send-email-yi.zhu@intel.com>
 <11933037674045-git-send-email-yi.zhu@intel.com>
 <11933037692766-git-send-email-yi.zhu@intel.com>
 <1193303770550-git-send-email-yi.zhu@intel.com>
 <11933037721573-git-send-email-yi.zhu@intel.com>
 <1193303773185-git-send-email-yi.zhu@intel.com>
 <11933037743841-git-send-email-yi.zhu@intel.com>
 <11933037762104-git-send-email-yi.zhu@intel.com>
 <11933037784073-git-send-email-yi.zhu@intel.com>
 <11933037794199-git-send-email-yi.zhu@intel.com>
 <11933037812209-git-send-email-yi.zhu@intel.com>
 <11933037822284-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: mabbas <mabbas@linux.intel.com>

This patch fix the following:
1. make sure we are not scanning before we call REPLY_RXON
2. set RXON_FILTER_ASSOC_MSK only after we receive association response
3. call scan abort on scan watchdog instead of restart

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   24 ++++++++++++++++++++----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 674362d..541ace9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3865,7 +3865,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 			 */
 		case IEEE80211_STYPE_ASSOC_RESP:
 		case IEEE80211_STYPE_REASSOC_RESP:
-			if (network_packet && iwl_is_associated(priv)) {
+			if (network_packet) {
 #ifdef CONFIG_IWLWIFI_HT
 				u8 *pos = NULL;
 				struct ieee802_11_elems elems;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index dc2d25c..bf93db5 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6831,8 +6831,9 @@ static void iwl_bg_scan_check(struct work_struct *data)
 		IWL_DEBUG(IWL_DL_INFO | IWL_DL_SCAN,
 			  "Scan completion watchdog resetting adapter (%dms)\n",
 			  jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));
+
 		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
-			queue_work(priv->workqueue, &priv->restart);
+			iwl_send_scan_abort(priv);
 	}
 	mutex_unlock(&priv->mutex);
 }
@@ -6928,7 +6929,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		spin_unlock_irqrestore(&priv->lock, flags);
 
 		scan->suspend_time = 0;
-		scan->max_out_time = cpu_to_le32(600 * 1024);
+		scan->max_out_time = cpu_to_le32(200 * 1024);
 		if (!interval)
 			interval = suspend_time;
 
@@ -7102,6 +7103,8 @@ static void iwl_bg_post_associate(struct work_struct *data)
 
 	mutex_lock(&priv->mutex);
 
+	iwl_scan_cancel_timeout(priv, 200);
+
 	conf = ieee80211_get_hw_conf(priv->hw);
 
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
@@ -7554,8 +7557,6 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 		if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
 			iwl_config_ap(priv);
 		else {
-			priv->staging_rxon.filter_flags |=
-						RXON_FILTER_ASSOC_MSK;
 			rc = iwl_commit_rxon(priv);
 			if ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && rc)
 				iwl_rxon_add_station(
@@ -7563,6 +7564,7 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 		}
 
 	} else {
+		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl_commit_rxon(priv);
 	}
@@ -7623,6 +7625,7 @@ static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 
 	IWL_DEBUG_MAC80211("enter\n");
 
+	mutex_lock(&priv->mutex);
 	spin_lock_irqsave(&priv->lock, flags);
 
 	if (!iwl_is_ready_rf(priv)) {
@@ -7661,6 +7664,7 @@ static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 
 out_unlock:
 	spin_unlock_irqrestore(&priv->lock, flags);
+	mutex_unlock(&priv->mutex);
 
 	return rc;
 }
@@ -7693,6 +7697,8 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	mutex_lock(&priv->mutex);
 
+	iwl_scan_cancel_timeout(priv, 100);
+
 	switch (cmd) {
 	case  SET_KEY:
 		rc = iwl_update_sta_key_info(priv, key, sta_id);
@@ -7883,8 +7889,18 @@ static void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	/* we are restarting association process
+	 * clear RXON_FILTER_ASSOC_MSK bit
+	 */
+	if (priv->iw_mode != IEEE80211_IF_TYPE_AP) {
+		iwl_scan_cancel_timeout(priv, 100);
+		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		iwl_commit_rxon(priv);
+	}
+
 	/* Per mac80211.h: This is only used in IBSS mode... */
 	if (priv->iw_mode != IEEE80211_IF_TYPE_IBSS) {
+
 		IWL_DEBUG_MAC80211("leave - not in IBSS\n");
 		mutex_unlock(&priv->mutex);
 		return;
-- 
1.5.2
