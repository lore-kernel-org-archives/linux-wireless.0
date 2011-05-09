Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32866 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab1EIJFy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 05:05:54 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so1473428eyx.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 02:05:53 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC ONLY 4/5] b43: bus: abstract 80211 core revision
Date: Mon,  9 May 2011 11:43:20 +0200
Message-Id: <1304934201-10626-4-git-send-email-zajec5@gmail.com> (sfid-20110509_110558_207895_2A02E6AC)
In-Reply-To: <1304934201-10626-1-git-send-email-zajec5@gmail.com>
References: <1304934201-10626-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We often check for core revision, it will be easier to abstract it
instead of using conditions checking bus type.
---
 drivers/net/wireless/b43/bus.c        |    2 ++
 drivers/net/wireless/b43/bus.h        |    2 ++
 drivers/net/wireless/b43/dma.c        |    2 +-
 drivers/net/wireless/b43/main.c       |   28 ++++++++++++++--------------
 drivers/net/wireless/b43/phy_common.c |    4 ++--
 drivers/net/wireless/b43/phy_n.c      |    4 ++--
 drivers/net/wireless/b43/pio.c        |   10 +++++-----
 7 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index 8f9c133..677a8a4 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -54,5 +54,7 @@ struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev)
 	dev->write16 = b43_bus_ssb_write16;
 	dev->write32 = b43_bus_ssb_write32;
 
+	dev->core_rev = sdev->id.revision;
+
 	return dev;
 }
diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
index 7d60f4f..adb5046 100644
--- a/drivers/net/wireless/b43/bus.h
+++ b/drivers/net/wireless/b43/bus.h
@@ -15,6 +15,8 @@ struct b43_bus_dev {
 	u32 (*read32)(struct b43_bus_dev *dev, u16 offset);
 	void (*write16)(struct b43_bus_dev *dev, u16 offset, u16 value);
 	void (*write32)(struct b43_bus_dev *dev, u16 offset, u32 value);
+
+	u8 core_rev;
 };
 
 struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev);
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 10cfba3..1a7ed4f 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1084,7 +1084,7 @@ int b43_dma_init(struct b43_wldev *dev)
 		goto err_destroy_mcast;
 
 	/* No support for the TX status DMA ring. */
