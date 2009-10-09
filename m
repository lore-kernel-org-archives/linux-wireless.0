Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40967 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761088AbZJISb1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 14:31:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43/legacy: Fix usage of host_pci pointer
Date: Fri, 9 Oct 2009 20:30:10 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910092030.10963.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must check the bustype before using the host_pci pointer.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This does not fix a bug, but is required for a future patch which puts
the pointer into a union.

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-10-09 18:47:03.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-10-09 18:47:52.000000000 +0200
@@ -4671,7 +4671,7 @@ static int b43_wireless_core_attach(stru
 {
 	struct b43_wl *wl = dev->wl;
 	struct ssb_bus *bus = dev->dev->bus;
-	struct pci_dev *pdev = bus->host_pci;
+	struct pci_dev *pdev = (bus->bustype == SSB_BUSTYPE_PCI) ? bus->host_pci : NULL;
 	int err;
 	bool have_2ghz_phy = 0, have_5ghz_phy = 0;
 	u32 tmp;
@@ -4804,7 +4804,7 @@ static int b43_one_core_attach(struct ss
 
 	if (!list_empty(&wl->devlist)) {
 		/* We are not the first core on this chip. */
-		pdev = dev->bus->host_pci;
+		pdev = (dev->bus->bustype == SSB_BUSTYPE_PCI) ? dev->bus->host_pci : NULL;
 		/* Only special chips support more than one wireless
 		 * core, although some of the other chips have more than
 		 * one wireless core as well. Check for this and
Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c	2009-10-09 18:47:03.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c	2009-10-09 18:47:52.000000000 +0200
@@ -3592,7 +3592,7 @@ static int b43legacy_wireless_core_attac
 {
 	struct b43legacy_wl *wl = dev->wl;
 	struct ssb_bus *bus = dev->dev->bus;
-	struct pci_dev *pdev = bus->host_pci;
+	struct pci_dev *pdev = (bus->bustype == SSB_BUSTYPE_PCI) ? bus->host_pci : NULL;
 	int err;
 	int have_bphy = 0;
 	int have_gphy = 0;
@@ -3706,7 +3706,7 @@ static int b43legacy_one_core_attach(str
 
 	if (!list_empty(&wl->devlist)) {
 		/* We are not the first core on this chip. */
-		pdev = dev->bus->host_pci;
+		pdev = (dev->bus->bustype == SSB_BUSTYPE_PCI) ? dev->bus->host_pci : NULL;
 		/* Only special chips support more than one wireless
 		 * core, although some of the other chips have more than
 		 * one wireless core as well. Check for this and

-- 
Greetings, Michael.
