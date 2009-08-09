Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:46601 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbZHISPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 14:15:12 -0400
Received: by fxm28 with SMTP id 28so578374fxm.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2009 11:15:12 -0700 (PDT)
Message-ID: <4A7F122D.3010803@gmail.com>
Date: Sun, 09 Aug 2009 20:15:09 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH] b43: LP-PHY: Implement STX synchronization
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The v2+ radio init (B2063) is now complete, modulo BCM4325 support.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/phy_lp.c |   57 +++++++++++++++++++++++++++++++++++-
 1 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 5d50943..27eadee 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -346,9 +346,60 @@ static void lpphy_2063_init(struct b43_wldev *dev)
 	b43_radio_write(dev, B2063_PA_SP2, 0x18);
 }
 
+struct lpphy_stx_table_entry {
+	u16 phy_offset;
+	u16 phy_shift;
+	u16 rf_addr;
+	u16 rf_shift;
+	u16 mask;
+};
+
+static const struct lpphy_stx_table_entry lpphy_stx_table[] = {
+	{ .phy_offset = 2, .phy_shift = 6, .rf_addr = 0x3d, .rf_shift = 3, .mask = 0x01, },
+	{ .phy_offset = 1, .phy_shift = 12, .rf_addr = 0x4c, .rf_shift = 1, .mask = 0x01, },
+	{ .phy_offset = 1, .phy_shift = 8, .rf_addr = 0x50, .rf_shift = 0, .mask = 0x7f, },
+	{ .phy_offset = 0, .phy_shift = 8, .rf_addr = 0x44, .rf_shift = 0, .mask = 0xff, },
+	{ .phy_offset = 1, .phy_shift = 0, .rf_addr = 0x4a, .rf_shift = 0, .mask = 0xff, },
+	{ .phy_offset = 0, .phy_shift = 4, .rf_addr = 0x4d, .rf_shift = 0, .mask = 0xff, },
+	{ .phy_offset = 1, .phy_shift = 4, .rf_addr = 0x4e, .rf_shift = 0, .mask = 0xff, },
+	{ .phy_offset = 0, .phy_shift = 12, .rf_addr = 0x4f, .rf_shift = 0, .mask = 0x0f, },
+	{ .phy_offset = 1, .phy_shift = 0, .rf_addr = 0x4f, .rf_shift = 4, .mask = 0x0f, },
+	{ .phy_offset = 3, .phy_shift = 0, .rf_addr = 0x49, .rf_shift = 0, .mask = 0x0f, },
+	{ .phy_offset = 4, .phy_shift = 3, .rf_addr = 0x46, .rf_shift = 4, .mask = 0x07, },
+	{ .phy_offset = 3, .phy_shift = 15, .rf_addr = 0x46, .rf_shift = 0, .mask = 0x01, },
+	{ .phy_offset = 4, .phy_shift = 0, .rf_addr = 0x46, .rf_shift = 1, .mask = 0x07, },
+	{ .phy_offset = 3, .phy_shift = 8, .rf_addr = 0x48, .rf_shift = 4, .mask = 0x07, },
+	{ .phy_offset = 3, .phy_shift = 11, .rf_addr = 0x48, .rf_shift = 0, .mask = 0x0f, },
+	{ .phy_offset = 3, .phy_shift = 4, .rf_addr = 0x49, .rf_shift = 4, .mask = 0x0f, },
+	{ .phy_offset = 2, .phy_shift = 15, .rf_addr = 0x45, .rf_shift = 0, .mask = 0x01, },
+	{ .phy_offset = 5, .phy_shift = 13, .rf_addr = 0x52, .rf_shift = 4, .mask = 0x07, },
+	{ .phy_offset = 6, .phy_shift = 0, .rf_addr = 0x52, .rf_shift = 7, .mask = 0x01, },
+	{ .phy_offset = 5, .phy_shift = 3, .rf_addr = 0x41, .rf_shift = 5, .mask = 0x07, },
+	{ .phy_offset = 5, .phy_shift = 6, .rf_addr = 0x41, .rf_shift = 0, .mask = 0x0f, },
+	{ .phy_offset = 5, .phy_shift = 10, .rf_addr = 0x42, .rf_shift = 5, .mask = 0x07, },
+	{ .phy_offset = 4, .phy_shift = 15, .rf_addr = 0x42, .rf_shift = 0, .mask = 0x01, },
+	{ .phy_offset = 5, .phy_shift = 0, .rf_addr = 0x42, .rf_shift = 1, .mask = 0x07, },
+	{ .phy_offset = 4, .phy_shift = 11, .rf_addr = 0x43, .rf_shift = 4, .mask = 0x0f, },
+	{ .phy_offset = 4, .phy_shift = 7, .rf_addr = 0x43, .rf_shift = 0, .mask = 0x0f, },
+	{ .phy_offset = 4, .phy_shift = 6, .rf_addr = 0x45, .rf_shift = 1, .mask = 0x01, },
+	{ .phy_offset = 2, .phy_shift = 7, .rf_addr = 0x40, .rf_shift = 4, .mask = 0x0f, },
+	{ .phy_offset = 2, .phy_shift = 11, .rf_addr = 0x40, .rf_shift = 0, .mask = 0x0f, },
+};
+
 static void lpphy_sync_stx(struct b43_wldev *dev)
 {
-	//TODO
+	const struct lpphy_stx_table_entry *e;
+	unsigned int i;
+	u16 tmp;
+
+	for (i = 0; i < ARRAY_SIZE(lpphy_stx_table); i++) {
+		e = &lpphy_stx_table[i];
+		tmp = b43_radio_read(dev, e->rf_addr);
+		tmp >>= e->rf_shift;
+		tmp <<= e->phy_shift;
+		b43_phy_maskset(dev, B43_PHY_OFDM(0xF2 + e->phy_offset),
+				e->mask << e->phy_shift, tmp);
+	}
 }
 
 static void lpphy_radio_init(struct b43_wldev *dev)
@@ -366,7 +417,9 @@ static void lpphy_radio_init(struct b43_wldev *dev)
 		lpphy_sync_stx(dev);
 		b43_phy_write(dev, B43_PHY_OFDM(0xF0), 0x5F80);
 		b43_phy_write(dev, B43_PHY_OFDM(0xF1), 0);
-		//TODO Do something on the backplane
+		if (dev->dev->bus->chip_id == 0x4325) {
+			// TODO SSB PMU recalibration
+		}
 	}
 }
 
-- 
1.6.2.4


