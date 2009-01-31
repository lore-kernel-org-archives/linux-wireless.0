Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3487 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZAaRI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 12:08:26 -0500
Date: Sat, 31 Jan 2009 12:08:02 -0500
From: Bob Copeland <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH 5/5] ath5k: Update reset code
Message-ID: <20090131170802.GA16826@hash.localnet> (sfid-20090131_180839_012856_947970E3)
References: <20090131023147.GE3342@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090131023147.GE3342@makis>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 31, 2009 at 04:31:47AM +0200, Nick Kossifidis wrote:
>  * Update reset and sync with HALs
>  * Clean up eeprom settings and tweaking of initvals and put them on separate functions
>  * Set/Restore 32KHz ref clk operation
>  * Add some more documentation
>  TODO: Spur mitigation, tpc, half/quarter rate, compression etc

Awesome work!  I just double checked it, I have some minor comments,
on the whole looks very good.

>  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

Should be "Signed-off-by:" (lowercase O) according to checkpatch.

> [...]
> +bool ath5k_eeprom_is_hb63(struct ath5k_hw *ah)
> +{
> +	u16 data;
> +
> +	ath5k_hw_eeprom_read(ah, AR5K_EEPROM_IS_HB63, &data);
> +
> +	if ((ah->ah_mac_version == (AR5K_SREV_AR2425 >> 4) && data))

Don't think it makes a difference, but judging from the double parens,
I think you meant:

> +	if ((ah->ah_mac_version == (AR5K_SREV_AR2425 >> 4)) && data)

Do we need to check for eeprom version 5.4 or better?  HAL does. 

> [...]
> @@ -2156,7 +2157,8 @@
>  #define	AR5K_PHY_ANT_CTL_TXRX_EN	0x00000001	/* Enable TX/RX (?) */
>  #define	AR5K_PHY_ANT_CTL_SECTORED_ANT	0x00000004	/* Sectored Antenna */
>  #define	AR5K_PHY_ANT_CTL_HITUNE5	0x00000008	/* Hitune5 (?) */
> -#define	AR5K_PHY_ANT_CTL_SWTABLE_IDLE	0x00000010	/* Switch table idle (?) */
> +#define	AR5K_PHY_ANT_CTL_SWTABLE_IDLE	0x000003f9	/* Switch table idle (?) */
> +#define	AR5K_PHY_ANT_CTL_SWTABLE_IDLE_S	4

That doesn't look right.. should be 3f0?  (still probably works, I guess).

> -#define	AR5K_PHY_OFDM_SELFCORR_CYPWR_THR1_S	0
> +#define	AR5K_PHY_OFDM_SELFCORR_CYPWR_THR1_S	1

Heh, we should write a little tool to check the shifts and masks :)

> - * Write the OFDM timings for the AR5212 upon reset. This is a helper for
> - * ath5k_hw_reset(). This seems to tune the PLL a specified frequency
> - * depending on the bandwidth of the channel.
> + * Write the delta slope coefficient (used on pilot tracking ?) for OFDM
> + * operration on the AR5212 upon reset. This is a helper for ath5k_hw_reset().

operation

>   *
> + * Since delta slope is floating point we split it on it's exponent and

its

> + * mantissa and provide these values on hw.
> + *
> + * For more infos i think this pattent is related

patent

> @@ -53,13 +57,20 @@ static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
>  		!(channel->hw_value & CHANNEL_OFDM))
>  		BUG();
>  
> -	/* Seems there are two PLLs, one for baseband sampling and one
> -	 * for tuning. Tuning basebands are 40 MHz or 80MHz when in
> -	 * turbo. */
> -	clock = channel->hw_value & CHANNEL_TURBO ? 80 : 40;
> +	/* Get coefficient
> +	 * ALGO: coef = (5 * clock * carrier_freq) / 2)
> +	 * we scale coef by shifting clock value by 24 for
> +	 * better precision since we use integers */
> +	/* TODO: Half/quarter rate */
> +	clock = channel->hw_value & CHANNEL_TURBO ?
> +				ath5k_hw_htoclock(1, true) :
> +				ath5k_hw_htoclock(1, false);
> +


Could be: 

    clock = ath5k_hw_htoclock(1, channel->hw_value & CHANNEL_TURBO);

>  	coef_scaled = ((5 * (clock << 24)) / 2) /
>  	channel->center_freq;
>  
> +	/* Get exponent
> +	 * ALGO: coe_exp = 14 - highest set bit position */
>  	for (coef_exp = 31; coef_exp > 0; coef_exp--)
>  		if ((coef_scaled >> coef_exp) & 0x1)
>  			break;

I know this is existing code, but we could use something like
get_bitmask_order() here or fls() instead of the open-coded loop.  
For some other patch.

>  /*
> + * If there is an external 32KHz crystal available, use it
> + * as ref. clock instead of 32/40MHz clock and baseband clocks
> + * to save power durring sleep or restore normal 32/40MHz

during

> + * operation.
> + *
> + * XXX: When operating on 32KHz certain PHY registers (27 - 31,
> + * 	123 - 127) require delay on access.
> + */
> +void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)

ACK

