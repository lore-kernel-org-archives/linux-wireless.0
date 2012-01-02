Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40972 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab2ABRuG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 12:50:06 -0500
Received: by eekc4 with SMTP id c4so15359264eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jan 2012 09:50:05 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/3] b43: add maskset helpers
Date: Mon,  2 Jan 2012 19:31:21 +0100
Message-Id: <1325529082-10218-1-git-send-email-zajec5@gmail.com> (sfid-20120102_185009_244570_60DB82B5)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h   |   12 +++++++
 drivers/net/wireless/b43/main.c  |   67 +++++++++++---------------------------
 drivers/net/wireless/b43/phy_n.c |   14 +++-----
 3 files changed, 36 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 16e8f80..835462d 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -999,6 +999,12 @@ static inline void b43_write16(struct b43_wldev *dev, u16 offset, u16 value)
 	dev->dev->write16(dev->dev, offset, value);
 }
 
+static inline void b43_maskset16(struct b43_wldev *dev, u16 offset, u16 mask,
+				 u16 set)
+{
+	b43_write16(dev, offset, (b43_read16(dev, offset) & mask) | set);
+}
+
 static inline u32 b43_read32(struct b43_wldev *dev, u16 offset)
 {
 	return dev->dev->read32(dev->dev, offset);
@@ -1009,6 +1015,12 @@ static inline void b43_write32(struct b43_wldev *dev, u16 offset, u32 value)
 	dev->dev->write32(dev->dev, offset, value);
 }
 
+static inline void b43_maskset32(struct b43_wldev *dev, u16 offset, u32 mask,
+				 u32 set)
+{
+	b43_write32(dev, offset, (b43_read32(dev, offset) & mask) | set);
+}
+
 static inline void b43_block_read(struct b43_wldev *dev, void *buffer,
 				 size_t count, u16 offset, u8 reg_width)
 {
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 989f654..4858e66 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -578,22 +578,14 @@ void b43_tsf_read(struct b43_wldev *dev, u64 *tsf)
 
 static void b43_time_lock(struct b43_wldev *dev)
 {
-	u32 macctl;
-
-	macctl = b43_read32(dev, B43_MMIO_MACCTL);
-	macctl |= B43_MACCTL_TBTTHOLD;
-	b43_write32(dev, B43_MMIO_MACCTL, macctl);
+	b43_maskset32(dev, B43_MMIO_MACCTL, ~0, B43_MACCTL_TBTTHOLD);
 	/* Commit the write */
 	b43_read32(dev, B43_MMIO_MACCTL);
 }
 
 static void b43_time_unlock(struct b43_wldev *dev)
 {
-	u32 macctl;
-
-	macctl = b43_read32(dev, B43_MMIO_MACCTL);
-	macctl &= ~B43_MACCTL_TBTTHOLD;
-	b43_write32(dev, B43_MMIO_MACCTL, macctl);
+	b43_maskset32(dev, B43_MMIO_MACCTL, ~B43_MACCTL_TBTTHOLD, 0);
 	/* Commit the write */
 	b43_read32(dev, B43_MMIO_MACCTL);
 }
@@ -2485,10 +2477,8 @@ static int b43_upload_microcode(struct b43_wldev *dev)
 	b43_write32(dev, B43_MMIO_GEN_IRQ_REASON, B43_IRQ_ALL);
 
 	/* Start the microcode PSM */
-	macctl = b43_read32(dev, B43_MMIO_MACCTL);
-	macctl &= ~B43_MACCTL_PSM_JMP0;
-	macctl |= B43_MACCTL_PSM_RUN;
-	b43_write32(dev, B43_MMIO_MACCTL, macctl);
+	b43_maskset32(dev, B43_MMIO_MACCTL, ~B43_MACCTL_PSM_JMP0,
+		      B43_MACCTL_PSM_RUN);
 
 	/* Wait for the microcode to load and respond */
 	i = 0;
@@ -2588,10 +2578,9 @@ static int b43_upload_microcode(struct b43_wldev *dev)
 	return 0;
 
 error:
-	macctl = b43_read32(dev, B43_MMIO_MACCTL);
-	macctl &= ~B43_MACCTL_PSM_RUN;
-	macctl |= B43_MACCTL_PSM_JMP0;
-	b43_write32(dev, B43_MMIO_MACCTL, macctl);
+	/* Stop the microcode PSM. */
+	b43_maskset32(dev, B43_MMIO_MACCTL, ~B43_MACCTL_PSM_RUN,
+		      B43_MACCTL_PSM_JMP0);
 
 	return err;
 }
