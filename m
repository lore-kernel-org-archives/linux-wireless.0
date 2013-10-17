Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48826 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab3JQHmx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:53 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 20/21] rt2x00: rt2800pci: move SoC specific code into a separate module
Date: Thu, 17 Oct 2013 09:42:34 +0200
Message-Id: <1381995755-16471-21-git-send-email-juhosg@openwrt.org> (sfid-20131017_094259_182301_581C0CE7)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PCI and SoC specific drivers are using separate
code now so it is not reasonable to use the same
module for both drivers anymore.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/Kconfig     |   21 ++-
 drivers/net/wireless/rt2x00/Makefile    |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c |  244 +---------------------------
 drivers/net/wireless/rt2x00/rt2800soc.c |  263 +++++++++++++++++++++++++++++++
 4 files changed, 284 insertions(+), 245 deletions(-)
 create mode 100644 drivers/net/wireless/rt2x00/rt2800soc.c

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index e863249..006b8bc 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -58,12 +58,11 @@ config RT61PCI
 
 config RT2800PCI
 	tristate "Ralink rt27xx/rt28xx/rt30xx (PCI/PCIe/PCMCIA) support"
-	depends on PCI || SOC_RT288X || SOC_RT305X
+	depends on PCI
 	select RT2800_LIB
 	select RT2800_LIB_MMIO
 	select RT2X00_LIB_MMIO
-	select RT2X00_LIB_PCI if PCI
-	select RT2X00_LIB_SOC if SOC_RT288X || SOC_RT305X
+	select RT2X00_LIB_PCI
 	select RT2X00_LIB_FIRMWARE
 	select RT2X00_LIB_CRYPTO
 	select CRC_CCITT
@@ -200,6 +199,22 @@ config RT2800USB_UNKNOWN
 
 endif
 
+config RT2800SOC
+	tristate "Ralink WiSoC support"
+	depends on SOC_RT288X || SOC_RT305X
+	select RT2X00_LIB_SOC
+	select RT2X00_LIB_MMIO
+	select RT2X00_LIB_CRYPTO
+	select RT2X00_LIB_FIRMWARE
+	select RT2800_LIB
+	select RT2800_LIB_MMIO
+	---help---
+	  This adds support for Ralink WiSoC devices.
+	  Supported chips: RT2880, RT3050, RT3052, RT3350, RT3352.
+
+	  When compiled as a module, this driver will be called rt2800soc.
+
+
 config RT2800_LIB
 	tristate
 
diff --git a/drivers/net/wireless/rt2x00/Makefile b/drivers/net/wireless/rt2x00/Makefile
index d11e356..24a6601 100644
--- a/drivers/net/wireless/rt2x00/Makefile
+++ b/drivers/net/wireless/rt2x00/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_RT2800PCI)			+= rt2800pci.o
 obj-$(CONFIG_RT2500USB)			+= rt2500usb.o
 obj-$(CONFIG_RT73USB)			+= rt73usb.o
 obj-$(CONFIG_RT2800USB)			+= rt2800usb.o
+obj-$(CONFIG_RT2800SOC)			+= rt2800soc.o
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 488d1c4..260d2fd 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -37,13 +37,11 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/platform_device.h>
 #include <linux/eeprom_93cx6.h>
 
 #include "rt2x00.h"
 #include "rt2x00mmio.h"
 #include "rt2x00pci.h"
-#include "rt2x00soc.h"
 #include "rt2800lib.h"
 #include "rt2800mmio.h"
 #include "rt2800.h"
@@ -56,7 +54,6 @@ static bool modparam_nohwcrypt = false;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
-#ifdef CONFIG_PCI
 static bool rt2800pci_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
 {
 	return modparam_nohwcrypt;
@@ -449,230 +446,15 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 #endif
 	{ 0, }
 };
-#endif /* CONFIG_PCI */
 
 MODULE_AUTHOR(DRV_PROJECT);
 MODULE_VERSION(DRV_VERSION);
 MODULE_DESCRIPTION("Ralink RT2800 PCI & PCMCIA Wireless LAN driver.");
 MODULE_SUPPORTED_DEVICE("Ralink RT2860 PCI & PCMCIA chipset based cards");