> +static bool ath5k_hw_chan_has_spur_noise(struct ath5k_hw *ah,
> +				struct ieee80211_channel *channel)
> +{

ACK

> +	/* Set DAC/ADC delays */
> +	if (ah->ah_version == AR5K_AR5212) {
> +		if (ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))
> +			data = AR5K_PHY_SCAL_32MHZ_2417;
> +		else if (ath5k_eeprom_is_hb63(ah))
> +			data = AR5K_PHY_SCAL_32MHZ_HB63;
> +		else
> +			data = AR5K_PHY_SCAL_32MHZ;
> +		ath5k_hw_reg_write(ah, data, AR5K_PHY_SCAL);
> +		data = 0;

why data = 0; ?

> +	}
> +
> +	/* Set fast ADC */
> +	if ((ah->ah_radio == AR5K_RF5413) ||
> +	(ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))) {
> +		data = 1;
> +
> +		if (channel->center_freq == 2462 ||
> +		channel->center_freq == 2467)
> +			data = 0;
> +
> +		if (ath5k_hw_reg_read(ah, AR5K_PHY_FAST_ADC) != data)
> +				ath5k_hw_reg_write(ah, data,
> +						AR5K_PHY_FAST_ADC);
> +		data = 0;

ditto

> +	}
> +
> +	/* Fix for first revision of the RF5112 RF chipset */
> +	if (ah->ah_radio >= AR5K_RF5112 &&
> +			ah->ah_radio_5ghz_revision <
> +			AR5K_SREV_RAD_5112A) {
> +		ath5k_hw_reg_write(ah, AR5K_PHY_CCKTXCTL_WORLD,
> +				AR5K_PHY_CCKTXCTL);
> +		if (channel->hw_value & CHANNEL_5GHZ)
> +			data = 0xffb81020;
> +		else
> +			data = 0xffb80d20;
> +		ath5k_hw_reg_write(ah, data, AR5K_PHY_FRAME_CTL);
> +		data = 0;

ditto

> +	}
> +
> +	if (ah->ah_mac_srev < AR5K_SREV_AR5211) {
> +		/* 5311 has different tx/rx latency masks
> +		 * from 5211, since we deal 5311 the same
> +		 * as 5211 when setting initvals, shift
> +		 * values here to their proper locations */
> +		data = ath5k_hw_reg_read(ah, AR5K_USEC_5211);
> +		ath5k_hw_reg_write(ah, data & (AR5K_USEC_1 |
> +				AR5K_USEC_32 |
> +				AR5K_USEC_TX_LATENCY_5211 |
> +				AR5K_REG_SM(29,
> +				AR5K_USEC_RX_LATENCY_5210)),
> +				AR5K_USEC_5211);
> +		/* Clear QCU/DCU clock gating register */
> +		ath5k_hw_reg_write(ah, 0, AR5K_QCUDCU_CLKGT);
> +		/* Set DAC/ADC delays */
> +		ath5k_hw_reg_write(ah, 0x08, AR5K_PHY_SCAL);
> +		/* Enable PCU FIFO corruption ECO */
> +		AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW_5211,
> +					AR5K_DIAG_SW_ECO_ENABLE);
> +		data = 0;

ditto

> +	}
> +
> +	return;

No need for return.

> +}
> +
> +static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
> +		struct ieee80211_channel *channel, u8 *ant, u8 ee_mode)
> +{
> +	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
> +	int16_t cck_ofdm_pwr_delta = 0;

I don't think you need to assign it, unless gcc is particularly dumb.

> +
> +	/* Set CCK to OFDM power delta */
> +	if (ah->ah_phy_revision > AR5K_SREV_PHY_5212A) {
> +		/* Adjust power delta for channel 14 */
> +		if (channel->center_freq == 2484)
> +			cck_ofdm_pwr_delta =
> +				((ee->ee_cck_ofdm_power_delta -
> +				ee->ee_scaled_cck_delta) * 2) / 10;
> +		else
> +			cck_ofdm_pwr_delta =
> +				ee->ee_cck_ofdm_power_delta;

missing * 2 / 10 here?

> +
> +		if (channel->hw_value == CHANNEL_G)
> +			ath5k_hw_reg_write(ah,
> +			AR5K_REG_SM((ee->ee_cck_ofdm_power_delta * -1),
> [...]
> +		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_GAIN,
> +				AR5K_PHY_GAIN_TXRX_ATTEN,
> +				ee->ee_atn_tx_rx[ee_mode]);
> +
> +		/* ADC/PGA dezired size */

desired

> [...]
> +
> +	/* Thres64 (ANI) */

Thresh62 ?

> +	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_NF,
> +			AR5K_PHY_NF_THRESH62,
> +			ee->ee_thr_62[ee_mode]);
> +

> +	/* I/Q correction
> +	 * TODO: Per channel i/q infos ? */
> +	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ,
> +		AR5K_PHY_IQ_CORR_ENABLE |
> +		(ee->ee_i_cal[ee_mode] << AR5K_PHY_IQ_CORR_Q_I_COFF_S) |
> +		ee->ee_q_cal[ee_mode]);
> +
> +	/* Heavy clipping -disable for now */
> +	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_5_1)
> +		ath5k_hw_reg_write(ah, 0, AR5K_PHY_HEAVY_CLIP_ENABLE);
> +
> +	return;

No need for return.

> +}

My eyes got tired, so I skipped a lot :)

> +
> +	/* QoS NOACK Policy */
> +	if (ah->ah_version == AR5K_AR5212) {
> +		ath5k_hw_reg_write(ah,
> +			AR5K_REG_SM(2, AR5K_QOS_NOACK_2BIT_VALUES) |
> +			AR5K_REG_SM(5, AR5K_QOS_NOACK_BIT_OFFSET)  |
> +			AR5K_REG_SM(0, AR5K_QOS_NOACK_BYTE_OFFSET),

AR5K_QOS_NOACK_BYTE_OFFSET_S is also wrong, should be 7.

> +			AR5K_QOS_NOACK);
> +	}
> +

Thanks!
-- 
Bob Copeland %% www.bobcopeland.com

