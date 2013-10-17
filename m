Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48763 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab3JQHmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:49 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 12/21] rt2x00: rt2800pci: use separate ops for the SoC driver
Date: Thu, 17 Oct 2013 09:42:26 +0200
Message-Id: <1381995755-16471-13-git-send-email-juhosg@openwrt.org> (sfid-20131017_100808_273553_74D88E0B)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it possible to use different callback
functions for PCI and SoC devices which will allow
to move the SoC driver into a separate module.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |  104 ++++++++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 5ae90df6..344a73d 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -356,6 +356,7 @@ static int rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
 	return retval;
 }
 
+#ifdef CONFIG_PCI
 static const struct ieee80211_ops rt2800pci_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
 	.start			= rt2x00mac_start,
@@ -459,7 +460,6 @@ static const struct rt2x00_ops rt2800pci_ops = {
 /*
  * RT2800pci module information.
  */
-#ifdef CONFIG_PCI
 static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1814, 0x0601) },
 	{ PCI_DEVICE(0x1814, 0x0681) },
@@ -517,9 +517,109 @@ MODULE_DEVICE_TABLE(pci, rt2800pci_device_table);
 MODULE_LICENSE("GPL");
 
 #if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
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
+	.read_eeprom		= rt2800pci_read_eeprom,
+	.hwcrypt_disabled	= rt2800pci_hwcrypt_disabled,
+	.drv_write_firmware	= rt2800pci_write_firmware,
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
+	.get_firmware_name	= rt2800pci_get_firmware_name,
+	.check_firmware		= rt2800_check_firmware,
+	.load_firmware		= rt2800_load_firmware,
+	.initialize		= rt2x00mmio_initialize,
+	.uninitialize		= rt2x00mmio_uninitialize,
+	.get_entry_state	= rt2800mmio_get_entry_state,
+	.clear_entry		= rt2800mmio_clear_entry,
+	.set_device_state	= rt2800pci_set_device_state,
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
 static int rt2800soc_probe(struct platform_device *pdev)
 {
-	return rt2x00soc_probe(pdev, &rt2800pci_ops);
+	return rt2x00soc_probe(pdev, &rt2800soc_ops);
 }
 
 static struct platform_driver rt2800soc_driver = {
-- 
1.7.10
