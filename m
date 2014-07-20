Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:40284 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaGTK5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 06:57:53 -0400
Received: by mail-we0-f171.google.com with SMTP id p10so6340617wes.30
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 03:57:51 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: extract one more radio parameter: version
Date: Sun, 20 Jul 2014 12:57:45 +0200
Message-Id: <1405853865-11764-1-git-send-email-zajec5@gmail.com> (sfid-20140720_125757_030964_7EA86FEF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some radios may share the same ID and revision but differ by a version.
E.g. radio in BCM5357B0 is version 1 and requires specific handling.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 46 ++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 73f629c..47b6fa5 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4385,8 +4385,9 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 	u8 phy_type;
 	u8 phy_rev;
 	u16 radio_manuf;
-	u16 radio_ver;
+	u16 radio_id;
 	u16 radio_rev;
+	u8 radio_ver;
 	int unsupported = 0;
 
 	/* Get PHY versioning */
@@ -4452,7 +4453,9 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 		radio_rev = b43_read16(dev, B43_MMIO_RADIO24_DATA);
 
 		b43_write16(dev, B43_MMIO_RADIO24_CONTROL, 1);
-		radio_ver = b43_read16(dev, B43_MMIO_RADIO24_DATA);
+		radio_id = b43_read16(dev, B43_MMIO_RADIO24_DATA);
+
+		radio_ver = 0; /* Is there version somewhere? */
 	} else if (core_rev >= 24) {
 		u16 radio24[3];
 
@@ -4461,12 +4464,10 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 			radio24[tmp] = b43_read16(dev, B43_MMIO_RADIO24_DATA);
 		}
 
-		/* Broadcom uses "id" for our "ver" and has separated "ver" */
-		/* radio_ver = (radio24[0] & 0xF0) >> 4; */
-
 		radio_manuf = 0x17F;
-		radio_ver = (radio24[2] << 8) | radio24[1];
+		radio_id = (radio24[2] << 8) | radio24[1];
 		radio_rev = (radio24[0] & 0xF);
+		radio_ver = (radio24[0] & 0xF0) >> 4;
 	} else {
 		if (dev->dev->chip_id == 0x4317) {
 			if (dev->dev->chip_rev == 0)
@@ -4485,15 +4486,16 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 				<< 16;
 		}
 		radio_manuf = (tmp & 0x00000FFF);
-		radio_ver = (tmp & 0x0FFFF000) >> 12;
+		radio_id = (tmp & 0x0FFFF000) >> 12;
 		radio_rev = (tmp & 0xF0000000) >> 28;
+		radio_ver = 0; /* Probably not available on old hw */
 	}
 
 	if (radio_manuf != 0x17F /* Broadcom */)
 		unsupported = 1;
 	switch (phy_type) {
 	case B43_PHYTYPE_A:
-		if (radio_ver != 0x2060)
+		if (radio_id != 0x2060)
 			unsupported = 1;
 		if (radio_rev != 1)
 			unsupported = 1;
@@ -4501,31 +4503,31 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_B:
-		if ((radio_ver & 0xFFF0) != 0x2050)
+		if ((radio_id & 0xFFF0) != 0x2050)
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_G:
-		if (radio_ver != 0x2050)
+		if (radio_id != 0x2050)
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_N:
-		if (radio_ver != 0x2055 && radio_ver != 0x2056 &&
-		    radio_ver != 0x2057)
+		if (radio_id != 0x2055 && radio_id != 0x2056 &&
+		    radio_id != 0x2057)
 			unsupported = 1;
-		if (radio_ver == 0x2057 &&
+		if (radio_id == 0x2057 &&
 		    !(radio_rev == 9 || radio_rev == 14))
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_LP:
-		if (radio_ver != 0x2062 && radio_ver != 0x2063)
+		if (radio_id != 0x2062 && radio_id != 0x2063)
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_HT:
-		if (radio_ver != 0x2059)
+		if (radio_id != 0x2059)
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_LCN:
-		if (radio_ver != 0x2064)
+		if (radio_id != 0x2064)
 			unsupported = 1;
 		break;
 	default:
@@ -4533,15 +4535,17 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 	}
 	if (unsupported) {
 		b43err(dev->wl,
-		       "FOUND UNSUPPORTED RADIO (Manuf 0x%X, ID 0x%X, Revision %u)\n",
-		       radio_manuf, radio_ver, radio_rev);
+		       "FOUND UNSUPPORTED RADIO (Manuf 0x%X, ID 0x%X, Revision %u, Version %u)\n",
+		       radio_manuf, radio_id, radio_rev, radio_ver);
 		return -EOPNOTSUPP;
 	}
-	b43info(dev->wl, "Found Radio: Manuf 0x%X, ID 0x%X, Revision %u\n",
-		radio_manuf, radio_ver, radio_rev);
+	b43info(dev->wl,
+		"Found Radio: Manuf 0x%X, ID 0x%X, Revision %u, Version %u\n",
+		radio_manuf, radio_id, radio_rev, radio_ver);
 
+	/* FIXME: b43 treats "id" as "ver" and ignores the real "ver" */
 	phy->radio_manuf = radio_manuf;
-	phy->radio_ver = radio_ver;
+	phy->radio_ver = radio_id;
 	phy->radio_rev = radio_rev;
 
 	phy->analog = analog_type;
-- 
1.8.4.5

