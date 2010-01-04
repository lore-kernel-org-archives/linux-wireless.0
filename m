Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:26948 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab0ADUZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 15:25:11 -0500
Received: by ey-out-2122.google.com with SMTP id 22so219501eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jan 2010 12:25:10 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 04 Jan 2010 21:26:27 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
	"Michael Buesch" <mb@bu3sch.de>
Subject: [PATCH] b43: N-PHY: update part of init code to current specs
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u50y2cd29lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes part of init code follow updated specs.

Michael said many times he prefers smaller patches posted more frequently. So there this go.

However if you think it's too small, just let me know please.


 From 7892ad10e3e15abc960e9a05c8c372a97b1f6b67 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Date: Mon, 4 Jan 2010 21:20:14 +0100
Subject: [PATCH] b43: N-PHY: update part of init code to current specs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   72 +++++++++++++++++++++++++++++++-------
  drivers/net/wireless/b43/phy_n.h |   12 ++++++
  2 files changed, 71 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 992318a..015da44 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -417,37 +417,70 @@ static void b43_nphy_rssi_cal(struct b43_wldev *dev, u8 type)
  	//TODO
  }

+/* Init N-PHY
+ * http://bcm-v4.sipsolutions.net/802.11/PHY/Init/N
+ */
  int b43_phy_initn(struct b43_wldev *dev)
  {
+	struct ssb_bus *bus = dev->dev->bus;
  	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = phy->n;
  	u16 tmp;
+	enum ieee80211_band tmp2;
+
+	u16 clip[2];
+	bool do_cal = false;

-	//TODO: Spectral management
+	if ((dev->phy.rev >= 3) &&
+	   (bus->sprom.boardflags_lo & B43_BFL_EXTLNA) &&
+	   (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)) {
+		chipco_set32(&dev->dev->bus->chipco, SSB_CHIPCO_CHIPCTL, 0x40);
+	}
+	nphy->deaf_count = 0;
  	b43_nphy_tables_init(dev);
+	nphy->crsminpwr_adjusted = false;
+	nphy->noisevars_adjusted = false;

  	/* Clear all overrides */
-	b43_phy_write(dev, B43_NPHY_RFCTL_OVER, 0);
+	if (dev->phy.rev >= 3) {
+		b43_phy_write(dev, B43_NPHY_TXF_40CO_B1S1, 0);
+		b43_phy_write(dev, B43_NPHY_RFCTL_OVER, 0);
+		b43_phy_write(dev, B43_NPHY_TXF_40CO_B1S0, 0);
+		b43_phy_write(dev, B43_NPHY_TXF_40CO_B32S1, 0);
+	} else {
+		b43_phy_write(dev, B43_NPHY_RFCTL_OVER, 0);
+	}
  	b43_phy_write(dev, B43_NPHY_RFCTL_INTC1, 0);
  	b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, 0);
-	b43_phy_write(dev, B43_NPHY_RFCTL_INTC3, 0);
-	b43_phy_write(dev, B43_NPHY_RFCTL_INTC4, 0);
+	if (dev->phy.rev < 6) {
+		b43_phy_write(dev, B43_NPHY_RFCTL_INTC3, 0);
+		b43_phy_write(dev, B43_NPHY_RFCTL_INTC4, 0);
+	}
  	b43_phy_mask(dev, B43_NPHY_RFSEQMODE,
  		     ~(B43_NPHY_RFSEQMODE_CAOVER |
  		       B43_NPHY_RFSEQMODE_TROVER));
+	if (dev->phy.rev >= 3)
+		b43_phy_write(dev, B43_NPHY_AFECTL_OVER1, 0);
  	b43_phy_write(dev, B43_NPHY_AFECTL_OVER, 0);

-	tmp = (phy->rev < 2) ? 64 : 59;
-	b43_phy_maskset(dev, B43_NPHY_BPHY_CTL3,
-			~B43_NPHY_BPHY_CTL3_SCALE,
-			tmp << B43_NPHY_BPHY_CTL3_SCALE_SHIFT);
-
+	if (dev->phy.rev <= 2) {
+		tmp = (dev->phy.rev == 2) ? 0x3B : 0x40;
+		b43_phy_maskset(dev, B43_NPHY_BPHY_CTL3,
+				~B43_NPHY_BPHY_CTL3_SCALE,
+				tmp << B43_NPHY_BPHY_CTL3_SCALE_SHIFT);
+	}
  	b43_phy_write(dev, B43_NPHY_AFESEQ_TX2RX_PUD_20M, 0x20);
  	b43_phy_write(dev, B43_NPHY_AFESEQ_TX2RX_PUD_40M, 0x20);

