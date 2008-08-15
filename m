Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbYHOCEp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 22:04:45 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 03/15] iwlwifi: clean up hw scan handler
Date: Fri, 15 Aug 2008 10:01:08 +0800
Message-Id: <1218765680-8378-4-git-send-email-yi.zhu@intel.com> (sfid-20080815_040450_801435_1D3503AF)
In-Reply-To: <1218765680-8378-3-git-send-email-yi.zhu@intel.com>
References: <1218765680-8378-1-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-2-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch cleans up iwl_mac_hw_scan handler.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   35 ++++++++++++++-----------------
 1 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5262a2d..9798883 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3180,9 +3180,9 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 
 }
 
-static int iwl4965_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
+static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t ssid_len)
 {
-	int rc = 0;
+	int ret;
 	unsigned long flags;
 	struct iwl_priv *priv = hw->priv;
 
@@ -3192,41 +3192,38 @@ static int iwl4965_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 	spin_lock_irqsave(&priv->lock, flags);
 
 	if (!iwl_is_ready_rf(priv)) {
-		rc = -EIO;
+		ret = -EIO;
 		IWL_DEBUG_MAC80211("leave - not ready or exit pending\n");
 		goto out_unlock;
 	}
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {	/* APs don't scan */
-		rc = -EIO;
+		ret = -EIO;
 		IWL_ERROR("ERROR: APs don't scan\n");
 		goto out_unlock;
 	}
 
 	/* we don't schedule scan within next_scan_jiffies period */
 	if (priv->next_scan_jiffies &&
-			time_after(priv->next_scan_jiffies, jiffies)) {
-		rc = -EAGAIN;
+	    time_after(priv->next_scan_jiffies, jiffies)) {
+		ret = -EAGAIN;
 		goto out_unlock;
 	}
 	/* if we just finished scan ask for delay */
-	if (priv->last_scan_jiffies && time_after(priv->last_scan_jiffies +
-				IWL_DELAY_NEXT_SCAN, jiffies)) {
-		rc = -EAGAIN;
+	if (priv->last_scan_jiffies &&
+	    time_after(priv->last_scan_jiffies + IWL_DELAY_NEXT_SCAN, jiffies)) {
+		ret = -EAGAIN;
 		goto out_unlock;
 	}
-	if (len) {
-		IWL_DEBUG_SCAN("direct scan for %s [%d]\n ",
-			       iwl_escape_essid(ssid, len), (int)len);
-
+	if (ssid_len) {
 		priv->one_direct_scan = 1;
-		priv->direct_ssid_len = (u8)
-		    min((u8) len, (u8) IW_ESSID_MAX_SIZE);
+		priv->direct_ssid_len =  min_t(u8, ssid_len, IW_ESSID_MAX_SIZE);
 		memcpy(priv->direct_ssid, ssid, priv->direct_ssid_len);
-	} else
+	} else {
 		priv->one_direct_scan = 0;
+	}
 
-	rc = iwl_scan_initiate(priv);
+	ret = iwl_scan_initiate(priv);
 
 	IWL_DEBUG_MAC80211("leave\n");
 
@@ -3234,7 +3231,7 @@ out_unlock:
 	spin_unlock_irqrestore(&priv->lock, flags);
 	mutex_unlock(&priv->mutex);
 
-	return rc;
+	return ret;
 }
 
 static void iwl4965_mac_update_tkip_key(struct ieee80211_hw *hw,
@@ -4141,7 +4138,7 @@ static struct ieee80211_ops iwl4965_hw_ops = {
 	.reset_tsf = iwl4965_mac_reset_tsf,
 	.bss_info_changed = iwl4965_bss_info_changed,
 	.ampdu_action = iwl4965_mac_ampdu_action,
-	.hw_scan = iwl4965_mac_hw_scan
+	.hw_scan = iwl_mac_hw_scan
 };
 
 static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
-- 
1.5.3.6

