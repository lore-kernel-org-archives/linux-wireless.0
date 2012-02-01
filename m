Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37400 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab2BATfV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 14:35:21 -0500
Message-ID: <4F2993F1.1020203@candelatech.com> (sfid-20120201_203545_739908_11C7521D)
Date: Wed, 01 Feb 2012 11:35:13 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Paul Stewart <pstew@google.com>
Subject: Re: [PATCH 1/2] ath9k: recover the chip from tx/rx stuck
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/2012 08:05 AM, Rajkumar Manoharan wrote:
> In the following scenario, where the distance b/w STA and AP is ~10m
> or in a shield environment by placing an attenuator with reduced AP
> txpower, the station started reporting with beacon loss and got
> disconnected whenever the chariot endpoint was initiated with BiDi
> traffic. In such state, two different stuck cases were observed.
>
>    * rx clear is stuck at low for more than 100ms
>    * dcu chain and complete state is stuck.
>
> This patch detects the stuck state if the beacons are not received for
> more than 300ms. In the above matching conditions, trigger a chip
> reset to recover. This issue was originally reported in 3.0 kernel with
> AR9382 chip by having two stations associated with two different APs in
> the same channel and was attenuated/controlled by Azimuth ADEPT-n box.
>
> Cc: Paul Stewart<pstew@google.com>
> Reported-by: Gary Morain<gmorain@google.com>
> Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>

Some more comments below.....


> +static bool ath9k_check_dcu_chain_state(u32 dma_dbg, int max_limit,
> +					int *hang_state, int *hang_pos)
> +{
> +	static u32 hang_sign[] = {5, 6, 9};
> +	u32 chain_state, dcs_pos, i;
> +
> +	for (dcs_pos = 0; dcs_pos<  max_limit; dcs_pos++) {
> +		chain_state = (dma_dbg>>  (5 * dcs_pos))&  0x1f;
> +		for (i = 0; i<  3; i++) {
> +			if (chain_state == hang_sign[i]) {
> +				*hang_state = chain_state;
> +				*hang_pos = dcs_pos;
> +				return true;
> +			}
> +		}
> +	}
> +	return false;
> +}

Perhaps you could add some comments to the code above to describe
what the '5, 6, 9' and other constants mean?

> +#define DCU_COMPLETE_STATE  1
> +#define NUM_STATUS_READS    50
> +static bool ath9k_detect_mac_hang(struct ath_hw *ah)
> +{
> +	u32 chain_state, comp_state, dcs_reg = AR_DMADBG_4;
> +	u32 i, hang_pos, hang_state;
> +
> +	comp_state = REG_READ(ah, AR_DMADBG_6);
> +
> +	if ((comp_state&  0x3) != DCU_COMPLETE_STATE) {
> +		ath_dbg(ath9k_hw_common(ah), RESET,
> +			"MAC Hang signature not found at DCU complete\n");
> +		return false;
> +	}

Same with the 0x3 (maybe #define what those bits mean and or them together instead
of using the 0x3?)

> +
> +	chain_state = REG_READ(ah, dcs_reg);
> +	if (ath9k_check_dcu_chain_state(chain_state, 6,&hang_state,&hang_pos))
> +		goto hang_check_iter;

And why did you choose a '6' here?

> +
> +	dcs_reg = AR_DMADBG_5;
> +	chain_state = REG_READ(ah, dcs_reg);
> +	if (ath9k_check_dcu_chain_state(chain_state, 4,&hang_state,&hang_pos))
> +		goto hang_check_iter;

And the '4'?

> +void ath_start_rx_poll(struct ath_softc *sc, const u32 msec)
> +{
> +	if (!AR_SREV_9300_20_OR_LATER(sc->sc_ah))
> +		return;
> +
> +	if (!(sc->sc_flags&  SC_OP_PRIM_STA_VIF))
> +		return;
> +
> +	mod_timer(&sc->rx_poll_timer, jiffies + msecs_to_jiffies(msec));
> +}

Since the rx-poll timer isn't started when SC_OP_PRIM_STA_VIF is
not set, should you always call the ath_start_rx_poll method
even if ani is disabled in the ath9k_bss_iter method since
the PRIM_STA_VIF flag is set earlier in that code)?

>   static int ath9k_add_interface(struct ieee80211_hw *hw,
>   			       struct ieee80211_vif *vif)
> @@ -1948,6 +2086,8 @@ static void ath9k_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
>   		if (!common->disable_ani) {
>   			sc->sc_flags |= SC_OP_ANI_RUN;
>   			ath_start_ani(common);
> +			sc->rx.stop_rx_poll = false;
> +			ath_start_rx_poll(sc, 300);
>   		}
>
>   	}

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

