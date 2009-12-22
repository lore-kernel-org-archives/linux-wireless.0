Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:61812 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755384AbZLVXDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 18:03:51 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 5/5] rt2x00: Cleanup chip handling helper functions.
Date: Wed, 23 Dec 2009 00:03:25 +0100
Message-Id: <1261523005-5856-6-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1261523005-5856-5-git-send-email-gwingerde@gmail.com>
References: <1261523005-5856-1-git-send-email-gwingerde@gmail.com>
 <1261523005-5856-2-git-send-email-gwingerde@gmail.com>
 <1261523005-5856-3-git-send-email-gwingerde@gmail.com>
 <1261523005-5856-4-git-send-email-gwingerde@gmail.com>
 <1261523005-5856-5-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let each of them take a struct rt2x00_dev pointer as argument instead of
a mixture of struct rt2x00_chip and struct rt2x00_dev pointers.
Preparation for further clean ups in the rt2x00 chip handling, especially
for rt2800 devices.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    5 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |   39 +++++++-------
 drivers/net/wireless/rt2x00/rt2500usb.c |   38 ++++++-------
 drivers/net/wireless/rt2x00/rt2800lib.c |   90 +++++++++++++++----------------
 drivers/net/wireless/rt2x00/rt2800pci.c |    3 +-
 drivers/net/wireless/rt2x00/rt2800usb.c |    4 +-
 drivers/net/wireless/rt2x00/rt2x00.h    |   24 ++++----
 drivers/net/wireless/rt2x00/rt61pci.c   |   29 ++++------
 drivers/net/wireless/rt2x00/rt73usb.c   |   36 ++++++-------
 9 files changed, 125 insertions(+), 143 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index e7f4640..d86d233 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -451,7 +451,7 @@ static void rt2400pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * RF2420 chipset don't need any additional actions.
 	 */
-	if (rt2x00_rf(&rt2x00dev->chip, RF2420))
+	if (rt2x00_rf(rt2x00dev, RF2420))
 		return;
 
 	/*
@@ -1343,8 +1343,7 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_chip_rf(rt2x00dev, value, reg);
 	rt2x00_print_chip(rt2x00dev);
 
-	if (!rt2x00_rf(&rt2x00dev->chip, RF2420) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2421)) {
+	if (!rt2x00_rf(rt2x00dev, RF2420) && !rt2x00_rf(rt2x00dev, RF2421)) {
 		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
 		return -ENODEV;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 408fcfc..46cbc6e 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -440,8 +440,7 @@ static void rt2500pci_config_ant(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * RT2525E and RT5222 need to flip TX I/Q
 	 */
