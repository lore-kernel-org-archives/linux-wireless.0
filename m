Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:1728 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564Ab2H3VEh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 17:04:37 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 17/17] rt2x00: rt2800 - Make probe_hw function common between PCI and USB.
Date: Thu, 30 Aug 2012 23:04:30 +0200
Message-Id: <1346360670-6498-13-git-send-email-gwingerde@gmail.com> (sfid-20120830_230445_610292_5595E766)
In-Reply-To: <1346360670-6498-12-git-send-email-gwingerde@gmail.com>
References: <1346355248-5331-10-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-1-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-2-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-3-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-4-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-5-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-6-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-7-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-8-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-9-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-10-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-11-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-12-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor the probe_hw code so that more code can be shared between
rt2800pci and rt2800usb.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c3cae1d..2ad3b7a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -44,6 +44,13 @@
 #include "rt2800.h"
 
 /*
+ * Allow hardware encryption to be disabled.
+ */
+static bool modparam_nohwcrypt = false;
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
+MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
+
+/*
  * Register access.
  * All access to the CSR registers will go through the methods
  * rt2800_register_read and rt2800_register_write.
@@ -4391,7 +4398,7 @@ void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800_read_eeprom_efuse);
 
-int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
+static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
 	u16 word;
@@ -4399,6 +4406,11 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	u8 default_lna_gain;
 
 	/*
+	 * Read the EEPROM.
+	 */
+	rt2800_read_eeprom(rt2x00dev);
+
+	/*
 	 * Start validation of the data that has been read.
 	 */
 	mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
@@ -4520,9 +4532,8 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(rt2800_validate_eeprom);
 
