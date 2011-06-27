Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34954 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab1F0Rte (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 13:49:34 -0400
Received: by pvg12 with SMTP id 12so2994668pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 10:49:34 -0700 (PDT)
From: Jon Mason <jdmason@kudzu.us>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 18/19] iwlwifi: remove unnecessary read of PCI_CAP_ID_EXP
Date: Mon, 27 Jun 2011 12:49:29 -0500
Message-Id: <1309196969-16348-1-git-send-email-jdmason@kudzu.us> (sfid-20110627_194940_849827_C407E1E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PCIE capability offset is saved during PCI bus walking.  It will
remove an unnecessary search in the PCI configuration space if this
value is referenced instead of reacquiring it.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 7328fbf..60d9140 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -93,7 +93,7 @@ static u16 iwl_pciexp_link_ctrl(struct iwl_bus *bus)
 	u16 pci_lnk_ctl;
 	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
 
-	pos = pci_find_capability(pci_dev, PCI_CAP_ID_EXP);
+	pos = pci_pcie_cap(priv->pci_dev);
 	pci_read_config_word(pci_dev, pos + PCI_EXP_LNKCTL, &pci_lnk_ctl);
 	return pci_lnk_ctl;
 }
-- 
1.7.5.4

