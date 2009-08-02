Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33800 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbZHBX2Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 19:28:24 -0400
Received: by bwz19 with SMTP id 19so2170195bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2009 16:28:23 -0700 (PDT)
Message-ID: <4A76210C.4040209@gmail.com>
Date: Mon, 03 Aug 2009 01:28:12 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?B?R8OhYm9yIFN0ZWZhbg==?= =?UTF-8?B?aWs=?=
	<netrolller.3d@gmail.com>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH V2] b43: implement baseband init for LP-PHY <= rev1
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement baseband init for rev.0 and rev.1 LP PHYs. Convert boardflags_hi values to defines.
Implement b43_phy_copy for easier copying between registers, as needed by LP-PHY init.

Signed-off-by: Gábor Stefanik<netrolller.3d@gmail.com>
Cc: Michael Buesch<mb@bu3sch.de>
Cc: Larry Finger<larry.finger@lwfinger.net>
---
V2:
-Reversed argument order for b43_phy_copy.
-Named all registers, no more magic numbers.
-Whitespace errors hopefully fixed (I hope my mailer doesn't re-introduce them...)

 b43.h        |   11 ++++++
 phy_common.c |    7 ++++
 phy_common.h |    5 +++
 phy_lp.c     |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 phy_lp.h     |   11 +++++-
 phy_n.c      |    3 +
 6 files changed, 127 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 4e8ad84..41ca727 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -142,6 +142,17 @@
 #define B43_BFL_BTCMOD			0x4000	/* BFL_BTCOEXIST is given in alternate GPIOs */
 #define B43_BFL_ALTIQ			0x8000	/* alternate I/Q settings */
 
+/* SPROM boardflags_hi values */
+#define B43_BFH_NOPA			0x0001	/* has no PA */
+#define B43_BFH_RSSIINV			0x0002	/* RSSI uses positive slope (not TSSI) */
+#define B43_BFH_PAREF			0x0004	/* uses the PARef LDO */
+#define B43_BFH_3TSWITCH		0x0008	/* uses a triple throw switch shared
+						 * with bluetooth */
+#define B43_BFH_PHASESHIFT		0x0010	/* can support phase shifter */
+#define B43_BFH_BUCKBOOST		0x0020	/* has buck/booster */
+#define B43_BFH_FEM_BT			0x0040	/* has FEM and switch to share antenna
+						 * with bluetooth */
+
 /* GPIO register offset, in both ChipCommon and PCI core. */
 #define B43_GPIO_CONTROL		0x6c
 
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index e176b6e..1661b03 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -240,6 +240,13 @@ void b43_phy_write(struct b43_wldev *dev, u16 reg, u16 value)
 	dev->phy.ops->phy_write(dev, reg, value);
 }
 
