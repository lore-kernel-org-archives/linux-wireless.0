Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:56771 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaGDHWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2014 03:22:13 -0400
Received: by mail-we0-f178.google.com with SMTP id x48so1228070wes.37
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2014 00:22:12 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: fix reading info about radio for new devices (cores 40 & 42)
Date: Fri,  4 Jul 2014 09:21:56 +0200
Message-Id: <1404458516-2074-1-git-send-email-zajec5@gmail.com> (sfid-20140704_092223_489403_70906C50)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This changes
b43-phy0: Found Radio: Manuf 0x17F, Version 0x7769, Revision 4
to the
b43-phy0: Found Radio: Manuf 0x17F, Version 0x2069, Revision 4
which matches what closed source driver reports:
$ wl revinfo
radiorev 0x42069000

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 1b02016..83b2d56 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4329,6 +4329,7 @@ static char *b43_phy_name(struct b43_wldev *dev, u8 phy_type)
 static int b43_phy_versioning(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
+	const u8 core_rev = dev->dev->core_rev;
 	u32 tmp;
 	u8 analog_type;
 	u8 phy_type;
@@ -4394,7 +4395,15 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 		analog_type, phy_type, b43_phy_name(dev, phy_type), phy_rev);
 
 	/* Get RADIO versioning */
-	if (dev->dev->core_rev >= 24) {
+	if (core_rev == 40 || core_rev == 42) {
+		radio_manuf = 0x17F;
+
+		b43_write16(dev, B43_MMIO_RADIO24_CONTROL, 0);
+		radio_rev = b43_read16(dev, B43_MMIO_RADIO24_DATA);
+
+		b43_write16(dev, B43_MMIO_RADIO24_CONTROL, 1);
+		radio_ver = b43_read16(dev, B43_MMIO_RADIO24_DATA);
+	} else if (core_rev >= 24) {
 		u16 radio24[3];
 
 		for (tmp = 0; tmp < 3; tmp++) {
-- 
1.8.4.5

