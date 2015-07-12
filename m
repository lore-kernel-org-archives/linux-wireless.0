Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57634 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbbGLRIg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2015 13:08:36 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/10] iwlwifi: edit the 3165 series and 8000 series PCI IDs
Date: Sun, 12 Jul 2015 20:08:17 +0300
Message-Id: <1436720900-18588-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150712_190840_399832_A5E76709)
In-Reply-To: <1436720814.17999.2.camel@intel.com>
References: <1436720814.17999.2.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add new 3165 devices support.
Add one new 8000 series device support.
Remove support for 0x0000, 0xC030 and 0xD030 sub-system IDs
in the 8000 series.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 2ed1e4d..9f65c1c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -368,12 +368,14 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 /* 3165 Series */
 	{IWL_PCI_DEVICE(0x3165, 0x4010, iwl3165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x3165, 0x4012, iwl3165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x3166, 0x4212, iwl3165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x3165, 0x4410, iwl3165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x3165, 0x4510, iwl3165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x3165, 0x4110, iwl3165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x3166, 0x4310, iwl3165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x3166, 0x4210, iwl3165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x3165, 0x8010, iwl3165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x3165, 0x8110, iwl3165_2ac_cfg)},
 
 /* 7265 Series */
 	{IWL_PCI_DEVICE(0x095A, 0x5010, iwl7265_2ac_cfg)},
@@ -426,9 +428,8 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24F4, 0x1130, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F4, 0x1030, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0xC010, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0xC110, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0xD010, iwl8260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x24F4, 0xC030, iwl8260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x24F4, 0xD030, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0xC050, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0xD050, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x8010, iwl8260_2ac_cfg)},
-- 
2.1.4

