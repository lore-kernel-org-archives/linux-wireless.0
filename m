Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59778 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbZBRXuV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 18:50:21 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/8] iwl3945: use iwl_mac_hw_scan callback
Date: Wed, 18 Feb 2009 15:54:27 -0800
Message-Id: <1235001273-7808-3-git-send-email-reinette.chatre@intel.com> (sfid-20090219_005041_852059_02E10ACB)
In-Reply-To: <1235001273-7808-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1235001273-7808-1-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

3945 can use iwl_mac_hw_scan callback instead of
iwl3945_mac_hw_scan callback.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   65 ------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   68 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   94 +--------------------------
 4 files changed, 70 insertions(+), 158 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 50f8c7f..0027a77 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2674,71 +2674,6 @@ static void iwl_bss_info_changed(struct ieee80211_hw *hw,
 
 }
 
-static int iwl_mac_hw_scan(struct ieee80211_hw *hw,
-			   struct cfg80211_scan_request *req)
-{
-	unsigned long flags;
-	struct iwl_priv *priv = hw->priv;
-	int ret;
-	u8 *ssid = NULL;
-	size_t ssid_len = 0;
-
-	if (req->n_ssids) {
-		ssid = req->ssids[0].ssid;
-		ssid_len = req->ssids[0].ssid_len;
-	}
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	mutex_lock(&priv->mutex);
-	spin_lock_irqsave(&priv->lock, flags);
-
-	if (!iwl_is_ready_rf(priv)) {
-		ret = -EIO;
-		IWL_DEBUG_MAC80211(priv, "leave - not ready or exit pending\n");
-		goto out_unlock;
-	}
-
-	/* We don't schedule scan within next_scan_jiffies period.
-	 * Avoid scanning during possible EAPOL exchange, return
-	 * success immediately.
-	 */
-	if (priv->next_scan_jiffies &&
-	    time_after(priv->next_scan_jiffies, jiffies)) {
-		IWL_DEBUG_SCAN(priv, "scan rejected: within next scan period\n");
-		queue_work(priv->workqueue, &priv->scan_completed);
-		ret = 0;
-		goto out_unlock;
-	}
-
-	/* if we just finished scan ask for delay */
-	if (iwl_is_associated(priv) && priv->last_scan_jiffies &&
-	    time_after(priv->last_scan_jiffies + IWL_DELAY_NEXT_SCAN, jiffies)) {
-		IWL_DEBUG_SCAN(priv, "scan rejected: within previous scan period\n");
-		queue_work(priv->workqueue, &priv->scan_completed);
-		ret = 0;
-		goto out_unlock;
-	}
-
-	if (ssid_len) {
-		priv->one_direct_scan = 1;
-		priv->direct_ssid_len = ssid_len;
-		memcpy(priv->direct_ssid, ssid, priv->direct_ssid_len);
-	} else {
-		priv->one_direct_scan = 0;
-	}
-
-	ret = iwl_scan_initiate(priv);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-out_unlock:
-	spin_unlock_irqrestore(&priv->lock, flags);
-	mutex_unlock(&priv->mutex);
-
-	return ret;
-}
-
 static void iwl_mac_update_tkip_key(struct ieee80211_hw *hw,
 			struct ieee80211_key_conf *keyconf, const u8 *addr,
 			u32 iv32, u16 *phase1key)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 10ee20c..f3aa07c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -345,6 +345,7 @@ void iwl_init_scan_params(struct iwl_priv *priv);
 int iwl_scan_cancel(struct iwl_priv *priv);
 int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
 int iwl_scan_initiate(struct iwl_priv *priv);
+int iwl_mac_hw_scan(struct ieee80211_hw *hw, struct cfg80211_scan_request *req);
 u16 iwl_fill_probe_req(struct iwl_priv *priv, enum ieee80211_band band,
 		       struct ieee80211_mgmt *frame, int left);
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 1ec2b20..23644cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -440,6 +440,74 @@ int iwl_scan_initiate(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_scan_initiate);
 
