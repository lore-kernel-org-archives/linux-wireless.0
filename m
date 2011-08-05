Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab1HELLW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 07:11:22 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	<lrodriguez@atheros.com>
Subject: [PATCH -next 5/8] ath9k: use common function for disabling ASPM
Date: Fri,  5 Aug 2011 13:10:36 +0200
Message-Id: <1312542639-4274-6-git-send-email-sgruszka@redhat.com> (sfid-20110805_131124_581364_40A2575E)
In-Reply-To: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
References: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable ASPM using common function, this works also with
CONFIG_PCIEASPM=y.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/pci.c |   23 +++--------------------
 1 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 7d94b64..67a2c96 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -110,33 +110,16 @@ static void ath_pci_aspm_init(struct ath_common *common)
 	int pos;
 	u8 aspm;
 
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
-		pos = pci_pcie_cap(parent);
-		pci_read_config_byte(parent, pos + PCI_EXP_LNKCTL, &aspm);
-		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
-		pci_write_config_byte(parent, pos + PCI_EXP_LNKCTL, aspm);
-
+		pcie_disable_aspm(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
 		return;
 	}
 
+	parent = pdev->bus->self;
 	if (WARN_ON(!parent))
 		return;
 
-- 
1.7.1

