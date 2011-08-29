Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45886 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab1H2Jbi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 05:31:38 -0400
Message-ID: <4E5B5C74.50202@openwrt.org> (sfid-20110829_113149_172716_60445230)
Date: Mon, 29 Aug 2011 11:31:32 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH v3 2/3] ath9k: merge reset related functions
References: <1314604701-65802-1-git-send-email-nbd@openwrt.org> <1314604701-65802-2-git-send-email-nbd@openwrt.org> <20110829091050.GA31112@vmraj-lnx.users.atheros.com>
In-Reply-To: <20110829091050.GA31112@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-29 11:10 AM, Rajkumar Manoharan wrote:
> On Mon, Aug 29, 2011 at 09:58:20AM +0200, Felix Fietkau wrote:
>>  reduces unnecessary code duplication
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  ---
>>   drivers/net/wireless/ath/ath9k/main.c |  246 ++++++++++++--------------------
>>   1 files changed, 92 insertions(+), 154 deletions(-)
>>
>>  diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>>  index 085ec20..4b1fe7c 100644
>>  --- a/drivers/net/wireless/ath/ath9k/main.c
>>  +++ b/drivers/net/wireless/ath/ath9k/main.c
>>  @@ -212,83 +212,39 @@ static int ath_update_survey_stats(struct ath_softc *sc)
>>   	return ret;
>>   }
>>
>>  -/*
>>  - * Set/change channels.  If the channel is really being changed, it's done
>>  - * by reseting the chip.  To accomplish this we must first cleanup any pending
>>  - * DMA, then restart stuff.
>>  -*/
>>  -static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
>>  -		    struct ath9k_channel *hchan)
>>  +static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx)
>>   {
>>   	struct ath_hw *ah = sc->sc_ah;
>>  -	struct ath_common *common = ath9k_hw_common(ah);
>>  -	struct ieee80211_conf *conf =&common->hw->conf;
>>  -	bool fastcc = true, stopped;
>>  -	struct ieee80211_channel *channel = hw->conf.channel;
>>  -	struct ath9k_hw_cal_data *caldata = NULL;
>>  -	int r;
>>  +	bool ret;
>>
>>  -	if (sc->sc_flags&  SC_OP_INVALID)
>>  -		return -EIO;
>>  +	ieee80211_stop_queues(sc->hw);
>>
>>   	sc->hw_busy_count = 0;
>>  -
>>  -	del_timer_sync(&common->ani.timer);
> ani timer never be stopped.
>>   	cancel_work_sync(&sc->paprd_work);
>>   	cancel_work_sync(&sc->hw_check_work);
>>   	cancel_delayed_work_sync(&sc->tx_complete_work);
>>   	cancel_delayed_work_sync(&sc->hw_pll_work);
>>
>>  -	ath9k_ps_wakeup(sc);
>>  -
>>  -	spin_lock_bh(&sc->sc_pcu_lock);
>>  -
>>  -	/*
>>  -	 * This is only performed if the channel settings have
>>  -	 * actually changed.
>>  -	 *
>>  -	 * To switch channels clear any pending DMA operations;
>>  -	 * wait long enough for the RX fifo to drain, reset the
>>  -	 * hardware at the new frequency, and then re-enable
>>  -	 * the relevant bits of the h/w.
>>  -	 */
>>   	ath9k_hw_disable_interrupts(ah);
>>  -	stopped = ath_drain_all_txq(sc, false);
>>  -
>>  -	if (!ath_stoprecv(sc))
>>  -		stopped = false;
>>
>>  -	if (!ath9k_hw_check_alive(ah))
>>  -		stopped = false;
>>  +	ret = ath_drain_all_txq(sc, retry_tx);
>>
>>  -	/* XXX: do not flush receive queue here. We don't want
>>  -	 * to flush data frames already in queue because of
>>  -	 * changing channel. */
>>  -
>>  -	if (!stopped || !(sc->sc_flags&  SC_OP_OFFCHANNEL))
>>  -		fastcc = false;
>>  +	if (!ath_stoprecv(sc))
>>  +		ret = false;
>>
>>  -	if (!(sc->sc_flags&  SC_OP_OFFCHANNEL))
>>  -		caldata =&sc->caldata;
>>  +	ath_flushrecv(sc);
> do not flush receive queue here. We don't want to flush data frames already
> in queue because of channel change. Do it only for ath_reset/radio disable.
I thought about that as well, but then I noticed that if the recv queue 
is not flushed, ath_startrecv can pass a non-free rx descriptor pointer 
to the hw after the reset, which might lead to some nasty race conditions.
I'll change the code so that it runs ath_rx_tasklet instead of 
ath_flushrecv when changing the channel, that should make it more safe.

>>  @@ -942,13 +949,7 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
>>   		ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
>>   	}
>>
>>  -	/* Disable interrupts */
>>  -	ath9k_hw_disable_interrupts(ah);
>>  -
>>  -	ath_drain_all_txq(sc, false);	/* clear pending tx frames */
>>  -
>>  -	ath_stoprecv(sc);		/* turn off frame recv */
>>  -	ath_flushrecv(sc);		/* flush recv queue */
>>  +	ath_prepare_reset(sc, false);
> In radio_disable, remove ieee80211_stop_queues, cancel_work before
> calling ath_prepare_reset.
Will do, thanks.

- Felix
