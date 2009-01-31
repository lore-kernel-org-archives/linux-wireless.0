Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:8889 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbZAaSsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 13:48:04 -0500
Received: by yx-out-2324.google.com with SMTP id 8so349464yxm.1
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2009 10:48:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090131170802.GA16826@hash.localnet>
References: <20090131023147.GE3342@makis>
	 <20090131170802.GA16826@hash.localnet>
Date: Sat, 31 Jan 2009 20:48:02 +0200
Message-ID: <40f31dec0901311048t3834612cgc6b1dd01aa42a5c0@mail.gmail.com> (sfid-20090131_194810_206521_5917045F)
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Update reset code
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/31 Bob Copeland <me@bobcopeland.com>:
> On Sat, Jan 31, 2009 at 04:31:47AM +0200, Nick Kossifidis wrote:
>>  * Update reset and sync with HALs
>>  * Clean up eeprom settings and tweaking of initvals and put them on separate functions
>>  * Set/Restore 32KHz ref clk operation
>>  * Add some more documentation
>>  TODO: Spur mitigation, tpc, half/quarter rate, compression etc
>
> Awesome work!  I just double checked it, I have some minor comments,
> on the whole looks very good.
>

Thanks a lot for the review ! ;-)

>>  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> Should be "Signed-off-by:" (lowercase O) according to checkpatch.
>

ACK, i just c/p it from my previous patches and it seems i got it
wrong on all of them :P

>> [...]
>> +bool ath5k_eeprom_is_hb63(struct ath5k_hw *ah)
>> +{
>> +     u16 data;
>> +
>> +     ath5k_hw_eeprom_read(ah, AR5K_EEPROM_IS_HB63, &data);
>> +
>> +     if ((ah->ah_mac_version == (AR5K_SREV_AR2425 >> 4) && data))
>
> Don't think it makes a difference, but judging from the double parens,
> I think you meant:
>
>> +     if ((ah->ah_mac_version == (AR5K_SREV_AR2425 >> 4)) && data)

You are right, i'll change that...

>
> Do we need to check for eeprom version 5.4 or better?  HAL does.
>

Well ath5k_eeprom_is_hb63 is a temporary solution, i'll make a
ath5k_hw_get_eeprom_info for all eeprom flags (rf kill, antenna gain
etc) and use that instead.

>> [...]
>> @@ -2156,7 +2157,8 @@
>>  #define      AR5K_PHY_ANT_CTL_TXRX_EN        0x00000001      /* Enable TX/RX (?) */
>>  #define      AR5K_PHY_ANT_CTL_SECTORED_ANT   0x00000004      /* Sectored Antenna */
>>  #define      AR5K_PHY_ANT_CTL_HITUNE5        0x00000008      /* Hitune5 (?) */
>> -#define      AR5K_PHY_ANT_CTL_SWTABLE_IDLE   0x00000010      /* Switch table idle (?) */
>> +#define      AR5K_PHY_ANT_CTL_SWTABLE_IDLE   0x000003f9      /* Switch table idle (?) */
>> +#define      AR5K_PHY_ANT_CTL_SWTABLE_IDLE_S 4
>
> That doesn't look right.. should be 3f0?  (still probably works, I guess).
>

I know, but HAL does this...
	AR_PHY_BIS(ah, 68, 0xFFFFFC06,
		(ee->ee_antennaControl[0][arrayMode] << 4) | 0x1);

~0xFFFFFC06 = 3F9

>> -#define      AR5K_PHY_OFDM_SELFCORR_CYPWR_THR1_S     0
>> +#define      AR5K_PHY_OFDM_SELFCORR_CYPWR_THR1_S     1
>
> Heh, we should write a little tool to check the shifts and masks :)
>

Yup :P

>> - * Write the OFDM timings for the AR5212 upon reset. This is a helper for
>> - * ath5k_hw_reset(). This seems to tune the PLL a specified frequency
>> - * depending on the bandwidth of the channel.
>> + * Write the delta slope coefficient (used on pilot tracking ?) for OFDM
>> + * operration on the AR5212 upon reset. This is a helper for ath5k_hw_reset().
>
> operation
>
>>   *
>> + * Since delta slope is floating point we split it on it's exponent and
>
> its
>
>> + * mantissa and provide these values on hw.
>> + *
>> + * For more infos i think this pattent is related
>
> patent
>

ACK

