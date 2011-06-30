Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49316 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab1F3Pmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 11:42:53 -0400
Received: by iyb12 with SMTP id 12so2016833iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 08:42:53 -0700 (PDT)
Date: Thu, 30 Jun 2011 10:42:47 -0500
From: Jon Mason <jdmason@kudzu.us>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 18/19 v2] iwlwifi: remove unnecessary read of PCI_CAP_ID_EXP
Message-ID: <20110630154246.GA11407@kudzu.us> (sfid-20110630_174303_614139_1EC45B34)
References: <1309196969-16348-1-git-send-email-jdmason@kudzu.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1309196969-16348-1-git-send-email-jdmason@kudzu.us>
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
index 7328fbf..068b9ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -93,7 +93,7 @@ static u16 iwl_pciexp_link_ctrl(struct iwl_bus *bus)
 	u16 pci_lnk_ctl;
 	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
 
-	pos = pci_find_capability(pci_dev, PCI_CAP_ID_EXP);
+	pos = pci_pcie_cap(pci_dev);
 	pci_read_config_word(pci_dev, pos + PCI_EXP_LNKCTL, &pci_lnk_ctl);
 	return pci_lnk_ctl;
 }
-- 
1.7.5.4