-	if (rt2x00_rf(&rt2x00dev->chip, RF2525E) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+	if (rt2x00_rf(rt2x00dev, RF2525E) || rt2x00_rf(rt2x00dev, RF5222)) {
 		rt2x00_set_field8(&r2, BBP_R2_TX_IQ_FLIP, 1);
 		rt2x00_set_field32(&reg, BBPCSR1_CCK_FLIP, 1);
 		rt2x00_set_field32(&reg, BBPCSR1_OFDM_FLIP, 1);
@@ -449,7 +448,7 @@ static void rt2500pci_config_ant(struct rt2x00_dev *rt2x00dev,
 		/*
 		 * RT2525E does not need RX I/Q Flip.
 		 */
-		if (rt2x00_rf(&rt2x00dev->chip, RF2525E))
+		if (rt2x00_rf(rt2x00dev, RF2525E))
 			rt2x00_set_field8(&r14, BBP_R14_RX_IQ_FLIP, 0);
 	} else {
 		rt2x00_set_field32(&reg, BBPCSR1_CCK_FLIP, 0);
@@ -475,14 +474,14 @@ static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	 * Switch on tuning bits.
 	 * For RT2523 devices we do not need to update the R1 register.
 	 */
-	if (!rt2x00_rf(&rt2x00dev->chip, RF2523))
+	if (!rt2x00_rf(rt2x00dev, RF2523))
 		rt2x00_set_field32(&rf->rf1, RF1_TUNER, 1);
 	rt2x00_set_field32(&rf->rf3, RF3_TUNER, 1);
 
 	/*
 	 * For RT2525 we should first set the channel to half band higher.
 	 */
-	if (rt2x00_rf(&rt2x00dev->chip, RF2525)) {
+	if (rt2x00_rf(rt2x00dev, RF2525)) {
 		static const u32 vals[] = {
 			0x00080cbe, 0x00080d02, 0x00080d06, 0x00080d0a,
 			0x00080d0e, 0x00080d12, 0x00080d16, 0x00080d1a,
@@ -516,7 +515,7 @@ static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	 * Switch off tuning bits.
 	 * For RT2523 devices we do not need to update the R1 register.
 	 */
-	if (!rt2x00_rf(&rt2x00dev->chip, RF2523)) {
+	if (!rt2x00_rf(rt2x00dev, RF2523)) {
 		rt2x00_set_field32(&rf->rf1, RF1_TUNER, 0);
 		rt2500pci_rf_write(rt2x00dev, 1, rf->rf1);
 	}
@@ -640,7 +639,7 @@ static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev,
 	 * up to version C the link tuning should halt after 20
 	 * seconds while being associated.
 	 */
-	if (rt2x00_rev(&rt2x00dev->chip) < RT2560_VERSION_D &&
+	if (rt2x00_rev(rt2x00dev) < RT2560_VERSION_D &&
 	    rt2x00dev->intf_associated && count > 20)
 		return;
 
@@ -650,7 +649,7 @@ static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev,
 	 * should go straight to dynamic CCA tuning when they
 	 * are not associated.
 	 */
-	if (rt2x00_rev(&rt2x00dev->chip) < RT2560_VERSION_D ||
+	if (rt2x00_rev(rt2x00dev) < RT2560_VERSION_D ||
 	    !rt2x00dev->intf_associated)
 		goto dynamic_cca_tune;
 
@@ -1507,12 +1506,12 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_chip_rf(rt2x00dev, value, reg);
 	rt2x00_print_chip(rt2x00dev);
 
-	if (!rt2x00_rf(&rt2x00dev->chip, RF2522) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2523) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2524) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2525) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2525E) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+	if (!rt2x00_rf(rt2x00dev, RF2522) &&
+	    !rt2x00_rf(rt2x00dev, RF2523) &&
+	    !rt2x00_rf(rt2x00dev, RF2524) &&
+	    !rt2x00_rf(rt2x00dev, RF2525) &&
+	    !rt2x00_rf(rt2x00dev, RF2525E) &&
+	    !rt2x00_rf(rt2x00dev, RF5222)) {
 		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
 		return -ENODEV;
 	}
@@ -1744,22 +1743,22 @@ static int rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	spec->supported_bands = SUPPORT_BAND_2GHZ;
 	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
 
-	if (rt2x00_rf(&rt2x00dev->chip, RF2522)) {
+	if (rt2x00_rf(rt2x00dev, RF2522)) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2522);
 		spec->channels = rf_vals_bg_2522;
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF2523)) {
+	} else if (rt2x00_rf(rt2x00dev, RF2523)) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2523);
 		spec->channels = rf_vals_bg_2523;
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF2524)) {
+	} else if (rt2x00_rf(rt2x00dev, RF2524)) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2524);
 		spec->channels = rf_vals_bg_2524;
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF2525)) {
+	} else if (rt2x00_rf(rt2x00dev, RF2525)) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2525);
 		spec->channels = rf_vals_bg_2525;
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF2525E)) {
+	} else if (rt2x00_rf(rt2x00dev, RF2525E)) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2525e);
 		spec->channels = rf_vals_bg_2525e;
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+	} else if (rt2x00_rf(rt2x00dev, RF5222)) {
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_5222);
 		spec->channels = rf_vals_5222;
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 83f2592..9e6f865 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -565,8 +565,7 @@ static void rt2500usb_config_ant(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * RT2525E and RT5222 need to flip TX I/Q
 	 */
-	if (rt2x00_rf(&rt2x00dev->chip, RF2525E) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+	if (rt2x00_rf(rt2x00dev, RF2525E) || rt2x00_rf(rt2x00dev, RF5222)) {
 		rt2x00_set_field8(&r2, BBP_R2_TX_IQ_FLIP, 1);
 		rt2x00_set_field16(&csr5, PHY_CSR5_CCK_FLIP, 1);
 		rt2x00_set_field16(&csr6, PHY_CSR6_OFDM_FLIP, 1);
@@ -574,7 +573,7 @@ static void rt2500usb_config_ant(struct rt2x00_dev *rt2x00dev,
 		/*
 		 * RT2525E does not need RX I/Q Flip.
 		 */
-		if (rt2x00_rf(&rt2x00dev->chip, RF2525E))
+		if (rt2x00_rf(rt2x00dev, RF2525E))
 			rt2x00_set_field8(&r14, BBP_R14_RX_IQ_FLIP, 0);
 	} else {
 		rt2x00_set_field16(&csr5, PHY_CSR5_CCK_FLIP, 0);
@@ -598,7 +597,7 @@ static void rt2500usb_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * For RT2525E we should first set the channel to half band higher.
 	 */
-	if (rt2x00_rf(&rt2x00dev->chip, RF2525E)) {
+	if (rt2x00_rf(rt2x00dev, RF2525E)) {
 		static const u32 vals[] = {
 			0x000008aa, 0x000008ae, 0x000008ae, 0x000008b2,
 			0x000008b2, 0x000008b6, 0x000008b6, 0x000008ba,
@@ -793,7 +792,7 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field16(&reg, MAC_CSR1_HOST_READY, 1);
 	rt2500usb_register_write(rt2x00dev, MAC_CSR1, reg);
 
-	if (rt2x00_rev(&rt2x00dev->chip) >= RT2570_VERSION_C) {
+	if (rt2x00_rev(rt2x00dev) >= RT2570_VERSION_C) {
 		rt2500usb_register_read(rt2x00dev, PHY_CSR2, &reg);
 		rt2x00_set_field16(&reg, PHY_CSR2_LNA, 0);
 	} else {
@@ -1411,19 +1410,18 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_chip(rt2x00dev, RT2570, value, reg);
 	rt2x00_print_chip(rt2x00dev);
 
-	if (!rt2x00_check_rev(&rt2x00dev->chip, 0x000ffff0, 0) ||
-	    rt2x00_check_rev(&rt2x00dev->chip, 0x0000000f, 0)) {
-
+	if (!rt2x00_check_rev(rt2x00dev, 0x000ffff0, 0) ||
+	    rt2x00_check_rev(rt2x00dev, 0x0000000f, 0)) {
 		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
 		return -ENODEV;
 	}
 
-	if (!rt2x00_rf(&rt2x00dev->chip, RF2522) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2523) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2524) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2525) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2525E) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+	if (!rt2x00_rf(rt2x00dev, RF2522) &&
+	    !rt2x00_rf(rt2x00dev, RF2523) &&
+	    !rt2x00_rf(rt2x00dev, RF2524) &&
+	    !rt2x00_rf(rt2x00dev, RF2525) &&
+	    !rt2x00_rf(rt2x00dev, RF2525E) &&
+	    !rt2x00_rf(rt2x00dev, RF5222)) {
 		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
 		return -ENODEV;
 	}
@@ -1667,22 +1665,22 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	spec->supported_bands = SUPPORT_BAND_2GHZ;
 	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
 
-	if (rt2x00_rf(&rt2x00dev->chip, RF2522)) {
+	if (rt2x00_rf(rt2x00dev, RF2522)) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2522);
 		spec->channels = rf_vals_bg_2522;
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF2523)) {
+	} else if (rt2x00_rf(rt2x00dev, RF2523)) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2523);
 		spec->channels = rf_vals_bg_2523;
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF2524)) {
+	} else if (rt2x00_rf(rt2x00dev, RF2524)) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2524);
 		spec->channels = rf_vals_bg_2524;
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF2525)) {
+	} else if (rt2x00_rf(rt2x00dev, RF2525)) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2525);
 		spec->channels = rf_vals_bg_2525;
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF2525E)) {
+	} else if (rt2x00_rf(rt2x00dev, RF2525E)) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2525e);
 		spec->channels = rf_vals_bg_2525e;
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+	} else if (rt2x00_rf(rt2x00dev, RF5222)) {
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_5222);
 		spec->channels = rf_vals_5222;
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a654551..8ff7db8 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -220,8 +220,7 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * RT2880 and RT3052 don't support MCU requests.
 	 */
