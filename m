Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:50658 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab3CGPrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 10:47:47 -0500
Received: by mail-ea0-f175.google.com with SMTP id d1so1577965eab.6
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 07:47:45 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 03/13] b43: HT-PHY: move TX fix to the separated function
Date: Thu,  7 Mar 2013 16:47:17 +0100
Message-Id: <1362671247-10766-4-git-send-email-zajec5@gmail.com> (sfid-20130307_164750_550257_4B7981C7)
In-Reply-To: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On N-PHY after B43_PHY_B_TEST operation there is a call to TX power fix
function which iterates over available cores. It matches our HT-PHY code
which means it's probably also some TX fix.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   46 ++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 2a65d01..f7463aa 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -256,6 +256,32 @@ static void b43_phy_ht_bphy_init(struct b43_wldev *dev)
 }
 
 /**************************************************
+ * Tx/Rx
+ **************************************************/
+
+static void b43_phy_ht_tx_power_fix(struct b43_wldev *dev)
+{
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		u16 mask;
+		u32 tmp = b43_httab_read(dev, B43_HTTAB32(26, 0xE8));
+
+		if (0) /* FIXME */
+			mask = 0x2 << (i * 4);
+		else
+			mask = 0;
+		b43_phy_mask(dev, B43_PHY_EXTG(0x108), mask);
+
+		b43_httab_write(dev, B43_HTTAB16(7, 0x110 + i), tmp >> 16);
+		b43_httab_write(dev, B43_HTTAB8(13, 0x63 + (i * 4)),
+				tmp & 0xFF);
+		b43_httab_write(dev, B43_HTTAB8(13, 0x73 + (i * 4)),
+				tmp & 0xFF);
+	}
+}
+
+/**************************************************
  * Channel switching ops.
  **************************************************/
 
@@ -264,7 +290,6 @@ static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
 				struct ieee80211_channel *new_channel)
 {
 	bool old_band_5ghz;
-	u8 i;
 
 	old_band_5ghz = b43_phy_read(dev, B43_PHY_HT_BANDCTL) & 0; /* FIXME */
 	if (new_channel->band == IEEE80211_BAND_5GHZ && !old_band_5ghz) {
@@ -290,23 +315,8 @@ static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
 			b43_phy_mask(dev, B43_PHY_HT_TEST, ~0x840);
 	}
 
-	/* TODO: separated function? */
-	for (i = 0; i < 3; i++) {
-		u16 mask;
-		u32 tmp = b43_httab_read(dev, B43_HTTAB32(26, 0xE8));
-
-		if (0) /* FIXME */
-			mask = 0x2 << (i * 4);
-		else
-			mask = 0;
-		b43_phy_mask(dev, B43_PHY_EXTG(0x108), mask);
-
-		b43_httab_write(dev, B43_HTTAB16(7, 0x110 + i), tmp >> 16);
-		b43_httab_write(dev, B43_HTTAB8(13, 0x63 + (i * 4)),
-				tmp & 0xFF);
-		b43_httab_write(dev, B43_HTTAB8(13, 0x73 + (i * 4)),
-				tmp & 0xFF);
-	}
+	if (1) /* TODO: On N it's for early devices only, what about HT? */
+		b43_phy_ht_tx_power_fix(dev);
 
 	b43_phy_write(dev, 0x017e, 0x3830);
 }
-- 
1.7.10.4

