Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1092 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbZD3T47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 15:56:59 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Paride Legovini <legovini@spiro.fisica.unipd.it>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 9/9] Add LED support for AR5BXB6 IBM Thinkpad PCIe adapters
Date: Thu, 30 Apr 2009 15:55:52 -0400
Message-Id: <1241121352-6064-10-git-send-email-me@bobcopeland.com>
In-Reply-To: <1241121352-6064-1-git-send-email-me@bobcopeland.com>
References: <1241121352-6064-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Paride Legovini <legovini@spiro.fisica.unipd.it>

Add LED support on the IBM ThinkPad 11a/b/g Wireless LAN Mini Express
Adapter (AR5BXB6), found on the IBM/Lenovo Thinkpad X60/T60/Z60 series.

Signed-off-by: Paride Legovini <legovini@spiro.fisica.unipd.it>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/led.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index cbdc0b3..876725f 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -53,8 +53,6 @@
 
 /* Devices we match on for LED config info (typically laptops) */
 static const struct pci_device_id ath5k_led_devices[] = {
-	/* IBM-specific AR5212 */
-	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5212_IBM), ATH_LED(0, 0) },
 	/* AR5211 */
 	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5211), ATH_LED(0, 0) },
 	/* HP Compaq nc6xx, nc4000, nx6000 */
@@ -69,6 +67,10 @@ static const struct pci_device_id ath5k_led_devices[] = {
 	{ ATH_SDEVICE(PCI_VENDOR_ID_QMI, 0x0105), ATH_LED(3, 0) },
 	/* Fukato Datacask Jupiter 1014a (mrb74@gmx.at) */
 	{ ATH_SDEVICE(PCI_VENDOR_ID_AZWAVE, 0x1026), ATH_LED(3, 0) },
+	/* IBM ThinkPad AR5BXB6 (legovini@spiro.fisica.unipd.it) */
+	{ ATH_SDEVICE(PCI_VENDOR_ID_IBM, 0x058a), ATH_LED(1, 0) },
+	/* IBM-specific AR5212 (all others) */
+	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5212_IBM), ATH_LED(0, 0) },
 	{ }
 };
 
-- 
1.6.0.6