-int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
+static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 	u16 value;
@@ -4680,7 +4691,6 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(rt2800_init_eeprom);
 
 /*
  * RF value list for rt28xx
@@ -4823,7 +4833,7 @@ static const struct rf_channel rf_vals_3x[] = {
 	{173, 0x61, 0, 9},
 };
 
-int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
+static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
@@ -4999,7 +5009,72 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(rt2800_probe_hw_mode);
+
+int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
+{
+	int retval;
+	u32 reg;
+
+	/*
+	 * Allocate eeprom data.
+	 */
+	retval = rt2800_validate_eeprom(rt2x00dev);
+	if (retval)
+		return retval;
+
+	retval = rt2800_init_eeprom(rt2x00dev);
+	if (retval)
+		return retval;
+
+	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2800_register_read(rt2x00dev, GPIO_CTRL, &reg);
+	rt2x00_set_field32(&reg, GPIO_CTRL_DIR2, 1);
+	rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
+
+	/*
+	 * Initialize hw specifications.
+	 */
+	retval = rt2800_probe_hw_mode(rt2x00dev);
+	if (retval)
+		return retval;
+
+	/*
+	 * Set device capabilities.
+	 */
+	__set_bit(CAPABILITY_CONTROL_FILTERS, &rt2x00dev->cap_flags);
+	__set_bit(CAPABILITY_CONTROL_FILTER_PSPOLL, &rt2x00dev->cap_flags);
+	if (!rt2x00_is_usb(rt2x00dev))
+		__set_bit(CAPABILITY_PRE_TBTT_INTERRUPT, &rt2x00dev->cap_flags);
+
+	/*
+	 * Set device requirements.
+	 */
+	if (!rt2x00_is_soc(rt2x00dev))
+		__set_bit(REQUIRE_FIRMWARE, &rt2x00dev->cap_flags);
+	__set_bit(REQUIRE_L2PAD, &rt2x00dev->cap_flags);
+	__set_bit(REQUIRE_TXSTATUS_FIFO, &rt2x00dev->cap_flags);
+	if (!modparam_nohwcrypt)
+		__set_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags);
+	__set_bit(CAPABILITY_LINK_TUNING, &rt2x00dev->cap_flags);
+	__set_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags);
+	if (rt2x00_is_usb(rt2x00dev))
+		__set_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags);
+	else {
+		__set_bit(REQUIRE_DMA, &rt2x00dev->cap_flags);
+		__set_bit(REQUIRE_TASKLET_CONTEXT, &rt2x00dev->cap_flags);
+	}
+
+	/*
+	 * Set the rssi offset.
+	 */
+	rt2x00dev->rssi_offset = DEFAULT_RSSI_OFFSET;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2800_probe_hw);
 
 /*
  * IEEE80211 stack callback functions.
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 18a0b67..303e177 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -43,6 +43,8 @@ struct rt2800_ops {
 			    const unsigned int offset,
 			    const struct rt2x00_field32 field, u32 *reg);
 
+	void (*read_eeprom)(struct rt2x00_dev *rt2x00dev);
+
 	int (*drv_write_firmware)(struct rt2x00_dev *rt2x00dev,
 				  const u8 *data, const size_t len);
 	int (*drv_init_registers)(struct rt2x00_dev *rt2x00dev);
@@ -114,6 +116,13 @@ static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
 	return rt2800ops->regbusy_read(rt2x00dev, offset, field, reg);
 }
 
+static inline void rt2800_read_eeprom(struct rt2x00_dev *rt2x00dev)
+{
+	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
+
+	rt2800ops->read_eeprom(rt2x00dev);
+}
+
 static inline int rt2800_drv_write_firmware(struct rt2x00_dev *rt2x00dev,
 					    const u8 *data, const size_t len)
 {
@@ -191,9 +200,8 @@ void rt2800_disable_radio(struct rt2x00_dev *rt2x00dev);
 
 int rt2800_efuse_detect(struct rt2x00_dev *rt2x00dev);
 void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev);
-int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev);
-int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev);
-int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev);
+
+int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev);
 
 void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx, u32 *iv32,
 			 u16 *iv16);
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 0965540..abfc876 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -47,13 +47,6 @@
 #include "rt2800.h"
 #include "rt2800pci.h"
 
-/*
- * Allow hardware encryption to be disabled.
- */
-static bool modparam_nohwcrypt = false;
-module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
-MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
-
 static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 {
 	unsigned int i;
@@ -965,85 +958,14 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 /*
  * Device probe functions.
  */
-static int rt2800pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
+static void rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
 {
-	/*
-	 * Read EEPROM into buffer
-	 */
 	if (rt2x00_is_soc(rt2x00dev))
 		rt2800pci_read_eeprom_soc(rt2x00dev);
 	else if (rt2800pci_efuse_detect(rt2x00dev))
 		rt2800pci_read_eeprom_efuse(rt2x00dev);
 	else
 		rt2800pci_read_eeprom_pci(rt2x00dev);
-
-	return rt2800_validate_eeprom(rt2x00dev);
-}
-
-static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
-{
-	int retval;
-	u32 reg;
-
-	/*
-	 * Allocate eeprom data.
-	 */
-	retval = rt2800pci_validate_eeprom(rt2x00dev);
-	if (retval)
-		return retval;
-
-	retval = rt2800_init_eeprom(rt2x00dev);
-	if (retval)
-		return retval;
-
-	/*
-	 * Enable rfkill polling by setting GPIO direction of the
-	 * rfkill switch GPIO pin correctly.
-	 */
-	rt2x00pci_register_read(rt2x00dev, GPIO_CTRL, &reg);
-	rt2x00_set_field32(&reg, GPIO_CTRL_DIR2, 1);
-	rt2x00pci_register_write(rt2x00dev, GPIO_CTRL, reg);
-
-	/*
-	 * Initialize hw specifications.
-	 */
-	retval = rt2800_probe_hw_mode(rt2x00dev);
-	if (retval)
-		return retval;
-
-	/*
-	 * This device has multiple filters for control frames
-	 * and has a separate filter for PS Poll frames.
-	 */
-	__set_bit(CAPABILITY_CONTROL_FILTERS, &rt2x00dev->cap_flags);
-	__set_bit(CAPABILITY_CONTROL_FILTER_PSPOLL, &rt2x00dev->cap_flags);
-
-	/*
-	 * This device has a pre tbtt interrupt and thus fetches
-	 * a new beacon directly prior to transmission.
-	 */
-	__set_bit(CAPABILITY_PRE_TBTT_INTERRUPT, &rt2x00dev->cap_flags);
-
-	/*
-	 * This device requires firmware.
-	 */
-	if (!rt2x00_is_soc(rt2x00dev))
-		__set_bit(REQUIRE_FIRMWARE, &rt2x00dev->cap_flags);
-	__set_bit(REQUIRE_DMA, &rt2x00dev->cap_flags);
-	__set_bit(REQUIRE_L2PAD, &rt2x00dev->cap_flags);
-	__set_bit(REQUIRE_TXSTATUS_FIFO, &rt2x00dev->cap_flags);
-	__set_bit(REQUIRE_TASKLET_CONTEXT, &rt2x00dev->cap_flags);
-	if (!modparam_nohwcrypt)
-		__set_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags);
-	__set_bit(CAPABILITY_LINK_TUNING, &rt2x00dev->cap_flags);
-	__set_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags);
-
-	/*
-	 * Set the rssi offset.
-	 */
-	rt2x00dev->rssi_offset = DEFAULT_RSSI_OFFSET;
-
-	return 0;
 }
 
 static const struct ieee80211_ops rt2800pci_mac80211_ops = {
@@ -1081,6 +1003,7 @@ static const struct rt2800_ops rt2800pci_rt2800_ops = {
 	.register_multiread	= rt2x00pci_register_multiread,
 	.register_multiwrite	= rt2x00pci_register_multiwrite,
 	.regbusy_read		= rt2x00pci_regbusy_read,
+	.read_eeprom		= rt2800pci_read_eeprom,
 	.drv_write_firmware	= rt2800pci_write_firmware,
 	.drv_init_registers	= rt2800pci_init_registers,
 	.drv_get_txwi		= rt2800pci_get_txwi,
@@ -1093,7 +1016,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.tbtt_tasklet		= rt2800pci_tbtt_tasklet,
 	.rxdone_tasklet		= rt2800pci_rxdone_tasklet,
 	.autowake_tasklet	= rt2800pci_autowake_tasklet,
-	.probe_hw		= rt2800pci_probe_hw,
+	.probe_hw		= rt2800_probe_hw,
 	.get_firmware_name	= rt2800pci_get_firmware_name,
 	.check_firmware		= rt2800_check_firmware,
 	.load_firmware		= rt2800_load_firmware,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 5390632..dd0a41c 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -43,13 +43,6 @@
 #include "rt2800usb.h"
 
 /*
- * Allow hardware encryption to be disabled.
- */
-static bool modparam_nohwcrypt;
-module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
-MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
-
-/*
  * Queue handlers.
  */
 static void rt2800usb_start_queue(struct data_queue *queue)
@@ -722,73 +715,27 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 /*
  * Device probe functions.
  */
-static int rt2800usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
+static void rt2800usb_read_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt2800_efuse_detect(rt2x00dev))
 		rt2800_read_eeprom_efuse(rt2x00dev);
 	else
 		rt2x00usb_eeprom_read(rt2x00dev, rt2x00dev->eeprom,
 				      EEPROM_SIZE);
-
-	return rt2800_validate_eeprom(rt2x00dev);
 }
 
 static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
