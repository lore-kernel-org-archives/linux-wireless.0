Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab0CJFWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:08 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 21/24] iwlwifi: remove unnecessary parameter in scan function
Date: Tue,  9 Mar 2010 21:21:49 -0800
Message-Id: <1268198512-6572-22-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

small change to remove unnecessary "ret" parameter since it not being
used.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index ccad04c..1544d75 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -675,7 +675,6 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	};
 	struct iwl_scan_cmd *scan;
 	struct ieee80211_conf *conf = NULL;
-	int ret = 0;
 	u32 rate_flags = 0;
 	u16 cmd_len;
 	u16 rx_chain = 0;
@@ -708,7 +707,6 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
 		IWL_DEBUG_INFO(priv, "Multiple concurrent scan requests in parallel. "
 			       "Ignoring second request.\n");
-		ret = -EIO;
 		goto done;
 	}
 
@@ -741,7 +739,8 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		priv->scan = kmalloc(sizeof(struct iwl_scan_cmd) +
 				     IWL_MAX_SCAN_SIZE, GFP_KERNEL);
 		if (!priv->scan) {
-			ret = -ENOMEM;
+			IWL_DEBUG_SCAN(priv,
+				       "fail to allocate memory for scan\n");
 			goto done;
 		}
 	}
@@ -908,8 +907,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	scan->len = cpu_to_le16(cmd.len);
 
 	set_bit(STATUS_SCAN_HW, &priv->status);
-	ret = iwl_send_cmd_sync(priv, &cmd);
-	if (ret)
+	if (iwl_send_cmd_sync(priv, &cmd))
 		goto done;
 
 	queue_delayed_work(priv->workqueue, &priv->scan_check,
-- 
1.6.3.3

