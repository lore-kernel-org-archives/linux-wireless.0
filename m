Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:45378 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbZFHTnu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 15:43:50 -0400
Message-ID: <4A2D69EE.9090108@free.fr>
Date: Mon, 08 Jun 2009 21:43:42 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: b43 vs b43legacy
References: <loom.20090529T190620-42@post.gmane.org> <4A20505D.40908@lwfinger.net> <4A244C5A.50307@free.fr> <200906021717.01320.mb@bu3sch.de>
In-Reply-To: <200906021717.01320.mb@bu3sch.de>
Content-Type: multipart/mixed;
 boundary="------------030904070008060006080605"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030904070008060006080605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Michael Buesch wrote:
> On Monday 01 June 2009 23:47:06 matthieu castet wrote:
>> Ok but what prevent b43 to support core 4 chip with v4 firmware like the 
>> broadcom driver does ?
>> I am aware that the current driver doesn't support it, but what are the 
>> missing part to support it ?
> 
> Recent broadcom drivers do not support <=rev4 anymore.
Which one ?
4.178.10.4 seem to support them [1].

attached is a patch that remove support for old core for b43.

[1]
$readelf -s wl_ap.o|grep -e d11.*4$
   1261: 0000b8d0  2952 OBJECT  GLOBAL DEFAULT    5 d11lp0initvals14
   1406: 0000c458   288 OBJECT  GLOBAL DEFAULT    5 d11lp0bsinitvals14
   1516: 0000ee88 20128 OBJECT  GLOBAL DEFAULT    5 d11ucode4
   1520: 000018f8  3720 OBJECT  GLOBAL DEFAULT    5 d11b0g0initvals4
   1577: 0002f13c 30992 OBJECT  GLOBAL DEFAULT    5 d11ucode14
   1614: 00048060  1312 OBJECT  GLOBAL DEFAULT    5 d11pcm4
   1809: 00003640    56 OBJECT  GLOBAL DEFAULT    5 d11a0g0bsinitvals4
   1899: 00002780    56 OBJECT  GLOBAL DEFAULT    5 d11b0g0bsinitvals4
   1920: 000027b8  3720 OBJECT  GLOBAL DEFAULT    5 d11a0g0initvals4


Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>

--------------030904070008060006080605
Content-Type: text/x-diff;
 name="b43_remove_oldcore.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="b43_remove_oldcore.diff"

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index eae680b..c93f5c0 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1083,9 +1083,6 @@ int b43_dma_init(struct b43_wldev *dev)
 	if (!dma->rx_ring)
 		goto err_destroy_mcast;
 
-	/* No support for the TX status DMA ring. */
-	B43_WARN_ON(dev->dev->id.revision < 5);
-
 	b43dbg(dev->wl, "%u-bit DMA initialized\n",
 	       (unsigned int)type);
 	err = 0;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 79b685e..a37c635 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -542,8 +542,6 @@ void b43_tsf_read(struct b43_wldev *dev, u64 *tsf)
 {
 	u32 low, high;
 
-	B43_WARN_ON(dev->dev->id.revision < 3);
-
 	/* The hardware guarantees us an atomic read, if we
 	 * read the low register first. */
 	low = b43_read32(dev, B43_MMIO_REV3PLUS_TSF_LOW);
@@ -580,8 +578,6 @@ static void b43_tsf_write_locked(struct b43_wldev *dev, u64 tsf)
 {
 	u32 low, high;
 
-	B43_WARN_ON(dev->dev->id.revision < 3);
-
 	low = tsf;
 	high = (tsf >> 32);
 	/* The hardware guarantees us an atomic write, if we
@@ -837,27 +833,11 @@ static void keymac_write(struct b43_wldev *dev, u8 index, const u8 *addr)
 		addrtmp[1] |= ((u32) (addr[5]) << 8);
 	}
 
-	if (dev->dev->id.revision >= 5) {
-		/* Receive match transmitter address mechanism */
-		b43_shm_write32(dev, B43_SHM_RCMTA,
-				(index * 2) + 0, addrtmp[0]);
-		b43_shm_write16(dev, B43_SHM_RCMTA,
-				(index * 2) + 1, addrtmp[1]);
-	} else {
-		/* RXE (Receive Engine) and
-		 * PSM (Programmable State Machine) mechanism
-		 */
-		if (index < 8) {
-			/* TODO write to RCM 16, 19, 22 and 25 */
-		} else {
-			b43_shm_write32(dev, B43_SHM_SHARED,
-					B43_SHM_SH_PSM + (index * 6) + 0,
-					addrtmp[0]);
-			b43_shm_write16(dev, B43_SHM_SHARED,
-					B43_SHM_SH_PSM + (index * 6) + 4,
-					addrtmp[1]);
-		}
-	}
+	/* Receive match transmitter address mechanism */
+	b43_shm_write32(dev, B43_SHM_RCMTA,
+			(index * 2) + 0, addrtmp[0]);
+	b43_shm_write16(dev, B43_SHM_RCMTA,
+			(index * 2) + 1, addrtmp[1]);
 }
 
 static void do_key_write(struct b43_wldev *dev,
@@ -1046,7 +1026,7 @@ void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags)
 	b43_write32(dev, B43_MMIO_MACCTL, macctl);
 	/* Commit write */
 	b43_read32(dev, B43_MMIO_MACCTL);
