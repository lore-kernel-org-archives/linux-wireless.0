Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36141 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933Ab2CMVvl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 17:51:41 -0400
Message-ID: <4F5FC165.9010100@openwrt.org> (sfid-20120313_225146_159964_BC4BADAF)
Date: Tue, 13 Mar 2012 22:51:33 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Paul Stewart <pstew@google.com>
Subject: Re: [PATCH RESEND 2/2] ath9k: recover ar9380 chips from rare stuck
 state
References: <1331674733-10580-1-git-send-email-rmanohar@qca.qualcomm.com> <1331674733-10580-2-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1331674733-10580-2-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-13 10:38 PM, Rajkumar Manoharan wrote:
> In the experiment with Azimuth ADEPT-n testbed where the APs transmit
> power was reduced to 25% and the signal strength was futher attenuated
> by 20dB and induced a path loss of ~7dB, the station was reporting
> beacon losses and the following issue were observed.
> 
> * rx clear is stuck at low for more than 100ms
> * dcu chain and complete state is stuck at one of the hang signature
> 
> This patch triggers the hang detection logic that recovers the chip
> from any of the above conditions. As the issue was originally reported
> in ChromeOs with AR9382 chips, this detection logic is enabled only for
> AR9380/2 chips.
> 
> Cc: Paul Stewart <pstew@google.com>
> Reported-by: Gary Morain <gmorain@google.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath.h         |    1 +
>  drivers/net/wireless/ath/ath9k/ath9k.h |    3 ++
>  drivers/net/wireless/ath/ath9k/hw.c    |   71 ++++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/hw.h    |    1 +
>  drivers/net/wireless/ath/ath9k/init.c  |    1 +
>  drivers/net/wireless/ath/ath9k/main.c  |   66 +++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/recv.c  |    3 ++
>  drivers/net/wireless/ath/hw.c          |    5 +++
>  8 files changed, 151 insertions(+)
> 
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -3045,3 +3045,74 @@ void ath9k_hw_name(struct ath_hw *ah, char *hw_name, size_t len)
>  	hw_name[used] = '\0';
>  }
>  EXPORT_SYMBOL(ath9k_hw_name);
> +
> +static bool ath9k_hw_check_dcs(u32 dma_dbg, u32 num_dcu_states,
> +			       int *hang_state, int *hang_pos)
> +{
> +	static u32 dcu_chain_state[] = {5, 6, 9}; /* DCU chain stuck states */
> +	u32 chain_state, dcs_pos, i;
> +
> +	for (dcs_pos = 0; dcs_pos < num_dcu_states; dcs_pos++) {
> +		chain_state = (dma_dbg >> (5 * dcs_pos)) & 0x1f;
> +		for (i = 0; i < 3; i++) {
> +			if (chain_state == dcu_chain_state[i]) {
> +				*hang_state = chain_state;
> +				*hang_pos = dcs_pos;
> +				return true;
> +			}
> +		}
> +	}
> +	return false;
> +}
> +
> +#define DCU_COMPLETE_STATE        1
> +#define DCU_COMPLETE_STATE_MASK 0x3
> +#define NUM_STATUS_READS         50
> +bool ath9k_hw_detect_mac_hang(struct ath_hw *ah)
> +{
> +	u32 chain_state, comp_state, dcs_reg = AR_DMADBG_4;
> +	u32 i, hang_pos, hang_state, num_state = 6;
> +
> +	comp_state = REG_READ(ah, AR_DMADBG_6);
> +
> +	if ((comp_state & DCU_COMPLETE_STATE_MASK) != DCU_COMPLETE_STATE) {
> +		ath_dbg(ath9k_hw_common(ah), RESET,
> +			"MAC Hang signature not found at DCU complete\n");
> +		return false;
> +	}
> +
> +	chain_state = REG_READ(ah, dcs_reg);
> +	if (ath9k_hw_check_dcs(chain_state, num_state, &hang_state, &hang_pos))
> +		goto hang_check_iter;
> +
> +	dcs_reg = AR_DMADBG_5;
> +	num_state = 4;
> +	chain_state = REG_READ(ah, dcs_reg);
> +	if (ath9k_hw_check_dcs(chain_state, num_state, &hang_state, &hang_pos))
> +		goto hang_check_iter;
> +
> +	ath_dbg(ath9k_hw_common(ah), RESET,
> +		"MAC Hang signature 1 not found\n");
> +	return false;
> +
> +hang_check_iter:
> +	ath_dbg(ath9k_hw_common(ah), RESET,
> +		"DCU registers: chain %08x complete %08x Hang: state %d pos %d\n",
> +		chain_state, comp_state, hang_state, hang_pos);
> +
> +	for (i = 0; i < NUM_STATUS_READS; i++) {
> +		chain_state = REG_READ(ah, dcs_reg);
> +		chain_state = (chain_state >> (5 * hang_pos)) & 0x1f;
> +		comp_state = REG_READ(ah, AR_DMADBG_6);
> +
> +		if (((comp_state & DCU_COMPLETE_STATE_MASK) !=
> +					DCU_COMPLETE_STATE) ||
> +		    (chain_state != hang_state))
> +			return false;
> +	}
> +
> +	ath_dbg(ath9k_hw_common(ah), RESET, "MAC Hang signature 1 found\n");
> +
> +	return true;
> +}
> +EXPORT_SYMBOL(ath9k_hw_detect_mac_hang);
This could be merged into ath9k_hw_check_alive()

> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1396,6 +1399,65 @@ static void ath9k_do_vif_add_setup(struct ieee80211_hw *hw,
>  	}
>  }
>  
> +void ath_start_rx_poll(struct ath_softc *sc, u32 nmsec)
> +{
> +	if (!AR_SREV_9300(sc->sc_ah))
> +		return;
> +
> +	if (!(sc->sc_flags & SC_OP_PRIM_STA_VIF))
> +		return;
> +
> +	mod_timer(&sc->rx_poll_timer, jiffies + msecs_to_jiffies(nmsec));
> +}
> +
> +void ath_rx_poll_work(unsigned long data)
> +{
> +	struct ath_softc *sc = (struct ath_softc *)data;
> +	struct ath_hw *ah = sc->sc_ah;
> +	struct ath_common *common = ath9k_hw_common(ah);
> +	static u32 iteration, match_count;
> +	static u64 last_run;
> +	unsigned long flags;
> +	u32 rx_clear, rx, tx, nmsec = 10;
> +
> +	if (jiffies_to_msecs(jiffies - last_run) > 120)
> +		iteration = match_count = 0;
> +	else
> +		iteration += 1;
> +
> +	ath9k_ps_wakeup(sc);
> +
> +	spin_lock_irqsave(&common->cc_lock, flags);
> +	ath_hw_cycle_counters_update(common);
> +
> +	rx_clear = common->cc_rxpoll.rx_busy * 100 / common->cc_rxpoll.cycles;
> +	rx = common->cc_rxpoll.rx_frame * 100 / common->cc_rxpoll.cycles;
> +	tx = common->cc_rxpoll.tx_frame * 100 / common->cc_rxpoll.cycles;
> +	memset(&common->cc_rxpoll, 0, sizeof(common->cc_rxpoll));
> +	spin_unlock_irqrestore(&common->cc_lock, flags);
> +
> +	last_run = jiffies;
> +	if (rx_clear > 98) {
> +		ath_dbg(common, RESET,
> +			"rx clear %d match count %d iteration %d\n",
> +		       rx_clear, match_count, iteration);
> +		if (match_count++ > 9)
> +			goto queue_reset_work;
> +	} else if (ath9k_hw_detect_mac_hang(ah))
> +		goto queue_reset_work;
> +	else if (iteration >= 15) {
> +		iteration = match_count = 0;
> +		nmsec = 200;
> +	}
> +	ath9k_ps_restore(sc);
> +	ath_start_rx_poll(sc, nmsec);
> +	return;
> +
> +queue_reset_work:
> +	ath9k_ps_restore(sc);
> +	ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
> +	iteration = match_count = 0;
> +}
>  
>  static int ath9k_add_interface(struct ieee80211_hw *hw,
>  			       struct ieee80211_vif *vif)
How about merging this with ath_hw_check() which does similar things?
That way AP mode would get coverage as well.

> diff --git a/drivers/net/wireless/ath/hw.c b/drivers/net/wireless/ath/hw.c
> index 19befb3..f1821ea 100644
> --- a/drivers/net/wireless/ath/hw.c
> +++ b/drivers/net/wireless/ath/hw.c
> @@ -166,6 +166,11 @@ void ath_hw_cycle_counters_update(struct ath_common *common)
>  	common->cc_survey.rx_busy += busy;
>  	common->cc_survey.rx_frame += rx;
>  	common->cc_survey.tx_frame += tx;
> +
> +	common->cc_rxpoll.cycles += cycles;
> +	common->cc_rxpoll.rx_busy += busy;
> +	common->cc_rxpoll.rx_frame += rx;
> +	common->cc_rxpoll.tx_frame += tx;
>  }
>  EXPORT_SYMBOL(ath_hw_cycle_counters_update);
Do we really need yet another cycle counter state here? How about
reusing the survey counters like ath_hw_check() - or even reusing that
chunk of code entirely.

- Felix