-	if (rt2x00_rt(&rt2x00dev->chip, RT2880) ||
-	    rt2x00_rt(&rt2x00dev->chip, RT3052))
+	if (rt2x00_rt(rt2x00dev, RT2880) || rt2x00_rt(rt2x00dev, RT3052))
 		return;
 
 	mutex_lock(&rt2x00dev->csr_mutex);
@@ -806,12 +805,12 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	unsigned int tx_pin;
 	u8 bbp;
 
-	if ((rt2x00_rt(&rt2x00dev->chip, RT3070) ||
-	     rt2x00_rt(&rt2x00dev->chip, RT3090)) &&
-	    (rt2x00_rf(&rt2x00dev->chip, RF2020) ||
-	     rt2x00_rf(&rt2x00dev->chip, RF3020) ||
-	     rt2x00_rf(&rt2x00dev->chip, RF3021) ||
-	     rt2x00_rf(&rt2x00dev->chip, RF3022)))
+	if ((rt2x00_rt(rt2x00dev, RT3070) ||
+	     rt2x00_rt(rt2x00dev, RT3090)) &&
+	    (rt2x00_rf(rt2x00dev, RF2020) ||
+	     rt2x00_rf(rt2x00dev, RF3020) ||
+	     rt2x00_rf(rt2x00dev, RF3021) ||
+	     rt2x00_rf(rt2x00dev, RF3022)))
 		rt2800_config_channel_rt3x(rt2x00dev, conf, rf, info);
 	else
 		rt2800_config_channel_rt2x(rt2x00dev, conf, rf, info);
