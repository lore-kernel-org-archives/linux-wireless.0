Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45457 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab1H2JKY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 05:10:24 -0400
Date: Mon, 29 Aug 2011 14:40:51 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v3 2/3] ath9k: merge reset related functions
Message-ID: <20110829091050.GA31112@vmraj-lnx.users.atheros.com> (sfid-20110829_111043_569216_A2B9DA02)
References: <1314604701-65802-1-git-send-email-nbd@openwrt.org>
 <1314604701-65802-2-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1314604701-65802-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 09:58:20AM +0200, Felix Fietkau wrote:
> reduces unnecessary code duplication
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |  246 ++++++++++++--------------------
>  1 files changed, 92 insertions(+), 154 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 085ec20..4b1fe7c 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -212,83 +212,39 @@ static int ath_update_survey_stats(struct ath_softc *sc)
>  	return ret;
>  }
>  
> -/*
> - * Set/change channels.  If the channel is really being changed, it's done
> - * by reseting the chip.  To accomplish this we must first cleanup any pending
> - * DMA, then restart stuff.
> -*/
> -static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
> -		    struct ath9k_channel *hchan)
> +static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx)
>  {
>  	struct ath_hw *ah = sc->sc_ah;
> -	struct ath_common *common = ath9k_hw_common(ah);
> -	struct ieee80211_conf *conf = &common->hw->conf;
> -	bool fastcc = true, stopped;
> -	struct ieee80211_channel *channel = hw->conf.channel;
> -	struct ath9k_hw_cal_data *caldata = NULL;
> -	int r;
> +	bool ret;
>  
> -	if (sc->sc_flags & SC_OP_INVALID)
> -		return -EIO;
> +	ieee80211_stop_queues(sc->hw);
>  
>  	sc->hw_busy_count = 0;
> -
> -	del_timer_sync(&common->ani.timer);
ani timer never be stopped.
>  	cancel_work_sync(&sc->paprd_work);
>  	cancel_work_sync(&sc->hw_check_work);
>  	cancel_delayed_work_sync(&sc->tx_complete_work);
>  	cancel_delayed_work_sync(&sc->hw_pll_work);
>  
> -	ath9k_ps_wakeup(sc);
> -
> -	spin_lock_bh(&sc->sc_pcu_lock);
> -
> -	/*
> -	 * This is only performed if the channel settings have
> -	 * actually changed.
> -	 *
> -	 * To switch channels clear any pending DMA operations;
> -	 * wait long enough for the RX fifo to drain, reset the
> -	 * hardware at the new frequency, and then re-enable
> -	 * the relevant bits of the h/w.
> -	 */
>  	ath9k_hw_disable_interrupts(ah);
> -	stopped = ath_drain_all_txq(sc, false);
> -
> -	if (!ath_stoprecv(sc))
> -		stopped = false;
>  
> -	if (!ath9k_hw_check_alive(ah))
> -		stopped = false;
> +	ret = ath_drain_all_txq(sc, retry_tx);
>  
> -	/* XXX: do not flush receive queue here. We don't want
> -	 * to flush data frames already in queue because of
> -	 * changing channel. */
> -
> -	if (!stopped || !(sc->sc_flags & SC_OP_OFFCHANNEL))
> -		fastcc = false;
> +	if (!ath_stoprecv(sc))
> +		ret = false;
>  
> -	if (!(sc->sc_flags & SC_OP_OFFCHANNEL))
> -		caldata = &sc->caldata;
> +	ath_flushrecv(sc);
do not flush receive queue here. We don't want to flush data frames already
in queue because of channel change. Do it only for ath_reset/radio disable. 
> -      * changing channel
>  
> -	ath_dbg(common, ATH_DBG_CONFIG,
> -		"(%u MHz) -> (%u MHz), conf_is_ht40: %d fastcc: %d\n",
> -		sc->sc_ah->curchan->channel,
> -		channel->center_freq, conf_is_ht40(conf),
> -		fastcc);
> +	return ret;
> +}
>  
> -	r = ath9k_hw_reset(ah, hchan, caldata, fastcc);
> -	if (r) {
> -		ath_err(common,
> -			"Unable to reset channel (%u MHz), reset status %d\n",
> -			channel->center_freq, r);
> -		goto ps_restore;
> -	}
> +static bool ath_complete_reset(struct ath_softc *sc, bool start)
> +{
> +	struct ath_hw *ah = sc->sc_ah;
> +	struct ath_common *common = ath9k_hw_common(ah);
>  
>  	if (ath_startrecv(sc) != 0) {
>  		ath_err(common, "Unable to restart recv logic\n");
> -		r = -EIO;
> -		goto ps_restore;
> +		return false;
>  	}
>  
>  	ath9k_cmn_update_txpow(ah, sc->curtxpow,
> @@ -296,21 +252,87 @@ static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
>  	ath9k_hw_set_interrupts(ah, ah->imask);
>  	ath9k_hw_enable_interrupts(ah);
>  
> -	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL))) {
> +	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL)) && start) {
>  		if (sc->sc_flags & SC_OP_BEACONS)
>  			ath_set_beacon(sc);
> +
>  		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
>  		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work, HZ/2);
>  		if (!common->disable_ani)
>  			ath_start_ani(common);
>  	}
>  
> - ps_restore:
> -	ieee80211_wake_queues(hw);
> +	ieee80211_wake_queues(sc->hw);
> +
> +	return true;
> +}
> +
> +static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
> +			      bool retry_tx)
> +{
> +	struct ath_hw *ah = sc->sc_ah;
> +	struct ath_common *common = ath9k_hw_common(ah);
> +	struct ath9k_hw_cal_data *caldata = NULL;
> +	bool fastcc = true;
> +	int r;
> +
> +	if (!(sc->sc_flags & SC_OP_OFFCHANNEL)) {
> +		fastcc = false;
> +		caldata = &sc->caldata;
> +	}
> +
> +	if (!hchan) {
> +		fastcc = false;
> +		hchan = ah->curchan;
> +	}
> +
> +	if (fastcc && !ath9k_hw_check_alive(ah))
> +		fastcc = false;
> +
> +	if (!ath_prepare_reset(sc, retry_tx))
> +		fastcc = false;
> +
> +	ath_dbg(common, ATH_DBG_CONFIG,
> +		"Reset to %u MHz, HT40: %d fastcc: %d\n",
> +		hchan->channel, !!(hchan->channelFlags & (CHANNEL_HT40MINUS |
> +							  CHANNEL_HT40PLUS)),
> +		fastcc);
> +
> +	r = ath9k_hw_reset(ah, hchan, caldata, fastcc);
> +	if (r) {
> +		ath_err(common,
> +			"Unable to reset channel, reset status %d\n", r);
> +		return r;
> +	}
> +
> +	if (!ath_complete_reset(sc, true))
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +
> +/*
> + * Set/change channels.  If the channel is really being changed, it's done
> + * by reseting the chip.  To accomplish this we must first cleanup any pending
> + * DMA, then restart stuff.
> +*/
> +static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
> +		    struct ath9k_channel *hchan)
> +{
> +	int r;
> +
> +	if (sc->sc_flags & SC_OP_INVALID)
> +		return -EIO;
>  
> +	ath9k_ps_wakeup(sc);
> +
> +	spin_lock_bh(&sc->sc_pcu_lock);
> +	r = ath_reset_internal(sc, hchan, false);
>  	spin_unlock_bh(&sc->sc_pcu_lock);
>  
>  	ath9k_ps_restore(sc);
> +
>  	return r;
>  }
>  
> @@ -893,28 +915,13 @@ static void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
>  			channel->center_freq, r);
>  	}
>  
> -	ath9k_cmn_update_txpow(ah, sc->curtxpow,
> -			       sc->config.txpowlimit, &sc->curtxpow);
> -	if (ath_startrecv(sc) != 0) {
> -		ath_err(common, "Unable to restart recv logic\n");
> -		goto out;
> -	}
> -	if (sc->sc_flags & SC_OP_BEACONS)
> -		ath_set_beacon(sc);	/* restart beacons */
> -
> -	/* Re-Enable  interrupts */
> -	ath9k_hw_set_interrupts(ah, ah->imask);
> -	ath9k_hw_enable_interrupts(ah);
> +	ath_complete_reset(sc, true);
>  
>  	/* Enable LED */
>  	ath9k_hw_cfg_output(ah, ah->led_pin,
>  			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
>  	ath9k_hw_set_gpio(ah, ah->led_pin, 0);
>  
> -	ieee80211_wake_queues(hw);
> -	ieee80211_queue_delayed_work(hw, &sc->hw_pll_work, HZ/2);
> -
> -out:
>  	spin_unlock_bh(&sc->sc_pcu_lock);
>  
>  	ath9k_ps_restore(sc);
> @@ -942,13 +949,7 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
>  		ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
>  	}
>  
> -	/* Disable interrupts */
> -	ath9k_hw_disable_interrupts(ah);
> -
> -	ath_drain_all_txq(sc, false);	/* clear pending tx frames */
> -
> -	ath_stoprecv(sc);		/* turn off frame recv */
> -	ath_flushrecv(sc);		/* flush recv queue */
> +	ath_prepare_reset(sc, false);
In radio_disable, remove ieee80211_stop_queues, cancel_work before
calling ath_prepare_reset.
>  
>  	if (!ah->curchan)
>  		ah->curchan = ath9k_cmn_get_curchannel(hw, ah);
> @@ -970,48 +971,11 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
>  
>  int ath_reset(struct ath_softc *sc, bool retry_tx)
>  {
> -	struct ath_hw *ah = sc->sc_ah;
--
Rajkumar
