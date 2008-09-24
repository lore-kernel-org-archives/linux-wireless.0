Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29095 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbYIXGC2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 02:02:28 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] iwlwifi: don't fail if scan is issued too early
Date: Wed, 24 Sep 2008 13:57:46 +0800
Message-Id: <1222235866-19805-2-git-send-email-yi.zhu@intel.com> (sfid-20080924_080233_513536_F77131DD)
In-Reply-To: <1222235866-19805-1-git-send-email-yi.zhu@intel.com>
References: <1222235866-19805-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch returns success and empty scan on scans requests that were
rejected because issued too early. The cached bss list from previous
scanning will be returned by mac80211.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   15 +++++++++++----
 drivers/net/wireless/iwlwifi/iwl-scan.c |    8 +-------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c31adf6..e6d742f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3190,9 +3190,9 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 
 static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t ssid_len)
 {
-	int ret;
 	unsigned long flags;
 	struct iwl_priv *priv = hw->priv;
+	int ret;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -3211,20 +3211,27 @@ static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t ssid_len)
 		goto out_unlock;
 	}
 
-	/* we don't schedule scan within next_scan_jiffies period */
+	/* We don't schedule scan within next_scan_jiffies period.
+	 * Avoid scanning during possible EAPOL exchange, return
+	 * success immediately.
+	 */
 	if (priv->next_scan_jiffies &&
 	    time_after(priv->next_scan_jiffies, jiffies)) {
 		IWL_DEBUG_SCAN("scan rejected: within next scan period\n");
-		ret = -EAGAIN;
+		queue_work(priv->workqueue, &priv->scan_completed);
+		ret = 0;
 		goto out_unlock;
 	}
+
 	/* if we just finished scan ask for delay */
 	if (iwl_is_associated(priv) && priv->last_scan_jiffies &&
 	    time_after(priv->last_scan_jiffies + IWL_DELAY_NEXT_SCAN, jiffies)) {
 		IWL_DEBUG_SCAN("scan rejected: within previous scan period\n");
-		ret = -EAGAIN;
+		queue_work(priv->workqueue, &priv->scan_completed);
+		ret = 0;
 		goto out_unlock;
 	}
+
 	if (ssid_len) {
 		priv->one_direct_scan = 1;
 		priv->direct_ssid_len =  min_t(u8, ssid_len, IW_ESSID_MAX_SIZE);
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 09c264b..bf855c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -463,11 +463,6 @@ void iwl_init_scan_params(struct iwl_priv *priv)
 
 int iwl_scan_initiate(struct iwl_priv *priv)
 {
-	if (priv->iw_mode == NL80211_IFTYPE_AP) {
-		IWL_ERROR("APs don't scan.\n");
-		return 0;
-	}
-
 	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_SCAN("Aborting scan due to not ready.\n");
 		return -EIO;
@@ -479,8 +474,7 @@ int iwl_scan_initiate(struct iwl_priv *priv)
 	}
 
 	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN("Scan request while abort pending.  "
-			       "Queuing.\n");
+		IWL_DEBUG_SCAN("Scan request while abort pending\n");
 		return -EAGAIN;
 	}
 
-- 
1.5.3.6

