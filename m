Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6991 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab0FUSGr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 14:06:47 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 8/9] iwlwifi: code cleanup to remove un-necessary "goto"
Date: Mon, 21 Jun 2010 11:06:39 -0700
Message-Id: <1277143600-32554-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277143600-32554-1-git-send-email-reinette.chatre@intel.com>
References: <1277143600-32554-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Break out of loop and log the error message when encounter error; this is
better approach than using "goto".

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index d03b5e5..400eb31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -96,14 +96,14 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 			hcmd.len = priv->calib_results[i].buf_len;
 			hcmd.data = priv->calib_results[i].buf;
 			ret = iwl_send_cmd_sync(priv, &hcmd);
-			if (ret)
-				goto err;
+			if (ret) {
+				IWL_ERR(priv, "Error %d iteration %d\n",
+					ret, i);
+				break;
+			}
 		}
 	}
 
-	return 0;
-err:
-	IWL_ERR(priv, "Error %d iteration %d\n", ret, i);
 	return ret;
 }
 
-- 
1.7.0.4

