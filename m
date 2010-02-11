Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10247 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799Ab0BKSmO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 13:42:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/12] iwlwifi: fix scan race
Date: Thu, 11 Feb 2010 10:42:00 -0800
Message-Id: <1265913725-4279-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
References: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

There is a problem if an "internal short scan" is in progress when a
mac80211 requested scan arrives. If this new scan request arrives within
the "next_scan_jiffies" period then driver will immediately return success
and complete the scan. The problem here is that the scan has not been
fully initialized at this time (is_internal_short_scan is still set to true
because of the currently running scan), which results in the scan
completion never to be sent to mac80211. At this time also, evan though the
internal short scan is still running the state (is_internal_short_scan)
will be set to false, so when the internal scan does complete then mac80211
will receive a scan completion.

Fix this by checking right away if a scan is in progress when a scan
request arrives from mac80211.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 5014774..dd9ff2e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -469,21 +469,6 @@ EXPORT_SYMBOL(iwl_init_scan_params);
 
 static int iwl_scan_initiate(struct iwl_priv *priv)
 {
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
-		IWL_DEBUG_SCAN(priv, "Scan request while abort pending\n");
-		return -EAGAIN;
-	}
-
 	IWL_DEBUG_INFO(priv, "Starting scan...\n");
 	set_bit(STATUS_SCANNING, &priv->status);
 	priv->is_internal_short_scan = false;
@@ -515,6 +500,18 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
+	if (test_bit(STATUS_SCANNING, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
+	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "Scan request while abort pending\n");
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
 	/* We don't schedule scan within next_scan_jiffies period.
 	 * Avoid scanning during possible EAPOL exchange, return
 	 * success immediately.
-- 
1.6.3.3