-	if (awake && dev->dev->id.revision >= 5) {
+	if (awake) {
 		/* Wait for the microcode to wake up. */
 		for (i = 0; i < 100; i++) {
 			ucstat = b43_shm_read16(dev, B43_SHM_SHARED,
@@ -1127,8 +1107,6 @@ static void drain_txstatus_queue(struct b43_wldev *dev)
 {
 	u32 dummy;
 
-	if (dev->dev->id.revision < 5)
-		return;
 	/* Read all entries from the microcode TXstatus FIFO
 	 * and throw them away.
 	 */
@@ -1683,13 +1661,8 @@ static void b43_update_templates(struct b43_wl *wl)
 static void b43_set_beacon_int(struct b43_wldev *dev, u16 beacon_int)
 {
 	b43_time_lock(dev);
-	if (dev->dev->id.revision >= 3) {
-		b43_write32(dev, B43_MMIO_TSF_CFP_REP, (beacon_int << 16));
-		b43_write32(dev, B43_MMIO_TSF_CFP_START, (beacon_int << 10));
-	} else {
-		b43_write16(dev, 0x606, (beacon_int >> 6));
-		b43_write16(dev, 0x610, beacon_int);
-	}
+	b43_write32(dev, B43_MMIO_TSF_CFP_REP, (beacon_int << 16));
+	b43_write32(dev, B43_MMIO_TSF_CFP_START, (beacon_int << 10));
 	b43_time_unlock(dev);
 	b43dbg(dev->wl, "Set beacon interval to %u\n", beacon_int);
 }
@@ -2495,8 +2468,7 @@ static int b43_gpio_init(struct b43_wldev *dev)
 		mask |= 0x0200;
 		set |= 0x0200;
 	}
-	if (dev->dev->id.revision >= 2)
-		mask |= 0x0010;	/* FIXME: This is redundant. */
+	mask |= 0x0010;	/* FIXME: This is redundant. */
 
 #ifdef CONFIG_SSB_DRIVER_PCICORE
 	pcidev = bus->pcicore.dev;
@@ -2625,12 +2597,6 @@ static void b43_adjust_opmode(struct b43_wldev *dev)
 	if (wl->filter_flags & FIF_BCN_PRBRESP_PROMISC)
 		ctl |= B43_MACCTL_BEACPROMISC;
 
-	/* Workaround: On old hardware the HW-MAC-address-filter
-	 * doesn't work properly, so always run promisc in filter
-	 * it in software. */
-	if (dev->dev->id.revision <= 4)
-		ctl |= B43_MACCTL_PROMISC;
-
 	b43_write32(dev, B43_MMIO_MACCTL, ctl);
 
 	cfp_pretbtt = 2;
@@ -2779,8 +2745,6 @@ static int b43_chip_init(struct b43_wldev *dev)
 		b43_write16(dev, 0x005E, value16);
 	}
 	b43_write32(dev, 0x0100, 0x01000000);
-	if (dev->dev->id.revision < 5)
-		b43_write32(dev, 0x010C, 0x01000000);
 
 	b43_write32(dev, B43_MMIO_MACCTL, b43_read32(dev, B43_MMIO_MACCTL)
 		    & ~B43_MACCTL_INFRA);
@@ -2794,15 +2758,8 @@ static int b43_chip_init(struct b43_wldev *dev)
 	/* Initially set the wireless operation mode. */
 	b43_adjust_opmode(dev);
 
-	if (dev->dev->id.revision < 3) {
-		b43_write16(dev, 0x060E, 0x0000);
-		b43_write16(dev, 0x0610, 0x8000);
-		b43_write16(dev, 0x0604, 0x0000);
-		b43_write16(dev, 0x0606, 0x0200);
-	} else {
-		b43_write32(dev, 0x0188, 0x80000000);
-		b43_write32(dev, 0x018C, 0x02000000);
-	}
+	b43_write32(dev, 0x0188, 0x80000000);
+	b43_write32(dev, 0x018C, 0x02000000);
 	b43_write32(dev, B43_MMIO_GEN_IRQ_REASON, 0x00004000);
 	b43_write32(dev, B43_MMIO_DMA0_IRQ_MASK, 0x0001DC00);
 	b43_write32(dev, B43_MMIO_DMA1_IRQ_MASK, 0x0000DC00);
@@ -2941,7 +2898,7 @@ static int b43_validate_chipaccess(struct b43_wldev *dev)
 
 	b43_shm_write32(dev, B43_SHM_SHARED, 0, backup);
 
-	if ((dev->dev->id.revision >= 3) && (dev->dev->id.revision <= 10)) {
+	if (dev->dev->id.revision <= 10) {
 		/* The 32bit register shadows the two 16bit registers
 		 * with update sideeffects. Validate this. */
 		b43_write16(dev, B43_MMIO_TSF_CFP_START, 0xAAAA);
@@ -2966,17 +2923,15 @@ error:
 
 static void b43_security_init(struct b43_wldev *dev)
 {
-	dev->max_nr_keys = (dev->dev->id.revision >= 5) ? 58 : 20;
+	dev->max_nr_keys = 58;
 	B43_WARN_ON(dev->max_nr_keys > ARRAY_SIZE(dev->key));
 	dev->ktp = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_KTP);
 	/* KTP is a word address, but we address SHM bytewise.
 	 * So multiply by two.
 	 */
 	dev->ktp *= 2;
-	if (dev->dev->id.revision >= 5) {
-		/* Number of RCMTA address slots */
-		b43_write16(dev, B43_MMIO_RCMTA_COUNT, dev->max_nr_keys - 8);
-	}
+	/* Number of RCMTA address slots */
+	b43_write16(dev, B43_MMIO_RCMTA_COUNT, dev->max_nr_keys - 8);
 	b43_clear_keys(dev);
 }
 
@@ -4558,14 +4513,11 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 		goto out;
 	}
 	/* Get the PHY type. */
-	if (dev->dev->id.revision >= 5) {
-		u32 tmshigh;
+	u32 tmshigh;
 
-		tmshigh = ssb_read32(dev->dev, SSB_TMSHIGH);
-		have_2ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY);
-		have_5ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_5GHZ_PHY);
-	} else
-		B43_WARN_ON(1);
+	tmshigh = ssb_read32(dev->dev, SSB_TMSHIGH);
+	have_2ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY);
+	have_5ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_5GHZ_PHY);
 
 	dev->phy.gmode = have_2ghz_phy;
 	tmp = dev->phy.gmode ? B43_TMSLOW_GMODE : 0;
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index e176b6e..8cfc85b 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -168,7 +168,6 @@ void b43_phy_lock(struct b43_wldev *dev)
 	B43_WARN_ON(dev->phy.phy_locked);
 	dev->phy.phy_locked = 1;
 #endif
-	B43_WARN_ON(dev->dev->id.revision < 3);
 
 	if (!b43_is_mode(dev->wl, NL80211_IFTYPE_AP))
 		b43_power_saving_ctl_bits(dev, B43_PS_AWAKE);
@@ -180,7 +179,6 @@ void b43_phy_unlock(struct b43_wldev *dev)
 	B43_WARN_ON(!dev->phy.phy_locked);
 	dev->phy.phy_locked = 0;
 #endif
-	B43_WARN_ON(dev->dev->id.revision < 3);
 
 	if (!b43_is_mode(dev->wl, NL80211_IFTYPE_AP))
 		b43_power_saving_ctl_bits(dev, 0);

--------------030904070008060006080605--
