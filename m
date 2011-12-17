Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44537 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab1LQM4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 07:56:40 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so4011144eek.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2011 04:56:39 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 8/8] b43: N-PHY: reorder functions: random clenaups
Date: Sat, 17 Dec 2011 13:57:27 +0100
Message-Id: <1324126647-22425-9-git-send-email-zajec5@gmail.com> (sfid-20111217_135649_684769_CD593299)
In-Reply-To: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
References: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  223 ++++++++++++++++++++------------------
 1 files changed, 116 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 17440a9..e89b04b 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1929,7 +1929,7 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 }
 
 /**************************************************
- * Others
+ * Tx and Rx
  **************************************************/
 
 void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
@@ -1946,17 +1946,6 @@ static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
 	return B43_TXPWR_RES_DONE;
 }
 
-static void b43_chantab_phy_upload(struct b43_wldev *dev,
-				   const struct b43_phy_n_sfo_cfg *e)
-{
-	b43_phy_write(dev, B43_NPHY_BW1A, e->phy_bw1a);
-	b43_phy_write(dev, B43_NPHY_BW2, e->phy_bw2);
-	b43_phy_write(dev, B43_NPHY_BW3, e->phy_bw3);
-	b43_phy_write(dev, B43_NPHY_BW4, e->phy_bw4);
-	b43_phy_write(dev, B43_NPHY_BW5, e->phy_bw5);
-	b43_phy_write(dev, B43_NPHY_BW6, e->phy_bw6);
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlEnable */
 static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 {
@@ -2249,18 +2238,6 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
 	}
 }
 