@@ -2706,11 +2695,8 @@ static int b43_gpio_init(struct b43_wldev *dev)
 	struct ssb_device *gpiodev;
 	u32 mask, set;
 
-	b43_write32(dev, B43_MMIO_MACCTL, b43_read32(dev, B43_MMIO_MACCTL)
-		    & ~B43_MACCTL_GPOUTSMSK);
-
-	b43_write16(dev, B43_MMIO_GPIO_MASK, b43_read16(dev, B43_MMIO_GPIO_MASK)
-		    | 0x000F);
+	b43_maskset32(dev, B43_MMIO_MACCTL, ~B43_MACCTL_GPOUTSMSK, 0);
+	b43_maskset16(dev, B43_MMIO_GPIO_MASK, ~0, 0xF);
 
 	mask = 0x0000001F;
 	set = 0x0000000F;
@@ -2798,9 +2784,7 @@ void b43_mac_enable(struct b43_wldev *dev)
 	dev->mac_suspended--;
 	B43_WARN_ON(dev->mac_suspended < 0);
 	if (dev->mac_suspended == 0) {
-		b43_write32(dev, B43_MMIO_MACCTL,
-			    b43_read32(dev, B43_MMIO_MACCTL)
-			    | B43_MACCTL_ENABLED);
+		b43_maskset32(dev, B43_MMIO_MACCTL, ~0, B43_MACCTL_ENABLED);
 		b43_write32(dev, B43_MMIO_GEN_IRQ_REASON,
 			    B43_IRQ_MAC_SUSPENDED);
 		/* Commit writes */
@@ -2821,9 +2805,7 @@ void b43_mac_suspend(struct b43_wldev *dev)
 
 	if (dev->mac_suspended == 0) {
 		b43_power_saving_ctl_bits(dev, B43_PS_AWAKE);
-		b43_write32(dev, B43_MMIO_MACCTL,
-			    b43_read32(dev, B43_MMIO_MACCTL)
-			    & ~B43_MACCTL_ENABLED);
+		b43_maskset32(dev, B43_MMIO_MACCTL, ~B43_MACCTL_ENABLED, 0);
 		/* force pci to flush the write */
 		b43_read32(dev, B43_MMIO_MACCTL);
 		for (i = 35; i; i--) {
@@ -2929,15 +2911,10 @@ static void b43_adjust_opmode(struct b43_wldev *dev)
 	 *        so always disable it. If we want to implement PMQ,
 	 *        we need to enable it here (clear DISCPMQ) in AP mode.
 	 */
-	if (0  /* ctl & B43_MACCTL_AP */) {
-		b43_write32(dev, B43_MMIO_MACCTL,
-			    b43_read32(dev, B43_MMIO_MACCTL)
-			    & ~B43_MACCTL_DISCPMQ);
-	} else {
-		b43_write32(dev, B43_MMIO_MACCTL,
-			    b43_read32(dev, B43_MMIO_MACCTL)
-			    | B43_MACCTL_DISCPMQ);
-	}
+	if (0  /* ctl & B43_MACCTL_AP */)
+		b43_maskset32(dev, B43_MMIO_MACCTL, ~B43_MACCTL_DISCPMQ, 0);
+	else
+		b43_maskset32(dev, B43_MMIO_MACCTL, ~0, B43_MACCTL_DISCPMQ);
 }
 
 static void b43_rate_memory_write(struct b43_wldev *dev, u16 rate, int is_ofdm)
@@ -3081,10 +3058,8 @@ static int b43_chip_init(struct b43_wldev *dev)
 	if (dev->dev->core_rev < 5)
 		b43_write32(dev, 0x010C, 0x01000000);
 
-	b43_write32(dev, B43_MMIO_MACCTL, b43_read32(dev, B43_MMIO_MACCTL)
-		    & ~B43_MACCTL_INFRA);
-	b43_write32(dev, B43_MMIO_MACCTL, b43_read32(dev, B43_MMIO_MACCTL)
-		    | B43_MACCTL_INFRA);
+	b43_maskset32(dev, B43_MMIO_MACCTL, ~B43_MACCTL_INFRA, 0);
+	b43_maskset32(dev, B43_MMIO_MACCTL, ~0, B43_MACCTL_INFRA);
 
 	/* Probe Response Timeout value */
 	/* FIXME: Default to 0, has to be set by ioctl probably... :-/ */
@@ -4562,8 +4537,6 @@ static void b43_set_pretbtt(struct b43_wldev *dev)
 /* Locking: wl->mutex */
 static void b43_wireless_core_exit(struct b43_wldev *dev)
 {
-	u32 macctl;
-
 	B43_WARN_ON(dev && b43_status(dev) > B43_STAT_INITIALIZED);
 	if (!dev || b43_status(dev) != B43_STAT_INITIALIZED)
 		return;
@@ -4574,10 +4547,8 @@ static void b43_wireless_core_exit(struct b43_wldev *dev)
 	b43_set_status(dev, B43_STAT_UNINIT);
 
 	/* Stop the microcode PSM. */
-	macctl = b43_read32(dev, B43_MMIO_MACCTL);
-	macctl &= ~B43_MACCTL_PSM_RUN;
-	macctl |= B43_MACCTL_PSM_JMP0;
-	b43_write32(dev, B43_MMIO_MACCTL, macctl);
+	b43_maskset32(dev, B43_MMIO_MACCTL, ~B43_MACCTL_PSM_RUN,
+		      B43_MACCTL_PSM_JMP0);
 
 	b43_dma_free(dev);
 	b43_pio_free(dev);
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index aadfed0..c5cb0f4 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3968,13 +3968,10 @@ static void b43_nphy_superswitch_init(struct b43_wldev *dev, bool init)
 #endif
 		}
 
-		b43_write32(dev, B43_MMIO_MACCTL,
-			b43_read32(dev, B43_MMIO_MACCTL) &
-			~B43_MACCTL_GPOUTSMSK);
-		b43_write16(dev, B43_MMIO_GPIO_MASK,
-			b43_read16(dev, B43_MMIO_GPIO_MASK) | 0xFC00);
-		b43_write16(dev, B43_MMIO_GPIO_CONTROL,
-			b43_read16(dev, B43_MMIO_GPIO_CONTROL) & ~0xFC00);
+		b43_maskset32(dev, B43_MMIO_MACCTL, ~B43_MACCTL_GPOUTSMSK, 0);
+		b43_maskset16(dev, B43_MMIO_GPIO_MASK, ~0, 0xFC00);
+		b43_maskset16(dev, B43_MMIO_GPIO_CONTROL, (~0xFC00 & 0xFFFF),
+			      0);
 
 		if (init) {
 			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO1, 0x2D8);
@@ -4530,8 +4527,7 @@ static void b43_nphy_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
 {
 	check_phyreg(dev, reg);
 	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
-	b43_write16(dev, B43_MMIO_PHY_DATA,
-		    (b43_read16(dev, B43_MMIO_PHY_DATA) & mask) | set);
+	b43_maskset16(dev, B43_MMIO_PHY_DATA, mask, set);
 }
 
 static u16 b43_nphy_op_radio_read(struct b43_wldev *dev, u16 reg)
-- 
1.7.3.4

