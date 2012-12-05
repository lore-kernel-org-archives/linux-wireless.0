Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:41419 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab2LEU6W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 15:58:22 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so560893yhl.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 12:58:22 -0800 (PST)
Subject: [PATCH 12/12] iwlwifi: Use standard #defines for PCIe Capability ASPM
	fields
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Wed, 05 Dec 2012 13:58:21 -0700
Message-ID: <20121205205821.13851.59050.stgit@bhelgaas.mtv.corp.google.com> (sfid-20121205_215831_436859_0EDF2BD3)
In-Reply-To: <20121205205724.13851.50508.stgit@bhelgaas.mtv.corp.google.com>
References: <20121205205724.13851.50508.stgit@bhelgaas.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the standard #defines rather than creating local definitions for
PCIe Capability ASPM fields.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes.berg@intel.com>
CC: Wey-Yi Guy <wey-yi.w.guy@intel.com>
CC: Intel Linux Wireless <ilw@linux.intel.com>
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 5cd06b3..1dfa6be 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -670,8 +670,6 @@ static void iwl_set_pwr_vmain(struct iwl_trans *trans)
 
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
-#define PCI_CFG_LINK_CTRL_VAL_L0S_EN	0x01
-#define PCI_CFG_LINK_CTRL_VAL_L1_EN	0x02
 
 static void iwl_apm_config(struct iwl_trans *trans)
 {
@@ -688,8 +686,7 @@ static void iwl_apm_config(struct iwl_trans *trans)
 	 */
 
 	pcie_capability_read_word(trans_pcie->pci_dev, PCI_EXP_LNKCTL, &lctl);
-	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
-				PCI_CFG_LINK_CTRL_VAL_L1_EN) {
+	if (lctl & PCI_EXP_LNKCTL_ASPM_L1) {
 		/* L1-ASPM enabled; disable(!) L0S */
 		iwl_set_bit(trans, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
 		dev_printk(KERN_INFO, trans->dev,
@@ -700,7 +697,7 @@ static void iwl_apm_config(struct iwl_trans *trans)
 		dev_printk(KERN_INFO, trans->dev,
 			   "L1 Disabled; Enabling L0S\n");
 	}
-	trans->pm_support = !(lctl & PCI_CFG_LINK_CTRL_VAL_L0S_EN);
+	trans->pm_support = !(lctl & PCI_EXP_LNKCTL_ASPM_L0S);
 }
 
 /*

