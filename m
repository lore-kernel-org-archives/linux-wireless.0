Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46188 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab1EJXaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 19:30:25 -0400
Received: by ewy4 with SMTP id 4so1975561ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 16:30:24 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: add missing GPIO defines, use PULL register only when available
Date: Wed, 11 May 2011 02:08:09 +0200
Message-Id: <1305072489-3936-1-git-send-email-zajec5@gmail.com> (sfid-20110511_013029_830578_57848CF9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar patch was commited to ssb.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon.c            |    6 ++++--
 include/linux/bcma/bcma_driver_chipcommon.h |    5 +++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index caf5960..6061022 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -29,8 +29,10 @@ void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
 	if (cc->core->id.rev >= 35)
 		cc->capabilities_ext = bcma_cc_read32(cc, BCMA_CC_CAP_EXT);
 
-	bcma_cc_write32(cc, 0x58, 0);
-	bcma_cc_write32(cc, 0x5C, 0);
+	if (cc->core->id.rev >= 20) {
+		bcma_cc_write32(cc, BCMA_CC_GPIOPULLUP, 0);
+		bcma_cc_write32(cc, BCMA_CC_GPIOPULLDOWN, 0);
+	}
 
 	if (cc->capabilities & BCMA_CC_CAP_PMU)
 		bcma_pmu_init(cc);
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 4f8fd6a..083c3b6 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -113,6 +113,8 @@
 #define BCMA_CC_FLASHDATA		0x0048
 #define BCMA_CC_BCAST_ADDR		0x0050
 #define BCMA_CC_BCAST_DATA		0x0054
+#define BCMA_CC_GPIOPULLUP		0x0058		/* Rev >= 20 only */
+#define BCMA_CC_GPIOPULLDOWN		0x005C		/* Rev >= 20 only */
 #define BCMA_CC_GPIOIN			0x0060
 #define BCMA_CC_GPIOOUT			0x0064
 #define BCMA_CC_GPIOOUTEN		0x0068
@@ -121,6 +123,9 @@
 #define BCMA_CC_GPIOIRQ			0x0074
 #define BCMA_CC_WATCHDOG		0x0080
 #define BCMA_CC_GPIOTIMER		0x0088		/* LED powersave (corerev >= 16) */
+#define  BCMA_CC_GPIOTIMER_OFFTIME	0x0000FFFF
+#define  BCMA_CC_GPIOTIMER_OFFTIME_SHIFT	0
+#define  BCMA_CC_GPIOTIMER_ONTIME	0xFFFF0000
 #define  BCMA_CC_GPIOTIMER_ONTIME_SHIFT	16
 #define BCMA_CC_GPIOTOUTM		0x008C		/* LED powersave (corerev >= 16) */
 #define BCMA_CC_CLOCK_N			0x0090
-- 
1.7.3.4

