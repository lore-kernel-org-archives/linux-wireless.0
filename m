Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3566 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbZCHFlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2009 00:41:16 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/3] ath5k: update LED table with reported devices
Date: Sun,  8 Mar 2009 00:10:22 -0500
Message-Id: <1236489022-16199-3-git-send-email-me@bobcopeland.com> (sfid-20090308_064129_994293_0410C2A6)
In-Reply-To: <1236489022-16199-1-git-send-email-me@bobcopeland.com>
References: <1236489022-16199-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for Acer Ferrari 5000, and also specifies
the subsystem device ids for previously reported e-machines e510 and
Acer Aspire One A150.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/led.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/led.c b/drivers/net/wireless/ath5k/led.c
index e365fbd..0686e12 100644
--- a/drivers/net/wireless/ath5k/led.c
+++ b/drivers/net/wireless/ath5k/led.c
@@ -60,9 +60,11 @@ static const struct pci_device_id ath5k_led_devices[] = {
 	/* HP Compaq nc6xx, nc4000, nx6000 */
 	{ ATH_SDEVICE(PCI_VENDOR_ID_COMPAQ, PCI_ANY_ID), ATH_LED(1, 1) },
 	/* Acer Aspire One A150 (maximlevitsky@gmail.com) */
-	{ ATH_SDEVICE(PCI_VENDOR_ID_FOXCONN, PCI_ANY_ID), ATH_LED(3, 0) },
+	{ ATH_SDEVICE(PCI_VENDOR_ID_FOXCONN, 0xe008), ATH_LED(3, 0) },
+	/* Acer Ferrari 5000 (russ.dill@gmail.com) */
+	{ ATH_SDEVICE(PCI_VENDOR_ID_AMBIT, 0x0422), ATH_LED(1, 1) },
 	/* E-machines E510 (tuliom@gmail.com) */
-	{ ATH_SDEVICE(PCI_VENDOR_ID_AMBIT, PCI_ANY_ID), ATH_LED(3, 0) },
+	{ ATH_SDEVICE(PCI_VENDOR_ID_AMBIT, 0x0428), ATH_LED(3, 0) },
 	{ }
 };
 
-- 
1.6.0.6


