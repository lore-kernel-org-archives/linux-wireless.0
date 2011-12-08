Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:54408 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1LHQVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 11:21:32 -0500
Received: by wgbds13 with SMTP id ds13so1567877wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 08:21:31 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] bcma: extract FEM info from SPROM
Date: Thu,  8 Dec 2011 18:02:22 +0100
Message-Id: <1323363742-10603-2-git-send-email-zajec5@gmail.com> (sfid-20111208_172135_439270_8144305B)
In-Reply-To: <1323363742-10603-1-git-send-email-zajec5@gmail.com>
References: <1323363742-10603-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/sprom.c                        |   22 ++++++++++++++++++++++
 include/linux/bcma/bcma_driver_chipcommon.h |    1 +
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index d729239..b6c474b 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -142,6 +142,28 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 	bus->sprom.boardflags2_hi = sprom[SPOFF(SSB_SPROM8_BFL2HI)];
 
 	bus->sprom.country_code = sprom[SPOFF(SSB_SPROM8_CCODE)];
+
+	bus->sprom.fem.ghz2.tssipos = (sprom[SPOFF(SSB_SPROM8_FEM2G)] &
+		SSB_SROM8_FEM_TSSIPOS) >> SSB_SROM8_FEM_TSSIPOS_SHIFT;
+	bus->sprom.fem.ghz2.extpa_gain = (sprom[SPOFF(SSB_SPROM8_FEM2G)] &
+		SSB_SROM8_FEM_EXTPA_GAIN) >> SSB_SROM8_FEM_EXTPA_GAIN_SHIFT;
+	bus->sprom.fem.ghz2.pdet_range = (sprom[SPOFF(SSB_SPROM8_FEM2G)] &
+		SSB_SROM8_FEM_PDET_RANGE) >> SSB_SROM8_FEM_PDET_RANGE_SHIFT;
+	bus->sprom.fem.ghz2.tr_iso = (sprom[SPOFF(SSB_SPROM8_FEM2G)] &
+		SSB_SROM8_FEM_TR_ISO) >> SSB_SROM8_FEM_TR_ISO_SHIFT;
+	bus->sprom.fem.ghz2.antswlut = (sprom[SPOFF(SSB_SPROM8_FEM2G)] &
+		SSB_SROM8_FEM_ANTSWLUT) >> SSB_SROM8_FEM_ANTSWLUT_SHIFT;
+
+	bus->sprom.fem.ghz5.tssipos = (sprom[SPOFF(SSB_SPROM8_FEM5G)] &
+		SSB_SROM8_FEM_TSSIPOS) >> SSB_SROM8_FEM_TSSIPOS_SHIFT;
+	bus->sprom.fem.ghz5.extpa_gain = (sprom[SPOFF(SSB_SPROM8_FEM5G)] &
+		SSB_SROM8_FEM_EXTPA_GAIN) >> SSB_SROM8_FEM_EXTPA_GAIN_SHIFT;
+	bus->sprom.fem.ghz5.pdet_range = (sprom[SPOFF(SSB_SPROM8_FEM5G)] &
+		SSB_SROM8_FEM_PDET_RANGE) >> SSB_SROM8_FEM_PDET_RANGE_SHIFT;
+	bus->sprom.fem.ghz5.tr_iso = (sprom[SPOFF(SSB_SPROM8_FEM5G)] &
+		SSB_SROM8_FEM_TR_ISO) >> SSB_SROM8_FEM_TR_ISO_SHIFT;
+	bus->sprom.fem.ghz5.antswlut = (sprom[SPOFF(SSB_SPROM8_FEM5G)] &
+		SSB_SROM8_FEM_ANTSWLUT) >> SSB_SROM8_FEM_ANTSWLUT_SHIFT;
 }
 
 int bcma_sprom_get(struct bcma_bus *bus)
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 1526d96..a33086a 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -203,6 +203,7 @@
 #define BCMA_CC_PMU_CTL			0x0600 /* PMU control */
 #define  BCMA_CC_PMU_CTL_ILP_DIV	0xFFFF0000 /* ILP div mask */
 #define  BCMA_CC_PMU_CTL_ILP_DIV_SHIFT	16
+#define  BCMA_CC_PMU_CTL_PLL_UPD	0x00000400
 #define  BCMA_CC_PMU_CTL_NOILPONW	0x00000200 /* No ILP on wait */
 #define  BCMA_CC_PMU_CTL_HTREQEN	0x00000100 /* HT req enable */
 #define  BCMA_CC_PMU_CTL_ALPREQEN	0x00000080 /* ALP req enable */
-- 
1.7.3.4

