Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:52109 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbXJ0XEg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 19:04:36 -0400
Date: Sun, 28 Oct 2007 02:04:25 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 1/7] ath5k: Maintain coding style
Message-ID: <20071027230425.GA5973@localhost.domain.invalid> (sfid-20071028_000446_114091_7A5CAB05)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Sort functions in segments like we do on the rest of the code (eg.
hw.c). This improves readability and maintainability.

* Add myself as module author (a patch for this was submited some time
ago as part of SFLC's changes but wasn't applied)

* Declare that this driver is or 5xxx chipset series only in
MODULE_SUPPORTED_DEVICE and MODULE_DESCRIPTION.


Changes-licensed-under: 3-clause-BSD
Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index c972ff9..7d8e0b5 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -39,7 +39,6 @@
  * THE POSSIBILITY OF SUCH DAMAGES.
  *
  */
-#define	ATH_PCI_VERSION	"0.9.5.0-BSD"
 
 #include <linux/version.h>
 #include <linux/module.h>
@@ -103,34 +102,6 @@ static unsigned int ath5k_debug;
 module_param_named(debug, ath5k_debug, uint, 0);
 #endif
 
-/*
- * Static table of PCI id's.
- */
-static struct pci_device_id ath5k_pci_id_table[] __devinitdata = {
-	{ PCI_VDEVICE(ATHEROS, 0x0207), .driver_data = AR5K_AR5210 }, /* 5210 early */
-	{ PCI_VDEVICE(ATHEROS, 0x0007), .driver_data = AR5K_AR5210 }, /* 5210 */
-	{ PCI_VDEVICE(ATHEROS, 0x0011), .driver_data = AR5K_AR5211 }, /* 5311 */
-	{ PCI_VDEVICE(ATHEROS, 0x0012), .driver_data = AR5K_AR5211 }, /* 5211 */
-	{ PCI_VDEVICE(ATHEROS, 0x0013), .driver_data = AR5K_AR5212 }, /* 5212 */
-	{ PCI_VDEVICE(3COM_2,  0x0013), .driver_data = AR5K_AR5212 }, /* 3com 5212 */
-	{ PCI_VDEVICE(3COM,    0x0013), .driver_data = AR5K_AR5212 }, /* 3com 3CRDAG675 5212 */
-	{ PCI_VDEVICE(ATHEROS, 0x1014), .driver_data = AR5K_AR5212 }, /* IBM minipci 5212 */
-	{ PCI_VDEVICE(ATHEROS, 0x0014), .driver_data = AR5K_AR5212 },
-	{ PCI_VDEVICE(ATHEROS, 0x0015), .driver_data = AR5K_AR5212 },
-	{ PCI_VDEVICE(ATHEROS, 0x0016), .driver_data = AR5K_AR5212 },
-	{ PCI_VDEVICE(ATHEROS, 0x0017), .driver_data = AR5K_AR5212 },
-	{ PCI_VDEVICE(ATHEROS, 0x0018), .driver_data = AR5K_AR5212 },
-	{ PCI_VDEVICE(ATHEROS, 0x0019), .driver_data = AR5K_AR5212 },
-	{ PCI_VDEVICE(ATHEROS, 0x001a), .driver_data = AR5K_AR5212 }, /* 2413 Griffin-lite */
-	{ PCI_VDEVICE(ATHEROS, 0x001b), .driver_data = AR5K_AR5212 }, /* 5413 Eagle */
-	{ PCI_VDEVICE(ATHEROS, 0x001c), .driver_data = AR5K_AR5212 }, /* 5424 Condor (PCI-E)*/
-	{ 0 }
-};
-MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
-
-static void ath5k_led_event(struct ath5k_softc *, int);
-static int ath5k_reset(struct ieee80211_hw *);
-
 #if AR_DEBUG
 static void ath5k_printrxbuf(struct ath5k_buf *bf, int done)
 {
@@ -165,93 +136,1157 @@ static inline void ath5k_dump_skb(struct sk_buff *skb, const char *prefix)
 static inline void ath5k_dump_skb(struct sk_buff *skb, const char *prefix) {}
 #endif
 
-static inline void ath5k_cleanup_txbuf(struct ath5k_softc *sc, struct ath5k_buf *bf)
+#if ATH_DEBUG_MODES
+static void ath5k_dump_modes(struct ieee80211_hw_mode *modes)
 {
-	BUG_ON(!bf);
-	if (!bf->skb)
-		return;
-	pci_unmap_single(sc->pdev, bf->skbaddr, bf->skb->len,
-			PCI_DMA_TODEVICE);
-	dev_kfree_skb(bf->skb);
-	bf->skb = NULL;
+	unsigned int m, i;
+
+	for (m = 0; m < NUM_DRIVER_MODES; m++) {
+		printk(KERN_DEBUG "Mode %u: channels %d, rates %d\n", m,
+				modes[m].num_channels, modes[m].num_rates);
+		printk(KERN_DEBUG " channels:\n");
+		for (i = 0; i < modes[m].num_channels; i++)
+			printk(KERN_DEBUG "  %3d %d %.4x %.4x\n",
+					modes[m].channels[i].chan,
+					modes[m].channels[i].freq,
+					modes[m].channels[i].val,
+					modes[m].channels[i].flag);
+		printk(KERN_DEBUG " rates:\n");
+		for (i = 0; i < modes[m].num_rates; i++)
+			printk(KERN_DEBUG "  %4d %.4x %.4x %.4x\n",
+					modes[m].rates[i].rate,
+					modes[m].rates[i].val,
+					modes[m].rates[i].flags,
+					modes[m].rates[i].val2);
+	}
 }
+#else
+static inline void ath5k_dump_modes(struct ieee80211_hw_mode *modes) {}
+#endif
+
+
+/******************\
+* Internal defines *
+\******************/
+
+/* Module info */
+MODULE_AUTHOR("Jiri Slaby");
+MODULE_AUTHOR("Nick Kossifidis");
+MODULE_DESCRIPTION("Support for 5xxx series of Atheros 802.11 wireless LAN cards.");
+MODULE_SUPPORTED_DEVICE("Atheros 5xxx WLAN cards");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION("0.1.1 (EXPERIMENTAL)");
+
+
+/* Known PCI ids */
+static struct pci_device_id ath5k_pci_id_table[] __devinitdata = {
+	{ PCI_VDEVICE(ATHEROS, 0x0207), .driver_data = AR5K_AR5210 }, /* 5210 early */
+	{ PCI_VDEVICE(ATHEROS, 0x0007), .driver_data = AR5K_AR5210 }, /* 5210 */
+	{ PCI_VDEVICE(ATHEROS, 0x0011), .driver_data = AR5K_AR5211 }, /* 5311 */
+	{ PCI_VDEVICE(ATHEROS, 0x0012), .driver_data = AR5K_AR5211 }, /* 5211 */
+	{ PCI_VDEVICE(ATHEROS, 0x0013), .driver_data = AR5K_AR5212 }, /* 5212 */
+	{ PCI_VDEVICE(3COM_2,  0x0013), .driver_data = AR5K_AR5212 }, /* 3com 5212 */
+	{ PCI_VDEVICE(3COM,    0x0013), .driver_data = AR5K_AR5212 }, /* 3com 3CRDAG675 5212 */
+	{ PCI_VDEVICE(ATHEROS, 0x1014), .driver_data = AR5K_AR5212 }, /* IBM minipci 5212 */
+	{ PCI_VDEVICE(ATHEROS, 0x0014), .driver_data = AR5K_AR5212 }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0015), .driver_data = AR5K_AR5212 }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0016), .driver_data = AR5K_AR5212 }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0017), .driver_data = AR5K_AR5212 }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0018), .driver_data = AR5K_AR5212 }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0019), .driver_data = AR5K_AR5212 }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x001a), .driver_data = AR5K_AR5212 }, /* 2413 Griffin-lite */
+	{ PCI_VDEVICE(ATHEROS, 0x001b), .driver_data = AR5K_AR5212 }, /* 5413 Eagle */
+	{ PCI_VDEVICE(ATHEROS, 0x001c), .driver_data = AR5K_AR5212 }, /* 5424 Condor (PCI-E)*/
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
+
 
-static void ath5k_tasklet_reset(unsigned long data)
+/*
+ * Sysctl tables
+ */
+static int mincalibrate = 1;
+static int maxcalibrate = INT_MAX / 1000;
+static ctl_table ath5k_static_sysctls[] = {
+#if AR_DEBUG
+	{
+	  .procname	= "debug",
+	  .mode		= 0644,
+	  .data		= &ath5k_debug,
+	  .maxlen	= sizeof(ath5k_debug),
+	  .proc_handler	= proc_dointvec
+	},
+#endif
+	{
+	  .procname	= "calibrate",
+	  .mode		= 0644,
+	  .data		= &ath5k_calinterval,
+	  .maxlen	= sizeof(ath5k_calinterval),
+	  .extra1	= &mincalibrate,
+	  .extra2	= &maxcalibrate,
+	  .proc_handler	= proc_dointvec_minmax
+	},
+	{ 0 }
+};
+static ctl_table ath5k_ath5k_table[] = {
+	{
+	  .procname	= "ath",
+	  .mode		= 0555,
+	  .child	= ath5k_static_sysctls
+	}, { 0 }
+};
+static ctl_table ath5k_root_table[] = {
+	{
+	  .ctl_name	= CTL_DEV,
+	  .procname	= "dev",
+	  .mode		= 0555,
+	  .child	= ath5k_ath5k_table
+	}, { 0 }
+};
+static struct ctl_table_header *ath5k_sysctl_header;
+
+
+/*
+ * Prototypes - PCI stack related functions
+ */
+static int __devinit	ath5k_pci_probe(struct pci_dev *pdev,
+				const struct pci_device_id *id);
+static void __devexit	ath5k_pci_remove(struct pci_dev *pdev);
+#ifdef CONFIG_PM
+static int		ath5k_pci_suspend(struct pci_dev *pdev,
+					pm_message_t state);
+static int		ath5k_pci_resume(struct pci_dev *pdev);
+#else
+#define ath5k_pci_suspend NULL
+#define ath5k_pci_resume NULL
+#endif /* CONFIG_PM */
+
+static struct pci_driver ath5k_pci_drv_id = {
+	.name		= "ath5k_pci",
+	.id_table	= ath5k_pci_id_table,
+	.probe		= ath5k_pci_probe,
+	.remove		= __devexit_p(ath5k_pci_remove),
+	.suspend	= ath5k_pci_suspend,
+	.resume		= ath5k_pci_resume,
+};
+
+
+
+/*
+ * Prototypes - MAC 802.11 stack related functions
+ */
+static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+		struct ieee80211_tx_control *ctl);
+static int ath5k_reset(struct ieee80211_hw *hw);
+static int ath5k_start(struct ieee80211_hw *hw);
+static void ath5k_stop(struct ieee80211_hw *hw);
+static int ath5k_add_interface(struct ieee80211_hw *hw,
+		struct ieee80211_if_init_conf *conf);
+static void ath5k_remove_interface(struct ieee80211_hw *hw,
+		struct ieee80211_if_init_conf *conf);
+static int ath5k_config(struct ieee80211_hw *hw,
+		struct ieee80211_conf *conf);
+static int ath5k_config_interface(struct ieee80211_hw *hw, int if_id,
+		struct ieee80211_if_conf *conf);
+static void ath5k_configure_filter(struct ieee80211_hw *hw,
+		unsigned int changed_flags,
+		unsigned int *new_flags,
+		int mc_count, struct dev_mc_list *mclist);
+static int ath5k_set_key(struct ieee80211_hw *hw,
+		enum set_key_cmd cmd,
+		const u8 *local_addr, const u8 *addr,
+		struct ieee80211_key_conf *key);
+static int ath5k_get_stats(struct ieee80211_hw *hw,
+		struct ieee80211_low_level_stats *stats);
+static int ath5k_get_tx_stats(struct ieee80211_hw *hw,
+		struct ieee80211_tx_queue_stats *stats);
+static u64 ath5k_get_tsf(struct ieee80211_hw *hw);
+static void ath5k_reset_tsf(struct ieee80211_hw *hw);
+static int ath5k_beacon_update(struct ieee80211_hw *hw,
+		struct sk_buff *skb,
+		struct ieee80211_tx_control *ctl);
+
+static struct ieee80211_ops ath5k_hw_ops = {
+	.tx 		= ath5k_tx,
+	.start 		= ath5k_start,
+	.stop 		= ath5k_stop,
+	.add_interface 	= ath5k_add_interface,
+	.remove_interface = ath5k_remove_interface,
+	.config 	= ath5k_config,
+	.config_interface = ath5k_config_interface,
+	.configure_filter = ath5k_configure_filter,
+	.set_key 	= ath5k_set_key,
+	.get_stats 	= ath5k_get_stats,
+	.conf_tx 	= NULL,
+	.get_tx_stats 	= ath5k_get_tx_stats,
+	.get_tsf 	= ath5k_get_tsf,
+	.reset_tsf 	= ath5k_reset_tsf,
+	.beacon_update 	= ath5k_beacon_update,
+};
+
+/*
+ * Prototypes - Internal functions
+ */
+/* Attach detach */
+static int 	ath5k_attach(struct pci_dev *pdev,
+			struct ieee80211_hw *hw);
+static void 	ath5k_detach(struct pci_dev *pdev,
+			struct ieee80211_hw *hw);
+/* Channel/mode setup */
+static inline short ath5k_ieee2mhz(short chan);
+static unsigned int ath5k_copy_rates(struct ieee80211_rate *rates,
+				const struct ath5k_rate_table *rt,
+				unsigned int max);
+static unsigned int ath5k_copy_channels(struct ath5k_hw *ah,
+				struct ieee80211_channel *channels,
+				unsigned int mode,
+				unsigned int max);
+static int 	ath5k_getchannels(struct ieee80211_hw *hw);
+static int 	ath5k_chan_set(struct ath5k_softc *sc,
+				struct ieee80211_channel *chan);
+static void	ath5k_setcurmode(struct ath5k_softc *sc,
+				unsigned int mode);
+static void	ath5k_mode_init(struct ath5k_softc *sc);
+/* Descriptor setup */
+static int	ath5k_desc_alloc(struct ath5k_softc *sc,
+				struct pci_dev *pdev);
+static void	ath5k_desc_free(struct ath5k_softc *sc,
+				struct pci_dev *pdev);
+/* Buffers setup */
+static int 	ath5k_rxbuf_init(struct ath5k_softc *sc,
+				struct ath5k_buf *bf);
+static int 	ath5k_tx_bf(struct ath5k_softc *sc,
+				struct ath5k_buf *bf,
+				struct ieee80211_tx_control *ctl);
+static inline void ath5k_cleanup_txbuf(struct ath5k_softc *sc,
+				struct ath5k_buf *bf);
+/* Queues setup */
+static struct 	ath5k_txq *ath5k_txq_setup(struct ath5k_softc *sc,
+				int qtype, int subtype);
+static int 	ath5k_beaconq_setup(struct ath5k_hw *ah);
+static int 	ath5k_beaconq_config(struct ath5k_softc *sc);
+static void 	ath5k_tx_draintxq(struct ath5k_softc *sc,
+				struct ath5k_txq *txq);
+static void 	ath5k_draintxq(struct ath5k_softc *sc);
+static void 	ath5k_tx_cleanup(struct ath5k_softc *sc);
+/* Rx handling */
+static int 	ath5k_startrecv(struct ath5k_softc *sc);
+static void 	ath5k_stoprecv(struct ath5k_softc *sc);
+static unsigned int ath5k_rx_decrypted(struct ath5k_softc *sc,
+					struct ath5k_desc *ds,
+					struct sk_buff *skb);
+static void 	ath5k_tasklet_rx(unsigned long data);
+/* Tx handling */
+static void 	ath5k_tx_processq(struct ath5k_softc *sc,
+				struct ath5k_txq *txq);
+static void 	ath5k_tasklet_tx(unsigned long data);
+/* Beacon handling */
+static int 	ath5k_beacon_setup(struct ath5k_softc *sc,
+				struct ath5k_buf *bf,
+				struct ieee80211_tx_control *ctl);
+static void 	ath5k_beacon_send(struct ath5k_softc *sc);
+static void 	ath5k_beacon_config(struct ath5k_softc *sc);
+static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp);
+/* Interrupt handling */
+static int 	ath5k_init(struct ath5k_softc *sc);
+static int 	ath5k_stop_locked(struct ath5k_softc *sc);
+static int 	ath5k_stop_hw(struct ath5k_softc *sc);
+static irqreturn_t ath5k_intr(int irq, void *dev_id);
+static void 	ath5k_tasklet_reset(unsigned long data);
+static inline void ath5k_update_txpow(struct ath5k_softc *sc);
+static void 	ath5k_calibrate(unsigned long data);
+/* LED functions */
+static void 	ath5k_led_off(unsigned long data);
+static void 	ath5k_led_blink(struct ath5k_softc *sc,
+				unsigned int on,
+				unsigned int off);
+static void 	ath5k_led_event(struct ath5k_softc *sc,
+				int event);
+
+
+/*
+ * Module init/exit functions
+ */
+static int __init
+init_ath5k_pci(void)
 {
-	struct ath5k_softc *sc = (void *)data;
+	int ret;
 
-	ath5k_reset(sc->hw);
+	ret = pci_register_driver(&ath5k_pci_drv_id);
+	if (ret) {
+		printk(KERN_ERR "ath5k_pci: can't register pci driver\n");
+		return ret;
+	}
+	ath5k_sysctl_header = register_sysctl_table(ath5k_root_table);
+
+	return 0;
 }
 
