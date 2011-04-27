Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59394 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab1D0PCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 11:02:40 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so1455241bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 08:02:40 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: cc: prepare clockmode support for cores rev 10+
Date: Wed, 27 Apr 2011 17:40:11 +0200
Message-Id: <1303918811-4949-1-git-send-email-zajec5@gmail.com> (sfid-20110427_170248_932570_DC6B4866)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_chipcommon.c |   60 ++++++++++++++++++++++++++++-----------
 1 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/drivers/ssb/driver_chipcommon.c b/drivers/ssb/driver_chipcommon.c
index b4b3733..06d15b6 100644
--- a/drivers/ssb/driver_chipcommon.c
+++ b/drivers/ssb/driver_chipcommon.c
@@ -46,40 +46,66 @@ void ssb_chipco_set_clockmode(struct ssb_chipcommon *cc,
 	if (!ccdev)
 		return;
 	bus = ccdev->bus;
+
+	/* We support SLOW only on 6..9 */
+	if (ccdev->id.revision >= 10 && mode == SSB_CLKMODE_SLOW)
+		mode = SSB_CLKMODE_DYNAMIC;
+
+	if (cc->capabilities & SSB_CHIPCO_CAP_PMU)
+		return; /* PMU controls clockmode, separated function needed */
+	SSB_WARN_ON(ccdev->id.revision >= 20);
+
 	/* chipcommon cores prior to rev6 don't support dynamic clock control */
 	if (ccdev->id.revision < 6)
 		return;
-	/* chipcommon cores rev10 are a whole new ball game */
+
+	/* ChipCommon cores rev10+ need testing */
 	if (ccdev->id.revision >= 10)
 		return;
+
 	if (!(cc->capabilities & SSB_CHIPCO_CAP_PCTL))
 		return;
 
 	switch (mode) {
-	case SSB_CLKMODE_SLOW:
+	case SSB_CLKMODE_SLOW: /* For revs 6..9 only */
 		tmp = chipco_read32(cc, SSB_CHIPCO_SLOWCLKCTL);
 		tmp |= SSB_CHIPCO_SLOWCLKCTL_FSLOW;
 		chipco_write32(cc, SSB_CHIPCO_SLOWCLKCTL, tmp);
 		break;
 	case SSB_CLKMODE_FAST:
-		ssb_pci_xtal(bus, SSB_GPIO_XTAL, 1); /* Force crystal on */
-		tmp = chipco_read32(cc, SSB_CHIPCO_SLOWCLKCTL);
-		tmp &= ~SSB_CHIPCO_SLOWCLKCTL_FSLOW;
-		tmp |= SSB_CHIPCO_SLOWCLKCTL_IPLL;
-		chipco_write32(cc, SSB_CHIPCO_SLOWCLKCTL, tmp);
+		if (ccdev->id.revision < 10) {
+			ssb_pci_xtal(bus, SSB_GPIO_XTAL, 1); /* Force crystal on */
+			tmp = chipco_read32(cc, SSB_CHIPCO_SLOWCLKCTL);
+			tmp &= ~SSB_CHIPCO_SLOWCLKCTL_FSLOW;
+			tmp |= SSB_CHIPCO_SLOWCLKCTL_IPLL;
+			chipco_write32(cc, SSB_CHIPCO_SLOWCLKCTL, tmp);
+		} else {
+			chipco_write32(cc, SSB_CHIPCO_SYSCLKCTL,
+				(chipco_read32(cc, SSB_CHIPCO_SYSCLKCTL) |
+				 SSB_CHIPCO_SYSCLKCTL_FORCEHT));
+			/* udelay(150); TODO: not available in early init */
+		}
 		break;
 	case SSB_CLKMODE_DYNAMIC:
-		tmp = chipco_read32(cc, SSB_CHIPCO_SLOWCLKCTL);
-		tmp &= ~SSB_CHIPCO_SLOWCLKCTL_FSLOW;
-		tmp &= ~SSB_CHIPCO_SLOWCLKCTL_IPLL;
-		tmp &= ~SSB_CHIPCO_SLOWCLKCTL_ENXTAL;
-		if ((tmp & SSB_CHIPCO_SLOWCLKCTL_SRC) != SSB_CHIPCO_SLOWCLKCTL_SRC_XTAL)
-			tmp |= SSB_CHIPCO_SLOWCLKCTL_ENXTAL;
-		chipco_write32(cc, SSB_CHIPCO_SLOWCLKCTL, tmp);
-
-		/* for dynamic control, we have to release our xtal_pu "force on" */
-		if (tmp & SSB_CHIPCO_SLOWCLKCTL_ENXTAL)
-			ssb_pci_xtal(bus, SSB_GPIO_XTAL, 0);
+		if (ccdev->id.revision < 10) {
+			tmp = chipco_read32(cc, SSB_CHIPCO_SLOWCLKCTL);
+			tmp &= ~SSB_CHIPCO_SLOWCLKCTL_FSLOW;
+			tmp &= ~SSB_CHIPCO_SLOWCLKCTL_IPLL;
+			tmp &= ~SSB_CHIPCO_SLOWCLKCTL_ENXTAL;
+			if ((tmp & SSB_CHIPCO_SLOWCLKCTL_SRC) !=
+			    SSB_CHIPCO_SLOWCLKCTL_SRC_XTAL)
+				tmp |= SSB_CHIPCO_SLOWCLKCTL_ENXTAL;
+			chipco_write32(cc, SSB_CHIPCO_SLOWCLKCTL, tmp);
+
+			/* For dynamic control, we have to release our xtal_pu
+			 * "force on" */
+			if (tmp & SSB_CHIPCO_SLOWCLKCTL_ENXTAL)
+				ssb_pci_xtal(bus, SSB_GPIO_XTAL, 0);
+		} else {
+			chipco_write32(cc, SSB_CHIPCO_SYSCLKCTL,
+				(chipco_read32(cc, SSB_CHIPCO_SYSCLKCTL) &
+				 ~SSB_CHIPCO_SYSCLKCTL_FORCEHT));
+		}
 		break;
 	default:
 		SSB_WARN_ON(1);
-- 
1.7.3.4

