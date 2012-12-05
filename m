Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:63932 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab2LEU6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 15:58:14 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so394100bkc.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 12:58:12 -0800 (PST)
Subject: [PATCH 10/12] iwlwifi: collapse wrapper for
	pcie_capability_read_word()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Wed, 05 Dec 2012 13:58:11 -0700
Message-ID: <20121205205811.13851.77247.stgit@bhelgaas.mtv.corp.google.com> (sfid-20121205_215821_229494_A248E3B2)
In-Reply-To: <20121205205724.13851.50508.stgit@bhelgaas.mtv.corp.google.com>
References: <20121205205724.13851.50508.stgit@bhelgaas.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl_pciexp_link_ctrl() has only one call site and no longer provides any
useful abstraction, so collapse it into the caller.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes.berg@intel.com>
CC: Wey-Yi Guy <wey-yi.w.guy@intel.com>
CC: Intel Linux Wireless <ilw@linux.intel.com>
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index fe0fffd..5cd06b3 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -673,18 +673,11 @@ static void iwl_set_pwr_vmain(struct iwl_trans *trans)
 #define PCI_CFG_LINK_CTRL_VAL_L0S_EN	0x01
 #define PCI_CFG_LINK_CTRL_VAL_L1_EN	0x02
 
-static u16 iwl_pciexp_link_ctrl(struct iwl_trans *trans)
+static void iwl_apm_config(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u16 pci_lnk_ctl;
-
-	pcie_capability_read_word(trans_pcie->pci_dev, PCI_EXP_LNKCTL,
-				  &pci_lnk_ctl);
-	return pci_lnk_ctl;
-}
+	u16 lctl;
 
-static void iwl_apm_config(struct iwl_trans *trans)
-{
 	/*
 	 * HW bug W/A for instability in PCIe bus L0S->L1 transition.
 	 * Check if BIOS (or OS) enabled L1-ASPM on this device.
@@ -693,8 +686,8 @@ static void iwl_apm_config(struct iwl_trans *trans)
 	 * If not (unlikely), enable L0S, so there is at least some
 	 *    power savings, even without L1.
 	 */
-	u16 lctl = iwl_pciexp_link_ctrl(trans);
 
+	pcie_capability_read_word(trans_pcie->pci_dev, PCI_EXP_LNKCTL, &lctl);
 	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
 				PCI_CFG_LINK_CTRL_VAL_L1_EN) {
 		/* L1-ASPM enabled; disable(!) L0S */