-static void ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
+static void __exit
+exit_ath5k_pci(void)
 {
-	struct ieee80211_tx_status txs = {};
-	struct ath5k_buf *bf, *bf0;
-	struct ath5k_desc *ds;
-	struct sk_buff *skb;
+	if (ath5k_sysctl_header)
+		unregister_sysctl_table(ath5k_sysctl_header);
+	pci_unregister_driver(&ath5k_pci_drv_id);
+}
+
+module_init(init_ath5k_pci);
+module_exit(exit_ath5k_pci);
+
+
+/********************\
+* PCI Initialization *
+\********************/
+
+static const char *
+ath5k_chip_name(u8 mac_version)
+{
+	switch (mac_version) {
+	case AR5K_AR5210:
+		return "AR5210";
+	case AR5K_AR5211:
+		return "AR5211";
+	case AR5K_AR5212:
+		return "AR5212";
+	}
+	return "Unknown";
+}
+
+static int __devinit
+ath5k_pci_probe(struct pci_dev *pdev,
+		const struct pci_device_id *id)
+{
+	void __iomem *mem;
+	struct ath5k_softc *sc;
+	struct ieee80211_hw *hw;
 	int ret;
+	u8 csz;
 
-	spin_lock(&txq->lock);
-	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
-		ds = bf->desc;
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "can't enable device\n");
+		goto err;
+	}
 
-		/* TODO only one segment */
-		pci_dma_sync_single_for_cpu(sc->pdev, sc->desc_daddr,
-				sc->desc_len, PCI_DMA_FROMDEVICE);
-		ret = sc->ah->ah_proc_tx_desc(sc->ah, ds);
-		if (unlikely(ret == -EINPROGRESS))
-			break;
-		else if (unlikely(ret)) {
-			printk(KERN_ERR "ath: error %d while processing "
-				"queue %u\n", ret, txq->qnum);
-			break;
+	/* XXX 32-bit addressing only */
+	ret = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	if (ret) {
+		dev_err(&pdev->dev, "32-bit DMA not available\n");
+		goto err_dis;
+	}
+
+	/*
+	 * Cache line size is used to size and align various
+	 * structures used to communicate with the hardware.
+	 */
+	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &csz);
+	if (csz == 0) {
+		/*
+		 * Linux 2.4.18 (at least) writes the cache line size
+		 * register as a 16-bit wide register which is wrong.
+		 * We must have this setup properly for rx buffer
+		 * DMA to work so force a reasonable value here if it
+		 * comes up zero.
+		 */
+		csz = L1_CACHE_BYTES / sizeof(u32);
+		pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, csz);
+	}
+	/*
+	 * The default setting of latency timer yields poor results,
+	 * set it to the value used by other systems.  It may be worth
+	 * tweaking this setting more.
+	 */
+	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0xa8);
+
+	/* Enable bus mastering */
+	pci_set_master(pdev);
+
+	/*
+	 * Disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state.
+	 */
+	pci_write_config_byte(pdev, 0x41, 0);
+
+	ret = pci_request_region(pdev, 0, "ath5k");
+	if (ret) {
+		dev_err(&pdev->dev, "cannot reserve PCI memory region\n");
+		goto err_dis;
+	}
+
+	mem = pci_iomap(pdev, 0, 0);
+	if (!mem) {
+		dev_err(&pdev->dev, "cannot remap PCI memory region\n") ;
+		ret = -EIO;
+		goto err_reg;
+	}
+
+	/* 
+	 * Allocate hw (mac80211 main struct)
+	 * and hw->priv (driver private data)
+	 */
+	hw = ieee80211_alloc_hw(sizeof(*sc), &ath5k_hw_ops);
+	if (hw == NULL) {
+		dev_err(&pdev->dev, "cannot allocate ieee80211_hw\n");
+		ret = -ENOMEM;
+		goto err_map;
+	}
+
+	/* Initialize driver private data */
+	SET_IEEE80211_DEV(hw, &pdev->dev);
+	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS;
+	hw->extra_tx_headroom = 2;
+	hw->channel_change_time = 5000;
+	hw->max_rssi = 127; /* FIXME: get a real value for this. */
+	sc = hw->priv;
+	sc->hw = hw;
+	sc->pdev = pdev;
+
+	/*
+	 * Mark the device as detached to avoid processing
+	 * interrupts until setup is complete.
+	 */
+#if AR_DEBUG
+	sc->debug = ath5k_debug;
+#endif
+	__set_bit(ATH_STAT_INVALID, sc->status);
+
+	sc->iobase = mem; /* So we can unmap it on detach */
+	sc->cachelsz = csz * sizeof(u32); /* convert to bytes */
+	sc->opmode = IEEE80211_IF_TYPE_STA;
+	mutex_init(&sc->lock);
+	spin_lock_init(&sc->rxbuflock);
+	spin_lock_init(&sc->txbuflock);
+
+	/* Set private data */
+	pci_set_drvdata(pdev, hw);
+
+	/* Enable msi for devices that support it */
+	pci_enable_msi(pdev);
+
+	/* Setup interrupt handler */
+	ret = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
+	if (ret) {
+		dev_err(&pdev->dev, "request_irq failed\n");
+		goto err_free;
+	}
+
+	/* Initialize device */
+	sc->ah = ath5k_hw_attach(pdev->device, id->driver_data, sc, sc->iobase);
+	if (IS_ERR(sc->ah)) {
+		ret = PTR_ERR(sc->ah);
+		goto err_irq;
+	}
+
+	/* Finish private driver data initialization */
+	ret = ath5k_attach(pdev, hw);
+	if (ret)
+		goto err_ah;
+
+	dev_info(&pdev->dev, "%s chip found: mac %d.%d phy %d.%d\n",
+			ath5k_chip_name(id->driver_data), sc->ah->ah_mac_version,
+			sc->ah->ah_mac_revision, sc->ah->ah_phy_revision >> 4,
+			sc->ah->ah_phy_revision & 0xf);
+
+	/* ready to process interrupts */
+	__clear_bit(ATH_STAT_INVALID, sc->status);
+
+	return 0;
+err_ah:
+	ath5k_hw_detach(sc->ah);
+err_irq:
+	free_irq(pdev->irq, sc);
+err_free:
+	pci_disable_msi(pdev);
+	ieee80211_free_hw(hw);
+err_map:
+	pci_iounmap(pdev, mem);
+err_reg:
+	pci_release_region(pdev, 0);
+err_dis:
+	pci_disable_device(pdev);
+err:
+	return ret;
+}
+
+static void __devexit
+ath5k_pci_remove(struct pci_dev *pdev)
+{
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ath5k_softc *sc = hw->priv;
+
+	ath5k_detach(pdev, hw);
+	ath5k_hw_detach(sc->ah);
+	free_irq(pdev->irq, sc);
+	pci_disable_msi(pdev);
+	pci_iounmap(pdev, sc->iobase);
+	pci_release_region(pdev, 0);
+	pci_disable_device(pdev);
+	ieee80211_free_hw(hw);
+}
+
+#ifdef CONFIG_PM
+static int
+ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ath5k_softc *sc = hw->priv;
+
+	if (test_bit(ATH_STAT_LEDSOFT, sc->status))
+		ath5k_hw_set_gpio(sc->ah, sc->led_pin, 1);
+
+	ath5k_stop_hw(sc);
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D3hot);
+
+	return 0;
+}
+
+static int
+ath5k_pci_resume(struct pci_dev *pdev)
+{
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ath5k_softc *sc = hw->priv;
+	int err;
+
+	err = pci_set_power_state(pdev, PCI_D0);
+	if (err)
+		return err;
+
+	err = pci_enable_device(pdev);
+	if (err)
+		return err;
+
+	pci_restore_state(pdev);
+	/*
+	 * Suspend/Resume resets the PCI configuration space, so we have to
+	 * re-disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state
+	 */
+	pci_write_config_byte(pdev, 0x41, 0);
+
+	ath5k_init(sc);
+	if (test_bit(ATH_STAT_LEDSOFT, sc->status)) {
+		ath5k_hw_set_gpio_output(sc->ah, sc->led_pin);
+		ath5k_hw_set_gpio(sc->ah, sc->led_pin, 0);
+	}
+
+	return 0;
+}
+#endif /* CONFIG_PM */
+
+
+
+/***********************\
+* Driver Initialization *
+\***********************/
+
+static int
+ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
+{
+	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = sc->ah;
+	u8 mac[ETH_ALEN];
+	unsigned int i;
+	int ret;
+
+	DPRINTF(sc, ATH_DEBUG_ANY, "%s: devid 0x%x\n", __func__, pdev->device);
+
+	/*
+	 * Check if the MAC has multi-rate retry support.
+	 * We do this by trying to setup a fake extended
+	 * descriptor.  MAC's that don't have support will
+	 * return false w/o doing anything.  MAC's that do
+	 * support it will return true w/o doing anything.
+	 */
+	if (ah->ah_setup_xtx_desc(ah, NULL, 0, 0, 0, 0, 0, 0))
+		__set_bit(ATH_STAT_MRRETRY, sc->status);
+
+	/*
+	 * Reset the key cache since some parts do not
+	 * reset the contents on initial power up.
+	 */
+	for (i = 0; i < AR5K_KEYCACHE_SIZE; i++)
+		ath5k_hw_reset_key(ah, i);
+
+	/*
+	 * Collect the channel list.  The 802.11 layer
+	 * is resposible for filtering this list based
+	 * on settings like the phy mode and regulatory
+	 * domain restrictions.
+	 */
+	ret = ath5k_getchannels(hw);
+	if (ret) {
+		dev_err(&pdev->dev, "can't get channels\n");
+		goto err;
+	}
+
+	/* NB: setup here so ath5k_rate_update is happy */
+	if (test_bit(MODE_IEEE80211A, ah->ah_modes))
+		ath5k_setcurmode(sc, MODE_IEEE80211A);
+	else
+		ath5k_setcurmode(sc, MODE_IEEE80211B);
+
+	/*
+	 * Allocate tx+rx descriptors and populate the lists.
+	 */
+	ret = ath5k_desc_alloc(sc, pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "can't allocate descriptors\n");
+		goto err;
+	}
+
+	/*
+	 * Allocate hardware transmit queues: one queue for
+	 * beacon frames and one data queue for each QoS
+	 * priority.  Note that hw functions handle reseting
+	 * these queues at the needed time.
+	 */
+	ret = ath5k_beaconq_setup(ah);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "can't setup a beacon xmit queue\n");
+		goto err_desc;
+	}
+	sc->bhalq = ret;
+
+	sc->txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
+	if (IS_ERR(sc->txq)) {
+		dev_err(&pdev->dev, "can't setup xmit queue\n");
+		ret = PTR_ERR(sc->txq);
+		goto err_bhal;
+	}
+
+	tasklet_init(&sc->rxtq, ath5k_tasklet_rx, (unsigned long)sc);
+	tasklet_init(&sc->txtq, ath5k_tasklet_tx, (unsigned long)sc);
+	tasklet_init(&sc->restq, ath5k_tasklet_reset, (unsigned long)sc);
+	setup_timer(&sc->calib_tim, ath5k_calibrate, (unsigned long)sc);
+	setup_timer(&sc->led_tim, ath5k_led_off, (unsigned long)sc);
+
+	sc->led_on = 0; /* low true */
+	/*
+	 * Auto-enable soft led processing for IBM cards and for
+	 * 5211 minipci cards.  Users can also manually enable/disable
+	 * support with a sysctl.
+	 */
+	if (pdev->device == PCI_DEVICE_ID_ATHEROS_AR5212_IBM ||
+			pdev->device == PCI_DEVICE_ID_ATHEROS_AR5211) {
+		__set_bit(ATH_STAT_LEDSOFT, sc->status);
+		sc->led_pin = 0;
+	}
+	/* Enable softled on PIN1 on HP Compaq nc6xx, nc4000 & nx5000 laptops */
+	if (pdev->subsystem_vendor == PCI_VENDOR_ID_COMPAQ) {
+		__set_bit(ATH_STAT_LEDSOFT, sc->status);
+		sc->led_pin = 0;
+	}
+	if (test_bit(ATH_STAT_LEDSOFT, sc->status)) {
+		ath5k_hw_set_gpio_output(ah, sc->led_pin);
+		ath5k_hw_set_gpio(ah, sc->led_pin, !sc->led_on);
+	}
+
+	ath5k_hw_get_lladdr(ah, mac);
+	SET_IEEE80211_PERM_ADDR(hw, mac);
+	/* All MAC address bits matter for ACKs */
+	memset(sc->bssidmask, 0xff, ETH_ALEN);
+	ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
+
+	ret = ieee80211_register_hw(hw);
+	if (ret) {
+		dev_err(&pdev->dev, "can't register ieee80211 hw\n");
+		goto err_queues;
+	}
+
+	return 0;
+err_queues:
+	ath5k_tx_cleanup(sc);
+err_bhal:
+	ath5k_hw_release_tx_queue(ah, sc->bhalq);
+err_desc:
+	ath5k_desc_free(sc, pdev);
+err:
+	return ret;
+}
+
+static void
+ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
+{
+	struct ath5k_softc *sc = hw->priv;
+
+	/*
+	 * NB: the order of these is important:
+	 * o call the 802.11 layer before detaching ath5k_hw to
+	 *   insure callbacks into the driver to delete global
+	 *   key cache entries can be handled
+	 * o reclaim the tx queue data structures after calling
+	 *   the 802.11 layer as we'll get called back to reclaim
+	 *   node state and potentially want to use them
+	 * o to cleanup the tx queues the hal is called, so detach
+	 *   it last
+	 * XXX: ??? detach ath5k_hw ???
+	 * Other than that, it's straightforward...
+	 */
+	ieee80211_unregister_hw(hw);
+	ath5k_desc_free(sc, pdev);
+	ath5k_tx_cleanup(sc);
+	ath5k_hw_release_tx_queue(sc->ah, sc->bhalq);
+
+	/*
+	 * NB: can't reclaim these until after ieee80211_ifdetach
+	 * returns because we'll get called back to reclaim node
+	 * state and potentially want to use them.
+	 */
+}
+
+
+
+
+/********************\
+* Channel/mode setup *
+\********************/
+
+/*
+ * Convert IEEE channel number to MHz frequency.
+ */
+static inline short
+ath5k_ieee2mhz(short chan)
+{
+	if (chan <= 14 || chan >= 27)
+		return ieee80211chan2mhz(chan);
+	else
+		return 2212 + chan * 20;
+}
+
+static unsigned int 
+ath5k_copy_rates(struct ieee80211_rate *rates,
+		const struct ath5k_rate_table *rt,
+		unsigned int max)
+{
+	unsigned int i, count;
+
+	if (rt == NULL)
+		return 0;
+
+	for (i = 0, count = 0; i < rt->rate_count && max > 0; i++) {
+		if (!rt->rates[i].valid)
+			continue;
+		rates->rate = rt->rates[i].rate_kbps / 100;
+		rates->val = rt->rates[i].rate_code;
+		rates->flags = rt->rates[i].modulation;
+		rates++;
+		count++;
+		max--;
+	}
+
+	return count;
+}
+
+static unsigned int
+ath5k_copy_channels(struct ath5k_hw *ah,
+		struct ieee80211_channel *channels,
+		unsigned int mode,
+		unsigned int max)
+{
+	static const struct { unsigned int mode, mask, chan; } map[] = {
+		[MODE_IEEE80211A] = { CHANNEL_OFDM, CHANNEL_OFDM | CHANNEL_TURBO, CHANNEL_A },
+		[MODE_ATHEROS_TURBO] = { CHANNEL_OFDM|CHANNEL_TURBO, CHANNEL_OFDM | CHANNEL_TURBO, CHANNEL_T },
+		[MODE_IEEE80211B] = { CHANNEL_CCK, CHANNEL_CCK, CHANNEL_B },
+		[MODE_IEEE80211G] = { CHANNEL_OFDM, CHANNEL_OFDM, CHANNEL_G },
+		[MODE_ATHEROS_TURBOG] = { CHANNEL_OFDM | CHANNEL_TURBO, CHANNEL_OFDM | CHANNEL_TURBO, CHANNEL_TG },
+	};
+	static const struct ath5k_regchannel chans_2ghz[] =
+		IEEE80211_CHANNELS_2GHZ;
+	static const struct ath5k_regchannel chans_5ghz[] =
+		IEEE80211_CHANNELS_5GHZ;
+	const struct ath5k_regchannel *chans;
+	enum ath5k_regdom dmn;
+	unsigned int i, count, size, chfreq, all, f, ch;
+
+	if (!test_bit(mode, ah->ah_modes))
+		return 0;
+
+	all = ah->ah_regdomain == DMN_DEFAULT || CHAN_DEBUG == 1;
+
+	switch (mode) {
+	case MODE_IEEE80211A:
+	case MODE_ATHEROS_TURBO:
+		/* 1..220, but 2GHz frequencies are filtered by check_channel */
+		size = all ? 220 : ARRAY_SIZE(chans_5ghz);
+		chans = chans_5ghz;
+		dmn = ath5k_regdom2flag(ah->ah_regdomain,
+				IEEE80211_CHANNELS_5GHZ_MIN);
+		chfreq = CHANNEL_5GHZ;
+		break;
+	case MODE_IEEE80211B:
+	case MODE_IEEE80211G:
+	case MODE_ATHEROS_TURBOG:
+		size = all ? 26 : ARRAY_SIZE(chans_2ghz);
+		chans = chans_2ghz;
+		dmn = ath5k_regdom2flag(ah->ah_regdomain,
+				IEEE80211_CHANNELS_2GHZ_MIN);
+		chfreq = CHANNEL_2GHZ;
+		break;
+	default:
+		printk(KERN_WARNING "bad mode, not copying channels\n");
+		return 0;
+	}
+
+	for (i = 0, count = 0; i < size && max > 0; i++) {
+		ch = all ? i + 1 : chans[i].chan;
+		f = ath5k_ieee2mhz(ch);
+		/* Check if channel is supported by the chipset */
+		if (!ath5k_channel_ok(ah, f, chfreq))
+			continue;
+
+		/* Match regulation domain */
+		if (!all && !(IEEE80211_DMN(chans[i].domain) &
+							IEEE80211_DMN(dmn)))
+			continue;
+
+		if (!all && (chans[i].mode & map[mode].mask) != map[mode].mode)
+			continue;
+
+		/* Write channel and increment counter */
+		channels->chan = ch;
+		channels->freq = f;
+		channels->val = map[mode].chan;
+		channels++;
+		count++;
+		max--;
+	}
+
+	return count;
+}
+
+/* Only tries to register modes our EEPROM says it can support */
+#define REGISTER_MODE(m) do { \
+	ret = ath5k_register_mode(hw, m); \
+	if (ret) \
+		return ret; \
+} while (0) \
+
+static inline int
+ath5k_register_mode(struct ieee80211_hw *hw, u8 m)
+{
+	struct ath5k_softc *sc = hw->priv;
+	struct ieee80211_hw_mode *modes = sc->modes;
+	unsigned int i;
+	int ret;
+
+	if (!test_bit(m, sc->ah->ah_capabilities.cap_mode))
+		return 0;
+
+	for (i = 0; i < NUM_DRIVER_MODES; i++) {
+		if (modes[i].mode != m || !modes[i].num_channels)
+			continue;
+		ret = ieee80211_register_hwmode(hw, &modes[i]);
+		if (ret) {
+			printk(KERN_ERR "can't register hwmode %u\n", m);
+			return ret;
 		}
+		return 0;
+	}
+	BUG();
+}
 
