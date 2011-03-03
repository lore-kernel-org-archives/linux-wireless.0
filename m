Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55925 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758384Ab1CCSgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:36:17 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Fry, Donald H" <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2.6.39] iwlagn: report correct temperature for WiFi/BT devices.
Date: Thu,  3 Mar 2011 10:20:41 -0800
Message-Id: <1299176441-26704-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fry, Donald H <donald.h.fry@intel.com>

The temperature reported by 'cat /sys/class/net/wlan?/device/temperature'
is incorrect for devices with BT capability.  Report the value from the
correct statistics structure.  Tested with 130, 100, 6205 and 5300.

Signed-off-by:  Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index fd142be..87a9fd8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -533,9 +533,10 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 
 void iwlagn_temperature(struct iwl_priv *priv)
 {
-	/* store temperature from statistics (in Celsius) */
-	priv->temperature =
-		le32_to_cpu(priv->_agn.statistics.general.common.temperature);
+	/* store temperature from correct statistics (in Celsius) */
+	priv->temperature = le32_to_cpu((iwl_bt_statistics(priv)) ?
+		priv->_agn.statistics_bt.general.common.temperature :
+		priv->_agn.statistics.general.common.temperature);
 	iwl_tt_handler(priv);
 }
 
-- 
1.7.0.4

