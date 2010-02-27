Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33651 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030620Ab0B0SxT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 13:53:19 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal DMA errors
Date: Sat, 27 Feb 2010 18:36:03 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <201002262120.37438.mb@bu3sch.de> <alpine.LFD.2.00.1002261231320.4513@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002261231320.4513@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002271836.04673.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 February 2010 21:33:08 Linus Torvalds wrote:
> So send me a patch. I'll try it.

Please check if the following patch makes any difference.
Also please show me the result of the printks.


Index: wireless-testing/drivers/ssb/driver_chipcommon_pmu.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_chipcommon_pmu.c	2010-02-27 17:16:38.000000000 +0100
+++ wireless-testing/drivers/ssb/driver_chipcommon_pmu.c	2010-02-27 18:35:50.000000000 +0100
@@ -428,6 +428,9 @@ static void ssb_pmu_resources_init(struc
 		 * min_msk = 0xCBB
 		 * max_msk = 0x7FFFF
 		 */
+printk("PMU res init 4312/4322\n");
+min_msk = 0xFFFFFFFF;
+max_msk = 0xFFFFFFFF;
 		break;
 	case 0x4325:
 		/* Power OTP down later. */
@@ -442,6 +445,9 @@ static void ssb_pmu_resources_init(struc
 		updown_tab_size = ARRAY_SIZE(pmu_res_updown_tab_4325a0);
 		depend_tab = pmu_res_depend_tab_4325a0;
 		depend_tab_size = ARRAY_SIZE(pmu_res_depend_tab_4325a0);
+printk("PMU res init 4325\n");
+min_msk = 0xFFFFFFFF;
+max_msk = 0xFFFFFFFF;
 		break;
 	case 0x4328:
 		min_msk = (1 << SSB_PMURES_4328_EXT_SWITCHER_PWM) |
@@ -453,10 +459,16 @@ static void ssb_pmu_resources_init(struc
 		updown_tab_size = ARRAY_SIZE(pmu_res_updown_tab_4328a0);
 		depend_tab = pmu_res_depend_tab_4328a0;
 		depend_tab_size = ARRAY_SIZE(pmu_res_depend_tab_4328a0);
+printk("PMU res init 4328\n");
+min_msk = 0xFFFFFFFF;
+max_msk = 0xFFFFFFFF;
 		break;
 	case 0x5354:
 		/* The PLL may turn on, if it decides so. */
 		max_msk = 0xFFFFF;
+printk("PMU res init 5354\n");
+min_msk = 0xFFFFFFFF;
+max_msk = 0xFFFFFFFF;
 		break;
 	default:
 		ssb_printk(KERN_ERR PFX
@@ -538,6 +550,7 @@ void ssb_pmu_set_ldo_voltage(struct ssb_
 	switch (bus->chip_id) {
 	case 0x4328:
 	case 0x5354:
+printk("Set LDO 4328/5354\n");
 		switch (id) {
 		case LDO_VOLT1:
 			addr = 2;
@@ -565,6 +578,7 @@ void ssb_pmu_set_ldo_voltage(struct ssb_
 		}
 		break;
 	case 0x4312:
+printk("Set LDO 4312\n");
 		if (SSB_WARN_ON(id != LDO_PAREF))
 			return;
 		addr = 0;
@@ -584,6 +598,7 @@ void ssb_pmu_set_ldo_paref(struct ssb_ch
 	struct ssb_bus *bus = cc->dev->bus;
 	int ldo;
 
+printk("Set LDO paref\n");
 	switch (bus->chip_id) {
 	case 0x4312:
 		ldo = SSB_PMURES_4312_PA_REF_LDO;

-- 
Greetings, Michael.
