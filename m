Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48051 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab0EJW23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 30/47] iwlwifi: remove useless priv->vif check
Date: Mon, 10 May 2010 15:28:01 -0700
Message-Id: <1273530498-11876-31-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This check is not useful, since we now no
longer dereference priv->vif at this spot.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 2655dbd..1fe9d84 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -317,10 +317,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 	update_chains = priv->chain_noise_data.state == IWL_CHAIN_NOISE_DONE ||
 			priv->chain_noise_data.state == IWL_CHAIN_NOISE_ALIVE;
 
-	if (priv->vif)
-		dtimper = priv->hw->conf.ps_dtim_period;
-	else
-		dtimper = 1;
+	dtimper = priv->hw->conf.ps_dtim_period ?: 1;
 
 	if (priv->cfg->broken_powersave)
 		iwl_power_sleep_cam_cmd(priv, &cmd);
-- 
1.6.3.3