@@ -878,7 +877,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&bbp, BBP3_HT40_PLUS, conf_is_ht40_plus(conf));
 	rt2800_bbp_write(rt2x00dev, 3, bbp);
 
-	if (rt2x00_rev(&rt2x00dev->chip) == RT2860C_VERSION) {
+	if (rt2x00_rev(rt2x00dev) == RT2860C_VERSION) {
 		if (conf_is_ht40(conf)) {
 			rt2800_bbp_write(rt2x00dev, 69, 0x1a);
 			rt2800_bbp_write(rt2x00dev, 70, 0x0a);
@@ -1041,7 +1040,7 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
 		if (rt2x00_intf_is_usb(rt2x00dev) &&
-		    rt2x00_rev(&rt2x00dev->chip) == RT3070_VERSION)
+		    rt2x00_rev(rt2x00dev) == RT3070_VERSION)
 			return 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			return 0x2e + rt2x00dev->lna_gain;
@@ -1072,7 +1071,7 @@ EXPORT_SYMBOL_GPL(rt2800_reset_tuner);
 void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 		       const u32 count)
 {
-	if (rt2x00_rev(&rt2x00dev->chip) == RT2860C_VERSION)
+	if (rt2x00_rev(rt2x00dev) == RT2860C_VERSION)
 		return;
 
 	/*
@@ -1158,7 +1157,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
 	if (rt2x00_intf_is_usb(rt2x00dev) &&
-	    rt2x00_rev(&rt2x00dev->chip) == RT3070_VERSION) {
+	    rt2x00_rev(rt2x00dev) == RT3070_VERSION) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
@@ -1185,8 +1184,8 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_register_read(rt2x00dev, MAX_LEN_CFG, &reg);
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
-	if (rt2x00_rev(&rt2x00dev->chip) >= RT2880E_VERSION &&
-	    rt2x00_rev(&rt2x00dev->chip) < RT3070_VERSION)
+	if (rt2x00_rev(rt2x00dev) >= RT2880E_VERSION &&
+	    rt2x00_rev(rt2x00dev) < RT3070_VERSION)
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
 	else
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 1);
@@ -1465,22 +1464,22 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 103, 0x00);
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 
-	if (rt2x00_rev(&rt2x00dev->chip) == RT2860C_VERSION) {
+	if (rt2x00_rev(rt2x00dev) == RT2860C_VERSION) {
 		rt2800_bbp_write(rt2x00dev, 69, 0x16);
 		rt2800_bbp_write(rt2x00dev, 73, 0x12);
 	}
 
-	if (rt2x00_rev(&rt2x00dev->chip) > RT2860D_VERSION)
+	if (rt2x00_rev(rt2x00dev) > RT2860D_VERSION)
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
 
 	if (rt2x00_intf_is_usb(rt2x00dev) &&
-	    rt2x00_rev(&rt2x00dev->chip) == RT3070_VERSION) {
+	    rt2x00_rev(rt2x00dev) == RT3070_VERSION) {
 		rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 		rt2800_bbp_write(rt2x00dev, 84, 0x99);
 		rt2800_bbp_write(rt2x00dev, 105, 0x05);
 	}
 
-	if (rt2x00_rt(&rt2x00dev->chip, RT3052)) {
+	if (rt2x00_rt(rt2x00dev, RT3052)) {
 		rt2800_bbp_write(rt2x00dev, 31, 0x08);
 		rt2800_bbp_write(rt2x00dev, 78, 0x0e);
 		rt2800_bbp_write(rt2x00dev, 80, 0x08);
@@ -1566,13 +1565,13 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	u8 bbp;
 
 	if (rt2x00_intf_is_usb(rt2x00dev) &&
-	    rt2x00_rev(&rt2x00dev->chip) != RT3070_VERSION)
+	    rt2x00_rev(rt2x00dev) != RT3070_VERSION)
 		return 0;
 
 	if (rt2x00_intf_is_pci(rt2x00dev)) {
-		if (!rt2x00_rf(&rt2x00dev->chip, RF3020) &&
-		    !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
-		    !rt2x00_rf(&rt2x00dev->chip, RF3022))
+		if (!rt2x00_rf(rt2x00dev, RF3020) &&
+		    !rt2x00_rf(rt2x00dev, RF3021) &&
+		    !rt2x00_rf(rt2x00dev, RF3022))
 			return 0;
 	}
 
@@ -1737,7 +1736,7 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_RF_TYPE, RF2820);
 		rt2x00_eeprom_write(rt2x00dev, EEPROM_ANTENNA, word);
 		EEPROM(rt2x00dev, "Antenna: 0x%04x\n", word);
-	} else if (rt2x00_rev(&rt2x00dev->chip) < RT2883_VERSION) {
+	} else if (rt2x00_rev(rt2x00dev) < RT2883_VERSION) {
 		/*
 		 * There is a max of 2 RX streams for RT28x0 series
 		 */
@@ -1839,17 +1838,15 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_chip_rf(rt2x00dev, value, reg);
 
 	if (rt2x00_intf_is_usb(rt2x00dev)) {
-		struct rt2x00_chip *chip = &rt2x00dev->chip;
-
 		/*
 		 * The check for rt2860 is not a typo, some rt2870 hardware
 		 * identifies itself as rt2860 in the CSR register.
 		 */
-		if (rt2x00_check_rev(chip, 0xfff00000, 0x28600000) ||
-		    rt2x00_check_rev(chip, 0xfff00000, 0x28700000) ||
-		    rt2x00_check_rev(chip, 0xfff00000, 0x28800000)) {
+		if (rt2x00_check_rev(rt2x00dev, 0xfff00000, 0x28600000) ||
+		    rt2x00_check_rev(rt2x00dev, 0xfff00000, 0x28700000) ||
+		    rt2x00_check_rev(rt2x00dev, 0xfff00000, 0x28800000)) {
 			rt2x00_set_chip_rt(rt2x00dev, RT2870);
-		} else if (rt2x00_check_rev(chip, 0xffff0000, 0x30700000)) {
+		} else if (rt2x00_check_rev(rt2x00dev, 0xffff0000, 0x30700000)) {
 			rt2x00_set_chip_rt(rt2x00dev, RT3070);
 		} else {
 			ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
@@ -1858,14 +1855,14 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	}
 	rt2x00_print_chip(rt2x00dev);
 
-	if (!rt2x00_rf(&rt2x00dev->chip, RF2820) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2850) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2720) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2750) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF3020) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2020) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF3022)) {
+	if (!rt2x00_rf(rt2x00dev, RF2820) &&
+	    !rt2x00_rf(rt2x00dev, RF2850) &&
+	    !rt2x00_rf(rt2x00dev, RF2720) &&
+	    !rt2x00_rf(rt2x00dev, RF2750) &&
+	    !rt2x00_rf(rt2x00dev, RF3020) &&
+	    !rt2x00_rf(rt2x00dev, RF2020) &&
+	    !rt2x00_rf(rt2x00dev, RF3021) &&
+	    !rt2x00_rf(rt2x00dev, RF3022)) {
 		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
 		return -ENODEV;
 	}
@@ -2013,7 +2010,6 @@ static const struct rf_channel rf_vals_302x[] = {
 
 int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
-	struct rt2x00_chip *chip = &rt2x00dev->chip;
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
 	char *tx_power1;
@@ -2049,19 +2045,19 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	spec->supported_bands = SUPPORT_BAND_2GHZ;
 	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
 
-	if (rt2x00_rf(chip, RF2820) ||
-	    rt2x00_rf(chip, RF2720) ||
-	    (rt2x00_intf_is_pci(rt2x00dev) && rt2x00_rf(chip, RF3052))) {
+	if (rt2x00_rf(rt2x00dev, RF2820) ||
+	    rt2x00_rf(rt2x00dev, RF2720) ||
+	    (rt2x00_intf_is_pci(rt2x00dev) && rt2x00_rf(rt2x00dev, RF3052))) {
 		spec->num_channels = 14;
 		spec->channels = rf_vals;
-	} else if (rt2x00_rf(chip, RF2850) || rt2x00_rf(chip, RF2750)) {
+	} else if (rt2x00_rf(rt2x00dev, RF2850) || rt2x00_rf(rt2x00dev, RF2750)) {
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals);
 		spec->channels = rf_vals;
-	} else if (rt2x00_rf(chip, RF3020) ||
-		   rt2x00_rf(chip, RF2020) ||
-		   rt2x00_rf(chip, RF3021) ||
-		   rt2x00_rf(chip, RF3022)) {
+	} else if (rt2x00_rf(rt2x00dev, RF3020) ||
+		   rt2x00_rf(rt2x00dev, RF2020) ||
+		   rt2x00_rf(rt2x00dev, RF3021) ||
+		   rt2x00_rf(rt2x00dev, RF3022)) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_302x);
 		spec->channels = rf_vals_302x;
 	}
