Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:52952 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbZHKUYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 16:24:24 -0400
Received: by fxm28 with SMTP id 28so1762035fxm.17
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2009 13:24:23 -0700 (PDT)
Message-ID: <4A81D376.5020405@gmail.com>
Date: Tue, 11 Aug 2009 22:24:22 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: LP-PHY: Refactor TX gain table I/O
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make it possible to write individual gain table entries.
Allow gain table entries to be written outside gain table init.
Add version-agnostic helpers for writing gain tables.
Use the new TX gain table helpers during table init.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/tables_lpphy.c |   85 +++++++++++++++++--------------
 drivers/net/wireless/b43/tables_lpphy.h |    9 +++
 2 files changed, 55 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/b43/tables_lpphy.c b/drivers/net/wireless/b43/tables_lpphy.c
index 3507515..5fdb175 100644
--- a/drivers/net/wireless/b43/tables_lpphy.c
+++ b/drivers/net/wireless/b43/tables_lpphy.c
@@ -1058,10 +1058,6 @@ static const u32 lpphy_papd_mult_table[] = {
 	0x00036963, 0x000339f2, 0x00030a89, 0x0002db28,
 };
 
-struct lpphy_tx_gain_table_entry {
-	u8 gm,  pga,  pad,  dac,  bb_mult;
-};
-
 static struct lpphy_tx_gain_table_entry lpphy_rev0_nopa_tx_gain_table[] = {
 	{ .gm = 7, .pga = 15, .pad = 14, .dac = 0, .bb_mult = 152, },
 	{ .gm = 7, .pga = 15, .pad = 14, .dac = 0, .bb_mult = 147, },
@@ -2345,44 +2341,55 @@ void lpphy_rev2plus_table_init(struct b43_wldev *dev)
 	}
 }
 
-
-static void lpphy_rev0_1_write_gain_table(struct b43_wldev *dev,
-				struct lpphy_tx_gain_table_entry *table)
+static void lpphy_rev0_1_write_gain_table(struct b43_wldev *dev, int offset,
+				struct lpphy_tx_gain_table_entry data)
 {
-	int i;
 	u32 tmp;
 
 	B43_WARN_ON(dev->phy.rev >= 2);
 
-	for (i = 0; i < 128; i++) {
-		tmp  = table[i].pad << 11;
-		tmp |= table[i].pga << 7;
-		tmp |= table[i].gm  << 4;
-		tmp |= table[i].dac;
-		b43_lptab_write(dev, B43_LPTAB32(10, 0xC0 + i), tmp);
-		tmp  = table[i].bb_mult << 20;
-		b43_lptab_write(dev, B43_LPTAB32(10, 0x140 + i), tmp);
-	}
+	tmp  = data.pad << 11;
+	tmp |= data.pga << 7;
+	tmp |= data.gm  << 4;
+	tmp |= data.dac;
+	b43_lptab_write(dev, B43_LPTAB32(10, 0xC0 + offset), tmp);
+	tmp  = data.bb_mult << 20;
+	b43_lptab_write(dev, B43_LPTAB32(10, 0x140 + offset), tmp);
 }
 