>> @@ -53,13 +57,20 @@ static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
>>               !(channel->hw_value & CHANNEL_OFDM))
>>               BUG();
>>
>> -     /* Seems there are two PLLs, one for baseband sampling and one
>> -      * for tuning. Tuning basebands are 40 MHz or 80MHz when in
>> -      * turbo. */
>> -     clock = channel->hw_value & CHANNEL_TURBO ? 80 : 40;
>> +     /* Get coefficient
>> +      * ALGO: coef = (5 * clock * carrier_freq) / 2)
>> +      * we scale coef by shifting clock value by 24 for
>> +      * better precision since we use integers */
>> +     /* TODO: Half/quarter rate */
>> +     clock = channel->hw_value & CHANNEL_TURBO ?
>> +                             ath5k_hw_htoclock(1, true) :
>> +                             ath5k_hw_htoclock(1, false);
>> +
>
>
> Could be:
>
>    clock = ath5k_hw_htoclock(1, channel->hw_value & CHANNEL_TURBO);
>

My intention is to reimplement hw_htoclock to account for half/quarter
rate so it'll soon be
clock = ath5k_hw_htoclock(1, channel->hw_value);

>>       coef_scaled = ((5 * (clock << 24)) / 2) /
>>       channel->center_freq;
>>
>> +     /* Get exponent
>> +      * ALGO: coe_exp = 14 - highest set bit position */
>>       for (coef_exp = 31; coef_exp > 0; coef_exp--)
>>               if ((coef_scaled >> coef_exp) & 0x1)
>>                       break;
>
> I know this is existing code, but we could use something like
> get_bitmask_order() here or fls() instead of the open-coded loop.
> For some other patch.
>

Sure thing, i was also looking for some fast bit operation but i
didn't put it in

>>  /*
>> + * If there is an external 32KHz crystal available, use it
>> + * as ref. clock instead of 32/40MHz clock and baseband clocks
>> + * to save power durring sleep or restore normal 32/40MHz
>
> during
>

>> +     /* Set DAC/ADC delays */
>> +     if (ah->ah_version == AR5K_AR5212) {
>> +             if (ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))
>> +                     data = AR5K_PHY_SCAL_32MHZ_2417;
>> +             else if (ath5k_eeprom_is_hb63(ah))
>> +                     data = AR5K_PHY_SCAL_32MHZ_HB63;
>> +             else
>> +                     data = AR5K_PHY_SCAL_32MHZ;
>> +             ath5k_hw_reg_write(ah, data, AR5K_PHY_SCAL);
>> +             data = 0;
>
> why data = 0; ?
>

Instead of having multiple temporary variables, i use only "data". To
be sure that "data" is ok for use i always zero it each time i use it
so that we don't write any weird stuff by mistake.

>
>> +     }
>> +
>> +     return;
>
> No need for return.
>

It's for my eyes mostly

>> +}
>> +
>> +static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
>> +             struct ieee80211_channel *channel, u8 *ant, u8 ee_mode)
>> +{
>> +     struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
>> +     int16_t cck_ofdm_pwr_delta = 0;
>
> I don't think you need to assign it, unless gcc is particularly dumb.
>

I agree but it's a good practice to initialize vars and it's free

>> +
>> +     /* Set CCK to OFDM power delta */
>> +     if (ah->ah_phy_revision > AR5K_SREV_PHY_5212A) {
>> +             /* Adjust power delta for channel 14 */
>> +             if (channel->center_freq == 2484)
>> +                     cck_ofdm_pwr_delta =
>> +                             ((ee->ee_cck_ofdm_power_delta -
>> +                             ee->ee_scaled_cck_delta) * 2) / 10;
>> +             else
>> +                     cck_ofdm_pwr_delta =
>> +                             ee->ee_cck_ofdm_power_delta;
>
> missing * 2 / 10 here?
>

Ouch ! Nice catch ;-)

>> +
>> +             if (channel->hw_value == CHANNEL_G)
>> +                     ath5k_hw_reg_write(ah,
>> +                     AR5K_REG_SM((ee->ee_cck_ofdm_power_delta * -1),
>> [...]
>> +             AR5K_REG_WRITE_BITS(ah, AR5K_PHY_GAIN,
>> +                             AR5K_PHY_GAIN_TXRX_ATTEN,
>> +                             ee->ee_atn_tx_rx[ee_mode]);
>> +
>> +             /* ADC/PGA dezired size */
>
> desired
>
>> [...]
>> +
>> +     /* Thres64 (ANI) */
>
> Thresh62 ?
>

Yup, I mispelled it

>> +
>> +     /* QoS NOACK Policy */
>> +     if (ah->ah_version == AR5K_AR5212) {
>> +             ath5k_hw_reg_write(ah,
>> +                     AR5K_REG_SM(2, AR5K_QOS_NOACK_2BIT_VALUES) |
>> +                     AR5K_REG_SM(5, AR5K_QOS_NOACK_BIT_OFFSET)  |
>> +                     AR5K_REG_SM(0, AR5K_QOS_NOACK_BYTE_OFFSET),
>
> AR5K_QOS_NOACK_BYTE_OFFSET_S is also wrong, should be 7.
>

ACK


Thanks a lot for your comments, i'll address them asap and come up
with a new version of this patch ;-)



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
