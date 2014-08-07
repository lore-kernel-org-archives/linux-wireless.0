Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:43781 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945AbaHGFps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 01:45:48 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so10062904wib.2
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2014 22:45:47 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 3/7] b43: flush some writes on Broadcom MIPS SoCs
Date: Thu,  7 Aug 2014 07:45:37 +0200
Message-Id: <1407390337-19467-1-git-send-email-zajec5@gmail.com> (sfid-20140807_074553_280279_3CDE1591)
In-Reply-To: <1406836788-23704-4-git-send-email-zajec5@gmail.com>
References: <1406836788-23704-4-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Access to PHY and radio registers is indirect on Broadcom hardware and
it seems that addressing on some MIPS SoCs may require flushing. So far
this problem was noticed on 0x4716 SoC only (marketing names: BCM4717,
BCM4718).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: As Hauke noticed, Broadcom comment says this is needed for 0x4716
    and 0x4706 only. Their code does this globally on the whole MIPS
    arch, but it doesn't seem to be needed. Also BCM4706 doesn't seem
    to require this.
    So let's enable this for BCMA_CHIP_ID_BCM4716 SoC only.
    Florian has also confirmed he never needed this on BCM63XX.
---
 drivers/net/wireless/b43/b43.h        | 10 ++++++++++
 drivers/net/wireless/b43/bus.c        | 10 ++++++++++
 drivers/net/wireless/b43/bus.h        |  1 +
 drivers/net/wireless/b43/main.c       | 17 ++++++++---------
 drivers/net/wireless/b43/phy_a.c      |  4 ++--
 drivers/net/wireless/b43/phy_common.c |  4 ++--
 drivers/net/wireless/b43/phy_g.c      |  8 ++++----
 drivers/net/wireless/b43/phy_ht.c     |  6 +++---
 drivers/net/wireless/b43/phy_lcn.c    |  6 +++---
 drivers/net/wireless/b43/phy_lp.c     |  6 +++---
 drivers/net/wireless/b43/phy_n.c      |  6 +++---
 11 files changed, 49 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 4113b69..9b2d0c9 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -1012,6 +1012,16 @@ static inline void b43_write16(struct b43_wldev *dev, u16 offset, u16 value)
 	dev->dev->write16(dev->dev, offset, value);
 }
 
+/* To optimize this check for flush_writes on BCM47XX_BCMA only. */
+static inline void b43_write16f(struct b43_wldev *dev, u16 offset, u16 value)
+{
+	b43_write16(dev, offset, value);
+#if defined(CONFIG_BCM47XX_BCMA)
+	if (dev->dev->flush_writes)
+		b43_read16(dev, offset);
+#endif
+}
+
 static inline void b43_maskset16(struct b43_wldev *dev, u16 offset, u16 mask,
 				 u16 set)
 {
diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index 565fdbd..17d16a3 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -22,6 +22,10 @@
 
 */
 
+#ifdef CONFIG_BCM47XX_BCMA
+#include <asm/mach-bcm47xx/bcm47xx.h>
+#endif
+
 #include "b43.h"
 #include "bus.h"
 
@@ -102,6 +106,12 @@ struct b43_bus_dev *b43_bus_dev_bcma_init(struct bcma_device *core)
 	dev->write32 = b43_bus_bcma_write32;
 	dev->block_read = b43_bus_bcma_block_read;
 	dev->block_write = b43_bus_bcma_block_write;
+#ifdef CONFIG_BCM47XX_BCMA
+	if (b43_bus_host_is_pci(dev) &&
+	    bcm47xx_bus_type == BCM47XX_BUS_TYPE_BCMA &&
+	    bcm47xx_bus.bcma.bus.chipinfo.id == BCMA_CHIP_ID_BCM4716)
+		dev->flush_writes = true;
+#endif
 
 	dev->dev = &core->dev;
 	dev->dma_dev = core->dma_dev;
diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
index 460d9d9..256c2c1 100644
--- a/drivers/net/wireless/b43/bus.h
+++ b/drivers/net/wireless/b43/bus.h
@@ -33,6 +33,7 @@ struct b43_bus_dev {
 			   size_t count, u16 offset, u8 reg_width);
 	void (*block_write)(struct b43_bus_dev *dev, const void *buffer,
 			    size_t count, u16 offset, u8 reg_width);
+	bool flush_writes;
 
 	struct device *dev;
 	struct device *dma_dev;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 2af1ac3..66ff718 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4466,10 +4466,10 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 	if (core_rev == 40 || core_rev == 42) {
 		radio_manuf = 0x17F;
 
-		b43_write16(dev, B43_MMIO_RADIO24_CONTROL, 0);
+		b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, 0);
 		radio_rev = b43_read16(dev, B43_MMIO_RADIO24_DATA);
 
-		b43_write16(dev, B43_MMIO_RADIO24_CONTROL, 1);
+		b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, 1);
 		radio_id = b43_read16(dev, B43_MMIO_RADIO24_DATA);
 
 		radio_ver = 0; /* Is there version somewhere? */
