Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server1.vittgam.net ([213.239.197.142]:38079 "EHLO
        mail.vittgam.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751872AbcJCKGe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 06:06:34 -0400
Date: Mon, 3 Oct 2016 12:00:56 +0200
From: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>
To: <kvalo@codeaurora.org>
Cc: <linux-wireless@vger.kernel.org>
Cc: <ath9k-devel@qca.qualcomm.com>
Cc: <ath9k-devel@venema.h4ckr.net>
Cc: <stable@vger.kernel.org>
Subject: [PATCH] ath9k: Move generic entries below specific ones in ath_pci_id_table.
Message-ID: <ath9k-patch-20161003@vittgam.net> (sfid-20161003_120639_760442_B5FFD06B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If generic entries are positioned above specific ones, then the
former will be matched first and used instead of the latter.

Cc: <linux-wireless@vger.kernel.org>
Cc: <ath9k-devel@qca.qualcomm.com>
Cc: <ath9k-devel@lists.ath9k.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Vittorio Gambaletta <linuxbugs@vittgam.net>
---

--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -26,7 +26,6 @@
 	{ PCI_VDEVICE(ATHEROS, 0x0023) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x0024) }, /* PCI-E */
 	{ PCI_VDEVICE(ATHEROS, 0x0027) }, /* PCI   */
-	{ PCI_VDEVICE(ATHEROS, 0x0029) }, /* PCI   */
 
 #ifdef CONFIG_ATH9K_PCOEM
 	/* Mini PCI AR9220 MB92 cards: Compex WLM200NX, Wistron DNMA-92 */
@@ -37,7 +36,7 @@
 	  .driver_data = ATH9K_PCI_LED_ACT_HI },
 #endif
 
-	{ PCI_VDEVICE(ATHEROS, 0x002A) }, /* PCI-E */
+	{ PCI_VDEVICE(ATHEROS, 0x0029) }, /* PCI   */
 
 #ifdef CONFIG_ATH9K_PCOEM
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
@@ -85,7 +84,11 @@
 			 0x10CF, /* Fujitsu */
 			 0x1536),
 	  .driver_data = ATH9K_PCI_D3_L1_WAR },
+#endif
 
+	{ PCI_VDEVICE(ATHEROS, 0x002A) }, /* PCI-E */
+
+#ifdef CONFIG_ATH9K_PCOEM
 	/* AR9285 card for Asus */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x002B,