-		skb = bf->skb;
-		bf->skb = NULL;
-		pci_unmap_single(sc->pdev, bf->skbaddr, skb->len,
-				PCI_DMA_TODEVICE);
+static int
+ath5k_getchannels(struct ieee80211_hw *hw)
+{
+	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = sc->ah;
+	struct ieee80211_hw_mode *modes = sc->modes;
+	unsigned int i, max_r, max_c;
+	int ret;
 
-		txs.control = bf->ctl;
-		txs.retry_count = ds->ds_txstat.ts_shortretry +
-			ds->ds_txstat.ts_longretry / 6;
-		if (unlikely(ds->ds_txstat.ts_status)) {
-			sc->ll_stats.dot11ACKFailureCount++;
-			if (ds->ds_txstat.ts_status & AR5K_TXERR_XRETRY)
-				txs.excessive_retries = 1;
-			else if (ds->ds_txstat.ts_status & AR5K_TXERR_FILT)
-				txs.flags |= IEEE80211_TX_STATUS_TX_FILTERED;
+	BUILD_BUG_ON(ARRAY_SIZE(sc->modes) < 3);
+
+	/* The order here does not matter */
+	modes[0].mode = MODE_IEEE80211G;
+	modes[1].mode = MODE_IEEE80211B;
+	modes[2].mode = MODE_IEEE80211A;
+
+	max_r = ARRAY_SIZE(sc->rates);
+	max_c = ARRAY_SIZE(sc->channels);
+
+	for (i = 0; i < NUM_DRIVER_MODES; i++) {
+		struct ieee80211_hw_mode *mode = &modes[i];
+		const struct ath5k_rate_table *hw_rates;
+
+		if (i == 0) {
+			modes[0].rates	= sc->rates;
+			modes->channels	= sc->channels;
 		} else {
-			txs.flags |= IEEE80211_TX_STATUS_ACK;
-			txs.ack_signal = ds->ds_txstat.ts_rssi;
+			struct ieee80211_hw_mode *prev_mode = &modes[i-1];
+			int prev_num_r	= prev_mode->num_rates;
+			int prev_num_c	= prev_mode->num_channels;
+			mode->rates	= &prev_mode->rates[prev_num_r];
+			mode->channels	= &prev_mode->channels[prev_num_c];
 		}
 
-		ieee80211_tx_status(sc->hw, skb, &txs);
-		sc->tx_stats.data[txq->qnum].count++;
+		hw_rates = ath5k_hw_get_rate_table(ah, mode->mode);
+		mode->num_rates    = ath5k_copy_rates(mode->rates, hw_rates,
+			max_r);
+		mode->num_channels = ath5k_copy_channels(ah, mode->channels,
+			mode->mode, max_c);
+		max_r -= mode->num_rates;
+		max_c -= mode->num_channels;
+	}
 
-		spin_lock(&sc->txbuflock);
-		sc->tx_stats.data[txq->qnum].len--;
-		list_move_tail(&bf->list, &sc->txbuf);
-		sc->txbuf_len++;
-		spin_unlock(&sc->txbuflock);
+	/* We try to register all modes this driver supports. We don't bother
+	 * with MODE_IEEE80211B for AR5212 as MODE_IEEE80211G already accounts
+	 * for that as per mac80211. Then, REGISTER_MODE() will will actually
+	 * check the eeprom reading for more reliable capability information.
+	 * Order matters here as per mac80211's latest preference. This will
+	 * all hopefullly soon go away. */
+
+	REGISTER_MODE(MODE_IEEE80211G);
+	if (ah->ah_version != AR5K_AR5212)
+		REGISTER_MODE(MODE_IEEE80211B);
+	REGISTER_MODE(MODE_IEEE80211A);
+
+	ath5k_dump_modes(modes);
+
+	return ret;
+}
+
+/*
+ * Set/change channels.  If the channel is really being changed,
+ * it's done by reseting the chip.  To accomplish this we must
+ * first cleanup any pending DMA, then restart stuff after a la
+ * ath5k_init.
+ */
+static int
+ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
+{
+	struct ath5k_hw *ah = sc->ah;
+	int ret;
+
+	DPRINTF(sc, ATH_DEBUG_RESET, "%s: %u (%u MHz) -> %u (%u MHz)\n",
+		__func__, sc->curchan->chan, sc->curchan->freq,
+		chan->chan, chan->freq);
+
+	if (chan->freq != sc->curchan->freq || chan->val != sc->curchan->val) {
+		/*
+		 * To switch channels clear any pending DMA operations;
+		 * wait long enough for the RX fifo to drain, reset the
+		 * hardware at the new frequency, and then re-enable
+		 * the relevant bits of the h/w.
+		 */
+		ath5k_hw_set_intr(ah, 0);	/* disable interrupts */
+		ath5k_draintxq(sc);		/* clear pending tx frames */
+		ath5k_stoprecv(sc);		/* turn off frame recv */
+		ret = ath5k_hw_reset(ah, sc->opmode, chan, true);
+		if (ret) {
+			printk(KERN_ERR "%s: unable to reset channel %u "
+				"(%u Mhz)\n", __func__, chan->chan, chan->freq);
+			return ret;
+		}
+		sc->curchan = chan;
+		ath5k_update_txpow(sc);
+
+		/*
+		 * Re-enable rx framework.
+		 */
+		ret = ath5k_startrecv(sc);
+		if (ret) {
+			printk(KERN_ERR "%s: unable to restart recv logic\n",
+					__func__);
+			return ret;
+		}
+
+		/*
+		 * Change channels and update the h/w rate map
+		 * if we're switching; e.g. 11a to 11b/g.
+		 *
+		 * XXX needed?
+		 */
+/*		ath5k_chan_change(sc, chan); */
+
+		/*
+		 * Re-enable interrupts.
+		 */
+		ath5k_hw_set_intr(ah, sc->imask);
 	}
-	if (likely(list_empty(&txq->q)))
-		txq->link = NULL;
-	spin_unlock(&txq->lock);
-	if (sc->txbuf_len > ATH_TXBUF / 5)
-		ieee80211_wake_queues(sc->hw);
+
+	return 0;
 }
 
-static void ath5k_tasklet_tx(unsigned long data)
+static void
+ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
 {
-	struct ath5k_softc *sc = (void *)data;
+	if (unlikely(test_bit(ATH_STAT_LEDSOFT, sc->status))) {
+		/* from Atheros NDIS driver, w/ permission */
+		static const struct {
+			u16 rate;	/* tx/rx 802.11 rate */
+			u16 timeOn;	/* LED on time (ms) */
+			u16 timeOff;	/* LED off time (ms) */
+		} blinkrates[] = {
+			{ 108,  40,  10 },
+			{  96,  44,  11 },
+			{  72,  50,  13 },
+			{  48,  57,  14 },
+			{  36,  67,  16 },
+			{  24,  80,  20 },
+			{  22, 100,  25 },
+			{  18, 133,  34 },
+			{  12, 160,  40 },
+			{  10, 200,  50 },
+			{   6, 240,  58 },
+			{   4, 267,  66 },
+			{   2, 400, 100 },
+			{   0, 500, 130 }
+		};
+		const struct ath5k_rate_table *rt =
+				ath5k_hw_get_rate_table(sc->ah, mode);
+		unsigned int i, j;
 
-	ath5k_tx_processq(sc, sc->txq);
+		BUG_ON(rt == NULL);
 
-	ath5k_led_event(sc, ATH_LED_TX);
+		memset(sc->hwmap, 0, sizeof(sc->hwmap));
+		for (i = 0; i < 32; i++) {
+			u8 ix = rt->rate_code_to_index[i];
+			if (ix == 0xff) {
+				sc->hwmap[i].ledon = msecs_to_jiffies(500);
+				sc->hwmap[i].ledoff = msecs_to_jiffies(130);
+				continue;
+			}
+			sc->hwmap[i].txflags = IEEE80211_RADIOTAP_F_DATAPAD;
+			if (SHPREAMBLE_FLAG(ix) || rt->rates[ix].modulation ==
+					IEEE80211_RATE_OFDM)
+				sc->hwmap[i].txflags |=
+						IEEE80211_RADIOTAP_F_SHORTPRE;
+			/* receive frames include FCS */
+			sc->hwmap[i].rxflags = sc->hwmap[i].txflags |
+					IEEE80211_RADIOTAP_F_FCS;
+			/* setup blink rate table to avoid per-packet lookup */
+			for (j = 0; j < ARRAY_SIZE(blinkrates) - 1; j++)
+				if (blinkrates[j].rate == /* XXX why 7f? */
+						(rt->rates[ix].dot11_rate&0x7f))
+					break;
+
+			sc->hwmap[i].ledon = msecs_to_jiffies(blinkrates[j].
+					timeOn);
+			sc->hwmap[i].ledoff = msecs_to_jiffies(blinkrates[j].
+					timeOff);
+		}
+	}
+
+	sc->curmode = mode;
+}
+
+static void 
+ath5k_mode_init(struct ath5k_softc *sc)
+{
+	struct ath5k_hw *ah = sc->ah;
+	u32 rfilt;
+
+	/* configure rx filter */
+	rfilt = sc->filter_flags;
+	ath5k_hw_set_rx_filter(ah, rfilt);
+
+	if (ath5k_hw_hasbssidmask(ah))
+		ath5k_hw_set_bssid_mask(ah, sc->bssidmask);
+
+	/* configure operational mode */
+	ath5k_hw_set_opmode(ah);
+
+	ath5k_hw_set_mcast_filter(ah, 0, 0);
+	DPRINTF(sc, ATH_DEBUG_MODE, "%s: RX filter 0x%x\n", __func__, rfilt);
+}
+
+
+
+
+/*******************\
+* Descriptors setup *
+\*******************/
+
+static int
+ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
+{
+	struct ath5k_desc *ds;
+	struct ath5k_buf *bf;
+	dma_addr_t da;
+	unsigned int i;
+	int ret;
+
+	/* allocate descriptors */
+	sc->desc_len = sizeof(struct ath5k_desc) *
+			(ATH_TXBUF + ATH_RXBUF + ATH_BCBUF + 1);
+	sc->desc = pci_alloc_consistent(pdev, sc->desc_len, &sc->desc_daddr);
+	if (sc->desc == NULL) {
+		dev_err(&pdev->dev, "can't allocate descriptors\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+	ds = sc->desc;
+	da = sc->desc_daddr;
+	DPRINTF(sc, ATH_DEBUG_ANY, "%s: DMA map: %p (%zu) -> %llx\n",
+		__func__, ds, sc->desc_len, (unsigned long long)sc->desc_daddr);
+
+	bf = kcalloc(1 + ATH_TXBUF + ATH_RXBUF + ATH_BCBUF,
+			sizeof(struct ath5k_buf), GFP_KERNEL);
+	if (bf == NULL) {
+		dev_err(&pdev->dev, "can't allocate bufptr\n");
+		ret = -ENOMEM;
+		goto err_free;
+	}
+	sc->bufptr = bf;
+
+	INIT_LIST_HEAD(&sc->rxbuf);
+	for (i = 0; i < ATH_RXBUF; i++, bf++, ds++, da += sizeof(*ds)) {
+		bf->desc = ds;
+		bf->daddr = da;
+		list_add_tail(&bf->list, &sc->rxbuf);
+	}
+
+	INIT_LIST_HEAD(&sc->txbuf);
+	sc->txbuf_len = ATH_TXBUF;
+	for (i = 0; i < ATH_TXBUF; i++, bf++, ds++,
+			da += sizeof(*ds)) {
+		bf->desc = ds;
+		bf->daddr = da;
+		list_add_tail(&bf->list, &sc->txbuf);
+	}
+
+	/* beacon buffer */
+	bf->desc = ds;
+	bf->daddr = da;
+	sc->bbuf = bf;
+
+	return 0;
+err_free:
+	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
+err:
+	sc->desc = NULL;
+	return ret;
+}
+
+static void
+ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
+{
+	struct ath5k_buf *bf;
+
+	ath5k_cleanup_txbuf(sc, sc->bbuf);
+	list_for_each_entry(bf, &sc->txbuf, list)
+		ath5k_cleanup_txbuf(sc, bf);
+	list_for_each_entry(bf, &sc->rxbuf, list)
+		ath5k_cleanup_txbuf(sc, bf);
+
+	/* Free memory associated with all descriptors */
+	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
+
+	kfree(sc->bufptr);
+	sc->bufptr = NULL;
 }
 
-static int ath5k_rxbuf_init(struct ath5k_softc *sc, struct ath5k_buf *bf)
+
+
+
+/***************\
+* Buffers setup *
+\***************/
+
+static int
+ath5k_rxbuf_init(struct ath5k_softc *sc, struct ath5k_buf *bf)
 {
 	struct ath5k_hw *ah = sc->ah;
 	struct sk_buff *skb = bf->skb;
@@ -318,8 +1353,337 @@ static int ath5k_rxbuf_init(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	return 0;
 }
 
-static unsigned int ath5k_rx_decrypted(struct ath5k_softc *sc,
-		struct ath5k_desc *ds, struct sk_buff *skb)
+static int
+ath5k_tx_bf(struct ath5k_softc *sc, struct ath5k_buf *bf,
+		struct ieee80211_tx_control *ctl)
+{
+	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_txq *txq = sc->txq;
+	struct ath5k_desc *ds = bf->desc;
+	struct sk_buff *skb = bf->skb;
+	unsigned int pktlen, flags, keyidx = AR5K_TXKEYIX_INVALID;
+	int ret;
+
+	flags = AR5K_TXDESC_INTREQ | AR5K_TXDESC_CLRDMASK;
+	bf->ctl = *ctl;
+	/* XXX endianness */
+	bf->skbaddr = pci_map_single(sc->pdev, skb->data, skb->len,
+			PCI_DMA_TODEVICE);
+
+	if (ctl->flags & IEEE80211_TXCTL_NO_ACK)
+		flags |= AR5K_TXDESC_NOACK;
+
+	pktlen = skb->len + FCS_LEN;
+
+	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT)) {
+		keyidx = ctl->key_idx;
+		pktlen += ctl->icv_len;
+	}
+
+	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
+		ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
+		0xffff, ctl->tx_rate, ctl->retry_limit, keyidx, 0, flags, 0, 0);
+	if (ret)
+		goto err_unmap;
+
+	ds->ds_link = 0;
+	ds->ds_data = bf->skbaddr;
+
+	ret = ah->ah_fill_tx_desc(ah, ds, skb->len, true, true);
+	if (ret)
+		goto err_unmap;
+
+	spin_lock_bh(&txq->lock);
+	list_add_tail(&bf->list, &txq->q);
+	sc->tx_stats.data[txq->qnum].len++;
+	if (txq->link == NULL) /* is this first packet? */
+		ath5k_hw_put_tx_buf(ah, txq->qnum, bf->daddr);
+	else /* no, so only link it */
+		*txq->link = bf->daddr;
+
+	txq->link = &ds->ds_link;
+	ath5k_hw_tx_start(ah, txq->qnum);
+	spin_unlock_bh(&txq->lock);
+
+	return 0;
+err_unmap:
+	pci_unmap_single(sc->pdev, bf->skbaddr, skb->len, PCI_DMA_TODEVICE);
+	return ret;
+}
+
+static inline void
+ath5k_cleanup_txbuf(struct ath5k_softc *sc, struct ath5k_buf *bf)
+{
+	BUG_ON(!bf);
+	if (!bf->skb)
+		return;
+	pci_unmap_single(sc->pdev, bf->skbaddr, bf->skb->len,
+			PCI_DMA_TODEVICE);
+	dev_kfree_skb(bf->skb);
+	bf->skb = NULL;
+}
+
+
+
+
+/**************\
+* Queues setup *
+\**************/
+
+static struct ath5k_txq *
+ath5k_txq_setup(struct ath5k_softc *sc,
+		int qtype, int subtype)
+{
+	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_txq *txq;
+	struct ath5k_txq_info qi = {
+		.tqi_subtype = subtype,
+		.tqi_aifs = AR5K_TXQ_USEDEFAULT,
+		.tqi_cw_min = AR5K_TXQ_USEDEFAULT,
+		.tqi_cw_max = AR5K_TXQ_USEDEFAULT
+	};
+	int qnum;
+
+	/*
+	 * Enable interrupts only for EOL and DESC conditions.
+	 * We mark tx descriptors to receive a DESC interrupt
+	 * when a tx queue gets deep; otherwise waiting for the
+	 * EOL to reap descriptors.  Note that this is done to
+	 * reduce interrupt load and this only defers reaping
+	 * descriptors, never transmitting frames.  Aside from
+	 * reducing interrupts this also permits more concurrency.
+	 * The only potential downside is if the tx queue backs
+	 * up in which case the top half of the kernel may backup
+	 * due to a lack of tx descriptors.
+	 */
+	qi.tqi_flags = AR5K_TXQ_FLAG_TXEOLINT_ENABLE |
+				AR5K_TXQ_FLAG_TXDESCINT_ENABLE;
+	qnum = ath5k_hw_setup_tx_queue(ah, qtype, &qi);
+	if (qnum < 0) {
+		/*
+		 * NB: don't print a message, this happens
+		 * normally on parts with too few tx queues
+		 */
+		return ERR_PTR(qnum);
+	}
+	if (qnum >= ARRAY_SIZE(sc->txqs)) {
+		printk(KERN_ERR "hw qnum %u out of range, max %tu!\n",
+			qnum, ARRAY_SIZE(sc->txqs));
+		ath5k_hw_release_tx_queue(ah, qnum);
+		return ERR_PTR(-EINVAL);
+	}
+	txq = &sc->txqs[qnum];
+	if (!txq->setup) {
+		txq->qnum = qnum;
+		txq->link = NULL;
+		INIT_LIST_HEAD(&txq->q);
+		spin_lock_init(&txq->lock);
+		txq->setup = true;
+	}
+	return &sc->txqs[qnum];
+}
+
+static int
+ath5k_beaconq_setup(struct ath5k_hw *ah)
+{
+	struct ath5k_txq_info qi = {
+		.tqi_aifs = AR5K_TXQ_USEDEFAULT,
+		.tqi_cw_min = AR5K_TXQ_USEDEFAULT,
+		.tqi_cw_max = AR5K_TXQ_USEDEFAULT,
+		/* NB: for dynamic turbo, don't enable any other interrupts */
+		.tqi_flags = AR5K_TXQ_FLAG_TXDESCINT_ENABLE
+	};
+
+	return ath5k_hw_setup_tx_queue(ah, AR5K_TX_QUEUE_BEACON, &qi);
+}
+
+static int
+ath5k_beaconq_config(struct ath5k_softc *sc)
+{
+	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_txq_info qi;
+	int ret;
+
+	ret = ath5k_hw_get_tx_queueprops(ah, sc->bhalq, &qi);
+	if (ret)
+		return ret;
+	if (sc->opmode == IEEE80211_IF_TYPE_AP ||
+			sc->opmode == IEEE80211_IF_TYPE_IBSS) {
+		/*
+		 * Always burst out beacon and CAB traffic
+		 * (aifs = cwmin = cwmax = 0)
+		 */
+		qi.tqi_aifs = 0;
+		qi.tqi_cw_min = 0;
+		qi.tqi_cw_max = 0;
+	}
+
+	ret = ath5k_hw_setup_tx_queueprops(ah, sc->bhalq, &qi);
+	if (ret) {
+		printk(KERN_ERR "%s: unable to update parameters for beacon "
+			"hardware queue!\n", __func__);
+		return ret;
+	}
+
+	return ath5k_hw_reset_tx_queue(ah, sc->bhalq); /* push to h/w */;
+}
+
+static void
+ath5k_tx_draintxq(struct ath5k_softc *sc, struct ath5k_txq *txq)
+{
+	struct ath5k_buf *bf, *bf0;
+
+	/*
+	 * NB: this assumes output has been stopped and
+	 *     we do not need to block ath5k_tx_tasklet
+	 */
+	spin_lock_bh(&txq->lock);
+	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
+#if AR_DEBUG
+		if (sc->debug & ATH_DEBUG_RESET)
+			ath5k_printtxbuf(bf, !sc->ah->ah_proc_tx_desc(sc->ah,
+						bf->desc));
+#endif
+		ath5k_cleanup_txbuf(sc, bf);
+
+		spin_lock_bh(&sc->txbuflock);
+		sc->tx_stats.data[txq->qnum].len--;
+		list_move_tail(&bf->list, &sc->txbuf);
+		sc->txbuf_len++;
+		spin_unlock_bh(&sc->txbuflock);
+	}
+	txq->link = NULL;
+	spin_unlock_bh(&txq->lock);
+}
+
+/*
+ * Drain the transmit queues and reclaim resources.
+ */
+static void
+ath5k_draintxq(struct ath5k_softc *sc)
+{
+	struct ath5k_hw *ah = sc->ah;
+	unsigned int i;
+
+	/* XXX return value */
+	if (likely(!test_bit(ATH_STAT_INVALID, sc->status))) {
+		/* don't touch the hardware if marked invalid */
+		(void)ath5k_hw_stop_tx_dma(ah, sc->bhalq);
+		DPRINTF(sc, ATH_DEBUG_RESET, "%s: beacon queue %x\n", __func__,
+			ath5k_hw_get_tx_buf(ah, sc->bhalq));
+		for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
+			if (sc->txqs[i].setup) {
+				ath5k_hw_stop_tx_dma(ah, sc->txqs[i].qnum);
+				DPRINTF(sc, ATH_DEBUG_RESET, "%s: txq [%u] %x, "
+					"link %p\n", __func__,
+					sc->txqs[i].qnum,
+					ath5k_hw_get_tx_buf(ah,
+							sc->txqs[i].qnum),
+					sc->txqs[i].link);
+			}
+	}
+	ieee80211_start_queues(sc->hw); /* XXX move to callers */
+
+	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
+		if (sc->txqs[i].setup)
+			ath5k_tx_draintxq(sc, &sc->txqs[i]);
+}
+
+static void
+ath5k_tx_cleanup(struct ath5k_softc *sc)
+{
+	struct ath5k_txq *txq = sc->txqs;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++, txq++)
+		if (txq->setup) {
+			ath5k_hw_release_tx_queue(sc->ah, txq->qnum);
+			txq->setup = false;
+		}
+}
+
+
+
+
+/*************\
+* RX Handling *
+\*************/
+
+/*
+ * Enable the receive h/w following a reset.
+ */
+static int
+ath5k_startrecv(struct ath5k_softc *sc)
+{
+	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_buf *bf;
+	int ret;
+
+	sc->rxbufsize = roundup(IEEE80211_MAX_LEN, sc->cachelsz);
+
+	DPRINTF(sc, ATH_DEBUG_RESET, "%s: cachelsz %u rxbufsize %u\n",
+		__func__, sc->cachelsz, sc->rxbufsize);
+
+	sc->rxlink = NULL;
+
+	spin_lock_bh(&sc->rxbuflock);
+	list_for_each_entry(bf, &sc->rxbuf, list) {
+		ret = ath5k_rxbuf_init(sc, bf);
+		if (ret != 0) {
+			spin_unlock_bh(&sc->rxbuflock);
+			goto err;
+		}
+	}
+	bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
+	spin_unlock_bh(&sc->rxbuflock);
+
+	ath5k_hw_put_rx_buf(ah, bf->daddr);
+	ath5k_hw_start_rx(ah);		/* enable recv descriptors */
+	ath5k_mode_init(sc);		/* set filters, etc. */
+	ath5k_hw_start_rx_pcu(ah);	/* re-enable PCU/DMA engine */
+
+	return 0;
+err:
+	return ret;
+}
+
+/*
+ * Disable the receive h/w in preparation for a reset.
+ */
+static void
+ath5k_stoprecv(struct ath5k_softc *sc)
+{
+	struct ath5k_hw *ah = sc->ah;
+
+	ath5k_hw_stop_pcu_recv(ah);	/* disable PCU */
+	ath5k_hw_set_rx_filter(ah, 0);	/* clear recv filter */
+	ath5k_hw_stop_rx_dma(ah);	/* disable DMA engine */
+	mdelay(3);			/* 3ms is long enough for 1 frame */
+#if AR_DEBUG
+	if (unlikely(sc->debug & (ATH_DEBUG_RESET | ATH_DEBUG_FATAL))) {
+		struct ath5k_desc *ds;
+		struct ath5k_buf *bf;
+		int status;
+
+		printk(KERN_DEBUG "%s: rx queue %x, link %p\n", __func__,
+			ath5k_hw_get_rx_buf(ah), sc->rxlink);
+
+		spin_lock_bh(&sc->rxbuflock);
+		list_for_each_entry(bf, &sc->rxbuf, list) {
+			ds = bf->desc;
+			status = ah->ah_proc_rx_desc(ah, ds);
+			if (!status || (sc->debug & ATH_DEBUG_FATAL))
+				ath5k_printrxbuf(bf, status == 0);
+		}
+		spin_unlock_bh(&sc->rxbuflock);
+	}
+#endif
+	sc->rxlink = NULL;		/* just in case */
+}
+
+static unsigned int 
+ath5k_rx_decrypted(struct ath5k_softc *sc, struct ath5k_desc *ds,
+		struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	unsigned int keyix, hlen = ieee80211_get_hdrlen_from_skb(skb);
@@ -343,17 +1707,8 @@ static unsigned int ath5k_rx_decrypted(struct ath5k_softc *sc,
 	return 0;
 }
 
-static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
-{
-	u64 tsf = ath5k_hw_get_tsf64(ah);
-
-	if ((tsf & 0x7fff) < rstamp)
-		tsf -= 0x8000;
-
-	return (tsf & ~0x7fff) | rstamp;
-}
-
-static void ath5k_tasklet_rx(unsigned long data)
+static void
+ath5k_tasklet_rx(unsigned long data)
 {
 	struct ieee80211_rx_status rxs = {};
 	struct sk_buff *skb;
@@ -477,10 +1832,95 @@ next:
 	spin_unlock(&sc->rxbuflock);
 }
 
+
+
+
+/*************\
+* TX Handling *
+\*************/
+
+static void
+ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
+{
+	struct ieee80211_tx_status txs = {};
+	struct ath5k_buf *bf, *bf0;
+	struct ath5k_desc *ds;
+	struct sk_buff *skb;
+	int ret;
+
+	spin_lock(&txq->lock);
+	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
+		ds = bf->desc;
+
+		/* TODO only one segment */
+		pci_dma_sync_single_for_cpu(sc->pdev, sc->desc_daddr,
+				sc->desc_len, PCI_DMA_FROMDEVICE);
+		ret = sc->ah->ah_proc_tx_desc(sc->ah, ds);
+		if (unlikely(ret == -EINPROGRESS))
+			break;
+		else if (unlikely(ret)) {
+			printk(KERN_ERR "ath: error %d while processing "
+				"queue %u\n", ret, txq->qnum);
+			break;
+		}
+
+		skb = bf->skb;
+		bf->skb = NULL;
+		pci_unmap_single(sc->pdev, bf->skbaddr, skb->len,
+				PCI_DMA_TODEVICE);
+
+		txs.control = bf->ctl;
+		txs.retry_count = ds->ds_txstat.ts_shortretry +
+			ds->ds_txstat.ts_longretry / 6;
+		if (unlikely(ds->ds_txstat.ts_status)) {
+			sc->ll_stats.dot11ACKFailureCount++;
+			if (ds->ds_txstat.ts_status & AR5K_TXERR_XRETRY)
+				txs.excessive_retries = 1;
+			else if (ds->ds_txstat.ts_status & AR5K_TXERR_FILT)
+				txs.flags |= IEEE80211_TX_STATUS_TX_FILTERED;
+		} else {
+			txs.flags |= IEEE80211_TX_STATUS_ACK;
+			txs.ack_signal = ds->ds_txstat.ts_rssi;
+		}
+
+		ieee80211_tx_status(sc->hw, skb, &txs);
+		sc->tx_stats.data[txq->qnum].count++;
+
+		spin_lock(&sc->txbuflock);
+		sc->tx_stats.data[txq->qnum].len--;
+		list_move_tail(&bf->list, &sc->txbuf);
+		sc->txbuf_len++;
+		spin_unlock(&sc->txbuflock);
+	}
+	if (likely(list_empty(&txq->q)))
+		txq->link = NULL;
+	spin_unlock(&txq->lock);
+	if (sc->txbuf_len > ATH_TXBUF / 5)
+		ieee80211_wake_queues(sc->hw);
+}
+
+static void
+ath5k_tasklet_tx(unsigned long data)
+{
+	struct ath5k_softc *sc = (void *)data;
+
+	ath5k_tx_processq(sc, sc->txq);
+
+	ath5k_led_event(sc, ATH_LED_TX);
+}
+
+
+
+
+/*****************\
+* Beacon handling *
+\*****************/
+
 /*
  * Setup the beacon frame for transmit.
  */