-/*
- * Upload the N-PHY tables.
- * http://bcm-v4.sipsolutions.net/802.11/PHY/N/InitTables
- */
-static void b43_nphy_tables_init(struct b43_wldev *dev)
-{
-	if (dev->phy.rev < 3)
-		b43_nphy_rev0_1_2_tables_init(dev);
-	else
-		b43_nphy_rev3plus_tables_init(dev);
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/PA%20override */
 static void b43_nphy_pa_override(struct b43_wldev *dev, bool enable)
 {
@@ -2313,20 +2290,6 @@ static void b43_nphy_tx_lp_fbw(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/MIMOConfig */
-static void b43_nphy_update_mimo_config(struct b43_wldev *dev, s32 preamble)
-{
-	u16 mimocfg = b43_phy_read(dev, B43_NPHY_MIMOCFG);
-
-	mimocfg |= B43_NPHY_MIMOCFG_AUTO;
-	if (preamble == 1)
-		mimocfg |= B43_NPHY_MIMOCFG_GFMIX;
-	else
-		mimocfg &= ~B43_NPHY_MIMOCFG_GFMIX;
-
-	b43_phy_write(dev, B43_NPHY_MIMOCFG, mimocfg);
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/Chains */
 static void b43_nphy_update_txrx_chain(struct b43_wldev *dev)
 {
@@ -2606,54 +2569,6 @@ static void b43_nphy_tx_iq_workaround(struct b43_wldev *dev)
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_NPHY_TXIQW3, array[3]);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SuperSwitchInit */
-static void b43_nphy_superswitch_init(struct b43_wldev *dev, bool init)
-{
-	if (dev->phy.rev >= 3) {
-		if (!init)
-			return;
-		if (0 /* FIXME */) {
-			b43_ntab_write(dev, B43_NTAB16(9, 2), 0x211);
-			b43_ntab_write(dev, B43_NTAB16(9, 3), 0x222);
-			b43_ntab_write(dev, B43_NTAB16(9, 8), 0x144);
-			b43_ntab_write(dev, B43_NTAB16(9, 12), 0x188);
-		}
-	} else {
-		b43_phy_write(dev, B43_NPHY_GPIO_LOOEN, 0);
-		b43_phy_write(dev, B43_NPHY_GPIO_HIOEN, 0);
-
-		switch (dev->dev->bus_type) {
-#ifdef CONFIG_B43_BCMA
-		case B43_BUS_BCMA:
-			bcma_chipco_gpio_control(&dev->dev->bdev->bus->drv_cc,
-						 0xFC00, 0xFC00);
-			break;
-#endif
-#ifdef CONFIG_B43_SSB
-		case B43_BUS_SSB:
-			ssb_chipco_gpio_control(&dev->dev->sdev->bus->chipco,
-						0xFC00, 0xFC00);
-			break;
-#endif
-		}
-
-		b43_write32(dev, B43_MMIO_MACCTL,
-			b43_read32(dev, B43_MMIO_MACCTL) &
-			~B43_MACCTL_GPOUTSMSK);
-		b43_write16(dev, B43_MMIO_GPIO_MASK,
-			b43_read16(dev, B43_MMIO_GPIO_MASK) | 0xFC00);
-		b43_write16(dev, B43_MMIO_GPIO_CONTROL,
-			b43_read16(dev, B43_MMIO_GPIO_CONTROL) & ~0xFC00);
-
-		if (init) {
-			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO1, 0x2D8);
-			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP1, 0x301);
-			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO2, 0x2D8);
-			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2, 0x301);
-		}
-	}
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/stop-playback */
 static void b43_nphy_stop_playback(struct b43_wldev *dev)
 {
@@ -2820,25 +2735,6 @@ static void b43_nphy_tx_pwr_ctrl_coef_setup(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, false);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/BPHYInit */
-static void b43_nphy_bphy_init(struct b43_wldev *dev)
-{
-	unsigned int i;
-	u16 val;
-
-	val = 0x1E1F;
-	for (i = 0; i < 16; i++) {
-		b43_phy_write(dev, B43_PHY_N_BMODE(0x88 + i), val);
-		val -= 0x202;
-	}
-	val = 0x3E3F;
-	for (i = 0; i < 16; i++) {
-		b43_phy_write(dev, B43_PHY_N_BMODE(0x98 + i), val);
-		val -= 0x202;
-	}
-	b43_phy_write(dev, B43_PHY_N_BMODE(0x38), 0x668);
-}
-
 /*
  * Restore RSSI Calibration
  * http://bcm-v4.sipsolutions.net/802.11/PHY/N/RestoreRssiCal
@@ -3865,10 +3761,104 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
 	b43_mac_enable(dev);
 }
 
+/**************************************************
+ * N-PHY init
+ **************************************************/
+
 /*
- * Init N-PHY
- * http://bcm-v4.sipsolutions.net/802.11/PHY/Init/N
+ * Upload the N-PHY tables.
+ * http://bcm-v4.sipsolutions.net/802.11/PHY/N/InitTables
  */
+static void b43_nphy_tables_init(struct b43_wldev *dev)
+{
+	if (dev->phy.rev < 3)
+		b43_nphy_rev0_1_2_tables_init(dev);
+	else
+		b43_nphy_rev3plus_tables_init(dev);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/MIMOConfig */
+static void b43_nphy_update_mimo_config(struct b43_wldev *dev, s32 preamble)
+{
+	u16 mimocfg = b43_phy_read(dev, B43_NPHY_MIMOCFG);
+
+	mimocfg |= B43_NPHY_MIMOCFG_AUTO;
+	if (preamble == 1)
+		mimocfg |= B43_NPHY_MIMOCFG_GFMIX;
+	else
+		mimocfg &= ~B43_NPHY_MIMOCFG_GFMIX;
+
+	b43_phy_write(dev, B43_NPHY_MIMOCFG, mimocfg);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/BPHYInit */
+static void b43_nphy_bphy_init(struct b43_wldev *dev)
+{
+	unsigned int i;
+	u16 val;
+
+	val = 0x1E1F;
+	for (i = 0; i < 16; i++) {
+		b43_phy_write(dev, B43_PHY_N_BMODE(0x88 + i), val);
+		val -= 0x202;
+	}
+	val = 0x3E3F;
+	for (i = 0; i < 16; i++) {
+		b43_phy_write(dev, B43_PHY_N_BMODE(0x98 + i), val);
+		val -= 0x202;
+	}
+	b43_phy_write(dev, B43_PHY_N_BMODE(0x38), 0x668);
+}
+
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
+		switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+		case B43_BUS_BCMA:
+			bcma_chipco_gpio_control(&dev->dev->bdev->bus->drv_cc,
+						 0xFC00, 0xFC00);
+			break;
+#endif
+#ifdef CONFIG_B43_SSB
+		case B43_BUS_SSB:
+			ssb_chipco_gpio_control(&dev->dev->sdev->bus->chipco,
+						0xFC00, 0xFC00);
+			break;
+#endif
+		}
+
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
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/Init/N */
 int b43_phy_initn(struct b43_wldev *dev)
 {
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
@@ -4063,6 +4053,21 @@ int b43_phy_initn(struct b43_wldev *dev)
 	return 0;
 }
 
+/**************************************************
+ * Channel switching ops.
+ **************************************************/
+
+static void b43_chantab_phy_upload(struct b43_wldev *dev,
+				   const struct b43_phy_n_sfo_cfg *e)
+{
+	b43_phy_write(dev, B43_NPHY_BW1A, e->phy_bw1a);
+	b43_phy_write(dev, B43_NPHY_BW2, e->phy_bw2);
+	b43_phy_write(dev, B43_NPHY_BW3, e->phy_bw3);
+	b43_phy_write(dev, B43_NPHY_BW4, e->phy_bw4);
+	b43_phy_write(dev, B43_NPHY_BW5, e->phy_bw5);
+	b43_phy_write(dev, B43_NPHY_BW6, e->phy_bw6);
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PmuSpurAvoid */
 static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
 {
@@ -4278,6 +4283,10 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 	return 0;
 }
 
+/**************************************************
+ * Basic PHY ops.
+ **************************************************/
+
 static int b43_nphy_op_allocate(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy;
-- 
1.7.7

