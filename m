Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46189 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab0EFFAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 01:00:16 -0400
Date: Thu, 06 May 2010 00:00:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [RFC/RFT] ssb: resolve alternate SPROM offset for 14e4:4315
Message-ID: <4be24cdd.Yg6pH2Z4OwSotB+K%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch and the patch by Gabor entitled "[PATCH] ssb: Implement
fast powerup delay calculation" are enough to allow the netbook from
John to work with ssb/b43. As this patch tampers with the SPROM offset for
14e4:4315 devices, it should be tested by anyone with an LP PHY that works
to ensure that it is not killed.

The essential elements of this patch will also be tested as part of kernel Bug
#15825.

Larry
 
Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c
+++ wireless-testing/drivers/ssb/pci.c
@@ -631,8 +631,17 @@ static int ssb_pci_sprom_get(struct ssb_
 		return -ENODEV;
 	}
 
-	bus->sprom_offset = (bus->chipco.dev->id.revision < 31) ?
-		SSB_SPROM_BASE1 : SSB_SPROM_BASE31;
+	/* get SPROM offset: SSB_SPROM_BASE1 except for chipcommon rev >= 31
+	 * or chip ID is 0x4312 and bit 0x2 is set in chipcommon status
+	 */
+	if (bus->chipco.dev->id.revision >= 31)
+		bus->sprom_offset = SSB_SPROM_BASE31;
+	else if (bus->chip_id == 0x4312 && (bus->chipco.status & 0x02))
+		bus->sprom_offset = SSB_SPROM_BASE31;
+	else
+		bus->sprom_offset = SSB_SPROM_BASE1;
+
+	ssb_dprintk(KERN_INFO PFX "SPROM offset is 0x%x\n", bus->sprom_offset);
 
 	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
 	if (!buf)
Index: wireless-testing/drivers/ssb/scan.c
===================================================================
--- wireless-testing.orig/drivers/ssb/scan.c
+++ wireless-testing/drivers/ssb/scan.c
@@ -306,6 +306,11 @@ int ssb_bus_scan(struct ssb_bus *bus,
 		}
 		tmp = scan_read32(bus, 0, SSB_CHIPCO_CAP);
 		bus->chipco.capabilities = tmp;
+		if (bus->chip_rev >= 11)
+			bus->chipco.status = scan_read32(bus, 0,
+					     SSB_CHIPCO_CHIPSTAT);
+		else
+			bus->chipco.status = 0;
 	} else {
 		if (bus->bustype == SSB_BUSTYPE_PCI) {
 			bus->chip_id = pcidev_to_chipid(bus->host_pci);
