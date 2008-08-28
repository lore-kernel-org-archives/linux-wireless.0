Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbYH1J3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 05:29:08 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 06/11] iwlwifi: fix apm_stop
Date: Thu, 28 Aug 2008 17:25:05 +0800
Message-Id: <1219915510-3647-7-git-send-email-yi.zhu@intel.com> (sfid-20080828_112918_237130_3F7D938E)
In-Reply-To: <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

The patch fixes CSR_GP_CNTRL_REG_FLAG_INIT_DONE was set instead of
cleared which disabled moving device to D0U state.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-5000.c |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e258122..23fed32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -474,8 +474,8 @@ static void iwl4965_apm_stop(struct iwl_priv *priv)
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 
 	udelay(10);
-
-	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	/* clear "init complete"  move adapter D0A* --> D0U state */
+	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index cbc01a0..d95fb42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -145,7 +145,8 @@ static void iwl5000_apm_stop(struct iwl_priv *priv)
 
 	udelay(10);
 
-	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	/* clear "init complete"  move adapter D0A* --> D0U state */
+	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
-- 
1.5.3.6

