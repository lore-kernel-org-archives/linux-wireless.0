Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3839 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbZDEPBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Apr 2009 11:01:44 -0400
Date: Sun, 5 Apr 2009 11:01:20 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: add support for Fukato Datacask Jupiter LEDs
Message-ID: <20090405150120.GB21913@hash.localnet> (sfid-20090405_170147_057734_3DD8FC37)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for the LEDs on the Jupiter netbook.

Reported-by: Martin Bammer <mrb74@gmx.at>

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

This is pre-ath merge, following makes it post-merge:

%!s,wireless/ath5k,wireless/ath/ath5k,g

 drivers/net/wireless/ath5k/led.c |    2 ++
 include/linux/pci_ids.h          |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/led.c b/drivers/net/wireless/ath5k/led.c
index 19555fb..13864fa 100644
--- a/drivers/net/wireless/ath5k/led.c
+++ b/drivers/net/wireless/ath5k/led.c
@@ -67,6 +67,8 @@ static const struct pci_device_id ath5k_led_devices[] = {
 	{ ATH_SDEVICE(PCI_VENDOR_ID_AMBIT, 0x0428), ATH_LED(3, 0) },
 	/* Acer Extensa 5620z (nekoreeve@gmail.com) */
 	{ ATH_SDEVICE(PCI_VENDOR_ID_QMI, 0x0105), ATH_LED(3, 0) },
+	/* Fukato Datacask Jupiter 1014a (mrb74@gmx.at) */
+	{ ATH_SDEVICE(PCI_VENDOR_ID_AZWAVE, 0x1026), ATH_LED(3, 0) },
 	{ }
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 1702acb..e592883 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2269,6 +2269,8 @@
 
 #define PCI_VENDOR_ID_QMI		0x1a32
 
+#define PCI_VENDOR_ID_AZWAVE		0x1a3b
+
 #define PCI_VENDOR_ID_TEKRAM		0x1de1
 #define PCI_DEVICE_ID_TEKRAM_DC290	0xdc29
 
-- 
1.6.0.6

-- 
Bob Copeland %% www.bobcopeland.com