-	B43_WARN_ON(dev->sdev->id.revision < 5);
+	B43_WARN_ON(dev->dev->core_rev < 5);
 
 	b43dbg(dev->wl, "%u-bit DMA initialized\n",
 	       (unsigned int)type);
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index dc7ca44..6b1d2a3 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -548,7 +548,7 @@ void b43_tsf_read(struct b43_wldev *dev, u64 *tsf)
 {
 	u32 low, high;
 
-	B43_WARN_ON(dev->sdev->id.revision < 3);
+	B43_WARN_ON(dev->dev->core_rev < 3);
 
 	/* The hardware guarantees us an atomic read, if we
 	 * read the low register first. */
@@ -586,7 +586,7 @@ static void b43_tsf_write_locked(struct b43_wldev *dev, u64 tsf)
 {
 	u32 low, high;
 
-	B43_WARN_ON(dev->sdev->id.revision < 3);
+	B43_WARN_ON(dev->dev->core_rev < 3);
 
 	low = tsf;
 	high = (tsf >> 32);
@@ -714,7 +714,7 @@ void b43_dummy_transmission(struct b43_wldev *dev, bool ofdm, bool pa_on)
 		b43_ram_write(dev, i * 4, buffer[i]);
 
 	b43_write16(dev, 0x0568, 0x0000);
-	if (dev->sdev->id.revision < 11)
+	if (dev->dev->core_rev < 11)
 		b43_write16(dev, 0x07C0, 0x0000);
 	else
 		b43_write16(dev, 0x07C0, 0x0100);
@@ -1132,7 +1132,7 @@ void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags)
 	b43_write32(dev, B43_MMIO_MACCTL, macctl);
 	/* Commit write */
 	b43_read32(dev, B43_MMIO_MACCTL);
-	if (awake && dev->sdev->id.revision >= 5) {
+	if (awake && dev->dev->core_rev >= 5) {
 		/* Wait for the microcode to wake up. */
 		for (i = 0; i < 100; i++) {
 			ucstat = b43_shm_read16(dev, B43_SHM_SHARED,
@@ -1215,7 +1215,7 @@ static void drain_txstatus_queue(struct b43_wldev *dev)
 {
 	u32 dummy;
 
-	if (dev->sdev->id.revision < 5)
+	if (dev->dev->core_rev < 5)
 		return;
 	/* Read all entries from the microcode TXstatus FIFO
 	 * and throw them away.
@@ -1683,7 +1683,7 @@ static void b43_update_templates(struct b43_wl *wl)
 static void b43_set_beacon_int(struct b43_wldev *dev, u16 beacon_int)
 {
 	b43_time_lock(dev);
-	if (dev->sdev->id.revision >= 3) {
+	if (dev->dev->core_rev >= 3) {
 		b43_write32(dev, B43_MMIO_TSF_CFP_REP, (beacon_int << 16));
 		b43_write32(dev, B43_MMIO_TSF_CFP_START, (beacon_int << 10));
 	} else {
@@ -2107,7 +2107,7 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 {
 	struct b43_wldev *dev = ctx->dev;
 	struct b43_firmware *fw = &ctx->dev->fw;
-	const u8 rev = ctx->dev->sdev->id.revision;
+	const u8 rev = ctx->dev->dev->core_rev;
 	const char *filename;
 	u32 tmshigh;
 	int err;
@@ -2589,7 +2589,7 @@ static int b43_gpio_init(struct b43_wldev *dev)
 		mask |= 0x0200;
 		set |= 0x0200;
 	}
-	if (dev->sdev->id.revision >= 2)
+	if (dev->dev->core_rev >= 2)
 		mask |= 0x0010;	/* FIXME: This is redundant. */
 
 #ifdef CONFIG_SSB_DRIVER_PCICORE
@@ -2722,7 +2722,7 @@ static void b43_adjust_opmode(struct b43_wldev *dev)
 	/* Workaround: On old hardware the HW-MAC-address-filter
 	 * doesn't work properly, so always run promisc in filter
 	 * it in software. */
-	if (dev->sdev->id.revision <= 4)
+	if (dev->dev->core_rev <= 4)
 		ctl |= B43_MACCTL_PROMISC;
 
 	b43_write32(dev, B43_MMIO_MACCTL, ctl);
@@ -2888,7 +2888,7 @@ static int b43_chip_init(struct b43_wldev *dev)
 		b43_write16(dev, 0x005E, value16);
 	}
 	b43_write32(dev, 0x0100, 0x01000000);
-	if (dev->sdev->id.revision < 5)
+	if (dev->dev->core_rev < 5)
 		b43_write32(dev, 0x010C, 0x01000000);
 
 	b43_write32(dev, B43_MMIO_MACCTL, b43_read32(dev, B43_MMIO_MACCTL)
@@ -2903,7 +2903,7 @@ static int b43_chip_init(struct b43_wldev *dev)
 	/* Initially set the wireless operation mode. */
 	b43_adjust_opmode(dev);
 
-	if (dev->sdev->id.revision < 3) {
+	if (dev->dev->core_rev < 3) {
 		b43_write16(dev, 0x060E, 0x0000);
 		b43_write16(dev, 0x0610, 0x8000);
 		b43_write16(dev, 0x0604, 0x0000);
@@ -3088,7 +3088,7 @@ static int b43_validate_chipaccess(struct b43_wldev *dev)
 	b43_shm_write32(dev, B43_SHM_SHARED, 0, backup0);
 	b43_shm_write32(dev, B43_SHM_SHARED, 4, backup4);
 
-	if ((dev->sdev->id.revision >= 3) && (dev->sdev->id.revision <= 10)) {
+	if ((dev->dev->core_rev >= 3) && (dev->dev->core_rev <= 10)) {
 		/* The 32bit register shadows the two 16bit registers
 		 * with update sideeffects. Validate this. */
 		b43_write16(dev, B43_MMIO_TSF_CFP_START, 0xAAAA);
@@ -4323,7 +4323,7 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	if (err)
 		goto err_busdown;
 	b43_shm_write16(dev, B43_SHM_SHARED,
-			B43_SHM_SH_WLCOREREV, dev->sdev->id.revision);
+			B43_SHM_SH_WLCOREREV, dev->dev->core_rev);
 	hf = b43_hf_read(dev);
 	if (phy->type == B43_PHYTYPE_G) {
 		hf |= B43_HF_SYMW;
@@ -4727,7 +4727,7 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 		goto out;
 	}
 	/* Get the PHY type. */
-	if (dev->sdev->id.revision >= 5) {
+	if (dev->dev->core_rev >= 5) {
 		u32 tmshigh;
 
 		tmshigh = ssb_read32(dev->sdev, SSB_TMSHIGH);
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index e46b2f4..3f7bdf8 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -168,7 +168,7 @@ void b43_phy_lock(struct b43_wldev *dev)
 	B43_WARN_ON(dev->phy.phy_locked);
 	dev->phy.phy_locked = 1;
 #endif
-	B43_WARN_ON(dev->sdev->id.revision < 3);
+	B43_WARN_ON(dev->dev->core_rev < 3);
 
 	if (!b43_is_mode(dev->wl, NL80211_IFTYPE_AP))
 		b43_power_saving_ctl_bits(dev, B43_PS_AWAKE);
@@ -180,7 +180,7 @@ void b43_phy_unlock(struct b43_wldev *dev)
 	B43_WARN_ON(!dev->phy.phy_locked);
 	dev->phy.phy_locked = 0;
 #endif
-	B43_WARN_ON(dev->sdev->id.revision < 3);
+	B43_WARN_ON(dev->dev->core_rev < 3);
 
 	if (!b43_is_mode(dev->wl, NL80211_IFTYPE_AP))
 		b43_power_saving_ctl_bits(dev, 0);
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 602f1c5..ddbd018 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -983,7 +983,7 @@ static u16 b43_nphy_classifier(struct b43_wldev *dev, u16 mask, u16 val)
 {
 	u16 tmp;
 
-	if (dev->sdev->id.revision == 16)
+	if (dev->dev->core_rev == 16)
 		b43_mac_suspend(dev);
 
 	tmp = b43_phy_read(dev, B43_NPHY_CLASSCTL);
@@ -993,7 +993,7 @@ static u16 b43_nphy_classifier(struct b43_wldev *dev, u16 mask, u16 val)
 	tmp |= (val & mask);
 	b43_phy_maskset(dev, B43_NPHY_CLASSCTL, 0xFFF8, tmp);
 
-	if (dev->sdev->id.revision == 16)
+	if (dev->dev->core_rev == 16)
 		b43_mac_enable(dev);
 
 	return tmp;
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index af0596d..b94de3dd 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -111,7 +111,7 @@ static u16 index_to_pioqueue_base(struct b43_wldev *dev,
 		B43_MMIO_PIO11_BASE5,
 	};
 
-	if (dev->sdev->id.revision >= 11) {
+	if (dev->dev->core_rev >= 11) {
 		B43_WARN_ON(index >= ARRAY_SIZE(bases_rev11));
 		return bases_rev11[index];
 	}
@@ -121,14 +121,14 @@ static u16 index_to_pioqueue_base(struct b43_wldev *dev,
 
 static u16 pio_txqueue_offset(struct b43_wldev *dev)
 {
-	if (dev->sdev->id.revision >= 11)
+	if (dev->dev->core_rev >= 11)
 		return 0x18;
 	return 0;
 }
 
 static u16 pio_rxqueue_offset(struct b43_wldev *dev)
 {
-	if (dev->sdev->id.revision >= 11)
+	if (dev->dev->core_rev >= 11)
 		return 0x38;
 	return 8;
 }
@@ -144,7 +144,7 @@ static struct b43_pio_txqueue *b43_setup_pioqueue_tx(struct b43_wldev *dev,
 	if (!q)
 		return NULL;
 	q->dev = dev;
-	q->rev = dev->sdev->id.revision;
+	q->rev = dev->dev->core_rev;
 	q->mmio_base = index_to_pioqueue_base(dev, index) +
 		       pio_txqueue_offset(dev);
 	q->index = index;
@@ -178,7 +178,7 @@ static struct b43_pio_rxqueue *b43_setup_pioqueue_rx(struct b43_wldev *dev,
 	if (!q)
 		return NULL;
 	q->dev = dev;
-	q->rev = dev->sdev->id.revision;
+	q->rev = dev->dev->core_rev;
 	q->mmio_base = index_to_pioqueue_base(dev, index) +
 		       pio_rxqueue_offset(dev);
 
-- 
1.7.3.4

