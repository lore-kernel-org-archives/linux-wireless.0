Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:39669 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab0AJWLj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 17:11:39 -0500
Received: by ewy6 with SMTP id 6so21225297ewy.29
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jan 2010 14:11:38 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Sun, 10 Jan 2010 23:13:07 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 1/6] b43: N-PHY: add RSSI functions: scale offset, select (rev
 < 3), restore cal
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6b7z2yo9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |  157 +++++++++++++++++++++++++++++++++++++-
  drivers/net/wireless/b43/phy_n.h |   10 +++
  2 files changed, 166 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index c2c2602..a44fca1 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -590,6 +590,127 @@ static void b43_nphy_bphy_init(struct b43_wldev *dev)
  	b43_phy_write(dev, B43_PHY_N_BMODE(0x38), 0x668);
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ScaleOffsetRssi */
+static void b43_nphy_scale_offset_rssi(struct b43_wldev *dev, u16 scale,
+				       s8 offset, u8 core, u8 rail, u8 type)
+{
+	u16 tmp;
+	bool core1or5 = (core == 1) || (core == 5);
+	bool core2or5 = (core == 2) || (core == 5);
+
+	offset = clamp_val(offset, -32, 31);
+	tmp = ((scale & 0x3F) << 8) | (offset & 0x3F);
+
+	if (core1or5 && (rail == 0) && (type == 2))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_RSSI_Z, tmp);
+	if (core1or5 && (rail == 1) && (type == 2))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_RSSI_Z, tmp);
+	if (core2or5 && (rail == 0) && (type == 2))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_RSSI_Z, tmp);
+	if (core2or5 && (rail == 1) && (type == 2))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_Z, tmp);
+	if (core1or5 && (rail == 0) && (type == 0))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_RSSI_X, tmp);
+	if (core1or5 && (rail == 1) && (type == 0))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_RSSI_X, tmp);
+	if (core2or5 && (rail == 0) && (type == 0))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_RSSI_X, tmp);
+	if (core2or5 && (rail == 1) && (type == 0))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_X, tmp);
+	if (core1or5 && (rail == 0) && (type == 1))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_RSSI_Y, tmp);
+	if (core1or5 && (rail == 1) && (type == 1))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_RSSI_Y, tmp);
+	if (core2or5 && (rail == 0) && (type == 1))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_RSSI_Y, tmp);
+	if (core2or5 && (rail == 1) && (type == 1))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_Y, tmp);
+	if (core1or5 && (rail == 0) && (type == 6))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_TBD, tmp);
+	if (core1or5 && (rail == 1) && (type == 6))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_TBD, tmp);
+	if (core2or5 && (rail == 0) && (type == 6))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_TBD, tmp);
+	if (core2or5 && (rail == 1) && (type == 6))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_TBD, tmp);
+	if (core1or5 && (rail == 0) && (type == 3))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_PWRDET, tmp);
+	if (core1or5 && (rail == 1) && (type == 3))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_PWRDET, tmp);
+	if (core2or5 && (rail == 0) && (type == 3))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_PWRDET, tmp);
+	if (core2or5 && (rail == 1) && (type == 3))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_PWRDET, tmp);
+	if (core1or5 && (type == 4))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_TSSI, tmp);
+	if (core2or5 && (type == 4))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_TSSI, tmp);
+	if (core1or5 && (type == 5))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_TSSI, tmp);
+	if (core2or5 && (type == 5))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_TSSI, tmp);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSISel */
+static void b43_nphy_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
+{
+	u16 val;
+
+	if (dev->phy.rev >= 3) {
+		/* TODO */
+	} else {
+		if (type < 3)
+			val = 0;
+		else if (type == 6)
+			val = 1;
+		else if (type == 3)
+			val = 2;
+		else
+			val = 3;
+
+		val = (val << 12) | (val << 14);
+		b43_phy_maskset(dev, B43_NPHY_AFECTL_C1, 0x0FFF, val);
+		b43_phy_maskset(dev, B43_NPHY_AFECTL_C2, 0x0FFF, val);
+
+		if (type < 3) {
+			b43_phy_maskset(dev, B43_NPHY_RFCTL_RSSIO1, 0xFFCF,
+					(type + 1) << 4);
+			b43_phy_maskset(dev, B43_NPHY_RFCTL_RSSIO2, 0xFFCF,
+					(type + 1) << 4);
+		}
+
+		/* TODO use some definitions */
+		if (code == 0) {
+			b43_phy_maskset(dev, B43_NPHY_AFECTL_OVER, 0xCFFF, 0);
+			if (type < 3) {
+				b43_phy_maskset(dev, B43_NPHY_RFCTL_CMD,
+						0xFEC7, 0);
+				b43_phy_maskset(dev, B43_NPHY_RFCTL_OVER,
+						0xEFDC, 0);
+				b43_phy_maskset(dev, B43_NPHY_RFCTL_CMD,
+						0xFFFE, 0);
+				udelay(20);
+				b43_phy_maskset(dev, B43_NPHY_RFCTL_OVER,
+						0xFFFE, 0);
+			}
+		} else {
+			b43_phy_maskset(dev, B43_NPHY_AFECTL_OVER, 0xCFFF,
+					0x3000);
+			if (type < 3) {
+				b43_phy_maskset(dev, B43_NPHY_RFCTL_CMD,
+						0xFEC7, 0x0180);
+				b43_phy_maskset(dev, B43_NPHY_RFCTL_OVER,
+						0xEFDC, (code << 1 | 0x1021));
+				b43_phy_maskset(dev, B43_NPHY_RFCTL_CMD,
+						0xFFFE, 0x0001);
+				udelay(20);
+				b43_phy_maskset(dev, B43_NPHY_RFCTL_OVER,
+						0xFFFE, 0);
+			}
+		}
+	}
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICal */
  static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
  {
@@ -623,7 +744,41 @@ static void b43_nphy_rssi_cal(struct b43_wldev *dev)
   */
  static void b43_nphy_restore_rssi_cal(struct b43_wldev *dev)
  {
-	//TODO
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	u16 *rssical_radio_regs = NULL;
+	u16 *rssical_phy_regs = NULL;
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (!nphy->rssical_chanspec_2G)
+			return;
+		rssical_radio_regs = nphy->rssical_cache.rssical_radio_regs_2G;
+		rssical_phy_regs = nphy->rssical_cache.rssical_phy_regs_2G;
+	} else {
+		if (!nphy->rssical_chanspec_5G)
+			return;
+		rssical_radio_regs = nphy->rssical_cache.rssical_radio_regs_5G;
+		rssical_phy_regs = nphy->rssical_cache.rssical_phy_regs_5G;
+	}
+
+	/* TODO use some definitions */
+	b43_radio_maskset(dev, 0x602B, 0xE3, rssical_radio_regs[0]);
+	b43_radio_maskset(dev, 0x702B, 0xE3, rssical_radio_regs[1]);
+
+	b43_phy_write(dev, B43_NPHY_RSSIMC_0I_RSSI_Z, rssical_phy_regs[0]);
+	b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_RSSI_Z, rssical_phy_regs[1]);
+	b43_phy_write(dev, B43_NPHY_RSSIMC_1I_RSSI_Z, rssical_phy_regs[2]);
+	b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_Z, rssical_phy_regs[3]);
+
+	b43_phy_write(dev, B43_NPHY_RSSIMC_0I_RSSI_X, rssical_phy_regs[4]);
+	b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_RSSI_X, rssical_phy_regs[5]);
+	b43_phy_write(dev, B43_NPHY_RSSIMC_1I_RSSI_X, rssical_phy_regs[6]);
+	b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_X, rssical_phy_regs[7]);
+
+	b43_phy_write(dev, B43_NPHY_RSSIMC_0I_RSSI_Y, rssical_phy_regs[8]);
+	b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_RSSI_Y, rssical_phy_regs[9]);
+	b43_phy_write(dev, B43_NPHY_RSSIMC_1I_RSSI_Y, rssical_phy_regs[10]);
+	b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_Y, rssical_phy_regs[11]);
  }

  /* Init N-PHY
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 6bb9476..ca1fd11 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -924,6 +924,14 @@

  struct b43_wldev;

+struct b43_phy_n_rssical_cache {
+	u16 rssical_radio_regs_2G[2];
+	u16 rssical_phy_regs_2G[12];
+
+	u16 rssical_radio_regs_5G[2];
+	u16 rssical_phy_regs_5G[12];
+};
+
  struct b43_phy_n {
  	u8 txpwrctrl;
  	u8 cal_orig_pwr_idx[2];
@@ -948,6 +956,8 @@ struct b43_phy_n {
  	u8 iqcal_chanspec_5G;
  	u8 rssical_chanspec_5G;

+	struct b43_phy_n_rssical_cache rssical_cache;
+
  	bool crsminpwr_adjusted;
  	bool noisevars_adjusted;

-- 
1.6.4.2