@@ -2069,7 +2065,7 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize HT information.
 	 */
-	if (!rt2x00_rf(chip, RF2020))
+	if (!rt2x00_rf(rt2x00dev, RF2020))
 		spec->ht.ht_supported = true;
 	else
 		spec->ht.ht_supported = false;
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 2f9dedd..b93eabb 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1121,8 +1121,7 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * This device requires firmware.
 	 */
-	if (!rt2x00_rt(&rt2x00dev->chip, RT2880) &&
-	    !rt2x00_rt(&rt2x00dev->chip, RT3052))
+	if (!rt2x00_rt(rt2x00dev, RT2880) && !rt2x00_rt(rt2x00dev, RT3052))
 		__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index aff984b..0510f02 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -92,7 +92,7 @@ static bool rt2800usb_check_crc(const u8 *data, const size_t len)
 static int rt2800usb_check_firmware(struct rt2x00_dev *rt2x00dev,
 				    const u8 *data, const size_t len)
 {
-	u16 chipset = (rt2x00_rev(&rt2x00dev->chip) >> 16) & 0xffff;
+	u16 chipset = (rt2x00_rev(rt2x00dev) >> 16) & 0xffff;
 	size_t offset = 0;
 
 	/*
@@ -138,7 +138,7 @@ static int rt2800usb_load_firmware(struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 	u32 offset;
 	u32 length;
-	u16 chipset = (rt2x00_rev(&rt2x00dev->chip) >> 16) & 0xffff;
+	u16 chipset = (rt2x00_rev(rt2x00dev) >> 16) & 0xffff;
 
 	/*
 	 * Check which section of the firmware we need.
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 194dae0..a664a99 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -937,25 +937,25 @@ static inline void rt2x00_print_chip(struct rt2x00_dev *rt2x00dev)
 	     rt2x00dev->chip.rt, rt2x00dev->chip.rf, rt2x00dev->chip.rev);
 }
 
-static inline char rt2x00_rt(const struct rt2x00_chip *chipset, const u16 chip)
+static inline char rt2x00_rt(struct rt2x00_dev *rt2x00dev, const u16 rt)
 {
-	return (chipset->rt == chip);
+	return (rt2x00dev->chip.rt == rt);
 }
 
-static inline char rt2x00_rf(const struct rt2x00_chip *chipset, const u16 chip)
+static inline char rt2x00_rf(struct rt2x00_dev *rt2x00dev, const u16 rf)
 {
-	return (chipset->rf == chip);
+	return (rt2x00dev->chip.rf == rf);
 }
 
-static inline u32 rt2x00_rev(const struct rt2x00_chip *chipset)
+static inline u32 rt2x00_rev(struct rt2x00_dev *rt2x00dev)
 {
-	return chipset->rev;
+	return rt2x00dev->chip.rev;
 }
 
-static inline bool rt2x00_check_rev(const struct rt2x00_chip *chipset,
+static inline bool rt2x00_check_rev(struct rt2x00_dev *rt2x00dev,
 				    const u32 mask, const u32 rev)
 {
-	return ((chipset->rev & mask) == rev);
+	return ((rt2x00dev->chip.rev & mask) == rev);
 }
 
 static inline void rt2x00_set_chip_intf(struct rt2x00_dev *rt2x00dev,
@@ -964,20 +964,20 @@ static inline void rt2x00_set_chip_intf(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->chip.intf = intf;
 }
 
-static inline bool rt2x00_intf(const struct rt2x00_chip *chipset,
+static inline bool rt2x00_intf(struct rt2x00_dev *rt2x00dev,
 			       enum rt2x00_chip_intf intf)
 {
-	return (chipset->intf == intf);
+	return (rt2x00dev->chip.intf == intf);
 }
 
 static inline bool rt2x00_intf_is_pci(struct rt2x00_dev *rt2x00dev)
 {
-	return rt2x00_intf(&rt2x00dev->chip, RT2X00_CHIP_INTF_PCI);
+	return rt2x00_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
 }
 
 static inline bool rt2x00_intf_is_usb(struct rt2x00_dev *rt2x00dev)
 {
-	return rt2x00_intf(&rt2x00dev->chip, RT2X00_CHIP_INTF_USB);
+	return rt2x00_intf(rt2x00dev, RT2X00_CHIP_INTF_USB);
 }
 
 /**
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 0ca5893..c353b49 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -637,8 +637,7 @@ static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	rt61pci_bbp_read(rt2x00dev, 4, &r4);
 	rt61pci_bbp_read(rt2x00dev, 77, &r77);
 
-	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE,
-			  rt2x00_rf(&rt2x00dev->chip, RF5325));
+	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, rt2x00_rf(rt2x00dev, RF5325));
 
 	/*
 	 * Configure the RX antenna.
@@ -684,8 +683,7 @@ static void rt61pci_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 	rt61pci_bbp_read(rt2x00dev, 4, &r4);
 	rt61pci_bbp_read(rt2x00dev, 77, &r77);
 
-	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE,
-			  rt2x00_rf(&rt2x00dev->chip, RF2529));
+	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, rt2x00_rf(rt2x00dev, RF2529));
 	rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
 			  !test_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags));
 
@@ -833,12 +831,11 @@ static void rt61pci_config_ant(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00pci_register_write(rt2x00dev, PHY_CSR0, reg);
 
-	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF5325))
+	if (rt2x00_rf(rt2x00dev, RF5225) || rt2x00_rf(rt2x00dev, RF5325))
 		rt61pci_config_antenna_5x(rt2x00dev, ant);
-	else if (rt2x00_rf(&rt2x00dev->chip, RF2527))
+	else if (rt2x00_rf(rt2x00dev, RF2527))
 		rt61pci_config_antenna_2x(rt2x00dev, ant);
-	else if (rt2x00_rf(&rt2x00dev->chip, RF2529)) {
+	else if (rt2x00_rf(rt2x00dev, RF2529)) {
 		if (test_bit(CONFIG_DOUBLE_ANTENNA, &rt2x00dev->flags))
 			rt61pci_config_antenna_2x(rt2x00dev, ant);
 		else
@@ -879,8 +876,7 @@ static void rt61pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&rf->rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
 	rt2x00_set_field32(&rf->rf4, RF4_FREQ_OFFSET, rt2x00dev->freq_offset);
 
-	smart = !(rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-		  rt2x00_rf(&rt2x00dev->chip, RF2527));
+	smart = !(rt2x00_rf(rt2x00dev, RF5225) || rt2x00_rf(rt2x00dev, RF2527));
 
 	rt61pci_bbp_read(rt2x00dev, 3, &r3);
 	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, smart);
@@ -2302,10 +2298,10 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_chip_rf(rt2x00dev, value, reg);
 	rt2x00_print_chip(rt2x00dev);
 
-	if (!rt2x00_rf(&rt2x00dev->chip, RF5225) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF5325) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2527) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2529)) {
+	if (!rt2x00_rf(rt2x00dev, RF5225) &&
+	    !rt2x00_rf(rt2x00dev, RF5325) &&
+	    !rt2x00_rf(rt2x00dev, RF2527) &&
+	    !rt2x00_rf(rt2x00dev, RF2529)) {
 		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
 		return -ENODEV;
 	}
@@ -2360,7 +2356,7 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * the antenna settings should be gathered from the NIC
 	 * eeprom word.
 	 */
-	if (rt2x00_rf(&rt2x00dev->chip, RF2529) &&
+	if (rt2x00_rf(rt2x00dev, RF2529) &&
 	    !test_bit(CONFIG_DOUBLE_ANTENNA, &rt2x00dev->flags)) {
 		rt2x00dev->default_ant.rx =
 		    ANTENNA_A + rt2x00_get_field16(eeprom, EEPROM_NIC_RX_FIXED);
@@ -2571,8 +2567,7 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		spec->channels = rf_vals_seq;
 	}
 
-	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF5325)) {
+	if (rt2x00_rf(rt2x00dev, RF5225) || rt2x00_rf(rt2x00dev, RF5325)) {
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_seq);
 	}
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 6ce88d3..a026912 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -136,8 +136,8 @@ static void rt73usb_rf_write(struct rt2x00_dev *rt2x00dev,
 		 * all others contain 20 bits.
 		 */
 		rt2x00_set_field32(&reg, PHY_CSR4_NUMBER_OF_BITS,
-				   20 + (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-					 rt2x00_rf(&rt2x00dev->chip, RF2527)));
+				   20 + (rt2x00_rf(rt2x00dev, RF5225) ||
+					 rt2x00_rf(rt2x00dev, RF2527)));
 		rt2x00_set_field32(&reg, PHY_CSR4_IF_SELECT, 0);
 		rt2x00_set_field32(&reg, PHY_CSR4_BUSY, 1);
 
