Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab1HELLq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 07:11:46 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	<lrodriguez@atheros.com>
Subject: [PATCH -next 6/8] e1000e: use common function for disabling ASPM
Date: Fri,  5 Aug 2011 13:10:37 +0200
Message-Id: <1312542639-4274-7-git-send-email-sgruszka@redhat.com> (sfid-20110805_131148_808861_207879FE)
In-Reply-To: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
References: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: e1000-devel@lists.sourceforge.net
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/e1000e/netdev.c |   31 +------------------------------
 1 files changed, 1 insertions(+), 30 deletions(-)

diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 3310c3d..62ee7e4 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -5358,42 +5358,13 @@ static void e1000_complete_shutdown(struct pci_dev *pdev, bool sleep,
 	}
 }
 
-#ifdef CONFIG_PCIEASPM
-static void __e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
-{
-	pci_disable_link_state_locked(pdev, state);
-}
-#else
-static void __e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
-{
-	int pos;
-	u16 reg16;
-
-	/*
-	 * Both device and parent should have the same ASPM setting.
-	 * Disable ASPM in downstream component first and then upstream.
-	 */
-	pos = pci_pcie_cap(pdev);
-	pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &reg16);
-	reg16 &= ~state;
-	pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
-
-	if (!pdev->bus->self)
-		return;
-
-	pos = pci_pcie_cap(pdev->bus->self);
-	pci_read_config_word(pdev->bus->self, pos + PCI_EXP_LNKCTL, &reg16);
-	reg16 &= ~state;
-	pci_write_config_word(pdev->bus->self, pos + PCI_EXP_LNKCTL, reg16);
-}
-#endif
 static void e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
 {
 	dev_info(&pdev->dev, "Disabling ASPM %s %s\n",
 		 (state & PCIE_LINK_STATE_L0S) ? "L0s" : "",
 		 (state & PCIE_LINK_STATE_L1) ? "L1" : "");
 
-	__e1000e_disable_aspm(pdev, state);
+	pcie_disable_aspm(pdev, state);
 }
 
 #ifdef CONFIG_PM
-- 
1.7.1

