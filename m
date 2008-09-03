Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbYICDbQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:16 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 16/39] iwlwifi: fix apm_stop function
Date: Wed,  3 Sep 2008 11:26:36 +0800
Message-Id: <1220412419-15404-17-git-send-email-yi.zhu@intel.com> (sfid-20080903_053125_200205_859DD008)
In-Reply-To: <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

The patch fixes CSR_GP_CNTRL_REG_FLAG_INIT_DONE was set instead of
cleared which disabled move device to D0U state.

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