-	b43_phy_write(dev, B43_NPHY_TXREALFD, 184);
-	b43_phy_write(dev, B43_NPHY_MIMO_CRSTXEXT, 200);
-	b43_phy_write(dev, B43_NPHY_PLOAD_CSENSE_EXTLEN, 80);
-	b43_phy_write(dev, B43_NPHY_C2_BCLIPBKOFF, 511);
+	if (bus->sprom.boardflags2_lo & 0x100 ||
+	    (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE &&
+	     bus->boardinfo.type == 0x8B))
+		b43_phy_write(dev, B43_NPHY_TXREALFD, 0xA0);
+	else
+		b43_phy_write(dev, B43_NPHY_TXREALFD, 0xB8);
+	b43_phy_write(dev, B43_NPHY_MIMO_CRSTXEXT, 0xC8);
+	b43_phy_write(dev, B43_NPHY_PLOAD_CSENSE_EXTLEN, 0x50);
+	b43_phy_write(dev, B43_NPHY_TXRIFS_FRDEL, 0x30);

  	//TODO MIMO-Config
  	//TODO Update TX/RX chain
@@ -456,6 +489,19 @@ int b43_phy_initn(struct b43_wldev *dev)
  		b43_phy_write(dev, B43_NPHY_DUP40_GFBL, 0xAA8);
  		b43_phy_write(dev, B43_NPHY_DUP40_BL, 0x9A4);
  	}
+
+	tmp2 = b43_current_band(dev->wl);
+	if ((nphy->ipa2g_on && tmp2 == IEEE80211_BAND_2GHZ) ||
+	    (nphy->ipa5g_on && tmp2 == IEEE80211_BAND_5GHZ)) {
+		b43_phy_set(dev, B43_NPHY_PAPD_EN0, 0x1);
+		//FIXME b43_phy_maskset(dev, B43_NPHY_EPS_TABLE_ADJ0, 0x007F, nphy->papd_epsilon_offset[0] << 7);
+		b43_phy_set(dev, B43_NPHY_PAPD_EN1, 0x1);
+		//FIXME b43_phy_maskset(dev, B43_NPHY_EPS_TABLE_ADJ1, 0x007F, nphy->papd_epsilon_offset[1] << 7);
+		//TODO N PHY IPA Set TX Dig Filters
+	} else if (phy->rev >= 5) {
+		//TODO N PHY Ext PA Set TX Dig Filters
+	}
+
  	b43_nphy_workarounds(dev);
  	b43_nphy_reset_cca(dev);

diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 1749aef..8f174b7 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -231,6 +231,7 @@
  #define B43_NPHY_C2_TXIQ_COMP_OFF		B43_PHY_N(0x088) /* Core 2 TX I/Q comp offset */
  #define B43_NPHY_C1_TXCTL			B43_PHY_N(0x08B) /* Core 1 TX control */
  #define B43_NPHY_C2_TXCTL			B43_PHY_N(0x08C) /* Core 2 TX control */
+#define B43_NPHY_AFECTL_OVER1			B43_PHY_N(0x08F) /* AFE control override 1 */
  #define B43_NPHY_SCRAM_SIGCTL			B43_PHY_N(0x090) /* Scram signal control */
  #define  B43_NPHY_SCRAM_SIGCTL_INITST		0x007F /* Initial state value */
  #define  B43_NPHY_SCRAM_SIGCTL_INITST_SHIFT	0
@@ -705,6 +706,10 @@
  #define B43_NPHY_TXPCTL_INIT			B43_PHY_N(0x222) /* TX power controll init */
  #define  B43_NPHY_TXPCTL_INIT_PIDXI1		0x00FF /* Power index init 1 */
  #define  B43_NPHY_TXPCTL_INIT_PIDXI1_SHIFT	0
+#define B43_NPHY_PAPD_EN0			B43_PHY_N(0x297) /* PAPD Enable0 TBD */
+#define B43_NPHY_EPS_TABLE_ADJ0			B43_PHY_N(0x298) /* EPS Table Adj0 TBD */
+#define B43_NPHY_PAPD_EN1			B43_PHY_N(0x29B) /* PAPD Enable1 TBD */
+#define B43_NPHY_EPS_TABLE_ADJ1			B43_PHY_N(0x29C) /* EPS Table Adj1 TBD */



@@ -920,6 +925,13 @@
  struct b43_wldev;

  struct b43_phy_n {
+	u32 deaf_count;
+	bool crsminpwr_adjusted;
+	bool noisevars_adjusted;
+
+	bool ipa2g_on;
+	bool ipa5g_on;
+
  	//TODO lots of missing stuff
  };

-- 
1.6.4.2
