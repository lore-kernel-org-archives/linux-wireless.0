Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18899 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab1J1C2O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 22:28:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.1] iwlwifi: remove un-needed out_iounmap label
Date: Thu, 27 Oct 2011 18:36:18 -0700
Message-Id: <1319765778-8868-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111028_042818_074644_138BAFD0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

out_iounmap is no longer used, remove it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
apply this patch after "iwlwifi-allow-pci_enable_msi-fail.patch"

hese patches will be also available later from wireless branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git once iwlwifi
account available

 drivers/net/wireless/iwlwifi/iwl-pci.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 718a722..32d64e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -465,7 +465,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 out_disable_msi:
 	pci_disable_msi(pdev);
-out_iounmap:
 	pci_iounmap(pdev, pci_bus->hw_base);
 out_pci_release_regions:
 	pci_set_drvdata(pdev, NULL);
-- 
1.7.0.4

