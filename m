Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37415 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab0BIUEs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 15:04:48 -0500
Received: by ewy19 with SMTP id 19so7496383ewy.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Feb 2010 12:04:47 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 02/11] b43: N-PHY: initialize super switch
Date: Tue,  9 Feb 2010 21:04:34 +0100
Message-Id: <1265745883-3392-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 795bb1e..2d8eda1 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -646,6 +646,41 @@ static void b43_nphy_read_clip_detection(struct b43_wldev *dev, u16 *clip_st)
 	clip_st[1] = b43_phy_read(dev, B43_NPHY_C2_CLIP1THRES);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SuperSwitchInit */
+static void b43_nphy_superswitch_init(struct b43_wldev *dev, bool init)
+{
+	if (dev->phy.rev >= 3) {
+		if (!init)
+			return;
+		if (0 /* FIXME */) {
+			b43_ntab_write(dev, B43_NTAB16(9, 2), 0x211);
+			b43_ntab_write(dev, B43_NTAB16(9, 3), 0x222);
+			b43_ntab_write(dev, B43_NTAB16(9, 8), 0x144);
+			b43_ntab_write(dev, B43_NTAB16(9, 12), 0x188);
+		}
+	} else {
+		b43_phy_write(dev, B43_NPHY_GPIO_LOOEN, 0);
+		b43_phy_write(dev, B43_NPHY_GPIO_HIOEN, 0);
+
+		ssb_chipco_gpio_control(&dev->dev->bus->chipco, 0xFC00,
+					0xFC00);
+		b43_write32(dev, B43_MMIO_MACCTL,
+			b43_read32(dev, B43_MMIO_MACCTL) &
+			~B43_MACCTL_GPOUTSMSK);
+		b43_write16(dev, B43_MMIO_GPIO_MASK,
+			b43_read16(dev, B43_MMIO_GPIO_MASK) | 0xFC00);
+		b43_write16(dev, B43_MMIO_GPIO_CONTROL,
+			b43_read16(dev, B43_MMIO_GPIO_CONTROL) & ~0xFC00);
+
+		if (init) {
+			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO1, 0x2D8);
+			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP1, 0x301);
+			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO2, 0x2D8);
+			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2, 0x301);
+		}
+	}
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/classifier */
 static u16 b43_nphy_classifier(struct b43_wldev *dev, u16 mask, u16 val)
 {
@@ -3116,7 +3151,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 			target = b43_nphy_get_tx_gains(dev);
 
 			if (nphy->antsel_type == 2)
-				;/*TODO NPHY Superswitch Init with argument 1*/
+				b43_nphy_superswitch_init(dev, true);
 			if (nphy->perical != 2) {
 				b43_nphy_rssi_cal(dev);
 				if (phy->rev >= 3) {
-- 
1.6.4.2

