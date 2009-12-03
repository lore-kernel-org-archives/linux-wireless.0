Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:40564 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbZLCNNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 08:13:45 -0500
Received: by ewy6 with SMTP id 6so1520681ewy.29
        for <linux-wireless@vger.kernel.org>; Thu, 03 Dec 2009 05:13:51 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 3 Dec 2009 15:07:28 +0200
Message-ID: <bf87febf0912030507u1c36f6a9h7cac0efabf3d016@mail.gmail.com>
Subject: [PATCH] ath5k: add support for Dell Vostro A860 LED
From: Shahar Or <mightyiampresence@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org, me@bobcopeland.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shahar Or

Adds support for the WiFi activity LED on the Dell Vostro A860 laptop.

Signed-off-by: Shahar Or

---
--- linux-2.6.31/drivers/net/wireless/ath/ath5k/led.c.orig
2009-12-03 14:57:20.000000000 +0200
+++ linux-2.6.31/drivers/net/wireless/ath/ath5k/led.c   2009-12-03
14:25:30.000000000 +0200
@@ -71,6 +71,8 @@ static const struct pci_device_id ath5k_
        { ATH_SDEVICE(PCI_VENDOR_ID_IBM, 0x058a), ATH_LED(1, 0) },
        /* IBM-specific AR5212 (all others) */
        { PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5212_IBM),
ATH_LED(0, 0) },
+       /* Dell Vostro A860 (shahar@shahar-or.co.il) */
+       { ATH_SDEVICE(PCI_VENDOR_ID_QMI, 0x0112), ATH_LED(3, 0) },
        { }
 };