+void b43_phy_copy(struct b43_wldev *dev, u16 destreg, u16 srcreg)
+{
+	assert_mac_suspended(dev);
+	dev->phy.ops->phy_write(dev, destreg,
+		dev->phy.ops->phy_read(dev, srcreg));
+}
+
 void b43_phy_mask(struct b43_wldev *dev, u16 offset, u16 mask)
 {
 	b43_phy_write(dev, offset,
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index b2d9910..c7a7d6b 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -291,6 +291,11 @@ u16 b43_phy_read(struct b43_wldev *dev, u16 reg);
 void b43_phy_write(struct b43_wldev *dev, u16 reg, u16 value);
 
 /**
+ * b43_phy_copy - copy contents of 16bit PHY register to another
+ */
+void b43_phy_copy(struct b43_wldev *dev, u16 destreg, u16 srcreg);
+
+/**
  * b43_phy_mask - Mask a PHY register with a mask
  */
 void b43_phy_mask(struct b43_wldev *dev, u16 offset, u16 mask);
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 58e319d..9653b5a 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -66,7 +66,99 @@ static void lpphy_table_init(struct b43_wldev *dev)
 
 static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 {
-	B43_WARN_ON(1);//TODO rev < 2 not supported, yet.
+	struct ssb_bus *bus = dev->dev->bus;
+	u16 tmp, tmp2;
+
+	if (dev->phy.rev == 1 &&
+	   (bus->sprom.boardflags_hi & B43_BFH_FEM_BT)) {
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xFFC0, 0x000A);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0x3F00, 0x0900);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_2, 0xFFC0, 0x000A);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_2, 0xC0FF, 0x0B00);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_3, 0xFFC0, 0x000A);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_3, 0xC0FF, 0x0400);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_4, 0xFFC0, 0x000A);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_4, 0xC0FF, 0x0B00);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_5, 0xFFC0, 0x000A);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_5, 0xC0FF, 0x0900);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_6, 0xFFC0, 0x000A);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_6, 0xC0FF, 0x0B00);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_7, 0xFFC0, 0x000A);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_7, 0xC0FF, 0x0900);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_8, 0xFFC0, 0x000A);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_8, 0xC0FF, 0x0B00);
+	} else if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ ||
+		  (bus->boardinfo.type == 0x048A) || ((dev->phy.rev == 0) &&
+		  (bus->sprom.boardflags_lo & B43_BFL_FEM))) {
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xFFC0, 0x0001);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xC0FF, 0x0400);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_2, 0xFFC0, 0x0001);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_2, 0xC0FF, 0x0500);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_3, 0xFFC0, 0x0002);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_3, 0xC0FF, 0x0800);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_4, 0xFFC0, 0x0002);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_4, 0xC0FF, 0x0A00);
+	} else if (dev->phy.rev == 1 ||
+		  (bus->sprom.boardflags_lo & B43_BFL_FEM)) {
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xFFC0, 0x0004);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xC0FF, 0x0800);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_2, 0xFFC0, 0x0004);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_2, 0xC0FF, 0x0C00);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_3, 0xFFC0, 0x0002);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_3, 0xC0FF, 0x0100);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_4, 0xFFC0, 0x0002);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_4, 0xC0FF, 0x0300);
+	} else {
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xFFC0, 0x000A);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xC0FF, 0x0900);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_2, 0xFFC0, 0x000A);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_2, 0xC0FF, 0x0B00);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_3, 0xFFC0, 0x0006);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_3, 0xC0FF, 0x0500);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_4, 0xFFC0, 0x0006);
+		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_4, 0xC0FF, 0x0700);
+	}
+	if (dev->phy.rev == 1) {
+		b43_phy_copy(dev, B43_LPPHY_TR_LOOKUP_5, B43_LPPHY_TR_LOOKUP_1);
+		b43_phy_copy(dev, B43_LPPHY_TR_LOOKUP_6, B43_LPPHY_TR_LOOKUP_2);
+		b43_phy_copy(dev, B43_LPPHY_TR_LOOKUP_7, B43_LPPHY_TR_LOOKUP_3);
+		b43_phy_copy(dev, B43_LPPHY_TR_LOOKUP_8, B43_LPPHY_TR_LOOKUP_4);
+	}
+	if ((bus->sprom.boardflags_hi & B43_BFH_FEM_BT) &&
+	    (bus->chip_id == 0x5354) &&
+	    (bus->chip_package == SSB_CHIPPACK_BCM4712S)) {
+		b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x0006);
+		b43_phy_write(dev, B43_LPPHY_GPIO_SELECT, 0x0005);
+		b43_phy_write(dev, B43_LPPHY_GPIO_OUTEN, 0xFFFF);
+		b43_hf_write(dev, b43_hf_read(dev) | 0x0800ULL << 32);
+	}
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		b43_phy_set(dev, B43_LPPHY_LP_PHY_CTL, 0x8000);
+		b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x0040);
+		b43_phy_maskset(dev, B43_LPPHY_MINPWR_LEVEL, 0x00FF, 0xA400);
+		b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xF0FF, 0x0B00);
+		b43_phy_maskset(dev, B43_LPPHY_SYNCPEAKCNT, 0xFFF8, 0x0007);
+		b43_phy_maskset(dev, B43_LPPHY_DSSS_CONFIRM_CNT, 0xFFF8, 0x0003);
+		b43_phy_maskset(dev, B43_LPPHY_DSSS_CONFIRM_CNT, 0xFFC7, 0x0020);
+		b43_phy_mask(dev, B43_LPPHY_IDLEAFTERPKTRXTO, 0x00FF);
+	} else { /* 5GHz */
+		b43_phy_mask(dev, B43_LPPHY_LP_PHY_CTL, 0x7FFF);
+		b43_phy_mask(dev, B43_LPPHY_CRSGAIN_CTL, 0xFFBF);
+	}
+	if (dev->phy.rev == 1) {
+		tmp = b43_phy_read(dev, B43_LPPHY_CLIPCTRTHRESH);
+		tmp2 = (tmp & 0x03E0) >> 5;
+		tmp2 |= tmp << 5;
+		b43_phy_write(dev, B43_LPPHY_4C3, tmp2);
+		tmp = b43_phy_read(dev, B43_LPPHY_OFDMSYNCTHRESH0);
+		tmp2 = (tmp & 0x1F00) >> 8;
+		tmp2 |= tmp << 5;
+		b43_phy_write(dev, B43_LPPHY_4C4, tmp2);
+		tmp = b43_phy_read(dev, B43_LPPHY_VERYLOWGAINDB);
+		tmp2 = tmp & 0x00FF;
+		tmp2 |= tmp << 8;
+		b43_phy_write(dev, B43_LPPHY_4C5, tmp2);
+	}
 }
 
 static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
