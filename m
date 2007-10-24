Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:37810 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbXJXTcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 15:32:23 -0400
Received: by ug-out-1314.google.com with SMTP id z38so385514ugc
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2007 12:32:23 -0700 (PDT)
From: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ssb: Add "ssb_pci_set_power_state" function
Date: Wed, 24 Oct 2007 21:31:21 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mb@bu3sch.de
MIME-Version: 1.0
Message-Id: <200710242131.21959.mboton.lkml@gmail.com> (sfid-20071024_203228_624273_77607FA8)
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add "ssb_pci_set_power_state" function. This allows set the power state=
 of a=20
PCI device (for example b44 ethernet device).

diff -ruN linux-2.6.23/include/linux/ssb/ssb.h=20
linux-2.6.23.orig/include/linux/ssb/ssb.h
--- linux-2.6.23.orig/include/linux/ssb/ssb.h	2007-10-24 19:02:33.00000=
0000=20
+0200
+++ linux-2.6.23/include/linux/ssb/ssb.h	2007-10-24 19:49:37.000000000 =
+0200
@@ -402,6 +402,14 @@
 {
 	pci_unregister_driver(driver);
 }
+
+/* Set PCI device power state */
+static inline
+void ssb_pci_set_power_state(struct ssb_device *dev, pci_power_t state=
)
+{
+	if(dev->bus->bustype =3D=3D SSB_BUSTYPE_PCI)
+		pci_set_power_state(dev->bus->host_pci, state);
+}
 #endif /* CONFIG_SSB_PCIHOST */
=20
=20

--=20
	Miguel Bot=F3n
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
