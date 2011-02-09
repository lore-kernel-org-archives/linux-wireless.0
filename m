Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:22797 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab1BIOsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:48:09 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000019992.msg
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 16:47:33 +0200
Subject: Re: SSB AI support code ([RFC8/11] SSB separate SB-specific
	scanning)
From: George Kashperko <george@znau.edu.ua>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297258590.17400.37.camel@dev.znau.edu.ua>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
Content-Type: text/plain
Date: Wed, 09 Feb 2011 16:40:40 +0200
Message-Id: <1297262440.18053.34.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Move piece of code out of ssb_bus_scan to introduce
SB-specific bus scan routine.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/scan.c |   68 +++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 27 deletions(-)
--- linux-next-20110203.orig/drivers/ssb/scan.c	2011-02-08 15:40:18.000000000 +0200
+++ linux-next-20110203/drivers/ssb/scan.c	2011-02-08 15:41:20.000000000 +0200
@@ -405,16 +405,46 @@ static int ssb_bus_detect(struct ssb_bus
 	return chiptype != SSB_CHIPCO_SB;
 }
 
-int ssb_bus_scan(struct ssb_bus *bus,
-		 unsigned long baseaddr)
+int ssb_bus_scan_sb(struct ssb_bus *bus, unsigned long baseaddr)
 {
-	int err = -ENOMEM;
-	void __iomem *mmio;
+	int err;
 	u32 idhi;
 	int dev_i, i;
 	struct ssb_device *dev;
 	int nr_80211_cores = 0;
 
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
+int ssb_bus_scan(struct ssb_bus *bus,
+		 unsigned long baseaddr)
+{
+	int err = -ENOMEM;
+	void __iomem *mmio;
+
 	mmio = ssb_ioremap(bus, baseaddr);
 	if (!mmio)
 		goto out;
@@ -444,30 +474,14 @@ int ssb_bus_scan(struct ssb_bus *bus,
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
-
-	err = 0;
 out:
 	return err;
 err_unmap:



