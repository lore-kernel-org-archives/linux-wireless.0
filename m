Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:41784 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbZAYWqM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 17:46:12 -0500
Received: by ewy14 with SMTP id 14so80987ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2009 14:46:09 -0800 (PST)
From: Tulio Magno Quites Machado Filho <tuliom@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Tulio Magno Quites Machado Filho <tuliom@gmail.com>
Subject: [PATCH] ath5k: support LED's on emachines E510 notebook
Date: Sun, 25 Jan 2009 23:54:25 +0100
Message-Id: <1232924065-28556-1-git-send-email-tuliom@gmail.com> (sfid-20090125_234617_914545_D859BF8B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add vendor ID for AMBIT and use it to set the ath5k LED gpio.

base.c:
Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Tulio Magno Quites Machado Filho <tuliom@gmail.com>
Acked-by: Bob Copeland <me@bobcopeland.com>
---

v2: fixed order of pci_ids.h

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
index 02e6046..42cc884 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1967,6 +1967,8 @@
 
 #define PCI_VENDOR_ID_SAMSUNG		0x144d
 
+#define PCI_VENDOR_ID_AMBIT		0x1468
+
 #define PCI_VENDOR_ID_MYRICOM		0x14c1
 
 #define PCI_VENDOR_ID_TITAN		0x14D2
-- 
1.6.0.2

