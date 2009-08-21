Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932551AbZHUUe0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:26 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/14] iwlwifi: set default tx power user limit to minimal
Date: Fri, 21 Aug 2009 13:34:14 -0700
Message-Id: <1250886867-4112-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
References: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Set the tx_power_user_lmt to the lowest power level
this value will get overwritten by channel's max power avg
from eeprom

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f1f6dab..43781dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1671,7 +1671,10 @@ int iwl_init_drv(struct iwl_priv *priv)
 	priv->qos_data.qos_cap.val = 0;
 
 	priv->rates_mask = IWL_RATES_MASK;
-	priv->tx_power_user_lmt = IWL_TX_POWER_TARGET_POWER_MAX;
+	/* Set the tx_power_user_lmt to the lowest power level
+	 * this value will get overwritten by channel max power avg
+	 * from eeprom */
+	priv->tx_power_user_lmt = IWL_TX_POWER_TARGET_POWER_MIN;
 
 	ret = iwl_init_channel_map(priv);
 	if (ret) {
-- 
1.5.6.3

