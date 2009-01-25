Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:32279 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbZAYT7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 14:59:22 -0500
Received: by nf-out-0910.google.com with SMTP id d3so965442nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2009 11:59:20 -0800 (PST)
From: Tulio Magno Quites Machado Filho <tuliom@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Tulio Magno Quites Machado Filho <tuliom@gmail.com>
Subject: [PATCH] ath5k: support LED's on emachines E510 notebok
Date: Sun, 25 Jan 2009 21:14:21 +0100
Message-Id: <1232914461-19607-1-git-send-email-tuliom@gmail.com> (sfid-20090125_205933_431355_92F2F9A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add vendor ID for AMBIT and use it to set the ath5k LED gpio.

base.c:
Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Tulio Magno Quites Machado Filho <tuliom@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |    8 ++++++--
 include/linux/pci_ids.h           |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 57971a9..180518c 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2626,8 +2626,12 @@ ath5k_init_leds(struct ath5k_softc *sc)
 		sc->led_pin = 1;
 		sc->led_on = 1;  /* active high */
 	}
-	/* Pin 3 on Foxconn chips used in Acer Aspire One (0x105b:e008) */
-	if (pdev->subsystem_vendor == PCI_VENDOR_ID_FOXCONN) {
+	/*
+	 * Pin 3 on Foxconn chips used in Acer Aspire One (0x105b:e008) and
+	 * in emachines notebooks with AMBIT subsystem.
+	 */
+	if (pdev->subsystem_vendor == PCI_VENDOR_ID_FOXCONN ||
+	    pdev->subsystem_vendor == PCI_VENDOR_ID_AMBIT) {
 		__set_bit(ATH_STAT_LEDSOFT, sc->status);
 		sc->led_pin = 3;
 		sc->led_on = 0;  /* active low */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 02e6046..402ab74 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -836,6 +836,8 @@
 
 #define PCI_VENDOR_ID_FOXCONN		0x105b
 
+#define PCI_VENDOR_ID_AMBIT		0x1468
+
 #define PCI_VENDOR_ID_UMC		0x1060
 #define PCI_DEVICE_ID_UMC_UM8673F	0x0101
 #define PCI_DEVICE_ID_UMC_UM8886BF	0x673a
-- 
1.6.0.2

