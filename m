Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20126 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757774AbZEHUi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 16:38:26 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/11 v2.6.30 and w-t] iwlwifi: fix device id registration for 6000 series 2x2 devices
Date: Fri,  8 May 2009 13:44:46 -0700
Message-Id: <1241815486-13510-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241815486-13510-11-git-send-email-reinette.chatre@intel.com>
References: <1241815486-13510-1-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-2-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-3-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-4-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-5-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-6-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-7-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-8-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-9-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-10-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

Add device ids for 2x2 devices. Also fix antenna usage because these devices use
antennas A and B, not B and C.

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index ee271d7..7236382 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -102,8 +102,8 @@ struct iwl_cfg iwl6000_2agn_cfg = {
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
-	.valid_tx_ant = ANT_BC,
-	.valid_rx_ant = ANT_BC,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = false,
 };
 
@@ -118,8 +118,8 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
-	.valid_tx_ant = ANT_BC,
-	.valid_rx_ant = ANT_BC,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = false,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3ebf6cf..596977d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2944,7 +2944,9 @@ static struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x0085, 0x1112, iwl6000_2ag_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1122, iwl6000_2ag_cfg)},
 	{IWL_PCI_DEVICE(0x422B, PCI_ANY_ID, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x422C, PCI_ANY_ID, iwl6000_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x4238, PCI_ANY_ID, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x4239, PCI_ANY_ID, iwl6000_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0082, PCI_ANY_ID, iwl6000_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0085, PCI_ANY_ID, iwl6000_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x0086, PCI_ANY_ID, iwl6050_3agn_cfg)},
-- 
1.5.6.3

