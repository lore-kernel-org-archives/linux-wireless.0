Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44560 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbXJYJXB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:23:01 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 24/30] iwl4965: fix scan problem
Date: Thu, 25 Oct 2007 17:15:45 +0800
Message-Id: <11933037863641-git-send-email-yi.zhu@intel.com> (sfid-20071025_104104_325468_DB28D143)
In-Reply-To: <11933037851697-git-send-email-yi.zhu@intel.com>
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
 <11933037831480-git-send-email-yi.zhu@intel.com>
 <11933037851697-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

This patch fixes the following problems for 4965:
1. Fix direct scan by make sure we set one_direct_scan only when the
   mac80211 ask for direct scan.
2. Fix mac_stop and mac_remove_interface calles, we make sure we cancel any
   scan and disassoc on these call.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   32 +++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index f07643b..05faa0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6952,7 +6952,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		memcpy(scan->direct_scan[0].ssid,
 		       priv->direct_ssid, priv->direct_ssid_len);
 		direct_mask = 1;
-	} else if (!iwl_is_associated(priv)) {
+	} else if (!iwl_is_associated(priv) && priv->essid_len) {
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
@@ -7103,6 +7103,10 @@ static void iwl_bg_post_associate(struct work_struct *data)
 
 	mutex_lock(&priv->mutex);
 
+	if (!priv->interface_id || !priv->is_open) {
+		mutex_unlock(&priv->mutex);
+		return;
+	}
 	iwl_scan_cancel_timeout(priv, 200);
 
 	conf = ieee80211_get_hw_conf(priv->hw);
@@ -7257,9 +7261,19 @@ static void iwl_mac_stop(struct ieee80211_hw *hw)
 	struct iwl_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
+
+
+	mutex_lock(&priv->mutex);
+	/* stop mac, cancel any scan request and clear
+	 * RXON_FILTER_ASSOC_MSK BIT
+	 */
 	priv->is_open = 0;
-	/*netif_stop_queue(dev); */
-	flush_workqueue(priv->workqueue);
+	iwl_scan_cancel_timeout(priv, 100);
+	cancel_delayed_work(&priv->post_associate);
+	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	iwl_commit_rxon(priv);
+	mutex_unlock(&priv->mutex);
+
 	IWL_DEBUG_MAC80211("leave\n");
 }
 
@@ -7604,6 +7618,12 @@ static void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211("enter\n");
 
 	mutex_lock(&priv->mutex);
+
+	iwl_scan_cancel_timeout(priv, 100);
+	cancel_delayed_work(&priv->post_associate);
+	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	iwl_commit_rxon(priv);
+
 	if (priv->interface_id == conf->if_id) {
 		priv->interface_id = 0;
 		memset(priv->bssid, 0, ETH_ALEN);
@@ -7656,7 +7676,8 @@ static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 		priv->direct_ssid_len = (u8)
 		    min((u8) len, (u8) IW_ESSID_MAX_SIZE);
 		memcpy(priv->direct_ssid, ssid, priv->direct_ssid_len);
-	}
+	} else
+		priv->one_direct_scan = 0;
 
 	rc = iwl_scan_initiate(priv);
 
@@ -9146,6 +9167,9 @@ static void iwl_pci_remove(struct pci_dev *pdev)
 		iwl_rate_control_unregister(priv->hw);
 	}
 
+	/*netif_stop_queue(dev); */
+	flush_workqueue(priv->workqueue);
+
 	/* ieee80211_unregister_hw calls iwl_mac_stop, which flushes
 	 * priv->workqueue... so we can't take down the workqueue
 	 * until now... */
-- 
1.5.2
