Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:35851 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbcC3OGR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:17 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/43] iwlwifi: mvm: set aux STA ID in scan config
Date: Wed, 30 Mar 2016 17:04:58 +0300
Message-Id: <1459346715-7954-26-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160624_815399_A924B63A)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Auxilary station ID in flag in scan config command wasn't set
although we set the station ID. Add the flag.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 09eb72c..25b007c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -961,6 +961,7 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 					 SCAN_CONFIG_FLAG_ALLOW_CHUB_REQS |
 					 SCAN_CONFIG_FLAG_SET_TX_CHAINS |
 					 SCAN_CONFIG_FLAG_SET_RX_CHAINS |
+					 SCAN_CONFIG_FLAG_SET_AUX_STA_ID |
 					 SCAN_CONFIG_FLAG_SET_ALL_TIMES |
 					 SCAN_CONFIG_FLAG_SET_LEGACY_RATES |
 					 SCAN_CONFIG_FLAG_SET_MAC_ADDR |
-- 
2.5.0

