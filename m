Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:14165 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbZH1Qou (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 12:44:50 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/5] iwlwifi: fix situation in which debug message is printed
Date: Fri, 28 Aug 2009 09:44:49 -0700
Message-Id: <1251477889-13732-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1251477889-13732-1-git-send-email-reinette.chatre@intel.com>
References: <1251477889-13732-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

3945 does not have update_chain_flags defined and because if this we always
see the debug message that does not apply to it. Add a check to be specific
about what is actually happening.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 081a7ea..4ec6a83 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -321,7 +321,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 			if (priv->cfg->ops->lib->update_chain_flags &&
 			    update_chains)
 				priv->cfg->ops->lib->update_chain_flags(priv);
-			else
+			else if (priv->cfg->ops->lib->update_chain_flags)
 				IWL_DEBUG_POWER(priv,
 					"Cannot update the power, chain noise "
 					"calibration running: %d\n",
-- 
1.5.6.3

