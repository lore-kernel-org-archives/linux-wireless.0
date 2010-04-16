Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50641 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583Ab0DPVwm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/21] iwlwifi: rename priv->scan to priv->scan_cmd
Date: Fri, 16 Apr 2010 14:52:23 -0700
Message-Id: <1271454758-14351-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

I keep checking what "priv->scan" is, so rename
it to "priv->scan_cmd" which more clearly tells
us what it is.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   12 ++++++------
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 955315b..3199818 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3400,7 +3400,7 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 	iwl_calib_free_results(priv);
 	iwlcore_free_geos(priv);
 	iwl_free_channel_map(priv);
-	kfree(priv->scan);
+	kfree(priv->scan_cmd);
 }
 
 static struct attribute *iwl_sysfs_entries[] = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a7ffb4f..4007b57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1051,7 +1051,7 @@ struct iwl_priv {
 	/* Scan related variables */
 	unsigned long scan_start;
 	unsigned long scan_start_tsf;
-	void *scan;
+	void *scan_cmd;
 	enum ieee80211_band scan_band;
 	struct cfg80211_scan_request *scan_request;
 	bool is_internal_short_scan;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index cb3601d..18b89d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -680,16 +680,16 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		goto done;
 	}
 
-	if (!priv->scan) {
-		priv->scan = kmalloc(sizeof(struct iwl_scan_cmd) +
-				     IWL_MAX_SCAN_SIZE, GFP_KERNEL);
-		if (!priv->scan) {
+	if (!priv->scan_cmd) {
+		priv->scan_cmd = kmalloc(sizeof(struct iwl_scan_cmd) +
+					 IWL_MAX_SCAN_SIZE, GFP_KERNEL);
+		if (!priv->scan_cmd) {
 			IWL_DEBUG_SCAN(priv,
 				       "fail to allocate memory for scan\n");
 			goto done;
 		}
 	}
-	scan = priv->scan;
+	scan = priv->scan_cmd;
 	memset(scan, 0, sizeof(struct iwl_scan_cmd) + IWL_MAX_SCAN_SIZE);
 
 	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index af32359..0f77397 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2852,15 +2852,15 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		goto done;
 	}
 
-	if (!priv->scan) {
-		priv->scan = kmalloc(sizeof(struct iwl3945_scan_cmd) +
-				     IWL_MAX_SCAN_SIZE, GFP_KERNEL);
-		if (!priv->scan) {
+	if (!priv->scan_cmd) {
+		priv->scan_cmd = kmalloc(sizeof(struct iwl3945_scan_cmd) +
+					 IWL_MAX_SCAN_SIZE, GFP_KERNEL);
+		if (!priv->scan_cmd) {
 			IWL_DEBUG_SCAN(priv, "Fail to allocate scan memory\n");
 			goto done;
 		}
 	}
-	scan = priv->scan;
+	scan = priv->scan_cmd;
 	memset(scan, 0, sizeof(struct iwl3945_scan_cmd) + IWL_MAX_SCAN_SIZE);
 
 	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
@@ -4245,7 +4245,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 
 	iwl_free_channel_map(priv);
 	iwlcore_free_geos(priv);
-	kfree(priv->scan);
+	kfree(priv->scan_cmd);
 	if (priv->ibss_beacon)
 		dev_kfree_skb(priv->ibss_beacon);
 
-- 
1.6.3.3