@@ -741,11 +741,9 @@ static void rt73usb_config_ant(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00usb_register_write(rt2x00dev, PHY_CSR0, reg);
 
-	if (rt2x00_rf(&rt2x00dev->chip, RF5226) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF5225))
+	if (rt2x00_rf(rt2x00dev, RF5226) || rt2x00_rf(rt2x00dev, RF5225))
 		rt73usb_config_antenna_5x(rt2x00dev, ant);
-	else if (rt2x00_rf(&rt2x00dev->chip, RF2528) ||
-		 rt2x00_rf(&rt2x00dev->chip, RF2527))
+	else if (rt2x00_rf(rt2x00dev, RF2528) || rt2x00_rf(rt2x00dev, RF2527))
 		rt73usb_config_antenna_2x(rt2x00dev, ant);
 }
 
@@ -779,8 +777,7 @@ static void rt73usb_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&rf->rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
 	rt2x00_set_field32(&rf->rf4, RF4_FREQ_OFFSET, rt2x00dev->freq_offset);
 
-	smart = !(rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-		  rt2x00_rf(&rt2x00dev->chip, RF2527));
+	smart = !(rt2x00_rf(rt2x00dev, RF5225) || rt2x00_rf(rt2x00dev, RF2527));
 
 	rt73usb_bbp_read(rt2x00dev, 3, &r3);
 	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, smart);
