Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:7137 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758391AbXK3QvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2007 11:51:24 -0500
Received: by an-out-0708.google.com with SMTP id d31so480222and
        for <linux-wireless@vger.kernel.org>; Fri, 30 Nov 2007 08:51:22 -0800 (PST)
Message-ID: <40f31dec0711300851u5140c3ehcc93891759813185@mail.gmail.com> (sfid-20071130_165130_374964_8CCAB255)
Date: Fri, 30 Nov 2007 16:51:22 +0000
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 1/5] ath5k: more consistent info and error logging
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com
In-Reply-To: <1196389597-23559-2-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1196389597-23559-1-git-send-email-bruno@thinktube.com>
	 <1196389597-23559-2-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/11/30, Bruno Randolf <bruno@thinktube.com>:
> added new macros ATH5K_INFO, ATH5K_WARN and ATH5K_ERR for more consistent
> logging inside ath5k. they prepend "ath5k phyX:" to all lines so we can
> distinguish between different cards in multi-card setups. ATH5K_WARN and
> ATH5K_ERR use net_ratelimit(), so they can be used anywhere without having to
> check net_ratelimit() seperately.
>
> the macros get a reference to sc, so we can automatically add additional
> information: right now it is used to get the phy name, but having this in one
> central place gived us the flexibility to switch to dev_info/warn/... or others
> instead too. i think using "phyX" makes the output most readable and easier to
> match with the output from mac80211. in cases where we don't have sc available
> we still use ATH5K_PRINTF.
>
> changed all printk, most dev_info and most AR5K_PRINTF lines to use these
> macros instead. deleted AR5K_PRINT because it's easy to use ATH5K_PRINTF
> instead.
>
> for base.c
> Changes-licensed-under: 3-clause-BSD
>
> for all others...
> Changes-licensed-under: ISC
>
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> ---
>  drivers/net/wireless/ath5k/ath5k.h |   23 ++++++++-
>  drivers/net/wireless/ath5k/base.c  |   94 ++++++++++++++++-------------------
>  drivers/net/wireless/ath5k/hw.c    |   78 +++++++++++++++++-------------
>  drivers/net/wireless/ath5k/phy.c   |   31 +++++++-----
>  4 files changed, 126 insertions(+), 100 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
> index c5e37d2..1b542f9 100644
> --- a/drivers/net/wireless/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath5k/ath5k.h
> @@ -69,8 +69,27 @@
>    GENERIC DRIVER DEFINITIONS
>  \****************************/
>
> -#define AR5K_PRINTF(fmt, ...)   printk("%s: " fmt, __func__, ##__VA_ARGS__)
> -#define AR5K_PRINT(fmt)         printk("%s: " fmt, __func__)
> +#define ATH5K_PRINTF(fmt, ...)   printk("%s: " fmt, __func__, ##__VA_ARGS__)
> +
> +#define ATH5K_PRINTK(_sc, _level, _fmt, ...) \
> +       printk(_level "ath5k %s: " _fmt, \
> +               ((_sc) && (_sc)->hw) ? wiphy_name((_sc)->hw->wiphy) : "", \
> +               ##__VA_ARGS__)
> +
> +#define ATH5K_PRINTK_LIMIT(_sc, _level, _fmt, ...) do { \
> +       if (net_ratelimit()) \
> +               ATH5K_PRINTK(_sc, _level, _fmt, ##__VA_ARGS__); \
> +       } while (0)
> +
> +#define ATH5K_INFO(_sc, _fmt, ...) \
> +       ATH5K_PRINTK(_sc, KERN_INFO, _fmt, ##__VA_ARGS__)
> +
> +#define ATH5K_WARN(_sc, _fmt, ...) \
> +       ATH5K_PRINTK_LIMIT(_sc, KERN_WARNING, _fmt, ##__VA_ARGS__)
> +
> +#define ATH5K_ERR(_sc, _fmt, ...) \
> +       ATH5K_PRINTK_LIMIT(_sc, KERN_ERR, _fmt, ##__VA_ARGS__)
> +
>  #ifdef AR5K_DEBUG
>  #define AR5K_TRACE              printk(KERN_DEBUG "%s:%d\n", __func__, __LINE__)
>  #else
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 77e3855..31197a3 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -519,6 +519,8 @@ ath5k_pci_probe(struct pci_dev *pdev,
>                 goto err_map;
>         }
>
> +       dev_info(&pdev->dev, "registered as '%s'\n", wiphy_name(hw->wiphy));
> +
>         /* Initialize driver private data */
>         SET_IEEE80211_DEV(hw, &pdev->dev);
>         hw->flags = IEEE80211_HW_RX_INCLUDES_FCS;
> @@ -554,7 +556,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
>         /* Setup interrupt handler */
>         ret = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
>         if (ret) {
> -               dev_err(&pdev->dev, "request_irq failed\n");
> +               ATH5K_ERR(sc, "request_irq failed\n");
>                 goto err_free;
>         }
>
> @@ -570,7 +572,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
>         if (ret)
>                 goto err_ah;
>
> -       dev_info(&pdev->dev, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
> +       ATH5K_INFO(sc, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
>                         ath5k_chip_name(AR5K_VERSION_VER,sc->ah->ah_mac_srev),
>                                         sc->ah->ah_mac_srev,
>                                         sc->ah->ah_phy_revision);
> @@ -580,27 +582,28 @@ ath5k_pci_probe(struct pci_dev *pdev,
>                 if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision) {
>                         /* No 5GHz support -> report 2GHz radio */
>                         if(!test_bit(MODE_IEEE80211A, sc->ah->ah_capabilities.cap_mode)){
> -                               dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
> +                               ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
>                                         ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
>                                                         sc->ah->ah_radio_5ghz_revision);
>                         /* No 2GHz support (5110 and some 5Ghz only cards) -> report 5Ghz radio */
>                         } else if(!test_bit(MODE_IEEE80211B, sc->ah->ah_capabilities.cap_mode)){
> -                               dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
> +                               ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
>                                         ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
>                                                         sc->ah->ah_radio_5ghz_revision);
>                         /* Multiband radio */
>                         } else {
> -                               dev_info(&pdev->dev, "RF%s multiband radio found (0x%x)\n",
> +                               ATH5K_INFO(sc, "RF%s multiband radio found"
> +                                       " (0x%x)\n",
>                                         ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
>                                                         sc->ah->ah_radio_5ghz_revision);
>                         }
>                 }
>                 /* Multi chip radio (RF5111 - RF2111) -> report both 2GHz/5GHz radios */
>                 else if(sc->ah->ah_radio_5ghz_revision && sc->ah->ah_radio_2ghz_revision){
> -                       dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
> +                       ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
>                                 ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
>                                                 sc->ah->ah_radio_5ghz_revision);
> -                       dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
> +                       ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
>                                 ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_2ghz_revision),
>                                                 sc->ah->ah_radio_2ghz_revision);
>                 }
> @@ -737,7 +740,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
>          */
>         ret = ath5k_getchannels(hw);
>         if (ret) {
> -               dev_err(&pdev->dev, "can't get channels\n");
> +               ATH5K_ERR(sc, "can't get channels\n");
>                 goto err;
>         }
>
> @@ -752,7 +755,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
>          */
>         ret = ath5k_desc_alloc(sc, pdev);
>         if (ret) {
> -               dev_err(&pdev->dev, "can't allocate descriptors\n");
> +               ATH5K_ERR(sc, "can't allocate descriptors\n");
>                 goto err;
>         }
>
> @@ -764,14 +767,14 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
>          */
>         ret = ath5k_beaconq_setup(ah);
>         if (ret < 0) {
> -               dev_err(&pdev->dev, "can't setup a beacon xmit queue\n");
> +               ATH5K_ERR(sc, "can't setup a beacon xmit queue\n");
>                 goto err_desc;
>         }
>         sc->bhalq = ret;
>
>         sc->txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
>         if (IS_ERR(sc->txq)) {
> -               dev_err(&pdev->dev, "can't setup xmit queue\n");
> +               ATH5K_ERR(sc, "can't setup xmit queue\n");
>                 ret = PTR_ERR(sc->txq);
>                 goto err_bhal;
>         }
> @@ -810,7 +813,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
>
>         ret = ieee80211_register_hw(hw);
>         if (ret) {
> -               dev_err(&pdev->dev, "can't register ieee80211 hw\n");
> +               ATH5K_ERR(sc, "can't register ieee80211 hw\n");
>                 goto err_queues;
>         }
>
> @@ -944,7 +947,7 @@ ath5k_copy_channels(struct ath5k_hw *ah,
>                 chfreq = CHANNEL_2GHZ;
>                 break;
>         default:
> -               printk(KERN_WARNING "bad mode, not copying channels\n");
> +               ATH5K_WARN(ah->ah_sc, "bad mode, not copying channels\n");
>                 return 0;
>         }
>
> @@ -998,7 +1001,7 @@ ath5k_register_mode(struct ieee80211_hw *hw, u8 m)
>                         continue;
>                 ret = ieee80211_register_hwmode(hw, &modes[i]);
>                 if (ret) {
> -                       printk(KERN_ERR "can't register hwmode %u\n", m);
> +                       ATH5K_ERR(sc, "can't register hwmode %u\n", m);
>                         return ret;
>                 }
>                 return 0;
> @@ -1094,7 +1097,7 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
>                 ath5k_rx_stop(sc);              /* turn off frame recv */
>                 ret = ath5k_hw_reset(ah, sc->opmode, chan, true);
>                 if (ret) {
> -                       printk(KERN_ERR "%s: unable to reset channel %u "
> +                       ATH5K_ERR(sc, "%s: unable to reset channel %u "
>                                 "(%u Mhz)\n", __func__, chan->chan, chan->freq);
>                         return ret;
>                 }
> @@ -1106,7 +1109,7 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
>                  */
>                 ret = ath5k_rx_start(sc);
>                 if (ret) {
> -                       printk(KERN_ERR "%s: unable to restart recv logic\n",
> +                       ATH5K_ERR(sc, "%s: unable to restart recv logic\n",
>                                         __func__);
>                         return ret;
>                 }
> @@ -1232,7 +1235,7 @@ ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
>                         (ATH_TXBUF + ATH_RXBUF + ATH_BCBUF + 1);
>         sc->desc = pci_alloc_consistent(pdev, sc->desc_len, &sc->desc_daddr);
>         if (sc->desc == NULL) {
> -               dev_err(&pdev->dev, "can't allocate descriptors\n");
> +               ATH5K_ERR(sc, "can't allocate descriptors\n");
>                 ret = -ENOMEM;
>                 goto err;
>         }
> @@ -1244,7 +1247,7 @@ ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
>         bf = kcalloc(1 + ATH_TXBUF + ATH_RXBUF + ATH_BCBUF,
>                         sizeof(struct ath5k_buf), GFP_KERNEL);
>         if (bf == NULL) {
> -               dev_err(&pdev->dev, "can't allocate bufptr\n");
> +               ATH5K_ERR(sc, "can't allocate bufptr\n");
>                 ret = -ENOMEM;
>                 goto err_free;
>         }
> @@ -1320,7 +1323,7 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
>                  */
>                 skb = dev_alloc_skb(sc->rxbufsize + sc->cachelsz - 1);
>                 if (unlikely(skb == NULL)) {
> -                       printk(KERN_ERR "ath: can't alloc skbuff of size %u\n",
> +                       ATH5K_ERR(sc, "can't alloc skbuff of size %u\n",
>                                         sc->rxbufsize + sc->cachelsz - 1);
>                         return -ENOMEM;
>                 }
> @@ -1337,7 +1340,7 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
>                 bf->skbaddr = pci_map_single(sc->pdev,
>                         skb->data, sc->rxbufsize, PCI_DMA_FROMDEVICE);
>                 if (unlikely(pci_dma_mapping_error(bf->skbaddr))) {
> -                       printk(KERN_ERR "%s: DMA mapping failed\n", __func__);
> +                       ATH5K_ERR(sc, "%s: DMA mapping failed\n", __func__);
>                         dev_kfree_skb(skb);
>                         bf->skb = NULL;
>                         return -ENOMEM;
> @@ -1482,7 +1485,7 @@ ath5k_txq_setup(struct ath5k_softc *sc,
>                 return ERR_PTR(qnum);
>         }
>         if (qnum >= ARRAY_SIZE(sc->txqs)) {
> -               printk(KERN_ERR "hw qnum %u out of range, max %tu!\n",
> +               ATH5K_ERR(sc, "hw qnum %u out of range, max %tu!\n",
>                         qnum, ARRAY_SIZE(sc->txqs));
>                 ath5k_hw_release_tx_queue(ah, qnum);
>                 return ERR_PTR(-EINVAL);
> @@ -1535,7 +1538,7 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
>
>         ret = ath5k_hw_setup_tx_queueprops(ah, sc->bhalq, &qi);
>         if (ret) {
> -               printk(KERN_ERR "%s: unable to update parameters for beacon "
> +               ATH5K_ERR(sc, "%s: unable to update parameters for beacon "
>                         "hardware queue!\n", __func__);
>                 return ret;
>         }
> @@ -1739,8 +1742,7 @@ ath5k_tasklet_rx(unsigned long data)
>         spin_lock(&sc->rxbuflock);
>         do {
>                 if (unlikely(list_empty(&sc->rxbuf))) {
> -                       if (net_ratelimit())
> -                               printk(KERN_WARNING "ath: empty rx buf pool\n");
> +                       ATH5K_WARN(sc, "empty rx buf pool\n");
>                         break;
>                 }
>                 bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
> @@ -1759,15 +1761,12 @@ ath5k_tasklet_rx(unsigned long data)
>                 if (unlikely(ret == -EINPROGRESS))
>                         break;
>                 else if (unlikely(ret)) {
> -                       if (net_ratelimit())
> -                               printk(KERN_ERR "ath: error in processing rx "
> -                                       "descriptor\n");
> +                       ATH5K_ERR(sc, "error in processing rx descriptor\n");
>                         return;
>                 }
>
>                 if (unlikely(ds->ds_rxstat.rs_more)) {
> -                       if (net_ratelimit())
> -                               printk(KERN_INFO "ath: unsupported jumbo\n");
> +                       ATH5K_WARN(sc, "unsupported jumbo\n");
>                         goto next;
>                 }
>
> @@ -1874,8 +1873,8 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
>                 if (unlikely(ret == -EINPROGRESS))
>                         break;
>                 else if (unlikely(ret)) {
> -                       printk(KERN_ERR "ath: error %d while processing "
> -                               "queue %u\n", ret, txq->qnum);
> +                       ATH5K_ERR(sc, "error %d while processing queue %u\n",
> +                               ret, txq->qnum);
>                         break;
>                 }
>
> @@ -1950,7 +1949,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
>                         "skbaddr %llx\n", __func__, skb, skb->data, skb->len,
>                         (unsigned long long)bf->skbaddr);
>         if (pci_dma_mapping_error(bf->skbaddr)) {
> -               printk(KERN_ERR "ath: beacon DMA mapping failed\n");
> +               ATH5K_ERR(sc, "beacon DMA mapping failed\n");
>                 return -EIO;
>         }
>
> @@ -2006,8 +2005,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
>
>         if (unlikely(bf->skb == NULL || sc->opmode == IEEE80211_IF_TYPE_STA ||
>                         sc->opmode == IEEE80211_IF_TYPE_MNTR)) {
> -               printk(KERN_WARNING "ath: bf=%p bf_skb=%p\n", bf,
> -                               bf ? bf->skb : NULL);
> +               ATH5K_WARN(sc, "bf=%p bf_skb=%p\n", bf, bf ? bf->skb : NULL);
>                 return;
>         }
>         /*
> @@ -2043,8 +2041,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
>          * are still pending on the queue.
>          */
>         if (unlikely(ath5k_hw_stop_tx_dma(ah, sc->bhalq))) {
> -               printk(KERN_WARNING "ath: beacon queue %u didn't stop?\n",
> -                               sc->bhalq);
> +               ATH5K_WARN(sc, "beacon queue %u didn't stop?\n", sc->bhalq);
>                 /* NB: hw still stops DMA, so proceed */
>         }
>         pci_dma_sync_single_for_cpu(sc->pdev, bf->skbaddr, bf->skb->len,
> @@ -2184,7 +2181,7 @@ ath5k_init(struct ath5k_softc *sc)
>         sc->curchan = sc->hw->conf.chan;
>         ret = ath5k_hw_reset(sc->ah, sc->opmode, sc->curchan, false);
>         if (ret) {
> -               printk(KERN_ERR "unable to reset hardware: %d\n", ret);
> +               ATH5K_ERR(sc, "unable to reset hardware: %d\n", ret);
>                 goto done;
>         }
>         /*
> @@ -2376,9 +2373,8 @@ ath5k_intr(int irq, void *dev_id)
>                 }
>         } while (ath5k_hw_is_intr_pending(ah) && counter-- > 0);
>
> -       if (unlikely(!counter && net_ratelimit()))
> -               printk(KERN_WARNING "ath: too many interrupts, giving up for "
> -                               "now\n");
> +       if (unlikely(!counter))
> +               ATH5K_WARN(sc, "too many interrupts, giving up for now\n");
>
>         return IRQ_HANDLED;
>  }
> @@ -2419,7 +2415,7 @@ ath5k_calibrate(unsigned long data)
>                 ath5k_reset(sc->hw);
>         }
>         if (ath5k_hw_phy_calibrate(ah, sc->curchan))
> -               printk(KERN_ERR "ath: calibration of channel %u failed\n",
> +               ATH5K_ERR(sc, "calibration of channel %u failed\n",
>                                 sc->curchan->chan);
>
>         mod_timer(&sc->calib_tim, round_jiffies(jiffies +
> @@ -2510,10 +2506,8 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
>         if (hdrlen & 3) {
>                 pad = hdrlen % 4;
>                 if (skb_headroom(skb) < pad) {
> -                       if (net_ratelimit())
> -                               printk(KERN_ERR "ath: tx hdrlen not %%4: %d "
> -                                       "not enough headroom to pad %d\n",
> -                                       hdrlen, pad);
> +                       ATH5K_ERR(sc, "tx hdrlen not %%4: %d not enough"
> +                               " headroom to pad %d\n", hdrlen, pad);
>                         return -1;
>                 }
>                 skb_push(skb, pad);
> @@ -2524,9 +2518,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
>
>         spin_lock_irqsave(&sc->txbuflock, flags);
>         if (list_empty(&sc->txbuf)) {
> -               if (net_ratelimit())
> -                       printk(KERN_ERR "ath: no further txbuf available, "
> -                               "dropping packet\n");
> +               ATH5K_ERR(sc, "no further txbuf available, dropping packet\n");
>                 spin_unlock_irqrestore(&sc->txbuflock, flags);
>                 ieee80211_stop_queue(hw, ctl->queue);
>                 return -1;
> @@ -2573,14 +2565,14 @@ ath5k_reset(struct ieee80211_hw *hw)
>
>         ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
>         if (unlikely(ret)) {
> -               printk(KERN_ERR "ath: can't reset hardware (%d)\n", ret);
> +               ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
>                 goto err;
>         }
>         ath5k_update_txpow(sc);
>
>         ret = ath5k_rx_start(sc);
>         if (unlikely(ret)) {
> -               printk(KERN_ERR "ath: can't start recv logic\n");
> +               ATH5K_ERR(sc, "can't start recv logic\n");
>                 goto err;
>         }
>         /*
> @@ -2845,7 +2837,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>         case SET_KEY:
>                 ret = ath5k_hw_set_key(sc->ah, key->keyidx, key, addr);
>                 if (ret) {
> -                       printk(KERN_ERR "ath: can't set the key\n");
> +                       ATH5K_ERR(sc, "can't set the key\n");
>                         goto unlock;
>                 }
>                 __set_bit(key->keyidx, sc->keymap);
> diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
> index 4aca069..0cdc195 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
> @@ -128,7 +128,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>         ah = kzalloc(sizeof(struct ath5k_hw), GFP_KERNEL);
>         if (ah == NULL) {
>                 ret = -ENOMEM;
> -               AR5K_PRINT("out of memory\n");
> +               ATH5K_ERR(sc, "out of memory\n");
>                 goto err;
>         }
>
> @@ -203,14 +203,14 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>
>         /* Return on unsuported chips (unsupported eeprom etc) */
>         if(srev >= AR5K_SREV_VER_AR5416){
> -               printk(KERN_ERR "ath5k: Device not yet supported.\n");
> +               ATH5K_ERR(sc, "Device not yet supported.\n");
>                 ret = -ENODEV;
>                 goto err_free;
>         }
>
>         /* Warn for partially supported chips (unsupported phy etc) */
>         if(srev >= AR5K_SREV_VER_AR2424){
> -               printk(KERN_DEBUG "ath5k: Device partially supported.\n");
> +               ATH5K_WARN(sc, "Device only partially supported.\n");
>         }
>
>         /* Identify single chip solutions */
> @@ -248,14 +248,14 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>
>         ret = ath5k_eeprom_init(ah);
>         if (ret) {
> -               AR5K_PRINT("unable to init EEPROM\n");
> +               ATH5K_ERR(sc, "unable to init EEPROM\n");
>                 goto err_free;
>         }
>
>         /* Get misc capabilities */
>         ret = ath5k_hw_get_capabilities(ah);
>         if (ret) {
> -               AR5K_PRINTF("unable to get device capabilities: 0x%04x\n",
> +               ATH5K_ERR(sc, "unable to get device capabilities: 0x%04x\n",
>                         sc->pdev->device);
>                 goto err_free;
>         }
> @@ -263,7 +263,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>         /* Get MAC address */
>         ret = ath5k_eeprom_read_mac(ah, mac);
>         if (ret) {
> -               AR5K_PRINTF("unable to read address from EEPROM: 0x%04x\n",
> +               ATH5K_ERR(sc, "unable to read address from EEPROM: 0x%04x\n",
>                         sc->pdev->device);
>                 goto err_free;
>         }
> @@ -328,7 +328,8 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
>                                 else
>                                         mode |= AR5K_PHY_MODE_MOD_DYN;
>                         } else {
> -                               AR5K_PRINT("invalid radio modulation mode\n");
> +                               ATH5K_ERR(ah->ah_sc,
> +                                       "invalid radio modulation mode\n");
>                                 return -EINVAL;
>                         }
>                 } else if (flags & CHANNEL_5GHZ) {
> @@ -338,11 +339,12 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
>                         if (flags & CHANNEL_OFDM)
>                                 mode |= AR5K_PHY_MODE_MOD_OFDM;
>                         else {
> -                               AR5K_PRINT("invalid radio modulation mode\n");
> +                               ATH5K_ERR(ah->ah_sc,
> +                                       "invalid radio modulation mode\n");
>                                 return -EINVAL;
>                         }
>                 } else {
> -                       AR5K_PRINT("invalid radio frequency mode\n");
> +                       ATH5K_ERR(ah->ah_sc, "invalid radio frequency mode\n");
>                         return -EINVAL;
>                 }
>
> @@ -352,7 +354,8 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
>                 if (initial == true) {
>                         /* ...reset hardware */
>                         if (ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCI)) {
> -                               AR5K_PRINT("failed to reset the PCI chipset\n");
> +                               ATH5K_ERR(ah->ah_sc,
> +                                       "failed to reset the PCI chipset\n");
>                                 return -EIO;
>                         }
>
> @@ -362,7 +365,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
>                 /* ...wakeup */
>                 ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
>                 if (ret) {
> -                       AR5K_PRINT("failed to resume the MAC Chip\n");
> +                       ATH5K_ERR(ah->ah_sc, "failed to resume the MAC Chip\n");
>                         return ret;
>                 }
>
> @@ -373,7 +376,8 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
>
>                 /* ...reset chipset */
>                 if (ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_CHIP)) {
> -                       AR5K_PRINT("failed to reset the AR5210 chipset\n");
> +                       ATH5K_ERR(ah->ah_sc,
> +                               "failed to reset the AR5210 chipset\n");
>                         return -EIO;
>                 }
>
> @@ -383,7 +387,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
>         /* ...reset chipset and PCI device */
>         if (ah->ah_single_chip == false && ath5k_hw_nic_reset(ah,
>                                 AR5K_RESET_CTL_CHIP | AR5K_RESET_CTL_PCI)) {
> -               AR5K_PRINT("failed to reset the MAC Chip + PCI\n");
> +               ATH5K_ERR(ah->ah_sc, "failed to reset the MAC Chip + PCI\n");
>                 return -EIO;
>         }
>
> @@ -393,13 +397,13 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
>         /* ...wakeup */
>         ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
>         if (ret) {
> -               AR5K_PRINT("failed to resume the MAC Chip\n");
> +               ATH5K_ERR(ah->ah_sc, "failed to resume the MAC Chip\n");
>                 return ret;
>         }
>
>         /* ...final warm reset */
>         if (ath5k_hw_nic_reset(ah, 0)) {
> -               AR5K_PRINT("failed to warm reset the MAC Chip\n");
> +               ATH5K_ERR(ah->ah_sc, "failed to warm reset the MAC Chip\n");
>                 return -EIO;
>         }
>
> @@ -643,7 +647,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>                 if (ah->ah_radio != AR5K_RF5111 &&
>                         ah->ah_radio != AR5K_RF5112 &&
>                         ah->ah_radio != AR5K_RF5413) {
> -                       AR5K_PRINTF("invalid phy radio: %u\n", ah->ah_radio);
> +                       ATH5K_ERR(ah->ah_sc,
> +                               "invalid phy radio: %u\n", ah->ah_radio);
>                         return -EINVAL;
>                 }
>
> @@ -681,7 +686,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>                         break;
>                 case CHANNEL_XR:
>                         if (ah->ah_version == AR5K_AR5211) {
> -                               AR5K_PRINTF("XR mode not available on 5211");
> +                               ATH5K_ERR(ah->ah_sc,
> +                                       "XR mode not available on 5211");
>                                 return -EINVAL;
>                         }
>                         mode = AR5K_INI_VAL_XR;
> @@ -690,7 +696,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>                         driver_mode = MODE_IEEE80211A;
>                         break;
>                 default:
> -                       AR5K_PRINTF("invalid channel: %d\n", channel->freq);
> +                       ATH5K_ERR(ah->ah_sc,
> +                               "invalid channel: %d\n", channel->freq);
>                         return -EINVAL;
>                 }
>
> @@ -905,7 +912,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>
>         if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
>                         AR5K_PHY_AGCCTL_CAL, 0, false)) {
> -               AR5K_PRINTF("calibration timeout (%uMHz)\n", channel->freq);
> +               ATH5K_ERR(ah->ah_sc, "calibration timeout (%uMHz)\n",
> +                       channel->freq);
>                 return -EAGAIN;
>         }
>
> @@ -917,8 +925,9 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>
>         if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
>                         AR5K_PHY_AGCCTL_NF, 0, false)) {
> -               AR5K_PRINTF("noise floor calibration timeout (%uMHz)\n",
> -                               channel->freq);
> +               ATH5K_ERR(ah->ah_sc,
> +                       "noise floor calibration timeout (%uMHz)\n",
> +                       channel->freq);
>                 return -EAGAIN;
>         }
>
> @@ -935,7 +944,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>         }
>
>         if (noise_floor > AR5K_TUNE_NOISE_FLOOR) {
> -               AR5K_PRINTF("noise floor calibration failed (%uMHz)\n",
> +               ATH5K_ERR(ah->ah_sc,
> +                       "noise floor calibration failed (%uMHz)\n",
>                         channel->freq);
>                 return -EIO;
>         }
> @@ -962,7 +972,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>
>                 ret = ath5k_hw_reset_tx_queue(ah, i);
>                 if (ret) {
> -                       AR5K_PRINTF("failed to reset TX queue #%d\n", i);
> +                       ATH5K_ERR(ah->ah_sc,
> +                               "failed to reset TX queue #%d\n", i);
>                         return ret;
>                 }
>         }
> @@ -1504,7 +1515,7 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
>          * print the register value.
>          */
>         if (unlikely(*interrupt_mask == 0 && net_ratelimit()))
> -               AR5K_PRINTF("0x%08x\n", data);
> +               ATH5K_PRINTF("0x%08x\n", data);
>
>         return 0;
>  }
> @@ -1645,7 +1656,7 @@ static int ath5k_hw_eeprom_write(struct ath5k_hw *ah, u32 offset, u16 data)
>                 udelay(15);
>         }
>  #endif
> -       AR5K_PRINTF("EEPROM Write is disabled!");
> +       ATH5K_ERR(ah->ah_sc, "EEPROM Write is disabled!");
>         return -EIO;
>  }
>
> @@ -1856,7 +1867,7 @@ static int ath5k_eeprom_init(struct ath5k_hw *ah)
>                 cksum ^= val;
>         }
>         if (cksum != AR5K_EEPROM_INFO_CKSUM) {
> -               AR5K_PRINTF("Invalid EEPROM checksum 0x%04x\n", cksum);
> +               ATH5K_ERR(ah->ah_sc, "Invalid EEPROM checksum 0x%04x\n", cksum);
>                 return -EIO;
>         }
>  #endif
> @@ -3092,8 +3103,9 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
>                         break;
>                 case AR5K_TX_QUEUE_XR_DATA:
>                         if (ah->ah_version != AR5K_AR5212)
> -                               AR5K_PRINTF("XR data queues only supported in "
> -                                               "5212!\n");
> +                               ATH5K_ERR(ah->ah_sc,
> +                                       "XR data queues only supported in"
> +                                       " 5212!\n");
>                         queue = AR5K_TX_QUEUE_ID_XR_DATA;
>                         break;
>                 default:
> @@ -4232,9 +4244,9 @@ ath5k_hw_dump_state(struct ath5k_hw *ah)
>  {
>  #ifdef AR5K_DEBUG
>  #define AR5K_PRINT_REGISTER(_x)                                                \
> -       AR5K_PRINTF("(%s: %08x) ", #_x, ath5k_hw_reg_read(ah, AR5K_##_x));
> +       ATH5K_PRINTF("(%s: %08x) ", #_x, ath5k_hw_reg_read(ah, AR5K_##_x));
>
> -       AR5K_PRINT("MAC registers:\n");
> +       ATH5K_PRINTF("MAC registers:\n");
>         AR5K_PRINT_REGISTER(CR);
>         AR5K_PRINT_REGISTER(CFG);
>         AR5K_PRINT_REGISTER(IER);
> @@ -4302,9 +4314,9 @@ ath5k_hw_dump_state(struct ath5k_hw *ah)
>         AR5K_PRINT_REGISTER(FCS_FAIL);
>         AR5K_PRINT_REGISTER(BEACON_CNT);
>         AR5K_PRINT_REGISTER(TSF_PARM);
> -       AR5K_PRINT("\n");
> +       ATH5K_PRINTF("\n");
>
> -       AR5K_PRINT("PHY registers:\n");
> +       ATH5K_PRINTF("PHY registers:\n");
>         AR5K_PRINT_REGISTER(PHY_TURBO);
>         AR5K_PRINT_REGISTER(PHY_AGC);
>         AR5K_PRINT_REGISTER(PHY_TIMING_3);
> @@ -4322,7 +4334,7 @@ ath5k_hw_dump_state(struct ath5k_hw *ah)
>         AR5K_PRINT_REGISTER(PHY_RADAR);
>         AR5K_PRINT_REGISTER(PHY_ANT_SWITCH_TABLE_0);
>         AR5K_PRINT_REGISTER(PHY_ANT_SWITCH_TABLE_1);
> -       AR5K_PRINT("\n");
> +       ATH5K_PRINTF("\n");
>  #endif
>  }
>
> diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
> index d5aec18..a4968b6 100644
> --- a/drivers/net/wireless/ath5k/phy.c
> +++ b/drivers/net/wireless/ath5k/phy.c
> @@ -23,6 +23,7 @@
>
>  #include "ath5k.h"
>  #include "reg.h"
> +#include "base.h"
>
>  /* Struct to hold initial RF register values (RF Banks) */
>  struct ath5k_ini_rf {
> @@ -719,7 +720,7 @@ static unsigned int ath5k_hw_rfregs_op(u32 *rf, u32 offset, u32 reg, u32 bits,
>                 return 0;
>
>         if (!(col <= 3 && bits <= 32 && first + bits <= 319)) {
> -               AR5K_PRINTF("invalid values at offset %u\n", offset);
> +               ATH5K_PRINTF("invalid values at offset %u\n", offset);
>                 return 0;
>         }
>
> @@ -880,11 +881,10 @@ static s32 ath5k_hw_rfregs_gain_adjust(struct ath5k_hw *ah)
>
>  done:
>  #ifdef AR5K_DEBUG
> -       AR5K_PRINTF("ret %d, gain step %u, current gain %u, target gain %u\n",
> +       ATH5K_PRINTF("ret %d, gain step %u, current gain %u, target gain %u\n",
>                 ret, ah->ah_gain.g_step_idx, ah->ah_gain.g_current,
>                 ah->ah_gain.g_target);
>  #endif
> -
>         return ret;
>  }
>
> @@ -908,7 +908,7 @@ static int ath5k_hw_rf5111_rfregs(struct ath5k_hw *ah,
>         /* Copy values to modify them */
>         for (i = 0; i < rf_size; i++) {
>                 if (rfregs_5111[i].rf_bank >= AR5K_RF5111_INI_RF_MAX_BANKS) {
> -                       AR5K_PRINT("invalid bank\n");
> +                       ATH5K_ERR(ah->ah_sc, "invalid bank\n");
>                         return -EINVAL;
>                 }
>
> @@ -1017,7 +1017,7 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
>         /* Copy values to modify them */
>         for (i = 0; i < rf_size; i++) {
>                 if (rf_ini[i].rf_bank >= AR5K_RF5112_INI_RF_MAX_BANKS) {
> -                       AR5K_PRINT("invalid bank\n");
> +                       ATH5K_ERR(ah->ah_sc, "invalid bank\n");
>                         return -EINVAL;
>                 }
>
> @@ -1105,7 +1105,7 @@ static int ath5k_hw_rf5413_rfregs(struct ath5k_hw *ah,
>         /* Copy values to modify them */
>         for (i = 0; i < rf_size; i++) {
>                 if (rf_ini[i].rf_bank >= AR5K_RF5112_INI_RF_MAX_BANKS) {
> -                       AR5K_PRINT("invalid bank\n");
> +                       ATH5K_ERR(ah->ah_sc, "invalid bank\n");
>                         return -EINVAL;
>                 }
>
> @@ -1167,7 +1167,7 @@ int ath5k_hw_rfregs(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>                 /* XXX do extra checks? */
>                 ah->ah_rf_banks = kmalloc(ah->ah_rf_banks_size, GFP_KERNEL);
>                 if (ah->ah_rf_banks == NULL) {
> -                       AR5K_PRINT("out of memory\n");
> +                       ATH5K_ERR(ah->ah_sc, "out of memory\n");
>                         return -ENOMEM;
>                 }
>         }
> @@ -1484,7 +1484,8 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
>             channel->freq > ah->ah_capabilities.cap_range.range_2ghz_max) &&
>             (channel->freq < ah->ah_capabilities.cap_range.range_5ghz_min ||
>             channel->freq > ah->ah_capabilities.cap_range.range_5ghz_max)) {
> -               AR5K_PRINTF("channel out of supported range (%u MHz)\n",
> +               ATH5K_ERR(ah->ah_sc,
> +                       "channel out of supported range (%u MHz)\n",
>                         channel->freq);
>                 return -EINVAL;
>         }
> @@ -1605,7 +1606,8 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
>         ath5k_hw_reg_write(ah, phy_sat, AR5K_PHY_ADCSAT);
>
>         if (ret) {
> -               AR5K_PRINTF("calibration timeout (%uMHz)\n", channel->freq);
> +               ATH5K_ERR(ah->ah_sc, "calibration timeout (%uMHz)\n",
> +                               channel->freq);
>                 return ret;
>         }
>
> @@ -1617,8 +1619,9 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
>         ret = ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
>                         AR5K_PHY_AGCCTL_NF, 0, false);
>         if (ret) {
> -               AR5K_PRINTF("noise floor calibration timeout (%uMHz)\n",
> -                               channel->freq);
> +               ATH5K_ERR(ah->ah_sc,
> +                       "noise floor calibration timeout (%uMHz)\n",
> +                       channel->freq);
>                 return ret;
>         }
>
> @@ -1635,7 +1638,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
>         }
>
>         if (noise_floor > AR5K_TUNE_NOISE_FLOOR) {
> -               AR5K_PRINTF("noise floor calibration failed (%uMHz)\n",
> +               ATH5K_ERR(ah->ah_sc, "noise floor calibration failed (%uMHz)\n",
>                         channel->freq);
>                 return -EIO;
>         }
> @@ -1847,7 +1850,7 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>
>         AR5K_TRACE;
>         if (txpower > AR5K_TUNE_MAX_TXPOWER) {
> -               AR5K_PRINTF("invalid tx power: %u\n", txpower);
> +               ATH5K_ERR(ah->ah_sc, "invalid tx power: %u\n", txpower);
>                 return -EINVAL;
>         }
>
> @@ -1901,7 +1904,7 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, unsigned int power)
>
>         AR5K_TRACE;
>  #ifdef AR5K_DEBUG
> -       AR5K_PRINTF("changing txpower to %d\n", power);
> +       ATH5K_PRINTF("changing txpower to %d\n", power);
>  #endif
>         return ath5k_hw_txpower(ah, channel, power);
>  }
> --
> 1.5.3.4
>
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
