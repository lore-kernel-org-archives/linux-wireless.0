Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:47170 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbZHJS5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 14:57:11 -0400
Received: by bwz19 with SMTP id 19so2759918bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 11:57:11 -0700 (PDT)
Message-ID: <4A806D82.4010606@gmail.com>
Date: Mon, 10 Aug 2009 20:57:06 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH V2] b43: Update LP-PHY rev2+ baseband init to match the specs
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rev2+ BB init spec has changed behind us, and thus the code is
no longer up to date. Update the code to match the current specs.
Also implement save/restore dig filt state, as required by the
new specification.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
V2: use ARRAY_SIZE for loop counts.

 drivers/net/wireless/b43/phy_lp.c |   73 +++++++++++++++++++++++++++++++++++--
 drivers/net/wireless/b43/phy_lp.h |    3 ++
 2 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index d2af924..128d75a 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -195,6 +195,56 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 	}
 }
 
+static void lpphy_save_dig_flt_state(struct b43_wldev *dev)
+{
+	static const u16 addr[] = {
+		B43_PHY_OFDM(0xC1),
+		B43_PHY_OFDM(0xC2),
+		B43_PHY_OFDM(0xC3),
+		B43_PHY_OFDM(0xC4),
+		B43_PHY_OFDM(0xC5),
+		B43_PHY_OFDM(0xC6),
+		B43_PHY_OFDM(0xC7),
+		B43_PHY_OFDM(0xC8),
+		B43_PHY_OFDM(0xCF),
+	};
+
+	static const u16 coefs[] = {
+		0xDE5E, 0xE832, 0xE331, 0x4D26,
+		0x0026, 0x1420, 0x0020, 0xFE08,
+		0x0008,
+	};
+
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(addr); i++) {
+		lpphy->dig_flt_state[i] = b43_phy_read(dev, addr[i]);
+		b43_phy_write(dev, addr[i], coefs[i]);
+	}
+}
+
+static void lpphy_restore_dig_flt_state(struct b43_wldev *dev)
+{
+	static const u16 addr[] = {
+		B43_PHY_OFDM(0xC1),
+		B43_PHY_OFDM(0xC2),
+		B43_PHY_OFDM(0xC3),
+		B43_PHY_OFDM(0xC4),
+		B43_PHY_OFDM(0xC5),
+		B43_PHY_OFDM(0xC6),
+		B43_PHY_OFDM(0xC7),
+		B43_PHY_OFDM(0xC8),
+		B43_PHY_OFDM(0xCF),
+	};
+
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(addr); i++)
+		b43_phy_write(dev, addr[i], lpphy->dig_flt_state[i]);
+}
+
 static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 {
 	struct ssb_bus *bus = dev->dev->bus;
@@ -209,7 +259,7 @@ static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_PHY_OFDM(0xF9), 0);
 	b43_phy_write(dev, B43_LPPHY_TR_LOOKUP_1, 0);
 	b43_phy_set(dev, B43_LPPHY_ADC_COMPENSATION_CTL, 0x10);
-	b43_phy_maskset(dev, B43_LPPHY_OFDMSYNCTHRESH0, 0xFF00, 0x78);
+	b43_phy_maskset(dev, B43_LPPHY_OFDMSYNCTHRESH0, 0xFF00, 0xB4);
 	b43_phy_maskset(dev, B43_LPPHY_DCOFFSETTRANSIENT, 0xF8FF, 0x200);
 	b43_phy_maskset(dev, B43_LPPHY_DCOFFSETTRANSIENT, 0xFF00, 0x7F);
 	b43_phy_maskset(dev, B43_LPPHY_GAINDIRECTMISMATCH, 0xFF0F, 0x40);
@@ -217,7 +267,12 @@ static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 	b43_phy_mask(dev, B43_LPPHY_CRSGAIN_CTL, ~0x4000);
 	b43_phy_mask(dev, B43_LPPHY_CRSGAIN_CTL, ~0x2000);
 	b43_phy_set(dev, B43_PHY_OFDM(0x10A), 0x1);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x10A), 0xFF01, 0x10);
+	if (bus->boardinfo.rev >= 0x18) {
+		b43_lptab_write(dev, B43_LPTAB32(17, 65), 0xEC);
+		b43_phy_maskset(dev, B43_PHY_OFDM(0x10A), 0xFF01, 0x14);
+	} else {
+		b43_phy_maskset(dev, B43_PHY_OFDM(0x10A), 0xFF01, 0x10);
+	}
 	b43_phy_maskset(dev, B43_PHY_OFDM(0xDF), 0xFF00, 0xF4);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0xDF), 0x00FF, 0xF100);
 	b43_phy_write(dev, B43_LPPHY_CLIPTHRESH, 0x48);
@@ -247,8 +302,10 @@ static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 	b43_phy_maskset(dev, B43_LPPHY_CLIPCTRTHRESH, 0xFFE0, 0x12);
 	b43_phy_maskset(dev, B43_LPPHY_GAINMISMATCH, 0x0FFF, 0x9000);
 
-	b43_lptab_write(dev, B43_LPTAB16(0x08, 0x14), 0);
-	b43_lptab_write(dev, B43_LPTAB16(0x08, 0x12), 0x40);
+	if ((bus->chip_id == 0x4325) && (bus->chip_rev == 1)) {
+		b43_lptab_write(dev, B43_LPTAB16(0x08, 0x14), 0);
+		b43_lptab_write(dev, B43_LPTAB16(0x08, 0x12), 0x40);
+	}
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
 		b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x40);
@@ -268,6 +325,14 @@ static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_LPPHY_AFE_RSSI_CTL_1,
 		      0x2000 | ((u16)lpphy->rssi_gs << 10) |
 		      ((u16)lpphy->rssi_vc << 4) | lpphy->rssi_vf);
+
+	if ((bus->chip_id == 0x4325) && (bus->chip_rev == 0)) {
+		b43_phy_set(dev, B43_LPPHY_AFE_ADC_CTL_0, 0x1C);
+		b43_phy_maskset(dev, B43_LPPHY_AFE_CTL, 0x00FF, 0x8800);
+		b43_phy_maskset(dev, B43_LPPHY_AFE_ADC_CTL_1, 0xFC3C, 0x0400);
+	}
+
+	lpphy_save_dig_flt_state(dev);
 }
 
 static void lpphy_baseband_init(struct b43_wldev *dev)
diff --git a/drivers/net/wireless/b43/phy_lp.h b/drivers/net/wireless/b43/phy_lp.h
index 829b2bb..13d89ea 100644
--- a/drivers/net/wireless/b43/phy_lp.h
+++ b/drivers/net/wireless/b43/phy_lp.h
@@ -865,6 +865,9 @@ struct b43_phy_lp {
 	/* Transmit iqlocal best coeffs */
 	bool tx_iqloc_best_coeffs_valid;
 	u8 tx_iqloc_best_coeffs[11];
+
+	/* Used for "Save/Restore Dig Filt State" */
+	u16 dig_flt_state[9];
 };
 
 
-- 
1.6.2.4


