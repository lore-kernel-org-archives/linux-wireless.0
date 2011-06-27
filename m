Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:62841 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab1F0M6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 08:58:08 -0400
Received: by fxd18 with SMTP id 18so1789140fxd.11
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 05:58:07 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/5] b43: HT-PHY: upload PHY values when switching channel
Date: Mon, 27 Jun 2011 14:58:51 +0200
Message-Id: <1309179534-8081-2-git-send-email-zajec5@gmail.com> (sfid-20110627_150220_042710_AB686B36)
In-Reply-To: <1309179534-8081-1-git-send-email-zajec5@gmail.com>
References: <1309179534-8081-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After calibrating radio you can find few PHY writes in MMIO dumps:
 phy_read(0x0009) -> 0x0000
phy_write(0x01ce) <- 0x03dd
phy_write(0x01cf) <- 0x03d9
phy_write(0x01d0) <- 0x03d5
phy_write(0x01d1) <- 0x0424
phy_write(0x01d2) <- 0x0429
phy_write(0x01d3) <- 0x042d
By comparing to N-PHY code we found out that they are PHY tables for
channel switching plus band info read at the beginning.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   16 +++++++++++++++-
 drivers/net/wireless/b43/phy_ht.h |   14 +++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 72f01ce..c48bcf6 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -82,7 +82,21 @@ static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
 				const struct b43_phy_ht_channeltab_e_phy *e,
 				struct ieee80211_channel *new_channel)
 {
-	/* TODO */
+	bool old_band_5ghz;
+
+	old_band_5ghz = b43_phy_read(dev, B43_PHY_HT_BANDCTL) & 0; /* FIXME */
+	if (new_channel->band == IEEE80211_BAND_5GHZ && !old_band_5ghz) {
+		/* TODO */
+	} else if (new_channel->band == IEEE80211_BAND_2GHZ && old_band_5ghz) {
+		/* TODO */
+	}
+
+	b43_phy_write(dev, B43_PHY_HT_BW1, e->bw1);
+	b43_phy_write(dev, B43_PHY_HT_BW2, e->bw2);
+	b43_phy_write(dev, B43_PHY_HT_BW3, e->bw3);
+	b43_phy_write(dev, B43_PHY_HT_BW4, e->bw4);
+	b43_phy_write(dev, B43_PHY_HT_BW5, e->bw5);
+	b43_phy_write(dev, B43_PHY_HT_BW6, e->bw6);
 }
 
 static int b43_phy_ht_set_channel(struct b43_wldev *dev,
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
index afa448d..7ad7aff 100644
--- a/drivers/net/wireless/b43/phy_ht.h
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -4,9 +4,16 @@
 #include "phy_common.h"
 
 
+#define B43_PHY_HT_BANDCTL			0x009 /* Band control */
 #define B43_PHY_HT_TABLE_ADDR			0x072 /* Table address */
 #define B43_PHY_HT_TABLE_DATALO			0x073 /* Table data low */
 #define B43_PHY_HT_TABLE_DATAHI			0x074 /* Table data high */
+#define B43_PHY_HT_BW1				0x1CE
+#define B43_PHY_HT_BW2				0x1CF
+#define B43_PHY_HT_BW3				0x1D0
+#define B43_PHY_HT_BW4				0x1D1
+#define B43_PHY_HT_BW5				0x1D2
+#define B43_PHY_HT_BW6				0x1D3
 
 #define B43_PHY_HT_RF_CTL1			B43_PHY_EXTG(0x010)
 
@@ -20,7 +27,12 @@
 
 /* Values for PHY registers used on channel switching */
 struct b43_phy_ht_channeltab_e_phy {
-	/* TODO */
+	u16 bw1;
+	u16 bw2;
+	u16 bw3;
+	u16 bw4;
+	u16 bw5;
+	u16 bw6;
 };
 
 
-- 
1.7.1