-static int ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
+static int
+ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 		struct ieee80211_tx_control *ctl)
 {
 	struct sk_buff *skb = bf->skb;
@@ -545,7 +1985,8 @@ err_unmap:
  * but also from ath5k_beacon_config() in IBSS mode which in turn
  * can be called from a tasklet and user context
  */
-static void ath5k_beacon_send(struct ath5k_softc *sc)
+static void
+ath5k_beacon_send(struct ath5k_softc *sc)
 {
 	struct ath5k_buf *bf = sc->bbuf;
 	struct ath5k_hw *ah = sc->ah;
@@ -606,36 +2047,6 @@ static void ath5k_beacon_send(struct ath5k_softc *sc)
 	sc->bsent++;
 }
 
-static int ath5k_beaconq_config(struct ath5k_softc *sc)
-{
-	struct ath5k_hw *ah = sc->ah;
-	struct ath5k_txq_info qi;
-	int ret;
-
-	ret = ath5k_hw_get_tx_queueprops(ah, sc->bhalq, &qi);
-	if (ret)
-		return ret;
-	if (sc->opmode == IEEE80211_IF_TYPE_AP ||
-			sc->opmode == IEEE80211_IF_TYPE_IBSS) {
-		/*
-		 * Always burst out beacon and CAB traffic
-		 * (aifs = cwmin = cwmax = 0)
-		 */
-		qi.tqi_aifs = 0;
-		qi.tqi_cw_min = 0;
-		qi.tqi_cw_max = 0;
-	}
-
-	ret = ath5k_hw_setup_tx_queueprops(ah, sc->bhalq, &qi);
-	if (ret) {
-		printk(KERN_ERR "%s: unable to update parameters for beacon "
-			"hardware queue!\n", __func__);
-		return ret;
-	}
-
-	return ath5k_hw_reset_tx_queue(ah, sc->bhalq); /* push to h/w */;
-}
-
 /*
  * Configure the beacon and sleep timers.
  *
@@ -651,7 +2062,8 @@ static int ath5k_beaconq_config(struct ath5k_softc *sc)
  * interrupt when we stop seeing beacons from the AP
  * we've associated with.
  */
-static void ath5k_beacon_config(struct ath5k_softc *sc)
+static void
+ath5k_beacon_config(struct ath5k_softc *sc)
 {
 #define TSF_TO_TU(_h, _l)	(((_h) << 22) | ((_l) >> 10))
 	struct ath5k_hw *ah = sc->ah;
@@ -718,70 +2130,26 @@ static void ath5k_beacon_config(struct ath5k_softc *sc)
 #undef TSF_TO_TU
 }
 
-static void ath5k_mode_init(struct ath5k_softc *sc)
+static inline
+u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
 {
-	struct ath5k_hw *ah = sc->ah;
-	u32 rfilt;
-
-	/* configure rx filter */
-	rfilt = sc->filter_flags;
-	ath5k_hw_set_rx_filter(ah, rfilt);
-
-	if (ath5k_hw_hasbssidmask(ah))
-		ath5k_hw_set_bssid_mask(ah, sc->bssidmask);
+	u64 tsf = ath5k_hw_get_tsf64(ah);
 
-	/* configure operational mode */
-	ath5k_hw_set_opmode(ah);
+	if ((tsf & 0x7fff) < rstamp)
+		tsf -= 0x8000;
 
-	ath5k_hw_set_mcast_filter(ah, 0, 0);
-	DPRINTF(sc, ATH_DEBUG_MODE, "%s: RX filter 0x%x\n", __func__, rfilt);
+	return (tsf & ~0x7fff) | rstamp;
 }
 
-/*
- * Enable the receive h/w following a reset.
- */
-static int ath5k_startrecv(struct ath5k_softc *sc)
-{
-	struct ath5k_hw *ah = sc->ah;
-	struct ath5k_buf *bf;
-	int ret;
-
-	sc->rxbufsize = roundup(IEEE80211_MAX_LEN, sc->cachelsz);
-
-	DPRINTF(sc, ATH_DEBUG_RESET, "%s: cachelsz %u rxbufsize %u\n",
-		__func__, sc->cachelsz, sc->rxbufsize);
-
-	sc->rxlink = NULL;
-
-	spin_lock_bh(&sc->rxbuflock);
-	list_for_each_entry(bf, &sc->rxbuf, list) {
-		ret = ath5k_rxbuf_init(sc, bf);
-		if (ret != 0) {
-			spin_unlock_bh(&sc->rxbuflock);
-			goto err;
-		}
-	}
-	bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
-	spin_unlock_bh(&sc->rxbuflock);
-
-	ath5k_hw_put_rx_buf(ah, bf->daddr);
-	ath5k_hw_start_rx(ah);		/* enable recv descriptors */
-	ath5k_mode_init(sc);		/* set filters, etc. */
-	ath5k_hw_start_rx_pcu(ah);	/* re-enable PCU/DMA engine */
 
-	return 0;
-err:
-	return ret;
-}
 
-static inline void ath5k_update_txpow(struct ath5k_softc *sc)
-{
-	ath5k_hw_set_txpower_limit(sc->ah, 0);
-}
 
-static int ath5k_stop_locked(struct ath5k_softc *);
+/********************\
+* Interrupt handling *
+\********************/
 
-static int ath5k_init(struct ath5k_softc *sc)
+static int
+ath5k_init(struct ath5k_softc *sc)
 {
 	int ret;
 
@@ -842,99 +2210,8 @@ done:
 	return ret;
 }
 
-/*
- * Disable the receive h/w in preparation for a reset.
- */
-static void ath5k_stoprecv(struct ath5k_softc *sc)
-{
-	struct ath5k_hw *ah = sc->ah;
-
-	ath5k_hw_stop_pcu_recv(ah);	/* disable PCU */
-	ath5k_hw_set_rx_filter(ah, 0);	/* clear recv filter */
-	ath5k_hw_stop_rx_dma(ah);	/* disable DMA engine */
-	mdelay(3);			/* 3ms is long enough for 1 frame */
-#if AR_DEBUG
-	if (unlikely(sc->debug & (ATH_DEBUG_RESET | ATH_DEBUG_FATAL))) {
-		struct ath5k_desc *ds;
-		struct ath5k_buf *bf;
-		int status;
-
-		printk(KERN_DEBUG "%s: rx queue %x, link %p\n", __func__,
-			ath5k_hw_get_rx_buf(ah), sc->rxlink);
-
-		spin_lock_bh(&sc->rxbuflock);
-		list_for_each_entry(bf, &sc->rxbuf, list) {
-			ds = bf->desc;
-			status = ah->ah_proc_rx_desc(ah, ds);
-			if (!status || (sc->debug & ATH_DEBUG_FATAL))
-				ath5k_printrxbuf(bf, status == 0);
-		}
-		spin_unlock_bh(&sc->rxbuflock);
-	}
-#endif
-	sc->rxlink = NULL;		/* just in case */
-}
-
-static void ath5k_tx_draintxq(struct ath5k_softc *sc, struct ath5k_txq *txq)
-{
-	struct ath5k_buf *bf, *bf0;
-
-	/*
-	 * NB: this assumes output has been stopped and
-	 *     we do not need to block ath5k_tx_tasklet
-	 */
-	spin_lock_bh(&txq->lock);
-	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
-#if AR_DEBUG
-		if (sc->debug & ATH_DEBUG_RESET)
-			ath5k_printtxbuf(bf, !sc->ah->ah_proc_tx_desc(sc->ah,
-						bf->desc));
-#endif
-		ath5k_cleanup_txbuf(sc, bf);
-
-		spin_lock_bh(&sc->txbuflock);
-		sc->tx_stats.data[txq->qnum].len--;
-		list_move_tail(&bf->list, &sc->txbuf);
-		sc->txbuf_len++;
-		spin_unlock_bh(&sc->txbuflock);
-	}
-	txq->link = NULL;
-	spin_unlock_bh(&txq->lock);
-}
-
-/*
- * Drain the transmit queues and reclaim resources.
- */
-static void ath5k_draintxq(struct ath5k_softc *sc)
-{
-	struct ath5k_hw *ah = sc->ah;
-	unsigned int i;
-
-	/* XXX return value */
-	if (likely(!test_bit(ATH_STAT_INVALID, sc->status))) {
-		/* don't touch the hardware if marked invalid */
-		(void)ath5k_hw_stop_tx_dma(ah, sc->bhalq);
-		DPRINTF(sc, ATH_DEBUG_RESET, "%s: beacon queue %x\n", __func__,
-			ath5k_hw_get_tx_buf(ah, sc->bhalq));
-		for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
-			if (sc->txqs[i].setup) {
-				ath5k_hw_stop_tx_dma(ah, sc->txqs[i].qnum);
-				DPRINTF(sc, ATH_DEBUG_RESET, "%s: txq [%u] %x, "
-					"link %p\n", __func__,
-					sc->txqs[i].qnum,
-					ath5k_hw_get_tx_buf(ah,
-							sc->txqs[i].qnum),
-					sc->txqs[i].link);
-			}
-	}
-	ieee80211_start_queues(sc->hw); /* XXX move to callers */
-
-	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
-		if (sc->txqs[i].setup)
-			ath5k_tx_draintxq(sc, &sc->txqs[i]);
-}
-
-static int ath5k_stop_locked(struct ath5k_softc *sc)
+static int
+ath5k_stop_locked(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
 
@@ -982,7 +2259,8 @@ static int ath5k_stop_locked(struct ath5k_softc *sc)
  * if another thread does a system call and the thread doing the
  * stop is preempted).
  */
