Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14249 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932566Ab0DPVwl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:41 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/21] iwlwifi: correct atomic bitops usage
Date: Fri, 16 Apr 2010 14:52:20 -0700
Message-Id: <1271454758-14351-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With atomic bitops, test_and_{set,clear}_bit
should be used instead of separate test_bit
and set_bit/clear_bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 3904bb4..7982b19 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -68,9 +68,8 @@ int iwl_scan_cancel(struct iwl_priv *priv)
 	}
 
 	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		if (!test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		if (!test_and_set_bit(STATUS_SCAN_ABORTING, &priv->status)) {
 			IWL_DEBUG_SCAN(priv, "Queuing scan abort.\n");
-			set_bit(STATUS_SCAN_ABORTING, &priv->status);
 			queue_work(priv->workqueue, &priv->abort_scan);
 
 		} else
@@ -227,13 +226,13 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 		       jiffies_to_msecs(elapsed_jiffies
 					(priv->scan_pass_start, jiffies)));
 
-	/* If a request to abort was given, or the scan did not succeed
+	/*
+	 * If a request to abort was given, or the scan did not succeed
 	 * then we reset the scan state machine and terminate,
-	 * re-queuing another scan if one has been requested */
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+	 * re-queuing another scan if one has been requested
+	 */
+	if (test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->status))
 		IWL_DEBUG_INFO(priv, "Aborted scan completed.\n");
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-	}
 
 	if (!priv->is_internal_short_scan)
 		priv->next_scan_jiffies = 0;
-- 
1.6.3.3

