Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47950 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab1GUP0t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:49 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/25] iwlagn: add comment to warn about WoWLAN in resume / suspend flows
Date: Thu, 21 Jul 2011 07:50:17 -0700
Message-Id: <1311259828-8415-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172707_017956_B3C6AC09)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

WoWLAN may need the NIC even after suspend. One should not do anything to the
NIC in the bus level, since one cannot check whether WoWLAN is enabled or not.
Same for resume.

Add a simple comment to the code to warn about this.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 0b815de..fb7e436 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -508,6 +508,11 @@ static int iwl_pci_suspend(struct device *device)
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct iwl_bus *bus = pci_get_drvdata(pdev);
 
+	/* Before you put code here, think about WoWLAN. You cannot check here
+	 * whether WoWLAN is enabled or not, and your code will run even if
+	 * WoWLAN is enabled - don't kill the NIC, someone may need it in Sx.
+	 */
+
 	return iwl_suspend(bus->drv_data);
 }
 
@@ -516,6 +521,11 @@ static int iwl_pci_resume(struct device *device)
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct iwl_bus *bus = pci_get_drvdata(pdev);
 
+	/* Before you put code here, think about WoWLAN. You cannot check here
+	 * whether WoWLAN is enabled or not, and your code will run even if
+	 * WoWLAN is enabled - the NIC may be alive.
+	 */
+
 	/*
 	 * We disable the RETRY_TIMEOUT register (0x41) to keep
 	 * PCI Tx retries from interfering with C3 CPU state.
-- 
1.7.0.4

