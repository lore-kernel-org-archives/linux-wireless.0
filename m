Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:45731 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143AbaGAOTW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 10:19:22 -0400
Received: by mail-we0-f171.google.com with SMTP id q58so9831591wes.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2014 07:19:20 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: N-PHY: fixes for radio 0x2057
Date: Tue,  1 Jul 2014 16:19:07 +0200
Message-Id: <1404224348-28010-1-git-send-email-zajec5@gmail.com> (sfid-20140701_161929_246191_3D874FD1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable initialization and update calibration code to fix:
b43-phy0 ERROR: Radio 0x2057 rcal timeout
b43-phy0 debug: Radio 0x2057 rccal timeout
b43-phy0 debug: Radio 0x2057 rccal timeout
b43-phy0 ERROR: Radio 0x2057 rcal timeout

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c      | 63 +++++++++++++++++++++++++++++------
 drivers/net/wireless/b43/radio_2057.c | 20 +++++------
 2 files changed, 61 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 0fb5e14..8369a08 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -590,7 +590,9 @@ static void b43_nphy_set_rf_sequence(struct b43_wldev *dev, u8 cmd,
  * Radio 0x2057
  **************************************************/
 
-/* http://bcm-v4.sipsolutions.net/PHY/radio2057_rcal */
+/* Calibrate resistors in LPF of PLL?
+ * http://bcm-v4.sipsolutions.net/PHY/radio205x_rcal
+ */
 static u8 b43_radio_2057_rcal(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -603,15 +605,25 @@ static u8 b43_radio_2057_rcal(struct b43_wldev *dev)
 		b43_radio_maskset(dev, 0x1ca, ~0x2, 0x1);
 	}
 
+	/* Enable */
 	b43_radio_set(dev, R2057_RCAL_CONFIG, 0x1);
 	udelay(10);
-	b43_radio_set(dev, R2057_RCAL_CONFIG, 0x3);
-	if (!b43_radio_wait_value(dev, R2057_RCCAL_N1_1, 1, 1, 100, 1000000)) {
+
+	/* Start */
+	b43_radio_set(dev, R2057_RCAL_CONFIG, 0x2);
+	usleep_range(100, 200);
+
+	/* Stop */
+	b43_radio_mask(dev, R2057_RCAL_CONFIG, ~0x2);
+
+	/* Wait and check for result */
+	if (!b43_radio_wait_value(dev, R2057_RCAL_STATUS, 1, 1, 100, 1000000)) {
 		b43err(dev->wl, "Radio 0x2057 rcal timeout\n");
 		return 0;
 	}
-	b43_radio_mask(dev, R2057_RCAL_CONFIG, ~0x2);
 	tmp = b43_radio_read(dev, R2057_RCAL_STATUS) & 0x3E;
+
+	/* Disable */
 	b43_radio_mask(dev, R2057_RCAL_CONFIG, ~0x1);
 
 	if (phy->radio_rev == 5) {
@@ -627,7 +639,9 @@ static u8 b43_radio_2057_rcal(struct b43_wldev *dev)
 	return tmp & 0x3e;
 }
 
-/* http://bcm-v4.sipsolutions.net/PHY/radio2057_rccal */
+/* Calibrate the internal RC oscillator?
+ * http://bcm-v4.sipsolutions.net/PHY/radio2057_rccal
+ */
 static u16 b43_radio_2057_rccal(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -635,49 +649,76 @@ static u16 b43_radio_2057_rccal(struct b43_wldev *dev)
 			phy->radio_rev == 6);
 	u16 tmp;
 
+	/* Setup cal */
 	if (special) {
 		b43_radio_write(dev, R2057_RCCAL_MASTER, 0x61);
 		b43_radio_write(dev, R2057_RCCAL_TRC0, 0xC0);
 	} else {
-		b43_radio_write(dev, 0x1AE, 0x61);
+		b43_radio_write(dev, R2057v7_RCCAL_MASTER, 0x61);
 		b43_radio_write(dev, R2057_RCCAL_TRC0, 0xE1);
 	}
 	b43_radio_write(dev, R2057_RCCAL_X1, 0x6E);
+
+	/* Start, wait, stop */
 	b43_radio_write(dev, R2057_RCCAL_START_R1_Q1_P1, 0x55);
-	if (!b43_radio_wait_value(dev, R2057_RCCAL_DONE_OSCCAP, 1, 1, 500,
+	if (!b43_radio_wait_value(dev, R2057_RCCAL_DONE_OSCCAP, 2, 2, 500,
 				  5000000))
 		b43dbg(dev->wl, "Radio 0x2057 rccal timeout\n");
+	usleep_range(35, 70);
 	b43_radio_write(dev, R2057_RCCAL_START_R1_Q1_P1, 0x15);
+	usleep_range(70, 140);
+
+	/* Setup cal */
 	if (special) {
 		b43_radio_write(dev, R2057_RCCAL_MASTER, 0x69);
 		b43_radio_write(dev, R2057_RCCAL_TRC0, 0xB0);
 	} else {
-		b43_radio_write(dev, 0x1AE, 0x69);
+		b43_radio_write(dev, R2057v7_RCCAL_MASTER, 0x69);
 		b43_radio_write(dev, R2057_RCCAL_TRC0, 0xD5);
 	}
 	b43_radio_write(dev, R2057_RCCAL_X1, 0x6E);
+
+	/* Start, wait, stop */
+	usleep_range(35, 70);
 	b43_radio_write(dev, R2057_RCCAL_START_R1_Q1_P1, 0x55);
-	if (!b43_radio_wait_value(dev, R2057_RCCAL_DONE_OSCCAP, 1, 1, 500,
+	usleep_range(70, 140);
+	if (!b43_radio_wait_value(dev, R2057_RCCAL_DONE_OSCCAP, 2, 2, 500,
 				  5000000))
 		b43dbg(dev->wl, "Radio 0x2057 rccal timeout\n");
+	usleep_range(35, 70);
 	b43_radio_write(dev, R2057_RCCAL_START_R1_Q1_P1, 0x15);
+	usleep_range(70, 140);
+
+	/* Setup cal */
 	if (special) {
 		b43_radio_write(dev, R2057_RCCAL_MASTER, 0x73);
 		b43_radio_write(dev, R2057_RCCAL_X1, 0x28);
 		b43_radio_write(dev, R2057_RCCAL_TRC0, 0xB0);
 	} else {
-		b43_radio_write(dev, 0x1AE, 0x73);
+		b43_radio_write(dev, R2057v7_RCCAL_MASTER, 0x73);
 		b43_radio_write(dev, R2057_RCCAL_X1, 0x6E);
 		b43_radio_write(dev, R2057_RCCAL_TRC0, 0x99);
 	}
+
+	/* Start, wait, stop */
+	usleep_range(35, 70);
 	b43_radio_write(dev, R2057_RCCAL_START_R1_Q1_P1, 0x55);
-	if (!b43_radio_wait_value(dev, R2057_RCCAL_DONE_OSCCAP, 1, 1, 500,
+	usleep_range(70, 140);
+	if (!b43_radio_wait_value(dev, R2057_RCCAL_DONE_OSCCAP, 2, 2, 500,
 				  5000000)) {
 		b43err(dev->wl, "Radio 0x2057 rcal timeout\n");
 		return 0;
 	}
 	tmp = b43_radio_read(dev, R2057_RCCAL_DONE_OSCCAP);
+	usleep_range(35, 70);
 	b43_radio_write(dev, R2057_RCCAL_START_R1_Q1_P1, 0x15);
+	usleep_range(70, 140);
+
+	if (special)
+		b43_radio_mask(dev, R2057_RCCAL_MASTER, ~0x1);
+	else
+		b43_radio_mask(dev, R2057v7_RCCAL_MASTER, ~0x1);
+
 	return tmp;
 }
 
diff --git a/drivers/net/wireless/b43/radio_2057.c b/drivers/net/wireless/b43/radio_2057.c
index d61d683..5e49440 100644
--- a/drivers/net/wireless/b43/radio_2057.c
+++ b/drivers/net/wireless/b43/radio_2057.c
@@ -26,7 +26,7 @@
 #include "radio_2057.h"
 #include "phy_common.h"
 
-static u16 r2057_rev4_init[42][2] = {
+static u16 r2057_rev4_init[][2] = {
 	{ 0x0E, 0x20 }, { 0x31, 0x00 }, { 0x32, 0x00 }, { 0x33, 0x00 },
 	{ 0x35, 0x26 }, { 0x3C, 0xff }, { 0x3D, 0xff }, { 0x3E, 0xff },
 	{ 0x3F, 0xff }, { 0x62, 0x33 }, { 0x8A, 0xf0 }, { 0x8B, 0x10 },
@@ -40,7 +40,7 @@ static u16 r2057_rev4_init[42][2] = {
 	{ 0x1AB, 0x00 }, { 0x1AC, 0x00 },
 };
 
-static u16 r2057_rev5_init[44][2] = {
+static u16 r2057_rev5_init[][2] = {
 	{ 0x00, 0x00 }, { 0x01, 0x57 }, { 0x02, 0x20 }, { 0x23, 0x6 },
 	{ 0x31, 0x00 }, { 0x32, 0x00 }, { 0x33, 0x00 }, { 0x51, 0x70 },
 	{ 0x59, 0x88 }, { 0x5C, 0x20 }, { 0x62, 0x33 }, { 0x63, 0x0f },
@@ -54,7 +54,7 @@ static u16 r2057_rev5_init[44][2] = {
 	{ 0x1AC, 0x00 }, { 0x1B7, 0x0c }, { 0x1C1, 0x01 }, { 0x1C2, 0x80 },
 };
 
-static u16 r2057_rev5a_init[45][2] = {
+static u16 r2057_rev5a_init[][2] = {
 	{ 0x00, 0x15 }, { 0x01, 0x57 }, { 0x02, 0x20 }, { 0x23, 0x6 },
 	{ 0x31, 0x00 }, { 0x32, 0x00 }, { 0x33, 0x00 }, { 0x51, 0x70 },
 	{ 0x59, 0x88 }, { 0x5C, 0x20 }, { 0x62, 0x33 }, { 0x63, 0x0f },
@@ -69,7 +69,7 @@ static u16 r2057_rev5a_init[45][2] = {
 	{ 0x1C2, 0x80 },
 };
 
-static u16 r2057_rev7_init[54][2] = {
+static u16 r2057_rev7_init[][2] = {
 	{ 0x00, 0x00 }, { 0x01, 0x57 }, { 0x02, 0x20 }, { 0x31, 0x00 },
 	{ 0x32, 0x00 }, { 0x33, 0x00 }, { 0x51, 0x70 }, { 0x59, 0x88 },
 	{ 0x5C, 0x20 }, { 0x62, 0x33 }, { 0x63, 0x0f }, { 0x64, 0x13 },
@@ -86,7 +86,7 @@ static u16 r2057_rev7_init[54][2] = {
 	{ 0x1B7, 0x05 }, { 0x1C2, 0xa0 },
 };
 
-static u16 r2057_rev8_init[54][2] = {
+static u16 r2057_rev8_init[][2] = {
 	{ 0x00, 0x08 }, { 0x01, 0x57 }, { 0x02, 0x20 }, { 0x31, 0x00 },
 	{ 0x32, 0x00 }, { 0x33, 0x00 }, { 0x51, 0x70 }, { 0x59, 0x88 },
 	{ 0x5C, 0x20 }, { 0x62, 0x33 }, { 0x63, 0x0f }, { 0x64, 0x0f },
@@ -130,12 +130,10 @@ void r2057_upload_inittabs(struct b43_wldev *dev)
 		}
 	}
 
+	B43_WARN_ON(!table);
+
 	if (table) {
-		for (i = 0; i < 10; i++) {
-			pr_info("radio_write 0x%X ", *table);
-			table++;
-			pr_info("0x%X\n", *table);
-			table++;
-		}
+		for (i = 0; i < size; i++, table += 2)
+			b43_radio_write(dev, table[0], table[1]);
 	}
 }
-- 
1.8.4.5

