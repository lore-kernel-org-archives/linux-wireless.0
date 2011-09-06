Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26702 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab1IFRPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 13:15:06 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/10] iwlagn: merge iwl_pci_down and iwl_pci_remove
Date: Tue,  6 Sep 2011 09:31:17 -0700
Message-Id: <1315326685-22213-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110906_191514_968296_9E7D1BEE)
In-Reply-To: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The latter was the only place that called the first. The two
functions were split when the iwl_pci_probe called iwl_pci_down
upon failure in the probe. Since iwl_pci_probe undoes its work by
itself, there is no need to split between iwl_pci_down, and
iwl_pci_remove.

Thanks to Pavel Roskin for pointing that out.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index e41f53e..78a3f8d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -483,9 +483,13 @@ out_no_pci:
 	return err;
 }
 
-static void iwl_pci_down(struct iwl_bus *bus)
+static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
-	struct iwl_pci_bus *pci_bus = (struct iwl_pci_bus *) bus->bus_specific;
+	struct iwl_shared *shrd = pci_get_drvdata(pdev);
+	struct iwl_bus *bus = shrd->bus;
+	struct iwl_pci_bus *pci_bus = IWL_BUS_GET_PCI_BUS(bus);
+
+	iwl_remove(shrd->priv);
 
 	pci_disable_msi(pci_bus->pci_dev);
 	pci_iounmap(pci_bus->pci_dev, pci_bus->hw_base);
@@ -496,16 +500,6 @@ static void iwl_pci_down(struct iwl_bus *bus)
 	kfree(bus);
 }
 
-static void __devexit iwl_pci_remove(struct pci_dev *pdev)
-{
-	struct iwl_shared *shrd = pci_get_drvdata(pdev);
-	struct iwl_bus *bus = shrd->bus;
-
-	iwl_remove(shrd->priv);
-
-	iwl_pci_down(bus);
-}
-
 #ifdef CONFIG_PM_SLEEP
 
 static int iwl_pci_suspend(struct device *device)
-- 
1.7.0.4

