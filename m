Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from salugit.unile.it ([193.204.77.149]:51212 "EHLO salug.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbZLVRJW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 12:09:22 -0500
Date: Tue, 22 Dec 2009 18:10:01 +0100
From: Luca Verdesca <magooz@salug.it>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath5k: adding LED support for AR5BXB63 cards
Message-ID: <20091222181001.5c1077b8@magooz.no-ip.org>
In-Reply-To: <20091222142841.GA5663@hash.localnet>
References: <20091222022135.2102c465@magooz.no-ip.org>
	<b6c5339f0912211937o525c9117k2e6d877b3c91b858@mail.gmail.com>
	<20091222120245.0df11284@magooz.no-ip.org>
	<20091222142841.GA5663@hash.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With following patch, LED should now work with LiteOn AR5BXB63 mini
pci-e cards.

Signed-off-by: Luca Verdesca <magooz@salug.it>
Acked-by: Bob Copeland <me@bobcopeland.com>
Cc: John Linville <linville@tuxdriver.com>
---
 home/magooz/led.c |    2 ++
 1 file changed, 2 insertions(+)

--- /usr/src/linux/drivers/net/wireless/ath/ath5k/led.c	2009-12-22 16:37:42.000000000 +0100
+++ /home/magooz/led.c	2009-12-22 16:38:14.000000000 +0100
@@ -75,6 +75,8 @@ static const struct pci_device_id ath5k_
 	{ ATH_SDEVICE(PCI_VENDOR_ID_HP, 0x0137a), ATH_LED(3, 1) },
 	/* HP Compaq C700 (nitrousnrg@gmail.com) */
 	{ ATH_SDEVICE(PCI_VENDOR_ID_HP, 0x0137b), ATH_LED(3, 1) },
+	/* LiteOn AR5BXB63 (magooz@salug.it) */
+	{ PCI_SDEVICE(ATHEROS, 0x3067), ATH_LED(3, 0) },
 	/* IBM-specific AR5212 (all others) */
 	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5212_IBM), ATH_LED(0, 0) },
 	{ }
