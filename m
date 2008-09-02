Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:50790 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYIBLBl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 07:01:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Split PHY alloc and init
Date: Tue, 2 Sep 2008 13:00:34 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200809021300.34760.mb@bu3sch.de> (sfid-20080902_130147_874059_D543F10F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This splits the PHY allocation from the PHY init.
This is needed in order to properly support Analog handling.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Please queue for the next merge window.


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-09-02 02:37:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-09-02 12:13:57.000000000 +0200
@@ -1088,14 +1088,18 @@ void b43_wireless_core_reset(struct b43_
 	msleep(1);
 	tmslow &= ~SSB_TMSLOW_FGC;
 	ssb_write32(dev->dev, SSB_TMSLOW, tmslow);
 	ssb_read32(dev->dev, SSB_TMSLOW);	/* flush */
 	msleep(1);
 
-	/* Turn Analog ON */
-	b43_switch_analog(dev, 1);
+	/* Turn Analog ON, but only if we already know the PHY-type.
+	 * This protects against very early setup where we don't know the
+	 * PHY-type, yet. wireless_core_reset will be called once again later,
+	 * when we know the PHY-type. */
+	if (dev->phy.ops)
+		b43_switch_analog(dev, 1);
 
 	macctl = b43_read32(dev, B43_MMIO_MACCTL);
 	macctl &= ~B43_MACCTL_GMODE;
 	if (flags & B43_TMSLOW_GMODE)
 		macctl |= B43_MACCTL_GMODE;
 	macctl |= B43_MACCTL_IHR_ENABLED;
@@ -2691,12 +2695,13 @@ static void b43_mgmtframe_txantenna(stru
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_PRPHYCTL, tmp);
 }
 
 /* This is the opposite of b43_chip_init() */
 static void b43_chip_exit(struct b43_wldev *dev)
 {
+	b43_phy_exit(dev);
 	b43_gpio_cleanup(dev);
 	/* firmware is released later */
 }
 
 /* Initialize the chip
  * http://bcm-specs.sipsolutions.net/ChipInit
@@ -3949,13 +3954,12 @@ static void b43_wireless_core_exit(struc
 	b43_chip_exit(dev);
 	b43_switch_analog(dev, 0);
 	if (dev->wl->current_beacon) {
 		dev_kfree_skb_any(dev->wl->current_beacon);
 		dev->wl->current_beacon = NULL;
 	}
-	b43_phy_exit(dev);
 
 	ssb_device_disable(dev->dev, 0);
 	ssb_bus_may_powerdown(dev->dev->bus);
 }
 
 /* Initialize a wireless core */
@@ -3976,30 +3980,29 @@ static int b43_wireless_core_init(struct
 		goto out;
 	if (!ssb_device_is_enabled(dev->dev)) {
 		tmp = phy->gmode ? B43_TMSLOW_GMODE : 0;
 		b43_wireless_core_reset(dev, tmp);
 	}
 
+	/* Reset all data structures. */
 	setup_struct_wldev_for_init(dev);
-	err = b43_phy_operations_setup(dev);
-	if (err)
-		goto err_busdown;
+	phy->ops->prepare_structs(dev);
 
 	/* Enable IRQ routing to this device. */
 	ssb_pcicore_dev_irqvecs_enable(&bus->pcicore, dev->dev);
 
 	b43_imcfglo_timeouts_workaround(dev);
 	b43_bluetooth_coext_disable(dev);
-	if (phy->ops->prepare) {
-		err = phy->ops->prepare(dev);
+	if (phy->ops->prepare_hardware) {
+		err = phy->ops->prepare_hardware(dev);
 		if (err)
-			goto err_phy_exit;
+			goto err_busdown;
 	}
 	err = b43_chip_init(dev);
 	if (err)
-		goto err_phy_exit;
+		goto err_busdown;
 	b43_shm_write16(dev, B43_SHM_SHARED,
 			B43_SHM_SH_WLCOREREV, dev->dev->id.revision);
 	hf = b43_hf_read(dev);
 	if (phy->type == B43_PHYTYPE_G) {
 		hf |= B43_HF_SYMW;
 		if (phy->rev == 1)
@@ -4061,14 +4064,12 @@ static int b43_wireless_core_init(struct
 		b43_leds_init(dev);
 out:
 	return err;
 
 err_chip_exit:
 	b43_chip_exit(dev);
-err_phy_exit:
-	b43_phy_exit(dev);
 err_busdown:
 	ssb_bus_may_powerdown(bus);
 	B43_WARN_ON(b43_status(dev) != B43_STAT_UNINIT);
 	return err;
 }
 
@@ -4339,12 +4340,13 @@ static int b43_setup_bands(struct b43_wl
 
 static void b43_wireless_core_detach(struct b43_wldev *dev)
 {
 	/* We release firmware that late to not be required to re-request
 	 * is all the time when we reinit the core. */
 	b43_release_firmware(dev);
+	b43_phy_free(dev);
 }
 
 static int b43_wireless_core_attach(struct b43_wldev *dev)
 {
 	struct b43_wl *wl = dev->wl;
 	struct ssb_bus *bus = dev->dev->bus;
@@ -4412,22 +4414,26 @@ static int b43_wireless_core_attach(stru
 		if (dev->phy.type != B43_PHYTYPE_N) {
 			have_2ghz_phy = 1;
 			have_5ghz_phy = 0;
 		}
 	}
 
+	err = b43_phy_allocate(dev);
+	if (err)
+		goto err_powerdown;
+
 	dev->phy.gmode = have_2ghz_phy;
 	tmp = dev->phy.gmode ? B43_TMSLOW_GMODE : 0;
 	b43_wireless_core_reset(dev, tmp);
 
 	err = b43_validate_chipaccess(dev);
 	if (err)
-		goto err_powerdown;
+		goto err_phy_free;
 	err = b43_setup_bands(dev, have_2ghz_phy, have_5ghz_phy);
 	if (err)
-		goto err_powerdown;
+		goto err_phy_free;
 
 	/* Now set some default "current_dev" */
 	if (!wl->current_dev)
 		wl->current_dev = dev;
 	INIT_WORK(&dev->restart_work, b43_chip_reset);
 
@@ -4435,12 +4441,14 @@ static int b43_wireless_core_attach(stru
 	ssb_device_disable(dev->dev, 0);
 	ssb_bus_may_powerdown(bus);
 
 out:
 	return err;
 
+err_phy_free:
+	b43_phy_free(dev);
 err_powerdown:
 	ssb_bus_may_powerdown(bus);
 	return err;
 }
 
 static void b43_one_core_detach(struct ssb_device *dev)
Index: wireless-testing/drivers/net/wireless/b43/phy_a.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_a.c	2008-09-02 02:37:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_a.c	2008-09-02 12:39:53.000000000 +0200
@@ -388,14 +388,12 @@ static int b43_aphy_op_allocate(struct b
 
 	aphy = kzalloc(sizeof(*aphy), GFP_KERNEL);
 	if (!aphy)
 		return -ENOMEM;
 	dev->phy.a = aphy;
 
-	//TODO init struct b43_phy_a
-
 	err = b43_aphy_init_tssi2dbm_table(dev);
 	if (err)
 		goto err_free_aphy;
 
 	return 0;
 
@@ -403,36 +401,53 @@ err_free_aphy:
 	kfree(aphy);
 	dev->phy.a = NULL;
 
 	return err;
 }
 
-static int b43_aphy_op_init(struct b43_wldev *dev)
+static void b43_aphy_op_prepare_structs(struct b43_wldev *dev)
 {
-	struct b43_phy_a *aphy = dev->phy.a;
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_a *aphy = phy->a;
+	const void *tssi2dbm;
+	int tgt_idle_tssi;
+
+	/* tssi2dbm table is constant, so it is initialized at alloc time.
+	 * Save a copy of the pointer. */
+	tssi2dbm = aphy->tssi2dbm;
+	tgt_idle_tssi = aphy->tgt_idle_tssi;
 
-	b43_phy_inita(dev);
-	aphy->initialised = 1;
+	/* Zero out the whole PHY structure. */
+	memset(aphy, 0, sizeof(*aphy));
+
+	aphy->tssi2dbm = tssi2dbm;
+	aphy->tgt_idle_tssi = tgt_idle_tssi;
+
+	//TODO init struct b43_phy_a
 
-	return 0;
 }
 
-static void b43_aphy_op_exit(struct b43_wldev *dev)
+static void b43_aphy_op_free(struct b43_wldev *dev)
 {
-	struct b43_phy_a *aphy = dev->phy.a;
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_a *aphy = phy->a;
 
-	if (aphy->initialised) {
-		//TODO
-		aphy->initialised = 0;
-	}
-	//TODO
 	kfree(aphy->tssi2dbm);
+	aphy->tssi2dbm = NULL;
+
 	kfree(aphy);
 	dev->phy.a = NULL;
 }
 
+static int b43_aphy_op_init(struct b43_wldev *dev)
+{
+	b43_phy_inita(dev);
+
+	return 0;
+}
+
 static inline u16 adjust_phyreg(struct b43_wldev *dev, u16 offset)
 {
 	/* OFDM registers are base-registers for the A-PHY. */
 	if ((offset & B43_PHYROUTE) == B43_PHYROUTE_OFDM_GPHY) {
 		offset &= ~B43_PHYROUTE;
 		offset |= B43_PHYROUTE_BASE;
@@ -605,14 +620,15 @@ static void b43_aphy_op_pwork_15sec(stru
 static void b43_aphy_op_pwork_60sec(struct b43_wldev *dev)
 {//TODO
 }
 
 const struct b43_phy_operations b43_phyops_a = {
 	.allocate		= b43_aphy_op_allocate,
+	.free			= b43_aphy_op_free,
+	.prepare_structs	= b43_aphy_op_prepare_structs,
 	.init			= b43_aphy_op_init,
-	.exit			= b43_aphy_op_exit,
 	.phy_read		= b43_aphy_op_read,
 	.phy_write		= b43_aphy_op_write,
 	.radio_read		= b43_aphy_op_radio_read,
 	.radio_write		= b43_aphy_op_radio_write,
 	.supports_hwpctl	= b43_aphy_op_supports_hwpctl,
 	.software_rfkill	= b43_aphy_op_software_rfkill,
Index: wireless-testing/drivers/net/wireless/b43/phy_a.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_a.h	2008-09-02 02:37:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_a.h	2008-09-02 02:37:28.000000000 +0200
@@ -100,14 +100,12 @@ void b43_ofdmtab_write16(struct b43_wlde
 u32 b43_ofdmtab_read32(struct b43_wldev *dev, u16 table, u16 offset);
 void b43_ofdmtab_write32(struct b43_wldev *dev, u16 table,
 			 u16 offset, u32 value);
 
 
 struct b43_phy_a {
-	bool initialised;
-
 	/* Pointer to the table used to convert a
 	 * TSSI value to dBm-Q5.2 */
 	const s8 *tssi2dbm;
 	/* Target idle TSSI */
 	int tgt_idle_tssi;
 	/* Current idle TSSI */
Index: wireless-testing/drivers/net/wireless/b43/phy_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.c	2008-09-02 02:37:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_common.c	2008-09-02 02:37:28.000000000 +0200
@@ -32,13 +32,13 @@
 #include "phy_n.h"
 #include "phy_lp.h"
 #include "b43.h"
 #include "main.h"
 
 
-int b43_phy_operations_setup(struct b43_wldev *dev)
+int b43_phy_allocate(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &(dev->phy);
 	int err;
 
 	phy->ops = NULL;
 
@@ -67,12 +67,18 @@ int b43_phy_operations_setup(struct b43_
 	if (err)
 		phy->ops = NULL;
 
 	return err;
 }
 
+void b43_phy_free(struct b43_wldev *dev)
+{
+	dev->phy.ops->free(dev);
+	dev->phy.ops = NULL;
+}
+
 int b43_phy_init(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 	const struct b43_phy_operations *ops = phy->ops;
 	int err;
 
Index: wireless-testing/drivers/net/wireless/b43/phy_common.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.h	2008-09-02 02:37:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_common.h	2008-09-02 02:37:28.000000000 +0200
@@ -71,17 +71,27 @@ enum b43_txpwr_result {
 	B43_TXPWR_RES_DONE,
 };
 
 /**
  * struct b43_phy_operations - Function pointers for PHY ops.
  *
- * @prepare:		Prepare the PHY. This is called before @init.
+ * @allocate:		Allocate and initialise the PHY data structures.
+ * 			Must not be NULL.
+ * @free:		Destroy and free the PHY data structures.
+ * 			Must not be NULL.
+ *
+ * @prepare_structs:	Prepare the PHY data structures.
+ * 			The data structures allocated in @allocate are
+ * 			initialized here.
+ * 			Must not be NULL.
+ * @prepare_hardware:	Prepare the PHY. This is called before b43_chip_init to
+ * 			do some early early PHY hardware init.
  * 			Can be NULL, if not required.
  * @init:		Initialize the PHY.
  * 			Must not be NULL.
- * @exit:		Shutdown the PHY and free all data structures.
+ * @exit:		Shutdown the PHY.
  * 			Can be NULL, if not required.
  *
  * @phy_read:		Read from a PHY register.
  * 			Must not be NULL.
  * @phy_write:		Write to a PHY register.
  * 			Must not be NULL.
@@ -130,13 +140,15 @@ enum b43_txpwr_result {
  * @pwork_60sec:	Periodic work. Called every 60 seconds.
  * 			Can be NULL, if not required.
  */
 struct b43_phy_operations {
 	/* Initialisation */
 	int (*allocate)(struct b43_wldev *dev);
-	int (*prepare)(struct b43_wldev *dev);
+	void (*free)(struct b43_wldev *dev);
+	void (*prepare_structs)(struct b43_wldev *dev);
+	int (*prepare_hardware)(struct b43_wldev *dev);
 	int (*init)(struct b43_wldev *dev);
 	void (*exit)(struct b43_wldev *dev);
 
 	/* Register access */
 	u16 (*phy_read)(struct b43_wldev *dev, u16 reg);
 	void (*phy_write)(struct b43_wldev *dev, u16 reg, u16 value);
@@ -234,16 +246,21 @@ struct b43_phy {
 	bool phy_locked;
 #endif /* B43_DEBUG */
 };
 
 
 /**
- * b43_phy_operations_setup - Initialize the PHY operations datastructure
- * based on the current PHY type.
+ * b43_phy_allocate - Allocate PHY structs
+ * Allocate the PHY data structures, based on the current dev->phy.type
+ */
+int b43_phy_allocate(struct b43_wldev *dev);
+
+/**
+ * b43_phy_free - Free PHY structs
  */
-int b43_phy_operations_setup(struct b43_wldev *dev);
+void b43_phy_free(struct b43_wldev *dev);
 
 /**
  * b43_phy_init - Initialise the PHY
  */
 int b43_phy_init(struct b43_wldev *dev);
 
Index: wireless-testing/drivers/net/wireless/b43/phy_g.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_g.c	2008-09-02 02:37:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_g.c	2008-09-02 12:40:51.000000000 +0200
@@ -2632,21 +2632,66 @@ static int b43_gphy_init_tssi2dbm_table(
 }
 
 static int b43_gphy_op_allocate(struct b43_wldev *dev)
 {
 	struct b43_phy_g *gphy;
 	struct b43_txpower_lo_control *lo;
-	int err, i;
+	int err;
 
 	gphy = kzalloc(sizeof(*gphy), GFP_KERNEL);
 	if (!gphy) {
 		err = -ENOMEM;
 		goto error;
 	}
 	dev->phy.g = gphy;
 
+	lo = kzalloc(sizeof(*lo), GFP_KERNEL);
+	if (!lo) {
+		err = -ENOMEM;
+		goto err_free_gphy;
+	}
+	gphy->lo_control = lo;
+
+	err = b43_gphy_init_tssi2dbm_table(dev);
+	if (err)
+		goto err_free_lo;
+
+	return 0;
+
+err_free_lo:
+	kfree(lo);
+err_free_gphy:
+	kfree(gphy);
+error:
+	return err;
+}
+
+static void b43_gphy_op_prepare_structs(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_g *gphy = phy->g;
+	const void *tssi2dbm;
+	int tgt_idle_tssi;
+	struct b43_txpower_lo_control *lo;
+	unsigned int i;
+
+	/* tssi2dbm table is constant, so it is initialized at alloc time.
+	 * Save a copy of the pointer. */
+	tssi2dbm = gphy->tssi2dbm;
+	tgt_idle_tssi = gphy->tgt_idle_tssi;
+	/* Save the LO pointer. */
+	lo = gphy->lo_control;
+
+	/* Zero out the whole PHY structure. */
+	memset(gphy, 0, sizeof(*gphy));
+
+	/* Restore pointers. */
+	gphy->tssi2dbm = tssi2dbm;
+	gphy->tgt_idle_tssi = tgt_idle_tssi;
+	gphy->lo_control = lo;
+
 	memset(gphy->minlowsig, 0xFF, sizeof(gphy->minlowsig));
 
 	/* NRSSI */
 	for (i = 0; i < ARRAY_SIZE(gphy->nrssi); i++)
 		gphy->nrssi[i] = -1000;
 	for (i = 0; i < ARRAY_SIZE(gphy->nrssi_lt); i++)
@@ -2659,37 +2704,34 @@ static int b43_gphy_op_allocate(struct b
 
 	/* OFDM-table address caching. */
 	gphy->ofdmtab_addr_direction = B43_OFDMTAB_DIRECTION_UNKNOWN;
 
 	gphy->average_tssi = 0xFF;
 
-	lo = kzalloc(sizeof(*lo), GFP_KERNEL);
-	if (!lo) {
-		err = -ENOMEM;
-		goto err_free_gphy;
-	}
-	gphy->lo_control = lo;
-
+	/* Local Osciallator structure */
 	lo->tx_bias = 0xFF;
 	INIT_LIST_HEAD(&lo->calib_list);
+}
 
-	err = b43_gphy_init_tssi2dbm_table(dev);
-	if (err)
-		goto err_free_lo;
+static void b43_gphy_op_free(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_g *gphy = phy->g;
 
-	return 0;
+	kfree(gphy->lo_control);
+
+	if (gphy->dyn_tssi_tbl)
+		kfree(gphy->tssi2dbm);
+	gphy->dyn_tssi_tbl = 0;
+	gphy->tssi2dbm = NULL;
 
-err_free_lo:
-	kfree(lo);
-err_free_gphy:
 	kfree(gphy);
-error:
-	return err;
+	dev->phy.g = NULL;
 }
 
-static int b43_gphy_op_prepare(struct b43_wldev *dev)
+static int b43_gphy_op_prepare_hardware(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
 	struct b43_txpower_lo_control *lo = gphy->lo_control;
 
 	B43_WARN_ON(phy->type != B43_PHYTYPE_G);
@@ -2715,34 +2757,20 @@ static int b43_gphy_op_prepare(struct b4
 
 	return 0;
 }
 
 static int b43_gphy_op_init(struct b43_wldev *dev)
 {
-	struct b43_phy_g *gphy = dev->phy.g;
-
 	b43_phy_initg(dev);
-	gphy->initialised = 1;
 
 	return 0;
 }
 
 static void b43_gphy_op_exit(struct b43_wldev *dev)
 {
-	struct b43_phy_g *gphy = dev->phy.g;
-
-	if (gphy->initialised) {
-		//TODO
-		gphy->initialised = 0;
-	}
 	b43_lo_g_cleanup(dev);
-	kfree(gphy->lo_control);
-	if (gphy->dyn_tssi_tbl)
-		kfree(gphy->tssi2dbm);
-	kfree(gphy);
-	dev->phy.g = NULL;
 }
 
 static u16 b43_gphy_op_read(struct b43_wldev *dev, u16 reg)
 {
 	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
 	return b43_read16(dev, B43_MMIO_PHY_DATA);
@@ -3229,13 +3257,15 @@ static void b43_gphy_op_pwork_60sec(stru
 	}
 	b43_mac_enable(dev);
 }
 
 const struct b43_phy_operations b43_phyops_g = {
 	.allocate		= b43_gphy_op_allocate,
-	.prepare		= b43_gphy_op_prepare,
+	.free			= b43_gphy_op_free,
+	.prepare_structs	= b43_gphy_op_prepare_structs,
+	.prepare_hardware	= b43_gphy_op_prepare_hardware,
 	.init			= b43_gphy_op_init,
 	.exit			= b43_gphy_op_exit,
 	.phy_read		= b43_gphy_op_read,
 	.phy_write		= b43_gphy_op_write,
 	.radio_read		= b43_gphy_op_radio_read,
 	.radio_write		= b43_gphy_op_radio_write,
Index: wireless-testing/drivers/net/wireless/b43/phy_g.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_g.h	2008-09-02 02:37:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_g.h	2008-09-02 02:37:28.000000000 +0200
@@ -111,14 +111,12 @@ static inline bool b43_compare_bbatt(con
 #define B43_TXCTL_PA2DB		0x20	/* PA Gain 2dB */
 #define B43_TXCTL_TXMIX		0x10	/* TX Mixer Gain */
 
 struct b43_txpower_lo_control;
 
 struct b43_phy_g {
-	bool initialised;
-
 	/* ACI (adjacent channel interference) flags. */
 	bool aci_enable;
 	bool aci_wlan_automatic;
 	bool aci_hw_rssi;
 
 	/* Radio switched on/off */
Index: wireless-testing/drivers/net/wireless/b43/phy_lp.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_lp.c	2008-09-02 02:37:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_lp.c	2008-09-02 02:37:28.000000000 +0200
@@ -33,40 +33,40 @@ static int b43_lpphy_op_allocate(struct 
 
 	lpphy = kzalloc(sizeof(*lpphy), GFP_KERNEL);
 	if (!lpphy)
 		return -ENOMEM;
 	dev->phy.lp = lpphy;
 
-	//TODO
-
 	return 0;
 }
 
-static int b43_lpphy_op_init(struct b43_wldev *dev)
+static void b43_lpphy_op_prepare_structs(struct b43_wldev *dev)
 {
-	struct b43_phy_lp *lpphy = dev->phy.lp;
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_lp *lpphy = phy->lp;
 
-	//TODO
-	lpphy->initialised = 1;
+	memset(lpphy, 0, sizeof(*lpphy));
 
-	return 0;
+	//TODO
 }
 
-static void b43_lpphy_op_exit(struct b43_wldev *dev)
+static void b43_lpphy_op_free(struct b43_wldev *dev)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
 
-	if (lpphy->initialised) {
-		//TODO
-		lpphy->initialised = 0;
-	}
-
 	kfree(lpphy);
 	dev->phy.lp = NULL;
 }
 
+static int b43_lpphy_op_init(struct b43_wldev *dev)
+{
+	//TODO
+
+	return 0;
+}
+
 static u16 b43_lpphy_op_read(struct b43_wldev *dev, u16 reg)
 {
 	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
 	return b43_read16(dev, B43_MMIO_PHY_DATA);
 }
 
@@ -135,14 +135,15 @@ static enum b43_txpwr_result b43_lpphy_o
 	return B43_TXPWR_RES_DONE;
 }
 
 
 const struct b43_phy_operations b43_phyops_lp = {
 	.allocate		= b43_lpphy_op_allocate,
+	.free			= b43_lpphy_op_free,
+	.prepare_structs	= b43_lpphy_op_prepare_structs,
 	.init			= b43_lpphy_op_init,
-	.exit			= b43_lpphy_op_exit,
 	.phy_read		= b43_lpphy_op_read,
 	.phy_write		= b43_lpphy_op_write,
 	.radio_read		= b43_lpphy_op_radio_read,
 	.radio_write		= b43_lpphy_op_radio_write,
 	.software_rfkill	= b43_lpphy_op_software_rfkill,
 	.switch_channel		= b43_lpphy_op_switch_channel,
Index: wireless-testing/drivers/net/wireless/b43/phy_lp.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_lp.h	2008-09-02 02:37:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_lp.h	2008-09-02 02:37:28.000000000 +0200
@@ -527,13 +527,13 @@
 #define B2063_EXT_TSSI_CTL2			B43_LP_RADIO(0x127) /* EXT TSSI Control 2 */
 #define B2063_AFE_CTL				B43_LP_RADIO(0x128) /* AFE Control */
 
 
 
 struct b43_phy_lp {
-	bool initialised;
+	//TODO
 };
 
 
 struct b43_phy_operations;
 extern const struct b43_phy_operations b43_phyops_lp;
 
Index: wireless-testing/drivers/net/wireless/b43/phy_n.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_n.c	2008-09-02 02:37:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_n.c	2008-09-02 02:37:28.000000000 +0200
@@ -496,41 +496,37 @@ static int b43_nphy_op_allocate(struct b
 
 	nphy = kzalloc(sizeof(*nphy), GFP_KERNEL);
 	if (!nphy)
 		return -ENOMEM;
 	dev->phy.n = nphy;
 
-	//TODO init struct b43_phy_n
-
 	return 0;
 }
 
-static int b43_nphy_op_init(struct b43_wldev *dev)
+static void b43_nphy_op_prepare_structs(struct b43_wldev *dev)
 {
-	struct b43_phy_n *nphy = dev->phy.n;
-	int err;
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = phy->n;
 
-	err = b43_phy_initn(dev);
-	if (err)
-		return err;
-	nphy->initialised = 1;
+	memset(nphy, 0, sizeof(*nphy));
 
-	return 0;
+	//TODO init struct b43_phy_n
 }
 
-static void b43_nphy_op_exit(struct b43_wldev *dev)
+static void b43_nphy_op_free(struct b43_wldev *dev)
 {
-	struct b43_phy_n *nphy = dev->phy.n;
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = phy->n;
 
-	if (nphy->initialised) {
-		//TODO
-		nphy->initialised = 0;
-	}
-	//TODO
 	kfree(nphy);
-	dev->phy.n = NULL;
+	phy->n = NULL;
+}
+
+static int b43_nphy_op_init(struct b43_wldev *dev)
+{
+	return b43_phy_initn(dev);
 }
 
 static inline void check_phyreg(struct b43_wldev *dev, u16 offset)
 {
 #if B43_DEBUG
 	if ((offset & B43_PHYROUTE) == B43_PHYROUTE_OFDM_GPHY) {
@@ -607,14 +603,15 @@ static unsigned int b43_nphy_op_get_defa
 		return 1;
 	return 36;
 }
 
 const struct b43_phy_operations b43_phyops_n = {
 	.allocate		= b43_nphy_op_allocate,
+	.free			= b43_nphy_op_free,
+	.prepare_structs	= b43_nphy_op_prepare_structs,
 	.init			= b43_nphy_op_init,
-	.exit			= b43_nphy_op_exit,
 	.phy_read		= b43_nphy_op_read,
 	.phy_write		= b43_nphy_op_write,
 	.radio_read		= b43_nphy_op_radio_read,
 	.radio_write		= b43_nphy_op_radio_write,
 	.software_rfkill	= b43_nphy_op_software_rfkill,
 	.switch_channel		= b43_nphy_op_switch_channel,
Index: wireless-testing/drivers/net/wireless/b43/phy_n.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_n.h	2008-09-02 02:37:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_n.h	2008-09-02 02:37:28.000000000 +0200
@@ -917,14 +917,12 @@
 
 
 
 struct b43_wldev;
 
 struct b43_phy_n {
-	bool initialised;
-
 	//TODO lots of missing stuff
 };
 
 
 struct b43_phy_operations;
 extern const struct b43_phy_operations b43_phyops_n;
