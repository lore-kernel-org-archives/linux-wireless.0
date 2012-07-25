Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60433 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2GYVXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 17:23:50 -0400
Received: by weyx8 with SMTP id x8so873051wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 14:23:49 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: N-PHY: finish 0x2056 radio setup
Date: Thu, 26 Jul 2012 00:07:38 +0200
Message-Id: <1343254059-4788-2-git-send-email-zajec5@gmail.com> (sfid-20120725_232353_176790_2B1B3677)
In-Reply-To: <1343254059-4788-1-git-send-email-zajec5@gmail.com>
References: <1343254059-4788-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   95 +++++++++++++++++++++++++++++++++++--
 drivers/net/wireless/b43/phy_n.h |    1 +
 2 files changed, 90 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 0963d59..0e75c35 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -545,7 +545,9 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 	enum ieee80211_band band = b43_current_band(dev->wl);
 	u16 offset;
 	u8 i;
-	u16 bias, cbias, pag_boost, pgag_boost, mixg_boost, padg_boost;
+	u16 bias, cbias;
+	u16 pag_boost, padg_boost, pgag_boost, mixg_boost;
+	u16 paa_boost, pada_boost, pgaa_boost, mixa_boost;
 
 	B43_WARN_ON(dev->phy.rev < 3);
 
@@ -630,7 +632,56 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 			b43_radio_write(dev, offset | B2056_TX_PA_SPARE1, 0xee);
 		}
 	} else if (dev->phy.n->ipa5g_on && band == IEEE80211_BAND_5GHZ) {
-		/* TODO */
+		u16 freq = dev->phy.channel_freq;
+		if (freq < 5100) {
+			paa_boost = 0xA;
+			pada_boost = 0x77;
+			pgaa_boost = 0xF;
+			mixa_boost = 0xF;
+		} else if (freq < 5340) {
+			paa_boost = 0x8;
+			pada_boost = 0x77;
+			pgaa_boost = 0xFB;
+			mixa_boost = 0xF;
+		} else if (freq < 5650) {
+			paa_boost = 0x0;
+			pada_boost = 0x77;
+			pgaa_boost = 0xB;
+			mixa_boost = 0xF;
+		} else {
+			paa_boost = 0x0;
+			pada_boost = 0x77;
+			if (freq != 5825)
+				pgaa_boost = -(freq - 18) / 36 + 168;
+			else
+				pgaa_boost = 6;
+			mixa_boost = 0xF;
+		}
+
+		for (i = 0; i < 2; i++) {
+			offset = i ? B2056_TX1 : B2056_TX0;
+
+			b43_radio_write(dev,
+				offset | B2056_TX_INTPAA_BOOST_TUNE, paa_boost);
+			b43_radio_write(dev,
+				offset | B2056_TX_PADA_BOOST_TUNE, pada_boost);
+			b43_radio_write(dev,
+				offset | B2056_TX_PGAA_BOOST_TUNE, pgaa_boost);
+			b43_radio_write(dev,
+				offset | B2056_TX_MIXA_BOOST_TUNE, mixa_boost);
+			b43_radio_write(dev,
+				offset | B2056_TX_TXSPARE1, 0x30);
+			b43_radio_write(dev,
+				offset | B2056_TX_PA_SPARE2, 0xee);
+			b43_radio_write(dev,
+				offset | B2056_TX_PADA_CASCBIAS, 0x03);
+			b43_radio_write(dev,
+				offset | B2056_TX_INTPAA_IAUX_STAT, 0x50);
+			b43_radio_write(dev,
+				offset | B2056_TX_INTPAA_IMAIN_STAT, 0x50);
+			b43_radio_write(dev,
+				offset | B2056_TX_INTPAA_CASCBIAS, 0x30);
+		}
 	}
 
 	udelay(50);
@@ -643,6 +694,37 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 	udelay(300);
 }
 
+static u8 b43_radio_2056_rcal(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	u16 mast2, tmp;
+
+	if (phy->rev != 3)
+		return 0;
+
+	mast2 = b43_radio_read(dev, B2056_SYN_PLL_MAST2);
+	b43_radio_write(dev, B2056_SYN_PLL_MAST2, mast2 | 0x7);
+
+	udelay(10);
+	b43_radio_write(dev, B2056_SYN_RCAL_MASTER, 0x01);
+	udelay(10);
+	b43_radio_write(dev, B2056_SYN_RCAL_MASTER, 0x09);
+
+	if (!b43_radio_wait_value(dev, B2056_SYN_RCAL_CODE_OUT, 0x80, 0x80, 100,
+				  1000000)) {
+		b43err(dev->wl, "Radio recalibration timeout\n");
+		return 0;
+	}
+
+	b43_radio_write(dev, B2056_SYN_RCAL_MASTER, 0x01);
+	tmp = b43_radio_read(dev, B2056_SYN_RCAL_CODE_OUT);
+	b43_radio_write(dev, B2056_SYN_RCAL_MASTER, 0x00);
+
+	b43_radio_write(dev, B2056_SYN_PLL_MAST2, mast2);
+
+	return tmp & 0x1f;
+}
+
 static void b43_radio_init2056_pre(struct b43_wldev *dev)
 {
 	b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
@@ -665,10 +747,8 @@ static void b43_radio_init2056_post(struct b43_wldev *dev)
 	b43_radio_mask(dev, B2056_SYN_COM_RESET, ~0x2);
 	b43_radio_mask(dev, B2056_SYN_PLL_MAST2, ~0xFC);
 	b43_radio_mask(dev, B2056_SYN_RCCAL_CTRL0, ~0x1);
-	/*
-	if (nphy->init_por)
-		Call Radio 2056 Recalibrate
-	*/
+	if (dev->phy.n->init_por)
+		b43_radio_2056_rcal(dev);
 }
 
 /*
@@ -680,6 +760,8 @@ static void b43_radio_init2056(struct b43_wldev *dev)
 	b43_radio_init2056_pre(dev);
 	b2056_upload_inittabs(dev, 0, 0);
 	b43_radio_init2056_post(dev);
+
+	dev->phy.n->init_por = false;
 }
 
 /**************************************************
@@ -5089,6 +5171,7 @@ static void b43_nphy_op_prepare_structs(struct b43_wldev *dev)
 	nphy->hang_avoid = (phy->rev == 3 || phy->rev == 4);
 	nphy->spur_avoid = (phy->rev >= 3) ?
 				B43_SPUR_AVOID_AUTO : B43_SPUR_AVOID_DISABLE;
+	nphy->init_por = true;
 	nphy->gain_boost = true; /* this way we follow wl, assume it is true */
 	nphy->txrx_chain = 2; /* sth different than 0 and 1 for now */
 	nphy->phyrxchain = 3; /* to avoid b43_nphy_set_rx_core_state like wl */
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index fd12b38..092c014 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -785,6 +785,7 @@ struct b43_phy_n {
 	u16 papd_epsilon_offset[2];
 	s32 preamble_override;
 	u32 bb_mult_save;
+	bool init_por;
 
 	bool gain_boost;
 	bool elna_gain_config;
-- 
1.7.7

