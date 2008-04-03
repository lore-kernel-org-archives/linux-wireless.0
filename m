Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:60296 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbYDCQ7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 12:59:30 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix TBTT and PU timings
Date: Thu, 3 Apr 2008 18:56:19 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804031856.19812.mb@bu3sch.de> (sfid-20080403_175941_452845_4BA26134)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes some timings for pre-TBTT and synthetic PU.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for 2.6.26
Stefano, you might want to port this.


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-04-03 18:03:54.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-04-03 18:04:20.000000000 +0200
@@ -108,12 +108,13 @@
 #define B43_MMIO_RCMTA_COUNT		0x43C
 #define B43_MMIO_RADIO_HWENABLED_LO	0x49A
 #define B43_MMIO_GPIO_CONTROL		0x49C
 #define B43_MMIO_GPIO_MASK		0x49E
 #define B43_MMIO_TSF_CFP_START_LOW	0x604
 #define B43_MMIO_TSF_CFP_START_HIGH	0x606
+#define B43_MMIO_TSF_CFP_PRETBTT	0x612
 #define B43_MMIO_TSF_0			0x632	/* core rev < 3 only */
 #define B43_MMIO_TSF_1			0x634	/* core rev < 3 only */
 #define B43_MMIO_TSF_2			0x636	/* core rev < 3 only */
 #define B43_MMIO_TSF_3			0x638	/* core rev < 3 only */
 #define B43_MMIO_RNG			0x65A
 #define B43_MMIO_IFSCTL			0x688 /* Interframe space control */
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-04-03 18:03:54.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-03 18:23:20.000000000 +0200
@@ -3687,12 +3687,47 @@ static void b43_set_retry_limits(struct 
 	b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_SRLIMIT,
 			short_retry);
 	b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_LRLIMIT,
 			long_retry);
 }
 
+static void b43_set_synth_pu_delay(struct b43_wldev *dev, bool idle)
+{
+	u16 pu_delay;
+
+	/* The time value is in microseconds. */
+	if (dev->phy.type == B43_PHYTYPE_A)
+		pu_delay = 3700;
+	else
+		pu_delay = 1050;
+	if ((dev->wl->if_type == IEEE80211_IF_TYPE_IBSS) || idle)
+		pu_delay = 500;
+	if ((dev->phy.radio_ver == 0x2050) && (dev->phy.radio_rev == 8))
+		pu_delay = max(pu_delay, (u16)2400);
+
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_SPUWKUP, pu_delay);
+}
+
+/* Set the TSF CFP pre-TargetBeaconTransmissionTime. */
+static void b43_set_pretbtt(struct b43_wldev *dev)
+{
+	u16 pretbtt;
+
+	/* The time value is in microseconds. */
+	if (dev->wl->if_type == IEEE80211_IF_TYPE_IBSS) {
+		pretbtt = 2;
+	} else {
+		if (dev->phy.type == B43_PHYTYPE_A)
+			pretbtt = 120;
+		else
+			pretbtt = 250;
+	}
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_PRETBTT, pretbtt);
+	b43_write16(dev, B43_MMIO_TSF_CFP_PRETBTT, pretbtt);
+}
+
 /* Shutdown a wireless core */
 /* Locking: wl->mutex */
 static void b43_wireless_core_exit(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 	u32 macctl;
@@ -3818,20 +3853,13 @@ static int b43_wireless_core_init(struct
 		dev->__using_pio_transfers = 0;
 		err = b43_dma_init(dev);
 	}
 	if (err)
 		goto err_chip_exit;
 	b43_qos_init(dev);
-
-//FIXME
-#if 1
-	b43_write16(dev, 0x0612, 0x0050);
-	b43_shm_write16(dev, B43_SHM_SHARED, 0x0416, 0x0050);
-	b43_shm_write16(dev, B43_SHM_SHARED, 0x0414, 0x01F4);
-#endif
-
+	b43_set_synth_pu_delay(dev, 1);
 	b43_bluetooth_coext_enable(dev);
 
 	ssb_bus_powerup(bus, 1);	/* Enable dynamic PCTL */
 	b43_upload_card_macaddress(dev);
 	b43_security_init(dev);
 	if (!dev->suspend_in_progress)
@@ -3885,12 +3913,14 @@ static int b43_op_add_interface(struct i
 	wl->vif = conf->vif;
 	wl->if_type = conf->type;
 	memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
 
 	spin_lock_irqsave(&wl->irq_lock, flags);
 	b43_adjust_opmode(dev);
+	b43_set_pretbtt(dev);
+	b43_set_synth_pu_delay(dev, 0);
 	b43_upload_card_macaddress(dev);
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
 	err = 0;
  out_mutex_unlock:
 	mutex_unlock(&wl->mutex);
