Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:52378 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418AbZAMMcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 07:32:43 -0500
Date: Tue, 13 Jan 2009 14:32:37 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Use a defined value for pci_set_power_state()
Message-ID: <20090113123237.GA14346@jm.kir.nu> (sfid-20090113_133248_269635_3EB4132A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Silence sparse by using a defined value PCI_D3hot instead of a magic
constant in a pci_set_power_state() call.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-01-13 14:10:23.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-01-13 14:11:00.000000000 +0200
@@ -2692,7 +2692,7 @@ static int ath_pci_suspend(struct pci_de
 
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
-	pci_set_power_state(pdev, 3);
+	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
 }

-- 
Jouni Malinen                                            PGP id EFC895FA
