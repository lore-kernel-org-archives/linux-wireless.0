Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:32879 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751158AbXLSGRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 01:17:16 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 4/6] rtl8180: update BB registers for rtl8225 V1 radio
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Wed, 19 Dec 2007 01:17:36 -0500
Message-ID: <20071219061735.4885.9679.stgit@tetra.sourmilk.net> (sfid-20071219_061722_365673_E00C8DF4)
In-Reply-To: <20071219061735.4885.1535.stgit@tetra.sourmilk.net>
References: <20071219061735.4885.1535.stgit@tetra.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrea Merello <andreamrl@tiscali.it>

This should give performance improvement in OFDM when signal is poor.

Signed-off-by: Andrea Merello <andreamrl@tiscali.it>
Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8180_rtl8225.c |   28 ++++++++++------------------
 1 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rtl8180_rtl8225.c b/drivers/net/wireless/rtl8180_rtl8225.c
index 1c4fd33..30c7e5d 100644
--- a/drivers/net/wireless/rtl8180_rtl8225.c
+++ b/drivers/net/wireless/rtl8180_rtl8225.c
@@ -288,10 +288,6 @@ static void rtl8225_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
-	rtl8225_write_phy_ofdm(dev, 2, 0x42);
-	rtl8225_write_phy_ofdm(dev, 6, 0x00);
-	rtl8225_write_phy_ofdm(dev, 8, 0x00);
-
 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_OFDM,
 			 rtl8225_tx_gain_cck_ofdm[ofdm_power/6] >> 1);
 
@@ -395,9 +391,9 @@ void rtl8225_rf_init(struct ieee80211_hw *dev)
 	rtl8225_write_phy_ofdm(dev, 0x03, 0x00); msleep(1);
 	rtl8225_write_phy_ofdm(dev, 0x04, 0x00); msleep(1);
 	rtl8225_write_phy_ofdm(dev, 0x05, 0x00); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x06, 0x40); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0x06, 0x00); msleep(1);
 	rtl8225_write_phy_ofdm(dev, 0x07, 0x00); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x08, 0x40); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0x08, 0x00); msleep(1);
 	rtl8225_write_phy_ofdm(dev, 0x09, 0xfe); msleep(1);
 	rtl8225_write_phy_ofdm(dev, 0x0a, 0x09); msleep(1);
 	rtl8225_write_phy_ofdm(dev, 0x0b, 0x80); msleep(1);
@@ -405,7 +401,7 @@ void rtl8225_rf_init(struct ieee80211_hw *dev)
 	rtl8225_write_phy_ofdm(dev, 0x0e, 0xd3); msleep(1);
 	rtl8225_write_phy_ofdm(dev, 0x0f, 0x38); msleep(1);
 	rtl8225_write_phy_ofdm(dev, 0x10, 0x84); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x11, 0x06); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0x11, 0x03); msleep(1);
 	rtl8225_write_phy_ofdm(dev, 0x12, 0x20); msleep(1);
 	rtl8225_write_phy_ofdm(dev, 0x13, 0x20); msleep(1);
 	rtl8225_write_phy_ofdm(dev, 0x14, 0x00); msleep(1);
@@ -427,11 +423,6 @@ void rtl8225_rf_init(struct ieee80211_hw *dev)
 	rtl8225_write_phy_ofdm(dev, 0x26, 0x90); msleep(1);
 	rtl8225_write_phy_ofdm(dev, 0x27, 0x88); msleep(1);
 
-	rtl8225_write_phy_ofdm(dev, 0x0d, rtl8225_gain[1 * 4]);
-	rtl8225_write_phy_ofdm(dev, 0x1b, rtl8225_gain[1 * 4 + 2]);
-	rtl8225_write_phy_ofdm(dev, 0x1d, rtl8225_gain[1 * 4 + 3]);
-	rtl8225_write_phy_ofdm(dev, 0x23, rtl8225_gain[1 * 4 + 1]);
-
 	rtl8225_write_phy_cck(dev, 0x00, 0x98); msleep(1);
 	rtl8225_write_phy_cck(dev, 0x03, 0x20); msleep(1);
 	rtl8225_write_phy_cck(dev, 0x04, 0x7e); msleep(1);
@@ -473,13 +464,14 @@ void rtl8225_rf_init(struct ieee80211_hw *dev)
 	rtl818x_iowrite32(priv, (__le32 __iomem *)((void __iomem *)priv->map + 0x94), 0x15c00002);
 	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
 
-	/* set sensitivity */
 	rtl8225_write(dev, 0x0c, 0x50);
-	rtl8225_write_phy_ofdm(dev, 0x0d, rtl8225_gain[1 * 4]);
-	rtl8225_write_phy_ofdm(dev, 0x1b, rtl8225_gain[1 * 4 + 2]);
-	rtl8225_write_phy_ofdm(dev, 0x1d, rtl8225_gain[1 * 4 + 3]);
-	rtl8225_write_phy_ofdm(dev, 0x23, rtl8225_gain[1 * 4 + 1]);
-	rtl8225_write_phy_cck(dev, 0x41, rtl8225_threshold[2]);
+	/* set OFDM initial gain */
+	rtl8225_write_phy_ofdm(dev, 0x0d, rtl8225_gain[4 * 4]);
+	rtl8225_write_phy_ofdm(dev, 0x23, rtl8225_gain[4 * 4 + 1]);
+	rtl8225_write_phy_ofdm(dev, 0x1b, rtl8225_gain[4 * 4 + 2]);
+	rtl8225_write_phy_ofdm(dev, 0x1d, rtl8225_gain[4 * 4 + 3]);
+	/* set CCK threshold */
+	rtl8225_write_phy_cck(dev, 0x41, rtl8225_threshold[0]);
 }
 
 static const u8 rtl8225z2_tx_power_cck_ch14[] = {