diff --git a/drivers/net/wireless/b43/phy_lp.h b/drivers/net/wireless/b43/phy_lp.h
index 18370b4..829b2bb 100644
--- a/drivers/net/wireless/b43/phy_lp.h
+++ b/drivers/net/wireless/b43/phy_lp.h
@@ -273,12 +273,19 @@
 #define B43_LPPHY_AFE_DDFS_POINTER_INIT		B43_PHY_OFDM(0xB8) /* AFE DDFS pointer init */
 #define B43_LPPHY_AFE_DDFS_INCR_INIT		B43_PHY_OFDM(0xB9) /* AFE DDFS incr init */
 #define B43_LPPHY_MRCNOISEREDUCTION		B43_PHY_OFDM(0xBA) /* mrcNoiseReduction */
-#define B43_LPPHY_TRLOOKUP3			B43_PHY_OFDM(0xBB) /* TRLookup3 */
-#define B43_LPPHY_TRLOOKUP4			B43_PHY_OFDM(0xBC) /* TRLookup4 */
+#define B43_LPPHY_TR_LOOKUP_3			B43_PHY_OFDM(0xBB) /* TR Lookup 3 */
+#define B43_LPPHY_TR_LOOKUP_4			B43_PHY_OFDM(0xBC) /* TR Lookup 4 */
 #define B43_LPPHY_RADAR_FIFO_STAT		B43_PHY_OFDM(0xBD) /* Radar FIFO Status */
 #define B43_LPPHY_GPIO_OUTEN			B43_PHY_OFDM(0xBE) /* GPIO Out enable */
 #define B43_LPPHY_GPIO_SELECT			B43_PHY_OFDM(0xBF) /* GPIO Select */
 #define B43_LPPHY_GPIO_OUT			B43_PHY_OFDM(0xC0) /* GPIO Out */
+#define B43_LPPHY_4C3				B43_PHY_OFDM(0xC3) /* unknown, used during BB init */
+#define B43_LPPHY_4C4				B43_PHY_OFDM(0xC4) /* unknown, used during BB init */
+#define B43_LPPHY_4C5				B43_PHY_OFDM(0xC5) /* unknown, used during BB init */
+#define B43_LPPHY_TR_LOOKUP_5			B43_PHY_OFDM(0xC7) /* TR Lookup 5 */
+#define B43_LPPHY_TR_LOOKUP_6			B43_PHY_OFDM(0xC8) /* TR Lookup 6 */
+#define B43_LPPHY_TR_LOOKUP_7			B43_PHY_OFDM(0xC9) /* TR Lookup 7 */
+#define B43_LPPHY_TR_LOOKUP_8			B43_PHY_OFDM(0xCA) /* TR Lookup 8 */
 
 
 
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 8bcfda5..14ad95a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -137,7 +137,8 @@ static void b43_radio_init2055_post(struct b43_wldev *dev)
 
 	b43_radio_mask(dev, B2055_MASTER1, 0xFFF3);
 	msleep(1);
-	if ((sprom->revision != 4) || !(sprom->boardflags_hi & 0x0002)) {
+	if ((sprom->revision != 4) ||
+	   !(sprom->boardflags_hi & B43_BFH_RSSIINV)) {
 		if ((binfo->vendor != PCI_VENDOR_ID_BROADCOM) ||
 		    (binfo->type != 0x46D) ||
 		    (binfo->rev < 0x41)) {


