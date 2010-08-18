Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51993 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab0HRQdr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:33:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/2] iwlwifi: do not spuriously call ieee80211_scan_completed
Date: Wed, 18 Aug 2010 09:35:22 -0700
Message-Id: <1282149322-17928-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282149322-17928-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282149322-17928-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a scan is aborted because the corresponding
virtual interface is removed, we may still later
attempt to tell mac80211 that the scan completed.
This is obviously wrong, since we already told it
that it was aborted, so don't do that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index a4b3663..0749363 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -511,6 +511,7 @@ void iwl_bg_scan_completed(struct work_struct *work)
 	struct iwl_priv *priv =
 	    container_of(work, struct iwl_priv, scan_completed);
 	bool internal = false;
+	bool scan_completed = false;
 
 	IWL_DEBUG_SCAN(priv, "SCAN complete scan\n");
 
@@ -521,7 +522,8 @@ void iwl_bg_scan_completed(struct work_struct *work)
 		priv->is_internal_short_scan = false;
 		IWL_DEBUG_SCAN(priv, "internal short scan completed\n");
 		internal = true;
-	} else {
+	} else if (priv->scan_request) {
+		scan_completed = true;
 		priv->scan_request = NULL;
 		priv->scan_vif = NULL;
 	}
@@ -552,7 +554,7 @@ void iwl_bg_scan_completed(struct work_struct *work)
 	 * into driver again into functions that will attempt to take
 	 * mutex.
 	 */
-	if (!internal)
+	if (scan_completed)
 		ieee80211_scan_completed(priv->hw, false);
 }
 EXPORT_SYMBOL(iwl_bg_scan_completed);
-- 
1.7.0.4

