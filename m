Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:37215 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbZASX2R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:17 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/15] iwlwifi: kill scan39
Date: Mon, 19 Jan 2009 15:30:28 -0800
Message-Id: <1232407835-19451-9-git-send-email-reinette.chatre@intel.com> (sfid-20090120_002830_237080_1A83F304)
In-Reply-To: <1232407835-19451-8-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-2-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-3-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-4-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-5-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-6-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-7-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

scan and scan39 can be represented by void * in iwl_priv

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 +---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   10 +++++-----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4d437cf..5b5e011 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -848,7 +848,7 @@ struct iwl_priv {
 	unsigned long scan_start;
 	unsigned long scan_pass_start;
 	unsigned long scan_start_tsf;
-	struct iwl_scan_cmd *scan;
+	void *scan;
 	int scan_bands;
 	int one_direct_scan;
 	u8 direct_ssid_len;
@@ -1071,8 +1071,6 @@ struct iwl_priv {
 	s8 user_txpower_limit;
 	s8 max_channel_txpower_limit;
 
-	struct iwl3945_scan_cmd *scan39;
-
 	/* We declare this const so it can only be
 	 * changed via explicit cast within the
 	 * routines that actually update the physical
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 67f05bc..47436ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5264,15 +5264,15 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		goto done;
 	}
 
-	if (!priv->scan39) {
-		priv->scan39 = kmalloc(sizeof(struct iwl3945_scan_cmd) +
+	if (!priv->scan) {
+		priv->scan = kmalloc(sizeof(struct iwl3945_scan_cmd) +
 				     IWL_MAX_SCAN_SIZE, GFP_KERNEL);
-		if (!priv->scan39) {
+		if (!priv->scan) {
 			rc = -ENOMEM;
 			goto done;
 		}
 	}
-	scan = priv->scan39;
+	scan = priv->scan;
 	memset(scan, 0, sizeof(struct iwl3945_scan_cmd) + IWL_MAX_SCAN_SIZE);
 
 	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
@@ -7292,7 +7292,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 
 	iwl3945_free_channel_map(priv);
 	iwl3945_free_geos(priv);
-	kfree(priv->scan39);
+	kfree(priv->scan);
 	if (priv->ibss_beacon)
 		dev_kfree_skb(priv->ibss_beacon);
 
-- 
1.5.4.3

