Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52678 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYE2IhP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:15 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 06/43] iwlwifi: mark 4965 ucode types
Date: Thu, 29 May 2008 16:34:51 +0800
Message-Id: <1212050128-17132-7-git-send-email-yi.zhu@intel.com> (sfid-20080529_103721_276939_A95C2271)
In-Reply-To: <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch marks 4965 ucode types.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index ca9ca92..063ba2e 100644
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