@@ -1210,8 +1207,7 @@ static int rt73usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00usb_register_write(rt2x00dev, SEC_CSR5, 0x00000000);
 
 	reg = 0x000023b0;
-	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF2527))
+	if (rt2x00_rf(rt2x00dev, RF5225) || rt2x00_rf(rt2x00dev, RF2527))
 		rt2x00_set_field32(&reg, PHY_CSR1_RF_RPI, 1);
 	rt2x00usb_register_write(rt2x00dev, PHY_CSR1, reg);
 
@@ -1827,16 +1823,16 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_chip(rt2x00dev, RT2571, value, reg);
 	rt2x00_print_chip(rt2x00dev);
 
-	if (!rt2x00_check_rev(&rt2x00dev->chip, 0x000ffff0, 0x25730) ||
-	    rt2x00_check_rev(&rt2x00dev->chip, 0x0000000f, 0)) {
+	if (!rt2x00_check_rev(rt2x00dev, 0x000ffff0, 0x25730) ||
+	    rt2x00_check_rev(rt2x00dev, 0x0000000f, 0)) {
 		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
 		return -ENODEV;
 	}
 
-	if (!rt2x00_rf(&rt2x00dev->chip, RF5226) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2528) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF5225) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2527)) {
+	if (!rt2x00_rf(rt2x00dev, RF5226) &&
+	    !rt2x00_rf(rt2x00dev, RF2528) &&
+	    !rt2x00_rf(rt2x00dev, RF5225) &&
+	    !rt2x00_rf(rt2x00dev, RF2527)) {
 		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
 		return -ENODEV;
 	}
@@ -2081,17 +2077,17 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	spec->supported_bands = SUPPORT_BAND_2GHZ;
 	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
 
-	if (rt2x00_rf(&rt2x00dev->chip, RF2528)) {
+	if (rt2x00_rf(rt2x00dev, RF2528)) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2528);
 		spec->channels = rf_vals_bg_2528;
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF5226)) {
+	} else if (rt2x00_rf(rt2x00dev, RF5226)) {
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_5226);
 		spec->channels = rf_vals_5226;
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF2527)) {
+	} else if (rt2x00_rf(rt2x00dev, RF2527)) {
 		spec->num_channels = 14;
 		spec->channels = rf_vals_5225_2527;
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF5225)) {
+	} else if (rt2x00_rf(rt2x00dev, RF5225)) {
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_5225_2527);
 		spec->channels = rf_vals_5225_2527;
-- 
1.6.5.7

