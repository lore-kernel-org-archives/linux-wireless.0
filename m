Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab0CJFWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:08 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 22/24] iwlwifi: add internal short scan support for 3945
Date: Tue,  9 Mar 2010 21:21:50 -0800
Message-Id: <1268198512-6572-23-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add internal short scan support for 3945 NIC, This allows 3945 NIC
to support radio reset request like the other series of NICs.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index dd33251..252df12 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2799,7 +2799,6 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		.len = sizeof(struct iwl3945_scan_cmd),
 		.flags = CMD_SIZE_HUGE,
 	};
-	int rc = 0;
 	struct iwl3945_scan_cmd *scan;
 	struct ieee80211_conf *conf = NULL;
 	u8 n_probes = 0;
@@ -2827,7 +2826,6 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
 		IWL_DEBUG_INFO(priv, "Multiple concurrent scan requests  "
 				"Ignoring second request.\n");
-		rc = -EIO;
 		goto done;
 	}
 
@@ -2862,7 +2860,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		priv->scan = kmalloc(sizeof(struct iwl3945_scan_cmd) +
 				     IWL_MAX_SCAN_SIZE, GFP_KERNEL);
 		if (!priv->scan) {
-			rc = -ENOMEM;
+			IWL_DEBUG_SCAN(priv, "Fail to allocate scan memory\n");
 			goto done;
 		}
 	}
@@ -2905,7 +2903,9 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 			       scan_suspend_time, interval);
 	}
 
-	if (priv->scan_request->n_ssids) {
+	if (priv->is_internal_short_scan) {
+		IWL_DEBUG_SCAN(priv, "Start internal passive scan.\n");
+	} else if (priv->scan_request->n_ssids) {
 		int i, p = 0;
 		IWL_DEBUG_SCAN(priv, "Kicking off active scan\n");
 		for (i = 0; i < priv->scan_request->n_ssids; i++) {
@@ -2952,13 +2952,20 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		goto done;
 	}
 
-	scan->tx_cmd.len = cpu_to_le16(
+	if (!priv->is_internal_short_scan) {
+		scan->tx_cmd.len = cpu_to_le16(
 			iwl_fill_probe_req(priv,
 				(struct ieee80211_mgmt *)scan->data,
 				priv->scan_request->ie,
 				priv->scan_request->ie_len,
 				IWL_MAX_SCAN_SIZE - sizeof(*scan)));
-
+	} else {
+		scan->tx_cmd.len = cpu_to_le16(
+			iwl_fill_probe_req(priv,
+				(struct ieee80211_mgmt *)scan->data,
+				NULL, 0,
+				IWL_MAX_SCAN_SIZE - sizeof(*scan)));
+	}
 	/* select Rx antennas */
 	scan->flags |= iwl3945_get_antenna_flags(priv);
 
@@ -2980,8 +2987,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	scan->len = cpu_to_le16(cmd.len);
 
 	set_bit(STATUS_SCAN_HW, &priv->status);
-	rc = iwl_send_cmd_sync(priv, &cmd);
-	if (rc)
+	if (iwl_send_cmd_sync(priv, &cmd))
 		goto done;
 
 	queue_delayed_work(priv->workqueue, &priv->scan_check,
-- 
1.6.3.3

