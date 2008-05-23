Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51620 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759789AbYEWCLp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:45 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: mark 4965 ucode types
Date: Fri, 23 May 2008 10:09:10 +0800
Message-Id: <1211508569-3163-33-git-send-email-yi.zhu@intel.com> (sfid-20080523_042833_526164_2F8FC2E4)
In-Reply-To: <1211508569-3163-32-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-19-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-21-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-22-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-23-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-24-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-25-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-26-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-27-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-28-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-29-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-30-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-31-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-32-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch marks 4965 ucode types.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index f848a5b..c92742c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -162,9 +162,10 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 
 	/* Tell bootstrap uCode where to find the "Initialize" uCode
 	 *   in host DRAM ... host DRAM physical address bits 35:4 for 4965.
-	 * NOTE:  iwl4965_initialize_alive_start() will replace these values,
+	 * NOTE:  iwl_init_alive_start() will replace these values,
 	 *        after the "initialize" uCode has run, to point to
-	 *        runtime/protocol instructions and backup data cache. */
+	 *        runtime/protocol instructions and backup data cache.
+	 */
 	pinst = priv->ucode_init.p_addr >> 4;
 	pdata = priv->ucode_init_data.p_addr >> 4;
 	inst_len = priv->ucode_init.len;
@@ -220,6 +221,8 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 
 	iwl_release_nic_access(priv);
 
+	priv->ucode_type = UCODE_INIT;
+
 	return 0;
 }
 
@@ -266,6 +269,8 @@ static int iwl4965_set_ucode_ptrs(struct iwl_priv *priv)
 
 	IWL_DEBUG_INFO("Runtime uCode pointers are set.\n");
 
+	priv->ucode_type = UCODE_RT;
+
 	return ret;
 }
 
-- 
1.5.3.6

