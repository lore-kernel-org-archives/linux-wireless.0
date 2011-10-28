Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6808 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab1J1BLf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 21:11:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.1] iwlwifi: allow pci_enable_msi fail
Date: Thu, 27 Oct 2011 17:19:39 -0700
Message-Id: <1319761179-25277-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111028_031142_688421_ACD8131D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Continue the init process even fail to enable msi

Reported-by: werner <w.landgraf@ru.ru>
Tested-by: werner <w.landgraf@ru.ru>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
hese patches will be also available later from wireless branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git once iwlwifi
account available

 drivers/net/wireless/iwlwifi/iwl-pci.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 2fdbffa..718a722 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -442,10 +442,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
 	err = pci_enable_msi(pdev);
-	if (err) {
-		dev_printk(KERN_ERR, &pdev->dev, "pci_enable_msi failed");
-		goto out_iounmap;
-	}
+	if (err)
+		dev_printk(KERN_ERR, &pdev->dev,
+			"pci_enable_msi failed(0X%x)", err);
 
 	/* TODO: Move this away, not needed if not MSI */
 	/* enable rfkill interrupt: hw bug w/a */
-- 
1.7.0.4

