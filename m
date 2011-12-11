Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54431 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1LKBOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 20:14:55 -0500
Received: by mail-ey0-f174.google.com with SMTP id k14so2316533eaa.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 17:14:54 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 6/7] b43: N-PHY: finish 2.4GHz 0x2056 radio setup
Date: Sun, 11 Dec 2011 02:55:34 +0100
Message-Id: <1323568535-2816-7-git-send-email-zajec5@gmail.com> (sfid-20111211_021457_747958_A8212F43)
In-Reply-To: <1323568535-2816-1-git-send-email-zajec5@gmail.com>
References: <1323568535-2816-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c      |   90 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/b43/radio_2056.c |   15 ++++++
 drivers/net/wireless/b43/radio_2056.h |    1 +
 3 files changed, 105 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 4bd94df..114c413 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -228,10 +228,98 @@ static void b43_chantab_radio_2056_upload(struct b43_wldev *dev,
 static void b43_radio_2056_setup(struct b43_wldev *dev,
 				const struct b43_nphy_channeltab_entry_rev3 *e)
 {
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
+	enum ieee80211_band band = b43_current_band(dev->wl);
+	u16 offset;
+	u8 i;
+	u16 bias, cbias, pag_boost, pgag_boost, mixg_boost, padg_boost;
+
 	B43_WARN_ON(dev->phy.rev < 3);
 
 	b43_chantab_radio_2056_upload(dev, e);
-	/* TODO */
+	b2056_upload_syn_pll_cp2(dev, band == IEEE80211_BAND_5GHZ);
+
+	if (sprom->boardflags2_lo & B43_BFL2_GPLL_WAR &&
+	    b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER1, 0x1F);
+		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER2, 0x1F);
+		if (dev->dev->chip_id == 0x4716) {
+			b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER4, 0x14);
+			b43_radio_write(dev, B2056_SYN_PLL_CP2, 0);
+		} else {
+			b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER4, 0x0B);
+			b43_radio_write(dev, B2056_SYN_PLL_CP2, 0x14);
+		}
+	}
+	if (sprom->boardflags2_lo & B43_BFL2_APLL_WAR &&
+	    b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER1, 0x1F);
+		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER2, 0x1F);
+		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER4, 0x05);
+		b43_radio_write(dev, B2056_SYN_PLL_CP2, 0x0C);
+	}
+
+	if (dev->phy.n->ipa2g_on && band == IEEE80211_BAND_2GHZ) {
+		for (i = 0; i < 2; i++) {
+			offset = i ? B2056_TX1 : B2056_TX0;
+			if (dev->phy.rev >= 5) {
+				b43_radio_write(dev,
+					offset | B2056_TX_PADG_IDAC, 0xcc);
+
+				if (dev->dev->chip_id == 0x4716) {
+					bias = 0x40;
+					cbias = 0x45;
+					pag_boost = 0x5;
+					pgag_boost = 0x33;
+					mixg_boost = 0x55;
+				} else {
+					bias = 0x25;
+					cbias = 0x20;
+					pag_boost = 0x4;
+					pgag_boost = 0x03;
+					mixg_boost = 0x65;
+				}
+				padg_boost = 0x77;
+
+				b43_radio_write(dev,
+					offset | B2056_TX_INTPAG_IMAIN_STAT,
+					bias);
+				b43_radio_write(dev,
+					offset | B2056_TX_INTPAG_IAUX_STAT,
+					bias);
+				b43_radio_write(dev,
+					offset | B2056_TX_INTPAG_CASCBIAS,
+					cbias);
+				b43_radio_write(dev,
+					offset | B2056_TX_INTPAG_BOOST_TUNE,
+					pag_boost);
+				b43_radio_write(dev,
+					offset | B2056_TX_PGAG_BOOST_TUNE,
+					pgag_boost);
+				b43_radio_write(dev,
+					offset | B2056_TX_PADG_BOOST_TUNE,
+					padg_boost);
+				b43_radio_write(dev,
+					offset | B2056_TX_MIXG_BOOST_TUNE,
+					mixg_boost);
+			} else {
+				bias = dev->phy.is_40mhz ? 0x40 : 0x20;
+				b43_radio_write(dev,
+					offset | B2056_TX_INTPAG_IMAIN_STAT,
+					bias);
+				b43_radio_write(dev,
+					offset | B2056_TX_INTPAG_IAUX_STAT,
+					bias);
+				b43_radio_write(dev,
+					offset | B2056_TX_INTPAG_CASCBIAS,
+					0x30);
+			}
+			b43_radio_write(dev, offset | B2056_TX_PA_SPARE1, 0xee);
+		}
+	} else if (dev->phy.n->ipa5g_on && band == IEEE80211_BAND_5GHZ) {
+		/* TODO */
+	}
+
 	udelay(50);
 	/* VCO calibration */
 	b43_radio_write(dev, B2056_SYN_PLL_VCOCAL12, 0x00);
diff --git a/drivers/net/wireless/b43/radio_2056.c b/drivers/net/wireless/b43/radio_2056.c
index 4a42994..ce037fb 100644
--- a/drivers/net/wireless/b43/radio_2056.c
+++ b/drivers/net/wireless/b43/radio_2056.c
@@ -9055,6 +9055,21 @@ void b2056_upload_inittabs(struct b43_wldev *dev,
 				B2056_RX1, pts->rx, pts->rx_length);
 }
 
+void b2056_upload_syn_pll_cp2(struct b43_wldev *dev, bool ghz5)
+{
+	struct b2056_inittabs_pts *pts;
+	const struct b2056_inittab_entry *e;
+
+	if (dev->phy.rev >= ARRAY_SIZE(b2056_inittabs)) {
+		B43_WARN_ON(1);
+		return;
+	}
+	pts = &b2056_inittabs[dev->phy.rev];
+	e = &pts->syn[B2056_SYN_PLL_CP2];
+
+	b43_radio_write(dev, B2056_SYN_PLL_CP2, ghz5 ? e->ghz5 : e->ghz2);
+}
+
 const struct b43_nphy_channeltab_entry_rev3 *
 b43_nphy_get_chantabent_rev3(struct b43_wldev *dev, u16 freq)
 {
diff --git a/drivers/net/wireless/b43/radio_2056.h b/drivers/net/wireless/b43/radio_2056.h
index a7159d8..5b86673 100644
--- a/drivers/net/wireless/b43/radio_2056.h
+++ b/drivers/net/wireless/b43/radio_2056.h
@@ -1090,6 +1090,7 @@ struct b43_nphy_channeltab_entry_rev3 {
 
 void b2056_upload_inittabs(struct b43_wldev *dev,
 			   bool ghz5, bool ignore_uploadflag);
+void b2056_upload_syn_pll_cp2(struct b43_wldev *dev, bool ghz5);
 
 /* Get the NPHY Channel Switch Table entry for a channel.
  * Returns NULL on failure to find an entry. */
-- 
1.7.3.4

