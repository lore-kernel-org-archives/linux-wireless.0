Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28629 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758971AbZJIUWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:22:08 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/17] iwl3945: remove unnecessary call to apm_ops.reset()
Date: Fri,  9 Oct 2009 13:20:21 -0700
Message-Id: <1255119634-3060-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Now that we're unconditionally using apm_ops.stop() to reset and power-down
the device in __iwl3945_down(), the apm_ops.reset() is redundant.  Removing
this call will also allow us to remove iwl3945_apm_reset().

Remove unneeded iwl_clear_bit(CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ) because
this bit will be set again very soon in iwl3945_hw_txq_ctx_stop() and other
following calls.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index adf4ebe..ab4c4ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2563,11 +2563,6 @@ static void __iwl3945_down(struct iwl_priv *priv)
 			test_bit(STATUS_EXIT_PENDING, &priv->status) <<
 				STATUS_EXIT_PENDING;
 
-	priv->cfg->ops->lib->apm_ops.reset(priv);
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	iwl3945_hw_txq_ctx_stop(priv);
 	iwl3945_hw_rxq_stop(priv);
 
-- 
1.5.6.3

