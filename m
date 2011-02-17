Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:26924 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1BQWcT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:32:19 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022260.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 00:31:41 +0200
Subject: Re: [RFC] AI support (9/14 ssb SB-specific bus scan routine)
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297980093.13554.5.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
Content-Type: text/plain
Date: Fri, 18 Feb 2011 00:23:52 +0200
Message-Id: <1297981432.23381.26.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Move piece of code out of ssb_bus_scan to introduce
SB-specific bus scan routine.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/scan.c |   67 ++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 26 deletions(-)
--- linux-wireless-testing.orig/drivers/ssb/scan.c	2011-02-17 15:51:11.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/scan.c	2011-02-17 15:53:21.000000000 +0200
@@ -407,14 +407,45 @@ static int ssb_bus_detect(struct ssb_bus
 	return chiptype == SSB_CHIPCO_SB ? 0 : -ENODEV;
 }
 
-int ssb_bus_scan(struct ssb_bus *bus, unsigned long baseaddr)
+static int ssb_bus_scan_sb(struct ssb_bus *bus, unsigned long baseaddr)
 {
-	int err = -ENOMEM;
-	void __iomem *mmio;
 	u32 idhi;
 	int dev_i, i;
 	struct ssb_device *dev;
 	int nr_80211_cores = 0;
+	int err;
+
+	/* Fetch basic information about each core/device */
+	for (i = 0, dev_i = 0; i < bus->nr_devices; i++) {
+		err = scan_switchcore(bus, i);
+		if (err)
+			return err;
+		dev = &(bus->devices[dev_i]);
+
+		idhi = scan_read32(bus, i, SSB_IDHIGH);
+		dev->id.coreid = (idhi & SSB_IDHIGH_CC) >> SSB_IDHIGH_CC_SHIFT;
+		dev->id.revision = (idhi & SSB_IDHIGH_RCLO);
+		dev->id.revision |= (idhi & SSB_IDHIGH_RCHI) >>
+				    SSB_IDHIGH_RCHI_SHIFT;
+		dev->id.vendor = (idhi & SSB_IDHIGH_VC) >> SSB_IDHIGH_VC_SHIFT;
+		dev->core_index = i;
+		dev->bus = bus;
+		dev->ops = bus->ops;
+		dev->helpers = &ssb_helpers_sb;
+
+		if (ssb_bus_check_core(dev, &nr_80211_cores, i) < 0)
+			continue;
+
+		dev_i++;
+	}
+	bus->nr_devices = dev_i;
+	return 0;
+}
+
+int ssb_bus_scan(struct ssb_bus *bus, unsigned long baseaddr)
+{
+	int err = -ENOMEM;
+	void __iomem *mmio;
 
 	mmio = ssb_ioremap(bus, baseaddr);
 	if (!mmio)
@@ -445,31 +476,15 @@ int ssb_bus_scan(struct ssb_bus *bus, un
 		bus->mmio = mmio;
 	}
 
-	/* Fetch basic information about each core/device */
-	for (i = 0, dev_i = 0; i < bus->nr_devices; i++) {
-		err = scan_switchcore(bus, i);
-		if (err)
-			goto err_unmap;
-		dev = &(bus->devices[dev_i]);
-
-		idhi = scan_read32(bus, i, SSB_IDHIGH);
-		dev->id.coreid = (idhi & SSB_IDHIGH_CC) >> SSB_IDHIGH_CC_SHIFT;
-		dev->id.revision = (idhi & SSB_IDHIGH_RCLO);
-		dev->id.revision |= (idhi & SSB_IDHIGH_RCHI) >> SSB_IDHIGH_RCHI_SHIFT;
-		dev->id.vendor = (idhi & SSB_IDHIGH_VC) >> SSB_IDHIGH_VC_SHIFT;
-		dev->core_index = i;
-		dev->bus = bus;
-		dev->ops = bus->ops;
-		dev->helpers = &ssb_helpers_sb;
-
-		if (ssb_bus_check_core(dev, &nr_80211_cores, i) < 0)
-			continue;
-
-		dev_i++;
+	switch (bus->chipco.chiptype) {
+	case SSB_CHIPCO_SB:
+		err = ssb_bus_scan_sb(bus, baseaddr);
+		break;
+	default:
+		SSB_WARN_ON(1);
+		err = -ENODEV;
 	}
-	bus->nr_devices = dev_i;
 
-	err = 0;
 out:
 	return err;
 err_unmap:



