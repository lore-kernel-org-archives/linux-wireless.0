Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6916 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758556AbYDXSzo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 04/21] iwlwifi: remove unnecessary apmg settings
Date: Thu, 24 Apr 2008 11:55:21 -0700
Message-Id: <1209063338-6572-5-git-send-email-reinette.chatre@intel.com> (sfid-20080424_205623_128803_80913FA3)
In-Reply-To: <1209063338-6572-4-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch remove settings of APMG_PS_CTRL_VAL_RESET_REQ
from 4965 this should be used only for 3945

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 2587773..a98f00f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -621,19 +621,6 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
 		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret < 0) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		IWL_DEBUG_INFO("Failed to init the card\n");
-		return ret;
-	}
-
-	iwl_read_prph(priv, APMG_PS_CTRL_REG);
-	iwl_set_bits_prph(priv, APMG_PS_CTRL_REG, APMG_PS_CTRL_VAL_RESET_REQ);
-	udelay(5);
-	iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG, APMG_PS_CTRL_VAL_RESET_REQ);
-
-	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	iwl4965_hw_card_show_info(priv);
-- 
1.5.3.4

