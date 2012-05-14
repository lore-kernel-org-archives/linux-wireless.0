Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:54274 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932371Ab2ENUNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 16:13:16 -0400
Message-ID: <4FB16765.3090602@xenotime.net> (sfid-20120514_221332_543797_AEFF9EAB)
Date: Mon, 14 May 2012 13:13:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH -next] nfc: shdlc needs to select CRC_CCITT
References: <20120514200357.e7448e4ca061c8efe3d4757d@canb.auug.org.au>
In-Reply-To: <20120514200357.e7448e4ca061c8efe3d4757d@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build error: SHDLC uses crc_ccitt so it should select CRC_CCITT.

ERROR: "crc_ccitt" [net/nfc/hci/hci.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc:	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc:	Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/hci/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20120514.orig/net/nfc/hci/Kconfig
+++ linux-next-20120514/net/nfc/hci/Kconfig
@@ -11,6 +11,7 @@ config NFC_SHDLC
 	depends on NFC_HCI
 	bool "SHDLC link layer for HCI based NFC drivers"
 	default n
+	select CRC_CCITT
 	---help---
 	  Say yes if you use an NFC HCI driver that requires SHDLC link layer.
 	  If unsure, say N here.
