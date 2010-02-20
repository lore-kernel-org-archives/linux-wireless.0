Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f227.google.com ([209.85.217.227]:58618 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab0BTTtM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Feb 2010 14:49:12 -0500
Received: by gxk27 with SMTP id 27so2166806gxk.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 Feb 2010 11:49:11 -0800 (PST)
Date: Sat, 20 Feb 2010 13:49:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH V2] ssb: Add PCI ID 0x4322 to PMU handling
Message-ID: <4b803cb5.tZQnvqGy2KfItgOq%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the N PHYs need a revision in the handling of the PMU.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This will be needed for some of the N PHY devices - 2.6.34 amterial.

Larry
---

V2 - Fix typo in subject line of commit message.

Index: wireless-testing/drivers/ssb/driver_chipcommon_pmu.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_chipcommon_pmu.c
+++ wireless-testing/drivers/ssb/driver_chipcommon_pmu.c
@@ -332,6 +332,12 @@ static void ssb_pmu_pll_init(struct ssb_
 	case 0x5354:
 		ssb_pmu0_pllinit_r0(cc, crystalfreq);
 		break;
+	case 0x4322:
+		if (cc->pmu.rev == 2) {
+			chipco_write32(cc, SSB_CHIPCO_PLLCTL_ADDR, 0x0000000A);
+			chipco_write32(cc, SSB_CHIPCO_PLLCTL_DATA, 0x380005C0);
+		}
+		break;
 	default:
 		ssb_printk(KERN_ERR PFX
 			   "ERROR: PLL init unknown for device %04X\n",
@@ -417,6 +423,7 @@ static void ssb_pmu_resources_init(struc
 
 	switch (bus->chip_id) {
 	case 0x4312:
+	case 0x4322:
 		/* We keep the default settings:
 		 * min_msk = 0xCBB
 		 * max_msk = 0x7FFFF
