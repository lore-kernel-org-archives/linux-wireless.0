Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:38947 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753473Ab1IUSCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 14:02:39 -0400
Message-ID: <4E7A26BD.1090202@xenotime.net> (sfid-20110921_200256_886785_FB429922)
Date: Wed, 21 Sep 2011 11:02:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH -next] nfc: NFC_WILINK depends on NFC_NCI
References: <20110921155850.09c858bb38205bb2cc0c8f0a@canb.auug.org.au>
In-Reply-To: <20110921155850.09c858bb38205bb2cc0c8f0a@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <rdunlap@xenotime.net>

nwcwilink.c uses nci_*() interfaces, so it should depend on
NFC_NCI.

Fixes these build errors:
ERROR: "nci_register_device" [drivers/nfc/nfcwilink.ko] undefined!
ERROR: "nci_allocate_device" [drivers/nfc/nfcwilink.ko] undefined!
ERROR: "nci_recv_frame" [drivers/nfc/nfcwilink.ko] undefined!
ERROR: "nci_free_device" [drivers/nfc/nfcwilink.ko] undefined!
ERROR: "nci_unregister_device" [drivers/nfc/nfcwilink.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/nfc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- next-2011-0921.orig/drivers/nfc/Kconfig
+++ next-2011-0921/drivers/nfc/Kconfig
@@ -29,7 +29,7 @@ config NFC_PN533
 
 config NFC_WILINK
 	tristate "Texas Instruments NFC WiLink driver"
-	depends on TI_ST
+	depends on TI_ST && NFC_NCI
 	help
 	  This enables the NFC driver for Texas Instrument's BT/FM/GPS/NFC
 	  combo devices. This makes use of shared transport line discipline
