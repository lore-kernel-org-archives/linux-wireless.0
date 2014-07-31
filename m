Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:54332 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaGaUAv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2014 16:00:51 -0400
Received: by mail-we0-f174.google.com with SMTP id x48so3274904wes.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2014 13:00:47 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3.18 1/7] b43: update flushing many writes performed in a row
Date: Thu, 31 Jul 2014 21:59:42 +0200
Message-Id: <1406836788-23704-2-git-send-email-zajec5@gmail.com> (sfid-20140731_220054_158031_9978B719)
In-Reply-To: <1406836788-23704-1-git-send-email-zajec5@gmail.com>
References: <1406836788-23704-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flush radio writes as well and add some tiny optimizations (e.g.
masksetting PHY reg involves reading it, so reset the counter).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/bus.h        | 14 ++++++++++++++
 drivers/net/wireless/b43/phy_common.c | 13 ++++++++++---
 drivers/net/wireless/b43/phy_n.c      |  1 +
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
index f3205c6..460d9d9 100644
--- a/drivers/net/wireless/b43/bus.h
+++ b/drivers/net/wireless/b43/bus.h
@@ -60,7 +60,21 @@ static inline bool b43_bus_host_is_pcmcia(struct b43_bus_dev *dev)
 #else
 	return false;
 #endif
+};
+
+static inline bool b43_bus_host_is_pci(struct b43_bus_dev *dev)
+{
+#ifdef CONFIG_B43_BCMA
+	if (dev->bus_type == B43_BUS_BCMA)
+		return (dev->bdev->bus->hosttype == BCMA_HOSTTYPE_PCI);
+#endif
+#ifdef CONFIG_B43_SSB
+	if (dev->bus_type == B43_BUS_SSB)
+		return (dev->sdev->bus->bustype == SSB_BUSTYPE_PCI);
+#endif
+	return false;
 }
+
 static inline bool b43_bus_host_is_sdio(struct b43_bus_dev *dev)
 {
 #ifdef CONFIG_B43_SSB
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 3cbef21..c868748 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -222,12 +222,18 @@ static inline void assert_mac_suspended(struct b43_wldev *dev)
 u16 b43_radio_read(struct b43_wldev *dev, u16 reg)
 {
 	assert_mac_suspended(dev);
+	dev->phy.writes_counter = 0;
 	return dev->phy.ops->radio_read(dev, reg);
 }
 
 void b43_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
 {
 	assert_mac_suspended(dev);
+	if (b43_bus_host_is_pci(dev->dev) &&
+	    ++dev->phy.writes_counter > B43_MAX_WRITES_IN_ROW) {
+		b43_read32(dev, B43_MMIO_MACCTL);
+		dev->phy.writes_counter = 1;
+	}
 	dev->phy.ops->radio_write(dev, reg, value);
 }
 
@@ -274,11 +280,12 @@ u16 b43_phy_read(struct b43_wldev *dev, u16 reg)
 void b43_phy_write(struct b43_wldev *dev, u16 reg, u16 value)
 {
 	assert_mac_suspended(dev);
-	dev->phy.ops->phy_write(dev, reg, value);
-	if (++dev->phy.writes_counter == B43_MAX_WRITES_IN_ROW) {
+	if (b43_bus_host_is_pci(dev->dev) &&
+	    ++dev->phy.writes_counter > B43_MAX_WRITES_IN_ROW) {
 		b43_read16(dev, B43_MMIO_PHY_VER);
-		dev->phy.writes_counter = 0;
+		dev->phy.writes_counter = 1;
 	}
+	dev->phy.ops->phy_write(dev, reg, value);
 }
 
 void b43_phy_copy(struct b43_wldev *dev, u16 destreg, u16 srcreg)
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index e2a3f0d..b04aa34 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -6517,6 +6517,7 @@ static void b43_nphy_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
 	check_phyreg(dev, reg);
 	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
 	b43_maskset16(dev, B43_MMIO_PHY_DATA, mask, set);
+	dev->phy.writes_counter = 1;
 }
 
 static u16 b43_nphy_op_radio_read(struct b43_wldev *dev, u16 reg)
-- 
1.8.4.5