-static void lpphy_rev2plus_write_gain_table(struct b43_wldev *dev,
-				struct lpphy_tx_gain_table_entry *table)
+static void lpphy_rev2plus_write_gain_table(struct b43_wldev *dev, int offset,
+				struct lpphy_tx_gain_table_entry data)
 {
-	int i;
 	u32 tmp;
 
 	B43_WARN_ON(dev->phy.rev < 2);
 
-	for (i = 0; i < 128; i++) {
-		tmp  = table[i].pad << 16;
-		tmp |= table[i].pga << 8;
-		tmp |= table[i].gm;
-		tmp |= 0x7f000000;
-		b43_lptab_write(dev, B43_LPTAB32(7, 0xC0 + i), tmp);
-		tmp  = table[i].bb_mult << 20;
-		tmp |= table[i].dac << 28;
-		b43_lptab_write(dev, B43_LPTAB32(7, 0x140 + i), tmp);
-	}
+	tmp  = data.pad << 16;
+	tmp |= data.pga << 8;
+	tmp |= data.gm;
+	tmp |= 0x7f000000;
+	b43_lptab_write(dev, B43_LPTAB32(7, 0xC0 + offset), tmp);
+	tmp  = data.bb_mult << 20;
+	tmp |= data.dac << 28;
+	b43_lptab_write(dev, B43_LPTAB32(7, 0x140 + offset), tmp);
+}
+
+void lpphy_write_gain_table(struct b43_wldev *dev, int offset,
+			    struct lpphy_tx_gain_table_entry data)
+{
+	if (dev->phy.rev >= 2)
+		lpphy_rev2plus_write_gain_table(dev, offset, data);
+	else
+		lpphy_rev0_1_write_gain_table(dev, offset, data);
+}
+
+void lpphy_write_gain_table_bulk(struct b43_wldev *dev, int offset, int count,
+				 struct lpphy_tx_gain_table_entry *table)
+{
+	int i;
+
+	for (i = offset; i < count; i++)
+		lpphy_write_gain_table(dev, i, table[i]);
 }
 
 void lpphy_init_tx_gain_table(struct b43_wldev *dev)
@@ -2393,36 +2400,36 @@ void lpphy_init_tx_gain_table(struct b43_wldev *dev)
 	case 0:
 		if ((bus->sprom.boardflags_hi & B43_BFH_NOPA) ||
 		    (bus->sprom.boardflags_lo & B43_BFL_HGPA))
-			lpphy_rev0_1_write_gain_table(dev,
+			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev0_nopa_tx_gain_table);
 		else if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
-			lpphy_rev0_1_write_gain_table(dev,
+			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev0_2ghz_tx_gain_table);
 		else
-			lpphy_rev0_1_write_gain_table(dev,
+			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev0_5ghz_tx_gain_table);
 		break;
 	case 1:
 		if ((bus->sprom.boardflags_hi & B43_BFH_NOPA) ||
 		    (bus->sprom.boardflags_lo & B43_BFL_HGPA))
-			lpphy_rev0_1_write_gain_table(dev,
+			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev1_nopa_tx_gain_table);
 		else if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
-			lpphy_rev0_1_write_gain_table(dev,
+			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev1_2ghz_tx_gain_table);
 		else
-			lpphy_rev0_1_write_gain_table(dev,
+			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev1_5ghz_tx_gain_table);
 		break;
 	default:
 		if (bus->sprom.boardflags_hi & B43_BFH_NOPA)
-			lpphy_rev2plus_write_gain_table(dev,
+			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev2_nopa_tx_gain_table);
 		else if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
-			lpphy_rev2plus_write_gain_table(dev,
+			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev2_2ghz_tx_gain_table);
 		else
-			lpphy_rev2plus_write_gain_table(dev,
+			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev2_5ghz_tx_gain_table);
 	}
 }
diff --git a/drivers/net/wireless/b43/tables_lpphy.h b/drivers/net/wireless/b43/tables_lpphy.h
index b5024b6..84f1d26 100644
--- a/drivers/net/wireless/b43/tables_lpphy.h
+++ b/drivers/net/wireless/b43/tables_lpphy.h
@@ -28,6 +28,15 @@ void b43_lptab_write_bulk(struct b43_wldev *dev, u32 offset,
 void b2062_upload_init_table(struct b43_wldev *dev);
 void b2063_upload_init_table(struct b43_wldev *dev);
 
+struct lpphy_tx_gain_table_entry {
+	u8 gm,  pga,  pad,  dac,  bb_mult;
+};
+
+void lpphy_write_gain_table(struct b43_wldev *dev, int offset,
+			    struct lpphy_tx_gain_table_entry data);
+void lpphy_write_gain_table_bulk(struct b43_wldev *dev, int offset, int count,
+				 struct lpphy_tx_gain_table_entry *table);
+
 void lpphy_rev0_1_table_init(struct b43_wldev *dev);
 void lpphy_rev2plus_table_init(struct b43_wldev *dev);
 void lpphy_init_tx_gain_table(struct b43_wldev *dev);
-- 
1.6.2.4



