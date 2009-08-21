Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932645AbZHUUe2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:28 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/14] iwlwifi: do not allow set tx power over channel power limit
Date: Fri, 21 Aug 2009 13:34:15 -0700
Message-Id: <1250886867-4112-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
References: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When setting tx power in sysfs, check against max channel tx power
limit instead of IWL_TX_POWER_TARGET_POWER_MAX.

Different devices have different max tx power limit; using
IWL_TX_POWER_TARGET_POWER_MAX can excess the limitaion and give wrong
information.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 43781dc..faafcae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1708,10 +1708,10 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 		return -EINVAL;
 	}
 
-	if (tx_power > IWL_TX_POWER_TARGET_POWER_MAX) {
-		IWL_WARN(priv, "Requested user TXPOWER %d above upper limit %d.\n",
-			 tx_power,
-			 IWL_TX_POWER_TARGET_POWER_MAX);
+	if (tx_power > priv->tx_power_channel_lmt) {
+		IWL_WARN(priv,
+			"Requested user TXPOWER %d above upper limit %d.\n",
+			 tx_power, priv->tx_power_channel_lmt);
 		return -EINVAL;
 	}
 
-- 
1.5.6.3

