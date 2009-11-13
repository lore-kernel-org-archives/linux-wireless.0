Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31482 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932204AbZKMT4n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:43 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/16] iwl3945: Reset saved POWER_TABLE_CMD in "up"
Date: Fri, 13 Nov 2009 11:56:29 -0800
Message-Id: <1258142198-3223-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Power-saving logic will not re-issue a POWER_TABLE_CMD if a new command
matches the prior one.  This can be bad if we re-start the device due to
e.g. uCode error; the new POWER_TABLE_CMD (required to invoke power-saving)
may match the prior POWER_TABLE_CMD issued before the uCode error.

Ensure the POWER_TABLE_CMD is sent to device when uCode is up.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1e05c91..4325dbf 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2494,7 +2494,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	priv->active_rate = priv->rates_mask;
 	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
 
-	iwl_power_update_mode(priv, false);
+	iwl_power_update_mode(priv, true);
 
 	if (iwl_is_associated(priv)) {
 		struct iwl3945_rxon_cmd *active_rxon =
-- 
1.5.6.3

