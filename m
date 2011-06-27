Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:42178 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab1F0M6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 08:58:12 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so1789080fxd.11
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 05:58:11 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/5] b43: HT-PHY: perform some tables ops on channel switching
Date: Mon, 27 Jun 2011 14:58:52 +0200
Message-Id: <1309179534-8081-3-git-send-email-zajec5@gmail.com> (sfid-20110627_150220_562675_74E927E8)
In-Reply-To: <1309179534-8081-1-git-send-email-zajec5@gmail.com>
References: <1309179534-8081-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Starring at MMIO dumps around PHY channel switching has led to finding
serie of 3 similar ops this patch implements.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
The interesting part of MMIO dump:
phy_write(0x01ce) <- 0x03dd
phy_write(0x01cf) <- 0x03d9
phy_write(0x01d0) <- 0x03d5
phy_write(0x01d1) <- 0x0424
phy_write(0x01d2) <- 0x0429
phy_write(0x01d3) <- 0x042d
>>> Uploading PHY tables end

>>> Some magic ops start
 phy_read(0x00b0) -> 0x0df7
 phy_read(0x00b0) -> 0x0df7
phy_write(0x00b0) <- 0x0df7
 phy_read(0x0c0a) -> 0x0100
phy_write(0x0c0a) <- 0x0100
>>> Some magic ops end

phy_write(0x0072) <- 0x68e8
 phy_read(0x0073) -> 0x0033
 phy_read(0x0074) -> 0x1019
 phy_read(0x0908) -> 0x0000
phy_write(0x0908) <- 0x0000
phy_write(0x0072) <- 0x1d10
phy_write(0x0073) <- 0x1019
phy_write(0x0072) <- 0x3463
phy_write(0x0073) <- 0x0033
phy_write(0x0072) <- 0x3473
phy_write(0x0073) <- 0x0033

phy_write(0x0072) <- 0x68e8
 phy_read(0x0073) -> 0x0033
 phy_read(0x0074) -> 0x1019
 phy_read(0x0908) -> 0x0000
phy_write(0x0908) <- 0x0000
phy_write(0x0072) <- 0x1d11
phy_write(0x0073) <- 0x1019
phy_write(0x0072) <- 0x3467
phy_write(0x0073) <- 0x0033
phy_write(0x0072) <- 0x3477
phy_write(0x0073) <- 0x0033

phy_write(0x0072) <- 0x68e8
 phy_read(0x0073) -> 0x0033
 phy_read(0x0074) -> 0x1019
 phy_read(0x0908) -> 0x0000
phy_write(0x0908) <- 0x0000
phy_write(0x0072) <- 0x1d12
phy_write(0x0073) <- 0x1019
phy_write(0x0072) <- 0x346b
phy_write(0x0073) <- 0x0033
phy_write(0x0072) <- 0x347b
phy_write(0x0073) <- 0x0033
---
 drivers/net/wireless/b43/phy_ht.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index c48bcf6..42bea30 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -24,6 +24,7 @@
 
 #include "b43.h"
 #include "phy_ht.h"
+#include "tables_phy_ht.h"
 #include "radio_2059.h"
 #include "main.h"
 
@@ -83,6 +84,7 @@ static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
 				struct ieee80211_channel *new_channel)
 {
 	bool old_band_5ghz;
+	u8 i;
 
 	old_band_5ghz = b43_phy_read(dev, B43_PHY_HT_BANDCTL) & 0; /* FIXME */
 	if (new_channel->band == IEEE80211_BAND_5GHZ && !old_band_5ghz) {
@@ -97,6 +99,23 @@ static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
 	b43_phy_write(dev, B43_PHY_HT_BW4, e->bw4);
 	b43_phy_write(dev, B43_PHY_HT_BW5, e->bw5);
 	b43_phy_write(dev, B43_PHY_HT_BW6, e->bw6);
+
+	/* TODO: some ops on PHY regs 0x0B0 and 0xC0A */
+
+	/* TODO: separated function? */
+	for (i = 0; i < 3; i++) {
+		u32 tmp = b43_httab_read(dev, B43_HTTAB32(26, 0xE8));
+
+		/* TODO: some op on PHY reg 0x908 */
+
+		b43_httab_write(dev, B43_HTTAB16(7, 0x110 + i), tmp >> 16);
+		b43_httab_write(dev, B43_HTTAB8(13, 0x63 + (i * 4)),
+				tmp & 0xFF);
+		b43_httab_write(dev, B43_HTTAB8(13, 0x73 + (i * 4)),
+				tmp & 0xFF);
+	}
+
+	b43_phy_write(dev, 0x017e, 0x3830);
 }
 
 static int b43_phy_ht_set_channel(struct b43_wldev *dev,
-- 
1.7.1

