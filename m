Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41521 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab1DTAjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 20:39:47 -0400
Received: by eyx24 with SMTP id 24so63446eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 17:39:45 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH] ssb: cc: add & fix defines
Date: Wed, 20 Apr 2011 03:17:12 +0200
Message-Id: <1303262232-2605-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
With updated defines following MMIO with defines makes sense:
 read32 0xf04001e0 -> 0x00010000
write32 0xf04001e0 <- 0x00010002	|= SSB_CHIPCO_CLKCTLST_FORCEHT
 read32 0xf04001e0 -> 0x00010002
(...)
 read32 0xf04001e0 -> 0x00010002
 read32 0xf04001e0 -> 0x00010002
 read32 0xf04001e0 -> 0x00030002	(& SSB_CHIPCO_CLKCTLST_HAVEHT)

Of course MMIO does not come from 4328. It is from 4312 and wl (just SSB defs).

The tricky part is that we were using SSB_CHIPCO_CLKCTLST_HAVEHT in PMU driver.

My guess is that we were always checking for the wrong register and we got
false positives on test for turning PLL down.
---
 include/linux/ssb/ssb_driver_chipcommon.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/ssb/ssb_driver_chipcommon.h b/include/linux/ssb/ssb_driver_chipcommon.h
index ba83bc5..45e7b6c 100644
--- a/include/linux/ssb/ssb_driver_chipcommon.h
+++ b/include/linux/ssb/ssb_driver_chipcommon.h
@@ -133,6 +133,9 @@
 #define SSB_CHIPCO_GPIOIRQ		0x0074
 #define SSB_CHIPCO_WATCHDOG		0x0080
 #define SSB_CHIPCO_GPIOTIMER		0x0088		/* LED powersave (corerev >= 16) */
+#define  SSB_CHIPCO_GPIOTIMER_OFFTIME	0x0000FFFF
+#define  SSB_CHIPCO_GPIOTIMER_OFFTIME_SHIFT	0
+#define  SSB_CHIPCO_GPIOTIMER_ONTIME	0xFFFF0000
 #define  SSB_CHIPCO_GPIOTIMER_ONTIME_SHIFT	16
 #define SSB_CHIPCO_GPIOTOUTM		0x008C		/* LED powersave (corerev >= 16) */
 #define SSB_CHIPCO_CLOCK_N		0x0090
@@ -191,8 +194,10 @@
 #define  SSB_CHIPCO_CLKCTLST_HAVEALPREQ	0x00000008 /* ALP available request */
 #define  SSB_CHIPCO_CLKCTLST_HAVEHTREQ	0x00000010 /* HT available request */
 #define  SSB_CHIPCO_CLKCTLST_HWCROFF	0x00000020 /* Force HW clock request off */
-#define  SSB_CHIPCO_CLKCTLST_HAVEHT	0x00010000 /* HT available */
-#define  SSB_CHIPCO_CLKCTLST_HAVEALP	0x00020000 /* APL available */
+#define  SSB_CHIPCO_CLKCTLST_HAVEHT	0x00010000 /* ALP available */
+#define  SSB_CHIPCO_CLKCTLST_HAVEALP	0x00020000 /* HT available */
+#define  SSB_CHIPCO_CLKCTLST_4328A0_HAVEHT	0x00010000 /* 4328a0 has reversed bits */
+#define  SSB_CHIPCO_CLKCTLST_4328A0_HAVEALP	0x00020000 /* 4328a0 has reversed bits */
 #define SSB_CHIPCO_HW_WORKAROUND	0x01E4 /* Hardware workaround (rev >= 20) */
 #define SSB_CHIPCO_UART0_DATA		0x0300
 #define SSB_CHIPCO_UART0_IMR		0x0304
-- 
1.7.3.4