-static int ath5k_stop_hw(struct ath5k_softc *sc)
+static int
+ath5k_stop_hw(struct ath5k_softc *sc)
 {
 	int ret;
 
@@ -1020,188 +2298,185 @@ static int ath5k_stop_hw(struct ath5k_softc *sc)
 	return ret;
 }
 
-static void ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
+static irqreturn_t
+ath5k_intr(int irq, void *dev_id)
 {
-	if (unlikely(test_bit(ATH_STAT_LEDSOFT, sc->status))) {
-		/* from Atheros NDIS driver, w/ permission */
-		static const struct {
-			u16 rate;	/* tx/rx 802.11 rate */
-			u16 timeOn;	/* LED on time (ms) */
-			u16 timeOff;	/* LED off time (ms) */
-		} blinkrates[] = {
-			{ 108,  40,  10 },
-			{  96,  44,  11 },
-			{  72,  50,  13 },
-			{  48,  57,  14 },
-			{  36,  67,  16 },
-			{  24,  80,  20 },
-			{  22, 100,  25 },
-			{  18, 133,  34 },
-			{  12, 160,  40 },
-			{  10, 200,  50 },
-			{   6, 240,  58 },
-			{   4, 267,  66 },
-			{   2, 400, 100 },
-			{   0, 500, 130 }
-		};
-		const struct ath5k_rate_table *rt =
-				ath5k_hw_get_rate_table(sc->ah, mode);
-		unsigned int i, j;
+	struct ath5k_softc *sc = dev_id;
+	struct ath5k_hw *ah = sc->ah;
+	enum ath5k_int status;
+	unsigned int counter = 1000;
 
-		BUG_ON(rt == NULL);
+	if (unlikely(test_bit(ATH_STAT_INVALID, sc->status) ||
+				!ath5k_hw_is_intr_pending(ah)))
+		return IRQ_NONE;
 
-		memset(sc->hwmap, 0, sizeof(sc->hwmap));
-		for (i = 0; i < 32; i++) {
-			u8 ix = rt->rate_code_to_index[i];
-			if (ix == 0xff) {
-				sc->hwmap[i].ledon = msecs_to_jiffies(500);
-				sc->hwmap[i].ledoff = msecs_to_jiffies(130);
-				continue;
+	do {
+		/*
+		 * Figure out the reason(s) for the interrupt.  Note
+		 * that get_isr returns a pseudo-ISR that may include
+		 * bits we haven't explicitly enabled so we mask the
+		 * value to insure we only process bits we requested.
+		 */
+		ath5k_hw_get_isr(ah, &status);		/* NB: clears IRQ too */
+		DPRINTF(sc, ATH_DEBUG_INTR, "%s: status 0x%x/0x%x\n", __func__,
+				status, sc->imask);
+		status &= sc->imask; /* discard unasked for bits */
+		if (unlikely(status & AR5K_INT_FATAL)) {
+			/*
+			 * Fatal errors are unrecoverable.
+			 * Typically these are caused by DMA errors.
+			 */
+			tasklet_schedule(&sc->restq);
+		} else if (unlikely(status & AR5K_INT_RXORN)) {
+			tasklet_schedule(&sc->restq);
+		} else {
+			if (status & AR5K_INT_SWBA) {
+				/*
+				* Software beacon alert--time to send a beacon.
+				* Handle beacon transmission directly; deferring
+				* this is too slow to meet timing constraints
+				* under load.
+				*/
+				ath5k_beacon_send(sc);
+			}
+			if (status & AR5K_INT_RXEOL) {
+				/*
+				* NB: the hardware should re-read the link when
+				*     RXE bit is written, but it doesn't work at
+				*     least on older hardware revs.
+				*/
+				sc->rxlink = NULL;
+			}
+			if (status & AR5K_INT_TXURN) {
+				/* bump tx trigger level */
+				ath5k_hw_update_tx_triglevel(ah, true);
+			}
+			if (status & AR5K_INT_RX)
+				tasklet_schedule(&sc->rxtq);
+			if (status & AR5K_INT_TX)
+				tasklet_schedule(&sc->txtq);
+			if (status & AR5K_INT_BMISS) {
+			}
+			if (status & AR5K_INT_MIB) {
+				/* TODO */
 			}
-			sc->hwmap[i].txflags = IEEE80211_RADIOTAP_F_DATAPAD;
-			if (SHPREAMBLE_FLAG(ix) || rt->rates[ix].modulation ==
-					IEEE80211_RATE_OFDM)
-				sc->hwmap[i].txflags |=
-						IEEE80211_RADIOTAP_F_SHORTPRE;
-			/* receive frames include FCS */
-			sc->hwmap[i].rxflags = sc->hwmap[i].txflags |
-					IEEE80211_RADIOTAP_F_FCS;
-			/* setup blink rate table to avoid per-packet lookup */
-			for (j = 0; j < ARRAY_SIZE(blinkrates) - 1; j++)
-				if (blinkrates[j].rate == /* XXX why 7f? */
-						(rt->rates[ix].dot11_rate&0x7f))
-					break;
-
-			sc->hwmap[i].ledon = msecs_to_jiffies(blinkrates[j].
-					timeOn);
-			sc->hwmap[i].ledoff = msecs_to_jiffies(blinkrates[j].
-					timeOff);
 		}
-	}
+	} while (ath5k_hw_is_intr_pending(ah) && counter-- > 0);
 
-	sc->curmode = mode;
+	if (unlikely(!counter && net_ratelimit()))
+		printk(KERN_WARNING "ath: too many interrupts, giving up for "
+				"now\n");
+
+	return IRQ_HANDLED;
 }
 
-/*
- * Set/change channels.  If the channel is really being changed,
- * it's done by reseting the chip.  To accomplish this we must
- * first cleanup any pending DMA, then restart stuff after a la
- * ath5k_init.
- */
-static int ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
+static void
+ath5k_tasklet_reset(unsigned long data)
 {
-	struct ath5k_hw *ah = sc->ah;
-	int ret;
+	struct ath5k_softc *sc = (void *)data;
 
-	DPRINTF(sc, ATH_DEBUG_RESET, "%s: %u (%u MHz) -> %u (%u MHz)\n",
-		__func__, sc->curchan->chan, sc->curchan->freq,
-		chan->chan, chan->freq);
+	ath5k_reset(sc->hw);
+}
 
-	if (chan->freq != sc->curchan->freq || chan->val != sc->curchan->val) {
-		/*
-		 * To switch channels clear any pending DMA operations;
-		 * wait long enough for the RX fifo to drain, reset the
-		 * hardware at the new frequency, and then re-enable
-		 * the relevant bits of the h/w.
-		 */
-		ath5k_hw_set_intr(ah, 0);	/* disable interrupts */
-		ath5k_draintxq(sc);		/* clear pending tx frames */
-		ath5k_stoprecv(sc);		/* turn off frame recv */
-		ret = ath5k_hw_reset(ah, sc->opmode, chan, true);
-		if (ret) {
-			printk(KERN_ERR "%s: unable to reset channel %u "
-				"(%u Mhz)\n", __func__, chan->chan, chan->freq);
-			return ret;
-		}
-		sc->curchan = chan;
-		ath5k_update_txpow(sc);
+static inline void
+ath5k_update_txpow(struct ath5k_softc *sc)
+{
+	ath5k_hw_set_txpower_limit(sc->ah, 0);
+}
 
-		/*
-		 * Re-enable rx framework.
-		 */
-		ret = ath5k_startrecv(sc);
-		if (ret) {
-			printk(KERN_ERR "%s: unable to restart recv logic\n",
-					__func__);
-			return ret;
-		}
+/*
+ * Periodically recalibrate the PHY to account
+ * for temperature/environment changes.
+ */
+static void
+ath5k_calibrate(unsigned long data)
+{
+	struct ath5k_softc *sc = (void *)data;
+	struct ath5k_hw *ah = sc->ah;
 
-		/*
-		 * Change channels and update the h/w rate map
-		 * if we're switching; e.g. 11a to 11b/g.
-		 *
-		 * XXX needed?
-		 */
-/*		ath5k_chan_change(sc, chan); */
+	DPRINTF(sc, ATH_DEBUG_CALIBRATE, "ath: channel %u/%x\n",
+		sc->curchan->chan, sc->curchan->val);
 
+	if (ath5k_hw_get_rf_gain(ah) == AR5K_RFGAIN_NEED_CHANGE) {
 		/*
-		 * Re-enable interrupts.
+		 * Rfgain is out of bounds, reset the chip
+		 * to load new gain values.
 		 */
-		ath5k_hw_set_intr(ah, sc->imask);
+		DPRINTF(sc, ATH_DEBUG_RESET, "calibration, resetting\n");
+		ath5k_reset(sc->hw);
 	}
+	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
+		printk(KERN_ERR "ath: calibration of channel %u failed\n",
+				sc->curchan->chan);
 
-	return 0;
+	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
+			msecs_to_jiffies(ath5k_calinterval * 1000)));
 }
 
-static int ath5k_tx_bf(struct ath5k_softc *sc, struct ath5k_buf *bf,
-		struct ieee80211_tx_control *ctl)
-{
-	struct ath5k_hw *ah = sc->ah;
-	struct ath5k_txq *txq = sc->txq;
-	struct ath5k_desc *ds = bf->desc;
-	struct sk_buff *skb = bf->skb;
-	unsigned int pktlen, flags, keyidx = AR5K_TXKEYIX_INVALID;
-	int ret;
 
-	flags = AR5K_TXDESC_INTREQ | AR5K_TXDESC_CLRDMASK;
-	bf->ctl = *ctl;
-	/* XXX endianness */
-	bf->skbaddr = pci_map_single(sc->pdev, skb->data, skb->len,
-			PCI_DMA_TODEVICE);
 
-	if (ctl->flags & IEEE80211_TXCTL_NO_ACK)
-		flags |= AR5K_TXDESC_NOACK;
+/***************\
+* LED functions *
+\***************/
 
-	pktlen = skb->len + FCS_LEN;
+static void
+ath5k_led_off(unsigned long data)
+{
+	struct ath5k_softc *sc = (void *)data;
 
-	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT)) {
-		keyidx = ctl->key_idx;
-		pktlen += ctl->icv_len;
+	if (test_bit(ATH_STAT_LEDENDBLINK, sc->status))
+		__clear_bit(ATH_STAT_LEDBLINKING, sc->status);
+	else {
+		__set_bit(ATH_STAT_LEDENDBLINK, sc->status);
+		ath5k_hw_set_gpio(sc->ah, sc->led_pin, !sc->led_on);
+		mod_timer(&sc->led_tim, jiffies + sc->led_off);
 	}
+}
 
-	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
-		ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
-		0xffff, ctl->tx_rate, ctl->retry_limit, keyidx, 0, flags, 0, 0);
-	if (ret)
-		goto err_unmap;
+/*
+ * Blink the LED according to the specified on/off times.
+ */
+static void
+ath5k_led_blink(struct ath5k_softc *sc, unsigned int on,
+		unsigned int off)
+{
+	DPRINTF(sc, ATH_DEBUG_LED, "%s: on %u off %u\n", __func__, on, off);
+	ath5k_hw_set_gpio(sc->ah, sc->led_pin, sc->led_on);
+	__set_bit(ATH_STAT_LEDBLINKING, sc->status);
+	__clear_bit(ATH_STAT_LEDENDBLINK, sc->status);
+	sc->led_off = off;
+	mod_timer(&sc->led_tim, jiffies + on);
+}
 
