Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:35605 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751047Ab0JHDii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 23:38:38 -0400
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0841919115
	for <linux-wireless@vger.kernel.org>; Fri,  8 Oct 2010 12:38:36 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Jonathan Guerin <jonathan@guerin.id.au>
Subject: Re: [ath5k-devel] Kernel panic
Date: Fri, 8 Oct 2010 12:38:40 +0900
Cc: ath5k-devel@lists.ath5k.org,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <AANLkTinsyUx6ev1UZhVV0FY5pO2wHk9R+TGHziR5rUET@mail.gmail.com> <AANLkTik9aUWu8T4Y7OgpPnTgZEtm3bGQ=Jn2RWx-YNHE@mail.gmail.com> <AANLkTimYvHy8XFkHNFLdLmReY2bvTbTgA2oTeQ4uDByR@mail.gmail.com>
In-Reply-To: <AANLkTimYvHy8XFkHNFLdLmReY2bvTbTgA2oTeQ4uDByR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010081238.40348.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri October 8 2010 12:32:26 Jonathan Guerin wrote:
> I've just looked for changes in ath5k which were submitted after
> 2.6.35 was released and found this patch. I won't pretend to
> understand what's been changed, but could it be causing the panics I'm
> observing?

unless we messed up somewhere, this patch should not have any effect, except 
for reordering code. the generated object file should be the same.

bruno
 
