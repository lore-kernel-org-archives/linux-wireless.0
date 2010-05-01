Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41130 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab0EAQ3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 12:29:09 -0400
Received: by fxm10 with SMTP id 10so1036971fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 May 2010 09:29:05 -0700 (PDT)
Message-ID: <4BDC56D2.5060605@gmail.com>
Date: Sat, 01 May 2010 18:29:06 +0200
From: =?ISO-8859-2?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <larry.finger@lwfinger.net>
Subject: [PATCH] ssb: Implement fast powerup delay calculation
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement fast powerup delay calculation, as described
in the recently updated specs. The 4325 part is coming soon.

Signed-off-by: Gábor Stefanik<netrolller.3d@gmail.com>
---

To people experiencing DMA errors: please test this patch, it touches
the PMU code, one of the suspected problem areas.

I'm submitting this patch using Thunderbird 3; so I cannot be held liable
if it gets damaged in transit. Blame Mozilla. :-)

Index: wireless-testing/drivers/ssb/driver_chipcommon.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_chipcommon.c
+++ wireless-testing/drivers/ssb/driver_chipcommon.c
@@ -209,7 +209,24 @@ static void chipco_powercontrol_init(str
  	}
  }

-static void calc_fast_powerup_delay(struct ssb_chipcommon *cc)
+static u16 pmu_fast_powerup_delay(struct ssb_chipcommon *cc)
+{
+	struct ssb_bus *bus = cc->dev->bus;
+
+	switch (bus->chip_id) {
+	case 0x4312:
+	case 0x4322:
+	case 0x4328:
+		return 7000;
+	case 0x4325:
+		/* TODO: */
+	default:
+		break;
+	}
+	return 15000;
+}
+
+static u16 calc_fast_powerup_delay(struct ssb_chipcommon *cc)
  {
  	struct ssb_bus *bus = cc->dev->bus;
  	int minfreq;
@@ -217,26 +234,33 @@ static void calc_fast_powerup_delay(stru
  	u32 pll_on_delay;

  	if (bus->bustype != SSB_BUSTYPE_PCI)
-		return;
+		return 0;
+	if (cc->capabilities&  SSB_CHIPCO_CAP_PMU)
+		return pmu_fast_powerup_delay(cc);
  	if (!(cc->capabilities&  SSB_CHIPCO_CAP_PCTL))
-		return;
+		return 0;

  	minfreq = chipco_pctl_clockfreqlimit(cc, 0);
  	pll_on_delay = chipco_read32(cc, SSB_CHIPCO_PLLONDELAY);
  	tmp = (((pll_on_delay + 2) * 1000000) + (minfreq - 1)) / minfreq;
  	SSB_WARN_ON(tmp&  ~0xFFFF);

-	cc->fast_pwrup_delay = tmp;
+	return tmp;
  }

  void ssb_chipcommon_init(struct ssb_chipcommon *cc)
  {
+	u16 delay;
+
  	if (!cc->dev)
  		return; /* We don't have a ChipCommon */
  	ssb_pmu_init(cc);
  	chipco_powercontrol_init(cc);
  	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_FAST);
-	calc_fast_powerup_delay(cc);
+	delay = calc_fast_powerup_delay(cc);
+	ssb_printk(KERN_INFO PFX "fast_pwrup_delay is %d\n", delay);
+	cc->fast_pwrup_delay = delay;
+	ssb_write16(cc->dev, SSB_MMIO_POWERUP_DELAY, delay);
  }

  void ssb_chipco_suspend(struct ssb_chipcommon *cc)
Index: wireless-testing/include/linux/ssb/ssb_regs.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb_regs.h
+++ wireless-testing/include/linux/ssb/ssb_regs.h
@@ -26,6 +26,7 @@
  #define	SSB_EUART		(SSB_EXTIF_BASE + 0x00800000)
  #define	SSB_LED			(SSB_EXTIF_BASE + 0x00900000)

+#define SSB_MMIO_POWERUP_DELAY	0x06A8

  /* Enumeration space constants */
  #define SSB_CORE_SIZE		0x1000	/* Size of a core MMIO area */


