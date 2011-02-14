Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab1BNLip (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 06:38:45 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlwifi: fix dma mappings and skbs leak
Date: Mon, 14 Feb 2011 12:38:49 +0100
Message-Id: <1297683529-4053-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit commit 470058e0ad82fcfaaffd57307d8bf8c094e8e9d7
"iwlwifi: avoid Tx queue memory allocation in interface down" we do
not unmap dma and free skbs when down device and there is pending
transfer. In consequence system may hung when performing shutdown
at iptables scripts or generate warning like below when unloading
iwlwifi module.

WARNING: at lib/dma-debug.c:689 dma_debug_device_change+0x15a/0x1b0()
Hardware name: HP xw8600 Workstation
pci 0000:80:00.0: DMA-API: device driver has pending DMA allocations while released from device [count=444]
Modules linked in: iwlagn(-) iwlcore cryptd aes_x86_64 aes_generic fuse autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf xt_physdev ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput hp_wmi sparse_keymap wmi sg microcode serio_raw iTCO_wdt iTCO_vendor_support tg3 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm arc4 ecb snd_timer snd soundcore snd_page_alloc i5k_amb hwmon i5400_edac edac_core shpchp mac80211 cfg80211 rfkill ext4 mbcache jbd2 sd_mod crc_t10dif sr_mod cdrom firewire_ohci firewire_core crc_itu_t mptsas mptscsih mptbase scsi_transport_sas pata_acpi ata_generic ata_piix ahci libahci floppy nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: iwlcore]
Pid: 7382, comm: rmmod Not tainted 2.6.38-rc3-wl+ #17
Call Trace:
 [<ffffffff81064bef>] ? warn_slowpath_common+0x7f/0xc0
 [<ffffffff81064ce6>] ? warn_slowpath_fmt+0x46/0x50
 [<ffffffff8125ea6b>] ? dma_debug_device_change+0xdb/0x1b0
 [<ffffffff8125eaea>] ? dma_debug_device_change+0x15a/0x1b0
 [<ffffffff814dfed8>] ? notifier_call_chain+0x58/0xb0
 [<ffffffff8108e6a0>] ? __blocking_notifier_call_chain+0x60/0x90
 [<ffffffff8108e6e6>] ? blocking_notifier_call_chain+0x16/0x20
 [<ffffffff81326fcc>] ? __device_release_driver+0xbc/0xe0
 [<ffffffff813270c8>] ? driver_detach+0xd8/0xe0
 [<ffffffff81325e91>] ? bus_remove_driver+0x91/0x100
 [<ffffffff813278e2>] ? driver_unregister+0x62/0xa0
 [<ffffffff81269f94>] ? pci_unregister_driver+0x44/0xa0
 [<ffffffffa0750e75>] ? iwl_exit+0x15/0x1c [iwlagn]
 [<ffffffff810abd22>] ? sys_delete_module+0x1a2/0x270
 [<ffffffff814db0d9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100bf82>] ? system_call_fastpath+0x16/0x1b

Patch fixes all of these.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   12 +++++-
 drivers/net/wireless/iwlwifi/iwl-core.h   |    2 +
 drivers/net/wireless/iwlwifi/iwl-tx.c     |   61 ++++++++++++++++++++--------
 3 files changed, 56 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 266490d..a709d05 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -947,7 +947,7 @@ void iwlagn_txq_ctx_reset(struct iwl_priv *priv)
  */
 void iwlagn_txq_ctx_stop(struct iwl_priv *priv)
 {
-	int ch;
+	int ch, txq_id;
 	unsigned long flags;
 
 	/* Turn off all Tx DMA fifos */
@@ -966,6 +966,16 @@ void iwlagn_txq_ctx_stop(struct iwl_priv *priv)
 			    iwl_read_direct32(priv, FH_TSSR_TX_STATUS_REG));
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
+
+	if (!priv->txq)
+		return;
+
+	/* Unmap DMA from host system and free skb's */
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
+		if (txq_id == priv->cmd_queue)
+			iwl_cmd_queue_unmap(priv);
+		else
+			iwl_tx_queue_unmap(priv, txq_id);
 }
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e0ec170..ed701f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -509,6 +509,7 @@ void iwl_rx_reply_error(struct iwl_priv *priv,
 * RX
 ******************************************************/
 void iwl_cmd_queue_free(struct iwl_priv *priv);
+void iwl_cmd_queue_unmap(struct iwl_priv *priv);
 int iwl_rx_queue_alloc(struct iwl_priv *priv);
 void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl_rx_queue *q);
