Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64067 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab0EJDCB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 May 2010 23:02:01 -0400
Date: Sun, 09 May 2010 22:01:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] ssb: Handle alternate SSPROM location
Message-ID: <4be77726.2Sqkr0ilm/WZUNRg%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In kernel Bugzilla #15825 (2 users), in a wireless mailing list thread
(http://lists.infradead.org/pipermail/b43-dev/2010-May/000124.html), and on a
netbook owned by John Linville
(http://marc.info/?l=linux-wireless&m=127230751408818&w=4), there are reports
of ssb failing to detect an SPROM at the normal location. After studying the
MMIO trace dump for the Broadcom wl driver, it was determined that the affected
boxes had a relocated SPROM.

This patch fixes all systems that have reported this problem.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>
---

John,

This patch and the one by Gabor entitled "[PATCH] ssb: Implement
fast powerup delay calculation" are needed to fix these systems. As there is the
possibility that this patch will break some 14e4:4315 devices, it should stew in
testing for a while. I am confident enough in it to add the Cc for stable.

Larry
---
 
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
+	 * or chip ID is 0x4312 and chipcommon status & 3 == 2
+	 */
+	if (bus->chipco.dev->id.revision >= 31)
+		bus->sprom_offset = SSB_SPROM_BASE31;
+	else if (bus->chip_id == 0x4312 && (bus->chipco.status & 0x03) == 2)
+		bus->sprom_offset = SSB_SPROM_BASE31;
+	else
+		bus->sprom_offset = SSB_SPROM_BASE1;
+
+	ssb_dprintk(KERN_INFO PFX "SPROM offset is 0x%x\n", bus->sprom_offset);
 
 	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
 	if (!buf)
Index: wireless-testing/drivers/ssb/driver_chipcommon.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_chipcommon.c
+++ wireless-testing/drivers/ssb/driver_chipcommon.c
@@ -252,15 +252,17 @@ void ssb_chipcommon_init(struct ssb_chip
 {
 	u16 delay;
 
+	cc->status = 0;
 	if (!cc->dev)
 		return; /* We don't have a ChipCommon */
 	if (cc->dev->id.revision >= 11)
 		cc->status = chipco_read32(cc, SSB_CHIPCO_CHIPSTAT);
+	ssb_dprintk(KERN_INFO PFX "chipcommon status is 0x%x\n", cc->status);
 	ssb_pmu_init(cc);
 	chipco_powercontrol_init(cc);
 	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_FAST);
 	delay = calc_fast_powerup_delay(cc);
-	ssb_printk(KERN_INFO PFX "fast_pwrup_delay is %d\n", delay);
+	ssb_dprintk(KERN_INFO PFX "fast_pwrup_delay is %d\n", delay);
 	cc->fast_pwrup_delay = delay;
 	ssb_write16(cc->dev, SSB_MMIO_POWERUP_DELAY, delay);
 }
