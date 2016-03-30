Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:47797 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbcC3OFu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:50 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/43] iwlwifi: pcie: print error value as signed int
Date: Wed, 30 Mar 2016 17:04:43 +0300
Message-Id: <1459346715-7954-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160554_225904_82E86DF4)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjorn pointed out that printing an error value as an
hexadecimal isn't very convenient. Change that.

Reported-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 007bcb5..28fe220 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1466,7 +1466,7 @@ static void iwl_pcie_set_interrupt_capa(struct pci_dev *pdev,
 
 	ret = pci_enable_msi(pdev);
 	if (ret) {
-		dev_err(&pdev->dev, "pci_enable_msi failed(0X%x)\n", ret);
+		dev_err(&pdev->dev, "pci_enable_msi failed - %d\n", ret);
 		/* enable rfkill interrupt: hw bug w/a */
 		pci_read_config_word(pdev, PCI_COMMAND, &pci_cmd);
 		if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
-- 
2.5.0