-#ifdef CONFIG_PCI
 MODULE_FIRMWARE(FIRMWARE_RT2860);
 MODULE_DEVICE_TABLE(pci, rt2800pci_device_table);
-#endif /* CONFIG_PCI */
 MODULE_LICENSE("GPL");
 
-#if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
-static bool rt2800soc_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
-{
-	return modparam_nohwcrypt;
-}
-
-static void rt2800soc_disable_radio(struct rt2x00_dev *rt2x00dev)
-{
-	rt2800_disable_radio(rt2x00dev);
-	rt2x00mmio_register_write(rt2x00dev, PWR_PIN_CFG, 0);
-	rt2x00mmio_register_write(rt2x00dev, TX_PIN_CFG, 0);
-}
-
-static int rt2800soc_set_device_state(struct rt2x00_dev *rt2x00dev,
-				      enum dev_state state)
-{
-	int retval = 0;
-
-	switch (state) {
-	case STATE_RADIO_ON:
-		retval = rt2800mmio_enable_radio(rt2x00dev);
-		break;
-
-	case STATE_RADIO_OFF:
-		rt2800soc_disable_radio(rt2x00dev);
-		break;
-
-	case STATE_RADIO_IRQ_ON:
-	case STATE_RADIO_IRQ_OFF:
-		rt2800mmio_toggle_irq(rt2x00dev, state);
-		break;
-
-	case STATE_DEEP_SLEEP:
-	case STATE_SLEEP:
-	case STATE_STANDBY:
-	case STATE_AWAKE:
-		/* These states are not supported, but don't report an error */
-		retval = 0;
-		break;
-
-	default:
-		retval = -ENOTSUPP;
-		break;
-	}
-
-	if (unlikely(retval))
-		rt2x00_err(rt2x00dev, "Device failed to enter state %d (%d)\n",
-			   state, retval);
-
-	return retval;
-}
-
-static int rt2800soc_read_eeprom(struct rt2x00_dev *rt2x00dev)
-{
-	void __iomem *base_addr = ioremap(0x1F040000, EEPROM_SIZE);
-
-	if (!base_addr)
-		return -ENOMEM;
-
-	memcpy_fromio(rt2x00dev->eeprom, base_addr, EEPROM_SIZE);
-
-	iounmap(base_addr);
-	return 0;
-}
-
-/* Firmware functions */
-static char *rt2800soc_get_firmware_name(struct rt2x00_dev *rt2x00dev)
-{
-	WARN_ON_ONCE(1);
-	return NULL;
-}
-
-static int rt2800soc_load_firmware(struct rt2x00_dev *rt2x00dev,
-				   const u8 *data, const size_t len)
-{
-	WARN_ON_ONCE(1);
-	return 0;
-}
-
-static int rt2800soc_check_firmware(struct rt2x00_dev *rt2x00dev,
-				    const u8 *data, const size_t len)
-{
-	WARN_ON_ONCE(1);
-	return 0;
-}
-
-static int rt2800soc_write_firmware(struct rt2x00_dev *rt2x00dev,
-				    const u8 *data, const size_t len)
-{
-	WARN_ON_ONCE(1);
-	return 0;
-}
-
-static const struct ieee80211_ops rt2800soc_mac80211_ops = {
-	.tx			= rt2x00mac_tx,
-	.start			= rt2x00mac_start,
-	.stop			= rt2x00mac_stop,
-	.add_interface		= rt2x00mac_add_interface,
-	.remove_interface	= rt2x00mac_remove_interface,
-	.config			= rt2x00mac_config,
-	.configure_filter	= rt2x00mac_configure_filter,
-	.set_key		= rt2x00mac_set_key,
-	.sw_scan_start		= rt2x00mac_sw_scan_start,
-	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
-	.get_stats		= rt2x00mac_get_stats,
-	.get_tkip_seq		= rt2800_get_tkip_seq,
-	.set_rts_threshold	= rt2800_set_rts_threshold,
-	.sta_add		= rt2x00mac_sta_add,
-	.sta_remove		= rt2x00mac_sta_remove,
-	.bss_info_changed	= rt2x00mac_bss_info_changed,
-	.conf_tx		= rt2800_conf_tx,
-	.get_tsf		= rt2800_get_tsf,
-	.rfkill_poll		= rt2x00mac_rfkill_poll,
-	.ampdu_action		= rt2800_ampdu_action,
-	.flush			= rt2x00mac_flush,
-	.get_survey		= rt2800_get_survey,
-	.get_ringparam		= rt2x00mac_get_ringparam,
-	.tx_frames_pending	= rt2x00mac_tx_frames_pending,
-};
-
-static const struct rt2800_ops rt2800soc_rt2800_ops = {
-	.register_read		= rt2x00mmio_register_read,
-	.register_read_lock	= rt2x00mmio_register_read, /* same for SoCs */
-	.register_write		= rt2x00mmio_register_write,
-	.register_write_lock	= rt2x00mmio_register_write, /* same for SoCs */
-	.register_multiread	= rt2x00mmio_register_multiread,
-	.register_multiwrite	= rt2x00mmio_register_multiwrite,
-	.regbusy_read		= rt2x00mmio_regbusy_read,
-	.read_eeprom		= rt2800soc_read_eeprom,
-	.hwcrypt_disabled	= rt2800soc_hwcrypt_disabled,
-	.drv_write_firmware	= rt2800soc_write_firmware,
-	.drv_init_registers	= rt2800mmio_init_registers,
-	.drv_get_txwi		= rt2800mmio_get_txwi,
-};
-
-static const struct rt2x00lib_ops rt2800soc_rt2x00_ops = {
-	.irq_handler		= rt2800mmio_interrupt,
-	.txstatus_tasklet	= rt2800mmio_txstatus_tasklet,
-	.pretbtt_tasklet	= rt2800mmio_pretbtt_tasklet,
-	.tbtt_tasklet		= rt2800mmio_tbtt_tasklet,
-	.rxdone_tasklet		= rt2800mmio_rxdone_tasklet,
-	.autowake_tasklet	= rt2800mmio_autowake_tasklet,
-	.probe_hw		= rt2800_probe_hw,
-	.get_firmware_name	= rt2800soc_get_firmware_name,
-	.check_firmware		= rt2800soc_check_firmware,
-	.load_firmware		= rt2800soc_load_firmware,
-	.initialize		= rt2x00mmio_initialize,
-	.uninitialize		= rt2x00mmio_uninitialize,
-	.get_entry_state	= rt2800mmio_get_entry_state,
-	.clear_entry		= rt2800mmio_clear_entry,
-	.set_device_state	= rt2800soc_set_device_state,
-	.rfkill_poll		= rt2800_rfkill_poll,
-	.link_stats		= rt2800_link_stats,
-	.reset_tuner		= rt2800_reset_tuner,
-	.link_tuner		= rt2800_link_tuner,
-	.gain_calibration	= rt2800_gain_calibration,
-	.vco_calibration	= rt2800_vco_calibration,
-	.start_queue		= rt2800mmio_start_queue,
-	.kick_queue		= rt2800mmio_kick_queue,
-	.stop_queue		= rt2800mmio_stop_queue,
-	.flush_queue		= rt2x00mmio_flush_queue,
-	.write_tx_desc		= rt2800mmio_write_tx_desc,
-	.write_tx_data		= rt2800_write_tx_data,
-	.write_beacon		= rt2800_write_beacon,
-	.clear_beacon		= rt2800_clear_beacon,
-	.fill_rxdone		= rt2800mmio_fill_rxdone,
-	.config_shared_key	= rt2800_config_shared_key,
-	.config_pairwise_key	= rt2800_config_pairwise_key,
-	.config_filter		= rt2800_config_filter,
-	.config_intf		= rt2800_config_intf,
-	.config_erp		= rt2800_config_erp,
-	.config_ant		= rt2800_config_ant,
-	.config			= rt2800_config,
-	.sta_add		= rt2800_sta_add,
-	.sta_remove		= rt2800_sta_remove,
-};
-
-static const struct rt2x00_ops rt2800soc_ops = {
-	.name			= KBUILD_MODNAME,
-	.drv_data_size		= sizeof(struct rt2800_drv_data),
-	.max_ap_intf		= 8,
-	.eeprom_size		= EEPROM_SIZE,
-	.rf_size		= RF_SIZE,
-	.tx_queues		= NUM_TX_QUEUES,
-	.queue_init		= rt2800mmio_queue_init,
-	.lib			= &rt2800soc_rt2x00_ops,
-	.drv			= &rt2800soc_rt2800_ops,
-	.hw			= &rt2800soc_mac80211_ops,
-#ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs		= &rt2800_rt2x00debug,
-#endif /* CONFIG_RT2X00_LIB_DEBUGFS */
-};
-
-static int rt2800soc_probe(struct platform_device *pdev)
-{
-	return rt2x00soc_probe(pdev, &rt2800soc_ops);
-}
-
-static struct platform_driver rt2800soc_driver = {
-	.driver		= {
-		.name		= "rt2800_wmac",
-		.owner		= THIS_MODULE,
-		.mod_name	= KBUILD_MODNAME,
-	},
-	.probe		= rt2800soc_probe,
-	.remove		= rt2x00soc_remove,
-	.suspend	= rt2x00soc_suspend,
-	.resume		= rt2x00soc_resume,
-};
-#endif /* CONFIG_SOC_RT288X || CONFIG_SOC_RT305X */
-
-#ifdef CONFIG_PCI
 static int rt2800pci_probe(struct pci_dev *pci_dev,
 			   const struct pci_device_id *id)
 {
@@ -687,38 +469,16 @@ static struct pci_driver rt2800pci_driver = {
 	.suspend	= rt2x00pci_suspend,
 	.resume		= rt2x00pci_resume,
 };
-#endif /* CONFIG_PCI */
+
 
 static int __init rt2800pci_init(void)
 {
-	int ret = 0;
-
-#if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
-	ret = platform_driver_register(&rt2800soc_driver);
-	if (ret)
-		return ret;
-#endif
-#ifdef CONFIG_PCI
-	ret = pci_register_driver(&rt2800pci_driver);
-	if (ret) {
-#if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
-		platform_driver_unregister(&rt2800soc_driver);
-#endif
-		return ret;
-	}
-#endif
-
-	return ret;
+	return pci_register_driver(&rt2800pci_driver);
 }
 
 static void __exit rt2800pci_exit(void)
 {
-#ifdef CONFIG_PCI
 	pci_unregister_driver(&rt2800pci_driver);
-#endif
-#if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
-	platform_driver_unregister(&rt2800soc_driver);
-#endif
 }
 
 module_init(rt2800pci_init);
diff --git a/drivers/net/wireless/rt2x00/rt2800soc.c b/drivers/net/wireless/rt2x00/rt2800soc.c
new file mode 100644
index 0000000..1359227
--- /dev/null
+++ b/drivers/net/wireless/rt2x00/rt2800soc.c
@@ -0,0 +1,263 @@
+/*	Copyright (C) 2009 - 2010 Ivo van Doorn <IvDoorn@gmail.com>
+ *	Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
+ *	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
+ *	Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
+ *	Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
+ *	Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
+ *	Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
+ *	Copyright (C) 2009 Bart Zolnierkiewicz <bzolnier@gmail.com>
+ *	<http://rt2x00.serialmonkey.com>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *	GNU General Public License for more details.
+ *
+ *	You should have received a copy of the GNU General Public License
+ *	along with this program; if not, write to the
+ *	Free Software Foundation, Inc.,
+ *	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*	Module: rt2800soc
+ *	Abstract: rt2800 WiSoC specific routines.
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include "rt2x00.h"
+#include "rt2x00mmio.h"
+#include "rt2x00soc.h"
+#include "rt2800.h"
+#include "rt2800lib.h"
+#include "rt2800mmio.h"
+
+/* Allow hardware encryption to be disabled. */
+static bool modparam_nohwcrypt;
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
+MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
+
+static bool rt2800soc_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
+{
+	return modparam_nohwcrypt;
+}
+
+static void rt2800soc_disable_radio(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_disable_radio(rt2x00dev);
+	rt2x00mmio_register_write(rt2x00dev, PWR_PIN_CFG, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_PIN_CFG, 0);
+}
+
+static int rt2800soc_set_device_state(struct rt2x00_dev *rt2x00dev,
+				      enum dev_state state)
+{
+	int retval = 0;
+
+	switch (state) {
+	case STATE_RADIO_ON:
+		retval = rt2800mmio_enable_radio(rt2x00dev);
+		break;
+
+	case STATE_RADIO_OFF:
+		rt2800soc_disable_radio(rt2x00dev);
+		break;
+
+	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_OFF:
+		rt2800mmio_toggle_irq(rt2x00dev, state);
+		break;
+
+	case STATE_DEEP_SLEEP:
+	case STATE_SLEEP:
+	case STATE_STANDBY:
+	case STATE_AWAKE:
+		/* These states are not supported, but don't report an error */
+		retval = 0;
+		break;
+
+	default:
+		retval = -ENOTSUPP;
+		break;
+	}
+
+	if (unlikely(retval))
+		rt2x00_err(rt2x00dev, "Device failed to enter state %d (%d)\n",
+			   state, retval);
+
+	return retval;
+}
+
+static int rt2800soc_read_eeprom(struct rt2x00_dev *rt2x00dev)
+{
+	void __iomem *base_addr = ioremap(0x1F040000, EEPROM_SIZE);
+
+	if (!base_addr)
+		return -ENOMEM;
+
+	memcpy_fromio(rt2x00dev->eeprom, base_addr, EEPROM_SIZE);
+
+	iounmap(base_addr);
+	return 0;
+}
+
+/* Firmware functions */
+static char *rt2800soc_get_firmware_name(struct rt2x00_dev *rt2x00dev)
+{
+	WARN_ON_ONCE(1);
+	return NULL;
+}
+
+static int rt2800soc_load_firmware(struct rt2x00_dev *rt2x00dev,
+				   const u8 *data, const size_t len)
+{
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
+static int rt2800soc_check_firmware(struct rt2x00_dev *rt2x00dev,
+				    const u8 *data, const size_t len)
+{
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
+static int rt2800soc_write_firmware(struct rt2x00_dev *rt2x00dev,
+				    const u8 *data, const size_t len)
+{
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
+static const struct ieee80211_ops rt2800soc_mac80211_ops = {
+	.tx			= rt2x00mac_tx,
+	.start			= rt2x00mac_start,
+	.stop			= rt2x00mac_stop,
+	.add_interface		= rt2x00mac_add_interface,
+	.remove_interface	= rt2x00mac_remove_interface,
+	.config			= rt2x00mac_config,
+	.configure_filter	= rt2x00mac_configure_filter,
+	.set_key		= rt2x00mac_set_key,
+	.sw_scan_start		= rt2x00mac_sw_scan_start,
+	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
+	.get_stats		= rt2x00mac_get_stats,
+	.get_tkip_seq		= rt2800_get_tkip_seq,
+	.set_rts_threshold	= rt2800_set_rts_threshold,
+	.sta_add		= rt2x00mac_sta_add,
+	.sta_remove		= rt2x00mac_sta_remove,
+	.bss_info_changed	= rt2x00mac_bss_info_changed,
+	.conf_tx		= rt2800_conf_tx,
+	.get_tsf		= rt2800_get_tsf,
+	.rfkill_poll		= rt2x00mac_rfkill_poll,
+	.ampdu_action		= rt2800_ampdu_action,
+	.flush			= rt2x00mac_flush,
+	.get_survey		= rt2800_get_survey,
+	.get_ringparam		= rt2x00mac_get_ringparam,
+	.tx_frames_pending	= rt2x00mac_tx_frames_pending,
+};
+
+static const struct rt2800_ops rt2800soc_rt2800_ops = {
+	.register_read		= rt2x00mmio_register_read,
+	.register_read_lock	= rt2x00mmio_register_read, /* same for SoCs */
+	.register_write		= rt2x00mmio_register_write,
+	.register_write_lock	= rt2x00mmio_register_write, /* same for SoCs */
+	.register_multiread	= rt2x00mmio_register_multiread,
+	.register_multiwrite	= rt2x00mmio_register_multiwrite,
+	.regbusy_read		= rt2x00mmio_regbusy_read,
+	.read_eeprom		= rt2800soc_read_eeprom,
+	.hwcrypt_disabled	= rt2800soc_hwcrypt_disabled,
+	.drv_write_firmware	= rt2800soc_write_firmware,
+	.drv_init_registers	= rt2800mmio_init_registers,
+	.drv_get_txwi		= rt2800mmio_get_txwi,
+};
+
+static const struct rt2x00lib_ops rt2800soc_rt2x00_ops = {
+	.irq_handler		= rt2800mmio_interrupt,
+	.txstatus_tasklet	= rt2800mmio_txstatus_tasklet,
+	.pretbtt_tasklet	= rt2800mmio_pretbtt_tasklet,
+	.tbtt_tasklet		= rt2800mmio_tbtt_tasklet,
+	.rxdone_tasklet		= rt2800mmio_rxdone_tasklet,
+	.autowake_tasklet	= rt2800mmio_autowake_tasklet,
+	.probe_hw		= rt2800_probe_hw,
+	.get_firmware_name	= rt2800soc_get_firmware_name,
+	.check_firmware		= rt2800soc_check_firmware,
+	.load_firmware		= rt2800soc_load_firmware,
+	.initialize		= rt2x00mmio_initialize,
+	.uninitialize		= rt2x00mmio_uninitialize,
+	.get_entry_state	= rt2800mmio_get_entry_state,
+	.clear_entry		= rt2800mmio_clear_entry,
+	.set_device_state	= rt2800soc_set_device_state,
+	.rfkill_poll		= rt2800_rfkill_poll,
+	.link_stats		= rt2800_link_stats,
+	.reset_tuner		= rt2800_reset_tuner,
+	.link_tuner		= rt2800_link_tuner,
+	.gain_calibration	= rt2800_gain_calibration,
+	.vco_calibration	= rt2800_vco_calibration,
+	.start_queue		= rt2800mmio_start_queue,
+	.kick_queue		= rt2800mmio_kick_queue,
+	.stop_queue		= rt2800mmio_stop_queue,
+	.flush_queue		= rt2x00mmio_flush_queue,
+	.write_tx_desc		= rt2800mmio_write_tx_desc,
+	.write_tx_data		= rt2800_write_tx_data,
+	.write_beacon		= rt2800_write_beacon,
+	.clear_beacon		= rt2800_clear_beacon,
+	.fill_rxdone		= rt2800mmio_fill_rxdone,
+	.config_shared_key	= rt2800_config_shared_key,
+	.config_pairwise_key	= rt2800_config_pairwise_key,
+	.config_filter		= rt2800_config_filter,
+	.config_intf		= rt2800_config_intf,
+	.config_erp		= rt2800_config_erp,
+	.config_ant		= rt2800_config_ant,
+	.config			= rt2800_config,
+	.sta_add		= rt2800_sta_add,
+	.sta_remove		= rt2800_sta_remove,
+};
+
+static const struct rt2x00_ops rt2800soc_ops = {
+	.name			= KBUILD_MODNAME,
+	.drv_data_size		= sizeof(struct rt2800_drv_data),
+	.max_ap_intf		= 8,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.queue_init		= rt2800mmio_queue_init,
+	.lib			= &rt2800soc_rt2x00_ops,
+	.drv			= &rt2800soc_rt2800_ops,
+	.hw			= &rt2800soc_mac80211_ops,
+#ifdef CONFIG_RT2X00_LIB_DEBUGFS
+	.debugfs		= &rt2800_rt2x00debug,
+#endif /* CONFIG_RT2X00_LIB_DEBUGFS */
+};
+
+static int rt2800soc_probe(struct platform_device *pdev)
+{
+	return rt2x00soc_probe(pdev, &rt2800soc_ops);
+}
+
+static struct platform_driver rt2800soc_driver = {
+	.driver		= {
+		.name		= "rt2800_wmac",
+		.owner		= THIS_MODULE,
+		.mod_name	= KBUILD_MODNAME,
+	},
+	.probe		= rt2800soc_probe,
+	.remove		= rt2x00soc_remove,
+	.suspend	= rt2x00soc_suspend,
+	.resume		= rt2x00soc_resume,
+};
+
+module_platform_driver(rt2800soc_driver);
+
+MODULE_AUTHOR(DRV_PROJECT);
+MODULE_VERSION(DRV_VERSION);
+MODULE_DESCRIPTION("Ralink WiSoC Wireless LAN driver.");
+MODULE_LICENSE("GPL");
-- 
1.7.10