-	ds->ds_link = 0;
-	ds->ds_data = bf->skbaddr;
+static void
+ath5k_led_event(struct ath5k_softc *sc, int event)
+{
+	if (likely(!test_bit(ATH_STAT_LEDSOFT, sc->status)))
+		return;
+	if (unlikely(test_bit(ATH_STAT_LEDBLINKING, sc->status)))
+		return; /* don't interrupt active blink */
+	switch (event) {
+	case ATH_LED_TX:
+		ath5k_led_blink(sc, sc->hwmap[sc->led_txrate].ledon,
+			sc->hwmap[sc->led_txrate].ledoff);
+		break;
+	case ATH_LED_RX:
+		ath5k_led_blink(sc, sc->hwmap[sc->led_rxrate].ledon,
+			sc->hwmap[sc->led_rxrate].ledoff);
+		break;
+	}
+}
 
-	ret = ah->ah_fill_tx_desc(ah, ds, skb->len, true, true);
-	if (ret)
-		goto err_unmap;
 
-	spin_lock_bh(&txq->lock);
-	list_add_tail(&bf->list, &txq->q);
-	sc->tx_stats.data[txq->qnum].len++;
-	if (txq->link == NULL) /* is this first packet? */
-		ath5k_hw_put_tx_buf(ah, txq->qnum, bf->daddr);
-	else /* no, so only link it */
-		*txq->link = bf->daddr;
 
-	txq->link = &ds->ds_link;
-	ath5k_hw_tx_start(ah, txq->qnum);
-	spin_unlock_bh(&txq->lock);
 
-	return 0;
-err_unmap:
-	pci_unmap_single(sc->pdev, bf->skbaddr, skb->len, PCI_DMA_TODEVICE);
-	return ret;
-}
+/********************\
+* Mac80211 functions *
+\********************/
 
-static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
-		struct ieee80211_tx_control *ctl)
+static int
+ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+			struct ieee80211_tx_control *ctl)
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_buf *bf;
@@ -1265,7 +2540,8 @@ static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	return 0;
 }
 
-static int ath5k_reset(struct ieee80211_hw *hw)
+static int
+ath5k_reset(struct ieee80211_hw *hw)
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
@@ -1352,8 +2628,9 @@ end:
 	return ret;
 }
 
-static void ath5k_remove_interface(struct ieee80211_hw *hw,
-		struct ieee80211_if_init_conf *conf)
+static void
+ath5k_remove_interface(struct ieee80211_hw *hw,
+			struct ieee80211_if_init_conf *conf)
 {
 	struct ath5k_softc *sc = hw->priv;
 
@@ -1366,7 +2643,9 @@ end:
 	mutex_unlock(&sc->lock);
 }
 
-static int ath5k_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
+static int
+ath5k_config(struct ieee80211_hw *hw,
+			struct ieee80211_conf *conf)
 {
 	struct ath5k_softc *sc = hw->priv;
 
@@ -1376,8 +2655,9 @@ static int ath5k_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 	return ath5k_chan_set(sc, conf->chan);
 }
 
-static int ath5k_config_interface(struct ieee80211_hw *hw, int if_id,
-		struct ieee80211_if_conf *conf)
+static int
+ath5k_config_interface(struct ieee80211_hw *hw, int if_id,
+			struct ieee80211_if_conf *conf)
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
@@ -1429,7 +2709,8 @@ unlock:
  *   - when scanning
  */
 static void ath5k_configure_filter(struct ieee80211_hw *hw,
-		unsigned int changed_flags, unsigned int *new_flags,
+		unsigned int changed_flags,
+		unsigned int *new_flags,
 		int mc_count, struct dev_mc_list *mclist)
 {
 	struct ath5k_softc *sc = hw->priv;
@@ -1526,7 +2807,8 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 	sc->filter_flags = rfilt;
 }
 
-static int ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+static int
+ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		const u8 *local_addr, const u8 *addr,
 		struct ieee80211_key_conf *key)
 {
@@ -1570,7 +2852,8 @@ unlock:
 	return ret;
 }
 
