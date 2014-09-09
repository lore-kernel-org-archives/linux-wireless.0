Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38266 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaIITSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 15:18:30 -0400
Received: by mail-wi0-f175.google.com with SMTP id ex7so4898457wid.2
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2014 12:18:28 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/4] b43: HT-PHY: Define some regs for 0x2059 radio
Date: Tue,  9 Sep 2014 21:17:08 +0200
Message-Id: <1410290229-7033-3-git-send-email-zajec5@gmail.com> (sfid-20140909_211847_428288_A7387650)
In-Reply-To: <1410290229-7033-1-git-send-email-zajec5@gmail.com>
References: <1410290229-7033-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c     | 55 ++++++++++++++++++++++-------------
 drivers/net/wireless/b43/radio_2059.h | 12 ++++++++
 2 files changed, 46 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index ff31c20..d346053 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -81,10 +81,10 @@ static void b43_radio_2059_channel_setup(struct b43_wldev *dev,
 	udelay(50);
 
 	/* Calibration */
-	b43_radio_mask(dev, 0x2b, ~0x1);
-	b43_radio_mask(dev, 0x2e, ~0x4);
-	b43_radio_set(dev, 0x2e, 0x4);
-	b43_radio_set(dev, 0x2b, 0x1);
+	b43_radio_mask(dev, R2059_RFPLL_MISC_EN, ~0x1);
+	b43_radio_mask(dev, R2059_RFPLL_MISC_CAL_RESETN, ~0x4);
+	b43_radio_set(dev, R2059_RFPLL_MISC_CAL_RESETN, 0x4);
+	b43_radio_set(dev, R2059_RFPLL_MISC_EN, 0x1);
 
 	udelay(300);
 }
