Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:52300 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbZCVA1f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 20:27:35 -0400
Received: by ewy9 with SMTP id 9so1151520ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 21 Mar 2009 17:27:32 -0700 (PDT)
From: Tulio Magno Quites Machado Filho <tuliom@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Tulio Magno Quites Machado Filho <tuliom@gmail.com>
Subject: [PATCH] ath5k: Support LED's on Acer Extensa 5620z
Date: Sun, 22 Mar 2009 01:41:13 +0100
Message-Id: <1237682473-5994-1-git-send-email-tuliom@gmail.com> (sfid-20090322_012737_270733_C2DDA439)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add vendor ID for Quanta Microsystems and update the led table with the reported device.

Reported-by: Scott Barnes <nekoreeve@gmail.com>

Signed-off-by: Tulio Magno Quites Machado Filho <tuliom@gmail.com>
---
 drivers/net/wireless/ath5k/led.c |    2 ++
 include/linux/pci_ids.h          |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/led.c b/drivers/net/wireless/ath5k/led.c
index 0686e12..19555fb 100644
--- a/drivers/net/wireless/ath5k/led.c
+++ b/drivers/net/wireless/ath5k/led.c
@@ -65,6 +65,8 @@ static const struct pci_device_id ath5k_led_devices[] = {
 	{ ATH_SDEVICE(PCI_VENDOR_ID_AMBIT, 0x0422), ATH_LED(1, 1) },
 	/* E-machines E510 (tuliom@gmail.com) */
 	{ ATH_SDEVICE(PCI_VENDOR_ID_AMBIT, 0x0428), ATH_LED(3, 0) },
+	/* Acer Extensa 5620z (nekoreeve@gmail.com) */
+	{ ATH_SDEVICE(PCI_VENDOR_ID_QMI, 0x0105), ATH_LED(3, 0) },
 	{ }
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 5207160..1702acb 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2267,6 +2267,8 @@
 #define PCI_DEVICE_ID_KORENIX_JETCARDF0	0x1600
 #define PCI_DEVICE_ID_KORENIX_JETCARDF1	0x16ff
 
+#define PCI_VENDOR_ID_QMI		0x1a32
+
 #define PCI_VENDOR_ID_TEKRAM		0x1de1
 #define PCI_DEVICE_ID_TEKRAM_DC290	0xdc29
 
-- 
1.6.0.2

