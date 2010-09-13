Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:11571 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753530Ab0IMBeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Sep 2010 21:34:15 -0400
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0885091636
	for <linux-wireless@vger.kernel.org>; Mon, 13 Sep 2010 10:34:02 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: reorder base.c to remove fwd decls
Date: Mon, 13 Sep 2010 10:33:56 +0900
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
References: <1284231996-29010-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1284231996-29010-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201009131033.56473.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun September 12 2010 04:06:36 Bob Copeland wrote:
> This change reorganizes the main ath5k file in order to re-group
> related functions and remove most of the forward declarations
> (from 61 down to 3).  This is, unfortunately, a lot of churn, but
> there should be no functional changes.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> 
> Worth the churn?  Is there any way to do this kind of patch that
> doesn't suck?

yeah, it's good!

i have a few pending patches which i'll have to re-do but that's fine with me. 
also let's fix the crypto flags in a separate patch after this.

Acked-by: Bruno Randolf <br1@einfach.org>

>  drivers/net/wireless/ath/ath5k/base.c | 3902
> ++++++++++++++++----------------- 1 files changed, 1884 insertions(+),
> 2018 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c
> b/drivers/net/wireless/ath/ath5k/base.c index f8c699d..9e4636f 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -70,11 +70,6 @@ static int modparam_all_channels;
>  module_param_named(all_channels, modparam_all_channels, bool, S_IRUGO);
>  MODULE_PARM_DESC(all_channels, "Expose all channels the device can use.");
> 
> -
> -/******************\
> -* Internal defines *
> -\******************/
> -
>  /* Module info */
>  MODULE_AUTHOR("Jiri Slaby");
>  MODULE_AUTHOR("Nick Kossifidis");
> @@ -83,6 +78,10 @@ MODULE_SUPPORTED_DEVICE("Atheros 5xxx WLAN cards");
>  MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_VERSION("0.6.0 (EXPERIMENTAL)");
> 
> +static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel
> *chan); +static int ath5k_beacon_update(struct ieee80211_hw *hw,
> +		struct ieee80211_vif *vif);
> +static void ath5k_beacon_update_timers(struct ath5k_softc *sc, u64
> bc_tsf);
> 
>  /* Known PCI ids */
>  static DEFINE_PCI_DEVICE_TABLE(ath5k_pci_id_table) = {
> @@ -190,129 +189,6 @@ static const struct ieee80211_rate ath5k_rates[] = {
>  	/* XR missing */
>  };
> 
> -/*
> - * Prototypes - PCI stack related functions
> - */
> -static int __devinit	ath5k_pci_probe(struct pci_dev *pdev,
> -				const struct pci_device_id *id);
> -static void __devexit	ath5k_pci_remove(struct pci_dev *pdev);
> -#ifdef CONFIG_PM_SLEEP
> -static int		ath5k_pci_suspend(struct device *dev);
> -static int		ath5k_pci_resume(struct device *dev);
> -
> -static SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend,
> ath5k_pci_resume); -#define ATH5K_PM_OPS	(&ath5k_pm_ops)
> -#else
> -#define ATH5K_PM_OPS	NULL
> -#endif /* CONFIG_PM_SLEEP */
> -
> -static struct pci_driver ath5k_pci_driver = {
> -	.name		= KBUILD_MODNAME,
> -	.id_table	= ath5k_pci_id_table,
> -	.probe		= ath5k_pci_probe,
> -	.remove		= __devexit_p(ath5k_pci_remove),
> -	.driver.pm	= ATH5K_PM_OPS,
> -};
> -
> -
> -
> -/*
> - * Prototypes - MAC 802.11 stack related functions
> - */
> -static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
> -static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
> -		struct ath5k_txq *txq);
> -static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel
> *chan); -static int ath5k_start(struct ieee80211_hw *hw);
> -static void ath5k_stop(struct ieee80211_hw *hw);
> -static int ath5k_add_interface(struct ieee80211_hw *hw,
> -		struct ieee80211_vif *vif);
> -static void ath5k_remove_interface(struct ieee80211_hw *hw,
> -		struct ieee80211_vif *vif);
> -static int ath5k_config(struct ieee80211_hw *hw, u32 changed);
> -static u64 ath5k_prepare_multicast(struct ieee80211_hw *hw,
> -				   struct netdev_hw_addr_list *mc_list);
> -static void ath5k_configure_filter(struct ieee80211_hw *hw,
> -		unsigned int changed_flags,
> -		unsigned int *new_flags,
> -		u64 multicast);
> -static int ath5k_set_key(struct ieee80211_hw *hw,
> -		enum set_key_cmd cmd,
> -		struct ieee80211_vif *vif, struct ieee80211_sta *sta,
> -		struct ieee80211_key_conf *key);
> -static int ath5k_get_stats(struct ieee80211_hw *hw,
> -		struct ieee80211_low_level_stats *stats);
> -static int ath5k_get_survey(struct ieee80211_hw *hw,
> -		int idx, struct survey_info *survey);
> -static u64 ath5k_get_tsf(struct ieee80211_hw *hw);
> -static void ath5k_set_tsf(struct ieee80211_hw *hw, u64 tsf);
> -static void ath5k_reset_tsf(struct ieee80211_hw *hw);
> -static int ath5k_beacon_update(struct ieee80211_hw *hw,
> -		struct ieee80211_vif *vif);
> -static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
> -		struct ieee80211_vif *vif,
> -		struct ieee80211_bss_conf *bss_conf,
> -		u32 changes);
> -static void ath5k_sw_scan_start(struct ieee80211_hw *hw);
> -static void ath5k_sw_scan_complete(struct ieee80211_hw *hw);
> -static void ath5k_set_coverage_class(struct ieee80211_hw *hw,
> -		u8 coverage_class);
> -
> -static const struct ieee80211_ops ath5k_hw_ops = {
> -	.tx 		= ath5k_tx,
> -	.start 		= ath5k_start,
> -	.stop 		= ath5k_stop,
> -	.add_interface 	= ath5k_add_interface,
> -	.remove_interface = ath5k_remove_interface,
> -	.config 	= ath5k_config,
> -	.prepare_multicast = ath5k_prepare_multicast,
> -	.configure_filter = ath5k_configure_filter,
> -	.set_key 	= ath5k_set_key,
> -	.get_stats 	= ath5k_get_stats,
> -	.get_survey	= ath5k_get_survey,
> -	.conf_tx 	= NULL,
> -	.get_tsf 	= ath5k_get_tsf,
> -	.set_tsf 	= ath5k_set_tsf,
> -	.reset_tsf 	= ath5k_reset_tsf,
> -	.bss_info_changed = ath5k_bss_info_changed,
> -	.sw_scan_start	= ath5k_sw_scan_start,
> -	.sw_scan_complete = ath5k_sw_scan_complete,
> -	.set_coverage_class = ath5k_set_coverage_class,
> -};
> -
> -/*
> - * Prototypes - Internal functions
> - */
> -/* Attach detach */
> -static int 	ath5k_attach(struct pci_dev *pdev,
> -			struct ieee80211_hw *hw);
> -static void 	ath5k_detach(struct pci_dev *pdev,
> -			struct ieee80211_hw *hw);
> -/* Channel/mode setup */
> -static inline short ath5k_ieee2mhz(short chan);
> -static unsigned int ath5k_copy_channels(struct ath5k_hw *ah,
> -				struct ieee80211_channel *channels,
> -				unsigned int mode,
> -				unsigned int max);
> -static int 	ath5k_setup_bands(struct ieee80211_hw *hw);
> -static int 	ath5k_chan_set(struct ath5k_softc *sc,
> -				struct ieee80211_channel *chan);
> -static void	ath5k_setcurmode(struct ath5k_softc *sc,
> -				unsigned int mode);
> -static void	ath5k_mode_setup(struct ath5k_softc *sc);
> -
> -/* Descriptor setup */
> -static int	ath5k_desc_alloc(struct ath5k_softc *sc,
> -				struct pci_dev *pdev);
> -static void	ath5k_desc_free(struct ath5k_softc *sc,
> -				struct pci_dev *pdev);
> -/* Buffers setup */
> -static int 	ath5k_rxbuf_setup(struct ath5k_softc *sc,
> -				struct ath5k_buf *bf);
> -static int 	ath5k_txbuf_setup(struct ath5k_softc *sc,
> -				struct ath5k_buf *bf,
> -				struct ath5k_txq *txq, int padsize);
> -
>  static inline void ath5k_txbuf_free_skb(struct ath5k_softc *sc,
>  				struct ath5k_buf *bf)
>  {
> @@ -345,35 +221,6 @@ static inline void ath5k_rxbuf_free_skb(struct
> ath5k_softc *sc, }
> 
> 
> -/* Queues setup */
> -static struct 	ath5k_txq *ath5k_txq_setup(struct ath5k_softc *sc,
> -				int qtype, int subtype);
> -static int 	ath5k_beaconq_setup(struct ath5k_hw *ah);
> -static int 	ath5k_beaconq_config(struct ath5k_softc *sc);
> -static void 	ath5k_txq_drainq(struct ath5k_softc *sc,
> -				struct ath5k_txq *txq);
> -static void 	ath5k_txq_cleanup(struct ath5k_softc *sc);
> -static void 	ath5k_txq_release(struct ath5k_softc *sc);
> -/* Rx handling */
> -static int 	ath5k_rx_start(struct ath5k_softc *sc);
> -static void 	ath5k_rx_stop(struct ath5k_softc *sc);
> -static unsigned int ath5k_rx_decrypted(struct ath5k_softc *sc,
> -					struct sk_buff *skb,
> -					struct ath5k_rx_status *rs);
> -static void 	ath5k_tasklet_rx(unsigned long data);
> -/* Tx handling */
> -static void 	ath5k_tx_processq(struct ath5k_softc *sc,
> -				struct ath5k_txq *txq);
> -static void 	ath5k_tasklet_tx(unsigned long data);
> -/* Beacon handling */
> -static int 	ath5k_beacon_setup(struct ath5k_softc *sc,
> -					struct ath5k_buf *bf);
> -static void 	ath5k_beacon_send(struct ath5k_softc *sc);
> -static void 	ath5k_beacon_config(struct ath5k_softc *sc);
> -static void	ath5k_beacon_update_timers(struct ath5k_softc *sc, u64
> bc_tsf); -static void	ath5k_tasklet_beacon(unsigned long data);
> -static void	ath5k_tasklet_ani(unsigned long data);
> -
>  static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
>  {
>  	u64 tsf = ath5k_hw_get_tsf64(ah);
> @@ -384,50 +231,6 @@ static inline u64 ath5k_extend_tsf(struct ath5k_hw
> *ah, u32 rstamp) return (tsf & ~0x7fff) | rstamp;
>  }
> 
> -/* Interrupt handling */
> -static int 	ath5k_init(struct ath5k_softc *sc);
> -static int 	ath5k_stop_locked(struct ath5k_softc *sc);
> -static int 	ath5k_stop_hw(struct ath5k_softc *sc);
> -static irqreturn_t ath5k_intr(int irq, void *dev_id);
> -static void ath5k_reset_work(struct work_struct *work);
> -
> -static void 	ath5k_tasklet_calibrate(unsigned long data);
> -
> -/*
> - * Module init/exit functions
> - */
> -static int __init
> -init_ath5k_pci(void)
> -{
> -	int ret;
> -
> -	ath5k_debug_init();
> -
> -	ret = pci_register_driver(&ath5k_pci_driver);
> -	if (ret) {
> -		printk(KERN_ERR "ath5k_pci: can't register pci driver\n");
> -		return ret;
> -	}
> -
> -	return 0;
> -}
> -
> -static void __exit
> -exit_ath5k_pci(void)
> -{
> -	pci_unregister_driver(&ath5k_pci_driver);
> -
> -	ath5k_debug_finish();
> -}
> -
> -module_init(init_ath5k_pci);
> -module_exit(exit_ath5k_pci);
> -
> -
> -/********************\
> -* PCI Initialization *
> -\********************/
> -
>  static const char *
>  ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val)
>  {
> @@ -466,1546 +269,1084 @@ static const struct ath_ops ath5k_common_ops = {
>  	.write = ath5k_iowrite32,
>  };
> 
> -static int __devinit
> -ath5k_pci_probe(struct pci_dev *pdev,
> -		const struct pci_device_id *id)
> +/***********************\
> +* Driver Initialization *
> +\***********************/
> +
> +static int ath5k_reg_notifier(struct wiphy *wiphy, struct
> regulatory_request *request) {
> -	void __iomem *mem;
> -	struct ath5k_softc *sc;
> -	struct ath_common *common;
> -	struct ieee80211_hw *hw;
> -	int ret;
> -	u8 csz;
> +	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
> +	struct ath5k_softc *sc = hw->priv;
> +	struct ath_regulatory *regulatory = ath5k_hw_regulatory(sc->ah);
> 
> -	/*
> -	 * L0s needs to be disabled on all ath5k cards.
> -	 *
> -	 * For distributions shipping with CONFIG_PCIEASPM (this will be enabled
> -	 * by default in the future in 2.6.36) this will also mean both L1 and
> -	 * L0s will be disabled when a pre 1.1 PCIe device is detected. We do
> -	 * know L1 works correctly even for all ath5k pre 1.1 PCIe devices
> -	 * though but cannot currently undue the effect of a blacklist, for
> -	 * details you can read pcie_aspm_sanity_check() and see how it adjusts
> -	 * the device link capability.
> -	 *
> -	 * It may be possible in the future to implement some PCI API to allow
> -	 * drivers to override blacklists for pre 1.1 PCIe but for now it is
> -	 * best to accept that both L0s and L1 will be disabled completely for
> -	 * distributions shipping with CONFIG_PCIEASPM rather than having this
> -	 * issue present. Motivation for adding this new API will be to help
> -	 * with power consumption for some of these devices.
> -	 */
> -	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
> +	return ath_reg_notifier_apply(wiphy, request, regulatory);
> +}
> 
> -	ret = pci_enable_device(pdev);
> -	if (ret) {
> -		dev_err(&pdev->dev, "can't enable device\n");
> -		goto err;
> -	}
> +/********************\
> +* Channel/mode setup *
> +\********************/
> 
> -	/* XXX 32-bit addressing only */
> -	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> -	if (ret) {
> -		dev_err(&pdev->dev, "32-bit DMA not available\n");
> -		goto err_dis;
> -	}
> +/*
> + * Convert IEEE channel number to MHz frequency.
> + */
> +static inline short
> +ath5k_ieee2mhz(short chan)
> +{
> +	if (chan <= 14 || chan >= 27)
> +		return ieee80211chan2mhz(chan);
> +	else
> +		return 2212 + chan * 20;
> +}
> 
> -	/*
> -	 * Cache line size is used to size and align various
> -	 * structures used to communicate with the hardware.
> -	 */
> -	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &csz);
> -	if (csz == 0) {
> -		/*
> -		 * Linux 2.4.18 (at least) writes the cache line size
> -		 * register as a 16-bit wide register which is wrong.
> -		 * We must have this setup properly for rx buffer
> -		 * DMA to work so force a reasonable value here if it
> -		 * comes up zero.
> -		 */
> -		csz = L1_CACHE_BYTES >> 2;
> -		pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, csz);
> -	}
> -	/*
> -	 * The default setting of latency timer yields poor results,
> -	 * set it to the value used by other systems.  It may be worth
> -	 * tweaking this setting more.
> -	 */
> -	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0xa8);
> +/*
> + * Returns true for the channel numbers used without all_channels
> modparam. + */
> +static bool ath5k_is_standard_channel(short chan)
> +{
> +	return ((chan <= 14) ||
> +		/* UNII 1,2 */
> +		((chan & 3) == 0 && chan >= 36 && chan <= 64) ||
> +		/* midband */
> +		((chan & 3) == 0 && chan >= 100 && chan <= 140) ||
> +		/* UNII-3 */
> +		((chan & 3) == 1 && chan >= 149 && chan <= 165));
> +}
> 
> -	/* Enable bus mastering */
> -	pci_set_master(pdev);
> +static unsigned int
> +ath5k_copy_channels(struct ath5k_hw *ah,
> +		struct ieee80211_channel *channels,
> +		unsigned int mode,
> +		unsigned int max)
> +{
> +	unsigned int i, count, size, chfreq, freq, ch;
> 
> -	/*
> -	 * Disable the RETRY_TIMEOUT register (0x41) to keep
> -	 * PCI Tx retries from interfering with C3 CPU state.
> -	 */
> -	pci_write_config_byte(pdev, 0x41, 0);
> +	if (!test_bit(mode, ah->ah_modes))
> +		return 0;
> 
> -	ret = pci_request_region(pdev, 0, "ath5k");
> -	if (ret) {
> -		dev_err(&pdev->dev, "cannot reserve PCI memory region\n");
> -		goto err_dis;
> +	switch (mode) {
> +	case AR5K_MODE_11A:
> +	case AR5K_MODE_11A_TURBO:
> +		/* 1..220, but 2GHz frequencies are filtered by check_channel */
> +		size = 220 ;
> +		chfreq = CHANNEL_5GHZ;
> +		break;
> +	case AR5K_MODE_11B:
> +	case AR5K_MODE_11G:
> +	case AR5K_MODE_11G_TURBO:
> +		size = 26;
> +		chfreq = CHANNEL_2GHZ;
> +		break;
> +	default:
> +		ATH5K_WARN(ah->ah_sc, "bad mode, not copying channels\n");
> +		return 0;
>  	}
> 
> -	mem = pci_iomap(pdev, 0, 0);
> -	if (!mem) {
> -		dev_err(&pdev->dev, "cannot remap PCI memory region\n") ;
> -		ret = -EIO;
> -		goto err_reg;
> -	}
> +	for (i = 0, count = 0; i < size && max > 0; i++) {
> +		ch = i + 1 ;
> +		freq = ath5k_ieee2mhz(ch);
> 
> -	/*
> -	 * Allocate hw (mac80211 main struct)
> -	 * and hw->priv (driver private data)
> -	 */
> -	hw = ieee80211_alloc_hw(sizeof(*sc), &ath5k_hw_ops);
> -	if (hw == NULL) {
> -		dev_err(&pdev->dev, "cannot allocate ieee80211_hw\n");
> -		ret = -ENOMEM;
> -		goto err_map;
> -	}
> -
> -	dev_info(&pdev->dev, "registered as '%s'\n", wiphy_name(hw->wiphy));
> -
> -	/* Initialize driver private data */
> -	SET_IEEE80211_DEV(hw, &pdev->dev);
> -	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
> -		    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
> -		    IEEE80211_HW_SIGNAL_DBM;
> +		/* Check if channel is supported by the chipset */
> +		if (!ath5k_channel_ok(ah, freq, chfreq))
> +			continue;
> 
> -	hw->wiphy->interface_modes =
> -		BIT(NL80211_IFTYPE_AP) |
> -		BIT(NL80211_IFTYPE_STATION) |
> -		BIT(NL80211_IFTYPE_ADHOC) |
> -		BIT(NL80211_IFTYPE_MESH_POINT);
> +		if (!modparam_all_channels && !ath5k_is_standard_channel(ch))
> +			continue;
> 
> -	hw->extra_tx_headroom = 2;
> -	hw->channel_change_time = 5000;
> -	sc = hw->priv;
> -	sc->hw = hw;
> -	sc->pdev = pdev;
> +		/* Write channel info and increment counter */
> +		channels[count].center_freq = freq;
> +		channels[count].band = (chfreq == CHANNEL_2GHZ) ?
> +			IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
> +		switch (mode) {
> +		case AR5K_MODE_11A:
> +		case AR5K_MODE_11G:
> +			channels[count].hw_value = chfreq | CHANNEL_OFDM;
> +			break;
> +		case AR5K_MODE_11A_TURBO:
> +		case AR5K_MODE_11G_TURBO:
> +			channels[count].hw_value = chfreq |
> +				CHANNEL_OFDM | CHANNEL_TURBO;
> +			break;
> +		case AR5K_MODE_11B:
> +			channels[count].hw_value = CHANNEL_B;
> +		}
> 
> -	ath5k_debug_init_device(sc);
> +		count++;
> +		max--;
> +	}
> 
> -	/*
> -	 * Mark the device as detached to avoid processing
> -	 * interrupts until setup is complete.
> -	 */
> -	__set_bit(ATH_STAT_INVALID, sc->status);
> +	return count;
> +}
> 
> -	sc->iobase = mem; /* So we can unmap it on detach */
> -	sc->opmode = NL80211_IFTYPE_STATION;
> -	sc->bintval = 1000;
> -	mutex_init(&sc->lock);
> -	spin_lock_init(&sc->rxbuflock);
> -	spin_lock_init(&sc->txbuflock);
> -	spin_lock_init(&sc->block);
> +static void
> +ath5k_setup_rate_idx(struct ath5k_softc *sc, struct
> ieee80211_supported_band *b) +{
> +	u8 i;
> 
> -	/* Set private data */
> -	pci_set_drvdata(pdev, sc);
> +	for (i = 0; i < AR5K_MAX_RATES; i++)
> +		sc->rate_idx[b->band][i] = -1;
> 
> -	/* Setup interrupt handler */
> -	ret = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
> -	if (ret) {
> -		ATH5K_ERR(sc, "request_irq failed\n");
> -		goto err_free;
> +	for (i = 0; i < b->n_bitrates; i++) {
> +		sc->rate_idx[b->band][b->bitrates[i].hw_value] = i;
> +		if (b->bitrates[i].hw_value_short)
> +			sc->rate_idx[b->band][b->bitrates[i].hw_value_short] = i;
>  	}
> +}
> 
> -	/* If we passed the test, malloc an ath5k_hw struct */
> -	sc->ah = kzalloc(sizeof(struct ath5k_hw), GFP_KERNEL);
> -	if (!sc->ah) {
> -		ret = -ENOMEM;
> -		ATH5K_ERR(sc, "out of memory\n");
> -		goto err_irq;
> -	}
> +static int
> +ath5k_setup_bands(struct ieee80211_hw *hw)
> +{
> +	struct ath5k_softc *sc = hw->priv;
> +	struct ath5k_hw *ah = sc->ah;
> +	struct ieee80211_supported_band *sband;
> +	int max_c, count_c = 0;
> +	int i;
> 
> -	sc->ah->ah_sc = sc;
> -	sc->ah->ah_iobase = sc->iobase;
> -	common = ath5k_hw_common(sc->ah);
> -	common->ops = &ath5k_common_ops;
> -	common->ah = sc->ah;
> -	common->hw = hw;
> -	common->cachelsz = csz << 2; /* convert to bytes */
> +	BUILD_BUG_ON(ARRAY_SIZE(sc->sbands) < IEEE80211_NUM_BANDS);
> +	max_c = ARRAY_SIZE(sc->channels);
> 
> -	/* Initialize device */
> -	ret = ath5k_hw_attach(sc);
> -	if (ret) {
> -		goto err_free_ah;
> -	}
> +	/* 2GHz band */
> +	sband = &sc->sbands[IEEE80211_BAND_2GHZ];
> +	sband->band = IEEE80211_BAND_2GHZ;
> +	sband->bitrates = &sc->rates[IEEE80211_BAND_2GHZ][0];
> 
> -	/* set up multi-rate retry capabilities */
> -	if (sc->ah->ah_version == AR5K_AR5212) {
> -		hw->max_rates = 4;
> -		hw->max_rate_tries = 11;
> -	}
> +	if (test_bit(AR5K_MODE_11G, sc->ah->ah_capabilities.cap_mode)) {
> +		/* G mode */
> +		memcpy(sband->bitrates, &ath5k_rates[0],
> +		       sizeof(struct ieee80211_rate) * 12);
> +		sband->n_bitrates = 12;
> 
> -	/* Finish private driver data initialization */
> -	ret = ath5k_attach(pdev, hw);
> -	if (ret)
> -		goto err_ah;
> +		sband->channels = sc->channels;
> +		sband->n_channels = ath5k_copy_channels(ah, sband->channels,
> +					AR5K_MODE_11G, max_c);
> 
> -	ATH5K_INFO(sc, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
> -			ath5k_chip_name(AR5K_VERSION_MAC, sc->ah->ah_mac_srev),
> -					sc->ah->ah_mac_srev,
> -					sc->ah->ah_phy_revision);
> +		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
> +		count_c = sband->n_channels;
> +		max_c -= count_c;
> +	} else if (test_bit(AR5K_MODE_11B, sc->ah->ah_capabilities.cap_mode)) {
> +		/* B mode */
> +		memcpy(sband->bitrates, &ath5k_rates[0],
> +		       sizeof(struct ieee80211_rate) * 4);
> +		sband->n_bitrates = 4;
> 
> -	if (!sc->ah->ah_single_chip) {
> -		/* Single chip radio (!RF5111) */
> -		if (sc->ah->ah_radio_5ghz_revision &&
> -			!sc->ah->ah_radio_2ghz_revision) {
> -			/* No 5GHz support -> report 2GHz radio */
> -			if (!test_bit(AR5K_MODE_11A,
> -				sc->ah->ah_capabilities.cap_mode)) {
> -				ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
> -					ath5k_chip_name(AR5K_VERSION_RAD,
> -						sc->ah->ah_radio_5ghz_revision),
> -						sc->ah->ah_radio_5ghz_revision);
> -			/* No 2GHz support (5110 and some
> -			 * 5Ghz only cards) -> report 5Ghz radio */
> -			} else if (!test_bit(AR5K_MODE_11B,
> -				sc->ah->ah_capabilities.cap_mode)) {
> -				ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
> -					ath5k_chip_name(AR5K_VERSION_RAD,
> -						sc->ah->ah_radio_5ghz_revision),
> -						sc->ah->ah_radio_5ghz_revision);
> -			/* Multiband radio */
> -			} else {
> -				ATH5K_INFO(sc, "RF%s multiband radio found"
> -					" (0x%x)\n",
> -					ath5k_chip_name(AR5K_VERSION_RAD,
> -						sc->ah->ah_radio_5ghz_revision),
> -						sc->ah->ah_radio_5ghz_revision);
> +		/* 5211 only supports B rates and uses 4bit rate codes
> +		 * (e.g normally we have 0x1B for 1M, but on 5211 we have 0x0B)
> +		 * fix them up here:
> +		 */
> +		if (ah->ah_version == AR5K_AR5211) {
> +			for (i = 0; i < 4; i++) {
> +				sband->bitrates[i].hw_value =
> +					sband->bitrates[i].hw_value & 0xF;
> +				sband->bitrates[i].hw_value_short =
> +					sband->bitrates[i].hw_value_short & 0xF;
>  			}
>  		}
> -		/* Multi chip radio (RF5111 - RF2111) ->
> -		 * report both 2GHz/5GHz radios */
> -		else if (sc->ah->ah_radio_5ghz_revision &&
> -				sc->ah->ah_radio_2ghz_revision){
> -			ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
> -				ath5k_chip_name(AR5K_VERSION_RAD,
> -					sc->ah->ah_radio_5ghz_revision),
> -					sc->ah->ah_radio_5ghz_revision);
> -			ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
> -				ath5k_chip_name(AR5K_VERSION_RAD,
> -					sc->ah->ah_radio_2ghz_revision),
> -					sc->ah->ah_radio_2ghz_revision);
> -		}
> -	}
> 
> +		sband->channels = sc->channels;
> +		sband->n_channels = ath5k_copy_channels(ah, sband->channels,
> +					AR5K_MODE_11B, max_c);
> 
> -	/* ready to process interrupts */
> -	__clear_bit(ATH_STAT_INVALID, sc->status);
> +		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
> +		count_c = sband->n_channels;
> +		max_c -= count_c;
> +	}
> +	ath5k_setup_rate_idx(sc, sband);
> 
> -	return 0;
> -err_ah:
> -	ath5k_hw_detach(sc->ah);
> -err_free_ah:
> -	kfree(sc->ah);
> -err_irq:
> -	free_irq(pdev->irq, sc);
> -err_free:
> -	ieee80211_free_hw(hw);
> -err_map:
> -	pci_iounmap(pdev, mem);
> -err_reg:
> -	pci_release_region(pdev, 0);
> -err_dis:
> -	pci_disable_device(pdev);
> -err:
> -	return ret;
> -}
> +	/* 5GHz band, A mode */
> +	if (test_bit(AR5K_MODE_11A, sc->ah->ah_capabilities.cap_mode)) {
> +		sband = &sc->sbands[IEEE80211_BAND_5GHZ];
> +		sband->band = IEEE80211_BAND_5GHZ;
> +		sband->bitrates = &sc->rates[IEEE80211_BAND_5GHZ][0];
> 
> -static void __devexit
> -ath5k_pci_remove(struct pci_dev *pdev)
> -{
> -	struct ath5k_softc *sc = pci_get_drvdata(pdev);
> +		memcpy(sband->bitrates, &ath5k_rates[4],
> +		       sizeof(struct ieee80211_rate) * 8);
> +		sband->n_bitrates = 8;
> 
> -	ath5k_debug_finish_device(sc);
> -	ath5k_detach(pdev, sc->hw);
> -	ath5k_hw_detach(sc->ah);
> -	kfree(sc->ah);
> -	free_irq(pdev->irq, sc);
> -	pci_iounmap(pdev, sc->iobase);
> -	pci_release_region(pdev, 0);
> -	pci_disable_device(pdev);
> -	ieee80211_free_hw(sc->hw);
> -}
> +		sband->channels = &sc->channels[count_c];
> +		sband->n_channels = ath5k_copy_channels(ah, sband->channels,
> +					AR5K_MODE_11A, max_c);
> 
> -#ifdef CONFIG_PM_SLEEP
> -static int ath5k_pci_suspend(struct device *dev)
> -{
> -	struct ath5k_softc *sc = pci_get_drvdata(to_pci_dev(dev));
> +		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
> +	}
> +	ath5k_setup_rate_idx(sc, sband);
> +
> +	ath5k_debug_dump_bands(sc);
> 
> -	ath5k_led_off(sc);
>  	return 0;
>  }
> 
> -static int ath5k_pci_resume(struct device *dev)
> -{
> -	struct pci_dev *pdev = to_pci_dev(dev);
> -	struct ath5k_softc *sc = pci_get_drvdata(pdev);
> -
> +/*
> + * Set/change channels. We always reset the chip.
> + * To accomplish this we must first cleanup any pending DMA,
> + * then restart stuff after a la  ath5k_init.
> + *
> + * Called with sc->lock.
> + */
> +static int
> +ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
> +{
> +	ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
> +		  "channel set, resetting (%u -> %u MHz)\n",
> +		  sc->curchan->center_freq, chan->center_freq);
> +
>  	/*
> -	 * Suspend/Resume resets the PCI configuration space, so we have to
> -	 * re-disable the RETRY_TIMEOUT register (0x41) to keep
> -	 * PCI Tx retries from interfering with C3 CPU state
> +	 * To switch channels clear any pending DMA operations;
> +	 * wait long enough for the RX fifo to drain, reset the
> +	 * hardware at the new frequency, and then re-enable
> +	 * the relevant bits of the h/w.
>  	 */
> -	pci_write_config_byte(pdev, 0x41, 0);
> -
> -	ath5k_led_enable(sc);
> -	return 0;
> +	return ath5k_reset(sc, chan);
>  }
> -#endif /* CONFIG_PM_SLEEP */
> -
> -
> -/***********************\
> -* Driver Initialization *
> -\***********************/
> 
> -static int ath5k_reg_notifier(struct wiphy *wiphy, struct
> regulatory_request *request) +static void
> +ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
>  {
> -	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
> -	struct ath5k_softc *sc = hw->priv;
> -	struct ath_regulatory *regulatory = ath5k_hw_regulatory(sc->ah);
> +	sc->curmode = mode;
> 
> -	return ath_reg_notifier_apply(wiphy, request, regulatory);
> +	if (mode == AR5K_MODE_11A) {
> +		sc->curband = &sc->sbands[IEEE80211_BAND_5GHZ];
> +	} else {
> +		sc->curband = &sc->sbands[IEEE80211_BAND_2GHZ];
> +	}
>  }
> 
> -static int
> -ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
> +static void
> +ath5k_mode_setup(struct ath5k_softc *sc)
>  {
> -	struct ath5k_softc *sc = hw->priv;
>  	struct ath5k_hw *ah = sc->ah;
> -	struct ath_regulatory *regulatory = ath5k_hw_regulatory(ah);
> -	u8 mac[ETH_ALEN] = {};
> -	int ret;
> +	u32 rfilt;
> 
> -	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "devid 0x%x\n", pdev->device);
> +	/* configure rx filter */
> +	rfilt = sc->filter_flags;
> +	ath5k_hw_set_rx_filter(ah, rfilt);
> 
> -	/*
> -	 * Check if the MAC has multi-rate retry support.
> -	 * We do this by trying to setup a fake extended
> -	 * descriptor.  MACs that don't have support will
> -	 * return false w/o doing anything.  MACs that do
> -	 * support it will return true w/o doing anything.
> -	 */
> -	ret = ath5k_hw_setup_mrr_tx_desc(ah, NULL, 0, 0, 0, 0, 0, 0);
> +	if (ath5k_hw_hasbssidmask(ah))
> +		ath5k_hw_set_bssid_mask(ah, sc->bssidmask);
> 
> -	if (ret < 0)
> -		goto err;
> -	if (ret > 0)
> -		__set_bit(ATH_STAT_MRRETRY, sc->status);
> +	/* configure operational mode */
> +	ath5k_hw_set_opmode(ah, sc->opmode);
> 
> -	/*
> -	 * Collect the channel list.  The 802.11 layer
> -	 * is resposible for filtering this list based
> -	 * on settings like the phy mode and regulatory
> -	 * domain restrictions.
> -	 */
> -	ret = ath5k_setup_bands(hw);
> -	if (ret) {
> -		ATH5K_ERR(sc, "can't get channels\n");
> -		goto err;
> -	}
> +	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d\n", sc->opmode);
> +	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "RX filter 0x%x\n", rfilt);
> +}
> 
> -	/* NB: setup here so ath5k_rate_update is happy */
> -	if (test_bit(AR5K_MODE_11A, ah->ah_modes))
> -		ath5k_setcurmode(sc, AR5K_MODE_11A);
> -	else
> -		ath5k_setcurmode(sc, AR5K_MODE_11B);
> +static inline int
> +ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
> +{
> +	int rix;
> 
> -	/*
> -	 * Allocate tx+rx descriptors and populate the lists.
> -	 */
> -	ret = ath5k_desc_alloc(sc, pdev);
> -	if (ret) {
> -		ATH5K_ERR(sc, "can't allocate descriptors\n");
> -		goto err;
> -	}
> +	/* return base rate on errors */
> +	if (WARN(hw_rix < 0 || hw_rix >= AR5K_MAX_RATES,
> +			"hw_rix out of bounds: %x\n", hw_rix))
> +		return 0;
> +
> +	rix = sc->rate_idx[sc->curband->band][hw_rix];
> +	if (WARN(rix < 0, "invalid hw_rix: %x\n", hw_rix))
> +		rix = 0;
> +
> +	return rix;
> +}
> +
> +/***************\
> +* Buffers setup *
> +\***************/
> +
> +static
> +struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t
> *skb_addr) +{
> +	struct ath_common *common = ath5k_hw_common(sc->ah);
> +	struct sk_buff *skb;
> 
>  	/*
> -	 * Allocate hardware transmit queues: one queue for
> -	 * beacon frames and one data queue for each QoS
> -	 * priority.  Note that hw functions handle resetting
> -	 * these queues at the needed time.
> +	 * Allocate buffer with headroom_needed space for the
> +	 * fake physical layer header at the start.
>  	 */
> -	ret = ath5k_beaconq_setup(ah);
> -	if (ret < 0) {
> -		ATH5K_ERR(sc, "can't setup a beacon xmit queue\n");
> -		goto err_desc;
> -	}
> -	sc->bhalq = ret;
> -	sc->cabq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_CAB, 0);
> -	if (IS_ERR(sc->cabq)) {
> -		ATH5K_ERR(sc, "can't setup cab queue\n");
> -		ret = PTR_ERR(sc->cabq);
> -		goto err_bhal;
> -	}
> +	skb = ath_rxbuf_alloc(common,
> +			      common->rx_bufsize,
> +			      GFP_ATOMIC);
> 
> -	sc->txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
> -	if (IS_ERR(sc->txq)) {
> -		ATH5K_ERR(sc, "can't setup xmit queue\n");
> -		ret = PTR_ERR(sc->txq);
> -		goto err_queues;
> +	if (!skb) {
> +		ATH5K_ERR(sc, "can't alloc skbuff of size %u\n",
> +				common->rx_bufsize);
> +		return NULL;
>  	}
> 
> -	tasklet_init(&sc->rxtq, ath5k_tasklet_rx, (unsigned long)sc);
> -	tasklet_init(&sc->txtq, ath5k_tasklet_tx, (unsigned long)sc);
> -	tasklet_init(&sc->calib, ath5k_tasklet_calibrate, (unsigned long)sc);
> -	tasklet_init(&sc->beacontq, ath5k_tasklet_beacon, (unsigned long)sc);
> -	tasklet_init(&sc->ani_tasklet, ath5k_tasklet_ani, (unsigned long)sc);
> -
> -	INIT_WORK(&sc->reset_work, ath5k_reset_work);
> -
> -	ret = ath5k_eeprom_read_mac(ah, mac);
> -	if (ret) {
> -		ATH5K_ERR(sc, "unable to read address from EEPROM: 0x%04x\n",
> -			sc->pdev->device);
> -		goto err_queues;
> +	*skb_addr = pci_map_single(sc->pdev,
> +				   skb->data, common->rx_bufsize,
> +				   PCI_DMA_FROMDEVICE);
> +	if (unlikely(pci_dma_mapping_error(sc->pdev, *skb_addr))) {
> +		ATH5K_ERR(sc, "%s: DMA mapping failed\n", __func__);
> +		dev_kfree_skb(skb);
> +		return NULL;
>  	}
> +	return skb;
> +}
> 
> -	SET_IEEE80211_PERM_ADDR(hw, mac);
> -	/* All MAC address bits matter for ACKs */
> -	memcpy(sc->bssidmask, ath_bcast_mac, ETH_ALEN);
> -	ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
> +static int
> +ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
> +{
> +	struct ath5k_hw *ah = sc->ah;
> +	struct sk_buff *skb = bf->skb;
> +	struct ath5k_desc *ds;
> +	int ret;
> 
> -	regulatory->current_rd = ah->ah_capabilities.cap_eeprom.ee_regdomain;
> -	ret = ath_regd_init(regulatory, hw->wiphy, ath5k_reg_notifier);
> -	if (ret) {
> -		ATH5K_ERR(sc, "can't initialize regulatory system\n");
> -		goto err_queues;
> +	if (!skb) {
> +		skb = ath5k_rx_skb_alloc(sc, &bf->skbaddr);
> +		if (!skb)
> +			return -ENOMEM;
> +		bf->skb = skb;
>  	}
> 
> -	ret = ieee80211_register_hw(hw);
> +	/*
> +	 * Setup descriptors.  For receive we always terminate
> +	 * the descriptor list with a self-linked entry so we'll
> +	 * not get overrun under high load (as can happen with a
> +	 * 5212 when ANI processing enables PHY error frames).
> +	 *
> +	 * To ensure the last descriptor is self-linked we create
> +	 * each descriptor as self-linked and add it to the end.  As
> +	 * each additional descriptor is added the previous self-linked
> +	 * entry is "fixed" naturally.  This should be safe even
> +	 * if DMA is happening.  When processing RX interrupts we
> +	 * never remove/process the last, self-linked, entry on the
> +	 * descriptor list.  This ensures the hardware always has
> +	 * someplace to write a new frame.
> +	 */
> +	ds = bf->desc;
> +	ds->ds_link = bf->daddr;	/* link to self */
> +	ds->ds_data = bf->skbaddr;
> +	ret = ath5k_hw_setup_rx_desc(ah, ds, ah->common.rx_bufsize, 0);
>  	if (ret) {
> -		ATH5K_ERR(sc, "can't register ieee80211 hw\n");
> -		goto err_queues;
> +		ATH5K_ERR(sc, "%s: could not setup RX desc\n", __func__);
> +		return ret;
>  	}
> 
> -	if (!ath_is_world_regd(regulatory))
> -		regulatory_hint(hw->wiphy, regulatory->alpha2);
> -
> -	ath5k_init_leds(sc);
> -
> -	ath5k_sysfs_register(sc);
> -
> +	if (sc->rxlink != NULL)
> +		*sc->rxlink = bf->daddr;
> +	sc->rxlink = &ds->ds_link;
>  	return 0;
> -err_queues:
> -	ath5k_txq_release(sc);
> -err_bhal:
> -	ath5k_hw_release_tx_queue(ah, sc->bhalq);
> -err_desc:
> -	ath5k_desc_free(sc, pdev);
> -err:
> -	return ret;
>  }
> 
> -static void
> -ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
> +static enum ath5k_pkt_type get_hw_packet_type(struct sk_buff *skb)
>  {
> -	struct ath5k_softc *sc = hw->priv;
> +	struct ieee80211_hdr *hdr;
> +	enum ath5k_pkt_type htype;
> +	__le16 fc;
> 
> -	/*
> -	 * NB: the order of these is important:
> -	 * o call the 802.11 layer before detaching ath5k_hw to
> -	 *   ensure callbacks into the driver to delete global
> -	 *   key cache entries can be handled
> -	 * o reclaim the tx queue data structures after calling
> -	 *   the 802.11 layer as we'll get called back to reclaim
> -	 *   node state and potentially want to use them
> -	 * o to cleanup the tx queues the hal is called, so detach
> -	 *   it last
> -	 * XXX: ??? detach ath5k_hw ???
> -	 * Other than that, it's straightforward...
> -	 */
> -	ieee80211_unregister_hw(hw);
> -	ath5k_desc_free(sc, pdev);
> -	ath5k_txq_release(sc);
> -	ath5k_hw_release_tx_queue(sc->ah, sc->bhalq);
> -	ath5k_unregister_leds(sc);
> -
> -	ath5k_sysfs_unregister(sc);
> -	/*
> -	 * NB: can't reclaim these until after ieee80211_ifdetach
> -	 * returns because we'll get called back to reclaim node
> -	 * state and potentially want to use them.
> -	 */
> -}
> -
> -
> -
> -
> -/********************\
> -* Channel/mode setup *
> -\********************/
> +	hdr = (struct ieee80211_hdr *)skb->data;
> +	fc = hdr->frame_control;
> 
> -/*
> - * Convert IEEE channel number to MHz frequency.
> - */
> -static inline short
> -ath5k_ieee2mhz(short chan)
> -{
> -	if (chan <= 14 || chan >= 27)
> -		return ieee80211chan2mhz(chan);
> +	if (ieee80211_is_beacon(fc))
> +		htype = AR5K_PKT_TYPE_BEACON;
> +	else if (ieee80211_is_probe_resp(fc))
> +		htype = AR5K_PKT_TYPE_PROBE_RESP;
> +	else if (ieee80211_is_atim(fc))
> +		htype = AR5K_PKT_TYPE_ATIM;
> +	else if (ieee80211_is_pspoll(fc))
> +		htype = AR5K_PKT_TYPE_PSPOLL;
>  	else
> -		return 2212 + chan * 20;
> -}
> +		htype = AR5K_PKT_TYPE_NORMAL;
> 
> -/*
> - * Returns true for the channel numbers used without all_channels
> modparam. - */
> -static bool ath5k_is_standard_channel(short chan)
> -{
> -	return ((chan <= 14) ||
> -		/* UNII 1,2 */
> -		((chan & 3) == 0 && chan >= 36 && chan <= 64) ||
> -		/* midband */
> -		((chan & 3) == 0 && chan >= 100 && chan <= 140) ||
> -		/* UNII-3 */
> -		((chan & 3) == 1 && chan >= 149 && chan <= 165));
> +	return htype;
>  }
> 
> -static unsigned int
> -ath5k_copy_channels(struct ath5k_hw *ah,
> -		struct ieee80211_channel *channels,
> -		unsigned int mode,
> -		unsigned int max)
> +static int
> +ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
> +		  struct ath5k_txq *txq, int padsize)
>  {
> -	unsigned int i, count, size, chfreq, freq, ch;
> +	struct ath5k_hw *ah = sc->ah;
> +	struct ath5k_desc *ds = bf->desc;
> +	struct sk_buff *skb = bf->skb;
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	unsigned int pktlen, flags, keyidx = AR5K_TXKEYIX_INVALID;
> +	struct ieee80211_rate *rate;
> +	unsigned int mrr_rate[3], mrr_tries[3];
> +	int i, ret;
> +	u16 hw_rate;
> +	u16 cts_rate = 0;
> +	u16 duration = 0;
> +	u8 rc_flags;
> 
> -	if (!test_bit(mode, ah->ah_modes))
> -		return 0;
> +	flags = AR5K_TXDESC_INTREQ | AR5K_TXDESC_CLRDMASK;
> 
> -	switch (mode) {
> -	case AR5K_MODE_11A:
> -	case AR5K_MODE_11A_TURBO:
> -		/* 1..220, but 2GHz frequencies are filtered by check_channel */
> -		size = 220 ;
> -		chfreq = CHANNEL_5GHZ;
> -		break;
> -	case AR5K_MODE_11B:
> -	case AR5K_MODE_11G:
> -	case AR5K_MODE_11G_TURBO:
> -		size = 26;
> -		chfreq = CHANNEL_2GHZ;
> -		break;
> -	default:
> -		ATH5K_WARN(ah->ah_sc, "bad mode, not copying channels\n");
> -		return 0;
> +	/* XXX endianness */
> +	bf->skbaddr = pci_map_single(sc->pdev, skb->data, skb->len,
> +			PCI_DMA_TODEVICE);
> +
> +	rate = ieee80211_get_tx_rate(sc->hw, info);
> +	if (!rate) {
> +		ret = -EINVAL;
> +		goto err_unmap;
>  	}
> 
> -	for (i = 0, count = 0; i < size && max > 0; i++) {
> -		ch = i + 1 ;
> -		freq = ath5k_ieee2mhz(ch);
> +	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
> +		flags |= AR5K_TXDESC_NOACK;
> 
> -		/* Check if channel is supported by the chipset */
> -		if (!ath5k_channel_ok(ah, freq, chfreq))
> -			continue;
> +	rc_flags = info->control.rates[0].flags;
> +	hw_rate = (rc_flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE) ?
> +		rate->hw_value_short : rate->hw_value;
> 
> -		if (!modparam_all_channels && !ath5k_is_standard_channel(ch))
> -			continue;
> +	pktlen = skb->len;
> 
> -		/* Write channel info and increment counter */
> -		channels[count].center_freq = freq;
> -		channels[count].band = (chfreq == CHANNEL_2GHZ) ?
> -			IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
> -		switch (mode) {
> -		case AR5K_MODE_11A:
> -		case AR5K_MODE_11G:
> -			channels[count].hw_value = chfreq | CHANNEL_OFDM;
> -			break;
> -		case AR5K_MODE_11A_TURBO:
> -		case AR5K_MODE_11G_TURBO:
> -			channels[count].hw_value = chfreq |
> -				CHANNEL_OFDM | CHANNEL_TURBO;
> +	/* FIXME: If we are in g mode and rate is a CCK rate
> +	 * subtract ah->ah_txpower.txp_cck_ofdm_pwr_delta
> +	 * from tx power (value is in dB units already) */
> +	if (info->control.hw_key) {
> +		keyidx = info->control.hw_key->hw_key_idx;
> +		pktlen += info->control.hw_key->icv_len;
> +	}
> +	if (rc_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
> +		flags |= AR5K_TXDESC_RTSENA;
> +		cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
> +		duration = le16_to_cpu(ieee80211_rts_duration(sc->hw,
> +			sc->vif, pktlen, info));
> +	}
> +	if (rc_flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
> +		flags |= AR5K_TXDESC_CTSENA;
> +		cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
> +		duration = le16_to_cpu(ieee80211_ctstoself_duration(sc->hw,
> +			sc->vif, pktlen, info));
> +	}
> +	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
> +		ieee80211_get_hdrlen_from_skb(skb), padsize,
> +		get_hw_packet_type(skb),
> +		(sc->power_level * 2),
> +		hw_rate,
> +		info->control.rates[0].count, keyidx, ah->ah_tx_ant, flags,
> +		cts_rate, duration);
> +	if (ret)
> +		goto err_unmap;
> +
> +	memset(mrr_rate, 0, sizeof(mrr_rate));
> +	memset(mrr_tries, 0, sizeof(mrr_tries));
> +	for (i = 0; i < 3; i++) {
> +		rate = ieee80211_get_alt_retry_rate(sc->hw, info, i);
> +		if (!rate)
>  			break;
> -		case AR5K_MODE_11B:
> -			channels[count].hw_value = CHANNEL_B;
> -		}
> 
> -		count++;
> -		max--;
> +		mrr_rate[i] = rate->hw_value;
> +		mrr_tries[i] = info->control.rates[i + 1].count;
>  	}
> 
> -	return count;
> -}
> +	ath5k_hw_setup_mrr_tx_desc(ah, ds,
> +		mrr_rate[0], mrr_tries[0],
> +		mrr_rate[1], mrr_tries[1],
> +		mrr_rate[2], mrr_tries[2]);
> 
> -static void
> -ath5k_setup_rate_idx(struct ath5k_softc *sc, struct
> ieee80211_supported_band *b) -{
> -	u8 i;
> +	ds->ds_link = 0;
> +	ds->ds_data = bf->skbaddr;
> 
> -	for (i = 0; i < AR5K_MAX_RATES; i++)
> -		sc->rate_idx[b->band][i] = -1;
> +	spin_lock_bh(&txq->lock);
> +	list_add_tail(&bf->list, &txq->q);
> +	if (txq->link == NULL) /* is this first packet? */
> +		ath5k_hw_set_txdp(ah, txq->qnum, bf->daddr);
> +	else /* no, so only link it */
> +		*txq->link = bf->daddr;
> 
> -	for (i = 0; i < b->n_bitrates; i++) {
> -		sc->rate_idx[b->band][b->bitrates[i].hw_value] = i;
> -		if (b->bitrates[i].hw_value_short)
> -			sc->rate_idx[b->band][b->bitrates[i].hw_value_short] = i;
> -	}
> +	txq->link = &ds->ds_link;
> +	ath5k_hw_start_tx_dma(ah, txq->qnum);
> +	mmiowb();
> +	spin_unlock_bh(&txq->lock);
> +
> +	return 0;
> +err_unmap:
> +	pci_unmap_single(sc->pdev, bf->skbaddr, skb->len, PCI_DMA_TODEVICE);
> +	return ret;
>  }
> 
> +/*******************\
> +* Descriptors setup *
> +\*******************/
> +
>  static int
> -ath5k_setup_bands(struct ieee80211_hw *hw)
> +ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
>  {
> -	struct ath5k_softc *sc = hw->priv;
> -	struct ath5k_hw *ah = sc->ah;
> -	struct ieee80211_supported_band *sband;
> -	int max_c, count_c = 0;
> -	int i;
> +	struct ath5k_desc *ds;
> +	struct ath5k_buf *bf;
> +	dma_addr_t da;
> +	unsigned int i;
> +	int ret;
> 
> -	BUILD_BUG_ON(ARRAY_SIZE(sc->sbands) < IEEE80211_NUM_BANDS);
> -	max_c = ARRAY_SIZE(sc->channels);
> +	/* allocate descriptors */
> +	sc->desc_len = sizeof(struct ath5k_desc) *
> +			(ATH_TXBUF + ATH_RXBUF + ATH_BCBUF + 1);
> +	sc->desc = pci_alloc_consistent(pdev, sc->desc_len, &sc->desc_daddr);
> +	if (sc->desc == NULL) {
> +		ATH5K_ERR(sc, "can't allocate descriptors\n");
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +	ds = sc->desc;
> +	da = sc->desc_daddr;
> +	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "DMA map: %p (%zu) -> %llx\n",
> +		ds, sc->desc_len, (unsigned long long)sc->desc_daddr);
> 
> -	/* 2GHz band */
> -	sband = &sc->sbands[IEEE80211_BAND_2GHZ];
> -	sband->band = IEEE80211_BAND_2GHZ;
> -	sband->bitrates = &sc->rates[IEEE80211_BAND_2GHZ][0];
> +	bf = kcalloc(1 + ATH_TXBUF + ATH_RXBUF + ATH_BCBUF,
> +			sizeof(struct ath5k_buf), GFP_KERNEL);
> +	if (bf == NULL) {
> +		ATH5K_ERR(sc, "can't allocate bufptr\n");
> +		ret = -ENOMEM;
> +		goto err_free;
> +	}
> +	sc->bufptr = bf;
> 
> -	if (test_bit(AR5K_MODE_11G, sc->ah->ah_capabilities.cap_mode)) {
> -		/* G mode */
> -		memcpy(sband->bitrates, &ath5k_rates[0],
> -		       sizeof(struct ieee80211_rate) * 12);
> -		sband->n_bitrates = 12;
> -
> -		sband->channels = sc->channels;
> -		sband->n_channels = ath5k_copy_channels(ah, sband->channels,
> -					AR5K_MODE_11G, max_c);
> -
> -		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
> -		count_c = sband->n_channels;
> -		max_c -= count_c;
> -	} else if (test_bit(AR5K_MODE_11B, sc->ah->ah_capabilities.cap_mode)) {
> -		/* B mode */
> -		memcpy(sband->bitrates, &ath5k_rates[0],
> -		       sizeof(struct ieee80211_rate) * 4);
> -		sband->n_bitrates = 4;
> -
> -		/* 5211 only supports B rates and uses 4bit rate codes
> -		 * (e.g normally we have 0x1B for 1M, but on 5211 we have 0x0B)
> -		 * fix them up here:
> -		 */
> -		if (ah->ah_version == AR5K_AR5211) {
> -			for (i = 0; i < 4; i++) {
> -				sband->bitrates[i].hw_value =
> -					sband->bitrates[i].hw_value & 0xF;
> -				sband->bitrates[i].hw_value_short =
> -					sband->bitrates[i].hw_value_short & 0xF;
> -			}
> -		}
> -
> -		sband->channels = sc->channels;
> -		sband->n_channels = ath5k_copy_channels(ah, sband->channels,
> -					AR5K_MODE_11B, max_c);
> -
> -		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
> -		count_c = sband->n_channels;
> -		max_c -= count_c;
> +	INIT_LIST_HEAD(&sc->rxbuf);
> +	for (i = 0; i < ATH_RXBUF; i++, bf++, ds++, da += sizeof(*ds)) {
> +		bf->desc = ds;
> +		bf->daddr = da;
> +		list_add_tail(&bf->list, &sc->rxbuf);
>  	}
> -	ath5k_setup_rate_idx(sc, sband);
> -
> -	/* 5GHz band, A mode */
> -	if (test_bit(AR5K_MODE_11A, sc->ah->ah_capabilities.cap_mode)) {
> -		sband = &sc->sbands[IEEE80211_BAND_5GHZ];
> -		sband->band = IEEE80211_BAND_5GHZ;
> -		sband->bitrates = &sc->rates[IEEE80211_BAND_5GHZ][0];
> -
> -		memcpy(sband->bitrates, &ath5k_rates[4],
> -		       sizeof(struct ieee80211_rate) * 8);
> -		sband->n_bitrates = 8;
> -
> -		sband->channels = &sc->channels[count_c];
> -		sband->n_channels = ath5k_copy_channels(ah, sband->channels,
> -					AR5K_MODE_11A, max_c);
> 
> -		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
> +	INIT_LIST_HEAD(&sc->txbuf);
> +	sc->txbuf_len = ATH_TXBUF;
> +	for (i = 0; i < ATH_TXBUF; i++, bf++, ds++,
> +			da += sizeof(*ds)) {
> +		bf->desc = ds;
> +		bf->daddr = da;
> +		list_add_tail(&bf->list, &sc->txbuf);
>  	}
> -	ath5k_setup_rate_idx(sc, sband);
> 
> -	ath5k_debug_dump_bands(sc);
> +	/* beacon buffer */
> +	bf->desc = ds;
> +	bf->daddr = da;
> +	sc->bbuf = bf;
> 
>  	return 0;
> -}
> -
> -/*
> - * Set/change channels. We always reset the chip.
> - * To accomplish this we must first cleanup any pending DMA,
> - * then restart stuff after a la  ath5k_init.
> - *
> - * Called with sc->lock.
> - */
> -static int
> -ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
> -{
> -	ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
> -		  "channel set, resetting (%u -> %u MHz)\n",
> -		  sc->curchan->center_freq, chan->center_freq);
> -
> -	/*
> -	 * To switch channels clear any pending DMA operations;
> -	 * wait long enough for the RX fifo to drain, reset the
> -	 * hardware at the new frequency, and then re-enable
> -	 * the relevant bits of the h/w.
> -	 */
> -	return ath5k_reset(sc, chan);
> -}
> -
> -static void
> -ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
> -{
> -	sc->curmode = mode;
> -
> -	if (mode == AR5K_MODE_11A) {
> -		sc->curband = &sc->sbands[IEEE80211_BAND_5GHZ];
> -	} else {
> -		sc->curband = &sc->sbands[IEEE80211_BAND_2GHZ];
> -	}
> +err_free:
> +	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
> +err:
> +	sc->desc = NULL;
> +	return ret;
>  }
> 
>  static void
> -ath5k_mode_setup(struct ath5k_softc *sc)
> +ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
>  {
> -	struct ath5k_hw *ah = sc->ah;
> -	u32 rfilt;
> -
> -	/* configure rx filter */
> -	rfilt = sc->filter_flags;
> -	ath5k_hw_set_rx_filter(ah, rfilt);
> +	struct ath5k_buf *bf;
> 
> -	if (ath5k_hw_hasbssidmask(ah))
> -		ath5k_hw_set_bssid_mask(ah, sc->bssidmask);
> +	ath5k_txbuf_free_skb(sc, sc->bbuf);
> +	list_for_each_entry(bf, &sc->txbuf, list)
> +		ath5k_txbuf_free_skb(sc, bf);
> +	list_for_each_entry(bf, &sc->rxbuf, list)
> +		ath5k_rxbuf_free_skb(sc, bf);
> 
> -	/* configure operational mode */
> -	ath5k_hw_set_opmode(ah, sc->opmode);
> +	/* Free memory associated with all descriptors */
> +	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
> +	sc->desc = NULL;
> +	sc->desc_daddr = 0;
> 
> -	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d\n", sc->opmode);
> -	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "RX filter 0x%x\n", rfilt);
> +	kfree(sc->bufptr);
> +	sc->bufptr = NULL;
> +	sc->bbuf = NULL;
>  }
> 
> -static inline int
> -ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
> -{
> -	int rix;
> -
> -	/* return base rate on errors */
> -	if (WARN(hw_rix < 0 || hw_rix >= AR5K_MAX_RATES,
> -			"hw_rix out of bounds: %x\n", hw_rix))
> -		return 0;
> -
> -	rix = sc->rate_idx[sc->curband->band][hw_rix];
> -	if (WARN(rix < 0, "invalid hw_rix: %x\n", hw_rix))
> -		rix = 0;
> -
> -	return rix;
> -}
> 
> -/***************\
> -* Buffers setup *
> -\***************/
> +/**************\
> +* Queues setup *
> +\**************/
> 
> -static
> -struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t
> *skb_addr) +static struct ath5k_txq *
> +ath5k_txq_setup(struct ath5k_softc *sc,
> +		int qtype, int subtype)
>  {
> -	struct ath_common *common = ath5k_hw_common(sc->ah);
> -	struct sk_buff *skb;
> +	struct ath5k_hw *ah = sc->ah;
> +	struct ath5k_txq *txq;
> +	struct ath5k_txq_info qi = {
> +		.tqi_subtype = subtype,
> +		.tqi_aifs = AR5K_TXQ_USEDEFAULT,
> +		.tqi_cw_min = AR5K_TXQ_USEDEFAULT,
> +		.tqi_cw_max = AR5K_TXQ_USEDEFAULT
> +	};
> +	int qnum;
> 
>  	/*
> -	 * Allocate buffer with headroom_needed space for the
> -	 * fake physical layer header at the start.
> +	 * Enable interrupts only for EOL and DESC conditions.
> +	 * We mark tx descriptors to receive a DESC interrupt
> +	 * when a tx queue gets deep; otherwise we wait for the
> +	 * EOL to reap descriptors.  Note that this is done to
> +	 * reduce interrupt load and this only defers reaping
> +	 * descriptors, never transmitting frames.  Aside from
> +	 * reducing interrupts this also permits more concurrency.
> +	 * The only potential downside is if the tx queue backs
> +	 * up in which case the top half of the kernel may backup
> +	 * due to a lack of tx descriptors.
>  	 */
> -	skb = ath_rxbuf_alloc(common,
> -			      common->rx_bufsize,
> -			      GFP_ATOMIC);
> -
> -	if (!skb) {
> -		ATH5K_ERR(sc, "can't alloc skbuff of size %u\n",
> -				common->rx_bufsize);
> -		return NULL;
> +	qi.tqi_flags = AR5K_TXQ_FLAG_TXEOLINT_ENABLE |
> +				AR5K_TXQ_FLAG_TXDESCINT_ENABLE;
> +	qnum = ath5k_hw_setup_tx_queue(ah, qtype, &qi);
> +	if (qnum < 0) {
> +		/*
> +		 * NB: don't print a message, this happens
> +		 * normally on parts with too few tx queues
> +		 */
> +		return ERR_PTR(qnum);
>  	}
> -
> -	*skb_addr = pci_map_single(sc->pdev,
> -				   skb->data, common->rx_bufsize,
> -				   PCI_DMA_FROMDEVICE);
> -	if (unlikely(pci_dma_mapping_error(sc->pdev, *skb_addr))) {
> -		ATH5K_ERR(sc, "%s: DMA mapping failed\n", __func__);
> -		dev_kfree_skb(skb);
> -		return NULL;
> +	if (qnum >= ARRAY_SIZE(sc->txqs)) {
> +		ATH5K_ERR(sc, "hw qnum %u out of range, max %tu!\n",
> +			qnum, ARRAY_SIZE(sc->txqs));
> +		ath5k_hw_release_tx_queue(ah, qnum);
> +		return ERR_PTR(-EINVAL);
>  	}
> -	return skb;
> +	txq = &sc->txqs[qnum];
> +	if (!txq->setup) {
> +		txq->qnum = qnum;
> +		txq->link = NULL;
> +		INIT_LIST_HEAD(&txq->q);
> +		spin_lock_init(&txq->lock);
> +		txq->setup = true;
> +	}
> +	return &sc->txqs[qnum];
>  }
> 
>  static int
> -ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
> +ath5k_beaconq_setup(struct ath5k_hw *ah)
> +{
> +	struct ath5k_txq_info qi = {
> +		.tqi_aifs = AR5K_TXQ_USEDEFAULT,
> +		.tqi_cw_min = AR5K_TXQ_USEDEFAULT,
> +		.tqi_cw_max = AR5K_TXQ_USEDEFAULT,
> +		/* NB: for dynamic turbo, don't enable any other interrupts */
> +		.tqi_flags = AR5K_TXQ_FLAG_TXDESCINT_ENABLE
> +	};
> +
> +	return ath5k_hw_setup_tx_queue(ah, AR5K_TX_QUEUE_BEACON, &qi);
> +}
> +
> +static int
> +ath5k_beaconq_config(struct ath5k_softc *sc)
>  {
>  	struct ath5k_hw *ah = sc->ah;
> -	struct sk_buff *skb = bf->skb;
> -	struct ath5k_desc *ds;
> +	struct ath5k_txq_info qi;
>  	int ret;
> 
> -	if (!skb) {
> -		skb = ath5k_rx_skb_alloc(sc, &bf->skbaddr);
> -		if (!skb)
> -			return -ENOMEM;
> -		bf->skb = skb;
> -	}
> +	ret = ath5k_hw_get_tx_queueprops(ah, sc->bhalq, &qi);
> +	if (ret)
> +		goto err;
> 
> -	/*
> -	 * Setup descriptors.  For receive we always terminate
> -	 * the descriptor list with a self-linked entry so we'll
> -	 * not get overrun under high load (as can happen with a
> -	 * 5212 when ANI processing enables PHY error frames).
> -	 *
> -	 * To ensure the last descriptor is self-linked we create
> -	 * each descriptor as self-linked and add it to the end.  As
> -	 * each additional descriptor is added the previous self-linked
> -	 * entry is "fixed" naturally.  This should be safe even
> -	 * if DMA is happening.  When processing RX interrupts we
> -	 * never remove/process the last, self-linked, entry on the
> -	 * descriptor list.  This ensures the hardware always has
> -	 * someplace to write a new frame.
> -	 */
> -	ds = bf->desc;
> -	ds->ds_link = bf->daddr;	/* link to self */
> -	ds->ds_data = bf->skbaddr;
> -	ret = ath5k_hw_setup_rx_desc(ah, ds, ah->common.rx_bufsize, 0);
> +	if (sc->opmode == NL80211_IFTYPE_AP ||
> +		sc->opmode == NL80211_IFTYPE_MESH_POINT) {
> +		/*
> +		 * Always burst out beacon and CAB traffic
> +		 * (aifs = cwmin = cwmax = 0)
> +		 */
> +		qi.tqi_aifs = 0;
> +		qi.tqi_cw_min = 0;
> +		qi.tqi_cw_max = 0;
> +	} else if (sc->opmode == NL80211_IFTYPE_ADHOC) {
> +		/*
> +		 * Adhoc mode; backoff between 0 and (2 * cw_min).
> +		 */
> +		qi.tqi_aifs = 0;
> +		qi.tqi_cw_min = 0;
> +		qi.tqi_cw_max = 2 * ah->ah_cw_min;
> +	}
> +
> +	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
> +		"beacon queueprops tqi_aifs:%d tqi_cw_min:%d tqi_cw_max:%d\n",
> +		qi.tqi_aifs, qi.tqi_cw_min, qi.tqi_cw_max);
> +
> +	ret = ath5k_hw_set_tx_queueprops(ah, sc->bhalq, &qi);
>  	if (ret) {
> -		ATH5K_ERR(sc, "%s: could not setup RX desc\n", __func__);
> -		return ret;
> +		ATH5K_ERR(sc, "%s: unable to update parameters for beacon "
> +			"hardware queue!\n", __func__);
> +		goto err;
>  	}
> +	ret = ath5k_hw_reset_tx_queue(ah, sc->bhalq); /* push to h/w */
> +	if (ret)
> +		goto err;
> 
> -	if (sc->rxlink != NULL)
> -		*sc->rxlink = bf->daddr;
> -	sc->rxlink = &ds->ds_link;
> -	return 0;
> +	/* reconfigure cabq with ready time to 80% of beacon_interval */
> +	ret = ath5k_hw_get_tx_queueprops(ah, AR5K_TX_QUEUE_ID_CAB, &qi);
> +	if (ret)
> +		goto err;
> +
> +	qi.tqi_ready_time = (sc->bintval * 80) / 100;
> +	ret = ath5k_hw_set_tx_queueprops(ah, AR5K_TX_QUEUE_ID_CAB, &qi);
> +	if (ret)
> +		goto err;
> +
> +	ret = ath5k_hw_reset_tx_queue(ah, AR5K_TX_QUEUE_ID_CAB);
> +err:
> +	return ret;
>  }
> 
> -static enum ath5k_pkt_type get_hw_packet_type(struct sk_buff *skb)
> +static void
> +ath5k_txq_drainq(struct ath5k_softc *sc, struct ath5k_txq *txq)
>  {
> -	struct ieee80211_hdr *hdr;
> -	enum ath5k_pkt_type htype;
> -	__le16 fc;
> +	struct ath5k_buf *bf, *bf0;
> 
> -	hdr = (struct ieee80211_hdr *)skb->data;
> -	fc = hdr->frame_control;
> +	/*
> +	 * NB: this assumes output has been stopped and
> +	 *     we do not need to block ath5k_tx_tasklet
> +	 */
> +	spin_lock_bh(&txq->lock);
> +	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
> +		ath5k_debug_printtxbuf(sc, bf);
> 
> -	if (ieee80211_is_beacon(fc))
> -		htype = AR5K_PKT_TYPE_BEACON;
> -	else if (ieee80211_is_probe_resp(fc))
> -		htype = AR5K_PKT_TYPE_PROBE_RESP;
> -	else if (ieee80211_is_atim(fc))
> -		htype = AR5K_PKT_TYPE_ATIM;
> -	else if (ieee80211_is_pspoll(fc))
> -		htype = AR5K_PKT_TYPE_PSPOLL;
> -	else
> -		htype = AR5K_PKT_TYPE_NORMAL;
> +		ath5k_txbuf_free_skb(sc, bf);
> 
> -	return htype;
> +		spin_lock_bh(&sc->txbuflock);
> +		list_move_tail(&bf->list, &sc->txbuf);
> +		sc->txbuf_len++;
> +		spin_unlock_bh(&sc->txbuflock);
> +	}
> +	txq->link = NULL;
> +	spin_unlock_bh(&txq->lock);
>  }
> 
> -static int
> -ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
> -		  struct ath5k_txq *txq, int padsize)
> +/*
> + * Drain the transmit queues and reclaim resources.
> + */
> +static void
> +ath5k_txq_cleanup(struct ath5k_softc *sc)
>  {
>  	struct ath5k_hw *ah = sc->ah;
> -	struct ath5k_desc *ds = bf->desc;
> -	struct sk_buff *skb = bf->skb;
> -	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> -	unsigned int pktlen, flags, keyidx = AR5K_TXKEYIX_INVALID;
> -	struct ieee80211_rate *rate;
> -	unsigned int mrr_rate[3], mrr_tries[3];
> -	int i, ret;
> -	u16 hw_rate;
> -	u16 cts_rate = 0;
> -	u16 duration = 0;
> -	u8 rc_flags;
> -
> -	flags = AR5K_TXDESC_INTREQ | AR5K_TXDESC_CLRDMASK;
> -
> -	/* XXX endianness */
> -	bf->skbaddr = pci_map_single(sc->pdev, skb->data, skb->len,
> -			PCI_DMA_TODEVICE);
> +	unsigned int i;
> 
> -	rate = ieee80211_get_tx_rate(sc->hw, info);
> -	if (!rate) {
> -		ret = -EINVAL;
> -		goto err_unmap;
> +	/* XXX return value */
> +	if (likely(!test_bit(ATH_STAT_INVALID, sc->status))) {
> +		/* don't touch the hardware if marked invalid */
> +		ath5k_hw_stop_tx_dma(ah, sc->bhalq);
> +		ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "beacon queue %x\n",
> +			ath5k_hw_get_txdp(ah, sc->bhalq));
> +		for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
> +			if (sc->txqs[i].setup) {
> +				ath5k_hw_stop_tx_dma(ah, sc->txqs[i].qnum);
> +				ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "txq [%u] %x, "
> +					"link %p\n",
> +					sc->txqs[i].qnum,
> +					ath5k_hw_get_txdp(ah,
> +							sc->txqs[i].qnum),
> +					sc->txqs[i].link);
> +			}
>  	}
> 
> -	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
> -		flags |= AR5K_TXDESC_NOACK;
> +	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
> +		if (sc->txqs[i].setup)
> +			ath5k_txq_drainq(sc, &sc->txqs[i]);
> +}
> 
> -	rc_flags = info->control.rates[0].flags;
> -	hw_rate = (rc_flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE) ?
> -		rate->hw_value_short : rate->hw_value;
> +static void
> +ath5k_txq_release(struct ath5k_softc *sc)
> +{
> +	struct ath5k_txq *txq = sc->txqs;
> +	unsigned int i;
> 
> -	pktlen = skb->len;
> +	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++, txq++)
> +		if (txq->setup) {
> +			ath5k_hw_release_tx_queue(sc->ah, txq->qnum);
> +			txq->setup = false;
> +		}
> +}
> 
> -	/* FIXME: If we are in g mode and rate is a CCK rate
> -	 * subtract ah->ah_txpower.txp_cck_ofdm_pwr_delta
> -	 * from tx power (value is in dB units already) */
> -	if (info->control.hw_key) {
> -		keyidx = info->control.hw_key->hw_key_idx;
> -		pktlen += info->control.hw_key->icv_len;
> -	}
> -	if (rc_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
> -		flags |= AR5K_TXDESC_RTSENA;
> -		cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
> -		duration = le16_to_cpu(ieee80211_rts_duration(sc->hw,
> -			sc->vif, pktlen, info));
> -	}
> -	if (rc_flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
> -		flags |= AR5K_TXDESC_CTSENA;
> -		cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
> -		duration = le16_to_cpu(ieee80211_ctstoself_duration(sc->hw,
> -			sc->vif, pktlen, info));
> -	}
> -	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
> -		ieee80211_get_hdrlen_from_skb(skb), padsize,
> -		get_hw_packet_type(skb),
> -		(sc->power_level * 2),
> -		hw_rate,
> -		info->control.rates[0].count, keyidx, ah->ah_tx_ant, flags,
> -		cts_rate, duration);
> -	if (ret)
> -		goto err_unmap;
> 
> -	memset(mrr_rate, 0, sizeof(mrr_rate));
> -	memset(mrr_tries, 0, sizeof(mrr_tries));
> -	for (i = 0; i < 3; i++) {
> -		rate = ieee80211_get_alt_retry_rate(sc->hw, info, i);
> -		if (!rate)
> -			break;
> +/*************\
> +* RX Handling *
> +\*************/
> 
> -		mrr_rate[i] = rate->hw_value;
> -		mrr_tries[i] = info->control.rates[i + 1].count;
> -	}
> +/*
> + * Enable the receive h/w following a reset.
> + */
> +static int
> +ath5k_rx_start(struct ath5k_softc *sc)
> +{
> +	struct ath5k_hw *ah = sc->ah;
> +	struct ath_common *common = ath5k_hw_common(ah);
> +	struct ath5k_buf *bf;
> +	int ret;
> 
> -	ath5k_hw_setup_mrr_tx_desc(ah, ds,
> -		mrr_rate[0], mrr_tries[0],
> -		mrr_rate[1], mrr_tries[1],
> -		mrr_rate[2], mrr_tries[2]);
> +	common->rx_bufsize = roundup(IEEE80211_MAX_FRAME_LEN, common->cachelsz);
> 
> -	ds->ds_link = 0;
> -	ds->ds_data = bf->skbaddr;
> +	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "cachelsz %u rx_bufsize %u\n",
> +		  common->cachelsz, common->rx_bufsize);
> 
> -	spin_lock_bh(&txq->lock);
> -	list_add_tail(&bf->list, &txq->q);
> -	if (txq->link == NULL) /* is this first packet? */
> -		ath5k_hw_set_txdp(ah, txq->qnum, bf->daddr);
> -	else /* no, so only link it */
> -		*txq->link = bf->daddr;
> +	spin_lock_bh(&sc->rxbuflock);
> +	sc->rxlink = NULL;
> +	list_for_each_entry(bf, &sc->rxbuf, list) {
> +		ret = ath5k_rxbuf_setup(sc, bf);
> +		if (ret != 0) {
> +			spin_unlock_bh(&sc->rxbuflock);
> +			goto err;
> +		}
> +	}
> +	bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
> +	ath5k_hw_set_rxdp(ah, bf->daddr);
> +	spin_unlock_bh(&sc->rxbuflock);
> 
> -	txq->link = &ds->ds_link;
> -	ath5k_hw_start_tx_dma(ah, txq->qnum);
> -	mmiowb();
> -	spin_unlock_bh(&txq->lock);
> +	ath5k_hw_start_rx_dma(ah);	/* enable recv descriptors */
> +	ath5k_mode_setup(sc);		/* set filters, etc. */
> +	ath5k_hw_start_rx_pcu(ah);	/* re-enable PCU/DMA engine */
> 
>  	return 0;
> -err_unmap:
> -	pci_unmap_single(sc->pdev, bf->skbaddr, skb->len, PCI_DMA_TODEVICE);
> +err:
>  	return ret;
>  }
> 
> -/*******************\
> -* Descriptors setup *
> -\*******************/
> -
> -static int
> -ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
> +/*
> + * Disable the receive h/w in preparation for a reset.
> + */
> +static void
> +ath5k_rx_stop(struct ath5k_softc *sc)
>  {
> -	struct ath5k_desc *ds;
> -	struct ath5k_buf *bf;
> -	dma_addr_t da;
> -	unsigned int i;
> -	int ret;
> +	struct ath5k_hw *ah = sc->ah;
> 
> -	/* allocate descriptors */
> -	sc->desc_len = sizeof(struct ath5k_desc) *
> -			(ATH_TXBUF + ATH_RXBUF + ATH_BCBUF + 1);
> -	sc->desc = pci_alloc_consistent(pdev, sc->desc_len, &sc->desc_daddr);
> -	if (sc->desc == NULL) {
> -		ATH5K_ERR(sc, "can't allocate descriptors\n");
> -		ret = -ENOMEM;
> -		goto err;
> -	}
> -	ds = sc->desc;
> -	da = sc->desc_daddr;
> -	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "DMA map: %p (%zu) -> %llx\n",
> -		ds, sc->desc_len, (unsigned long long)sc->desc_daddr);
> +	ath5k_hw_stop_rx_pcu(ah);	/* disable PCU */
> +	ath5k_hw_set_rx_filter(ah, 0);	/* clear recv filter */
> +	ath5k_hw_stop_rx_dma(ah);	/* disable DMA engine */
> 
> -	bf = kcalloc(1 + ATH_TXBUF + ATH_RXBUF + ATH_BCBUF,
> -			sizeof(struct ath5k_buf), GFP_KERNEL);
> -	if (bf == NULL) {
> -		ATH5K_ERR(sc, "can't allocate bufptr\n");
> -		ret = -ENOMEM;
> -		goto err_free;
> -	}
> -	sc->bufptr = bf;
> +	ath5k_debug_printrxbuffs(sc, ah);
> +}
> 
> -	INIT_LIST_HEAD(&sc->rxbuf);
> -	for (i = 0; i < ATH_RXBUF; i++, bf++, ds++, da += sizeof(*ds)) {
> -		bf->desc = ds;
> -		bf->daddr = da;
> -		list_add_tail(&bf->list, &sc->rxbuf);
> -	}
> +static unsigned int
> +ath5k_rx_decrypted(struct ath5k_softc *sc, struct sk_buff *skb,
> +		   struct ath5k_rx_status *rs)
> +{
> +	struct ath5k_hw *ah = sc->ah;
> +	struct ath_common *common = ath5k_hw_common(ah);
> +	struct ieee80211_hdr *hdr = (void *)skb->data;
> +	unsigned int keyix, hlen;
> 
> -	INIT_LIST_HEAD(&sc->txbuf);
> -	sc->txbuf_len = ATH_TXBUF;
> -	for (i = 0; i < ATH_TXBUF; i++, bf++, ds++,
> -			da += sizeof(*ds)) {
> -		bf->desc = ds;
> -		bf->daddr = da;
> -		list_add_tail(&bf->list, &sc->txbuf);
> -	}
> +	if (!(rs->rs_status & AR5K_RXERR_DECRYPT) &&
> +			rs->rs_keyix != AR5K_RXKEYIX_INVALID)
> +		return RX_FLAG_DECRYPTED;
> 
> -	/* beacon buffer */
> -	bf->desc = ds;
> -	bf->daddr = da;
> -	sc->bbuf = bf;
> +	/* Apparently when a default key is used to decrypt the packet
> +	   the hw does not set the index used to decrypt.  In such cases
> +	   get the index from the packet. */
> +	hlen = ieee80211_hdrlen(hdr->frame_control);
> +	if (ieee80211_has_protected(hdr->frame_control) &&
> +	    !(rs->rs_status & AR5K_RXERR_DECRYPT) &&
> +	    skb->len >= hlen + 4) {
> +		keyix = skb->data[hlen + 3] >> 6;
> +
> +		if (test_bit(keyix, common->keymap))
> +			return RX_FLAG_DECRYPTED;
> +	}
> 
>  	return 0;
> -err_free:
> -	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
> -err:
> -	sc->desc = NULL;
> -	return ret;
>  }
> 
> +
>  static void
> -ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
> +ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
> +		     struct ieee80211_rx_status *rxs)
>  {
> -	struct ath5k_buf *bf;
> +	struct ath_common *common = ath5k_hw_common(sc->ah);
> +	u64 tsf, bc_tstamp;
> +	u32 hw_tu;
> +	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
> 
> -	ath5k_txbuf_free_skb(sc, sc->bbuf);
> -	list_for_each_entry(bf, &sc->txbuf, list)
> -		ath5k_txbuf_free_skb(sc, bf);
> -	list_for_each_entry(bf, &sc->rxbuf, list)
> -		ath5k_rxbuf_free_skb(sc, bf);
> +	if (ieee80211_is_beacon(mgmt->frame_control) &&
> +	    le16_to_cpu(mgmt->u.beacon.capab_info) & WLAN_CAPABILITY_IBSS &&
> +	    memcmp(mgmt->bssid, common->curbssid, ETH_ALEN) == 0) {
> +		/*
> +		 * Received an IBSS beacon with the same BSSID. Hardware *must*
> +		 * have updated the local TSF. We have to work around various
> +		 * hardware bugs, though...
> +		 */
> +		tsf = ath5k_hw_get_tsf64(sc->ah);
> +		bc_tstamp = le64_to_cpu(mgmt->u.beacon.timestamp);
> +		hw_tu = TSF_TO_TU(tsf);
> 
> -	/* Free memory associated with all descriptors */
> -	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
> -	sc->desc = NULL;
> -	sc->desc_daddr = 0;
> +		ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
> +			"beacon %llx mactime %llx (diff %lld) tsf now %llx\n",
> +			(unsigned long long)bc_tstamp,
> +			(unsigned long long)rxs->mactime,
> +			(unsigned long long)(rxs->mactime - bc_tstamp),
> +			(unsigned long long)tsf);
> 
> -	kfree(sc->bufptr);
> -	sc->bufptr = NULL;
> -	sc->bbuf = NULL;
> -}
> +		/*
> +		 * Sometimes the HW will give us a wrong tstamp in the rx
> +		 * status, causing the timestamp extension to go wrong.
> +		 * (This seems to happen especially with beacon frames bigger
> +		 * than 78 byte (incl. FCS))
> +		 * But we know that the receive timestamp must be later than the
> +		 * timestamp of the beacon since HW must have synced to that.
> +		 *
> +		 * NOTE: here we assume mactime to be after the frame was
> +		 * received, not like mac80211 which defines it at the start.
> +		 */
> +		if (bc_tstamp > rxs->mactime) {
> +			ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
> +				"fixing mactime from %llx to %llx\n",
> +				(unsigned long long)rxs->mactime,
> +				(unsigned long long)tsf);
> +			rxs->mactime = tsf;
> +		}
> 
> +		/*
> +		 * Local TSF might have moved higher than our beacon timers,
> +		 * in that case we have to update them to continue sending
> +		 * beacons. This also takes care of synchronizing beacon sending
> +		 * times with other stations.
> +		 */
> +		if (hw_tu >= sc->nexttbtt)
> +			ath5k_beacon_update_timers(sc, bc_tstamp);
> +	}
> +}
> 
> +static void
> +ath5k_update_beacon_rssi(struct ath5k_softc *sc, struct sk_buff *skb, int
> rssi) +{
> +	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
> +	struct ath5k_hw *ah = sc->ah;
> +	struct ath_common *common = ath5k_hw_common(ah);
> 
> +	/* only beacons from our BSSID */
> +	if (!ieee80211_is_beacon(mgmt->frame_control) ||
> +	    memcmp(mgmt->bssid, common->curbssid, ETH_ALEN) != 0)
> +		return;
> 
> +	ah->ah_beacon_rssi_avg = ath5k_moving_average(ah->ah_beacon_rssi_avg,
> +						      rssi);
> 
> -/**************\
> -* Queues setup *
> -\**************/
> +	/* in IBSS mode we should keep RSSI statistics per neighbour */
> +	/* le16_to_cpu(mgmt->u.beacon.capab_info) & WLAN_CAPABILITY_IBSS */
> +}
> 
> -static struct ath5k_txq *
> -ath5k_txq_setup(struct ath5k_softc *sc,
> -		int qtype, int subtype)
> +/*
> + * Compute padding position. skb must contain an IEEE 802.11 frame
> + */
> +static int ath5k_common_padpos(struct sk_buff *skb)
>  {
> -	struct ath5k_hw *ah = sc->ah;
> -	struct ath5k_txq *txq;
> -	struct ath5k_txq_info qi = {
> -		.tqi_subtype = subtype,
> -		.tqi_aifs = AR5K_TXQ_USEDEFAULT,
> -		.tqi_cw_min = AR5K_TXQ_USEDEFAULT,
> -		.tqi_cw_max = AR5K_TXQ_USEDEFAULT
> -	};
> -	int qnum;
> +	struct ieee80211_hdr * hdr = (struct ieee80211_hdr *)skb->data;
> +	__le16 frame_control = hdr->frame_control;
> +	int padpos = 24;
> 
> -	/*
> -	 * Enable interrupts only for EOL and DESC conditions.
> -	 * We mark tx descriptors to receive a DESC interrupt
> -	 * when a tx queue gets deep; otherwise we wait for the
> -	 * EOL to reap descriptors.  Note that this is done to
> -	 * reduce interrupt load and this only defers reaping
> -	 * descriptors, never transmitting frames.  Aside from
> -	 * reducing interrupts this also permits more concurrency.
> -	 * The only potential downside is if the tx queue backs
> -	 * up in which case the top half of the kernel may backup
> -	 * due to a lack of tx descriptors.
> -	 */
> -	qi.tqi_flags = AR5K_TXQ_FLAG_TXEOLINT_ENABLE |
> -				AR5K_TXQ_FLAG_TXDESCINT_ENABLE;
> -	qnum = ath5k_hw_setup_tx_queue(ah, qtype, &qi);
> -	if (qnum < 0) {
> -		/*
> -		 * NB: don't print a message, this happens
> -		 * normally on parts with too few tx queues
> -		 */
> -		return ERR_PTR(qnum);
> -	}
> -	if (qnum >= ARRAY_SIZE(sc->txqs)) {
> -		ATH5K_ERR(sc, "hw qnum %u out of range, max %tu!\n",
> -			qnum, ARRAY_SIZE(sc->txqs));
> -		ath5k_hw_release_tx_queue(ah, qnum);
> -		return ERR_PTR(-EINVAL);
> +	if (ieee80211_has_a4(frame_control)) {
> +		padpos += ETH_ALEN;
>  	}
> -	txq = &sc->txqs[qnum];
> -	if (!txq->setup) {
> -		txq->qnum = qnum;
> -		txq->link = NULL;
> -		INIT_LIST_HEAD(&txq->q);
> -		spin_lock_init(&txq->lock);
> -		txq->setup = true;
> +	if (ieee80211_is_data_qos(frame_control)) {
> +		padpos += IEEE80211_QOS_CTL_LEN;
>  	}
> -	return &sc->txqs[qnum];
> -}
> -
> -static int
> -ath5k_beaconq_setup(struct ath5k_hw *ah)
> -{
> -	struct ath5k_txq_info qi = {
> -		.tqi_aifs = AR5K_TXQ_USEDEFAULT,
> -		.tqi_cw_min = AR5K_TXQ_USEDEFAULT,
> -		.tqi_cw_max = AR5K_TXQ_USEDEFAULT,
> -		/* NB: for dynamic turbo, don't enable any other interrupts */
> -		.tqi_flags = AR5K_TXQ_FLAG_TXDESCINT_ENABLE
> -	};
> 
> -	return ath5k_hw_setup_tx_queue(ah, AR5K_TX_QUEUE_BEACON, &qi);
> +	return padpos;
>  }
> 
> -static int
> -ath5k_beaconq_config(struct ath5k_softc *sc)
> +/*
> + * This function expects an 802.11 frame and returns the number of
> + * bytes added, or -1 if we don't have enough header room.
> + */
> +static int ath5k_add_padding(struct sk_buff *skb)
>  {
> -	struct ath5k_hw *ah = sc->ah;
> -	struct ath5k_txq_info qi;
> -	int ret;
> +	int padpos = ath5k_common_padpos(skb);
> +	int padsize = padpos & 3;
> 
> -	ret = ath5k_hw_get_tx_queueprops(ah, sc->bhalq, &qi);
> -	if (ret)
> -		goto err;
> -
> -	if (sc->opmode == NL80211_IFTYPE_AP ||
> -		sc->opmode == NL80211_IFTYPE_MESH_POINT) {
> -		/*
> -		 * Always burst out beacon and CAB traffic
> -		 * (aifs = cwmin = cwmax = 0)
> -		 */
> -		qi.tqi_aifs = 0;
> -		qi.tqi_cw_min = 0;
> -		qi.tqi_cw_max = 0;
> -	} else if (sc->opmode == NL80211_IFTYPE_ADHOC) {
> -		/*
> -		 * Adhoc mode; backoff between 0 and (2 * cw_min).
> -		 */
> -		qi.tqi_aifs = 0;
> -		qi.tqi_cw_min = 0;
> -		qi.tqi_cw_max = 2 * ah->ah_cw_min;
> -	}
> +	if (padsize && skb->len>padpos) {
> 
> -	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
> -		"beacon queueprops tqi_aifs:%d tqi_cw_min:%d tqi_cw_max:%d\n",
> -		qi.tqi_aifs, qi.tqi_cw_min, qi.tqi_cw_max);
> +		if (skb_headroom(skb) < padsize)
> +			return -1;
> 
> -	ret = ath5k_hw_set_tx_queueprops(ah, sc->bhalq, &qi);
> -	if (ret) {
> -		ATH5K_ERR(sc, "%s: unable to update parameters for beacon "
> -			"hardware queue!\n", __func__);
> -		goto err;
> +		skb_push(skb, padsize);
> +		memmove(skb->data, skb->data+padsize, padpos);
> +		return padsize;
>  	}
> -	ret = ath5k_hw_reset_tx_queue(ah, sc->bhalq); /* push to h/w */
> -	if (ret)
> -		goto err;
> -
> -	/* reconfigure cabq with ready time to 80% of beacon_interval */
> -	ret = ath5k_hw_get_tx_queueprops(ah, AR5K_TX_QUEUE_ID_CAB, &qi);
> -	if (ret)
> -		goto err;
> -
> -	qi.tqi_ready_time = (sc->bintval * 80) / 100;
> -	ret = ath5k_hw_set_tx_queueprops(ah, AR5K_TX_QUEUE_ID_CAB, &qi);
> -	if (ret)
> -		goto err;
> -
> -	ret = ath5k_hw_reset_tx_queue(ah, AR5K_TX_QUEUE_ID_CAB);
> -err:
> -	return ret;
> -}
> -
> -static void
> -ath5k_txq_drainq(struct ath5k_softc *sc, struct ath5k_txq *txq)
> -{
> -	struct ath5k_buf *bf, *bf0;
> -
> -	/*
> -	 * NB: this assumes output has been stopped and
> -	 *     we do not need to block ath5k_tx_tasklet
> -	 */
> -	spin_lock_bh(&txq->lock);
> -	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
> -		ath5k_debug_printtxbuf(sc, bf);
> -
> -		ath5k_txbuf_free_skb(sc, bf);
> 
> -		spin_lock_bh(&sc->txbuflock);
> -		list_move_tail(&bf->list, &sc->txbuf);
> -		sc->txbuf_len++;
> -		spin_unlock_bh(&sc->txbuflock);
> -	}
> -	txq->link = NULL;
> -	spin_unlock_bh(&txq->lock);
> +	return 0;
>  }
> 
>  /*
> - * Drain the transmit queues and reclaim resources.
> + * The MAC header is padded to have 32-bit boundary if the
> + * packet payload is non-zero. The general calculation for
> + * padsize would take into account odd header lengths:
> + * padsize = 4 - (hdrlen & 3); however, since only
> + * even-length headers are used, padding can only be 0 or 2
> + * bytes and we can optimize this a bit.  We must not try to
> + * remove padding from short control frames that do not have a
> + * payload.
> + *
> + * This function expects an 802.11 frame and returns the number of
> + * bytes removed.
>   */
> -static void
> -ath5k_txq_cleanup(struct ath5k_softc *sc)
> +static int ath5k_remove_padding(struct sk_buff *skb)
>  {
> -	struct ath5k_hw *ah = sc->ah;
> -	unsigned int i;
> +	int padpos = ath5k_common_padpos(skb);
> +	int padsize = padpos & 3;
> 
> -	/* XXX return value */
> -	if (likely(!test_bit(ATH_STAT_INVALID, sc->status))) {
> -		/* don't touch the hardware if marked invalid */
> -		ath5k_hw_stop_tx_dma(ah, sc->bhalq);
> -		ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "beacon queue %x\n",
> -			ath5k_hw_get_txdp(ah, sc->bhalq));
> -		for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
> -			if (sc->txqs[i].setup) {
> -				ath5k_hw_stop_tx_dma(ah, sc->txqs[i].qnum);
> -				ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "txq [%u] %x, "
> -					"link %p\n",
> -					sc->txqs[i].qnum,
> -					ath5k_hw_get_txdp(ah,
> -							sc->txqs[i].qnum),
> -					sc->txqs[i].link);
> -			}
> +	if (padsize && skb->len>=padpos+padsize) {
> +		memmove(skb->data + padsize, skb->data, padpos);
> +		skb_pull(skb, padsize);
> +		return padsize;
>  	}
> 
> -	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
> -		if (sc->txqs[i].setup)
> -			ath5k_txq_drainq(sc, &sc->txqs[i]);
> +	return 0;
>  }
> 
>  static void
> -ath5k_txq_release(struct ath5k_softc *sc)
> +ath5k_receive_frame(struct ath5k_softc *sc, struct sk_buff *skb,
> +		    struct ath5k_rx_status *rs)
>  {
> -	struct ath5k_txq *txq = sc->txqs;
> -	unsigned int i;
> +	struct ieee80211_rx_status *rxs;
> 
> -	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++, txq++)
> -		if (txq->setup) {
> -			ath5k_hw_release_tx_queue(sc->ah, txq->qnum);
> -			txq->setup = false;
> -		}
> -}
> +	ath5k_remove_padding(skb);
> 
> +	rxs = IEEE80211_SKB_RXCB(skb);
> 
> +	rxs->flag = 0;
> +	if (unlikely(rs->rs_status & AR5K_RXERR_MIC))
> +		rxs->flag |= RX_FLAG_MMIC_ERROR;
> 
> +	/*
> +	 * always extend the mac timestamp, since this information is
> +	 * also needed for proper IBSS merging.
> +	 *
> +	 * XXX: it might be too late to do it here, since rs_tstamp is
> +	 * 15bit only. that means TSF extension has to be done within
> +	 * 32768usec (about 32ms). it might be necessary to move this to
> +	 * the interrupt handler, like it is done in madwifi.
> +	 *
> +	 * Unfortunately we don't know when the hardware takes the rx
> +	 * timestamp (beginning of phy frame, data frame, end of rx?).
> +	 * The only thing we know is that it is hardware specific...
> +	 * On AR5213 it seems the rx timestamp is at the end of the
> +	 * frame, but i'm not sure.
> +	 *
> +	 * NOTE: mac80211 defines mactime at the beginning of the first
> +	 * data symbol. Since we don't have any time references it's
> +	 * impossible to comply to that. This affects IBSS merge only
> +	 * right now, so it's not too bad...
> +	 */
> +	rxs->mactime = ath5k_extend_tsf(sc->ah, rs->rs_tstamp);
> +	rxs->flag |= RX_FLAG_TSFT;
> 
> -/*************\
> -* RX Handling *
> -\*************/
> +	rxs->freq = sc->curchan->center_freq;
> +	rxs->band = sc->curband->band;
> 
> -/*
> - * Enable the receive h/w following a reset.
> - */
> -static int
> -ath5k_rx_start(struct ath5k_softc *sc)
> -{
> -	struct ath5k_hw *ah = sc->ah;
> -	struct ath_common *common = ath5k_hw_common(ah);
> -	struct ath5k_buf *bf;
> -	int ret;
> +	rxs->signal = sc->ah->ah_noise_floor + rs->rs_rssi;
> 
> -	common->rx_bufsize = roundup(IEEE80211_MAX_FRAME_LEN, common->cachelsz);
> +	rxs->antenna = rs->rs_antenna;
> 
> -	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "cachelsz %u rx_bufsize %u\n",
> -		  common->cachelsz, common->rx_bufsize);
> +	if (rs->rs_antenna > 0 && rs->rs_antenna < 5)
> +		sc->stats.antenna_rx[rs->rs_antenna]++;
> +	else
> +		sc->stats.antenna_rx[0]++; /* invalid */
> 
> -	spin_lock_bh(&sc->rxbuflock);
> -	sc->rxlink = NULL;
> -	list_for_each_entry(bf, &sc->rxbuf, list) {
> -		ret = ath5k_rxbuf_setup(sc, bf);
> -		if (ret != 0) {
> -			spin_unlock_bh(&sc->rxbuflock);
> -			goto err;
> -		}
> -	}
> -	bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
> -	ath5k_hw_set_rxdp(ah, bf->daddr);
> -	spin_unlock_bh(&sc->rxbuflock);
> +	rxs->rate_idx = ath5k_hw_to_driver_rix(sc, rs->rs_rate);
> +	rxs->flag |= ath5k_rx_decrypted(sc, skb, rs);
> 
> -	ath5k_hw_start_rx_dma(ah);	/* enable recv descriptors */
> -	ath5k_mode_setup(sc);		/* set filters, etc. */
> -	ath5k_hw_start_rx_pcu(ah);	/* re-enable PCU/DMA engine */
> +	if (rxs->rate_idx >= 0 && rs->rs_rate ==
> +	    sc->curband->bitrates[rxs->rate_idx].hw_value_short)
> +		rxs->flag |= RX_FLAG_SHORTPRE;
> 
> -	return 0;
> -err:
> -	return ret;
> -}
> +	ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
> 
> -/*
> - * Disable the receive h/w in preparation for a reset.
> - */
> -static void
> -ath5k_rx_stop(struct ath5k_softc *sc)
> -{
> -	struct ath5k_hw *ah = sc->ah;
> +	ath5k_update_beacon_rssi(sc, skb, rs->rs_rssi);
> 
> -	ath5k_hw_stop_rx_pcu(ah);	/* disable PCU */
> -	ath5k_hw_set_rx_filter(ah, 0);	/* clear recv filter */
> -	ath5k_hw_stop_rx_dma(ah);	/* disable DMA engine */
> +	/* check beacons in IBSS mode */
> +	if (sc->opmode == NL80211_IFTYPE_ADHOC)
> +		ath5k_check_ibss_tsf(sc, skb, rxs);
> 
> -	ath5k_debug_printrxbuffs(sc, ah);
> +	ieee80211_rx(sc->hw, skb);
>  }
> 
> -static unsigned int
> -ath5k_rx_decrypted(struct ath5k_softc *sc, struct sk_buff *skb,
> -		   struct ath5k_rx_status *rs)
> +/** ath5k_frame_receive_ok() - Do we want to receive this frame or not?
> + *
> + * Check if we want to further process this frame or not. Also update
> + * statistics. Return true if we want this frame, false if not.
> + */
> +static bool
> +ath5k_receive_frame_ok(struct ath5k_softc *sc, struct ath5k_rx_status *rs)
>  {
> -	struct ath5k_hw *ah = sc->ah;
> -	struct ath_common *common = ath5k_hw_common(ah);
> -	struct ieee80211_hdr *hdr = (void *)skb->data;
> -	unsigned int keyix, hlen;
> -
> -	if (!(rs->rs_status & AR5K_RXERR_DECRYPT) &&
> -			rs->rs_keyix != AR5K_RXKEYIX_INVALID)
> -		return RX_FLAG_DECRYPTED;
> -
> -	/* Apparently when a default key is used to decrypt the packet
> -	   the hw does not set the index used to decrypt.  In such cases
> -	   get the index from the packet. */
> -	hlen = ieee80211_hdrlen(hdr->frame_control);
> -	if (ieee80211_has_protected(hdr->frame_control) &&
> -	    !(rs->rs_status & AR5K_RXERR_DECRYPT) &&
> -	    skb->len >= hlen + 4) {
> -		keyix = skb->data[hlen + 3] >> 6;
> -
> -		if (test_bit(keyix, common->keymap))
> -			return RX_FLAG_DECRYPTED;
> -	}
> -
> -	return 0;
> -}
> -
> -
> -static void
> -ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
> -		     struct ieee80211_rx_status *rxs)
> -{
> -	struct ath_common *common = ath5k_hw_common(sc->ah);
> -	u64 tsf, bc_tstamp;
> -	u32 hw_tu;
> -	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
> -
> -	if (ieee80211_is_beacon(mgmt->frame_control) &&
> -	    le16_to_cpu(mgmt->u.beacon.capab_info) & WLAN_CAPABILITY_IBSS &&
> -	    memcmp(mgmt->bssid, common->curbssid, ETH_ALEN) == 0) {
> -		/*
> -		 * Received an IBSS beacon with the same BSSID. Hardware *must*
> -		 * have updated the local TSF. We have to work around various
> -		 * hardware bugs, though...
> -		 */
> -		tsf = ath5k_hw_get_tsf64(sc->ah);
> -		bc_tstamp = le64_to_cpu(mgmt->u.beacon.timestamp);
> -		hw_tu = TSF_TO_TU(tsf);
> -
> -		ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
> -			"beacon %llx mactime %llx (diff %lld) tsf now %llx\n",
> -			(unsigned long long)bc_tstamp,
> -			(unsigned long long)rxs->mactime,
> -			(unsigned long long)(rxs->mactime - bc_tstamp),
> -			(unsigned long long)tsf);
> -
> -		/*
> -		 * Sometimes the HW will give us a wrong tstamp in the rx
> -		 * status, causing the timestamp extension to go wrong.
> -		 * (This seems to happen especially with beacon frames bigger
> -		 * than 78 byte (incl. FCS))
> -		 * But we know that the receive timestamp must be later than the
> -		 * timestamp of the beacon since HW must have synced to that.
> -		 *
> -		 * NOTE: here we assume mactime to be after the frame was
> -		 * received, not like mac80211 which defines it at the start.
> -		 */
> -		if (bc_tstamp > rxs->mactime) {
> -			ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
> -				"fixing mactime from %llx to %llx\n",
> -				(unsigned long long)rxs->mactime,
> -				(unsigned long long)tsf);
> -			rxs->mactime = tsf;
> -		}
> -
> -		/*
> -		 * Local TSF might have moved higher than our beacon timers,
> -		 * in that case we have to update them to continue sending
> -		 * beacons. This also takes care of synchronizing beacon sending
> -		 * times with other stations.
> -		 */
> -		if (hw_tu >= sc->nexttbtt)
> -			ath5k_beacon_update_timers(sc, bc_tstamp);
> -	}
> -}
> -
> -static void
> -ath5k_update_beacon_rssi(struct ath5k_softc *sc, struct sk_buff *skb, int
> rssi) -{
> -	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
> -	struct ath5k_hw *ah = sc->ah;
> -	struct ath_common *common = ath5k_hw_common(ah);
> -
> -	/* only beacons from our BSSID */
> -	if (!ieee80211_is_beacon(mgmt->frame_control) ||
> -	    memcmp(mgmt->bssid, common->curbssid, ETH_ALEN) != 0)
> -		return;
> -
> -	ah->ah_beacon_rssi_avg = ath5k_moving_average(ah->ah_beacon_rssi_avg,
> -						      rssi);
> -
> -	/* in IBSS mode we should keep RSSI statistics per neighbour */
> -	/* le16_to_cpu(mgmt->u.beacon.capab_info) & WLAN_CAPABILITY_IBSS */
> -}
> -
> -/*
> - * Compute padding position. skb must contain an IEEE 802.11 frame
> - */
> -static int ath5k_common_padpos(struct sk_buff *skb)
> -{
> -	struct ieee80211_hdr * hdr = (struct ieee80211_hdr *)skb->data;
> -	__le16 frame_control = hdr->frame_control;
> -	int padpos = 24;
> -
> -	if (ieee80211_has_a4(frame_control)) {
> -		padpos += ETH_ALEN;
> -	}
> -	if (ieee80211_is_data_qos(frame_control)) {
> -		padpos += IEEE80211_QOS_CTL_LEN;
> -	}
> -
> -	return padpos;
> -}
> -
> -/*
> - * This function expects an 802.11 frame and returns the number of
> - * bytes added, or -1 if we don't have enough header room.
> - */
> -static int ath5k_add_padding(struct sk_buff *skb)
> -{
> -	int padpos = ath5k_common_padpos(skb);
> -	int padsize = padpos & 3;
> -
> -	if (padsize && skb->len>padpos) {
> -
> -		if (skb_headroom(skb) < padsize)
> -			return -1;
> -
> -		skb_push(skb, padsize);
> -		memmove(skb->data, skb->data+padsize, padpos);
> -		return padsize;
> -	}
> -
> -	return 0;
> -}
> -
> -/*
> - * The MAC header is padded to have 32-bit boundary if the
> - * packet payload is non-zero. The general calculation for
> - * padsize would take into account odd header lengths:
> - * padsize = 4 - (hdrlen & 3); however, since only
> - * even-length headers are used, padding can only be 0 or 2
> - * bytes and we can optimize this a bit.  We must not try to
> - * remove padding from short control frames that do not have a
> - * payload.
> - *
> - * This function expects an 802.11 frame and returns the number of
> - * bytes removed.
> - */
> -static int ath5k_remove_padding(struct sk_buff *skb)
> -{
> -	int padpos = ath5k_common_padpos(skb);
> -	int padsize = padpos & 3;
> -
> -	if (padsize && skb->len>=padpos+padsize) {
> -		memmove(skb->data + padsize, skb->data, padpos);
> -		skb_pull(skb, padsize);
> -		return padsize;
> -	}
> -
> -	return 0;
> -}
> -
> -static void
> -ath5k_receive_frame(struct ath5k_softc *sc, struct sk_buff *skb,
> -		    struct ath5k_rx_status *rs)
> -{
> -	struct ieee80211_rx_status *rxs;
> -
> -	ath5k_remove_padding(skb);
> -
> -	rxs = IEEE80211_SKB_RXCB(skb);
> -
> -	rxs->flag = 0;
> -	if (unlikely(rs->rs_status & AR5K_RXERR_MIC))
> -		rxs->flag |= RX_FLAG_MMIC_ERROR;
> -
> -	/*
> -	 * always extend the mac timestamp, since this information is
> -	 * also needed for proper IBSS merging.
> -	 *
> -	 * XXX: it might be too late to do it here, since rs_tstamp is
> -	 * 15bit only. that means TSF extension has to be done within
> -	 * 32768usec (about 32ms). it might be necessary to move this to
> -	 * the interrupt handler, like it is done in madwifi.
> -	 *
> -	 * Unfortunately we don't know when the hardware takes the rx
> -	 * timestamp (beginning of phy frame, data frame, end of rx?).
> -	 * The only thing we know is that it is hardware specific...
> -	 * On AR5213 it seems the rx timestamp is at the end of the
> -	 * frame, but i'm not sure.
> -	 *
> -	 * NOTE: mac80211 defines mactime at the beginning of the first
> -	 * data symbol. Since we don't have any time references it's
> -	 * impossible to comply to that. This affects IBSS merge only
> -	 * right now, so it's not too bad...
> -	 */
> -	rxs->mactime = ath5k_extend_tsf(sc->ah, rs->rs_tstamp);
> -	rxs->flag |= RX_FLAG_TSFT;
> -
> -	rxs->freq = sc->curchan->center_freq;
> -	rxs->band = sc->curband->band;
> -
> -	rxs->signal = sc->ah->ah_noise_floor + rs->rs_rssi;
> -
> -	rxs->antenna = rs->rs_antenna;
> -
> -	if (rs->rs_antenna > 0 && rs->rs_antenna < 5)
> -		sc->stats.antenna_rx[rs->rs_antenna]++;
> -	else
> -		sc->stats.antenna_rx[0]++; /* invalid */
> -
> -	rxs->rate_idx = ath5k_hw_to_driver_rix(sc, rs->rs_rate);
> -	rxs->flag |= ath5k_rx_decrypted(sc, skb, rs);
> -
> -	if (rxs->rate_idx >= 0 && rs->rs_rate ==
> -	    sc->curband->bitrates[rxs->rate_idx].hw_value_short)
> -		rxs->flag |= RX_FLAG_SHORTPRE;
> -
> -	ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
> -
> -	ath5k_update_beacon_rssi(sc, skb, rs->rs_rssi);
> -
> -	/* check beacons in IBSS mode */
> -	if (sc->opmode == NL80211_IFTYPE_ADHOC)
> -		ath5k_check_ibss_tsf(sc, skb, rxs);
> -
> -	ieee80211_rx(sc->hw, skb);
> -}
> -
> -/** ath5k_frame_receive_ok() - Do we want to receive this frame or not?
> - *
> - * Check if we want to further process this frame or not. Also update
> - * statistics. Return true if we want this frame, false if not.
> - */
> -static bool
> -ath5k_receive_frame_ok(struct ath5k_softc *sc, struct ath5k_rx_status *rs)
> -{
> -	sc->stats.rx_all_count++;
> +	sc->stats.rx_all_count++;
> 
>  	if (unlikely(rs->rs_status)) {
>  		if (rs->rs_status & AR5K_RXERR_CRC)
> @@ -2121,33 +1462,86 @@ unlock:
>  * TX Handling *
>  \*************/
> 
> -static void
> -ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
> +static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
> +			  struct ath5k_txq *txq)
>  {
> -	struct ath5k_tx_status ts = {};
> -	struct ath5k_buf *bf, *bf0;
> -	struct ath5k_desc *ds;
> -	struct sk_buff *skb;
> -	struct ieee80211_tx_info *info;
> -	int i, ret;
> -
> -	spin_lock(&txq->lock);
> -	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
> -		ds = bf->desc;
> +	struct ath5k_softc *sc = hw->priv;
> +	struct ath5k_buf *bf;
> +	unsigned long flags;
> +	int padsize;
> 
> -		/*
> -		 * It's possible that the hardware can say the buffer is
> -		 * completed when it hasn't yet loaded the ds_link from
> -		 * host memory and moved on.  If there are more TX
> -		 * descriptors in the queue, wait for TXDP to change
> -		 * before processing this one.
> -		 */
> -		if (ath5k_hw_get_txdp(sc->ah, txq->qnum) == bf->daddr &&
> -		    !list_is_last(&bf->list, &txq->q))
> -			break;
> +	ath5k_debug_dump_skb(sc, skb, "TX  ", 1);
> 
> -		ret = sc->ah->ah_proc_tx_desc(sc->ah, ds, &ts);
> -		if (unlikely(ret == -EINPROGRESS))
> +	/*
> +	 * The hardware expects the header padded to 4 byte boundaries.
> +	 * If this is not the case, we add the padding after the header.
> +	 */
> +	padsize = ath5k_add_padding(skb);
> +	if (padsize < 0) {
> +		ATH5K_ERR(sc, "tx hdrlen not %%4: not enough"
> +			  " headroom to pad");
> +		goto drop_packet;
> +	}
> +
> +	spin_lock_irqsave(&sc->txbuflock, flags);
> +	if (list_empty(&sc->txbuf)) {
> +		ATH5K_ERR(sc, "no further txbuf available, dropping packet\n");
> +		spin_unlock_irqrestore(&sc->txbuflock, flags);
> +		ieee80211_stop_queue(hw, skb_get_queue_mapping(skb));
> +		goto drop_packet;
> +	}
> +	bf = list_first_entry(&sc->txbuf, struct ath5k_buf, list);
> +	list_del(&bf->list);
> +	sc->txbuf_len--;
> +	if (list_empty(&sc->txbuf))
> +		ieee80211_stop_queues(hw);
> +	spin_unlock_irqrestore(&sc->txbuflock, flags);
> +
> +	bf->skb = skb;
> +
> +	if (ath5k_txbuf_setup(sc, bf, txq, padsize)) {
> +		bf->skb = NULL;
> +		spin_lock_irqsave(&sc->txbuflock, flags);
> +		list_add_tail(&bf->list, &sc->txbuf);
> +		sc->txbuf_len++;
> +		spin_unlock_irqrestore(&sc->txbuflock, flags);
> +		goto drop_packet;
> +	}
> +	return NETDEV_TX_OK;
> +
> +drop_packet:
> +	dev_kfree_skb_any(skb);
> +	return NETDEV_TX_OK;
> +}
> +
> +
> +static void
> +ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
> +{
> +	struct ath5k_tx_status ts = {};
> +	struct ath5k_buf *bf, *bf0;
> +	struct ath5k_desc *ds;
> +	struct sk_buff *skb;
> +	struct ieee80211_tx_info *info;
> +	int i, ret;
> +
> +	spin_lock(&txq->lock);
> +	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
> +		ds = bf->desc;
> +
> +		/*
> +		 * It's possible that the hardware can say the buffer is
> +		 * completed when it hasn't yet loaded the ds_link from
> +		 * host memory and moved on.  If there are more TX
> +		 * descriptors in the queue, wait for TXDP to change
> +		 * before processing this one.
> +		 */
> +		if (ath5k_hw_get_txdp(sc->ah, txq->qnum) == bf->daddr &&
> +		    !list_is_last(&bf->list, &txq->q))
> +			break;
> +
> +		ret = sc->ah->ah_proc_tx_desc(sc->ah, ds, &ts);
> +		if (unlikely(ret == -EINPROGRESS))
>  			break;
>  		else if (unlikely(ret)) {
>  			ATH5K_ERR(sc, "error %d while processing queue %u\n",
> @@ -2313,6 +1707,43 @@ err_unmap:
>  }
> 
>  /*
> + * Updates the beacon that is sent by ath5k_beacon_send.  For adhoc,
> + * this is called only once at config_bss time, for AP we do it every
> + * SWBA interrupt so that the TIM will reflect buffered frames.
> + *
> + * Called with the beacon lock.
> + */
> +static int
> +ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
> +{
> +	int ret;
> +	struct ath5k_softc *sc = hw->priv;
> +	struct sk_buff *skb;
> +
> +	if (WARN_ON(!vif)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	skb = ieee80211_beacon_get(hw, vif);
> +
> +	if (!skb) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
> +
> +	ath5k_txbuf_free_skb(sc, sc->bbuf);
> +	sc->bbuf->skb = skb;
> +	ret = ath5k_beacon_setup(sc, sc->bbuf);
> +	if (ret)
> +		sc->bbuf->skb = NULL;
> +out:
> +	return ret;
> +}
> +
> +/*
>   * Transmit a beacon frame at SWBA.  Dynamic updates to the
>   * frame contents are done as needed and the slot time is
>   * also adjusted based on current state.
> @@ -2389,7 +1820,6 @@ ath5k_beacon_send(struct ath5k_softc *sc)
>  	sc->bsent++;
>  }
> 
> -
>  /**
>   * ath5k_beacon_update_timers - update beacon timers
>   *
> @@ -2491,7 +1921,6 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc,
> u64 bc_tsf) intval & AR5K_BEACON_RESET_TSF ? "AR5K_BEACON_RESET_TSF" :
> ""); }
> 
> -
>  /**
>   * ath5k_beacon_config - Configure the beacon queues and interrupts
>   *
> @@ -2570,66 +1999,181 @@ static void ath5k_tasklet_beacon(unsigned long
> data) * Interrupt handling *
>  \********************/
> 
> -static int
> -ath5k_init(struct ath5k_softc *sc)
> +static void
> +ath5k_intr_calibration_poll(struct ath5k_hw *ah)
>  {
> -	struct ath5k_hw *ah = sc->ah;
> -	struct ath_common *common = ath5k_hw_common(ah);
> -	int ret, i;
> +	if (time_is_before_eq_jiffies(ah->ah_cal_next_ani) &&
> +	    !(ah->ah_cal_mask & AR5K_CALIBRATION_FULL)) {
> +		/* run ANI only when full calibration is not active */
> +		ah->ah_cal_next_ani = jiffies +
> +			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_ANI);
> +		tasklet_schedule(&ah->ah_sc->ani_tasklet);
> 
> -	mutex_lock(&sc->lock);
> +	} else if (time_is_before_eq_jiffies(ah->ah_cal_next_full)) {
> +		ah->ah_cal_next_full = jiffies +
> +			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_FULL);
> +		tasklet_schedule(&ah->ah_sc->calib);
> +	}
> +	/* we could use SWI to generate enough interrupts to meet our
> +	 * calibration interval requirements, if necessary:
> +	 * AR5K_REG_ENABLE_BITS(ah, AR5K_CR, AR5K_CR_SWI); */
> +}
> 
> -	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "mode %d\n", sc->opmode);
> +static irqreturn_t
> +ath5k_intr(int irq, void *dev_id)
> +{
> +	struct ath5k_softc *sc = dev_id;
> +	struct ath5k_hw *ah = sc->ah;
> +	enum ath5k_int status;
> +	unsigned int counter = 1000;
> 
> -	/*
> -	 * Stop anything previously setup.  This is safe
> -	 * no matter this is the first time through or not.
> -	 */
> -	ath5k_stop_locked(sc);
> +	if (unlikely(test_bit(ATH_STAT_INVALID, sc->status) ||
> +				!ath5k_hw_is_intr_pending(ah)))
> +		return IRQ_NONE;
> 
> -	/*
> -	 * The basic interface to setting the hardware in a good
> -	 * state is ``reset''.  On return the hardware is known to
> -	 * be powered up and with interrupts disabled.  This must
> -	 * be followed by initialization of the appropriate bits
> -	 * and then setup of the interrupt mask.
> -	 */
> -	sc->curchan = sc->hw->conf.channel;
> -	sc->curband = &sc->sbands[sc->curchan->band];
> -	sc->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
> -		AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
> -		AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_MIB;
> +	do {
> +		ath5k_hw_get_isr(ah, &status);		/* NB: clears IRQ too */
> +		ATH5K_DBG(sc, ATH5K_DEBUG_INTR, "status 0x%x/0x%x\n",
> +				status, sc->imask);
> +		if (unlikely(status & AR5K_INT_FATAL)) {
> +			/*
> +			 * Fatal errors are unrecoverable.
> +			 * Typically these are caused by DMA errors.
> +			 */
> +			ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
> +				  "fatal int, resetting\n");
> +			ieee80211_queue_work(sc->hw, &sc->reset_work);
> +		} else if (unlikely(status & AR5K_INT_RXORN)) {
> +			/*
> +			 * Receive buffers are full. Either the bus is busy or
> +			 * the CPU is not fast enough to process all received
> +			 * frames.
> +			 * Older chipsets need a reset to come out of this
> +			 * condition, but we treat it as RX for newer chips.
> +			 * We don't know exactly which versions need a reset -
> +			 * this guess is copied from the HAL.
> +			 */
> +			sc->stats.rxorn_intr++;
> +			if (ah->ah_mac_srev < AR5K_SREV_AR5212) {
> +				ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
> +					  "rx overrun, resetting\n");
> +				ieee80211_queue_work(sc->hw, &sc->reset_work);
> +			}
> +			else
> +				tasklet_schedule(&sc->rxtq);
> +		} else {
> +			if (status & AR5K_INT_SWBA) {
> +				tasklet_hi_schedule(&sc->beacontq);
> +			}
> +			if (status & AR5K_INT_RXEOL) {
> +				/*
> +				* NB: the hardware should re-read the link when
> +				*     RXE bit is written, but it doesn't work at
> +				*     least on older hardware revs.
> +				*/
> +				sc->stats.rxeol_intr++;
> +			}
> +			if (status & AR5K_INT_TXURN) {
> +				/* bump tx trigger level */
> +				ath5k_hw_update_tx_triglevel(ah, true);
> +			}
> +			if (status & (AR5K_INT_RXOK | AR5K_INT_RXERR))
> +				tasklet_schedule(&sc->rxtq);
> +			if (status & (AR5K_INT_TXOK | AR5K_INT_TXDESC
> +					| AR5K_INT_TXERR | AR5K_INT_TXEOL))
> +				tasklet_schedule(&sc->txtq);
> +			if (status & AR5K_INT_BMISS) {
> +				/* TODO */
> +			}
> +			if (status & AR5K_INT_MIB) {
> +				sc->stats.mib_intr++;
> +				ath5k_hw_update_mib_counters(ah);
> +				ath5k_ani_mib_intr(ah);
> +			}
> +			if (status & AR5K_INT_GPIO)
> +				tasklet_schedule(&sc->rf_kill.toggleq);
> 
> -	ret = ath5k_reset(sc, NULL);
> -	if (ret)
> -		goto done;
> +		}
> +	} while (ath5k_hw_is_intr_pending(ah) && --counter > 0);
> 
> -	ath5k_rfkill_hw_start(ah);
> +	if (unlikely(!counter))
> +		ATH5K_WARN(sc, "too many interrupts, giving up for now\n");
> 
> -	/*
> -	 * Reset the key cache since some parts do not reset the
> -	 * contents on initial power up or resume from suspend.
> -	 */
> -	for (i = 0; i < common->keymax; i++)
> -		ath_hw_keyreset(common, (u16)i);
> +	ath5k_intr_calibration_poll(ah);
> 
> -	ath5k_hw_set_ack_bitrate_high(ah, true);
> -	ret = 0;
> -done:
> -	mmiowb();
> -	mutex_unlock(&sc->lock);
> -	return ret;
> +	return IRQ_HANDLED;
>  }
> 
> -static int
> -ath5k_stop_locked(struct ath5k_softc *sc)
> +/*
> + * Periodically recalibrate the PHY to account
> + * for temperature/environment changes.
> + */
> +static void
> +ath5k_tasklet_calibrate(unsigned long data)
>  {
> +	struct ath5k_softc *sc = (void *)data;
>  	struct ath5k_hw *ah = sc->ah;
> 
> -	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "invalid %u\n",
> -			test_bit(ATH_STAT_INVALID, sc->status));
> +	/* Only full calibration for now */
> +	ah->ah_cal_mask |= AR5K_CALIBRATION_FULL;
> 
> -	/*
> +	ATH5K_DBG(sc, ATH5K_DEBUG_CALIBRATE, "channel %u/%x\n",
> +		ieee80211_frequency_to_channel(sc->curchan->center_freq),
> +		sc->curchan->hw_value);
> +
> +	if (ath5k_hw_gainf_calibrate(ah) == AR5K_RFGAIN_NEED_CHANGE) {
> +		/*
> +		 * Rfgain is out of bounds, reset the chip
> +		 * to load new gain values.
> +		 */
> +		ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "calibration, resetting\n");
> +		ieee80211_queue_work(sc->hw, &sc->reset_work);
> +	}
> +	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
> +		ATH5K_ERR(sc, "calibration of channel %u failed\n",
> +			ieee80211_frequency_to_channel(
> +				sc->curchan->center_freq));
> +
> +	/* Noise floor calibration interrupts rx/tx path while I/Q calibration
> +	 * doesn't. We stop the queues so that calibration doesn't interfere
> +	 * with TX and don't run it as often */
> +	if (time_is_before_eq_jiffies(ah->ah_cal_next_nf)) {
> +		ah->ah_cal_next_nf = jiffies +
> +			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_NF);
> +		ieee80211_stop_queues(sc->hw);
> +		ath5k_hw_update_noise_floor(ah);
> +		ieee80211_wake_queues(sc->hw);
> +	}
> +
> +	ah->ah_cal_mask &= ~AR5K_CALIBRATION_FULL;
> +}
> +
> +
> +static void
> +ath5k_tasklet_ani(unsigned long data)
> +{
> +	struct ath5k_softc *sc = (void *)data;
> +	struct ath5k_hw *ah = sc->ah;
> +
> +	ah->ah_cal_mask |= AR5K_CALIBRATION_ANI;
> +	ath5k_ani_calibration(ah);
> +	ah->ah_cal_mask &= ~AR5K_CALIBRATION_ANI;
> +}
> +
> +
> +/*************************\
> +* Initialization routines *
> +\*************************/
> +
> +static int
> +ath5k_stop_locked(struct ath5k_softc *sc)
> +{
> +	struct ath5k_hw *ah = sc->ah;
> +
> +	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "invalid %u\n",
> +			test_bit(ATH_STAT_INVALID, sc->status));
> +
> +	/*
>  	 * Shutdown the hardware and driver:
>  	 *    stop output from above
>  	 *    disable interrupts
> @@ -2660,6 +2204,57 @@ ath5k_stop_locked(struct ath5k_softc *sc)
>  	return 0;
>  }
> 
> +static int
> +ath5k_init(struct ath5k_softc *sc)
> +{
> +	struct ath5k_hw *ah = sc->ah;
> +	struct ath_common *common = ath5k_hw_common(ah);
> +	int ret, i;
> +
> +	mutex_lock(&sc->lock);
> +
> +	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "mode %d\n", sc->opmode);
> +
> +	/*
> +	 * Stop anything previously setup.  This is safe
> +	 * no matter this is the first time through or not.
> +	 */
> +	ath5k_stop_locked(sc);
> +
> +	/*
> +	 * The basic interface to setting the hardware in a good
> +	 * state is ``reset''.  On return the hardware is known to
> +	 * be powered up and with interrupts disabled.  This must
> +	 * be followed by initialization of the appropriate bits
> +	 * and then setup of the interrupt mask.
> +	 */
> +	sc->curchan = sc->hw->conf.channel;
> +	sc->curband = &sc->sbands[sc->curchan->band];
> +	sc->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
> +		AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
> +		AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_MIB;
> +
> +	ret = ath5k_reset(sc, NULL);
> +	if (ret)
> +		goto done;
> +
> +	ath5k_rfkill_hw_start(ah);
> +
> +	/*
> +	 * Reset the key cache since some parts do not reset the
> +	 * contents on initial power up or resume from suspend.
> +	 */
> +	for (i = 0; i < common->keymax; i++)
> +		ath_hw_keyreset(common, (u16) i);
> +
> +	ath5k_hw_set_ack_bitrate_high(ah, true);
> +	ret = 0;
> +done:
> +	mmiowb();
> +	mutex_unlock(&sc->lock);
> +	return ret;
> +}
> +
>  static void stop_tasklets(struct ath5k_softc *sc)
>  {
>  	tasklet_kill(&sc->rxtq);
> @@ -2720,310 +2315,257 @@ ath5k_stop_hw(struct ath5k_softc *sc)
>  	return ret;
>  }
> 
> -static void
> -ath5k_intr_calibration_poll(struct ath5k_hw *ah)
> +/*
> + * Reset the hardware.  If chan is not NULL, then also pause rx/tx
> + * and change to the given channel.
> + *
> + * This should be called with sc->lock.
> + */
> +static int
> +ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
>  {
> -	if (time_is_before_eq_jiffies(ah->ah_cal_next_ani) &&
> -	    !(ah->ah_cal_mask & AR5K_CALIBRATION_FULL)) {
> -		/* run ANI only when full calibration is not active */
> -		ah->ah_cal_next_ani = jiffies +
> -			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_ANI);
> -		tasklet_schedule(&ah->ah_sc->ani_tasklet);
> +	struct ath5k_hw *ah = sc->ah;
> +	int ret;
> 
> -	} else if (time_is_before_eq_jiffies(ah->ah_cal_next_full)) {
> -		ah->ah_cal_next_full = jiffies +
> -			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_FULL);
> -		tasklet_schedule(&ah->ah_sc->calib);
> +	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
> +
> +	ath5k_hw_set_imr(ah, 0);
> +	synchronize_irq(sc->pdev->irq);
> +	stop_tasklets(sc);
> +
> +	if (chan) {
> +		ath5k_txq_cleanup(sc);
> +		ath5k_rx_stop(sc);
> +
> +		sc->curchan = chan;
> +		sc->curband = &sc->sbands[chan->band];
> +	}
> +	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL);
> +	if (ret) {
> +		ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
> +		goto err;
>  	}
> -	/* we could use SWI to generate enough interrupts to meet our
> -	 * calibration interval requirements, if necessary:
> -	 * AR5K_REG_ENABLE_BITS(ah, AR5K_CR, AR5K_CR_SWI); */
> -}
> 
> -static irqreturn_t
> -ath5k_intr(int irq, void *dev_id)
> -{
> -	struct ath5k_softc *sc = dev_id;
> -	struct ath5k_hw *ah = sc->ah;
> -	enum ath5k_int status;
> -	unsigned int counter = 1000;
> +	ret = ath5k_rx_start(sc);
> +	if (ret) {
> +		ATH5K_ERR(sc, "can't start recv logic\n");
> +		goto err;
> +	}
> 
> -	if (unlikely(test_bit(ATH_STAT_INVALID, sc->status) ||
> -				!ath5k_hw_is_intr_pending(ah)))
> -		return IRQ_NONE;
> +	ath5k_ani_init(ah, ah->ah_sc->ani_state.ani_mode);
> 
> -	do {
> -		ath5k_hw_get_isr(ah, &status);		/* NB: clears IRQ too */
> -		ATH5K_DBG(sc, ATH5K_DEBUG_INTR, "status 0x%x/0x%x\n",
> -				status, sc->imask);
> -		if (unlikely(status & AR5K_INT_FATAL)) {
> -			/*
> -			 * Fatal errors are unrecoverable.
> -			 * Typically these are caused by DMA errors.
> -			 */
> -			ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
> -				  "fatal int, resetting\n");
> -			ieee80211_queue_work(sc->hw, &sc->reset_work);
> -		} else if (unlikely(status & AR5K_INT_RXORN)) {
> -			/*
> -			 * Receive buffers are full. Either the bus is busy or
> -			 * the CPU is not fast enough to process all received
> -			 * frames.
> -			 * Older chipsets need a reset to come out of this
> -			 * condition, but we treat it as RX for newer chips.
> -			 * We don't know exactly which versions need a reset -
> -			 * this guess is copied from the HAL.
> -			 */
> -			sc->stats.rxorn_intr++;
> -			if (ah->ah_mac_srev < AR5K_SREV_AR5212) {
> -				ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
> -					  "rx overrun, resetting\n");
> -				ieee80211_queue_work(sc->hw, &sc->reset_work);
> -			}
> -			else
> -				tasklet_schedule(&sc->rxtq);
> -		} else {
> -			if (status & AR5K_INT_SWBA) {
> -				tasklet_hi_schedule(&sc->beacontq);
> -			}
> -			if (status & AR5K_INT_RXEOL) {
> -				/*
> -				* NB: the hardware should re-read the link when
> -				*     RXE bit is written, but it doesn't work at
> -				*     least on older hardware revs.
> -				*/
> -				sc->stats.rxeol_intr++;
> -			}
> -			if (status & AR5K_INT_TXURN) {
> -				/* bump tx trigger level */
> -				ath5k_hw_update_tx_triglevel(ah, true);
> -			}
> -			if (status & (AR5K_INT_RXOK | AR5K_INT_RXERR))
> -				tasklet_schedule(&sc->rxtq);
> -			if (status & (AR5K_INT_TXOK | AR5K_INT_TXDESC
> -					| AR5K_INT_TXERR | AR5K_INT_TXEOL))
> -				tasklet_schedule(&sc->txtq);
> -			if (status & AR5K_INT_BMISS) {
> -				/* TODO */
> -			}
> -			if (status & AR5K_INT_MIB) {
> -				sc->stats.mib_intr++;
> -				ath5k_hw_update_mib_counters(ah);
> -				ath5k_ani_mib_intr(ah);
> -			}
> -			if (status & AR5K_INT_GPIO)
> -				tasklet_schedule(&sc->rf_kill.toggleq);
> +	ah->ah_cal_next_full = jiffies;
> +	ah->ah_cal_next_ani = jiffies;
> +	ah->ah_cal_next_nf = jiffies;
> 
> -		}
> -	} while (ath5k_hw_is_intr_pending(ah) && --counter > 0);
> +	/*
> +	 * Change channels and update the h/w rate map if we're switching;
> +	 * e.g. 11a to 11b/g.
> +	 *
> +	 * We may be doing a reset in response to an ioctl that changes the
> +	 * channel so update any state that might change as a result.
> +	 *
> +	 * XXX needed?
> +	 */
> +/*	ath5k_chan_change(sc, c); */
> 
> -	if (unlikely(!counter))
> -		ATH5K_WARN(sc, "too many interrupts, giving up for now\n");
> +	ath5k_beacon_config(sc);
> +	/* intrs are enabled by ath5k_beacon_config */
> 
> -	ath5k_intr_calibration_poll(ah);
> +	ieee80211_wake_queues(sc->hw);
> 
> -	return IRQ_HANDLED;
> +	return 0;
> +err:
> +	return ret;
>  }
> 
> -/*
> - * Periodically recalibrate the PHY to account
> - * for temperature/environment changes.
> - */
> -static void
> -ath5k_tasklet_calibrate(unsigned long data)
> +static void ath5k_reset_work(struct work_struct *work)
>  {
> -	struct ath5k_softc *sc = (void *)data;
> -	struct ath5k_hw *ah = sc->ah;
> -
> -	/* Only full calibration for now */
> -	ah->ah_cal_mask |= AR5K_CALIBRATION_FULL;
> -
> -	ATH5K_DBG(sc, ATH5K_DEBUG_CALIBRATE, "channel %u/%x\n",
> -		ieee80211_frequency_to_channel(sc->curchan->center_freq),
> -		sc->curchan->hw_value);
> -
> -	if (ath5k_hw_gainf_calibrate(ah) == AR5K_RFGAIN_NEED_CHANGE) {
> -		/*
> -		 * Rfgain is out of bounds, reset the chip
> -		 * to load new gain values.
> -		 */
> -		ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "calibration, resetting\n");
> -		ieee80211_queue_work(sc->hw, &sc->reset_work);
> -	}
> -	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
> -		ATH5K_ERR(sc, "calibration of channel %u failed\n",
> -			ieee80211_frequency_to_channel(
> -				sc->curchan->center_freq));
> -
> -	/* Noise floor calibration interrupts rx/tx path while I/Q calibration
> -	 * doesn't. We stop the queues so that calibration doesn't interfere
> -	 * with TX and don't run it as often */
> -	if (time_is_before_eq_jiffies(ah->ah_cal_next_nf)) {
> -		ah->ah_cal_next_nf = jiffies +
> -			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_NF);
> -		ieee80211_stop_queues(sc->hw);
> -		ath5k_hw_update_noise_floor(ah);
> -		ieee80211_wake_queues(sc->hw);
> -	}
> -
> -	ah->ah_cal_mask &= ~AR5K_CALIBRATION_FULL;
> -}
> -
> -
> -static void
> -ath5k_tasklet_ani(unsigned long data)
> -{
> -	struct ath5k_softc *sc = (void *)data;
> -	struct ath5k_hw *ah = sc->ah;
> +	struct ath5k_softc *sc = container_of(work, struct ath5k_softc,
> +		reset_work);
> 
> -	ah->ah_cal_mask |= AR5K_CALIBRATION_ANI;
> -	ath5k_ani_calibration(ah);
> -	ah->ah_cal_mask &= ~AR5K_CALIBRATION_ANI;
> +	mutex_lock(&sc->lock);
> +	ath5k_reset(sc, sc->curchan);
> +	mutex_unlock(&sc->lock);
>  }
> 
> -
> -/********************\
> -* Mac80211 functions *
> -\********************/
> -
>  static int
> -ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
> +ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
>  {
>  	struct ath5k_softc *sc = hw->priv;
> +	struct ath5k_hw *ah = sc->ah;
> +	struct ath_regulatory *regulatory = ath5k_hw_regulatory(ah);
> +	u8 mac[ETH_ALEN] = {};
> +	int ret;
> 
> -	return ath5k_tx_queue(hw, skb, sc->txq);
> -}
> +	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "devid 0x%x\n", pdev->device);
> 
> -static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
> -			  struct ath5k_txq *txq)
> -{
> -	struct ath5k_softc *sc = hw->priv;
> -	struct ath5k_buf *bf;
> -	unsigned long flags;
> -	int padsize;
> +	/*
> +	 * Check if the MAC has multi-rate retry support.
> +	 * We do this by trying to setup a fake extended
> +	 * descriptor.  MACs that don't have support will
> +	 * return false w/o doing anything.  MACs that do
> +	 * support it will return true w/o doing anything.
> +	 */
> +	ret = ath5k_hw_setup_mrr_tx_desc(ah, NULL, 0, 0, 0, 0, 0, 0);
> 
> -	ath5k_debug_dump_skb(sc, skb, "TX  ", 1);
> +	if (ret < 0)
> +		goto err;
> +	if (ret > 0)
> +		__set_bit(ATH_STAT_MRRETRY, sc->status);
> 
>  	/*
> -	 * The hardware expects the header padded to 4 byte boundaries.
> -	 * If this is not the case, we add the padding after the header.
> +	 * Collect the channel list.  The 802.11 layer
> +	 * is resposible for filtering this list based
> +	 * on settings like the phy mode and regulatory
> +	 * domain restrictions.
>  	 */
> -	padsize = ath5k_add_padding(skb);
> -	if (padsize < 0) {
> -		ATH5K_ERR(sc, "tx hdrlen not %%4: not enough"
> -			  " headroom to pad");
> -		goto drop_packet;
> +	ret = ath5k_setup_bands(hw);
> +	if (ret) {
> +		ATH5K_ERR(sc, "can't get channels\n");
> +		goto err;
>  	}
> 
> -	spin_lock_irqsave(&sc->txbuflock, flags);
> -	if (list_empty(&sc->txbuf)) {
> -		ATH5K_ERR(sc, "no further txbuf available, dropping packet\n");
> -		spin_unlock_irqrestore(&sc->txbuflock, flags);
> -		ieee80211_stop_queue(hw, skb_get_queue_mapping(skb));
> -		goto drop_packet;
> -	}
> -	bf = list_first_entry(&sc->txbuf, struct ath5k_buf, list);
> -	list_del(&bf->list);
> -	sc->txbuf_len--;
> -	if (list_empty(&sc->txbuf))
> -		ieee80211_stop_queues(hw);
> -	spin_unlock_irqrestore(&sc->txbuflock, flags);
> +	/* NB: setup here so ath5k_rate_update is happy */
> +	if (test_bit(AR5K_MODE_11A, ah->ah_modes))
> +		ath5k_setcurmode(sc, AR5K_MODE_11A);
> +	else
> +		ath5k_setcurmode(sc, AR5K_MODE_11B);
> 
> -	bf->skb = skb;
> +	/*
> +	 * Allocate tx+rx descriptors and populate the lists.
> +	 */
> +	ret = ath5k_desc_alloc(sc, pdev);
> +	if (ret) {
> +		ATH5K_ERR(sc, "can't allocate descriptors\n");
> +		goto err;
> +	}
> 
> -	if (ath5k_txbuf_setup(sc, bf, txq, padsize)) {
> -		bf->skb = NULL;
> -		spin_lock_irqsave(&sc->txbuflock, flags);
> -		list_add_tail(&bf->list, &sc->txbuf);
> -		sc->txbuf_len++;
> -		spin_unlock_irqrestore(&sc->txbuflock, flags);
> -		goto drop_packet;
> +	/*
> +	 * Allocate hardware transmit queues: one queue for
> +	 * beacon frames and one data queue for each QoS
> +	 * priority.  Note that hw functions handle resetting
> +	 * these queues at the needed time.
> +	 */
> +	ret = ath5k_beaconq_setup(ah);
> +	if (ret < 0) {
> +		ATH5K_ERR(sc, "can't setup a beacon xmit queue\n");
> +		goto err_desc;
> +	}
> +	sc->bhalq = ret;
> +	sc->cabq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_CAB, 0);
> +	if (IS_ERR(sc->cabq)) {
> +		ATH5K_ERR(sc, "can't setup cab queue\n");
> +		ret = PTR_ERR(sc->cabq);
> +		goto err_bhal;
>  	}
> -	return NETDEV_TX_OK;
> 
> -drop_packet:
> -	dev_kfree_skb_any(skb);
> -	return NETDEV_TX_OK;
> -}
> +	sc->txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
> +	if (IS_ERR(sc->txq)) {
> +		ATH5K_ERR(sc, "can't setup xmit queue\n");
> +		ret = PTR_ERR(sc->txq);
> +		goto err_queues;
> +	}
> 
> -/*
> - * Reset the hardware.  If chan is not NULL, then also pause rx/tx
> - * and change to the given channel.
> - *
> - * This should be called with sc->lock.
> - */
> -static int
> -ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
> -{
> -	struct ath5k_hw *ah = sc->ah;
> -	int ret;
> +	tasklet_init(&sc->rxtq, ath5k_tasklet_rx, (unsigned long)sc);
> +	tasklet_init(&sc->txtq, ath5k_tasklet_tx, (unsigned long)sc);
> +	tasklet_init(&sc->calib, ath5k_tasklet_calibrate, (unsigned long)sc);
> +	tasklet_init(&sc->beacontq, ath5k_tasklet_beacon, (unsigned long)sc);
> +	tasklet_init(&sc->ani_tasklet, ath5k_tasklet_ani, (unsigned long)sc);
> 
> -	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
> +	INIT_WORK(&sc->reset_work, ath5k_reset_work);
> 
> -	ath5k_hw_set_imr(ah, 0);
> -	synchronize_irq(sc->pdev->irq);
> -	stop_tasklets(sc);
> +	ret = ath5k_eeprom_read_mac(ah, mac);
> +	if (ret) {
> +		ATH5K_ERR(sc, "unable to read address from EEPROM: 0x%04x\n",
> +			sc->pdev->device);
> +		goto err_queues;
> +	}
> 
> -	if (chan) {
> -		ath5k_txq_cleanup(sc);
> -		ath5k_rx_stop(sc);
> +	SET_IEEE80211_PERM_ADDR(hw, mac);
> +	/* All MAC address bits matter for ACKs */
> +	memcpy(sc->bssidmask, ath_bcast_mac, ETH_ALEN);
> +	ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
> 
> -		sc->curchan = chan;
> -		sc->curband = &sc->sbands[chan->band];
> -	}
> -	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL);
> +	regulatory->current_rd = ah->ah_capabilities.cap_eeprom.ee_regdomain;
> +	ret = ath_regd_init(regulatory, hw->wiphy, ath5k_reg_notifier);
>  	if (ret) {
> -		ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
> -		goto err;
> +		ATH5K_ERR(sc, "can't initialize regulatory system\n");
> +		goto err_queues;
>  	}
> 
> -	ret = ath5k_rx_start(sc);
> +	ret = ieee80211_register_hw(hw);
>  	if (ret) {
> -		ATH5K_ERR(sc, "can't start recv logic\n");
> -		goto err;
> +		ATH5K_ERR(sc, "can't register ieee80211 hw\n");
> +		goto err_queues;
>  	}
> 
> -	ath5k_ani_init(ah, ah->ah_sc->ani_state.ani_mode);
> -
> -	ah->ah_cal_next_full = jiffies;
> -	ah->ah_cal_next_ani = jiffies;
> -	ah->ah_cal_next_nf = jiffies;
> -
> -	/*
> -	 * Change channels and update the h/w rate map if we're switching;
> -	 * e.g. 11a to 11b/g.
> -	 *
> -	 * We may be doing a reset in response to an ioctl that changes the
> -	 * channel so update any state that might change as a result.
> -	 *
> -	 * XXX needed?
> -	 */
> -/*	ath5k_chan_change(sc, c); */
> +	if (!ath_is_world_regd(regulatory))
> +		regulatory_hint(hw->wiphy, regulatory->alpha2);
> 
> -	ath5k_beacon_config(sc);
> -	/* intrs are enabled by ath5k_beacon_config */
> +	ath5k_init_leds(sc);
> 
> -	ieee80211_wake_queues(sc->hw);
> +	ath5k_sysfs_register(sc);
> 
>  	return 0;
> +err_queues:
> +	ath5k_txq_release(sc);
> +err_bhal:
> +	ath5k_hw_release_tx_queue(ah, sc->bhalq);
> +err_desc:
> +	ath5k_desc_free(sc, pdev);
>  err:
>  	return ret;
>  }
> 
> -static void ath5k_reset_work(struct work_struct *work)
> +static void
> +ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
>  {
> -	struct ath5k_softc *sc = container_of(work, struct ath5k_softc,
> -		reset_work);
> -
> -	mutex_lock(&sc->lock);
> -	ath5k_reset(sc, sc->curchan);
> -	mutex_unlock(&sc->lock);
> -}
> +	struct ath5k_softc *sc = hw->priv;
> 
> -static int ath5k_start(struct ieee80211_hw *hw)
> -{
> -	return ath5k_init(hw->priv);
> -}
> +	/*
> +	 * NB: the order of these is important:
> +	 * o call the 802.11 layer before detaching ath5k_hw to
> +	 *   ensure callbacks into the driver to delete global
> +	 *   key cache entries can be handled
> +	 * o reclaim the tx queue data structures after calling
> +	 *   the 802.11 layer as we'll get called back to reclaim
> +	 *   node state and potentially want to use them
> +	 * o to cleanup the tx queues the hal is called, so detach
> +	 *   it last
> +	 * XXX: ??? detach ath5k_hw ???
> +	 * Other than that, it's straightforward...
> +	 */
> +	ieee80211_unregister_hw(hw);
> +	ath5k_desc_free(sc, pdev);
> +	ath5k_txq_release(sc);
> +	ath5k_hw_release_tx_queue(sc->ah, sc->bhalq);
> +	ath5k_unregister_leds(sc);
> +
> +	ath5k_sysfs_unregister(sc);
> +	/*
> +	 * NB: can't reclaim these until after ieee80211_ifdetach
> +	 * returns because we'll get called back to reclaim node
> +	 * state and potentially want to use them.
> +	 */
> +}
> +
> +/********************\
> +* Mac80211 functions *
> +\********************/
> +
> +static int
> +ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
> +{
> +	struct ath5k_softc *sc = hw->priv;
> +
> +	return ath5k_tx_queue(hw, skb, sc->txq);
> +}
> +
> +static int ath5k_start(struct ieee80211_hw *hw)
> +{
> +	return ath5k_init(hw->priv);
> +}
> 
>  static void ath5k_stop(struct ieee80211_hw *hw)
>  {
> @@ -3329,214 +2871,538 @@ ath5k_set_key(struct ieee80211_hw *hw, enum
> set_key_cmd cmd, ret = -EINVAL;
>  	}
> 
> -	mmiowb();
> -	mutex_unlock(&sc->lock);
> -	return ret;
> -}
> -
> -static int
> -ath5k_get_stats(struct ieee80211_hw *hw,
> -		struct ieee80211_low_level_stats *stats)
> -{
> -	struct ath5k_softc *sc = hw->priv;
> -
> -	/* Force update */
> -	ath5k_hw_update_mib_counters(sc->ah);
> -
> -	stats->dot11ACKFailureCount = sc->stats.ack_fail;
> -	stats->dot11RTSFailureCount = sc->stats.rts_fail;
> -	stats->dot11RTSSuccessCount = sc->stats.rts_ok;
> -	stats->dot11FCSErrorCount = sc->stats.fcs_error;
> -
> -	return 0;
> -}
> -
> -static int ath5k_get_survey(struct ieee80211_hw *hw, int idx,
> -		struct survey_info *survey)
> -{
> -	struct ath5k_softc *sc = hw->priv;
> -	struct ieee80211_conf *conf = &hw->conf;
> -
> -	 if (idx != 0)
> -		return -ENOENT;
> +	mmiowb();
> +	mutex_unlock(&sc->lock);
> +	return ret;
> +}
> +
> +static int
> +ath5k_get_stats(struct ieee80211_hw *hw,
> +		struct ieee80211_low_level_stats *stats)
> +{
> +	struct ath5k_softc *sc = hw->priv;
> +
> +	/* Force update */
> +	ath5k_hw_update_mib_counters(sc->ah);
> +
> +	stats->dot11ACKFailureCount = sc->stats.ack_fail;
> +	stats->dot11RTSFailureCount = sc->stats.rts_fail;
> +	stats->dot11RTSSuccessCount = sc->stats.rts_ok;
> +	stats->dot11FCSErrorCount = sc->stats.fcs_error;
> +
> +	return 0;
> +}
> +
> +static int ath5k_get_survey(struct ieee80211_hw *hw, int idx,
> +		struct survey_info *survey)
> +{
> +	struct ath5k_softc *sc = hw->priv;
> +	struct ieee80211_conf *conf = &hw->conf;
> +
> +	 if (idx != 0)
> +		return -ENOENT;
> +
> +	survey->channel = conf->channel;
> +	survey->filled = SURVEY_INFO_NOISE_DBM;
> +	survey->noise = sc->ah->ah_noise_floor;
> +
> +	return 0;
> +}
> +
> +static u64
> +ath5k_get_tsf(struct ieee80211_hw *hw)
> +{
> +	struct ath5k_softc *sc = hw->priv;
> +
> +	return ath5k_hw_get_tsf64(sc->ah);
> +}
> +
> +static void
> +ath5k_set_tsf(struct ieee80211_hw *hw, u64 tsf)
> +{
> +	struct ath5k_softc *sc = hw->priv;
> +
> +	ath5k_hw_set_tsf64(sc->ah, tsf);
> +}
> +
> +static void
> +ath5k_reset_tsf(struct ieee80211_hw *hw)
> +{
> +	struct ath5k_softc *sc = hw->priv;
> +
> +	/*
> +	 * in IBSS mode we need to update the beacon timers too.
> +	 * this will also reset the TSF if we call it with 0
> +	 */
> +	if (sc->opmode == NL80211_IFTYPE_ADHOC)
> +		ath5k_beacon_update_timers(sc, 0);
> +	else
> +		ath5k_hw_reset_tsf(sc->ah);
> +}
> +
> +static void
> +set_beacon_filter(struct ieee80211_hw *hw, bool enable)
> +{
> +	struct ath5k_softc *sc = hw->priv;
> +	struct ath5k_hw *ah = sc->ah;
> +	u32 rfilt;
> +	rfilt = ath5k_hw_get_rx_filter(ah);
> +	if (enable)
> +		rfilt |= AR5K_RX_FILTER_BEACON;
> +	else
> +		rfilt &= ~AR5K_RX_FILTER_BEACON;
> +	ath5k_hw_set_rx_filter(ah, rfilt);
> +	sc->filter_flags = rfilt;
> +}
> +
> +static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
> +				    struct ieee80211_vif *vif,
> +				    struct ieee80211_bss_conf *bss_conf,
> +				    u32 changes)
> +{
> +	struct ath5k_softc *sc = hw->priv;
> +	struct ath5k_hw *ah = sc->ah;
> +	struct ath_common *common = ath5k_hw_common(ah);
> +	unsigned long flags;
> +
> +	mutex_lock(&sc->lock);
> +	if (WARN_ON(sc->vif != vif))
> +		goto unlock;
> +
> +	if (changes & BSS_CHANGED_BSSID) {
> +		/* Cache for later use during resets */
> +		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
> +		common->curaid = 0;
> +		ath5k_hw_set_bssid(ah);
> +		mmiowb();
> +	}
> +
> +	if (changes & BSS_CHANGED_BEACON_INT)
> +		sc->bintval = bss_conf->beacon_int;
> +
> +	if (changes & BSS_CHANGED_ASSOC) {
> +		sc->assoc = bss_conf->assoc;
> +		if (sc->opmode == NL80211_IFTYPE_STATION)
> +			set_beacon_filter(hw, sc->assoc);
> +		ath5k_hw_set_ledstate(sc->ah, sc->assoc ?
> +			AR5K_LED_ASSOC : AR5K_LED_INIT);
> +		if (bss_conf->assoc) {
> +			ATH5K_DBG(sc, ATH5K_DEBUG_ANY,
> +				  "Bss Info ASSOC %d, bssid: %pM\n",
> +				  bss_conf->aid, common->curbssid);
> +			common->curaid = bss_conf->aid;
> +			ath5k_hw_set_bssid(ah);
> +			/* Once ANI is available you would start it here */
> +		}
> +	}
> +
> +	if (changes & BSS_CHANGED_BEACON) {
> +		spin_lock_irqsave(&sc->block, flags);
> +		ath5k_beacon_update(hw, vif);
> +		spin_unlock_irqrestore(&sc->block, flags);
> +	}
> +
> +	if (changes & BSS_CHANGED_BEACON_ENABLED)
> +		sc->enable_beacon = bss_conf->enable_beacon;
> +
> +	if (changes & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_ENABLED |
> +		       BSS_CHANGED_BEACON_INT))
> +		ath5k_beacon_config(sc);
> +
> + unlock:
> +	mutex_unlock(&sc->lock);
> +}
> +
> +static void ath5k_sw_scan_start(struct ieee80211_hw *hw)
> +{
> +	struct ath5k_softc *sc = hw->priv;
> +	if (!sc->assoc)
> +		ath5k_hw_set_ledstate(sc->ah, AR5K_LED_SCAN);
> +}
> +
> +static void ath5k_sw_scan_complete(struct ieee80211_hw *hw)
> +{
> +	struct ath5k_softc *sc = hw->priv;
> +	ath5k_hw_set_ledstate(sc->ah, sc->assoc ?
> +		AR5K_LED_ASSOC : AR5K_LED_INIT);
> +}
> +
> +/**
> + * ath5k_set_coverage_class - Set IEEE 802.11 coverage class
> + *
> + * @hw: struct ieee80211_hw pointer
> + * @coverage_class: IEEE 802.11 coverage class number
> + *
> + * Mac80211 callback. Sets slot time, ACK timeout and CTS timeout for
> given + * coverage class. The values are persistent, they are restored
> after device + * reset.
> + */
> +static void ath5k_set_coverage_class(struct ieee80211_hw *hw, u8
> coverage_class) +{
> +	struct ath5k_softc *sc = hw->priv;
> +
> +	mutex_lock(&sc->lock);
> +	ath5k_hw_set_coverage_class(sc->ah, coverage_class);
> +	mutex_unlock(&sc->lock);
> +}
> +
> +static const struct ieee80211_ops ath5k_hw_ops = {
> +	.tx 		= ath5k_tx,
> +	.start 		= ath5k_start,
> +	.stop 		= ath5k_stop,
> +	.add_interface 	= ath5k_add_interface,
> +	.remove_interface = ath5k_remove_interface,
> +	.config 	= ath5k_config,
> +	.prepare_multicast = ath5k_prepare_multicast,
> +	.configure_filter = ath5k_configure_filter,
> +	.set_key 	= ath5k_set_key,
> +	.get_stats 	= ath5k_get_stats,
> +	.get_survey	= ath5k_get_survey,
> +	.conf_tx 	= NULL,
> +	.get_tsf 	= ath5k_get_tsf,
> +	.set_tsf 	= ath5k_set_tsf,
> +	.reset_tsf 	= ath5k_reset_tsf,
> +	.bss_info_changed = ath5k_bss_info_changed,
> +	.sw_scan_start	= ath5k_sw_scan_start,
> +	.sw_scan_complete = ath5k_sw_scan_complete,
> +	.set_coverage_class = ath5k_set_coverage_class,
> +};
> +
> +/********************\
> +* PCI Initialization *
> +\********************/
> +
> +static int __devinit
> +ath5k_pci_probe(struct pci_dev *pdev,
> +		const struct pci_device_id *id)
> +{
> +	void __iomem *mem;
> +	struct ath5k_softc *sc;
> +	struct ath_common *common;
> +	struct ieee80211_hw *hw;
> +	int ret;
> +	u8 csz;
> +
> +	/*
> +	 * L0s needs to be disabled on all ath5k cards.
> +	 *
> +	 * For distributions shipping with CONFIG_PCIEASPM (this will be enabled
> +	 * by default in the future in 2.6.36) this will also mean both L1 and
> +	 * L0s will be disabled when a pre 1.1 PCIe device is detected. We do
> +	 * know L1 works correctly even for all ath5k pre 1.1 PCIe devices
> +	 * though but cannot currently undue the effect of a blacklist, for
> +	 * details you can read pcie_aspm_sanity_check() and see how it adjusts
> +	 * the device link capability.
> +	 *
> +	 * It may be possible in the future to implement some PCI API to allow
> +	 * drivers to override blacklists for pre 1.1 PCIe but for now it is
> +	 * best to accept that both L0s and L1 will be disabled completely for
> +	 * distributions shipping with CONFIG_PCIEASPM rather than having this
> +	 * issue present. Motivation for adding this new API will be to help
> +	 * with power consumption for some of these devices.
> +	 */
> +	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "can't enable device\n");
> +		goto err;
> +	}
> +
> +	/* XXX 32-bit addressing only */
> +	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> +	if (ret) {
> +		dev_err(&pdev->dev, "32-bit DMA not available\n");
> +		goto err_dis;
> +	}
> +
> +	/*
> +	 * Cache line size is used to size and align various
> +	 * structures used to communicate with the hardware.
> +	 */
> +	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &csz);
> +	if (csz == 0) {
> +		/*
> +		 * Linux 2.4.18 (at least) writes the cache line size
> +		 * register as a 16-bit wide register which is wrong.
> +		 * We must have this setup properly for rx buffer
> +		 * DMA to work so force a reasonable value here if it
> +		 * comes up zero.
> +		 */
> +		csz = L1_CACHE_BYTES >> 2;
> +		pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, csz);
> +	}
> +	/*
> +	 * The default setting of latency timer yields poor results,
> +	 * set it to the value used by other systems.  It may be worth
> +	 * tweaking this setting more.
> +	 */
> +	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0xa8);
> +
> +	/* Enable bus mastering */
> +	pci_set_master(pdev);
> +
> +	/*
> +	 * Disable the RETRY_TIMEOUT register (0x41) to keep
> +	 * PCI Tx retries from interfering with C3 CPU state.
> +	 */
> +	pci_write_config_byte(pdev, 0x41, 0);
> +
> +	ret = pci_request_region(pdev, 0, "ath5k");
> +	if (ret) {
> +		dev_err(&pdev->dev, "cannot reserve PCI memory region\n");
> +		goto err_dis;
> +	}
> +
> +	mem = pci_iomap(pdev, 0, 0);
> +	if (!mem) {
> +		dev_err(&pdev->dev, "cannot remap PCI memory region\n") ;
> +		ret = -EIO;
> +		goto err_reg;
> +	}
> +
> +	/*
> +	 * Allocate hw (mac80211 main struct)
> +	 * and hw->priv (driver private data)
> +	 */
> +	hw = ieee80211_alloc_hw(sizeof(*sc), &ath5k_hw_ops);
> +	if (hw == NULL) {
> +		dev_err(&pdev->dev, "cannot allocate ieee80211_hw\n");
> +		ret = -ENOMEM;
> +		goto err_map;
> +	}
> +
> +	dev_info(&pdev->dev, "registered as '%s'\n", wiphy_name(hw->wiphy));
> +
> +	/* Initialize driver private data */
> +	SET_IEEE80211_DEV(hw, &pdev->dev);
> +	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
> +		    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
> +		    IEEE80211_HW_SIGNAL_DBM;
> +
> +	hw->wiphy->interface_modes =
> +		BIT(NL80211_IFTYPE_AP) |
> +		BIT(NL80211_IFTYPE_STATION) |
> +		BIT(NL80211_IFTYPE_ADHOC) |
> +		BIT(NL80211_IFTYPE_MESH_POINT);
> +
> +	hw->extra_tx_headroom = 2;
> +	hw->channel_change_time = 5000;
> +	sc = hw->priv;
> +	sc->hw = hw;
> +	sc->pdev = pdev;
> +
> +	ath5k_debug_init_device(sc);
> +
> +	/*
> +	 * Mark the device as detached to avoid processing
> +	 * interrupts until setup is complete.
> +	 */
> +	__set_bit(ATH_STAT_INVALID, sc->status);
> +
> +	sc->iobase = mem; /* So we can unmap it on detach */
> +	sc->opmode = NL80211_IFTYPE_STATION;
> +	sc->bintval = 1000;
> +	mutex_init(&sc->lock);
> +	spin_lock_init(&sc->rxbuflock);
> +	spin_lock_init(&sc->txbuflock);
> +	spin_lock_init(&sc->block);
> +
> +	/* Set private data */
> +	pci_set_drvdata(pdev, sc);
> +
> +	/* Setup interrupt handler */
> +	ret = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
> +	if (ret) {
> +		ATH5K_ERR(sc, "request_irq failed\n");
> +		goto err_free;
> +	}
> +
> +	/* If we passed the test, malloc an ath5k_hw struct */
> +	sc->ah = kzalloc(sizeof(struct ath5k_hw), GFP_KERNEL);
> +	if (!sc->ah) {
> +		ret = -ENOMEM;
> +		ATH5K_ERR(sc, "out of memory\n");
> +		goto err_irq;
> +	}
> +
> +	sc->ah->ah_sc = sc;
> +	sc->ah->ah_iobase = sc->iobase;
> +	common = ath5k_hw_common(sc->ah);
> +	common->ops = &ath5k_common_ops;
> +	common->ah = sc->ah;
> +	common->hw = hw;
> +	common->cachelsz = csz << 2; /* convert to bytes */
> +
> +	/* Initialize device */
> +	ret = ath5k_hw_attach(sc);
> +	if (ret) {
> +		goto err_free_ah;
> +	}
> +
> +	/* set up multi-rate retry capabilities */
> +	if (sc->ah->ah_version == AR5K_AR5212) {
> +		hw->max_rates = 4;
> +		hw->max_rate_tries = 11;
> +	}
> +
> +	/* Finish private driver data initialization */
> +	ret = ath5k_attach(pdev, hw);
> +	if (ret)
> +		goto err_ah;
> +
> +	ATH5K_INFO(sc, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
> +			ath5k_chip_name(AR5K_VERSION_MAC, sc->ah->ah_mac_srev),
> +					sc->ah->ah_mac_srev,
> +					sc->ah->ah_phy_revision);
> +
> +	if (!sc->ah->ah_single_chip) {
> +		/* Single chip radio (!RF5111) */
> +		if (sc->ah->ah_radio_5ghz_revision &&
> +			!sc->ah->ah_radio_2ghz_revision) {
> +			/* No 5GHz support -> report 2GHz radio */
> +			if (!test_bit(AR5K_MODE_11A,
> +				sc->ah->ah_capabilities.cap_mode)) {
> +				ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
> +					ath5k_chip_name(AR5K_VERSION_RAD,
> +						sc->ah->ah_radio_5ghz_revision),
> +						sc->ah->ah_radio_5ghz_revision);
> +			/* No 2GHz support (5110 and some
> +			 * 5Ghz only cards) -> report 5Ghz radio */
> +			} else if (!test_bit(AR5K_MODE_11B,
> +				sc->ah->ah_capabilities.cap_mode)) {
> +				ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
> +					ath5k_chip_name(AR5K_VERSION_RAD,
> +						sc->ah->ah_radio_5ghz_revision),
> +						sc->ah->ah_radio_5ghz_revision);
> +			/* Multiband radio */
> +			} else {
> +				ATH5K_INFO(sc, "RF%s multiband radio found"
> +					" (0x%x)\n",
> +					ath5k_chip_name(AR5K_VERSION_RAD,
> +						sc->ah->ah_radio_5ghz_revision),
> +						sc->ah->ah_radio_5ghz_revision);
> +			}
> +		}
> +		/* Multi chip radio (RF5111 - RF2111) ->
> +		 * report both 2GHz/5GHz radios */
> +		else if (sc->ah->ah_radio_5ghz_revision &&
> +				sc->ah->ah_radio_2ghz_revision){
> +			ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
> +				ath5k_chip_name(AR5K_VERSION_RAD,
> +					sc->ah->ah_radio_5ghz_revision),
> +					sc->ah->ah_radio_5ghz_revision);
> +			ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
> +				ath5k_chip_name(AR5K_VERSION_RAD,
> +					sc->ah->ah_radio_2ghz_revision),
> +					sc->ah->ah_radio_2ghz_revision);
> +		}
> +	}
> +
> 
> -	survey->channel = conf->channel;
> -	survey->filled = SURVEY_INFO_NOISE_DBM;
> -	survey->noise = sc->ah->ah_noise_floor;
> +	/* ready to process interrupts */
> +	__clear_bit(ATH_STAT_INVALID, sc->status);
> 
>  	return 0;
> +err_ah:
> +	ath5k_hw_detach(sc->ah);
> +err_free_ah:
> +	kfree(sc->ah);
> +err_irq:
> +	free_irq(pdev->irq, sc);
> +err_free:
> +	ieee80211_free_hw(hw);
> +err_map:
> +	pci_iounmap(pdev, mem);
> +err_reg:
> +	pci_release_region(pdev, 0);
> +err_dis:
> +	pci_disable_device(pdev);
> +err:
> +	return ret;
>  }
> 
> -static u64
> -ath5k_get_tsf(struct ieee80211_hw *hw)
> +static void __devexit
> +ath5k_pci_remove(struct pci_dev *pdev)
>  {
> -	struct ath5k_softc *sc = hw->priv;
> +	struct ath5k_softc *sc = pci_get_drvdata(pdev);
> 
> -	return ath5k_hw_get_tsf64(sc->ah);
> +	ath5k_debug_finish_device(sc);
> +	ath5k_detach(pdev, sc->hw);
> +	ath5k_hw_detach(sc->ah);
> +	kfree(sc->ah);
> +	free_irq(pdev->irq, sc);
> +	pci_iounmap(pdev, sc->iobase);
> +	pci_release_region(pdev, 0);
> +	pci_disable_device(pdev);
> +	ieee80211_free_hw(sc->hw);
>  }
> 
> -static void
> -ath5k_set_tsf(struct ieee80211_hw *hw, u64 tsf)
> +#ifdef CONFIG_PM_SLEEP
> +static int ath5k_pci_suspend(struct device *dev)
>  {
> -	struct ath5k_softc *sc = hw->priv;
> +	struct ath5k_softc *sc = pci_get_drvdata(to_pci_dev(dev));
> 
> -	ath5k_hw_set_tsf64(sc->ah, tsf);
> +	ath5k_led_off(sc);
> +	return 0;
>  }
> 
> -static void
> -ath5k_reset_tsf(struct ieee80211_hw *hw)
> +static int ath5k_pci_resume(struct device *dev)
>  {
> -	struct ath5k_softc *sc = hw->priv;
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct ath5k_softc *sc = pci_get_drvdata(pdev);
> 
>  	/*
> -	 * in IBSS mode we need to update the beacon timers too.
> -	 * this will also reset the TSF if we call it with 0
> +	 * Suspend/Resume resets the PCI configuration space, so we have to
> +	 * re-disable the RETRY_TIMEOUT register (0x41) to keep
> +	 * PCI Tx retries from interfering with C3 CPU state
>  	 */
> -	if (sc->opmode == NL80211_IFTYPE_ADHOC)
> -		ath5k_beacon_update_timers(sc, 0);
> -	else
> -		ath5k_hw_reset_tsf(sc->ah);
> +	pci_write_config_byte(pdev, 0x41, 0);
> +
> +	ath5k_led_enable(sc);
> +	return 0;
>  }
> 
> +static SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend,
> ath5k_pci_resume); +#define ATH5K_PM_OPS	(&ath5k_pm_ops)
> +#else
> +#define ATH5K_PM_OPS	NULL
> +#endif /* CONFIG_PM_SLEEP */
> +
> +static struct pci_driver ath5k_pci_driver = {
> +	.name		= KBUILD_MODNAME,
> +	.id_table	= ath5k_pci_id_table,
> +	.probe		= ath5k_pci_probe,
> +	.remove		= __devexit_p(ath5k_pci_remove),
> +	.driver.pm	= ATH5K_PM_OPS,
> +};
> +
>  /*
> - * Updates the beacon that is sent by ath5k_beacon_send.  For adhoc,
> - * this is called only once at config_bss time, for AP we do it every
> - * SWBA interrupt so that the TIM will reflect buffered frames.
> - *
> - * Called with the beacon lock.
> + * Module init/exit functions
>   */
> -static int
> -ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
> +static int __init
> +init_ath5k_pci(void)
>  {
>  	int ret;
> -	struct ath5k_softc *sc = hw->priv;
> -	struct sk_buff *skb;
> -
> -	if (WARN_ON(!vif)) {
> -		ret = -EINVAL;
> -		goto out;
> -	}
> -
> -	skb = ieee80211_beacon_get(hw, vif);
> -
> -	if (!skb) {
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> -
> -	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
> -
> -	ath5k_txbuf_free_skb(sc, sc->bbuf);
> -	sc->bbuf->skb = skb;
> -	ret = ath5k_beacon_setup(sc, sc->bbuf);
> -	if (ret)
> -		sc->bbuf->skb = NULL;
> -out:
> -	return ret;
> -}
> -
> -static void
> -set_beacon_filter(struct ieee80211_hw *hw, bool enable)
> -{
> -	struct ath5k_softc *sc = hw->priv;
> -	struct ath5k_hw *ah = sc->ah;
> -	u32 rfilt;
> -	rfilt = ath5k_hw_get_rx_filter(ah);
> -	if (enable)
> -		rfilt |= AR5K_RX_FILTER_BEACON;
> -	else
> -		rfilt &= ~AR5K_RX_FILTER_BEACON;
> -	ath5k_hw_set_rx_filter(ah, rfilt);
> -	sc->filter_flags = rfilt;
> -}
> -
> -static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
> -				    struct ieee80211_vif *vif,
> -				    struct ieee80211_bss_conf *bss_conf,
> -				    u32 changes)
> -{
> -	struct ath5k_softc *sc = hw->priv;
> -	struct ath5k_hw *ah = sc->ah;
> -	struct ath_common *common = ath5k_hw_common(ah);
> -	unsigned long flags;
> -
> -	mutex_lock(&sc->lock);
> -	if (WARN_ON(sc->vif != vif))
> -		goto unlock;
> -
> -	if (changes & BSS_CHANGED_BSSID) {
> -		/* Cache for later use during resets */
> -		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
> -		common->curaid = 0;
> -		ath5k_hw_set_bssid(ah);
> -		mmiowb();
> -	}
> -
> -	if (changes & BSS_CHANGED_BEACON_INT)
> -		sc->bintval = bss_conf->beacon_int;
> 
> -	if (changes & BSS_CHANGED_ASSOC) {
> -		sc->assoc = bss_conf->assoc;
> -		if (sc->opmode == NL80211_IFTYPE_STATION)
> -			set_beacon_filter(hw, sc->assoc);
> -		ath5k_hw_set_ledstate(sc->ah, sc->assoc ?
> -			AR5K_LED_ASSOC : AR5K_LED_INIT);
> -		if (bss_conf->assoc) {
> -			ATH5K_DBG(sc, ATH5K_DEBUG_ANY,
> -				  "Bss Info ASSOC %d, bssid: %pM\n",
> -				  bss_conf->aid, common->curbssid);
> -			common->curaid = bss_conf->aid;
> -			ath5k_hw_set_bssid(ah);
> -			/* Once ANI is available you would start it here */
> -		}
> -	}
> +	ath5k_debug_init();
> 
> -	if (changes & BSS_CHANGED_BEACON) {
> -		spin_lock_irqsave(&sc->block, flags);
> -		ath5k_beacon_update(hw, vif);
> -		spin_unlock_irqrestore(&sc->block, flags);
> +	ret = pci_register_driver(&ath5k_pci_driver);
> +	if (ret) {
> +		printk(KERN_ERR "ath5k_pci: can't register pci driver\n");
> +		return ret;
>  	}
> 
> -	if (changes & BSS_CHANGED_BEACON_ENABLED)
> -		sc->enable_beacon = bss_conf->enable_beacon;
> -
> -	if (changes & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_ENABLED |
> -		       BSS_CHANGED_BEACON_INT))
> -		ath5k_beacon_config(sc);
> -
> - unlock:
> -	mutex_unlock(&sc->lock);
> +	return 0;
>  }
> 
> -static void ath5k_sw_scan_start(struct ieee80211_hw *hw)
> +static void __exit
> +exit_ath5k_pci(void)
>  {
> -	struct ath5k_softc *sc = hw->priv;
> -	if (!sc->assoc)
> -		ath5k_hw_set_ledstate(sc->ah, AR5K_LED_SCAN);
> -}
> +	pci_unregister_driver(&ath5k_pci_driver);
> 
> -static void ath5k_sw_scan_complete(struct ieee80211_hw *hw)
> -{
> -	struct ath5k_softc *sc = hw->priv;
> -	ath5k_hw_set_ledstate(sc->ah, sc->assoc ?
> -		AR5K_LED_ASSOC : AR5K_LED_INIT);
> +	ath5k_debug_finish();
>  }
> 
> -/**
> - * ath5k_set_coverage_class - Set IEEE 802.11 coverage class
> - *
> - * @hw: struct ieee80211_hw pointer
> - * @coverage_class: IEEE 802.11 coverage class number
> - *
> - * Mac80211 callback. Sets slot time, ACK timeout and CTS timeout for
> given - * coverage class. The values are persistent, they are restored
> after device - * reset.
> - */
> -static void ath5k_set_coverage_class(struct ieee80211_hw *hw, u8
> coverage_class) -{
> -	struct ath5k_softc *sc = hw->priv;
> -
> -	mutex_lock(&sc->lock);
> -	ath5k_hw_set_coverage_class(sc->ah, coverage_class);
> -	mutex_unlock(&sc->lock);
> -}
> +module_init(init_ath5k_pci);
> +module_exit(exit_ath5k_pci);
