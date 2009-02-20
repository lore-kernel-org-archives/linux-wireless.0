Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16428 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbZBTJrR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 04:47:17 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 01:47:17 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18846.31550.15193.632756@gargle.gargle.HOWL> (sfid-20090220_104720_180896_03ADA420)
Date: Fri, 20 Feb 2009 15:13:26 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 4/5] ath9k: Fix PCI shutdown sequence
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pci_release_region() has to be called after the device
has been disabled. Also remove a stray __init attribute.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/pci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/pci.c b/drivers/net/wireless/ath9k/pci.c
index a70f954..eea9d3a 100644
--- a/drivers/net/wireless/ath9k/pci.c
+++ b/drivers/net/wireless/ath9k/pci.c
@@ -52,8 +52,8 @@ static void ath_pci_cleanup(struct ath_softc *sc)
 	struct pci_dev *pdev = to_pci_dev(sc->dev);
 
 	pci_iounmap(pdev, sc->mem);
-	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
+	pci_release_region(pdev, 0);
 }
 
 static bool ath_pci_eeprom_read(struct ath_hw *ah, u32 off, u16 *data)
@@ -293,7 +293,7 @@ static struct pci_driver ath_pci_driver = {
 #endif /* CONFIG_PM */
 };
 
-int __init ath_pci_init(void)
+int ath_pci_init(void)
 {
 	return pci_register_driver(&ath_pci_driver);
 }
-- 
1.6.1