@@ -4477,7 +4477,7 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 		u16 radio24[3];
 
 		for (tmp = 0; tmp < 3; tmp++) {
-			b43_write16(dev, B43_MMIO_RADIO24_CONTROL, tmp);
+			b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, tmp);
 			radio24[tmp] = b43_read16(dev, B43_MMIO_RADIO24_DATA);
 		}
 
@@ -4494,13 +4494,12 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 			else
 				tmp = 0x5205017F;
 		} else {
-			b43_write16(dev, B43_MMIO_RADIO_CONTROL,
-				    B43_RADIOCTL_ID);
+			b43_write16f(dev, B43_MMIO_RADIO_CONTROL,
+				     B43_RADIOCTL_ID);
 			tmp = b43_read16(dev, B43_MMIO_RADIO_DATA_LOW);
-			b43_write16(dev, B43_MMIO_RADIO_CONTROL,
-				    B43_RADIOCTL_ID);
-			tmp |= (u32)b43_read16(dev, B43_MMIO_RADIO_DATA_HIGH)
-				<< 16;
+			b43_write16f(dev, B43_MMIO_RADIO_CONTROL,
+				     B43_RADIOCTL_ID);
+			tmp |= b43_read16(dev, B43_MMIO_RADIO_DATA_HIGH) << 16;
 		}
 		radio_manuf = (tmp & 0x00000FFF);
 		radio_id = (tmp & 0x0FFFF000) >> 12;
diff --git a/drivers/net/wireless/b43/phy_a.c b/drivers/net/wireless/b43/phy_a.c
index 25e4043..99c036f 100644
--- a/drivers/net/wireless/b43/phy_a.c
+++ b/drivers/net/wireless/b43/phy_a.c
@@ -444,14 +444,14 @@ static inline u16 adjust_phyreg(struct b43_wldev *dev, u16 offset)
 static u16 b43_aphy_op_read(struct b43_wldev *dev, u16 reg)
 {
 	reg = adjust_phyreg(dev, reg);
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
 	return b43_read16(dev, B43_MMIO_PHY_DATA);
 }
 
 static void b43_aphy_op_write(struct b43_wldev *dev, u16 reg, u16 value)
 {
 	reg = adjust_phyreg(dev, reg);
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
 	b43_write16(dev, B43_MMIO_PHY_DATA, value);
 }
 
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 08ca524..1dfc682 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -278,7 +278,7 @@ u16 b43_phy_read(struct b43_wldev *dev, u16 reg)
 	if (dev->phy.ops->phy_read)
 		return dev->phy.ops->phy_read(dev, reg);
 
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
 	return b43_read16(dev, B43_MMIO_PHY_DATA);
 }
 
@@ -294,7 +294,7 @@ void b43_phy_write(struct b43_wldev *dev, u16 reg, u16 value)
 	if (dev->phy.ops->phy_write)
 		return dev->phy.ops->phy_write(dev, reg, value);
 
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
 	b43_write16(dev, B43_MMIO_PHY_DATA, value);
 }
 
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index 8f5c14b..727ce6e 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -2555,13 +2555,13 @@ static void b43_gphy_op_exit(struct b43_wldev *dev)
 
 static u16 b43_gphy_op_read(struct b43_wldev *dev, u16 reg)
 {
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
 	return b43_read16(dev, B43_MMIO_PHY_DATA);
 }
 
 static void b43_gphy_op_write(struct b43_wldev *dev, u16 reg, u16 value)
 {
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
 	b43_write16(dev, B43_MMIO_PHY_DATA, value);
 }
 
@@ -2572,7 +2572,7 @@ static u16 b43_gphy_op_radio_read(struct b43_wldev *dev, u16 reg)
 	/* G-PHY needs 0x80 for read access. */
 	reg |= 0x80;
 
-	b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_RADIO_CONTROL, reg);
 	return b43_read16(dev, B43_MMIO_RADIO_DATA_LOW);
 }
 
@@ -2581,7 +2581,7 @@ static void b43_gphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
 	/* Register 1 is a 32-bit register. */
 	B43_WARN_ON(reg == 1);
 