> Thanks,
> 
> Jonathan Guerin
> 
> On Fri, Sep 17, 2010 at 1:45 PM, Bruno Randolf <br1@einfach.org> wrote:
> > From: Bob Copeland <me@bobcopeland.com>
> > 
> > This change reorganizes the main ath5k file in order to re-group
> > related functions and remove most of the forward declarations
> > (from 61 down to 3).  This is, unfortunately, a lot of churn, but
> > there should be no functional changes.
> > 
> > Signed-off-by: Bob Copeland <me@bobcopeland.com>
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> > 
> > ---
> > Bruno: rebased to wireless-next
> > v2: resent because i lost the subject line before
> > ---
> > 
> >  drivers/net/wireless/ath/ath5k/base.c | 1662
> >  +++++++++++++++------------------ 1 files changed, 764 insertions(+),
> >  898 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath5k/base.c
> > b/drivers/net/wireless/ath/ath5k/base.c index f8c699d..9e4636f 100644
> > --- a/drivers/net/wireless/ath/ath5k/base.c
> > +++ b/drivers/net/wireless/ath/ath5k/base.c
> > @@ -70,11 +70,6 @@ static int modparam_all_channels;
> > 
> >  module_param_named(all_channels, modparam_all_channels, bool, S_IRUGO);
> >  MODULE_PARM_DESC(all_channels, "Expose all channels the device can
> >  use.");
> > 
> > -
> > -/******************\
> > -* Internal defines *
> > -\******************/
> > -
> > 
> >  /* Module info */
> >  MODULE_AUTHOR("Jiri Slaby");
> >  MODULE_AUTHOR("Nick Kossifidis");
> > 
> > @@ -83,6 +78,10 @@ MODULE_SUPPORTED_DEVICE("Atheros 5xxx WLAN cards");
> > 
> >  MODULE_LICENSE("Dual BSD/GPL");
> >  MODULE_VERSION("0.6.0 (EXPERIMENTAL)");
> > 
> > +static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel
> > *chan); +static int ath5k_beacon_update(struct ieee80211_hw *hw,
> > +               struct ieee80211_vif *vif);
> > +static void ath5k_beacon_update_timers(struct ath5k_softc *sc, u64
> > bc_tsf);
> > 
> >  /* Known PCI ids */
> >  static DEFINE_PCI_DEVICE_TABLE(ath5k_pci_id_table) = {
> > 
> > @@ -190,129 +189,6 @@ static const struct ieee80211_rate ath5k_rates[] =
> > {
> > 
> >        /* XR missing */
> >  
> >  };
> > 
> > -/*
> > - * Prototypes - PCI stack related functions
> > - */
> > -static int __devinit   ath5k_pci_probe(struct pci_dev *pdev,
> > -                               const struct pci_device_id *id);
> > -static void __devexit  ath5k_pci_remove(struct pci_dev *pdev);
> > -#ifdef CONFIG_PM_SLEEP
> > -static int             ath5k_pci_suspend(struct device *dev);
> > -static int             ath5k_pci_resume(struct device *dev);
> > -
> > -static SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend,
> > ath5k_pci_resume); -#define ATH5K_PM_OPS   (&ath5k_pm_ops)
> > -#else
> > -#define ATH5K_PM_OPS   NULL
> > -#endif /* CONFIG_PM_SLEEP */
> > -
> > -static struct pci_driver ath5k_pci_driver = {
> > -       .name           = KBUILD_MODNAME,
> > -       .id_table       = ath5k_pci_id_table,
> > -       .probe          = ath5k_pci_probe,
> > -       .remove         = __devexit_p(ath5k_pci_remove),
> > -       .driver.pm      = ATH5K_PM_OPS,
> > -};
> > -
> > -
> > -
> > -/*
> > - * Prototypes - MAC 802.11 stack related functions
> > - */
> > -static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
> > -static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
> > -               struct ath5k_txq *txq);
> > -static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel
> > *chan); -static int ath5k_start(struct ieee80211_hw *hw);
> > -static void ath5k_stop(struct ieee80211_hw *hw);
> > -static int ath5k_add_interface(struct ieee80211_hw *hw,
> > -               struct ieee80211_vif *vif);
> > -static void ath5k_remove_interface(struct ieee80211_hw *hw,
> > -               struct ieee80211_vif *vif);
> > -static int ath5k_config(struct ieee80211_hw *hw, u32 changed);
> > -static u64 ath5k_prepare_multicast(struct ieee80211_hw *hw,
> > -                                  struct netdev_hw_addr_list *mc_list);
> > -static void ath5k_configure_filter(struct ieee80211_hw *hw,
> > -               unsigned int changed_flags,
> > -               unsigned int *new_flags,
> > -               u64 multicast);
> > -static int ath5k_set_key(struct ieee80211_hw *hw,
> > -               enum set_key_cmd cmd,
> > -               struct ieee80211_vif *vif, struct ieee80211_sta *sta,
> > -               struct ieee80211_key_conf *key);
> > -static int ath5k_get_stats(struct ieee80211_hw *hw,
> > -               struct ieee80211_low_level_stats *stats);
> > -static int ath5k_get_survey(struct ieee80211_hw *hw,
> > -               int idx, struct survey_info *survey);
> > -static u64 ath5k_get_tsf(struct ieee80211_hw *hw);
> > -static void ath5k_set_tsf(struct ieee80211_hw *hw, u64 tsf);
> > -static void ath5k_reset_tsf(struct ieee80211_hw *hw);
> > -static int ath5k_beacon_update(struct ieee80211_hw *hw,
> > -               struct ieee80211_vif *vif);
> > -static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
> > -               struct ieee80211_vif *vif,
> > -               struct ieee80211_bss_conf *bss_conf,
> > -               u32 changes);
> > -static void ath5k_sw_scan_start(struct ieee80211_hw *hw);
> > -static void ath5k_sw_scan_complete(struct ieee80211_hw *hw);
> > -static void ath5k_set_coverage_class(struct ieee80211_hw *hw,
> > -               u8 coverage_class);
> > -
> > -static const struct ieee80211_ops ath5k_hw_ops = {
> > -       .tx             = ath5k_tx,
> > -       .start          = ath5k_start,
> > -       .stop           = ath5k_stop,
> > -       .add_interface  = ath5k_add_interface,
> > -       .remove_interface = ath5k_remove_interface,
> > -       .config         = ath5k_config,
> > -       .prepare_multicast = ath5k_prepare_multicast,
> > -       .configure_filter = ath5k_configure_filter,
> > -       .set_key        = ath5k_set_key,
> > -       .get_stats      = ath5k_get_stats,
> > -       .get_survey     = ath5k_get_survey,
> > -       .conf_tx        = NULL,
> > -       .get_tsf        = ath5k_get_tsf,
> > -       .set_tsf        = ath5k_set_tsf,
> > -       .reset_tsf      = ath5k_reset_tsf,
> > -       .bss_info_changed = ath5k_bss_info_changed,
> > -       .sw_scan_start  = ath5k_sw_scan_start,
> > -       .sw_scan_complete = ath5k_sw_scan_complete,
> > -       .set_coverage_class = ath5k_set_coverage_class,
> > -};
> > -
> > -/*
> > - * Prototypes - Internal functions
> > - */
> > -/* Attach detach */
> > -static int     ath5k_attach(struct pci_dev *pdev,
> > -                       struct ieee80211_hw *hw);
> > -static void    ath5k_detach(struct pci_dev *pdev,
> > -                       struct ieee80211_hw *hw);
> > -/* Channel/mode setup */
> > -static inline short ath5k_ieee2mhz(short chan);
> > -static unsigned int ath5k_copy_channels(struct ath5k_hw *ah,
> > -                               struct ieee80211_channel *channels,
> > -                               unsigned int mode,
> > -                               unsigned int max);
> > -static int     ath5k_setup_bands(struct ieee80211_hw *hw);
> > -static int     ath5k_chan_set(struct ath5k_softc *sc,
> > -                               struct ieee80211_channel *chan);
> > -static void    ath5k_setcurmode(struct ath5k_softc *sc,
> > -                               unsigned int mode);
> > -static void    ath5k_mode_setup(struct ath5k_softc *sc);
> > -
> > -/* Descriptor setup */
> > -static int     ath5k_desc_alloc(struct ath5k_softc *sc,
> > -                               struct pci_dev *pdev);
> > -static void    ath5k_desc_free(struct ath5k_softc *sc,
> > -                               struct pci_dev *pdev);
> > -/* Buffers setup */
> > -static int     ath5k_rxbuf_setup(struct ath5k_softc *sc,
> > -                               struct ath5k_buf *bf);
> > -static int     ath5k_txbuf_setup(struct ath5k_softc *sc,
> > -                               struct ath5k_buf *bf,
> > -                               struct ath5k_txq *txq, int padsize);
> > -
> > 
> >  static inline void ath5k_txbuf_free_skb(struct ath5k_softc *sc,
> >  
> >                                struct ath5k_buf *bf)
> >  
> >  {
> > 
> > @@ -345,35 +221,6 @@ static inline void ath5k_rxbuf_free_skb(struct
> > ath5k_softc *sc,
> > 
> >  }
> > 
> > -/* Queues setup */
> > -static struct  ath5k_txq *ath5k_txq_setup(struct ath5k_softc *sc,
> > -                               int qtype, int subtype);
> > -static int     ath5k_beaconq_setup(struct ath5k_hw *ah);
> > -static int     ath5k_beaconq_config(struct ath5k_softc *sc);
> > -static void    ath5k_txq_drainq(struct ath5k_softc *sc,
> > -                               struct ath5k_txq *txq);
> > -static void    ath5k_txq_cleanup(struct ath5k_softc *sc);
> > -static void    ath5k_txq_release(struct ath5k_softc *sc);
> > -/* Rx handling */
> > -static int     ath5k_rx_start(struct ath5k_softc *sc);
> > -static void    ath5k_rx_stop(struct ath5k_softc *sc);
> > -static unsigned int ath5k_rx_decrypted(struct ath5k_softc *sc,
> > -                                       struct sk_buff *skb,
> > -                                       struct ath5k_rx_status *rs);
> > -static void    ath5k_tasklet_rx(unsigned long data);
> > -/* Tx handling */
> > -static void    ath5k_tx_processq(struct ath5k_softc *sc,
> > -                               struct ath5k_txq *txq);
> > -static void    ath5k_tasklet_tx(unsigned long data);
> > -/* Beacon handling */
> > -static int     ath5k_beacon_setup(struct ath5k_softc *sc,
> > -                                       struct ath5k_buf *bf);
> > -static void    ath5k_beacon_send(struct ath5k_softc *sc);
> > -static void    ath5k_beacon_config(struct ath5k_softc *sc);
> > -static void    ath5k_beacon_update_timers(struct ath5k_softc *sc, u64
> > bc_tsf); -static void    ath5k_tasklet_beacon(unsigned long data);
> > -static void    ath5k_tasklet_ani(unsigned long data);
> > -
> > 
> >  static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
> >  {
> >  
> >        u64 tsf = ath5k_hw_get_tsf64(ah);
> > 
> > @@ -384,50 +231,6 @@ static inline u64 ath5k_extend_tsf(struct ath5k_hw
> > *ah, u32 rstamp)
> > 
> >        return (tsf & ~0x7fff) | rstamp;
> >  
> >  }
> > 
> > -/* Interrupt handling */
> > -static int     ath5k_init(struct ath5k_softc *sc);
> > -static int     ath5k_stop_locked(struct ath5k_softc *sc);
> > -static int     ath5k_stop_hw(struct ath5k_softc *sc);
> > -static irqreturn_t ath5k_intr(int irq, void *dev_id);
> > -static void ath5k_reset_work(struct work_struct *work);
> > -
> > -static void    ath5k_tasklet_calibrate(unsigned long data);
> > -
> > -/*
> > - * Module init/exit functions
> > - */
> > -static int __init
> > -init_ath5k_pci(void)
> > -{
> > -       int ret;
> > -
> > -       ath5k_debug_init();
> > -
> > -       ret = pci_register_driver(&ath5k_pci_driver);
> > -       if (ret) {
> > -               printk(KERN_ERR "ath5k_pci: can't register pci
> > driver\n"); -               return ret;
> > -       }
> > -
> > -       return 0;
> > -}
> > -
> > -static void __exit
> > -exit_ath5k_pci(void)
> > -{
> > -       pci_unregister_driver(&ath5k_pci_driver);
> > -
> > -       ath5k_debug_finish();
> > -}
> > -
> > -module_init(init_ath5k_pci);
> > -module_exit(exit_ath5k_pci);
> > -
> > -
> > -/********************\
> > -* PCI Initialization *
> > -\********************/
> > -
> > 
> >  static const char *
> >  ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val)
> >  {
> > 
> > @@ -466,299 +269,6 @@ static const struct ath_ops ath5k_common_ops = {
> > 
> >        .write = ath5k_iowrite32,
> >  
> >  };
> > 
> > -static int __devinit
> > -ath5k_pci_probe(struct pci_dev *pdev,
> > -               const struct pci_device_id *id)
> > -{
> > -       void __iomem *mem;
> > -       struct ath5k_softc *sc;
> > -       struct ath_common *common;
> > -       struct ieee80211_hw *hw;
> > -       int ret;
> > -       u8 csz;
> > -
> > -       /*
> > -        * L0s needs to be disabled on all ath5k cards.
> > -        *
> > -        * For distributions shipping with CONFIG_PCIEASPM (this will be
> > enabled -        * by default in the future in 2.6.36) this will also
> > mean both L1 and -        * L0s will be disabled when a pre 1.1 PCIe
> > device is detected. We do -        * know L1 works correctly even for
> > all ath5k pre 1.1 PCIe devices -        * though but cannot currently
> > undue the effect of a blacklist, for -        * details you can read
> > pcie_aspm_sanity_check() and see how it adjusts -        * the device
> > link capability.
> > -        *
> > -        * It may be possible in the future to implement some PCI API to
> > allow -        * drivers to override blacklists for pre 1.1 PCIe but for
> > now it is -        * best to accept that both L0s and L1 will be
> > disabled completely for -        * distributions shipping with
> > CONFIG_PCIEASPM rather than having this -        * issue present.
> > Motivation for adding this new API will be to help -        * with power
> > consumption for some of these devices.
> > -        */
> > -       pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
> > -
> > -       ret = pci_enable_device(pdev);
> > -       if (ret) {
> > -               dev_err(&pdev->dev, "can't enable device\n");
> > -               goto err;
> > -       }
> > -
> > -       /* XXX 32-bit addressing only */
> > -       ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> > -       if (ret) {
> > -               dev_err(&pdev->dev, "32-bit DMA not available\n");
> > -               goto err_dis;
> > -       }
> > -
> > -       /*
> > -        * Cache line size is used to size and align various
> > -        * structures used to communicate with the hardware.
> > -        */
> > -       pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &csz);
> > -       if (csz == 0) {
> > -               /*
> > -                * Linux 2.4.18 (at least) writes the cache line size
> > -                * register as a 16-bit wide register which is wrong.
> > -                * We must have this setup properly for rx buffer
> > -                * DMA to work so force a reasonable value here if it
> > -                * comes up zero.
> > -                */
> > -               csz = L1_CACHE_BYTES >> 2;
> > -               pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, csz);
> > -       }
> > -       /*
> > -        * The default setting of latency timer yields poor results,
> > -        * set it to the value used by other systems.  It may be worth
> > -        * tweaking this setting more.
> > -        */
> > -       pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0xa8);
> > -
> > -       /* Enable bus mastering */
> > -       pci_set_master(pdev);
> > -
> > -       /*
> > -        * Disable the RETRY_TIMEOUT register (0x41) to keep
> > -        * PCI Tx retries from interfering with C3 CPU state.
> > -        */
> > -       pci_write_config_byte(pdev, 0x41, 0);
> > -
> > -       ret = pci_request_region(pdev, 0, "ath5k");
> > -       if (ret) {
> > -               dev_err(&pdev->dev, "cannot reserve PCI memory
> > region\n"); -               goto err_dis;
> > -       }
> > -
> > -       mem = pci_iomap(pdev, 0, 0);
> > -       if (!mem) {
> > -               dev_err(&pdev->dev, "cannot remap PCI memory region\n") ;
> > -               ret = -EIO;
> > -               goto err_reg;
> > -       }
> > -
> > -       /*
> > -        * Allocate hw (mac80211 main struct)
> > -        * and hw->priv (driver private data)
> > -        */
> > -       hw = ieee80211_alloc_hw(sizeof(*sc), &ath5k_hw_ops);
> > -       if (hw == NULL) {
> > -               dev_err(&pdev->dev, "cannot allocate ieee80211_hw\n");
> > -               ret = -ENOMEM;
> > -               goto err_map;
> > -       }
> > -
> > -       dev_info(&pdev->dev, "registered as '%s'\n",
> > wiphy_name(hw->wiphy)); -
> > -       /* Initialize driver private data */
> > -       SET_IEEE80211_DEV(hw, &pdev->dev);
> > -       hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
> > -                   IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
> > -                   IEEE80211_HW_SIGNAL_DBM;
> > -
> > -       hw->wiphy->interface_modes =
> > -               BIT(NL80211_IFTYPE_AP) |
> > -               BIT(NL80211_IFTYPE_STATION) |
> > -               BIT(NL80211_IFTYPE_ADHOC) |
> > -               BIT(NL80211_IFTYPE_MESH_POINT);
> > -
> > -       hw->extra_tx_headroom = 2;
> > -       hw->channel_change_time = 5000;
> > -       sc = hw->priv;
> > -       sc->hw = hw;
> > -       sc->pdev = pdev;
> > -
> > -       ath5k_debug_init_device(sc);
> > -
> > -       /*
> > -        * Mark the device as detached to avoid processing
> > -        * interrupts until setup is complete.
> > -        */
> > -       __set_bit(ATH_STAT_INVALID, sc->status);
> > -
> > -       sc->iobase = mem; /* So we can unmap it on detach */
> > -       sc->opmode = NL80211_IFTYPE_STATION;
> > -       sc->bintval = 1000;
> > -       mutex_init(&sc->lock);
> > -       spin_lock_init(&sc->rxbuflock);
> > -       spin_lock_init(&sc->txbuflock);
> > -       spin_lock_init(&sc->block);
> > -
> > -       /* Set private data */
> > -       pci_set_drvdata(pdev, sc);
> > -
> > -       /* Setup interrupt handler */
> > -       ret = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
> > -       if (ret) {
> > -               ATH5K_ERR(sc, "request_irq failed\n");
> > -               goto err_free;
> > -       }
> > -
> > -       /* If we passed the test, malloc an ath5k_hw struct */
> > -       sc->ah = kzalloc(sizeof(struct ath5k_hw), GFP_KERNEL);
> > -       if (!sc->ah) {
> > -               ret = -ENOMEM;
> > -               ATH5K_ERR(sc, "out of memory\n");
> > -               goto err_irq;
> > -       }
> > -
> > -       sc->ah->ah_sc = sc;
> > -       sc->ah->ah_iobase = sc->iobase;
> > -       common = ath5k_hw_common(sc->ah);
> > -       common->ops = &ath5k_common_ops;
> > -       common->ah = sc->ah;
> > -       common->hw = hw;
> > -       common->cachelsz = csz << 2; /* convert to bytes */
> > -
> > -       /* Initialize device */
> > -       ret = ath5k_hw_attach(sc);
> > -       if (ret) {
> > -               goto err_free_ah;
> > -       }
> > -
> > -       /* set up multi-rate retry capabilities */
> > -       if (sc->ah->ah_version == AR5K_AR5212) {
> > -               hw->max_rates = 4;
> > -               hw->max_rate_tries = 11;
> > -       }
> > -
> > -       /* Finish private driver data initialization */
> > -       ret = ath5k_attach(pdev, hw);
> > -       if (ret)
> > -               goto err_ah;
> > -
> > -       ATH5K_INFO(sc, "Atheros AR%s chip found (MAC: 0x%x, PHY:
> > 0x%x)\n", -                       ath5k_chip_name(AR5K_VERSION_MAC,
> > sc->ah->ah_mac_srev), -                                      
> > sc->ah->ah_mac_srev,
> > -                                       sc->ah->ah_phy_revision);
> > -
> > -       if (!sc->ah->ah_single_chip) {
> > -               /* Single chip radio (!RF5111) */
> > -               if (sc->ah->ah_radio_5ghz_revision &&
> > -                       !sc->ah->ah_radio_2ghz_revision) {
> > -                       /* No 5GHz support -> report 2GHz radio */
> > -                       if (!test_bit(AR5K_MODE_11A,
> > -                               sc->ah->ah_capabilities.cap_mode)) {
> > -                               ATH5K_INFO(sc, "RF%s 2GHz radio found
> > (0x%x)\n", -                                      
> > ath5k_chip_name(AR5K_VERSION_RAD, -                                     
> >          sc->ah->ah_radio_5ghz_revision), -                             
> >                  sc->ah->ah_radio_5ghz_revision); -                     
> >  /* No 2GHz support (5110 and some
> > -                        * 5Ghz only cards) -> report 5Ghz radio */
> > -                       } else if (!test_bit(AR5K_MODE_11B,
> > -                               sc->ah->ah_capabilities.cap_mode)) {
> > -                               ATH5K_INFO(sc, "RF%s 5GHz radio found
> > (0x%x)\n", -                                      
> > ath5k_chip_name(AR5K_VERSION_RAD, -                                     
> >          sc->ah->ah_radio_5ghz_revision), -                             
> >                  sc->ah->ah_radio_5ghz_revision); -                     
> >  /* Multiband radio */
> > -                       } else {
> > -                               ATH5K_INFO(sc, "RF%s multiband radio
> > found" -                                       " (0x%x)\n",
> > -                                       ath5k_chip_name(AR5K_VERSION_RAD,
> > -                                              
> > sc->ah->ah_radio_5ghz_revision), -                                      
> >         sc->ah->ah_radio_5ghz_revision); -                       }
> > -               }
> > -               /* Multi chip radio (RF5111 - RF2111) ->
> > -                * report both 2GHz/5GHz radios */
> > -               else if (sc->ah->ah_radio_5ghz_revision &&
> > -                               sc->ah->ah_radio_2ghz_revision){
> > -                       ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
> > -                               ath5k_chip_name(AR5K_VERSION_RAD,
> > -                                       sc->ah->ah_radio_5ghz_revision),
> > -                                       sc->ah->ah_radio_5ghz_revision);
> > -                       ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
> > -                               ath5k_chip_name(AR5K_VERSION_RAD,
> > -                                       sc->ah->ah_radio_2ghz_revision),
> > -                                       sc->ah->ah_radio_2ghz_revision);
> > -               }
> > -       }
> > -
> > -
> > -       /* ready to process interrupts */
> > -       __clear_bit(ATH_STAT_INVALID, sc->status);
> > -
> > -       return 0;
> > -err_ah:
> > -       ath5k_hw_detach(sc->ah);
> > -err_free_ah:
> > -       kfree(sc->ah);
> > -err_irq:
> > -       free_irq(pdev->irq, sc);
> > -err_free:
> > -       ieee80211_free_hw(hw);
> > -err_map:
> > -       pci_iounmap(pdev, mem);
> > -err_reg:
> > -       pci_release_region(pdev, 0);
> > -err_dis:
> > -       pci_disable_device(pdev);
> > -err:
> > -       return ret;
> > -}
> > -
> > -static void __devexit
> > -ath5k_pci_remove(struct pci_dev *pdev)
> > -{
> > -       struct ath5k_softc *sc = pci_get_drvdata(pdev);
> > -
> > -       ath5k_debug_finish_device(sc);
> > -       ath5k_detach(pdev, sc->hw);
> > -       ath5k_hw_detach(sc->ah);
> > -       kfree(sc->ah);
> > -       free_irq(pdev->irq, sc);
> > -       pci_iounmap(pdev, sc->iobase);
> > -       pci_release_region(pdev, 0);
> > -       pci_disable_device(pdev);
> > -       ieee80211_free_hw(sc->hw);
> > -}
> > -
> > -#ifdef CONFIG_PM_SLEEP
> > -static int ath5k_pci_suspend(struct device *dev)
> > -{
> > -       struct ath5k_softc *sc = pci_get_drvdata(to_pci_dev(dev));
> > -
> > -       ath5k_led_off(sc);
> > -       return 0;
> > -}
> > -
> > -static int ath5k_pci_resume(struct device *dev)
> > -{
> > -       struct pci_dev *pdev = to_pci_dev(dev);
> > -       struct ath5k_softc *sc = pci_get_drvdata(pdev);
> > -
> > -       /*
> > -        * Suspend/Resume resets the PCI configuration space, so we have
> > to -        * re-disable the RETRY_TIMEOUT register (0x41) to keep
> > -        * PCI Tx retries from interfering with C3 CPU state
> > -        */
> > -       pci_write_config_byte(pdev, 0x41, 0);
> > -
> > -       ath5k_led_enable(sc);
> > -       return 0;
> > -}
> > -#endif /* CONFIG_PM_SLEEP */
> > -
> > -
> > 
> >  /***********************\
> >  * Driver Initialization *
> >  \***********************/
> > 
> > @@ -772,170 +282,6 @@ static int ath5k_reg_notifier(struct wiphy *wiphy,
> > struct regulatory_request *re
> > 
> >        return ath_reg_notifier_apply(wiphy, request, regulatory);
> >  
> >  }
> > 
> > -static int
> > -ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
> > -{
> > -       struct ath5k_softc *sc = hw->priv;
> > -       struct ath5k_hw *ah = sc->ah;
> > -       struct ath_regulatory *regulatory = ath5k_hw_regulatory(ah);
> > -       u8 mac[ETH_ALEN] = {};
> > -       int ret;
> > -
> > -       ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "devid 0x%x\n", pdev->device);
> > -
> > -       /*
> > -        * Check if the MAC has multi-rate retry support.
> > -        * We do this by trying to setup a fake extended
> > -        * descriptor.  MACs that don't have support will
> > -        * return false w/o doing anything.  MACs that do
> > -        * support it will return true w/o doing anything.
> > -        */
> > -       ret = ath5k_hw_setup_mrr_tx_desc(ah, NULL, 0, 0, 0, 0, 0, 0);
> > -
> > -       if (ret < 0)
> > -               goto err;
> > -       if (ret > 0)
> > -               __set_bit(ATH_STAT_MRRETRY, sc->status);
> > -
> > -       /*
> > -        * Collect the channel list.  The 802.11 layer
> > -        * is resposible for filtering this list based
> > -        * on settings like the phy mode and regulatory
> > -        * domain restrictions.
> > -        */
> > -       ret = ath5k_setup_bands(hw);
> > -       if (ret) {
> > -               ATH5K_ERR(sc, "can't get channels\n");
> > -               goto err;
> > -       }
> > -
> > -       /* NB: setup here so ath5k_rate_update is happy */
> > -       if (test_bit(AR5K_MODE_11A, ah->ah_modes))
> > -               ath5k_setcurmode(sc, AR5K_MODE_11A);
> > -       else
> > -               ath5k_setcurmode(sc, AR5K_MODE_11B);
> > -
> > -       /*
> > -        * Allocate tx+rx descriptors and populate the lists.
> > -        */
> > -       ret = ath5k_desc_alloc(sc, pdev);
> > -       if (ret) {
> > -               ATH5K_ERR(sc, "can't allocate descriptors\n");
> > -               goto err;
> > -       }
> > -
> > -       /*
> > -        * Allocate hardware transmit queues: one queue for
> > -        * beacon frames and one data queue for each QoS
> > -        * priority.  Note that hw functions handle resetting
> > -        * these queues at the needed time.
> > -        */
> > -       ret = ath5k_beaconq_setup(ah);
> > -       if (ret < 0) {
> > -               ATH5K_ERR(sc, "can't setup a beacon xmit queue\n");
> > -               goto err_desc;
> > -       }
> > -       sc->bhalq = ret;
> > -       sc->cabq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_CAB, 0);
> > -       if (IS_ERR(sc->cabq)) {
> > -               ATH5K_ERR(sc, "can't setup cab queue\n");
> > -               ret = PTR_ERR(sc->cabq);
> > -               goto err_bhal;
> > -       }
> > -
> > -       sc->txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA,
> > AR5K_WME_AC_BK); -       if (IS_ERR(sc->txq)) {
> > -               ATH5K_ERR(sc, "can't setup xmit queue\n");
> > -               ret = PTR_ERR(sc->txq);
> > -               goto err_queues;
> > -       }
> > -
> > -       tasklet_init(&sc->rxtq, ath5k_tasklet_rx, (unsigned long)sc);
> > -       tasklet_init(&sc->txtq, ath5k_tasklet_tx, (unsigned long)sc);
> > -       tasklet_init(&sc->calib, ath5k_tasklet_calibrate, (unsigned
> > long)sc); -       tasklet_init(&sc->beacontq, ath5k_tasklet_beacon,
> > (unsigned long)sc); -       tasklet_init(&sc->ani_tasklet,
> > ath5k_tasklet_ani, (unsigned long)sc); -
> > -       INIT_WORK(&sc->reset_work, ath5k_reset_work);
> > -
> > -       ret = ath5k_eeprom_read_mac(ah, mac);
> > -       if (ret) {
> > -               ATH5K_ERR(sc, "unable to read address from EEPROM:
> > 0x%04x\n", -                       sc->pdev->device);
> > -               goto err_queues;
> > -       }
> > -
> > -       SET_IEEE80211_PERM_ADDR(hw, mac);
> > -       /* All MAC address bits matter for ACKs */
> > -       memcpy(sc->bssidmask, ath_bcast_mac, ETH_ALEN);
> > -       ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
> > -
> > -       regulatory->current_rd =
> > ah->ah_capabilities.cap_eeprom.ee_regdomain; -       ret =
> > ath_regd_init(regulatory, hw->wiphy, ath5k_reg_notifier); -       if
> > (ret) {
> > -               ATH5K_ERR(sc, "can't initialize regulatory system\n");
> > -               goto err_queues;
> > -       }
> > -
> > -       ret = ieee80211_register_hw(hw);
> > -       if (ret) {
> > -               ATH5K_ERR(sc, "can't register ieee80211 hw\n");
> > -               goto err_queues;
> > -       }
> > -
> > -       if (!ath_is_world_regd(regulatory))
> > -               regulatory_hint(hw->wiphy, regulatory->alpha2);
> > -
> > -       ath5k_init_leds(sc);
> > -
> > -       ath5k_sysfs_register(sc);
> > -
> > -       return 0;
> > -err_queues:
> > -       ath5k_txq_release(sc);
> > -err_bhal:
> > -       ath5k_hw_release_tx_queue(ah, sc->bhalq);
> > -err_desc:
> > -       ath5k_desc_free(sc, pdev);
> > -err:
> > -       return ret;
> > -}
> > -
> > -static void
> > -ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
> > -{
> > -       struct ath5k_softc *sc = hw->priv;
> > -
> > -       /*
> > -        * NB: the order of these is important:
> > -        * o call the 802.11 layer before detaching ath5k_hw to
> > -        *   ensure callbacks into the driver to delete global
> > -        *   key cache entries can be handled
> > -        * o reclaim the tx queue data structures after calling
> > -        *   the 802.11 layer as we'll get called back to reclaim
> > -        *   node state and potentially want to use them
> > -        * o to cleanup the tx queues the hal is called, so detach
> > -        *   it last
> > -        * XXX: ??? detach ath5k_hw ???
> > -        * Other than that, it's straightforward...
> > -        */
> > -       ieee80211_unregister_hw(hw);
> > -       ath5k_desc_free(sc, pdev);
> > -       ath5k_txq_release(sc);
> > -       ath5k_hw_release_tx_queue(sc->ah, sc->bhalq);
> > -       ath5k_unregister_leds(sc);
> > -
> > -       ath5k_sysfs_unregister(sc);
> > -       /*
> > -        * NB: can't reclaim these until after ieee80211_ifdetach
> > -        * returns because we'll get called back to reclaim node
> > -        * state and potentially want to use them.
> > -        */
> > -}
> > -
> > -
> > -
> > -
> > 
> >  /********************\
> >  * Channel/mode setup *
> >  \********************/
> > 
> > @@ -1494,9 +840,6 @@ ath5k_desc_free(struct ath5k_softc *sc, struct
> > pci_dev *pdev)
> > 
> >  }
> > 
> > -
> > -
> > -
> > 
> >  /**************\
> >  * Queues setup *
> >  \**************/
> > 
> > @@ -1696,8 +1039,6 @@ ath5k_txq_release(struct ath5k_softc *sc)
> > 
> >  }
> > 
> > -
> > -
> > 
> >  /*************\
> >  * RX Handling *
> >  \*************/
> > 
> > @@ -2121,6 +1462,59 @@ unlock:
> >  * TX Handling *
> >  \*************/
> > 
> > +static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
> > +                         struct ath5k_txq *txq)
> > +{
> > +       struct ath5k_softc *sc = hw->priv;
> > +       struct ath5k_buf *bf;
> > +       unsigned long flags;
> > +       int padsize;
> > +
> > +       ath5k_debug_dump_skb(sc, skb, "TX  ", 1);
> > +
> > +       /*
> > +        * The hardware expects the header padded to 4 byte boundaries.
> > +        * If this is not the case, we add the padding after the header.
> > +        */
> > +       padsize = ath5k_add_padding(skb);
> > +       if (padsize < 0) {
> > +               ATH5K_ERR(sc, "tx hdrlen not %%4: not enough"
> > +                         " headroom to pad");
> > +               goto drop_packet;
> > +       }
> > +
> > +       spin_lock_irqsave(&sc->txbuflock, flags);
> > +       if (list_empty(&sc->txbuf)) {
> > +               ATH5K_ERR(sc, "no further txbuf available, dropping
> > packet\n"); +               spin_unlock_irqrestore(&sc->txbuflock,
> > flags);
> > +               ieee80211_stop_queue(hw, skb_get_queue_mapping(skb));
> > +               goto drop_packet;
> > +       }
> > +       bf = list_first_entry(&sc->txbuf, struct ath5k_buf, list);
> > +       list_del(&bf->list);
> > +       sc->txbuf_len--;
> > +       if (list_empty(&sc->txbuf))
> > +               ieee80211_stop_queues(hw);
> > +       spin_unlock_irqrestore(&sc->txbuflock, flags);
> > +
> > +       bf->skb = skb;
> > +
> > +       if (ath5k_txbuf_setup(sc, bf, txq, padsize)) {
> > +               bf->skb = NULL;
> > +               spin_lock_irqsave(&sc->txbuflock, flags);
> > +               list_add_tail(&bf->list, &sc->txbuf);
> > +               sc->txbuf_len++;
> > +               spin_unlock_irqrestore(&sc->txbuflock, flags);
> > +               goto drop_packet;
> > +       }
> > +       return NETDEV_TX_OK;
> > +
> > +drop_packet:
> > +       dev_kfree_skb_any(skb);
> > +       return NETDEV_TX_OK;
> > +}
> > +
> > +
> > 
> >  static void
> >  ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
> >  {
> > 
> > @@ -2313,6 +1707,43 @@ err_unmap:
> >  }
> >  
> >  /*
> > 
> > + * Updates the beacon that is sent by ath5k_beacon_send.  For adhoc,
> > + * this is called only once at config_bss time, for AP we do it every
> > + * SWBA interrupt so that the TIM will reflect buffered frames.
> > + *
> > + * Called with the beacon lock.
> > + */
> > +static int
> > +ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
> > +{
> > +       int ret;
> > +       struct ath5k_softc *sc = hw->priv;
> > +       struct sk_buff *skb;
> > +
> > +       if (WARN_ON(!vif)) {
> > +               ret = -EINVAL;
> > +               goto out;
> > +       }
> > +
> > +       skb = ieee80211_beacon_get(hw, vif);
> > +
> > +       if (!skb) {
> > +               ret = -ENOMEM;
> > +               goto out;
> > +       }
> > +
> > +       ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
> > +
> > +       ath5k_txbuf_free_skb(sc, sc->bbuf);
> > +       sc->bbuf->skb = skb;
> > +       ret = ath5k_beacon_setup(sc, sc->bbuf);
> > +       if (ret)
> > +               sc->bbuf->skb = NULL;
> > +out:
> > +       return ret;
> > +}
> > +
> > +/*
> > 
> >  * Transmit a beacon frame at SWBA.  Dynamic updates to the
> >  * frame contents are done as needed and the slot time is
> >  * also adjusted based on current state.
> > 
> > @@ -2389,7 +1820,6 @@ ath5k_beacon_send(struct ath5k_softc *sc)
> > 
> >        sc->bsent++;
> >  
> >  }
> > 
> > -
> > 
> >  /**
> >  * ath5k_beacon_update_timers - update beacon timers
> >  *
> > 
> > @@ -2491,7 +1921,6 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc,
> > u64 bc_tsf)
> > 
> >                intval & AR5K_BEACON_RESET_TSF ? "AR5K_BEACON_RESET_TSF" :
> >                "");
> >  
> >  }
> > 
> > -
> > 
> >  /**
> >  * ath5k_beacon_config - Configure the beacon queues and interrupts
> >  *
> > 
> > @@ -2570,156 +1999,6 @@ static void ath5k_tasklet_beacon(unsigned long
> > data)
> > 
> >  * Interrupt handling *
> >  \********************/
> > 
> > -static int
> > -ath5k_init(struct ath5k_softc *sc)
> > -{
> > -       struct ath5k_hw *ah = sc->ah;
> > -       struct ath_common *common = ath5k_hw_common(ah);
> > -       int ret, i;
> > -
> > -       mutex_lock(&sc->lock);
> > -
> > -       ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "mode %d\n", sc->opmode);
> > -
> > -       /*
> > -        * Stop anything previously setup.  This is safe
> > -        * no matter this is the first time through or not.
> > -        */
> > -       ath5k_stop_locked(sc);
> > -
> > -       /*
> > -        * The basic interface to setting the hardware in a good
> > -        * state is ``reset''.  On return the hardware is known to
> > -        * be powered up and with interrupts disabled.  This must
> > -        * be followed by initialization of the appropriate bits
> > -        * and then setup of the interrupt mask.
> > -        */
> > -       sc->curchan = sc->hw->conf.channel;
> > -       sc->curband = &sc->sbands[sc->curchan->band];
> > -       sc->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
> > -               AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
> > -               AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_MIB;
> > -
> > -       ret = ath5k_reset(sc, NULL);
> > -       if (ret)
> > -               goto done;
> > -
> > -       ath5k_rfkill_hw_start(ah);
> > -
> > -       /*
> > -        * Reset the key cache since some parts do not reset the
> > -        * contents on initial power up or resume from suspend.
> > -        */
> > -       for (i = 0; i < common->keymax; i++)
> > -               ath_hw_keyreset(common, (u16)i);
> > -
> > -       ath5k_hw_set_ack_bitrate_high(ah, true);
> > -       ret = 0;
> > -done:
> > -       mmiowb();
> > -       mutex_unlock(&sc->lock);
> > -       return ret;
> > -}
> > -
> > -static int
> > -ath5k_stop_locked(struct ath5k_softc *sc)
> > -{
> > -       struct ath5k_hw *ah = sc->ah;
> > -
> > -       ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "invalid %u\n",
> > -                       test_bit(ATH_STAT_INVALID, sc->status));
> > -
> > -       /*
> > -        * Shutdown the hardware and driver:
> > -        *    stop output from above
> > -        *    disable interrupts
> > -        *    turn off timers
> > -        *    turn off the radio
> > -        *    clear transmit machinery
> > -        *    clear receive machinery
> > -        *    drain and release tx queues
> > -        *    reclaim beacon resources
> > -        *    power down hardware
> > -        *
> > -        * Note that some of this work is not possible if the
> > -        * hardware is gone (invalid).
> > -        */
> > -       ieee80211_stop_queues(sc->hw);
> > -
> > -       if (!test_bit(ATH_STAT_INVALID, sc->status)) {
> > -               ath5k_led_off(sc);
> > -               ath5k_hw_set_imr(ah, 0);
> > -               synchronize_irq(sc->pdev->irq);
> > -       }
> > -       ath5k_txq_cleanup(sc);
> > -       if (!test_bit(ATH_STAT_INVALID, sc->status)) {
> > -               ath5k_rx_stop(sc);
> > -               ath5k_hw_phy_disable(ah);
> > -       }
> > -
> > -       return 0;
> > -}
> > -
> > -static void stop_tasklets(struct ath5k_softc *sc)
> > -{
> > -       tasklet_kill(&sc->rxtq);
> > -       tasklet_kill(&sc->txtq);
> > -       tasklet_kill(&sc->calib);
> > -       tasklet_kill(&sc->beacontq);
> > -       tasklet_kill(&sc->ani_tasklet);
> > -}
> > -
> > -/*
> > - * Stop the device, grabbing the top-level lock to protect
> > - * against concurrent entry through ath5k_init (which can happen
> > - * if another thread does a system call and the thread doing the
> > - * stop is preempted).
> > - */
> > -static int
> > -ath5k_stop_hw(struct ath5k_softc *sc)
> > -{
> > -       int ret;
> > -
> > -       mutex_lock(&sc->lock);
> > -       ret = ath5k_stop_locked(sc);
> > -       if (ret == 0 && !test_bit(ATH_STAT_INVALID, sc->status)) {
> > -               /*
> > -                * Don't set the card in full sleep mode!
> > -                *
> > -                * a) When the device is in this state it must be
> > carefully -                * woken up or references to registers in the
> > PCI clock -                * domain may freeze the bus (and system). 
> > This varies -                * by chip and is mostly an issue with newer
> > parts -                * (madwifi sources mentioned srev >= 0x78) that
> > go to -                * sleep more quickly.
> > -                *
> > -                * b) On older chips full sleep results a weird behaviour
> > -                * during wakeup. I tested various cards with srev < 0x78
> > -                * and they don't wake up after module reload, a second
> > -                * module reload is needed to bring the card up again.
> > -                *
> > -                * Until we figure out what's going on don't enable
> > -                * full chip reset on any chip (this is what Legacy HAL
> > -                * and Sam's HAL do anyway). Instead Perform a full reset
> > -                * on the device (same as initial state after attach) and
> > -                * leave it idle (keep MAC/BB on warm reset) */
> > -               ret = ath5k_hw_on_hold(sc->ah);
> > -
> > -               ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
> > -                               "putting device to sleep\n");
> > -       }
> > -       ath5k_txbuf_free_skb(sc, sc->bbuf);
> > -
> > -       mmiowb();
> > -       mutex_unlock(&sc->lock);
> > -
> > -       stop_tasklets(sc);
> > -
> > -       ath5k_rfkill_hw_stop(sc->ah);
> > -
> > -       return ret;
> > -}
> > -
> > 
> >  static void
> >  ath5k_intr_calibration_poll(struct ath5k_hw *ah)
> >  {
> > 
> > @@ -2882,68 +2161,158 @@ ath5k_tasklet_ani(unsigned long data)
> > 
> >  }
> > 
> > -/********************\
> > -* Mac80211 functions *
> > -\********************/
> > +/*************************\
> > +* Initialization routines *
> > +\*************************/
> > 
> >  static int
> > 
> > -ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
> > +ath5k_stop_locked(struct ath5k_softc *sc)
> > 
> >  {
> > 
> > -       struct ath5k_softc *sc = hw->priv;
> > +       struct ath5k_hw *ah = sc->ah;
> > 
> > -       return ath5k_tx_queue(hw, skb, sc->txq);
> > +       ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "invalid %u\n",
> > +                       test_bit(ATH_STAT_INVALID, sc->status));
> > +
> > +       /*
> > +        * Shutdown the hardware and driver:
> > +        *    stop output from above
> > +        *    disable interrupts
> > +        *    turn off timers
> > +        *    turn off the radio
> > +        *    clear transmit machinery
> > +        *    clear receive machinery
> > +        *    drain and release tx queues
> > +        *    reclaim beacon resources
> > +        *    power down hardware
> > +        *
> > +        * Note that some of this work is not possible if the
> > +        * hardware is gone (invalid).
> > +        */
> > +       ieee80211_stop_queues(sc->hw);
> > +
> > +       if (!test_bit(ATH_STAT_INVALID, sc->status)) {
> > +               ath5k_led_off(sc);
> > +               ath5k_hw_set_imr(ah, 0);
> > +               synchronize_irq(sc->pdev->irq);
> > +       }
> > +       ath5k_txq_cleanup(sc);
> > +       if (!test_bit(ATH_STAT_INVALID, sc->status)) {
> > +               ath5k_rx_stop(sc);
> > +               ath5k_hw_phy_disable(ah);
> > +       }
> > +
> > +       return 0;
> > 
> >  }
> > 
> > -static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
> > -                         struct ath5k_txq *txq)
> > +static int
> > +ath5k_init(struct ath5k_softc *sc)
> > 
> >  {
> > 
> > -       struct ath5k_softc *sc = hw->priv;
> > -       struct ath5k_buf *bf;
> > -       unsigned long flags;
> > -       int padsize;
> > +       struct ath5k_hw *ah = sc->ah;
> > +       struct ath_common *common = ath5k_hw_common(ah);
> > +       int ret, i;
> > 
> > -       ath5k_debug_dump_skb(sc, skb, "TX  ", 1);
> > +       mutex_lock(&sc->lock);
> > +
> > +       ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "mode %d\n", sc->opmode);
> > 
> >        /*
> > 
> > -        * The hardware expects the header padded to 4 byte boundaries.
> > -        * If this is not the case, we add the padding after the header.
> > +        * Stop anything previously setup.  This is safe
> > +        * no matter this is the first time through or not.
> > 
> >         */
> > 
> > -       padsize = ath5k_add_padding(skb);
> > -       if (padsize < 0) {
> > -               ATH5K_ERR(sc, "tx hdrlen not %%4: not enough"
> > -                         " headroom to pad");
> > -               goto drop_packet;
> > -       }
> > +       ath5k_stop_locked(sc);
> > 
> > -       spin_lock_irqsave(&sc->txbuflock, flags);
> > -       if (list_empty(&sc->txbuf)) {
> > -               ATH5K_ERR(sc, "no further txbuf available, dropping
> > packet\n"); -               spin_unlock_irqrestore(&sc->txbuflock,
> > flags);
> > -               ieee80211_stop_queue(hw, skb_get_queue_mapping(skb));
> > -               goto drop_packet;
> > -       }
> > -       bf = list_first_entry(&sc->txbuf, struct ath5k_buf, list);
> > -       list_del(&bf->list);
> > -       sc->txbuf_len--;
> > -       if (list_empty(&sc->txbuf))
> > -               ieee80211_stop_queues(hw);
> > -       spin_unlock_irqrestore(&sc->txbuflock, flags);
> > +       /*
> > +        * The basic interface to setting the hardware in a good
> > +        * state is ``reset''.  On return the hardware is known to
> > +        * be powered up and with interrupts disabled.  This must
> > +        * be followed by initialization of the appropriate bits
> > +        * and then setup of the interrupt mask.
> > +        */
> > +       sc->curchan = sc->hw->conf.channel;
> > +       sc->curband = &sc->sbands[sc->curchan->band];
> > +       sc->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
> > +               AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
> > +               AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_MIB;
> > 
> > -       bf->skb = skb;
> > +       ret = ath5k_reset(sc, NULL);
> > +       if (ret)
> > +               goto done;
> > 
> > -       if (ath5k_txbuf_setup(sc, bf, txq, padsize)) {
> > -               bf->skb = NULL;
> > -               spin_lock_irqsave(&sc->txbuflock, flags);
> > -               list_add_tail(&bf->list, &sc->txbuf);
> > -               sc->txbuf_len++;
> > -               spin_unlock_irqrestore(&sc->txbuflock, flags);
> > -               goto drop_packet;
> > +       ath5k_rfkill_hw_start(ah);
> > +
> > +       /*
> > +        * Reset the key cache since some parts do not reset the
> > +        * contents on initial power up or resume from suspend.
> > +        */
> > +       for (i = 0; i < common->keymax; i++)
> > +               ath_hw_keyreset(common, (u16) i);
> > +
> > +       ath5k_hw_set_ack_bitrate_high(ah, true);
> > +       ret = 0;
> > +done:
> > +       mmiowb();
> > +       mutex_unlock(&sc->lock);
> > +       return ret;
> > +}
> > +
> > +static void stop_tasklets(struct ath5k_softc *sc)
> > +{
> > +       tasklet_kill(&sc->rxtq);
> > +       tasklet_kill(&sc->txtq);
> > +       tasklet_kill(&sc->calib);
> > +       tasklet_kill(&sc->beacontq);
> > +       tasklet_kill(&sc->ani_tasklet);
> > +}
> > +
> > +/*
> > + * Stop the device, grabbing the top-level lock to protect
> > + * against concurrent entry through ath5k_init (which can happen
> > + * if another thread does a system call and the thread doing the
> > + * stop is preempted).
> > + */
> > +static int
> > +ath5k_stop_hw(struct ath5k_softc *sc)
> > +{
> > +       int ret;
> > +
> > +       mutex_lock(&sc->lock);
> > +       ret = ath5k_stop_locked(sc);
> > +       if (ret == 0 && !test_bit(ATH_STAT_INVALID, sc->status)) {
> > +               /*
> > +                * Don't set the card in full sleep mode!
> > +                *
> > +                * a) When the device is in this state it must be
> > carefully +                * woken up or references to registers in the
> > PCI clock +                * domain may freeze the bus (and system). 
> > This varies +                * by chip and is mostly an issue with newer
> > parts +                * (madwifi sources mentioned srev >= 0x78) that
> > go to +                * sleep more quickly.
> > +                *
> > +                * b) On older chips full sleep results a weird behaviour
> > +                * during wakeup. I tested various cards with srev < 0x78
> > +                * and they don't wake up after module reload, a second
> > +                * module reload is needed to bring the card up again.
> > +                *
> > +                * Until we figure out what's going on don't enable
> > +                * full chip reset on any chip (this is what Legacy HAL
> > +                * and Sam's HAL do anyway). Instead Perform a full reset
> > +                * on the device (same as initial state after attach) and
> > +                * leave it idle (keep MAC/BB on warm reset) */
> > +               ret = ath5k_hw_on_hold(sc->ah);
> > +
> > +               ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
> > +                               "putting device to sleep\n");
> > 
> >        }
> > 
> > -       return NETDEV_TX_OK;
> > +       ath5k_txbuf_free_skb(sc, sc->bbuf);
> > 
> > -drop_packet:
> > -       dev_kfree_skb_any(skb);
> > -       return NETDEV_TX_OK;
> > +       mmiowb();
> > +       mutex_unlock(&sc->lock);
> > +
> > +       stop_tasklets(sc);
> > +
> > +       ath5k_rfkill_hw_stop(sc->ah);
> > +
> > +       return ret;
> > 
> >  }
> >  
> >  /*
> > 
> > @@ -3020,6 +2389,179 @@ static void ath5k_reset_work(struct work_struct
> > *work)
> > 
> >        mutex_unlock(&sc->lock);
> >  
> >  }
> > 
> > +static int
> > +ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
> > +{
> > +       struct ath5k_softc *sc = hw->priv;
> > +       struct ath5k_hw *ah = sc->ah;
> > +       struct ath_regulatory *regulatory = ath5k_hw_regulatory(ah);
> > +       u8 mac[ETH_ALEN] = {};
> > +       int ret;
> > +
> > +       ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "devid 0x%x\n", pdev->device);
> > +
> > +       /*
> > +        * Check if the MAC has multi-rate retry support.
> > +        * We do this by trying to setup a fake extended
> > +        * descriptor.  MACs that don't have support will
> > +        * return false w/o doing anything.  MACs that do
> > +        * support it will return true w/o doing anything.
> > +        */
> > +       ret = ath5k_hw_setup_mrr_tx_desc(ah, NULL, 0, 0, 0, 0, 0, 0);
> > +
> > +       if (ret < 0)
> > +               goto err;
> > +       if (ret > 0)
> > +               __set_bit(ATH_STAT_MRRETRY, sc->status);
> > +
> > +       /*
> > +        * Collect the channel list.  The 802.11 layer
> > +        * is resposible for filtering this list based
> > +        * on settings like the phy mode and regulatory
> > +        * domain restrictions.
> > +        */
> > +       ret = ath5k_setup_bands(hw);
> > +       if (ret) {
> > +               ATH5K_ERR(sc, "can't get channels\n");
> > +               goto err;
> > +       }
> > +
> > +       /* NB: setup here so ath5k_rate_update is happy */
> > +       if (test_bit(AR5K_MODE_11A, ah->ah_modes))
> > +               ath5k_setcurmode(sc, AR5K_MODE_11A);
> > +       else
> > +               ath5k_setcurmode(sc, AR5K_MODE_11B);
> > +
> > +       /*
> > +        * Allocate tx+rx descriptors and populate the lists.
> > +        */
> > +       ret = ath5k_desc_alloc(sc, pdev);
> > +       if (ret) {
> > +               ATH5K_ERR(sc, "can't allocate descriptors\n");
> > +               goto err;
> > +       }
> > +
> > +       /*
> > +        * Allocate hardware transmit queues: one queue for
> > +        * beacon frames and one data queue for each QoS
> > +        * priority.  Note that hw functions handle resetting
> > +        * these queues at the needed time.
> > +        */
> > +       ret = ath5k_beaconq_setup(ah);
> > +       if (ret < 0) {
> > +               ATH5K_ERR(sc, "can't setup a beacon xmit queue\n");
> > +               goto err_desc;
> > +       }
> > +       sc->bhalq = ret;
> > +       sc->cabq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_CAB, 0);
> > +       if (IS_ERR(sc->cabq)) {
> > +               ATH5K_ERR(sc, "can't setup cab queue\n");
> > +               ret = PTR_ERR(sc->cabq);
> > +               goto err_bhal;
> > +       }
> > +
> > +       sc->txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA,
> > AR5K_WME_AC_BK); +       if (IS_ERR(sc->txq)) {
> > +               ATH5K_ERR(sc, "can't setup xmit queue\n");
> > +               ret = PTR_ERR(sc->txq);
> > +               goto err_queues;
> > +       }
> > +
> > +       tasklet_init(&sc->rxtq, ath5k_tasklet_rx, (unsigned long)sc);
> > +       tasklet_init(&sc->txtq, ath5k_tasklet_tx, (unsigned long)sc);
> > +       tasklet_init(&sc->calib, ath5k_tasklet_calibrate, (unsigned
> > long)sc); +       tasklet_init(&sc->beacontq, ath5k_tasklet_beacon,
> > (unsigned long)sc); +       tasklet_init(&sc->ani_tasklet,
> > ath5k_tasklet_ani, (unsigned long)sc); +
> > +       INIT_WORK(&sc->reset_work, ath5k_reset_work);
> > +
> > +       ret = ath5k_eeprom_read_mac(ah, mac);
> > +       if (ret) {
> > +               ATH5K_ERR(sc, "unable to read address from EEPROM:
> > 0x%04x\n", +                       sc->pdev->device);
> > +               goto err_queues;
> > +       }
> > +
> > +       SET_IEEE80211_PERM_ADDR(hw, mac);
> > +       /* All MAC address bits matter for ACKs */
> > +       memcpy(sc->bssidmask, ath_bcast_mac, ETH_ALEN);
> > +       ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
> > +
> > +       regulatory->current_rd =
> > ah->ah_capabilities.cap_eeprom.ee_regdomain; +       ret =
> > ath_regd_init(regulatory, hw->wiphy, ath5k_reg_notifier); +       if
> > (ret) {
> > +               ATH5K_ERR(sc, "can't initialize regulatory system\n");
> > +               goto err_queues;
> > +       }
> > +
> > +       ret = ieee80211_register_hw(hw);
> > +       if (ret) {
> > +               ATH5K_ERR(sc, "can't register ieee80211 hw\n");
> > +               goto err_queues;
> > +       }
> > +
> > +       if (!ath_is_world_regd(regulatory))
> > +               regulatory_hint(hw->wiphy, regulatory->alpha2);
> > +
> > +       ath5k_init_leds(sc);
> > +
> > +       ath5k_sysfs_register(sc);
> > +
> > +       return 0;
> > +err_queues:
> > +       ath5k_txq_release(sc);
> > +err_bhal:
> > +       ath5k_hw_release_tx_queue(ah, sc->bhalq);
> > +err_desc:
> > +       ath5k_desc_free(sc, pdev);
> > +err:
> > +       return ret;
> > +}
> > +
> > +static void
> > +ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
> > +{
> > +       struct ath5k_softc *sc = hw->priv;
> > +
> > +       /*
> > +        * NB: the order of these is important:
> > +        * o call the 802.11 layer before detaching ath5k_hw to
> > +        *   ensure callbacks into the driver to delete global
> > +        *   key cache entries can be handled
> > +        * o reclaim the tx queue data structures after calling
> > +        *   the 802.11 layer as we'll get called back to reclaim
> > +        *   node state and potentially want to use them
> > +        * o to cleanup the tx queues the hal is called, so detach
> > +        *   it last
> > +        * XXX: ??? detach ath5k_hw ???
> > +        * Other than that, it's straightforward...
> > +        */
> > +       ieee80211_unregister_hw(hw);
> > +       ath5k_desc_free(sc, pdev);
> > +       ath5k_txq_release(sc);
> > +       ath5k_hw_release_tx_queue(sc->ah, sc->bhalq);
> > +       ath5k_unregister_leds(sc);
> > +
> > +       ath5k_sysfs_unregister(sc);
> > +       /*
> > +        * NB: can't reclaim these until after ieee80211_ifdetach
> > +        * returns because we'll get called back to reclaim node
> > +        * state and potentially want to use them.
> > +        */
> > +}
> > +
> > +/********************\
> > +* Mac80211 functions *
> > +\********************/
> > +
> > +static int
> > +ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
> > +{
> > +       struct ath5k_softc *sc = hw->priv;
> > +
> > +       return ath5k_tx_queue(hw, skb, sc->txq);
> > +}
> > +
> > 
> >  static int ath5k_start(struct ieee80211_hw *hw)
> >  {
> >  
> >        return ath5k_init(hw->priv);
> > 
> > @@ -3398,43 +2940,6 @@ ath5k_reset_tsf(struct ieee80211_hw *hw)
> > 
> >                ath5k_hw_reset_tsf(sc->ah);
> >  
> >  }
> > 
> > -/*
> > - * Updates the beacon that is sent by ath5k_beacon_send.  For adhoc,
> > - * this is called only once at config_bss time, for AP we do it every
> > - * SWBA interrupt so that the TIM will reflect buffered frames.
> > - *
> > - * Called with the beacon lock.
> > - */
> > -static int
> > -ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
> > -{
> > -       int ret;
> > -       struct ath5k_softc *sc = hw->priv;
> > -       struct sk_buff *skb;
> > -
> > -       if (WARN_ON(!vif)) {
> > -               ret = -EINVAL;
> > -               goto out;
> > -       }
> > -
> > -       skb = ieee80211_beacon_get(hw, vif);
> > -
> > -       if (!skb) {
> > -               ret = -ENOMEM;
> > -               goto out;
> > -       }
> > -
> > -       ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
> > -
> > -       ath5k_txbuf_free_skb(sc, sc->bbuf);
> > -       sc->bbuf->skb = skb;
> > -       ret = ath5k_beacon_setup(sc, sc->bbuf);
> > -       if (ret)
> > -               sc->bbuf->skb = NULL;
> > -out:
> > -       return ret;
> > -}
> > -
> > 
> >  static void
> >  set_beacon_filter(struct ieee80211_hw *hw, bool enable)
> >  {
> > 
> > @@ -3540,3 +3045,364 @@ static void ath5k_set_coverage_class(struct
> > ieee80211_hw *hw, u8 coverage_class)
> > 
> >        ath5k_hw_set_coverage_class(sc->ah, coverage_class);
> >        mutex_unlock(&sc->lock);
> >  
> >  }
> > 
> > +
> > +static const struct ieee80211_ops ath5k_hw_ops = {
> > +       .tx             = ath5k_tx,
> > +       .start          = ath5k_start,
> > +       .stop           = ath5k_stop,
> > +       .add_interface  = ath5k_add_interface,
> > +       .remove_interface = ath5k_remove_interface,
> > +       .config         = ath5k_config,
> > +       .prepare_multicast = ath5k_prepare_multicast,
> > +       .configure_filter = ath5k_configure_filter,
> > +       .set_key        = ath5k_set_key,
> > +       .get_stats      = ath5k_get_stats,
> > +       .get_survey     = ath5k_get_survey,
> > +       .conf_tx        = NULL,
> > +       .get_tsf        = ath5k_get_tsf,
> > +       .set_tsf        = ath5k_set_tsf,
> > +       .reset_tsf      = ath5k_reset_tsf,
> > +       .bss_info_changed = ath5k_bss_info_changed,
> > +       .sw_scan_start  = ath5k_sw_scan_start,
> > +       .sw_scan_complete = ath5k_sw_scan_complete,
> > +       .set_coverage_class = ath5k_set_coverage_class,
> > +};
> > +
> > +/********************\
> > +* PCI Initialization *
> > +\********************/
> > +
> > +static int __devinit
> > +ath5k_pci_probe(struct pci_dev *pdev,
> > +               const struct pci_device_id *id)
> > +{
> > +       void __iomem *mem;
> > +       struct ath5k_softc *sc;
> > +       struct ath_common *common;
> > +       struct ieee80211_hw *hw;
> > +       int ret;
> > +       u8 csz;
> > +
> > +       /*
> > +        * L0s needs to be disabled on all ath5k cards.
> > +        *
> > +        * For distributions shipping with CONFIG_PCIEASPM (this will be
> > enabled +        * by default in the future in 2.6.36) this will also
> > mean both L1 and +        * L0s will be disabled when a pre 1.1 PCIe
> > device is detected. We do +        * know L1 works correctly even for
> > all ath5k pre 1.1 PCIe devices +        * though but cannot currently
> > undue the effect of a blacklist, for +        * details you can read
> > pcie_aspm_sanity_check() and see how it adjusts +        * the device
> > link capability.
> > +        *
> > +        * It may be possible in the future to implement some PCI API to
> > allow +        * drivers to override blacklists for pre 1.1 PCIe but for
> > now it is +        * best to accept that both L0s and L1 will be
> > disabled completely for +        * distributions shipping with
> > CONFIG_PCIEASPM rather than having this +        * issue present.
> > Motivation for adding this new API will be to help +        * with power
> > consumption for some of these devices.
> > +        */
> > +       pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
> > +
> > +       ret = pci_enable_device(pdev);
> > +       if (ret) {
> > +               dev_err(&pdev->dev, "can't enable device\n");
> > +               goto err;
> > +       }
> > +
> > +       /* XXX 32-bit addressing only */
> > +       ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> > +       if (ret) {
> > +               dev_err(&pdev->dev, "32-bit DMA not available\n");
> > +               goto err_dis;
> > +       }
> > +
> > +       /*
> > +        * Cache line size is used to size and align various
> > +        * structures used to communicate with the hardware.
> > +        */
> > +       pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &csz);
> > +       if (csz == 0) {
> > +               /*
> > +                * Linux 2.4.18 (at least) writes the cache line size
> > +                * register as a 16-bit wide register which is wrong.
> > +                * We must have this setup properly for rx buffer
> > +                * DMA to work so force a reasonable value here if it
> > +                * comes up zero.
> > +                */
> > +               csz = L1_CACHE_BYTES >> 2;
> > +               pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, csz);
> > +       }
> > +       /*
> > +        * The default setting of latency timer yields poor results,
> > +        * set it to the value used by other systems.  It may be worth
> > +        * tweaking this setting more.
> > +        */
> > +       pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0xa8);
> > +
> > +       /* Enable bus mastering */
> > +       pci_set_master(pdev);
> > +
> > +       /*
> > +        * Disable the RETRY_TIMEOUT register (0x41) to keep
> > +        * PCI Tx retries from interfering with C3 CPU state.
> > +        */
> > +       pci_write_config_byte(pdev, 0x41, 0);
> > +
> > +       ret = pci_request_region(pdev, 0, "ath5k");
> > +       if (ret) {
> > +               dev_err(&pdev->dev, "cannot reserve PCI memory
> > region\n"); +               goto err_dis;
> > +       }
> > +
> > +       mem = pci_iomap(pdev, 0, 0);
> > +       if (!mem) {
> > +               dev_err(&pdev->dev, "cannot remap PCI memory region\n") ;
> > +               ret = -EIO;
> > +               goto err_reg;
> > +       }
> > +
> > +       /*
> > +        * Allocate hw (mac80211 main struct)
> > +        * and hw->priv (driver private data)
> > +        */
> > +       hw = ieee80211_alloc_hw(sizeof(*sc), &ath5k_hw_ops);
> > +       if (hw == NULL) {
> > +               dev_err(&pdev->dev, "cannot allocate ieee80211_hw\n");
> > +               ret = -ENOMEM;
> > +               goto err_map;
> > +       }
> > +
> > +       dev_info(&pdev->dev, "registered as '%s'\n",
> > wiphy_name(hw->wiphy)); +
> > +       /* Initialize driver private data */
> > +       SET_IEEE80211_DEV(hw, &pdev->dev);
> > +       hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
> > +                   IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
> > +                   IEEE80211_HW_SIGNAL_DBM;
> > +
> > +       hw->wiphy->interface_modes =
> > +               BIT(NL80211_IFTYPE_AP) |
> > +               BIT(NL80211_IFTYPE_STATION) |
> > +               BIT(NL80211_IFTYPE_ADHOC) |
> > +               BIT(NL80211_IFTYPE_MESH_POINT);
> > +
> > +       hw->extra_tx_headroom = 2;
> > +       hw->channel_change_time = 5000;
> > +       sc = hw->priv;
> > +       sc->hw = hw;
> > +       sc->pdev = pdev;
> > +
> > +       ath5k_debug_init_device(sc);
> > +
> > +       /*
> > +        * Mark the device as detached to avoid processing
> > +        * interrupts until setup is complete.
> > +        */
> > +       __set_bit(ATH_STAT_INVALID, sc->status);
> > +
> > +       sc->iobase = mem; /* So we can unmap it on detach */
> > +       sc->opmode = NL80211_IFTYPE_STATION;
> > +       sc->bintval = 1000;
> > +       mutex_init(&sc->lock);
> > +       spin_lock_init(&sc->rxbuflock);
> > +       spin_lock_init(&sc->txbuflock);
> > +       spin_lock_init(&sc->block);
> > +
> > +       /* Set private data */
> > +       pci_set_drvdata(pdev, sc);
> > +
> > +       /* Setup interrupt handler */
> > +       ret = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
> > +       if (ret) {
> > +               ATH5K_ERR(sc, "request_irq failed\n");
> > +               goto err_free;
> > +       }
> > +
> > +       /* If we passed the test, malloc an ath5k_hw struct */
> > +       sc->ah = kzalloc(sizeof(struct ath5k_hw), GFP_KERNEL);
> > +       if (!sc->ah) {
> > +               ret = -ENOMEM;
> > +               ATH5K_ERR(sc, "out of memory\n");
> > +               goto err_irq;
> > +       }
> > +
> > +       sc->ah->ah_sc = sc;
> > +       sc->ah->ah_iobase = sc->iobase;
> > +       common = ath5k_hw_common(sc->ah);
> > +       common->ops = &ath5k_common_ops;
> > +       common->ah = sc->ah;
> > +       common->hw = hw;
> > +       common->cachelsz = csz << 2; /* convert to bytes */
> > +
> > +       /* Initialize device */
> > +       ret = ath5k_hw_attach(sc);
> > +       if (ret) {
> > +               goto err_free_ah;
> > +       }
> > +
> > +       /* set up multi-rate retry capabilities */
> > +       if (sc->ah->ah_version == AR5K_AR5212) {
> > +               hw->max_rates = 4;
> > +               hw->max_rate_tries = 11;
> > +       }
> > +
> > +       /* Finish private driver data initialization */
> > +       ret = ath5k_attach(pdev, hw);
> > +       if (ret)
> > +               goto err_ah;
> > +
> > +       ATH5K_INFO(sc, "Atheros AR%s chip found (MAC: 0x%x, PHY:
> > 0x%x)\n", +                       ath5k_chip_name(AR5K_VERSION_MAC,
> > sc->ah->ah_mac_srev), +                                      
> > sc->ah->ah_mac_srev,
> > +                                       sc->ah->ah_phy_revision);
> > +
> > +       if (!sc->ah->ah_single_chip) {
> > +               /* Single chip radio (!RF5111) */
> > +               if (sc->ah->ah_radio_5ghz_revision &&
> > +                       !sc->ah->ah_radio_2ghz_revision) {
> > +                       /* No 5GHz support -> report 2GHz radio */
> > +                       if (!test_bit(AR5K_MODE_11A,
> > +                               sc->ah->ah_capabilities.cap_mode)) {
> > +                               ATH5K_INFO(sc, "RF%s 2GHz radio found
> > (0x%x)\n", +                                      
> > ath5k_chip_name(AR5K_VERSION_RAD, +                                     
> >          sc->ah->ah_radio_5ghz_revision), +                             
> >                  sc->ah->ah_radio_5ghz_revision); +                     
> >  /* No 2GHz support (5110 and some
> > +                        * 5Ghz only cards) -> report 5Ghz radio */
> > +                       } else if (!test_bit(AR5K_MODE_11B,
> > +                               sc->ah->ah_capabilities.cap_mode)) {
> > +                               ATH5K_INFO(sc, "RF%s 5GHz radio found
> > (0x%x)\n", +                                      
> > ath5k_chip_name(AR5K_VERSION_RAD, +                                     
> >          sc->ah->ah_radio_5ghz_revision), +                             
> >                  sc->ah->ah_radio_5ghz_revision); +                     
> >  /* Multiband radio */
> > +                       } else {
> > +                               ATH5K_INFO(sc, "RF%s multiband radio
> > found" +                                       " (0x%x)\n",
> > +                                       ath5k_chip_name(AR5K_VERSION_RAD,
> > +                                              
> > sc->ah->ah_radio_5ghz_revision), +                                      
> >         sc->ah->ah_radio_5ghz_revision); +                       }
> > +               }
> > +               /* Multi chip radio (RF5111 - RF2111) ->
> > +                * report both 2GHz/5GHz radios */
> > +               else if (sc->ah->ah_radio_5ghz_revision &&
> > +                               sc->ah->ah_radio_2ghz_revision){
> > +                       ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
> > +                               ath5k_chip_name(AR5K_VERSION_RAD,
> > +                                       sc->ah->ah_radio_5ghz_revision),
> > +                                       sc->ah->ah_radio_5ghz_revision);
> > +                       ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
> > +                               ath5k_chip_name(AR5K_VERSION_RAD,
> > +                                       sc->ah->ah_radio_2ghz_revision),
> > +                                       sc->ah->ah_radio_2ghz_revision);
> > +               }
> > +       }
> > +
> > +
> > +       /* ready to process interrupts */
> > +       __clear_bit(ATH_STAT_INVALID, sc->status);
> > +
> > +       return 0;
> > +err_ah:
> > +       ath5k_hw_detach(sc->ah);
> > +err_free_ah:
> > +       kfree(sc->ah);
> > +err_irq:
> > +       free_irq(pdev->irq, sc);
> > +err_free:
> > +       ieee80211_free_hw(hw);
> > +err_map:
> > +       pci_iounmap(pdev, mem);
> > +err_reg:
> > +       pci_release_region(pdev, 0);
> > +err_dis:
> > +       pci_disable_device(pdev);
> > +err:
> > +       return ret;
> > +}
> > +
> > +static void __devexit
> > +ath5k_pci_remove(struct pci_dev *pdev)
> > +{
> > +       struct ath5k_softc *sc = pci_get_drvdata(pdev);
> > +
> > +       ath5k_debug_finish_device(sc);
> > +       ath5k_detach(pdev, sc->hw);
> > +       ath5k_hw_detach(sc->ah);
> > +       kfree(sc->ah);
> > +       free_irq(pdev->irq, sc);
> > +       pci_iounmap(pdev, sc->iobase);
> > +       pci_release_region(pdev, 0);
> > +       pci_disable_device(pdev);
> > +       ieee80211_free_hw(sc->hw);
> > +}
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static int ath5k_pci_suspend(struct device *dev)
> > +{
> > +       struct ath5k_softc *sc = pci_get_drvdata(to_pci_dev(dev));
> > +
> > +       ath5k_led_off(sc);
> > +       return 0;
> > +}
> > +
> > +static int ath5k_pci_resume(struct device *dev)
> > +{
> > +       struct pci_dev *pdev = to_pci_dev(dev);
> > +       struct ath5k_softc *sc = pci_get_drvdata(pdev);
> > +
> > +       /*
> > +        * Suspend/Resume resets the PCI configuration space, so we have
> > to +        * re-disable the RETRY_TIMEOUT register (0x41) to keep
> > +        * PCI Tx retries from interfering with C3 CPU state
> > +        */
> > +       pci_write_config_byte(pdev, 0x41, 0);
> > +
> > +       ath5k_led_enable(sc);
> > +       return 0;
> > +}
> > +
> > +static SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend,
> > ath5k_pci_resume); +#define ATH5K_PM_OPS   (&ath5k_pm_ops)
> > +#else
> > +#define ATH5K_PM_OPS   NULL
> > +#endif /* CONFIG_PM_SLEEP */
> > +
> > +static struct pci_driver ath5k_pci_driver = {
> > +       .name           = KBUILD_MODNAME,
> > +       .id_table       = ath5k_pci_id_table,
> > +       .probe          = ath5k_pci_probe,
> > +       .remove         = __devexit_p(ath5k_pci_remove),
> > +       .driver.pm      = ATH5K_PM_OPS,
> > +};
> > +
> > +/*
> > + * Module init/exit functions
> > + */
> > +static int __init
> > +init_ath5k_pci(void)
> > +{
> > +       int ret;
> > +
> > +       ath5k_debug_init();
> > +
> > +       ret = pci_register_driver(&ath5k_pci_driver);
> > +       if (ret) {
> > +               printk(KERN_ERR "ath5k_pci: can't register pci
> > driver\n"); +               return ret;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static void __exit
> > +exit_ath5k_pci(void)
> > +{
> > +       pci_unregister_driver(&ath5k_pci_driver);
> > +
> > +       ath5k_debug_finish();
> > +}
> > +
> > +module_init(init_ath5k_pci);
> > +module_exit(exit_ath5k_pci);
> > 
> > 
> > 
> > 
> > Thanks,
> > 
> > Jonathan
> > 
> >>> > [   54.501954] skb_under_panic: text:c04e27f2 len:110 put:14 he0
> >>> > [   54.507979] ------------[ cut here ]------------
> >>> > [   54.511864] kernel BUG at net/core/skbuff.c:146!
> >>> > [   54.511864] invalid opcode: 0000 [#1] SMP
> >>> > [   54.511864] last sysfs file:
> >>> > /sys/devices/pci0000:00/0000:00:0c.0/device [   54.511864] Modules
> >>> > linked in: ath5k ath mac80211 led_class nfs lockd nfs_ac] [  
> >>> > 54.511864] [   54.511864] Pid: 0, comm: swapper Not tainted
> >>> > 2.6.36-rc6-wl-wl+ #3 / [   54.511864] EIP: 0060:[<c04c2b90>] EFLAGS:
> >>> > 00010286 CPU: 0 [   54.511864] EIP is at skb_push+0x80/0x90
> >>> > [   54.511864] EAX: 00000087 EBX: c04e27f2 ECX: c079daf4 EDX:
> >>> > 00000000 [   54.511864] ESI: cfd62cc0 EDI: cf468910 EBP: c0791d64
> >>> > ESP: c0791d3c [   54.511864]  DS: 007b ES: 007b FS: 00d8 GS: 00e0
> >>> > SS: 0068 [   54.511864] Process swapper (pid: 0, ti=c0790000
> >>> > task=c07976a0 task.ti=c0790) [   54.511864] Stack:
> >>> > [   54.511864]  c0754518 c04e27f2 0000006e 0000000e cfee8a00 cfee89f2
> >>> > cfee8a60 0 [   54.511864] <0> ce56c000 cfd62cc0 c0791d78 c04e27f2
> >>> > cfd62cc0 cfd62cc0 cf46890 [   54.511864] <0> c04cc866 00000040
> >>> > cf4682c0 cf4682c0 cf4682c0 c0791df8 d0c06a0 [   54.511864] Call
> >>> > Trace: [   54.511864]  [<c04e27f2>] ?
> >>> > skb_defer_rx_timestamp+0x22/0x80 [   54.511864]  [<c04e27f2>] ?
> >>> > skb_defer_rx_timestamp+0x22/0x80 [   54.511864]  [<c04cc866>] ?
> >>> > netif_receive_skb+0x26/0x90
> >>> > [   54.511864]  [<d0c06a83>] ? ieee80211_rx+0x613/0x800 [mac80211]
> >>> > [   54.511864]  [<c04c33dc>] ? __alloc_skb+0x5c/0x110
> >>> > [   54.511864]  [<d0c8badf>] ? ath5k_rx_skb_alloc+0x7f/0x160 [ath5k]
> >>> > [   54.511864]  [<d0c8cfa5>] ? ath5k_tasklet_rx+0x315/0x860 [ath5k]
> >>> > [   54.511864]  [<c0108538>] ? sched_clock+0x8/0x10
> >>> > [   54.511864]  [<c016d885>] ? sched_clock_local+0xa5/0x180
> >>> > [   54.511864]  [<d0c818c0>] ? ath5k_hw_get_isr+0xa0/0x380 [ath5k]
> >>> > [   54.511864]  [<d0c8ca9e>] ? ath5k_intr+0x2ae/0x4a0 [ath5k]
> >>> > [   54.511864]  [<c014fc17>] ? tasklet_action+0xa7/0xb0
> >>> > [   54.511864]  [<c015095c>] ? __do_softirq+0x9c/0x1b0
> >>> > [   54.511864]  [<c012c868>] ? default_spin_lock_flags+0x8/0x10
> >>> > [   54.511864]  [<c05b927f>] ? _raw_spin_lock_irqsave+0x2f/0x50
> >>> > [   54.511864]  [<c0150ab5>] ? do_softirq+0x45/0x50
> >>> > [   54.511864]  [<c0150c25>] ? irq_exit+0x65/0x70
> >>> > [   54.511864]  [<c05c0055>] ? do_IRQ+0x55/0xc0
> >>> > [   54.511864]  [<c017112f>] ? ktime_get+0x6f/0x110
> >>> > [   54.511864]  [<c01035b0>] ? common_interrupt+0x30/0x40
> >>> > [   54.511864]  [<c012bcaa>] ? native_safe_halt+0xa/0x10
> >>> > [   54.511864]  [<c0109f53>] ? default_idle+0x53/0xb0
> >>> > [   54.511864]  [<c0101e4a>] ? cpu_idle+0x8a/0xf0
> >>> > [   54.511864]  [<c05a2ccd>] ? rest_init+0x5d/0x70
> >>> > [   54.511864]  [<c07d297b>] ? start_kernel+0x357/0x35d
> >>> > [   54.511864]  [<c07d2450>] ? unknown_bootoption+0x0/0x19e
> >>> > [   54.511864]  [<c07d20de>] ? i386_start_kernel+0xde/0xe6
> >>> > [   54.511864] Code: 00 00 89 4c 24 14 8b 88 ac 00 00 00 89 54 24 0c
> >>> > 89 4c 24 1 [   54.511864] EIP: [<c04c2b90>] skb_push+0x80/0x90
> >>> > SS:ESP 0068:c0791d3c [   54.511864] ---[ end trace ccaff68ea5123ae2
> >>> > ]--- [   54.513037] Kernel panic - not syncing: Fatal exception in
> >>> > interrupt [   54.520124] Pid: 0, comm: swapper Tainted: G      D
> >>> > 2.6.36-rc6-wl-wl+ #3 [   54.521277] Call Trace:
> >>> > [   54.524656]  [<c05b6936>] ? printk+0x1d/0x1f
> >>> > [   54.529491]  [<c05b6817>] panic+0x5c/0x15e
> >>> > [   54.533818]  [<c05babdd>] oops_end+0xcd/0xd0
> >>> > [   54.538655]  [<c0105ce4>] die+0x54/0x80
> >>> > [   54.542199]  [<c05ba286>] do_trap+0x96/0xc0
> >>> > [   54.546781]  [<c0103d10>] ? do_invalid_op+0x0/0xa0
> >>> > [   54.549181]  [<c0103d9b>] do_invalid_op+0x8b/0xa0
> >>> > [   54.555342]  [<c04c2b90>] ? skb_push+0x80/0x90
> >>> > [   54.556724]  [<c014b041>] ? vprintk+0x191/0x3f0
> >>> > [   54.562339]  [<c04e27f2>] ? skb_defer_rx_timestamp+0x22/0x80
> >>> > [   54.567341]  [<c05ba017>] error_code+0x67/0x70
> >>> > [   54.568699]  [<c04e27f2>] ? skb_defer_rx_timestamp+0x22/0x80
> >>> > [   54.573704]  [<c04c2b90>] ? skb_push+0x80/0x90
> >>> > [   54.579064]  [<c04e27f2>] ? skb_defer_rx_timestamp+0x22/0x80
> >>> > [   54.584082]  [<c04e27f2>] skb_defer_rx_timestamp+0x22/0x80
> >>> > [   54.588612]  [<c04cc866>] netif_receive_skb+0x26/0x90
> >>> > [   54.595838]  [<d0c06a83>] ieee80211_rx+0x613/0x800 [mac80211]
> >>> > [   54.597099]  [<c04c33dc>] ? __alloc_skb+0x5c/0x110
> >>> > [   54.603523]  [<d0c8badf>] ? ath5k_rx_skb_alloc+0x7f/0x160 [ath5k]
> >>> > [   54.605849]  [<d0c8cfa5>] ath5k_tasklet_rx+0x315/0x860 [ath5k]
> >>> > [   54.611392]  [<c0108538>] ? sched_clock+0x8/0x10
> >>> > [   54.613284]  [<c016d885>] ? sched_clock_local+0xa5/0x180
> >>> > [   54.617265]  [<d0c818c0>] ? ath5k_hw_get_isr+0xa0/0x380 [ath5k]
> >>> > [   54.623076]  [<d0c8ca9e>] ? ath5k_intr+0x2ae/0x4a0 [ath5k]
> >>> > [   54.627564]  [<c014fc17>] tasklet_action+0xa7/0xb0
> >>> > [   54.629963]  [<c015095c>] __do_softirq+0x9c/0x1b0
> >>> > [   54.636107]  [<c012c868>] ? default_spin_lock_flags+0x8/0x10
> >>> > [   54.637124]  [<c05b927f>] ? _raw_spin_lock_irqsave+0x2f/0x50
> >>> > [   54.642137]  [<c0150ab5>] do_softirq+0x45/0x50
> >>> > [   54.647499]  [<c0150c25>] irq_exit+0x65/0x70
> >>> > [   54.652340]  [<c05c0055>] do_IRQ+0x55/0xc0
> >>> > [   54.652664]  [<c017112f>] ? ktime_get+0x6f/0x110
> >>> > [   54.658547]  [<c01035b0>] common_interrupt+0x30/0x40
> >>> > [   54.661471]  [<c012bcaa>] ? native_safe_halt+0xa/0x10
> >>> > [   54.664668]  [<c0109f53>] default_idle+0x53/0xb0
> >>> > [   54.670559]  [<c0101e4a>] cpu_idle+0x8a/0xf0
> >>> > [   54.675405]  [<c05a2ccd>] rest_init+0x5d/0x70
> >>> > [   54.680506]  [<c07d297b>] start_kernel+0x357/0x35d
> >>> > [   54.682907]  [<c07d2450>] ? unknown_bootoption+0x0/0x19e
> >>> > [   54.686869]  [<c07d20de>] i386_start_kernel+0xde/0xe6
> >>> > 
> >>> > Branch information:
> >>> > commit 25de059bdad7ce916df6f2cfdfc1c2d2d72abf11
> >>> > Merge: 412d5af 46bf695
> >>> > Author: John W. Linville <linville@tuxdriver.com>
> >>> > Date:   Tue Oct 5 15:09:33 2010 -0400
> >>> > 
> >>> > Thanks,
> >>> > 
> >>> > Jonathan Guerin
> >>> 
> >>> _______________________________________________
> >>> ath5k-devel mailing list
> >>> ath5k-devel@lists.ath5k.org
> >>> https://lists.ath5k.org/mailman/listinfo/ath5k-devel