-	u32 reg;
 
-	/*
-	 * Allocate eeprom data.
-	 */
-	retval = rt2800usb_validate_eeprom(rt2x00dev);
+	retval = rt2800_probe_hw(rt2x00dev);
 	if (retval)
 		return retval;
 
-	retval = rt2800_init_eeprom(rt2x00dev);
-	if (retval)
-		return retval;
-
-	/*
-	 * Enable rfkill polling by setting GPIO direction of the
-	 * rfkill switch GPIO pin correctly.
-	 */
-	rt2x00usb_register_read(rt2x00dev, GPIO_CTRL, &reg);
-	rt2x00_set_field32(&reg, GPIO_CTRL_DIR2, 1);
-	rt2x00usb_register_write(rt2x00dev, GPIO_CTRL, reg);
-
-	/*
-	 * Initialize hw specifications.
-	 */
-	retval = rt2800_probe_hw_mode(rt2x00dev);
-	if (retval)
-		return retval;
-
-	/*
-	 * This device has multiple filters for control frames
-	 * and has a separate filter for PS Poll frames.
-	 */
-	__set_bit(CAPABILITY_CONTROL_FILTERS, &rt2x00dev->cap_flags);
-	__set_bit(CAPABILITY_CONTROL_FILTER_PSPOLL, &rt2x00dev->cap_flags);
-
-	/*
-	 * This device requires firmware.
-	 */
-	__set_bit(REQUIRE_FIRMWARE, &rt2x00dev->cap_flags);
-	__set_bit(REQUIRE_L2PAD, &rt2x00dev->cap_flags);
-	if (!modparam_nohwcrypt)
-		__set_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags);
-	__set_bit(CAPABILITY_LINK_TUNING, &rt2x00dev->cap_flags);
-	__set_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags);
-	__set_bit(REQUIRE_TXSTATUS_FIFO, &rt2x00dev->cap_flags);
-	__set_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags);
-
-	rt2x00dev->txstatus_timer.function = rt2800usb_tx_sta_fifo_timeout,
-
 	/*
-	 * Set the rssi offset.
+	 * Set txstatus timer function.
 	 */
-	rt2x00dev->rssi_offset = DEFAULT_RSSI_OFFSET;
+	rt2x00dev->txstatus_timer.function = rt2800usb_tx_sta_fifo_timeout;
 
 	/*
 	 * Overwrite TX done handler
@@ -834,6 +781,7 @@ static const struct rt2800_ops rt2800usb_rt2800_ops = {
 	.register_multiread	= rt2x00usb_register_multiread,
 	.register_multiwrite	= rt2x00usb_register_multiwrite,
 	.regbusy_read		= rt2x00usb_regbusy_read,
+	.read_eeprom		= rt2800usb_read_eeprom,
 	.drv_write_firmware	= rt2800usb_write_firmware,
 	.drv_init_registers	= rt2800usb_init_registers,
 	.drv_get_txwi		= rt2800usb_get_txwi,
-- 
1.7.11.1

