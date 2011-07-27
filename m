Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013Ab1G0MN6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 08:13:58 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC/RFT v2 08/12] ath9k: use common function for disabling ASPM
Date: Wed, 27 Jul 2011 14:14:55 +0200
Message-Id: <1311768899-4559-9-git-send-email-sgruszka@redhat.com> (sfid-20110727_141411_716344_A058E448)
In-Reply-To: <1311768899-4559-1-git-send-email-sgruszka@redhat.com>
References: <1311768899-4559-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable ASPM using common function, this works also with
CONFIG_PCIEASPM=y.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/pci.c |   29 ++++++-----------------------
 1 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 494ec0f..a92e55f 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -111,43 +111,26 @@ static void ath_pci_aspm_init(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	struct pci_dev *pdev = to_pci_dev(sc->dev);
 	struct pci_dev *parent;
-	int pos, ppos;
+	int pos;
 	u8 aspm;
 
 	ah->aspm_enabled = false;
 
-	pos = pci_pcie_cap(pdev);
-	if (!pos)
+	if (!pci_is_pcie(pdev))
 		return;
 
-	parent = pdev->bus->self;
-
 	if (ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE) {
 		/* Bluetooth coexistance requires disabling ASPM. */
-		pci_read_config_byte(pdev, pos + PCI_EXP_LNKCTL, &aspm);
-		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
-		pci_write_config_byte(pdev, pos + PCI_EXP_LNKCTL, aspm);
-
-		/*
-		 * Both upstream and downstream PCIe components should
-		 * have the same ASPM settings.
-		 */
-		if (WARN_ON(!parent))
-			return;
-
-		ppos = pci_pcie_cap(parent);
-		pci_read_config_byte(parent, ppos + PCI_EXP_LNKCTL, &aspm);
-		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
-		pci_write_config_byte(parent, ppos + PCI_EXP_LNKCTL, aspm);
-
+		pcie_disable_aspm(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
 		return;
 	}
 
+	parent = pdev->bus->self;
 	if (WARN_ON(!parent))
 		return;
 
-	ppos = pci_pcie_cap(parent);
-	pci_read_config_byte(parent, ppos +  PCI_EXP_LNKCTL, &aspm);
+	pos = pci_pcie_cap(parent);
+	pci_read_config_byte(parent, pos +  PCI_EXP_LNKCTL, &aspm);
 	if (aspm & (PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1)) {
 		ah->aspm_enabled = true;
 		/* Initialize PCIe PM and SERDES registers. */
-- 
1.7.1