-static int ath5k_get_stats(struct ieee80211_hw *hw,
+static int
+ath5k_get_stats(struct ieee80211_hw *hw,
 		struct ieee80211_low_level_stats *stats)
 {
 	struct ath5k_softc *sc = hw->priv;
@@ -1580,7 +2863,8 @@ static int ath5k_get_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int ath5k_get_tx_stats(struct ieee80211_hw *hw,
+static int 
+ath5k_get_tx_stats(struct ieee80211_hw *hw,
 		struct ieee80211_tx_queue_stats *stats)
 {
 	struct ath5k_softc *sc = hw->priv;
@@ -1590,22 +2874,25 @@ static int ath5k_get_tx_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static u64 ath5k_get_tsf(struct ieee80211_hw *hw)
+static u64
+ath5k_get_tsf(struct ieee80211_hw *hw)
 {
 	struct ath5k_softc *sc = hw->priv;
 
 	return ath5k_hw_get_tsf64(sc->ah);
 }
 
-static void ath5k_reset_tsf(struct ieee80211_hw *hw)
+static void
+ath5k_reset_tsf(struct ieee80211_hw *hw)
 {
 	struct ath5k_softc *sc = hw->priv;
 
 	ath5k_hw_reset_tsf(sc->ah);
 }
 
-static int ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-		struct ieee80211_tx_control *ctl)
+static int
+ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
+			struct ieee80211_tx_control *ctl)
 {
 	struct ath5k_softc *sc = hw->priv;
 	int ret;
@@ -1630,1000 +2917,3 @@ end:
 	return ret;
 }
 
-static struct ieee80211_ops ath5k_hw_ops = {
-	.tx = ath5k_tx,
-	.start = ath5k_start,
-	.stop = ath5k_stop,
-	.add_interface = ath5k_add_interface,
-	.remove_interface = ath5k_remove_interface,
-	.config = ath5k_config,
-	.config_interface = ath5k_config_interface,
-	.configure_filter = ath5k_configure_filter,
-	.set_key = ath5k_set_key,
-	.get_stats = ath5k_get_stats,
-	.conf_tx = NULL,
-	.get_tx_stats = ath5k_get_tx_stats,
-	.get_tsf = ath5k_get_tsf,
-	.reset_tsf = ath5k_reset_tsf,
-	.beacon_update = ath5k_beacon_update,
-};
-
-/*
- * Periodically recalibrate the PHY to account
- * for temperature/environment changes.
- */
-static void ath5k_calibrate(unsigned long data)
-{
-	struct ath5k_softc *sc = (void *)data;
-	struct ath5k_hw *ah = sc->ah;
-
-	DPRINTF(sc, ATH_DEBUG_CALIBRATE, "ath: channel %u/%x\n",
-		sc->curchan->chan, sc->curchan->val);
-
-	if (ath5k_hw_get_rf_gain(ah) == AR5K_RFGAIN_NEED_CHANGE) {
-		/*
-		 * Rfgain is out of bounds, reset the chip
-		 * to load new gain values.
-		 */
-		DPRINTF(sc, ATH_DEBUG_RESET, "calibration, resetting\n");
-		ath5k_reset(sc->hw);
-	}
-	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
-		printk(KERN_ERR "ath: calibration of channel %u failed\n",
-				sc->curchan->chan);
-
-	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
-			msecs_to_jiffies(ath5k_calinterval * 1000)));
-}
-
-static void ath5k_led_off(unsigned long data)
-{
-	struct ath5k_softc *sc = (void *)data;
-
-	if (test_bit(ATH_STAT_LEDENDBLINK, sc->status))
-		__clear_bit(ATH_STAT_LEDBLINKING, sc->status);
-	else {
-		__set_bit(ATH_STAT_LEDENDBLINK, sc->status);
-		ath5k_hw_set_gpio(sc->ah, sc->led_pin, !sc->led_on);
-		mod_timer(&sc->led_tim, jiffies + sc->led_off);
-	}
-}
-
-/*
- * Blink the LED according to the specified on/off times.
- */
-static void ath5k_led_blink(struct ath5k_softc *sc, unsigned int on,
-		unsigned int off)
-{
-	DPRINTF(sc, ATH_DEBUG_LED, "%s: on %u off %u\n", __func__, on, off);
-	ath5k_hw_set_gpio(sc->ah, sc->led_pin, sc->led_on);
-	__set_bit(ATH_STAT_LEDBLINKING, sc->status);
-	__clear_bit(ATH_STAT_LEDENDBLINK, sc->status);
-	sc->led_off = off;
-	mod_timer(&sc->led_tim, jiffies + on);
-}
-
-static void ath5k_led_event(struct ath5k_softc *sc, int event)
-{
-	if (likely(!test_bit(ATH_STAT_LEDSOFT, sc->status)))
-		return;
-	if (unlikely(test_bit(ATH_STAT_LEDBLINKING, sc->status)))
-		return; /* don't interrupt active blink */
-	switch (event) {
-	case ATH_LED_TX:
-		ath5k_led_blink(sc, sc->hwmap[sc->led_txrate].ledon,
-			sc->hwmap[sc->led_txrate].ledoff);
-		break;
-	case ATH_LED_RX:
-		ath5k_led_blink(sc, sc->hwmap[sc->led_rxrate].ledon,
-			sc->hwmap[sc->led_rxrate].ledoff);
-		break;
-	}
-}
-
-static irqreturn_t ath5k_intr(int irq, void *dev_id)
-{
-	struct ath5k_softc *sc = dev_id;
-	struct ath5k_hw *ah = sc->ah;
-	enum ath5k_int status;
-	unsigned int counter = 1000;
-
-	if (unlikely(test_bit(ATH_STAT_INVALID, sc->status) ||
-				!ath5k_hw_is_intr_pending(ah)))
-		return IRQ_NONE;
-
-	do {
-		/*
-		 * Figure out the reason(s) for the interrupt.  Note
-		 * that get_isr returns a pseudo-ISR that may include
-		 * bits we haven't explicitly enabled so we mask the
-		 * value to insure we only process bits we requested.
-		 */
-		ath5k_hw_get_isr(ah, &status);		/* NB: clears IRQ too */
-		DPRINTF(sc, ATH_DEBUG_INTR, "%s: status 0x%x/0x%x\n", __func__,
-				status, sc->imask);
-		status &= sc->imask; /* discard unasked for bits */
-		if (unlikely(status & AR5K_INT_FATAL)) {
-			/*
-			 * Fatal errors are unrecoverable.
-			 * Typically these are caused by DMA errors.
-			 */
-			tasklet_schedule(&sc->restq);
-		} else if (unlikely(status & AR5K_INT_RXORN)) {
-			tasklet_schedule(&sc->restq);
-		} else {
-			if (status & AR5K_INT_SWBA) {
-				/*
-				* Software beacon alert--time to send a beacon.
-				* Handle beacon transmission directly; deferring
-				* this is too slow to meet timing constraints
-				* under load.
-				*/
-				ath5k_beacon_send(sc);
-			}
-			if (status & AR5K_INT_RXEOL) {
-				/*
-				* NB: the hardware should re-read the link when
-				*     RXE bit is written, but it doesn't work at
-				*     least on older hardware revs.
-				*/
-				sc->rxlink = NULL;
-			}
-			if (status & AR5K_INT_TXURN) {
-				/* bump tx trigger level */
-				ath5k_hw_update_tx_triglevel(ah, true);
-			}
-			if (status & AR5K_INT_RX)
-				tasklet_schedule(&sc->rxtq);
-			if (status & AR5K_INT_TX)
-				tasklet_schedule(&sc->txtq);
-			if (status & AR5K_INT_BMISS) {
-			}
-			if (status & AR5K_INT_MIB) {
-				/* TODO */
-			}
-		}
-	} while (ath5k_hw_is_intr_pending(ah) && counter-- > 0);
-
-	if (unlikely(!counter && net_ratelimit()))
-		printk(KERN_WARNING "ath: too many interrupts, giving up for "
-				"now\n");
-
-	return IRQ_HANDLED;
-}
-
-/*
- * Convert IEEE channel number to MHz frequency.
- */
-static inline short ath5k_ieee2mhz(short chan)
-{
-	if (chan <= 14 || chan >= 27)
-		return ieee80211chan2mhz(chan);
-	else
-		return 2212 + chan * 20;
-}
-
-static unsigned int ath5k_copy_rates(struct ieee80211_rate *rates,
-		const struct ath5k_rate_table *rt, unsigned int max)
-{
-	unsigned int i, count;
-
-	if (rt == NULL)
-		return 0;
-
-	for (i = 0, count = 0; i < rt->rate_count && max > 0; i++) {
-		if (!rt->rates[i].valid)
-			continue;
-		rates->rate = rt->rates[i].rate_kbps / 100;
-		rates->val = rt->rates[i].rate_code;
-		rates->flags = rt->rates[i].modulation;
-		rates++;
-		count++;
-		max--;
-	}
-
-	return count;
-}
-
-static unsigned int ath5k_copy_channels(struct ath5k_hw *ah,
-		struct ieee80211_channel *channels, unsigned int mode,
-		unsigned int max)
-{
-	static const struct { unsigned int mode, mask, chan; } map[] = {
-		[MODE_IEEE80211A] = { CHANNEL_OFDM, CHANNEL_OFDM | CHANNEL_TURBO, CHANNEL_A },
-		[MODE_ATHEROS_TURBO] = { CHANNEL_OFDM|CHANNEL_TURBO, CHANNEL_OFDM | CHANNEL_TURBO, CHANNEL_T },
-		[MODE_IEEE80211B] = { CHANNEL_CCK, CHANNEL_CCK, CHANNEL_B },
-		[MODE_IEEE80211G] = { CHANNEL_OFDM, CHANNEL_OFDM, CHANNEL_G },
-		[MODE_ATHEROS_TURBOG] = { CHANNEL_OFDM | CHANNEL_TURBO, CHANNEL_OFDM | CHANNEL_TURBO, CHANNEL_TG },
-	};
-	static const struct ath5k_regchannel chans_2ghz[] =
-		IEEE80211_CHANNELS_2GHZ;
-	static const struct ath5k_regchannel chans_5ghz[] =
-		IEEE80211_CHANNELS_5GHZ;
-	const struct ath5k_regchannel *chans;
-	enum ath5k_regdom dmn;
-	unsigned int i, count, size, chfreq, all, f, ch;
-
-	if (!test_bit(mode, ah->ah_modes))
-		return 0;
-
-	all = ah->ah_regdomain == DMN_DEFAULT || CHAN_DEBUG == 1;
-
-	switch (mode) {
-	case MODE_IEEE80211A:
-	case MODE_ATHEROS_TURBO:
-		/* 1..220, but 2GHz frequencies are filtered by check_channel */
-		size = all ? 220 : ARRAY_SIZE(chans_5ghz);
-		chans = chans_5ghz;
-		dmn = ath5k_regdom2flag(ah->ah_regdomain,
-				IEEE80211_CHANNELS_5GHZ_MIN);
-		chfreq = CHANNEL_5GHZ;
-		break;
-	case MODE_IEEE80211B:
-	case MODE_IEEE80211G:
-	case MODE_ATHEROS_TURBOG:
-		size = all ? 26 : ARRAY_SIZE(chans_2ghz);
-		chans = chans_2ghz;
-		dmn = ath5k_regdom2flag(ah->ah_regdomain,
-				IEEE80211_CHANNELS_2GHZ_MIN);
-		chfreq = CHANNEL_2GHZ;
-		break;
-	default:
-		printk(KERN_WARNING "bad mode, not copying channels\n");
-		return 0;
-	}
-
-	for (i = 0, count = 0; i < size && max > 0; i++) {
-		ch = all ? i + 1 : chans[i].chan;
-		f = ath5k_ieee2mhz(ch);
-		/* Check if channel is supported by the chipset */
-		if (!ath5k_channel_ok(ah, f, chfreq))
-			continue;
-
-		/* Match regulation domain */
-		if (!all && !(IEEE80211_DMN(chans[i].domain) &
-							IEEE80211_DMN(dmn)))
-			continue;
-
-		if (!all && (chans[i].mode & map[mode].mask) != map[mode].mode)
-			continue;
-
-		/* Write channel and increment counter */
-		channels->chan = ch;
-		channels->freq = f;
-		channels->val = map[mode].chan;
-		channels++;
-		count++;
-		max--;
-	}
-
-	return count;
-}
-
-#if ATH_DEBUG_MODES
-static void ath5k_dump_modes(struct ieee80211_hw_mode *modes)
-{
-	unsigned int m, i;
-
-	for (m = 0; m < NUM_DRIVER_MODES; m++) {
-		printk(KERN_DEBUG "Mode %u: channels %d, rates %d\n", m,
-				modes[m].num_channels, modes[m].num_rates);
-		printk(KERN_DEBUG " channels:\n");
-		for (i = 0; i < modes[m].num_channels; i++)
-			printk(KERN_DEBUG "  %3d %d %.4x %.4x\n",
-					modes[m].channels[i].chan,
-					modes[m].channels[i].freq,
-					modes[m].channels[i].val,
-					modes[m].channels[i].flag);
-		printk(KERN_DEBUG " rates:\n");
-		for (i = 0; i < modes[m].num_rates; i++)
-			printk(KERN_DEBUG "  %4d %.4x %.4x %.4x\n",
-					modes[m].rates[i].rate,
-					modes[m].rates[i].val,
-					modes[m].rates[i].flags,
-					modes[m].rates[i].val2);
-	}
-}
-#else
-static inline void ath5k_dump_modes(struct ieee80211_hw_mode *modes) {}
-#endif
-
-static inline int ath5k_register_mode(struct ieee80211_hw *hw, u8 m)
-{
-	struct ath5k_softc *sc = hw->priv;
-	struct ieee80211_hw_mode *modes = sc->modes;
-	unsigned int i;
-	int ret;
-
-	if (!test_bit(m, sc->ah->ah_capabilities.cap_mode))
-		return 0;
-
-	for (i = 0; i < NUM_DRIVER_MODES; i++) {
-		if (modes[i].mode != m || !modes[i].num_channels)
-			continue;
-		ret = ieee80211_register_hwmode(hw, &modes[i]);
-		if (ret) {
-			printk(KERN_ERR "can't register hwmode %u\n", m);
-			return ret;
-		}
-		return 0;
-	}
-	BUG();
-}
-
-/* Only tries to register modes our EEPROM says it can support */
-#define REGISTER_MODE(m) do { \
-	ret = ath5k_register_mode(hw, m); \
-	if (ret) \
-		return ret; \
-} while (0) \
-
-static int ath5k_getchannels(struct ieee80211_hw *hw)
-{
-	struct ath5k_softc *sc = hw->priv;
-	struct ath5k_hw *ah = sc->ah;
-	struct ieee80211_hw_mode *modes = sc->modes;
-	unsigned int i, max_r, max_c;
-	int ret;
-
-	BUILD_BUG_ON(ARRAY_SIZE(sc->modes) < 3);
-
-	/* The order here does not matter */
-	modes[0].mode = MODE_IEEE80211G;
-	modes[1].mode = MODE_IEEE80211B;
-	modes[2].mode = MODE_IEEE80211A;
-
-	max_r = ARRAY_SIZE(sc->rates);
-	max_c = ARRAY_SIZE(sc->channels);
-
-	for (i = 0; i < NUM_DRIVER_MODES; i++) {
-		struct ieee80211_hw_mode *mode = &modes[i];
-		const struct ath5k_rate_table *hw_rates;
-
-		if (i == 0) {
-			modes[0].rates	= sc->rates;
-			modes->channels	= sc->channels;
-		} else {
-			struct ieee80211_hw_mode *prev_mode = &modes[i-1];
-			int prev_num_r	= prev_mode->num_rates;
-			int prev_num_c	= prev_mode->num_channels;
-			mode->rates	= &prev_mode->rates[prev_num_r];
-			mode->channels	= &prev_mode->channels[prev_num_c];
-		}
-
-		hw_rates = ath5k_hw_get_rate_table(ah, mode->mode);
-		mode->num_rates    = ath5k_copy_rates(mode->rates, hw_rates,
-			max_r);
-		mode->num_channels = ath5k_copy_channels(ah, mode->channels,
-			mode->mode, max_c);
-		max_r -= mode->num_rates;
-		max_c -= mode->num_channels;
-	}
-
-	/* We try to register all modes this driver supports. We don't bother
-	 * with MODE_IEEE80211B for AR5212 as MODE_IEEE80211G already accounts
-	 * for that as per mac80211. Then, REGISTER_MODE() will will actually
-	 * check the eeprom reading for more reliable capability information.
-	 * Order matters here as per mac80211's latest preference. This will
-	 * all hopefullly soon go away. */
-
-	REGISTER_MODE(MODE_IEEE80211G);
-	if (ah->ah_version != AR5K_AR5212)
-		REGISTER_MODE(MODE_IEEE80211B);
-	REGISTER_MODE(MODE_IEEE80211A);
-
-	ath5k_dump_modes(modes);
-
-	return ret;
-}
-
-static int ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
-{
-	struct ath5k_desc *ds;
-	struct ath5k_buf *bf;
-	dma_addr_t da;
-	unsigned int i;
-	int ret;
-
-	/* allocate descriptors */
-	sc->desc_len = sizeof(struct ath5k_desc) *
-			(ATH_TXBUF + ATH_RXBUF + ATH_BCBUF + 1);
-	sc->desc = pci_alloc_consistent(pdev, sc->desc_len, &sc->desc_daddr);
-	if (sc->desc == NULL) {
-		dev_err(&pdev->dev, "can't allocate descriptors\n");
-		ret = -ENOMEM;
-		goto err;
-	}
-	ds = sc->desc;
-	da = sc->desc_daddr;
-	DPRINTF(sc, ATH_DEBUG_ANY, "%s: DMA map: %p (%zu) -> %llx\n",
-		__func__, ds, sc->desc_len, (unsigned long long)sc->desc_daddr);
-
-	bf = kcalloc(1 + ATH_TXBUF + ATH_RXBUF + ATH_BCBUF,
-			sizeof(struct ath5k_buf), GFP_KERNEL);
-	if (bf == NULL) {
-		dev_err(&pdev->dev, "can't allocate bufptr\n");
-		ret = -ENOMEM;
-		goto err_free;
-	}
-	sc->bufptr = bf;
-
-	INIT_LIST_HEAD(&sc->rxbuf);
-	for (i = 0; i < ATH_RXBUF; i++, bf++, ds++, da += sizeof(*ds)) {
-		bf->desc = ds;
-		bf->daddr = da;
-		list_add_tail(&bf->list, &sc->rxbuf);
-	}
-
-	INIT_LIST_HEAD(&sc->txbuf);
-	sc->txbuf_len = ATH_TXBUF;
-	for (i = 0; i < ATH_TXBUF; i++, bf++, ds++,
-			da += sizeof(*ds)) {
-		bf->desc = ds;
-		bf->daddr = da;
-		list_add_tail(&bf->list, &sc->txbuf);
-	}
-
-	/* beacon buffer */
-	bf->desc = ds;
-	bf->daddr = da;
-	sc->bbuf = bf;
-
-	return 0;
-err_free:
-	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
-err:
-	sc->desc = NULL;
-	return ret;
-}
-
-static void ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
-{
-	struct ath5k_buf *bf;
-
-	ath5k_cleanup_txbuf(sc, sc->bbuf);
-	list_for_each_entry(bf, &sc->txbuf, list)
-		ath5k_cleanup_txbuf(sc, bf);
-	list_for_each_entry(bf, &sc->rxbuf, list)
-		ath5k_cleanup_txbuf(sc, bf);
-
-	/* Free memory associated with all descriptors */
-	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
-
-	kfree(sc->bufptr);
-	sc->bufptr = NULL;
-}
-
-static int ath5k_beaconq_setup(struct ath5k_hw *ah)
-{
-	struct ath5k_txq_info qi = {
-		.tqi_aifs = AR5K_TXQ_USEDEFAULT,
-		.tqi_cw_min = AR5K_TXQ_USEDEFAULT,
-		.tqi_cw_max = AR5K_TXQ_USEDEFAULT,
-		/* NB: for dynamic turbo, don't enable any other interrupts */
-		.tqi_flags = AR5K_TXQ_FLAG_TXDESCINT_ENABLE
-	};
-
-	return ath5k_hw_setup_tx_queue(ah, AR5K_TX_QUEUE_BEACON, &qi);
-}
-
-static struct ath5k_txq *ath5k_txq_setup(struct ath5k_softc *sc, int qtype,
-		int subtype)
-{
-	struct ath5k_hw *ah = sc->ah;
-	struct ath5k_txq *txq;
-	struct ath5k_txq_info qi = {
-		.tqi_subtype = subtype,
-		.tqi_aifs = AR5K_TXQ_USEDEFAULT,
-		.tqi_cw_min = AR5K_TXQ_USEDEFAULT,
-		.tqi_cw_max = AR5K_TXQ_USEDEFAULT
-	};
-	int qnum;
-
-	/*
-	 * Enable interrupts only for EOL and DESC conditions.
-	 * We mark tx descriptors to receive a DESC interrupt
-	 * when a tx queue gets deep; otherwise waiting for the
-	 * EOL to reap descriptors.  Note that this is done to
-	 * reduce interrupt load and this only defers reaping
-	 * descriptors, never transmitting frames.  Aside from
-	 * reducing interrupts this also permits more concurrency.
-	 * The only potential downside is if the tx queue backs
-	 * up in which case the top half of the kernel may backup
-	 * due to a lack of tx descriptors.
-	 */
-	qi.tqi_flags = AR5K_TXQ_FLAG_TXEOLINT_ENABLE |
-				AR5K_TXQ_FLAG_TXDESCINT_ENABLE;
-	qnum = ath5k_hw_setup_tx_queue(ah, qtype, &qi);
-	if (qnum < 0) {
-		/*
-		 * NB: don't print a message, this happens
-		 * normally on parts with too few tx queues
-		 */
-		return ERR_PTR(qnum);
-	}
-	if (qnum >= ARRAY_SIZE(sc->txqs)) {
-		printk(KERN_ERR "hw qnum %u out of range, max %tu!\n",
-			qnum, ARRAY_SIZE(sc->txqs));
-		ath5k_hw_release_tx_queue(ah, qnum);
-		return ERR_PTR(-EINVAL);
-	}
-	txq = &sc->txqs[qnum];
-	if (!txq->setup) {
-		txq->qnum = qnum;
-		txq->link = NULL;
-		INIT_LIST_HEAD(&txq->q);
-		spin_lock_init(&txq->lock);
-		txq->setup = true;
-	}
-	return &sc->txqs[qnum];
-}
-
-static void ath5k_tx_cleanup(struct ath5k_softc *sc)
-{
-	struct ath5k_txq *txq = sc->txqs;
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++, txq++)
-		if (txq->setup) {
-			ath5k_hw_release_tx_queue(sc->ah, txq->qnum);
-			txq->setup = false;
-		}
-}
-
-static int ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
-{
-	struct ath5k_softc *sc = hw->priv;
-	struct ath5k_hw *ah = sc->ah;
-	u8 mac[ETH_ALEN];
-	unsigned int i;
-	int ret;
-
-	DPRINTF(sc, ATH_DEBUG_ANY, "%s: devid 0x%x\n", __func__, pdev->device);
-
-	/*
-	 * Check if the MAC has multi-rate retry support.
-	 * We do this by trying to setup a fake extended
-	 * descriptor.  MAC's that don't have support will
-	 * return false w/o doing anything.  MAC's that do
-	 * support it will return true w/o doing anything.
-	 */
-	if (ah->ah_setup_xtx_desc(ah, NULL, 0, 0, 0, 0, 0, 0))
-		__set_bit(ATH_STAT_MRRETRY, sc->status);
-
-	/*
-	 * Reset the key cache since some parts do not
-	 * reset the contents on initial power up.
-	 */
-	for (i = 0; i < AR5K_KEYCACHE_SIZE; i++)
-		ath5k_hw_reset_key(ah, i);
-
-	/*
-	 * Collect the channel list.  The 802.11 layer
-	 * is resposible for filtering this list based
-	 * on settings like the phy mode and regulatory
-	 * domain restrictions.
-	 */
-	ret = ath5k_getchannels(hw);
-	if (ret) {
-		dev_err(&pdev->dev, "can't get channels\n");
-		goto err;
-	}
-
-	/* NB: setup here so ath5k_rate_update is happy */
-	if (test_bit(MODE_IEEE80211A, ah->ah_modes))
-		ath5k_setcurmode(sc, MODE_IEEE80211A);
-	else
-		ath5k_setcurmode(sc, MODE_IEEE80211B);
-
-	/*
-	 * Allocate tx+rx descriptors and populate the lists.
-	 */
-	ret = ath5k_desc_alloc(sc, pdev);
-	if (ret) {
-		dev_err(&pdev->dev, "can't allocate descriptors\n");
-		goto err;
-	}
-
-	/*
-	 * Allocate hardware transmit queues: one queue for
-	 * beacon frames and one data queue for each QoS
-	 * priority.  Note that hw functions handle reseting
-	 * these queues at the needed time.
-	 */
-	ret = ath5k_beaconq_setup(ah);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "can't setup a beacon xmit queue\n");
-		goto err_desc;
-	}
-	sc->bhalq = ret;
-
-	sc->txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
-	if (IS_ERR(sc->txq)) {
-		dev_err(&pdev->dev, "can't setup xmit queue\n");
-		ret = PTR_ERR(sc->txq);
-		goto err_bhal;
-	}
-
-	tasklet_init(&sc->rxtq, ath5k_tasklet_rx, (unsigned long)sc);
-	tasklet_init(&sc->txtq, ath5k_tasklet_tx, (unsigned long)sc);
-	tasklet_init(&sc->restq, ath5k_tasklet_reset, (unsigned long)sc);
-	setup_timer(&sc->calib_tim, ath5k_calibrate, (unsigned long)sc);
-	setup_timer(&sc->led_tim, ath5k_led_off, (unsigned long)sc);
-
-	sc->led_on = 0; /* low true */
-	/*
-	 * Auto-enable soft led processing for IBM cards and for
-	 * 5211 minipci cards.  Users can also manually enable/disable
-	 * support with a sysctl.
-	 */
-	if (pdev->device == PCI_DEVICE_ID_ATHEROS_AR5212_IBM ||
-			pdev->device == PCI_DEVICE_ID_ATHEROS_AR5211) {
-		__set_bit(ATH_STAT_LEDSOFT, sc->status);
-		sc->led_pin = 0;
-	}
-	/* Enable softled on PIN1 on HP Compaq nc6xx, nc4000 & nx5000 laptops */
-	if (pdev->subsystem_vendor == PCI_VENDOR_ID_COMPAQ) {
-		__set_bit(ATH_STAT_LEDSOFT, sc->status);
-		sc->led_pin = 0;
-	}
-	if (test_bit(ATH_STAT_LEDSOFT, sc->status)) {
-		ath5k_hw_set_gpio_output(ah, sc->led_pin);
-		ath5k_hw_set_gpio(ah, sc->led_pin, !sc->led_on);
-	}
-
-	ath5k_hw_get_lladdr(ah, mac);
-	SET_IEEE80211_PERM_ADDR(hw, mac);
-	/* All MAC address bits matter for ACKs */
-	memset(sc->bssidmask, 0xff, ETH_ALEN);
-	ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
-
-	ret = ieee80211_register_hw(hw);
-	if (ret) {
-		dev_err(&pdev->dev, "can't register ieee80211 hw\n");
-		goto err_queues;
-	}
-
-	return 0;
-err_queues:
-	ath5k_tx_cleanup(sc);
-err_bhal:
-	ath5k_hw_release_tx_queue(ah, sc->bhalq);
-err_desc:
-	ath5k_desc_free(sc, pdev);
-err:
-	return ret;
-}
-
-static void ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
-{
-	struct ath5k_softc *sc = hw->priv;
-
-	/*
-	 * NB: the order of these is important:
-	 * o call the 802.11 layer before detaching ath5k_hw to
-	 *   insure callbacks into the driver to delete global
-	 *   key cache entries can be handled
-	 * o reclaim the tx queue data structures after calling
-	 *   the 802.11 layer as we'll get called back to reclaim
-	 *   node state and potentially want to use them
-	 * o to cleanup the tx queues the hal is called, so detach
-	 *   it last
-	 * XXX: ??? detach ath5k_hw ???
-	 * Other than that, it's straightforward...
-	 */
-	ieee80211_unregister_hw(hw);
-	ath5k_desc_free(sc, pdev);
-	ath5k_tx_cleanup(sc);
-	ath5k_hw_release_tx_queue(sc->ah, sc->bhalq);
-
-	/*
-	 * NB: can't reclaim these until after ieee80211_ifdetach
-	 * returns because we'll get called back to reclaim node
-	 * state and potentially want to use them.
-	 */
-}
-
-static const char *ath5k_chip_name(u8 mac_version)
-{
-	switch (mac_version) {
-	case AR5K_AR5210:
-		return "AR5210";
-	case AR5K_AR5211:
-		return "AR5211";
-	case AR5K_AR5212:
-		return "AR5212";
-	}
-	return "Unknown";
-}
-
-static int __devinit ath5k_pci_probe(struct pci_dev *pdev,
-		const struct pci_device_id *id)
-{
-	void __iomem *mem;
-	struct ath5k_softc *sc;
-	struct ieee80211_hw *hw;
-	int ret;
-	u8 csz;
-
-	ret = pci_enable_device(pdev);
-	if (ret) {
-		dev_err(&pdev->dev, "can't enable device\n");
-		goto err;
-	}
-
-	/* XXX 32-bit addressing only */
-	ret = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
-	if (ret) {
-		dev_err(&pdev->dev, "32-bit DMA not available\n");
-		goto err_dis;
-	}
-
-	/*
-	 * Cache line size is used to size and align various
-	 * structures used to communicate with the hardware.
-	 */
-	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &csz);
-	if (csz == 0) {
-		/*
-		 * Linux 2.4.18 (at least) writes the cache line size
-		 * register as a 16-bit wide register which is wrong.
-		 * We must have this setup properly for rx buffer
-		 * DMA to work so force a reasonable value here if it
-		 * comes up zero.
-		 */
-		csz = L1_CACHE_BYTES / sizeof(u32);
-		pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, csz);
-	}
-	/*
-	 * The default setting of latency timer yields poor results,
-	 * set it to the value used by other systems.  It may be worth
-	 * tweaking this setting more.
-	 */
-	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0xa8);
-
-	pci_set_master(pdev);
-
-	/*
-	 * Disable the RETRY_TIMEOUT register (0x41) to keep
-	 * PCI Tx retries from interfering with C3 CPU state.
-	 */
-	pci_write_config_byte(pdev, 0x41, 0);
-
-	ret = pci_request_region(pdev, 0, "ath");
-	if (ret) {
-		dev_err(&pdev->dev, "cannot reserve PCI memory region\n");
-		goto err_dis;
-	}
-
-	mem = pci_iomap(pdev, 0, 0);
-	if (!mem) {
-		dev_err(&pdev->dev, "cannot remap PCI memory region\n") ;
-		ret = -EIO;
-		goto err_reg;
-	}
-
-	hw = ieee80211_alloc_hw(sizeof(*sc), &ath5k_hw_ops);
-	if (hw == NULL) {
-		dev_err(&pdev->dev, "cannot allocate ieee80211_hw\n");
-		ret = -ENOMEM;
-		goto err_map;
-	}
-
-	SET_IEEE80211_DEV(hw, &pdev->dev);
-	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS;
-	hw->extra_tx_headroom = 2;
-	hw->channel_change_time = 5000;
-	hw->max_rssi = 127; /* FIXME: get a real value for this. */
-	sc = hw->priv;
-	sc->hw = hw;
-	sc->pdev = pdev;
-
-	/*
-	 * Mark the device as detached to avoid processing
-	 * interrupts until setup is complete.
-	 */
-#if AR_DEBUG
-	sc->debug = ath5k_debug;
-#endif
-	__set_bit(ATH_STAT_INVALID, sc->status);
-	sc->iobase = mem;
-	sc->cachelsz = csz * sizeof(u32); /* convert to bytes */
-	sc->opmode = IEEE80211_IF_TYPE_STA;
-	mutex_init(&sc->lock);
-	spin_lock_init(&sc->rxbuflock);
-	spin_lock_init(&sc->txbuflock);
-
-	pci_set_drvdata(pdev, hw);
-
-	pci_enable_msi(pdev);
-
-	ret = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
-	if (ret) {
-		dev_err(&pdev->dev, "request_irq failed\n");
-		goto err_free;
-	}
-
-	sc->ah = ath5k_hw_attach(pdev->device, id->driver_data, sc, sc->iobase);
-	if (IS_ERR(sc->ah)) {
-		ret = PTR_ERR(sc->ah);
-		goto err_irq;
-	}
-
-	ret = ath5k_attach(pdev, hw);
-	if (ret)
-		goto err_ah;
-
-	dev_info(&pdev->dev, "%s chip found: mac %d.%d phy %d.%d\n",
-			ath5k_chip_name(id->driver_data), sc->ah->ah_mac_version,
-			sc->ah->ah_mac_revision, sc->ah->ah_phy_revision >> 4,
-			sc->ah->ah_phy_revision & 0xf);
-
-	/* ready to process interrupts */
-	__clear_bit(ATH_STAT_INVALID, sc->status);
-
-	return 0;
-err_ah:
-	ath5k_hw_detach(sc->ah);
-err_irq:
-	free_irq(pdev->irq, sc);
-err_free:
-	pci_disable_msi(pdev);
-	ieee80211_free_hw(hw);
-err_map:
-	pci_iounmap(pdev, mem);
-err_reg:
-	pci_release_region(pdev, 0);
-err_dis:
-	pci_disable_device(pdev);
-err:
-	return ret;
-}
-
-static void __devexit ath5k_pci_remove(struct pci_dev *pdev)
-{
-	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath5k_softc *sc = hw->priv;
-
-	ath5k_detach(pdev, hw);
-	ath5k_hw_detach(sc->ah);
-	free_irq(pdev->irq, sc);
-	pci_disable_msi(pdev);
-	pci_iounmap(pdev, sc->iobase);
-	pci_release_region(pdev, 0);
-	pci_disable_device(pdev);
-	ieee80211_free_hw(hw);
-}
-
-#ifdef CONFIG_PM
-static int ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath5k_softc *sc = hw->priv;
-
-	if (test_bit(ATH_STAT_LEDSOFT, sc->status))
-		ath5k_hw_set_gpio(sc->ah, sc->led_pin, 1);
-
-	ath5k_stop_hw(sc);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
-
-	return 0;
-}
-
-static int ath5k_pci_resume(struct pci_dev *pdev)
-{
-	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath5k_softc *sc = hw->priv;
-	int err;
-
-	err = pci_set_power_state(pdev, PCI_D0);
-	if (err)
-		return err;
-
-	err = pci_enable_device(pdev);
-	if (err)
-		return err;
-
-	pci_restore_state(pdev);
-	/*
-	 * Suspend/Resume resets the PCI configuration space, so we have to
-	 * re-disable the RETRY_TIMEOUT register (0x41) to keep
-	 * PCI Tx retries from interfering with C3 CPU state
-	 */
-	pci_write_config_byte(pdev, 0x41, 0);
-
-	ath5k_init(sc);
-	if (test_bit(ATH_STAT_LEDSOFT, sc->status)) {
-		ath5k_hw_set_gpio_output(sc->ah, sc->led_pin);
-		ath5k_hw_set_gpio(sc->ah, sc->led_pin, 0);
-	}
-
-	return 0;
-}
-#else
-#define ath5k_pci_suspend NULL
-#define ath5k_pci_resume NULL
-#endif /* CONFIG_PM */
-
-static struct pci_driver ath5k_pci_drv_id = {
-	.name		= "ath5k_pci",
-	.id_table	= ath5k_pci_id_table,
-	.probe		= ath5k_pci_probe,
-	.remove		= __devexit_p(ath5k_pci_remove),
-	.suspend	= ath5k_pci_suspend,
-	.resume		= ath5k_pci_resume,
-};
-
-static int mincalibrate = 1;
-static int maxcalibrate = INT_MAX / 1000;
-#define	CTL_AUTO	-2	/* cannot be CTL_ANY or CTL_NONE */
-
-static ctl_table ath5k_static_sysctls[] = {
-#if AR_DEBUG
-	{
-	  .procname	= "debug",
-	  .mode		= 0644,
-	  .data		= &ath5k_debug,
-	  .maxlen	= sizeof(ath5k_debug),
-	  .proc_handler	= proc_dointvec
-	},
-#endif
-	{
-	  .procname	= "calibrate",
-	  .mode		= 0644,
-	  .data		= &ath5k_calinterval,
-	  .maxlen	= sizeof(ath5k_calinterval),
-	  .extra1	= &mincalibrate,
-	  .extra2	= &maxcalibrate,
-	  .proc_handler	= proc_dointvec_minmax
-	},
-	{ 0 }
-};
-static ctl_table ath5k_ath5k_table[] = {
-	{
-	  .procname	= "ath",
-	  .mode		= 0555,
-	  .child	= ath5k_static_sysctls
-	}, { 0 }
-};
-static ctl_table ath5k_root_table[] = {
-	{
-	  .ctl_name	= CTL_DEV,
-	  .procname	= "dev",
-	  .mode		= 0555,
-	  .child	= ath5k_ath5k_table
-	}, { 0 }
-};
-static struct ctl_table_header *ath5k_sysctl_header;
-
-static int __init init_ath5k_pci(void)
-{
-	int ret;
-
-	ret = pci_register_driver(&ath5k_pci_drv_id);
-	if (ret) {
-		printk(KERN_ERR "ath5k_pci: can't register pci driver\n");
-		return ret;
-	}
-	ath5k_sysctl_header = register_sysctl_table(ath5k_root_table);
-
-	return 0;
-}
-
-static void __exit exit_ath5k_pci(void)
-{
-	if (ath5k_sysctl_header)
-		unregister_sysctl_table(ath5k_sysctl_header);
-	pci_unregister_driver(&ath5k_pci_drv_id);
-}
-
-module_init(init_ath5k_pci);
-module_exit(exit_ath5k_pci);
-
-MODULE_AUTHOR("Jiri Slaby");
-MODULE_DESCRIPTION("Support for Atheros 802.11 wireless LAN cards.");
-MODULE_SUPPORTED_DEVICE("Atheros WLAN cards");
-MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(ATH_PCI_VERSION " (EXPERIMENTAL)");



