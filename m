Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:16332 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab0BDL26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 06:28:58 -0500
Received: by fg-out-1718.google.com with SMTP id 16so322949fgg.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 03:28:56 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/5] b43: N-PHY: implement overriding RF control intc
Date: Thu,  4 Feb 2010 12:23:08 +0100
Message-Id: <1265282592-25491-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  117 +++++++++++++++++++++++++++++++++++---
 1 files changed, 109 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 6392da2..8992457 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -68,6 +68,10 @@ static void b43_nphy_set_rf_sequence(struct b43_wldev *dev, u8 cmd,
 					u8 *events, u8 *delays, u8 length);
 static void b43_nphy_force_rf_sequence(struct b43_wldev *dev,
 				       enum b43_nphy_rf_sequence seq);
+static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
+						u16 value, u8 core, bool off);
+static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
+						u16 value, u8 core);
 
 void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
 {//TODO
@@ -498,8 +502,8 @@ static void b43_nphy_rx_cal_phy_setup(struct b43_wldev *dev, u8 core)
 		b43_phy_set(dev, B43_NPHY_AFECTL_OVER, 0x0007);
 	}
 
-	/* TODO: Call N PHY RF Ctrl Intc Override with 2, 0, 3 as arguments */
-	/* TODO: Call N PHY RF Intc Override with 8, 0, 3, 0 as arguments */
+	b43_nphy_rf_control_intc_override(dev, 2, 0, 3);
+	b43_nphy_rf_control_override(dev, 8, 0, 3, false);
 	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RX2TX);
 
 	if (core == 0) {
@@ -509,9 +513,8 @@ static void b43_nphy_rx_cal_phy_setup(struct b43_wldev *dev, u8 core)
 		rxval = 4;
 		txval = 2;
 	}
-
-	/* TODO: Call N PHY RF Ctrl Intc Override with 1, rxval, (core + 1) */
-	/* TODO: Call N PHY RF Ctrl Intc Override with 1, txval, (2 - core) */
+	b43_nphy_rf_control_intc_override(dev, 1, rxval, (core + 1));
+	b43_nphy_rf_control_intc_override(dev, 1, txval, (2 - core));
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CalcRxIqComp */
@@ -1264,6 +1267,104 @@ static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
 	}
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlIntcOverride */
+static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
+						u16 value, u8 core)
+{
+	u8 i, j;
+	u16 reg, tmp, val;
+
+	B43_WARN_ON(dev->phy.rev < 3);
+	B43_WARN_ON(field > 4);
+
+	for (i = 0; i < 2; i++) {
+		if ((core == 1 && i == 1) || (core == 2 && !i))
+			continue;
+
+		reg = (i == 0) ?
+			B43_NPHY_RFCTL_INTC1 : B43_NPHY_RFCTL_INTC2;
+		b43_phy_mask(dev, reg, 0xFBFF);
+
+		switch (field) {
+		case 0:
+			b43_phy_write(dev, reg, 0);
+			b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
+			break;
+		case 1:
+			if (!i) {
+				b43_phy_maskset(dev, B43_NPHY_RFCTL_INTC1,
+						0xFC3F, (value << 6));
+				b43_phy_maskset(dev, B43_NPHY_TXF_40CO_B1S1,
+						0xFFFE, 1);
+				b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
+						B43_NPHY_RFCTL_CMD_START);
+				for (j = 0; j < 100; j++) {
+					if (b43_phy_read(dev, B43_NPHY_RFCTL_CMD) & B43_NPHY_RFCTL_CMD_START) {
+						j = 0;
+						break;
+					}
+					udelay(10);
+				}
+				if (j)
+					b43err(dev->wl,
+						"intc override timeout\n");
+				b43_phy_mask(dev, B43_NPHY_TXF_40CO_B1S1,
+						0xFFFE);
+			} else {
+				b43_phy_maskset(dev, B43_NPHY_RFCTL_INTC2,
+						0xFC3F, (value << 6));
+				b43_phy_maskset(dev, B43_NPHY_RFCTL_OVER,
+						0xFFFE, 1);
+				b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
+						B43_NPHY_RFCTL_CMD_RXTX);
+				for (j = 0; j < 100; j++) {
+					if (b43_phy_read(dev, B43_NPHY_RFCTL_CMD) & B43_NPHY_RFCTL_CMD_RXTX) {
+						j = 0;
+						break;
+					}
+					udelay(10);
+				}
+				if (j)
+					b43err(dev->wl,
+						"intc override timeout\n");
+				b43_phy_mask(dev, B43_NPHY_RFCTL_OVER,
+						0xFFFE);
+			}
+			break;
+		case 2:
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+				tmp = 0x0020;
+				val = value << 5;
+			} else {
+				tmp = 0x0010;
+				val = value << 4;
+			}
+			b43_phy_maskset(dev, reg, ~tmp, val);
+			break;
+		case 3:
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+				tmp = 0x0001;
+				val = value;
+			} else {
+				tmp = 0x0004;
+				val = value << 2;
+			}
+			b43_phy_maskset(dev, reg, ~tmp, val);
+			break;
+		case 4:
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+				tmp = 0x0002;
+				val = value << 1;
+			} else {
+				tmp = 0x0008;
+				val = value << 3;
+			}
+			b43_phy_maskset(dev, reg, ~tmp, val);
+			break;
+		}
+	}
+}
+
 static void b43_nphy_bphy_init(struct b43_wldev *dev)
 {
 	unsigned int i;
@@ -2161,9 +2262,9 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
 		regs[7] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC1);
 		regs[8] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC2);
 
-		/* TODO: Call N PHY RF Ctrl Intc Override with 2, 1, 3 */
-		/* TODO: Call N PHY RF Ctrl Intc Override with 1, 2, 1 */
-		/* TODO: Call N PHY RF Ctrl Intc Override with 1, 8, 2 */
+		b43_nphy_rf_control_intc_override(dev, 2, 1, 3);
+		b43_nphy_rf_control_intc_override(dev, 1, 2, 1);
+		b43_nphy_rf_control_intc_override(dev, 1, 8, 2);
 
 		regs[9] = b43_phy_read(dev, B43_NPHY_PAPD_EN0);
 		regs[10] = b43_phy_read(dev, B43_NPHY_PAPD_EN1);
-- 
1.6.4.2

