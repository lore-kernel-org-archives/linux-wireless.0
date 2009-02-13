Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42988 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbZBMTro (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 14:47:44 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Wu, Fengguang" <fengguang.wu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/3] iwlwifi: report correct and detailed values about requested txpower
Date: Fri, 13 Feb 2009 11:51:17 -0800
Message-Id: <1234554679-30186-2-git-send-email-reinette.chatre@intel.com> (sfid-20090213_204750_557142_F42BA5BF)
In-Reply-To: <1234554679-30186-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1234554679-30186-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wu, Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 260bf90..4a51044 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1386,14 +1386,16 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 {
 	int ret = 0;
 	if (tx_power < IWL_TX_POWER_TARGET_POWER_MIN) {
-		IWL_WARN(priv, "Requested user TXPOWER %d below limit.\n",
-			    priv->tx_power_user_lmt);
+		IWL_WARN(priv, "Requested user TXPOWER %d below lower limit %d.\n",
+			 tx_power,
+			 IWL_TX_POWER_TARGET_POWER_MIN);
 		return -EINVAL;
 	}
 
 	if (tx_power > IWL_TX_POWER_TARGET_POWER_MAX) {
-		IWL_WARN(priv, "Requested user TXPOWER %d above limit.\n",
-			    priv->tx_power_user_lmt);
+		IWL_WARN(priv, "Requested user TXPOWER %d above upper limit %d.\n",
+			 tx_power,
+			 IWL_TX_POWER_TARGET_POWER_MAX);
 		return -EINVAL;
 	}
 
-- 
1.5.4.3

