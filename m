Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab0FFG4p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 20/23] iwlwifi: queue user-initiated scan when doing internal scan
Date: Sat,  5 Jun 2010 23:56:35 -0700
Message-Id: <1275807398-18184-21-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The internal scanning created a problem where
when userspace tries to scan, the scan gets
rejected. Instead of doing that, queue up the
user-initiated scan when doing an internal
scan.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    5 ++++
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-scan.c |   36 +++++++++++++++++++++---------
 3 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 00b2cdd..6cd8d20 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1960,6 +1960,11 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 	}
 	if (priv->vif == vif) {
 		priv->vif = NULL;
+		if (priv->scan_vif == vif) {
+			ieee80211_scan_completed(priv->hw, true);
+			priv->scan_vif = NULL;
+			priv->scan_request = NULL;
+		}
 		memset(priv->bssid, 0, ETH_ALEN);
 	}
 	mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index de326a6..45ceb27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1130,6 +1130,7 @@ struct iwl_priv {
 	void *scan_cmd;
 	enum ieee80211_band scan_band;
 	struct cfg80211_scan_request *scan_request;
+	struct ieee80211_vif *scan_vif;
 	bool is_internal_short_scan;
 	u8 scan_tx_ant[IEEE80211_NUM_BANDS];
 	u8 mgmt_tx_ant;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 0f9cbc2..b8bcd48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -333,7 +333,8 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
-	if (test_bit(STATUS_SCANNING, &priv->status)) {
+	if (test_bit(STATUS_SCANNING, &priv->status) &&
+	    !priv->is_internal_short_scan) {
 		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
 		ret = -EAGAIN;
 		goto out_unlock;
@@ -348,8 +349,16 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 	/* mac80211 will only ask for one band at a time */
 	priv->scan_band = req->channels[0]->band;
 	priv->scan_request = req;
+	priv->scan_vif = vif;
 
-	ret = iwl_scan_initiate(priv, vif);
+	/*
+	 * If an internal scan is in progress, just set
+	 * up the scan_request as per above.
+	 */
+	if (priv->is_internal_short_scan)
+		ret = 0;
+	else
+		ret = iwl_scan_initiate(priv, vif);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
@@ -513,7 +522,21 @@ void iwl_bg_scan_completed(struct work_struct *work)
 		priv->is_internal_short_scan = false;
 		IWL_DEBUG_SCAN(priv, "internal short scan completed\n");
 		internal = true;
+	} else {
+		priv->scan_request = NULL;
+		priv->scan_vif = NULL;
 	}
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		goto out;
+
+	if (internal && priv->scan_request)
+		iwl_scan_initiate(priv, priv->scan_vif);
+
+	/* Since setting the TXPOWER may have been deferred while
+	 * performing the scan, fire one off */
+	iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
+ out:
 	mutex_unlock(&priv->mutex);
 
 	/*
@@ -523,15 +546,6 @@ void iwl_bg_scan_completed(struct work_struct *work)
 	 */
 	if (!internal)
 		ieee80211_scan_completed(priv->hw, false);
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	/* Since setting the TXPOWER may have been deferred while
-	 * performing the scan, fire one off */
-	mutex_lock(&priv->mutex);
-	iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
-	mutex_unlock(&priv->mutex);
 }
 EXPORT_SYMBOL(iwl_bg_scan_completed);
 
-- 
1.7.0.4

