Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3171 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbZHYDBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 23:01:35 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>,
	Marcos Chaparro <nitrousnrg@gmail.com>
Subject: [PATCH 2/4] ath5k: add led pin configuration for compaq c700 laptop
Date: Mon, 24 Aug 2009 23:00:31 -0400
Message-Id: <1251169233-24169-3-git-send-email-me@bobcopeland.com>
In-Reply-To: <1251169233-24169-1-git-send-email-me@bobcopeland.com>
References: <1251169233-24169-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marcos Chaparro <nitrousnrg@gmail.com>

With this patch, a compaq c700 can turn on the wifi led.
The array of compatible devices now includes the hardware
present in this computer, as well as the led pin and
polarity.

Signed-off-by: Marcos Chaparro <nitrousnrg@gmail.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/led.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index 876725f..b767c3b 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -69,6 +69,8 @@ static const struct pci_device_id ath5k_led_devices[] = {
 	{ ATH_SDEVICE(PCI_VENDOR_ID_AZWAVE, 0x1026), ATH_LED(3, 0) },
 	/* IBM ThinkPad AR5BXB6 (legovini@spiro.fisica.unipd.it) */
 	{ ATH_SDEVICE(PCI_VENDOR_ID_IBM, 0x058a), ATH_LED(1, 0) },
+	/* HP Compaq C700 (nitrousnrg@gmail.com) */
+	{ ATH_SDEVICE(PCI_VENDOR_ID_HP, 0x0137b), ATH_LED(3, 1) },
 	/* IBM-specific AR5212 (all others) */
 	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5212_IBM), ATH_LED(0, 0) },
 	{ }
-- 
1.6.2.5


