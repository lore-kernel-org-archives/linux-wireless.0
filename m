Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46912 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab0LUSkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 13:40:37 -0500
Received: by wyb28 with SMTP id 28so4247098wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 10:40:36 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: N-PHY: update 2056 radio on channel switch on rev3+
Date: Tue, 21 Dec 2010 19:40:19 +0100
Message-Id: <1292956819-21166-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1292956819-21166-1-git-send-email-zajec5@gmail.com>
References: <1292956819-21166-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: I ignored over 80 chars warnings, as this is very simple code
(write-by-write, line-by-line) and I believe this can improve readibility.
---
 drivers/net/wireless/b43/phy_n.c |   66 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 65 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index dded231..b9bda46 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -139,6 +139,70 @@ static void b43_chantab_radio_upload(struct b43_wldev *dev,
 	b43_radio_write(dev, B2055_C2_TX_MXBGTRIM, e->radio_c2_tx_mxbgtrim);
 }
 
+static void b43_chantab_radio_2056_upload(struct b43_wldev *dev,
+				const struct b43_nphy_channeltab_entry_rev3 *e)
+{
+	b43_radio_write(dev, B2056_SYN_PLL_VCOCAL1, e->radio_syn_pll_vcocal1);
+	b43_radio_write(dev, B2056_SYN_PLL_VCOCAL2, e->radio_syn_pll_vcocal2);
+	b43_radio_write(dev, B2056_SYN_PLL_REFDIV, e->radio_syn_pll_refdiv);
+	b43_radio_write(dev, B2056_SYN_PLL_MMD2, e->radio_syn_pll_mmd2);
+	b43_radio_write(dev, B2056_SYN_PLL_MMD1, e->radio_syn_pll_mmd1);
+	b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER1, e->radio_syn_pll_loopfilter1);
+	b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER2, e->radio_syn_pll_loopfilter2);
+	b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER3, e->radio_syn_pll_loopfilter3);
+	b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER4, e->radio_syn_pll_loopfilter4);
+	b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER5, e->radio_syn_pll_loopfilter5);
+	b43_radio_write(dev, B2056_SYN_RESERVED_ADDR27, e->radio_syn_reserved_addr27);
+	b43_radio_write(dev, B2056_SYN_RESERVED_ADDR28, e->radio_syn_reserved_addr28);
+	b43_radio_write(dev, B2056_SYN_RESERVED_ADDR29, e->radio_syn_reserved_addr29);
+	b43_radio_write(dev, B2056_SYN_LOGEN_VCOBUF1, e->radio_syn_logen_vcobuf1);
+	b43_radio_write(dev, B2056_SYN_LOGEN_MIXER2, e->radio_syn_logen_mixer2);
+	b43_radio_write(dev, B2056_SYN_LOGEN_BUF3, e->radio_syn_logen_buf3);
+	b43_radio_write(dev, B2056_SYN_LOGEN_BUF4, e->radio_syn_logen_buf4);
+
+	b43_radio_write(dev, B2056_RX0 | B2056_RX_LNAA_TUNE, e->radio_rx0_lnaa_tune);
+	b43_radio_write(dev, B2056_RX0 | B2056_RX_LNAG_TUNE, e->radio_rx0_lnag_tune);
+
+	b43_radio_write(dev, B2056_TX0 | B2056_TX_INTPAA_BOOST_TUNE, e->radio_tx0_intpaa_boost_tune);
+	b43_radio_write(dev, B2056_TX0 | B2056_TX_INTPAG_BOOST_TUNE, e->radio_tx0_intpag_boost_tune);
+	b43_radio_write(dev, B2056_TX0 | B2056_TX_PADA_BOOST_TUNE, e->radio_tx0_pada_boost_tune);
+	b43_radio_write(dev, B2056_TX0 | B2056_TX_PADG_BOOST_TUNE, e->radio_tx0_padg_boost_tune);
+	b43_radio_write(dev, B2056_TX0 | B2056_TX_PGAA_BOOST_TUNE, e->radio_tx0_pgaa_boost_tune);
+	b43_radio_write(dev, B2056_TX0 | B2056_TX_PGAG_BOOST_TUNE, e->radio_tx0_pgag_boost_tune);
+	b43_radio_write(dev, B2056_TX0 | B2056_TX_MIXA_BOOST_TUNE, e->radio_tx0_mixa_boost_tune);
+	b43_radio_write(dev, B2056_TX0 | B2056_TX_MIXG_BOOST_TUNE, e->radio_tx0_mixg_boost_tune);
+
+	b43_radio_write(dev, B2056_RX1 | B2056_RX_LNAA_TUNE, e->radio_rx1_lnaa_tune);
+	b43_radio_write(dev, B2056_RX1 | B2056_RX_LNAG_TUNE, e->radio_rx1_lnag_tune);
+
+	b43_radio_write(dev, B2056_TX1 | B2056_TX_INTPAA_BOOST_TUNE, e->radio_tx1_intpaa_boost_tune);
+	b43_radio_write(dev, B2056_TX1 | B2056_TX_INTPAG_BOOST_TUNE, e->radio_tx1_intpag_boost_tune);
+	b43_radio_write(dev, B2056_TX1 | B2056_TX_PADA_BOOST_TUNE, e->radio_tx1_pada_boost_tune);
+	b43_radio_write(dev, B2056_TX1 | B2056_TX_PADG_BOOST_TUNE, e->radio_tx1_padg_boost_tune);
+	b43_radio_write(dev, B2056_TX1 | B2056_TX_PGAA_BOOST_TUNE, e->radio_tx1_pgaa_boost_tune);
+	b43_radio_write(dev, B2056_TX1 | B2056_TX_PGAG_BOOST_TUNE, e->radio_tx1_pgag_boost_tune);
+	b43_radio_write(dev, B2056_TX1 | B2056_TX_MIXA_BOOST_TUNE, e->radio_tx1_mixa_boost_tune);
+	b43_radio_write(dev, B2056_TX1 | B2056_TX_MIXG_BOOST_TUNE, e->radio_tx1_mixg_boost_tune);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/Radio/2056Setup */
+static void b43_radio_2056_setup(struct b43_wldev *dev,
+				const struct b43_nphy_channeltab_entry_rev3 *e)
+{
+	B43_WARN_ON(dev->phy.rev < 3);
+
+	b43_chantab_radio_2056_upload(dev, e);
+	/* TODO */
+	udelay(50);
+	/* VCO calibration */
+	b43_radio_write(dev, B2056_SYN_PLL_VCOCAL12, 0x00);
+	b43_radio_write(dev, B2056_TX_INTPAA_PA_MISC, 0x38);
+	b43_radio_write(dev, B2056_TX_INTPAA_PA_MISC, 0x18);
+	b43_radio_write(dev, B2056_TX_INTPAA_PA_MISC, 0x38);
+	b43_radio_write(dev, B2056_TX_INTPAA_PA_MISC, 0x39);
+	udelay(300);
+}
+
 static void b43_chantab_phy_upload(struct b43_wldev *dev,
 				   const struct b43_phy_n_sfo_cfg *e)
 {
@@ -3635,7 +3699,7 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 	if (dev->phy.rev >= 3) {
 		tmp = (channel->band == IEEE80211_BAND_5GHZ) ? 4 : 0;
 		b43_radio_maskset(dev, 0x08, 0xFFFB, tmp);
-		/* TODO: PHY Radio2056 Setup (dev, tabent_r3); */
+		b43_radio_2056_setup(dev, tabent_r3);
 		b43_nphy_channel_setup(dev, &(tabent_r3->phy_regs), channel);
 	} else {
 		tmp = (channel->band == IEEE80211_BAND_5GHZ) ? 0x0020 : 0x0050;
-- 
1.6.3.3