@@ -92,20 +92,27 @@ static void b43_radio_2059_channel_setup(struct b43_wldev *dev,
 /* Calibrate resistors in LPF of PLL? */
 static void b43_radio_2059_rcal(struct b43_wldev *dev)
 {
-	b43_radio_set(dev, R2059_C3 | 0x4, 0x1);
+	/* Enable */
+	b43_radio_set(dev, R2059_C3 | R2059_RCAL_CONFIG, 0x1);
 	usleep_range(10, 20);
+
 	b43_radio_set(dev, R2059_C3 | 0x0BF, 0x1);
 	b43_radio_maskset(dev, R2059_C3 | 0x19B, 0x3, 0x2);
 
-	b43_radio_set(dev, R2059_C3 | 0x4, 0x2);
+	/* Start */
+	b43_radio_set(dev, R2059_C3 | R2059_RCAL_CONFIG, 0x2);
 	usleep_range(100, 200);
-	b43_radio_mask(dev, R2059_C3 | 0x4, ~0x2);
 
-	if (!b43_radio_wait_value(dev, R2059_C3 | 0x145, 1, 1, 100,
+	/* Stop */
+	b43_radio_mask(dev, R2059_C3 | R2059_RCAL_CONFIG, ~0x2);
+
+	if (!b43_radio_wait_value(dev, R2059_C3 | R2059_RCAL_STATUS, 1, 1, 100,
 				  1000000))
 		b43err(dev->wl, "Radio 0x2059 rcal timeout\n");
 
-	b43_radio_mask(dev, R2059_C3 | 0x4, ~0x1);
+	/* Disable */
+	b43_radio_mask(dev, R2059_C3 | R2059_RCAL_CONFIG, ~0x1);
+
 	b43_radio_set(dev, 0xa, 0x60);
 }
 
@@ -118,19 +125,23 @@ static void b43_radio_2057_rccal(struct b43_wldev *dev)
 	int i;
 
 	for (i = 0; i < 3; i++) {
-		b43_radio_write(dev, 0x17F, radio_values[i][0]);
-		b43_radio_write(dev, 0x13D, 0x6E);
-		b43_radio_write(dev, 0x13E, radio_values[i][1]);
-		b43_radio_write(dev, 0x13C, 0x55);
+		b43_radio_write(dev, R2059_RCCAL_MASTER, radio_values[i][0]);
+		b43_radio_write(dev, R2059_RCCAL_X1, 0x6E);
+		b43_radio_write(dev, R2059_RCCAL_TRC0, radio_values[i][1]);
 
-		if (!b43_radio_wait_value(dev, 0x140, 2, 2,
+		/* Start */
+		b43_radio_write(dev, R2059_RCCAL_START_R1_Q1_P1, 0x55);
+
+		/* Wait */
+		if (!b43_radio_wait_value(dev, R2059_RCCAL_DONE_OSCCAP, 2, 2,
 					  500, 5000000))
 			b43err(dev->wl, "Radio 0x2059 rccal timeout\n");
 
-		b43_radio_write(dev, 0x13C, 0x15);
+		/* Stop */
+		b43_radio_write(dev, R2059_RCCAL_START_R1_Q1_P1, 0x15);
 	}
 
-	b43_radio_mask(dev, 0x17F, ~0x1);
+	b43_radio_mask(dev, R2059_RCCAL_MASTER, ~0x1);
 }
 
 static void b43_radio_2059_init_pre(struct b43_wldev *dev)
@@ -155,18 +166,20 @@ static void b43_radio_2059_init(struct b43_wldev *dev)
 	for (i = 0; i < ARRAY_SIZE(routing); i++)
 		b43_radio_set(dev, routing[i] | 0x146, 0x3);
 
-	b43_radio_set(dev, 0x2e, 0x0078);
-	b43_radio_set(dev, 0xc0, 0x0080);
+	/* Post init starts below */
+
+	b43_radio_set(dev, R2059_RFPLL_MISC_CAL_RESETN, 0x0078);
+	b43_radio_set(dev, R2059_XTAL_CONFIG2, 0x0080);
 	msleep(2);
-	b43_radio_mask(dev, 0x2e, ~0x0078);
-	b43_radio_mask(dev, 0xc0, ~0x0080);
+	b43_radio_mask(dev, R2059_RFPLL_MISC_CAL_RESETN, ~0x0078);
+	b43_radio_mask(dev, R2059_XTAL_CONFIG2, ~0x0080);
 
 	if (1) { /* FIXME */
 		b43_radio_2059_rcal(dev);
 		b43_radio_2057_rccal(dev);
 	}
 
-	b43_radio_mask(dev, 0x11, ~0x0008);
+	b43_radio_mask(dev, R2059_RFPLL_MASTER, ~0x0008);
 }
 
 /**************************************************
diff --git a/drivers/net/wireless/b43/radio_2059.h b/drivers/net/wireless/b43/radio_2059.h
index 40a82d7..9d828d5 100644
--- a/drivers/net/wireless/b43/radio_2059.h
+++ b/drivers/net/wireless/b43/radio_2059.h
@@ -10,6 +10,18 @@
 #define R2059_C3			0x800
 #define R2059_ALL			0xC00
 
+#define R2059_RCAL_CONFIG			0x004
+#define R2059_RFPLL_MASTER			0x011
+#define R2059_RFPLL_MISC_EN			0x02b
+#define R2059_RFPLL_MISC_CAL_RESETN		0x02e
+#define R2059_XTAL_CONFIG2			0x0c0
+#define R2059_RCCAL_START_R1_Q1_P1		0x13c
+#define R2059_RCCAL_X1				0x13d
+#define R2059_RCCAL_TRC0			0x13e
+#define R2059_RCCAL_DONE_OSCCAP			0x140
+#define R2059_RCAL_STATUS			0x145
+#define R2059_RCCAL_MASTER			0x17f
+
 /* Values for various registers uploaded on channel switching */
 struct b43_phy_ht_channeltab_e_radio2059 {
 	/* The channel frequency in MHz */
-- 
1.8.4.5