+#define IWL_DELAY_NEXT_SCAN (HZ*2)
+
+int iwl_mac_hw_scan(struct ieee80211_hw *hw,
+		     struct cfg80211_scan_request *req)
+{
+	unsigned long flags;
+	struct iwl_priv *priv = hw->priv;
+	int ret;
+	u8 *ssid = NULL;
+	size_t ssid_len = 0;
+
+	if (req->n_ssids) {
+		ssid = req->ssids[0].ssid;
+		ssid_len = req->ssids[0].ssid_len;
+	}
+
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	mutex_lock(&priv->mutex);
+	spin_lock_irqsave(&priv->lock, flags);
+
+	if (!iwl_is_ready_rf(priv)) {
+		ret = -EIO;
+		IWL_DEBUG_MAC80211(priv, "leave - not ready or exit pending\n");
+		goto out_unlock;
+	}
+
+	/* We don't schedule scan within next_scan_jiffies period.
+	 * Avoid scanning during possible EAPOL exchange, return
+	 * success immediately.
+	 */
+	if (priv->next_scan_jiffies &&
+	    time_after(priv->next_scan_jiffies, jiffies)) {
+		IWL_DEBUG_SCAN(priv, "scan rejected: within next scan period\n");
+		queue_work(priv->workqueue, &priv->scan_completed);
+		ret = 0;
+		goto out_unlock;
+	}
+
+	/* if we just finished scan ask for delay */
+	if (iwl_is_associated(priv) && priv->last_scan_jiffies &&
+	    time_after(priv->last_scan_jiffies + IWL_DELAY_NEXT_SCAN, jiffies)) {
+		IWL_DEBUG_SCAN(priv, "scan rejected: within previous scan period\n");
+		queue_work(priv->workqueue, &priv->scan_completed);
+		ret = 0;
+		goto out_unlock;
+	}
+
+	if (ssid_len) {
+		priv->one_direct_scan = 1;
+		priv->direct_ssid_len =  ssid_len;
+		memcpy(priv->direct_ssid, ssid, priv->direct_ssid_len);
+	} else {
+		priv->one_direct_scan = 0;
+	}
+
+	ret = iwl_scan_initiate(priv);
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+
+out_unlock:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	mutex_unlock(&priv->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(iwl_mac_hw_scan);
+
 #define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)
 
 void iwl_bg_scan_check(struct work_struct *data)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index cbd8871..d348b7d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -726,38 +726,6 @@ static void iwl3945_setup_rxon_timing(struct iwl_priv *priv)
 		le16_to_cpu(priv->rxon_timing.atim_window));
 }
 
-static int iwl3945_scan_initiate(struct iwl_priv *priv)
-{
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_SCAN(priv, "Aborting scan due to not ready.\n");
-		return -EIO;
-	}
-
-	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
-		return -EAGAIN;
-	}
-
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan request while abort pending.  "
-			       "Queuing.\n");
-		return -EAGAIN;
-	}
-
-	IWL_DEBUG_INFO(priv, "Starting scan...\n");
-	if (priv->cfg->sku & IWL_SKU_G)
-		priv->scan_bands |= BIT(IEEE80211_BAND_2GHZ);
-	if (priv->cfg->sku & IWL_SKU_A)
-		priv->scan_bands |= BIT(IEEE80211_BAND_5GHZ);
-	set_bit(STATUS_SCANNING, &priv->status);
-	priv->scan_start = jiffies;
-	priv->scan_pass_start = priv->scan_start;
-
-	queue_work(priv->workqueue, &priv->request_scan);
-
-	return 0;
-}
-
 static int iwl3945_set_mode(struct iwl_priv *priv, int mode)
 {
 	if (mode == NL80211_IFTYPE_ADHOC) {
@@ -4316,66 +4284,6 @@ static void iwl3945_bss_info_changed(struct ieee80211_hw *hw,
 
 }
 
-static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw,
-			       struct cfg80211_scan_request *req)
-{
-	int rc = 0;
-	unsigned long flags;
-	struct iwl_priv *priv = hw->priv;
-	size_t len = 0;
-	u8 *ssid = NULL;
-	DECLARE_SSID_BUF(ssid_buf);
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	if (req->n_ssids) {
-		ssid = req->ssids[0].ssid;
-		len = req->ssids[0].ssid_len;
-	}
-
-	mutex_lock(&priv->mutex);
-	spin_lock_irqsave(&priv->lock, flags);
-
-	if (!iwl_is_ready_rf(priv)) {
-		rc = -EIO;
-		IWL_DEBUG_MAC80211(priv, "leave - not ready or exit pending\n");
-		goto out_unlock;
-	}
-
-	/* we don't schedule scan within next_scan_jiffies period */
-	if (priv->next_scan_jiffies &&
-			time_after(priv->next_scan_jiffies, jiffies)) {
-		rc = -EAGAIN;
-		goto out_unlock;
-	}
-	/* if we just finished scan ask for delay for a broadcast scan */
-	if ((len == 0) && priv->last_scan_jiffies &&
-	    time_after(priv->last_scan_jiffies + IWL_DELAY_NEXT_SCAN,
-		       jiffies)) {
-		rc = -EAGAIN;
-		goto out_unlock;
-	}
-	if (len) {
-		IWL_DEBUG_SCAN(priv, "direct scan for %s [%zd]\n ",
-			       print_ssid(ssid_buf, ssid, len), len);
-
-		priv->one_direct_scan = 1;
-		priv->direct_ssid_len = len;
-		memcpy(priv->direct_ssid, ssid, len);
-	} else
-		priv->one_direct_scan = 0;
-
-	rc = iwl3945_scan_initiate(priv);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-out_unlock:
-	spin_unlock_irqrestore(&priv->lock, flags);
-	mutex_unlock(&priv->mutex);
-
-	return rc;
-}
-
 static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
@@ -5149,7 +5057,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.conf_tx = iwl3945_mac_conf_tx,
 	.reset_tsf = iwl3945_mac_reset_tsf,
 	.bss_info_changed = iwl3945_bss_info_changed,
-	.hw_scan = iwl3945_mac_hw_scan
+	.hw_scan = iwl_mac_hw_scan
 };
 
 static int iwl3945_init_drv(struct iwl_priv *priv)
-- 
1.5.4.3

