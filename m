Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:14579 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751896AbXKPINq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 03:13:46 -0500
From: bruno randolf <bruno@thinktube.com>
To: linville@tuxdriver.com
Subject: Re: [PATCH] ath5k: consistent info and error logging
Date: Fri, 16 Nov 2007 17:13:48 +0900
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
References: <1195200656-25847-1-git-send-email-bruno@thinktube.com>
In-Reply-To: <1195200656-25847-1-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711161713.48800.bruno@thinktube.com> (sfid-20071116_081349_618955_EAC38143)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

forgot to add: this applies on top of nicks latest patches.

bruno

On Friday 16 November 2007 17:10:56 Bruno Randolf wrote:
> this is just cosmetics, but anyhow it's important for distinguishing
> between cards in setups with more than one atheros card.
>
> added 4 new macros AR5K_INFO, AR5K_WARN, AR5K_ERR and AR5K_DBG, and changed
> all printk, most dev_info and most AR5K_PRINTF lines to use these macros
> instead. they get a reference to sc, so we can automatically add additional
> information: right now they prepend "ath5k phyX:" to all strings, but it
> would be possible to switch to dev_info/warn/... instead too. i think using
> "phyX" makes the output more readable and easier to match with the output
> from mac80211. in cases where we don't have sc available we still use
> AR5K_PRINTF.
>
> deleted AR5K_PRINT because it's easy to use AR5K_PRINTF instead.
>
> AR5K_DGB is only used when AR5K_DEBUG is defined.
>
> for base.c
> Changes-licensed-under: 3-clause-BSD
>
> for all others...
> Changes-licensed-under: ISC
>
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> ---
>  drivers/net/wireless/ath5k/ath5k.h |   15 ++++++-
>  drivers/net/wireless/ath5k/base.c  |   83
> ++++++++++++++++++------------------ drivers/net/wireless/ath5k/hw.c    |  
> 54 ++++++++++++------------ drivers/net/wireless/ath5k/phy.c   |   29
> ++++++------
>  4 files changed, 96 insertions(+), 85 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/ath5k.h
> b/drivers/net/wireless/ath5k/ath5k.h index c5e37d2..854ce5a 100644
> --- a/drivers/net/wireless/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath5k/ath5k.h
> @@ -70,11 +70,24 @@
>  \****************************/
>
>  #define AR5K_PRINTF(fmt, ...)   printk("%s: " fmt, __func__,
> ##__VA_ARGS__) -#define AR5K_PRINT(fmt)         printk("%s: " fmt,
> __func__)
> +
> +#define AR5K_INFO(_sc, _fmt, ...)	\
> +	printk(KERN_INFO "ath5k %s: " _fmt, wiphy_name((_sc)->hw->wiphy),
> ##__VA_ARGS__) +
> +#define AR5K_WARN(_sc, _fmt, ...)	\
> +	printk(KERN_WARNING "ath5k %s: " _fmt, wiphy_name((_sc)->hw->wiphy),
> ##__VA_ARGS__) +
> +#define AR5K_ERR(_sc, _fmt, ...) \
> +	printk(KERN_ERR "ath5k %s: " _fmt, wiphy_name((_sc)->hw->wiphy),
> ##__VA_ARGS__) +
>  #ifdef AR5K_DEBUG
>  #define AR5K_TRACE              printk(KERN_DEBUG "%s:%d\n", __func__,
> __LINE__) +#define AR5K_DBG(_sc, _fmt, ...) \
> +	printk(KERN_DEBUG "ath5k %s (%s:%d): " _fmt,
> wiphy_name((_sc)->hw->wiphy), \ +		__func__, __LINE__,  ##__VA_ARGS__)
>  #else
>  #define AR5K_TRACE
> +#define AR5K_DBG(...)
>  #endif
>
>  /*
> diff --git a/drivers/net/wireless/ath5k/base.c
> b/drivers/net/wireless/ath5k/base.c index 77e3855..c7cc366 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -519,6 +519,8 @@ ath5k_pci_probe(struct pci_dev *pdev,
>  		goto err_map;
>  	}
>
> +	dev_info(&pdev->dev, "registered as '%s'\n", wiphy_name(hw->wiphy));
> +
>  	/* Initialize driver private data */
>  	SET_IEEE80211_DEV(hw, &pdev->dev);
>  	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS;
> @@ -554,7 +556,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
>  	/* Setup interrupt handler */
>  	ret = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
>  	if (ret) {
> -		dev_err(&pdev->dev, "request_irq failed\n");
> +		AR5K_ERR(sc, "request_irq failed\n");
>  		goto err_free;
>  	}
>
> @@ -570,7 +572,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
>  	if (ret)
>  		goto err_ah;
>
> -	dev_info(&pdev->dev, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
> +	AR5K_INFO(sc, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
>  			ath5k_chip_name(AR5K_VERSION_VER,sc->ah->ah_mac_srev),
>  					sc->ah->ah_mac_srev,
>  					sc->ah->ah_phy_revision);
> @@ -580,27 +582,27 @@ ath5k_pci_probe(struct pci_dev *pdev,
>  		if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision) {
>  			/* No 5GHz support -> report 2GHz radio */
>  			if(!test_bit(MODE_IEEE80211A, sc->ah->ah_capabilities.cap_mode)){
> -				dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
> +				AR5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
>  					ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
>  							sc->ah->ah_radio_5ghz_revision);
>  			/* No 2GHz support (5110 and some 5Ghz only cards) -> report 5Ghz radio
> */ } else if(!test_bit(MODE_IEEE80211B, sc->ah->ah_capabilities.cap_mode)){
> -				dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
> +				AR5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
>  					ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
>  							sc->ah->ah_radio_5ghz_revision);
>  			/* Multiband radio */
>  			} else {
> -				dev_info(&pdev->dev, "RF%s multiband radio found (0x%x)\n",
> +				AR5K_INFO(sc, "RF%s multiband radio found (0x%x)\n",
>  					ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
>  							sc->ah->ah_radio_5ghz_revision);
>  			}
>  		}
>  		/* Multi chip radio (RF5111 - RF2111) -> report both 2GHz/5GHz radios */
>  		else if(sc->ah->ah_radio_5ghz_revision &&
> sc->ah->ah_radio_2ghz_revision){ -			dev_info(&pdev->dev, "RF%s 5GHz radio
> found (0x%x)\n",
> +			AR5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
>  				ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
>  						sc->ah->ah_radio_5ghz_revision);
> -			dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
> +			AR5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
>  				ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_2ghz_revision),
>  						sc->ah->ah_radio_2ghz_revision);
>  		}
> @@ -737,7 +739,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw
> *hw) */
>  	ret = ath5k_getchannels(hw);
>  	if (ret) {
> -		dev_err(&pdev->dev, "can't get channels\n");
> +		AR5K_ERR(sc, "can't get channels\n");
>  		goto err;
>  	}
>
> @@ -752,7 +754,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw
> *hw) */
>  	ret = ath5k_desc_alloc(sc, pdev);
>  	if (ret) {
> -		dev_err(&pdev->dev, "can't allocate descriptors\n");
> +		AR5K_ERR(sc, "can't allocate descriptors\n");
>  		goto err;
>  	}
>
> @@ -764,14 +766,14 @@ ath5k_attach(struct pci_dev *pdev, struct
> ieee80211_hw *hw) */
>  	ret = ath5k_beaconq_setup(ah);
>  	if (ret < 0) {
> -		dev_err(&pdev->dev, "can't setup a beacon xmit queue\n");
> +		AR5K_ERR(sc, "can't setup a beacon xmit queue\n");
>  		goto err_desc;
>  	}
>  	sc->bhalq = ret;
>
>  	sc->txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
>  	if (IS_ERR(sc->txq)) {
> -		dev_err(&pdev->dev, "can't setup xmit queue\n");
> +		AR5K_ERR(sc, "can't setup xmit queue\n");
>  		ret = PTR_ERR(sc->txq);
>  		goto err_bhal;
>  	}
> @@ -810,7 +812,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw
> *hw)
>
>  	ret = ieee80211_register_hw(hw);
>  	if (ret) {
> -		dev_err(&pdev->dev, "can't register ieee80211 hw\n");
> +		AR5K_ERR(sc, "can't register ieee80211 hw\n");
>  		goto err_queues;
>  	}
>
> @@ -944,7 +946,7 @@ ath5k_copy_channels(struct ath5k_hw *ah,
>  		chfreq = CHANNEL_2GHZ;
>  		break;
>  	default:
> -		printk(KERN_WARNING "bad mode, not copying channels\n");
> +		AR5K_WARN(ah->ah_sc, "bad mode, not copying channels\n");
>  		return 0;
>  	}
>
> @@ -998,7 +1000,7 @@ ath5k_register_mode(struct ieee80211_hw *hw, u8 m)
>  			continue;
>  		ret = ieee80211_register_hwmode(hw, &modes[i]);
>  		if (ret) {
> -			printk(KERN_ERR "can't register hwmode %u\n", m);
> +			AR5K_ERR(sc, "can't register hwmode %u\n", m);
>  			return ret;
>  		}
>  		return 0;
> @@ -1094,7 +1096,7 @@ ath5k_chan_set(struct ath5k_softc *sc, struct
> ieee80211_channel *chan) ath5k_rx_stop(sc);		/* turn off frame recv */
>  		ret = ath5k_hw_reset(ah, sc->opmode, chan, true);
>  		if (ret) {
> -			printk(KERN_ERR "%s: unable to reset channel %u "
> +			AR5K_ERR(sc, "%s: unable to reset channel %u "
>  				"(%u Mhz)\n", __func__, chan->chan, chan->freq);
>  			return ret;
>  		}
> @@ -1106,7 +1108,7 @@ ath5k_chan_set(struct ath5k_softc *sc, struct
> ieee80211_channel *chan) */
>  		ret = ath5k_rx_start(sc);
>  		if (ret) {
> -			printk(KERN_ERR "%s: unable to restart recv logic\n",
> +			AR5K_ERR(sc, "%s: unable to restart recv logic\n",
>  					__func__);
>  			return ret;
>  		}
> @@ -1232,7 +1234,7 @@ ath5k_desc_alloc(struct ath5k_softc *sc, struct
> pci_dev *pdev) (ATH_TXBUF + ATH_RXBUF + ATH_BCBUF + 1);
>  	sc->desc = pci_alloc_consistent(pdev, sc->desc_len, &sc->desc_daddr);
>  	if (sc->desc == NULL) {
> -		dev_err(&pdev->dev, "can't allocate descriptors\n");
> +		AR5K_ERR(sc, "can't allocate descriptors\n");
>  		ret = -ENOMEM;
>  		goto err;
>  	}
> @@ -1244,7 +1246,7 @@ ath5k_desc_alloc(struct ath5k_softc *sc, struct
> pci_dev *pdev) bf = kcalloc(1 + ATH_TXBUF + ATH_RXBUF + ATH_BCBUF,
>  			sizeof(struct ath5k_buf), GFP_KERNEL);
>  	if (bf == NULL) {
> -		dev_err(&pdev->dev, "can't allocate bufptr\n");
> +		AR5K_ERR(sc, "can't allocate bufptr\n");
>  		ret = -ENOMEM;
>  		goto err_free;
>  	}
> @@ -1320,7 +1322,7 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct
> ath5k_buf *bf) */
>  		skb = dev_alloc_skb(sc->rxbufsize + sc->cachelsz - 1);
>  		if (unlikely(skb == NULL)) {
> -			printk(KERN_ERR "ath: can't alloc skbuff of size %u\n",
> +			AR5K_ERR(sc, "can't alloc skbuff of size %u\n",
>  					sc->rxbufsize + sc->cachelsz - 1);
>  			return -ENOMEM;
>  		}
> @@ -1337,7 +1339,7 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct
> ath5k_buf *bf) bf->skbaddr = pci_map_single(sc->pdev,
>  			skb->data, sc->rxbufsize, PCI_DMA_FROMDEVICE);
>  		if (unlikely(pci_dma_mapping_error(bf->skbaddr))) {
> -			printk(KERN_ERR "%s: DMA mapping failed\n", __func__);
> +			AR5K_ERR(sc, "%s: DMA mapping failed\n", __func__);
>  			dev_kfree_skb(skb);
>  			bf->skb = NULL;
>  			return -ENOMEM;
> @@ -1482,7 +1484,7 @@ ath5k_txq_setup(struct ath5k_softc *sc,
>  		return ERR_PTR(qnum);
>  	}
>  	if (qnum >= ARRAY_SIZE(sc->txqs)) {
> -		printk(KERN_ERR "hw qnum %u out of range, max %tu!\n",
> +		AR5K_ERR(sc, "hw qnum %u out of range, max %tu!\n",
>  			qnum, ARRAY_SIZE(sc->txqs));
>  		ath5k_hw_release_tx_queue(ah, qnum);
>  		return ERR_PTR(-EINVAL);
> @@ -1535,7 +1537,7 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
>
>  	ret = ath5k_hw_setup_tx_queueprops(ah, sc->bhalq, &qi);
>  	if (ret) {
> -		printk(KERN_ERR "%s: unable to update parameters for beacon "
> +		AR5K_ERR(sc, "%s: unable to update parameters for beacon "
>  			"hardware queue!\n", __func__);
>  		return ret;
>  	}
> @@ -1680,7 +1682,7 @@ ath5k_rx_stop(struct ath5k_softc *sc)
>  		struct ath5k_buf *bf;
>  		int status;
>
> -		printk(KERN_DEBUG "%s: rx queue %x, link %p\n", __func__,
> +		AR5K_DBG(sc, "%s: rx queue %x, link %p\n", __func__,
>  			ath5k_hw_get_rx_buf(ah), sc->rxlink);
>
>  		spin_lock_bh(&sc->rxbuflock);
> @@ -1740,7 +1742,7 @@ ath5k_tasklet_rx(unsigned long data)
>  	do {
>  		if (unlikely(list_empty(&sc->rxbuf))) {
>  			if (net_ratelimit())
> -				printk(KERN_WARNING "ath: empty rx buf pool\n");
> +				AR5K_WARN(sc, "empty rx buf pool\n");
>  			break;
>  		}
>  		bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
> @@ -1760,14 +1762,14 @@ ath5k_tasklet_rx(unsigned long data)
>  			break;
>  		else if (unlikely(ret)) {
>  			if (net_ratelimit())
> -				printk(KERN_ERR "ath: error in processing rx "
> +				AR5K_ERR(sc, "error in processing rx "
>  					"descriptor\n");
>  			return;
>  		}
>
>  		if (unlikely(ds->ds_rxstat.rs_more)) {
>  			if (net_ratelimit())
> -				printk(KERN_INFO "ath: unsupported jumbo\n");
> +				AR5K_INFO(sc, "unsupported jumbo\n");
>  			goto next;
>  		}
>
> @@ -1874,8 +1876,8 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct
> ath5k_txq *txq) if (unlikely(ret == -EINPROGRESS))
>  			break;
>  		else if (unlikely(ret)) {
> -			printk(KERN_ERR "ath: error %d while processing "
> -				"queue %u\n", ret, txq->qnum);
> +			AR5K_ERR(sc, "error %d while processing queue %u\n",
> +				ret, txq->qnum);
>  			break;
>  		}
>
> @@ -1950,7 +1952,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct
> ath5k_buf *bf, "skbaddr %llx\n", __func__, skb, skb->data, skb->len,
>  			(unsigned long long)bf->skbaddr);
>  	if (pci_dma_mapping_error(bf->skbaddr)) {
> -		printk(KERN_ERR "ath: beacon DMA mapping failed\n");
> +		AR5K_ERR(sc, "beacon DMA mapping failed\n");
>  		return -EIO;
>  	}
>
> @@ -2006,8 +2008,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
>
>  	if (unlikely(bf->skb == NULL || sc->opmode == IEEE80211_IF_TYPE_STA ||
>  			sc->opmode == IEEE80211_IF_TYPE_MNTR)) {
> -		printk(KERN_WARNING "ath: bf=%p bf_skb=%p\n", bf,
> -				bf ? bf->skb : NULL);
> +		AR5K_WARN(sc, "bf=%p bf_skb=%p\n", bf, bf ? bf->skb : NULL);
>  		return;
>  	}
>  	/*
> @@ -2043,8 +2044,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
>  	 * are still pending on the queue.
>  	 */
>  	if (unlikely(ath5k_hw_stop_tx_dma(ah, sc->bhalq))) {
> -		printk(KERN_WARNING "ath: beacon queue %u didn't stop?\n",
> -				sc->bhalq);
> +		AR5K_WARN(sc, "beacon queue %u didn't stop?\n", sc->bhalq);
>  		/* NB: hw still stops DMA, so proceed */
>  	}
>  	pci_dma_sync_single_for_cpu(sc->pdev, bf->skbaddr, bf->skb->len,
> @@ -2184,7 +2184,7 @@ ath5k_init(struct ath5k_softc *sc)
>  	sc->curchan = sc->hw->conf.chan;
>  	ret = ath5k_hw_reset(sc->ah, sc->opmode, sc->curchan, false);
>  	if (ret) {
> -		printk(KERN_ERR "unable to reset hardware: %d\n", ret);
> +		AR5K_ERR(sc, "unable to reset hardware: %d\n", ret);
>  		goto done;
>  	}
>  	/*
> @@ -2377,8 +2377,7 @@ ath5k_intr(int irq, void *dev_id)
>  	} while (ath5k_hw_is_intr_pending(ah) && counter-- > 0);
>
>  	if (unlikely(!counter && net_ratelimit()))
> -		printk(KERN_WARNING "ath: too many interrupts, giving up for "
> -				"now\n");
> +		AR5K_WARN(sc, "too many interrupts, giving up for now\n");
>
>  	return IRQ_HANDLED;
>  }
> @@ -2419,7 +2418,7 @@ ath5k_calibrate(unsigned long data)
>  		ath5k_reset(sc->hw);
>  	}
>  	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
> -		printk(KERN_ERR "ath: calibration of channel %u failed\n",
> +		AR5K_ERR(sc, "calibration of channel %u failed\n",
>  				sc->curchan->chan);
>
>  	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
> @@ -2511,7 +2510,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff
> *skb, pad = hdrlen % 4;
>  		if (skb_headroom(skb) < pad) {
>  			if (net_ratelimit())
> -				printk(KERN_ERR "ath: tx hdrlen not %%4: %d "
> +				AR5K_ERR(sc, "tx hdrlen not %%4: %d "
>  					"not enough headroom to pad %d\n",
>  					hdrlen, pad);
>  			return -1;
> @@ -2525,7 +2524,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff
> *skb, spin_lock_irqsave(&sc->txbuflock, flags);
>  	if (list_empty(&sc->txbuf)) {
>  		if (net_ratelimit())
> -			printk(KERN_ERR "ath: no further txbuf available, "
> +			AR5K_ERR(sc, "no further txbuf available, "
>  				"dropping packet\n");
>  		spin_unlock_irqrestore(&sc->txbuflock, flags);
>  		ieee80211_stop_queue(hw, ctl->queue);
> @@ -2573,14 +2572,14 @@ ath5k_reset(struct ieee80211_hw *hw)
>
>  	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
>  	if (unlikely(ret)) {
> -		printk(KERN_ERR "ath: can't reset hardware (%d)\n", ret);
> +		AR5K_ERR(sc, "can't reset hardware (%d)\n", ret);
>  		goto err;
>  	}
>  	ath5k_update_txpow(sc);
>
>  	ret = ath5k_rx_start(sc);
>  	if (unlikely(ret)) {
> -		printk(KERN_ERR "ath: can't start recv logic\n");
> +		AR5K_ERR(sc, "can't start recv logic\n");
>  		goto err;
>  	}
>  	/*
> @@ -2845,7 +2844,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum
> set_key_cmd cmd, case SET_KEY:
>  		ret = ath5k_hw_set_key(sc->ah, key->keyidx, key, addr);
>  		if (ret) {
> -			printk(KERN_ERR "ath: can't set the key\n");
> +			AR5K_ERR(sc, "can't set the key\n");
>  			goto unlock;
>  		}
>  		__set_bit(key->keyidx, sc->keymap);
> diff --git a/drivers/net/wireless/ath5k/hw.c
> b/drivers/net/wireless/ath5k/hw.c index e7fecbb..1031487 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
> @@ -128,7 +128,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc
> *sc, u8 mac_version) ah = kzalloc(sizeof(struct ath5k_hw), GFP_KERNEL);
>  	if (ah == NULL) {
>  		ret = -ENOMEM;
> -		AR5K_PRINT("out of memory\n");
> +		AR5K_ERR(sc, "out of memory\n");
>  		goto err;
>  	}
>
> @@ -203,14 +203,14 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc
> *sc, u8 mac_version)
>
>  	/* Return on unsuported chips (unsupported eeprom etc) */
>  	if(srev >= AR5K_SREV_VER_AR5416){
> -		printk(KERN_ERR "ath5k: Device not yet supported.\n");
> +		AR5K_ERR(sc, "Device not yet supported.\n");
>  		ret = -ENODEV;
>  		goto err_free;
>  	}
>
>  	/* Warn for partially supported chips (unsupported phy etc) */
>  	if(srev >= AR5K_SREV_VER_AR2424){
> -		printk(KERN_DEBUG "ath5k: Device partially supported.\n");
> +		AR5K_WARN(sc, "Device only partially supported.\n");
>  	}
>
>  	/* Identify single chip solutions */
> @@ -248,14 +248,14 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc
> *sc, u8 mac_version)
>
>  	ret = ath5k_eeprom_init(ah);
>  	if (ret) {
> -		AR5K_PRINT("unable to init EEPROM\n");
> +		AR5K_ERR(sc, "unable to init EEPROM\n");
>  		goto err_free;
>  	}
>
>  	/* Get misc capabilities */
>  	ret = ath5k_hw_get_capabilities(ah);
>  	if (ret) {
> -		AR5K_PRINTF("unable to get device capabilities: 0x%04x\n",
> +		AR5K_ERR(sc, "unable to get device capabilities: 0x%04x\n",
>  			sc->pdev->device);
>  		goto err_free;
>  	}
> @@ -263,7 +263,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc
> *sc, u8 mac_version) /* Get MAC address */
>  	ret = ath5k_eeprom_read_mac(ah, mac);
>  	if (ret) {
> -		AR5K_PRINTF("unable to read address from EEPROM: 0x%04x\n",
> +		AR5K_ERR(sc, "unable to read address from EEPROM: 0x%04x\n",
>  			sc->pdev->device);
>  		goto err_free;
>  	}
> @@ -328,7 +328,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int
> flags, bool initial) else
>  					mode |= AR5K_PHY_MODE_MOD_DYN;
>  			} else {
> -				AR5K_PRINT("invalid radio modulation mode\n");
> +				AR5K_ERR(ah->ah_sc, "invalid radio modulation mode\n");
>  				return -EINVAL;
>  			}
>  		} else if (flags & CHANNEL_5GHZ) {
> @@ -338,11 +338,11 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah,
> int flags, bool initial) if (flags & CHANNEL_OFDM)
>  				mode |= AR5K_PHY_MODE_MOD_OFDM;
>  			else {
> -				AR5K_PRINT("invalid radio modulation mode\n");
> +				AR5K_ERR(ah->ah_sc, "invalid radio modulation mode\n");
>  				return -EINVAL;
>  			}
>  		} else {
> -			AR5K_PRINT("invalid radio frequency mode\n");
> +			AR5K_ERR(ah->ah_sc, "invalid radio frequency mode\n");
>  			return -EINVAL;
>  		}
>
> @@ -352,7 +352,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int
> flags, bool initial) if (initial == true) {
>  			/* ...reset hardware */
>  			if (ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCI)) {
> -				AR5K_PRINT("failed to reset the PCI chipset\n");
> +				AR5K_ERR(ah->ah_sc, "failed to reset the PCI chipset\n");
>  				return -EIO;
>  			}
>
> @@ -362,7 +362,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int
> flags, bool initial) /* ...wakeup */
>  		ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
>  		if (ret) {
> -			AR5K_PRINT("failed to resume the MAC Chip\n");
> +			AR5K_ERR(ah->ah_sc, "failed to resume the MAC Chip\n");
>  			return ret;
>  		}
>
> @@ -373,7 +373,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int
> flags, bool initial)
>
>  		/* ...reset chipset */
>  		if (ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_CHIP)) {
> -			AR5K_PRINT("failed to reset the AR5210 chipset\n");
> +			AR5K_ERR(ah->ah_sc, "failed to reset the AR5210 chipset\n");
>  			return -EIO;
>  		}
>
> @@ -383,7 +383,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int
> flags, bool initial) /* ...reset chipset and PCI device */
>  	if (ah->ah_single_chip == false && ath5k_hw_nic_reset(ah,
>  				AR5K_RESET_CTL_CHIP | AR5K_RESET_CTL_PCI)) {
> -		AR5K_PRINT("failed to reset the MAC Chip + PCI\n");
> +		AR5K_ERR(ah->ah_sc, "failed to reset the MAC Chip + PCI\n");
>  		return -EIO;
>  	}
>
> @@ -393,13 +393,13 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah,
> int flags, bool initial) /* ...wakeup */
>  	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
>  	if (ret) {
> -		AR5K_PRINT("failed to resume the MAC Chip\n");
> +		AR5K_ERR(ah->ah_sc, "failed to resume the MAC Chip\n");
>  		return ret;
>  	}
>
>  	/* ...final warm reset */
>  	if (ath5k_hw_nic_reset(ah, 0)) {
> -		AR5K_PRINT("failed to warm reset the MAC Chip\n");
> +		AR5K_ERR(ah->ah_sc, "failed to warm reset the MAC Chip\n");
>  		return -EIO;
>  	}
>
> @@ -643,7 +643,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum
> ieee80211_if_types op_mode, if (ah->ah_radio != AR5K_RF5111 &&
>  			ah->ah_radio != AR5K_RF5112 &&
>  			ah->ah_radio != AR5K_RF5413) {
> -			AR5K_PRINTF("invalid phy radio: %u\n", ah->ah_radio);
> +			AR5K_ERR(ah->ah_sc, "invalid phy radio: %u\n", ah->ah_radio);
>  			return -EINVAL;
>  		}
>
> @@ -681,7 +681,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum
> ieee80211_if_types op_mode, break;
>  		case CHANNEL_XR:
>  			if (ah->ah_version == AR5K_AR5211) {
> -				AR5K_PRINTF("XR mode not available on 5211");
> +				AR5K_ERR(ah->ah_sc, "XR mode not available on 5211");
>  				return -EINVAL;
>  			}
>  			mode = AR5K_INI_VAL_XR;
> @@ -690,7 +690,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum
> ieee80211_if_types op_mode, driver_mode = MODE_IEEE80211A;
>  			break;
>  		default:
> -			AR5K_PRINTF("invalid channel: %d\n", channel->freq);
> +			AR5K_ERR(ah->ah_sc, "invalid channel: %d\n", channel->freq);
>  			return -EINVAL;
>  		}
>
> @@ -905,7 +905,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum
> ieee80211_if_types op_mode,
>
>  	if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
>  			AR5K_PHY_AGCCTL_CAL, 0, false)) {
> -		AR5K_PRINTF("calibration timeout (%uMHz)\n", channel->freq);
> +		AR5K_ERR(ah->ah_sc, "calibration timeout (%uMHz)\n", channel->freq);
>  		return -EAGAIN;
>  	}
>
> @@ -917,7 +917,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum
> ieee80211_if_types op_mode,
>
>  	if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
>  			AR5K_PHY_AGCCTL_NF, 0, false)) {
> -		AR5K_PRINTF("noise floor calibration timeout (%uMHz)\n",
> +		AR5K_ERR(ah->ah_sc, "noise floor calibration timeout (%uMHz)\n",
>  				channel->freq);
>  		return -EAGAIN;
>  	}
> @@ -935,7 +935,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum
> ieee80211_if_types op_mode, }
>
>  	if (noise_floor > AR5K_TUNE_NOISE_FLOOR) {
> -		AR5K_PRINTF("noise floor calibration failed (%uMHz)\n",
> +		AR5K_ERR(ah->ah_sc, "noise floor calibration failed (%uMHz)\n",
>  			channel->freq);
>  		return -EIO;
>  	}
> @@ -962,7 +962,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum
> ieee80211_if_types op_mode,
>
>  		ret = ath5k_hw_reset_tx_queue(ah, i);
>  		if (ret) {
> -			AR5K_PRINTF("failed to reset TX queue #%d\n", i);
> +			AR5K_ERR(ah->ah_sc, "failed to reset TX queue #%d\n", i);
>  			return ret;
>  		}
>  	}
> @@ -1856,7 +1856,7 @@ static int ath5k_eeprom_init(struct ath5k_hw *ah)
>  		cksum ^= val;
>  	}
>  	if (cksum != AR5K_EEPROM_INFO_CKSUM) {
> -		AR5K_PRINTF("Invalid EEPROM checksum 0x%04x\n", cksum);
> +		AR5K_ERR(ah->ah_sc, "Invalid EEPROM checksum 0x%04x\n", cksum);
>  		return -EIO;
>  	}
>  #endif
> @@ -3092,8 +3092,8 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum
> ath5k_tx_queue queue_type, break;
>  		case AR5K_TX_QUEUE_XR_DATA:
>  			if (ah->ah_version != AR5K_AR5212)
> -				AR5K_PRINTF("XR data queues only supported in "
> -						"5212!\n");
> +				AR5K_ERR(ah->ah_sc,
> +					"XR data queues only supported in 5212!\n");
>  			queue = AR5K_TX_QUEUE_ID_XR_DATA;
>  			break;
>  		default:
> @@ -4234,7 +4234,7 @@ ath5k_hw_dump_state(struct ath5k_hw *ah)
>  #define AR5K_PRINT_REGISTER(_x)						\
>  	AR5K_PRINTF("(%s: %08x) ", #_x, ath5k_hw_reg_read(ah, AR5K_##_x));
>
> -	AR5K_PRINT("MAC registers:\n");
> +	AR5K_PRINTF("MAC registers:\n");
>  	AR5K_PRINT_REGISTER(CR);
>  	AR5K_PRINT_REGISTER(CFG);
>  	AR5K_PRINT_REGISTER(IER);
> @@ -4322,7 +4322,7 @@ ath5k_hw_dump_state(struct ath5k_hw *ah)
>  	AR5K_PRINT_REGISTER(PHY_RADAR);
>  	AR5K_PRINT_REGISTER(PHY_ANT_SWITCH_TABLE_0);
>  	AR5K_PRINT_REGISTER(PHY_ANT_SWITCH_TABLE_1);
> -	AR5K_PRINT("\n");
> +	AR5K_PRINTF("\n");
>  #endif
>  }
>
> diff --git a/drivers/net/wireless/ath5k/phy.c
> b/drivers/net/wireless/ath5k/phy.c index 79015ab..8a78f5f 100644
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
> @@ -879,11 +880,9 @@ static s32 ath5k_hw_rfregs_gain_adjust(struct ath5k_hw
> *ah) }
>
>  done:
> -#ifdef AR5K_DEBUG
> -	AR5K_PRINTF("ret %d, gain step %u, current gain %u, target gain %u\n",
> +	AR5K_DBG("ret %d, gain step %u, current gain %u, target gain %u\n",
>  		ret, ah->ah_gain.g_step_idx, ah->ah_gain.g_current,
>  		ah->ah_gain.g_target);
> -#endif
>
>  	return ret;
>  }
> @@ -908,7 +907,7 @@ static int ath5k_hw_rf5111_rfregs(struct ath5k_hw *ah,
>  	/* Copy values to modify them */
>  	for (i = 0; i < rf_size; i++) {
>  		if (rfregs_5111[i].rf_bank >= AR5K_RF5111_INI_RF_MAX_BANKS) {
> -			AR5K_PRINT("invalid bank\n");
> +			AR5K_ERR(ah->ah_sc, "invalid bank\n");
>  			return -EINVAL;
>  		}
>
> @@ -1017,7 +1016,7 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw
> *ah, /* Copy values to modify them */
>  	for (i = 0; i < rf_size; i++) {
>  		if (rf_ini[i].rf_bank >= AR5K_RF5112_INI_RF_MAX_BANKS) {
> -			AR5K_PRINT("invalid bank\n");
> +			AR5K_ERR(ah->ah_sc, "invalid bank\n");
>  			return -EINVAL;
>  		}
>
> @@ -1105,7 +1104,7 @@ static int ath5k_hw_rf5413_rfregs(struct ath5k_hw
> *ah, /* Copy values to modify them */
>  	for (i = 0; i < rf_size; i++) {
>  		if (rf_ini[i].rf_bank >= AR5K_RF5112_INI_RF_MAX_BANKS) {
> -			AR5K_PRINT("invalid bank\n");
> +			AR5K_ERR(ah->ah_sc, "invalid bank\n");
>  			return -EINVAL;
>  		}
>
> @@ -1167,7 +1166,7 @@ int ath5k_hw_rfregs(struct ath5k_hw *ah, struct
> ieee80211_channel *channel, /* XXX do extra checks? */
>  		ah->ah_rf_banks = kmalloc(ah->ah_rf_banks_size, GFP_KERNEL);
>  		if (ah->ah_rf_banks == NULL) {
> -			AR5K_PRINT("out of memory\n");
> +			AR5K_ERR(ah->ah_sc, "out of memory\n");
>  			return -ENOMEM;
>  		}
>  	}
> @@ -1484,7 +1483,7 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct
> ieee80211_channel *channel) channel->freq >
> ah->ah_capabilities.cap_range.range_2ghz_max) && (channel->freq <
> ah->ah_capabilities.cap_range.range_5ghz_min || channel->freq >
> ah->ah_capabilities.cap_range.range_5ghz_max)) { -		AR5K_PRINTF("channel
> out of supported range (%u MHz)\n",
> +		AR5K_ERR(ah->ah_sc, "channel out of supported range (%u MHz)\n",
>  			channel->freq);
>  		return -EINVAL;
>  	}
> @@ -1605,7 +1604,8 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw
> *ah, ath5k_hw_reg_write(ah, phy_sat, AR5K_PHY_ADCSAT);
>
>  	if (ret) {
> -		AR5K_PRINTF("calibration timeout (%uMHz)\n", channel->freq);
> +		AR5K_ERR(ah->ah_sc, "calibration timeout (%uMHz)\n",
> +				channel->freq);
>  		return ret;
>  	}
>
> @@ -1617,7 +1617,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw
> *ah, ret = ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
>  			AR5K_PHY_AGCCTL_NF, 0, false);
>  	if (ret) {
> -		AR5K_PRINTF("noise floor calibration timeout (%uMHz)\n",
> +		AR5K_ERR(ah->ah_sc, "noise floor calibration timeout (%uMHz)\n",
>  				channel->freq);
>  		return ret;
>  	}
> @@ -1635,7 +1635,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw
> *ah, }
>
>  	if (noise_floor > AR5K_TUNE_NOISE_FLOOR) {
> -		AR5K_PRINTF("noise floor calibration failed (%uMHz)\n",
> +		AR5K_ERR(ah->ah_sc, "noise floor calibration failed (%uMHz)\n",
>  			channel->freq);
>  		return -EIO;
>  	}
> @@ -1847,7 +1847,7 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct
> ieee80211_channel *channel,
>
>  	AR5K_TRACE;
>  	if (txpower > AR5K_TUNE_MAX_TXPOWER) {
> -		AR5K_PRINTF("invalid tx power: %u\n", txpower);
> +		AR5K_ERR(ah->ah_sc, "invalid tx power: %u\n", txpower);
>  		return -EINVAL;
>  	}
>
> @@ -1900,8 +1900,7 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah,
> unsigned int power) struct ieee80211_channel *channel =
> &ah->ah_current_channel;
>
>  	AR5K_TRACE;
> -#ifdef AR5K_DEBUG
> -	AR5K_PRINTF("changing txpower to %d\n", power);
> -#endif
> +	AR5K_DBG(ah->ah_sc, "changing txpower to %d\n", power);
> +
>  	return ath5k_hw_txpower(ah, channel, power);
>  }