-	b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_RADIO_CONTROL, reg);
 	b43_write16(dev, B43_MMIO_RADIO_DATA_LOW, value);
 }
 
diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 8b0b4b6..c4dc8b0 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -1074,7 +1074,7 @@ static unsigned int b43_phy_ht_op_get_default_chan(struct b43_wldev *dev)
 static void b43_phy_ht_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
 				 u16 set)
 {
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
 	b43_write16(dev, B43_MMIO_PHY_DATA,
 		    (b43_read16(dev, B43_MMIO_PHY_DATA) & mask) | set);
 }
@@ -1084,14 +1084,14 @@ static u16 b43_phy_ht_op_radio_read(struct b43_wldev *dev, u16 reg)
 	/* HT-PHY needs 0x200 for read access */
 	reg |= 0x200;
 
-	b43_write16(dev, B43_MMIO_RADIO24_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, reg);
 	return b43_read16(dev, B43_MMIO_RADIO24_DATA);
 }
 
 static void b43_phy_ht_op_radio_write(struct b43_wldev *dev, u16 reg,
 				      u16 value)
 {
-	b43_write16(dev, B43_MMIO_RADIO24_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, reg);
 	b43_write16(dev, B43_MMIO_RADIO24_DATA, value);
 }
 
diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index bf29c3e..97461cc 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -813,7 +813,7 @@ static void b43_phy_lcn_op_adjust_txpower(struct b43_wldev *dev)
 static void b43_phy_lcn_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
 				   u16 set)
 {
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
 	b43_write16(dev, B43_MMIO_PHY_DATA,
 		    (b43_read16(dev, B43_MMIO_PHY_DATA) & mask) | set);
 }
@@ -823,14 +823,14 @@ static u16 b43_phy_lcn_op_radio_read(struct b43_wldev *dev, u16 reg)
 	/* LCN-PHY needs 0x200 for read access */
 	reg |= 0x200;
 
-	b43_write16(dev, B43_MMIO_RADIO24_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, reg);
 	return b43_read16(dev, B43_MMIO_RADIO24_DATA);
 }
 
 static void b43_phy_lcn_op_radio_write(struct b43_wldev *dev, u16 reg,
 				       u16 value)
 {
-	b43_write16(dev, B43_MMIO_RADIO24_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, reg);
 	b43_write16(dev, B43_MMIO_RADIO24_DATA, value);
 }
 
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 1e9bae6..058a9f2 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1988,7 +1988,7 @@ static void lpphy_calibration(struct b43_wldev *dev)
 static void b43_lpphy_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
 				 u16 set)
 {
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
 	b43_write16(dev, B43_MMIO_PHY_DATA,
 		    (b43_read16(dev, B43_MMIO_PHY_DATA) & mask) | set);
 }
@@ -2004,7 +2004,7 @@ static u16 b43_lpphy_op_radio_read(struct b43_wldev *dev, u16 reg)
 	} else
 		reg |= 0x200;
 
-	b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_RADIO_CONTROL, reg);
 	return b43_read16(dev, B43_MMIO_RADIO_DATA_LOW);
 }
 
@@ -2013,7 +2013,7 @@ static void b43_lpphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
 	/* Register 1 is a 32-bit register. */
 	B43_WARN_ON(reg == 1);
 
-	b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_RADIO_CONTROL, reg);
 	b43_write16(dev, B43_MMIO_RADIO_DATA_LOW, value);
 }
 
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 5565318..df64032 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -6501,7 +6501,7 @@ static void b43_nphy_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
 				 u16 set)
 {
 	check_phyreg(dev, reg);
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
 	b43_maskset16(dev, B43_MMIO_PHY_DATA, mask, set);
 	dev->phy.writes_counter = 1;
 }
@@ -6516,7 +6516,7 @@ static u16 b43_nphy_op_radio_read(struct b43_wldev *dev, u16 reg)
 	else
 		reg |= 0x100;
 
-	b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_RADIO_CONTROL, reg);
 	return b43_read16(dev, B43_MMIO_RADIO_DATA_LOW);
 }
 
@@ -6525,7 +6525,7 @@ static void b43_nphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
 	/* Register 1 is a 32-bit register. */
 	B43_WARN_ON(dev->phy.rev < 7 && reg == 1);
 
-	b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
+	b43_write16f(dev, B43_MMIO_RADIO_CONTROL, reg);
 	b43_write16(dev, B43_MMIO_RADIO_DATA_LOW, value);
 }
 
-- 
1.8.4.5