@@ -533,6 +534,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 			int slots_num, u32 txq_id);
 void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id);
+void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id);
 void iwl_setup_watchdog(struct iwl_priv *priv);
 /*****************************************************
  * TX power
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 073b6ce..a8935cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -87,6 +87,24 @@ void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 EXPORT_SYMBOL(iwl_txq_update_write_ptr);
 
 /**
+ * iwl_tx_queue_unmap -  Unmap any remaining DMA mappings and free skb's
+ */
+void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id)
+{
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl_queue *q = &txq->q;
+
+	if (q->n_bd == 0)
+		return;
+
+	 while (q->write_ptr != q->read_ptr) {
+		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
+		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
+	}
+}
+EXPORT_SYMBOL(iwl_tx_queue_unmap);
+
+/**
  * iwl_tx_queue_free - Deallocate DMA queue.
  * @txq: Transmit queue to deallocate.
  *
@@ -97,17 +115,10 @@ EXPORT_SYMBOL(iwl_txq_update_write_ptr);
 void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
 	struct device *dev = &priv->pci_dev->dev;
 	int i;
 
-	if (q->n_bd == 0)
-		return;
-
-	/* first, empty all BD's */
-	for (; q->write_ptr != q->read_ptr;
-	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd))
-		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
+	iwl_tx_queue_unmap(priv, txq_id);
 
 	/* De-alloc array of command/tx buffers */
 	for (i = 0; i < TFD_TX_CMD_SLOTS; i++)
@@ -134,26 +145,19 @@ void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 EXPORT_SYMBOL(iwl_tx_queue_free);
 
 /**
- * iwl_cmd_queue_free - Deallocate DMA queue.
- * @txq: Transmit queue to deallocate.
- *
- * Empty queue by removing and destroying all BD's.
- * Free all buffers.
- * 0-fill, but do not free "txq" descriptor structure.
+ * iwl_cmd_queue_unmap - Unmap any remaining DMA mappings from command queue
  */
-void iwl_cmd_queue_free(struct iwl_priv *priv)
+void iwl_cmd_queue_unmap(struct iwl_priv *priv)
 {
 	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
 	struct iwl_queue *q = &txq->q;
-	struct device *dev = &priv->pci_dev->dev;
 	int i;
 	bool huge = false;
 
 	if (q->n_bd == 0)
 		return;
 
-	for (; q->read_ptr != q->write_ptr;
-	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+	while (q->read_ptr != q->write_ptr) {
 		/* we have no way to tell if it is a huge cmd ATM */
 		i = get_cmd_index(q, q->read_ptr, 0);
 
@@ -166,7 +170,10 @@ void iwl_cmd_queue_free(struct iwl_priv *priv)
 				 dma_unmap_addr(&txq->meta[i], mapping),
 				 dma_unmap_len(&txq->meta[i], len),
 				 PCI_DMA_BIDIRECTIONAL);
+
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
+
 	if (huge) {
 		i = q->n_window;
 		pci_unmap_single(priv->pci_dev,
@@ -174,6 +181,24 @@ void iwl_cmd_queue_free(struct iwl_priv *priv)
 				 dma_unmap_len(&txq->meta[i], len),
 				 PCI_DMA_BIDIRECTIONAL);
 	}
+}
+EXPORT_SYMBOL(iwl_cmd_queue_unmap);
+
+/**
+ * iwl_cmd_queue_free - Deallocate DMA queue.
+ * @txq: Transmit queue to deallocate.
+ *
+ * Empty queue by removing and destroying all BD's.
+ * Free all buffers.
+ * 0-fill, but do not free "txq" descriptor structure.
+ */
+void iwl_cmd_queue_free(struct iwl_priv *priv)
+{
+	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
+	struct device *dev = &priv->pci_dev->dev;
+	int i;
+
+	iwl_cmd_queue_unmap(priv);
 
 	/* De-alloc array of command/tx buffers */
 	for (i = 0; i <= TFD_CMD_SLOTS; i++)
-- 
1.7.1

