Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:36649 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab2LEU6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 15:58:02 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so556247vbi.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 12:58:01 -0800 (PST)
Subject: [PATCH 08/12] ath9k: Use standard #defines for PCIe Capability ASPM
	fields
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Date: Wed, 05 Dec 2012 13:58:01 -0700
Message-ID: <20121205205801.13851.35427.stgit@bhelgaas.mtv.corp.google.com> (sfid-20121205_215811_874399_666C1E6B)
In-Reply-To: <20121205205724.13851.50508.stgit@bhelgaas.mtv.corp.google.com>
References: <20121205205724.13851.50508.stgit@bhelgaas.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the standard #defines for PCIe Capability ASPM fields.

Previously we used PCIE_LINK_STATE_L0S and PCIE_LINK_STATE_L1 directly, but
these are defined for the Linux ASPM interfaces, e.g.,
pci_disable_link_state(), and only coincidentally match the actual register
bits.  PCIE_LINK_STATE_CLKPM, also part of that interface, does not match
the register bit.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: "John W. Linville" <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>
CC: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
---
 drivers/net/wireless/ath/ath9k/pci.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index f088f4b..71d8207 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -125,23 +125,23 @@ static void ath_pci_aspm_init(struct ath_common *common)
 
 	if ((ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) &&
 	    (AR_SREV_9285(ah))) {
-		/* Bluetooth coexistance requires disabling ASPM. */
+		/* Bluetooth coexistence requires disabling ASPM. */
 		pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL,
-			PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
+			PCI_EXP_LNKCTL_ASPM_L0S | PCI_EXP_LNKCTL_ASPM_L1);
 
 		/*
 		 * Both upstream and downstream PCIe components should
 		 * have the same ASPM settings.
 		 */
 		pcie_capability_clear_word(parent, PCI_EXP_LNKCTL,
-			PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
+			PCI_EXP_LNKCTL_ASPM_L0S | PCI_EXP_LNKCTL_ASPM_L1);
 
 		ath_info(common, "Disabling ASPM since BTCOEX is enabled\n");
 		return;
 	}
 
 	pcie_capability_read_word(parent, PCI_EXP_LNKCTL, &aspm);
-	if (aspm & (PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1)) {
+	if (aspm & (PCI_EXP_LNKCTL_ASPM_L0S | PCI_EXP_LNKCTL_ASPM_L1)) {
 		ah->aspm_enabled = true;
 		/* Initialize PCIe PM and SERDES registers. */
 		ath9k_hw_configpcipowersave(ah, false);

