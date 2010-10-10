Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:57041 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab0JJPWa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 11:22:30 -0400
Message-ID: <4CB1DAC8.6050609@ti.com>
Date: Sun, 10 Oct 2010 17:24:56 +0200
From: Shahar Levi <shahar_levi@ti.com>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 03/03] wl1271: 11n Support, functionality and configuration
 ability
References: <1286388491-28752-1-git-send-email-shahar_levi@ti.com>	 <1286388491-28752-5-git-send-email-shahar_levi@ti.com> <1286528736.21349.42.camel@chilepepper>
In-Reply-To: <1286528736.21349.42.camel@chilepepper>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the review. comments inline.
Cheers,
Shahar

Luciano Coelho wrote:
> On Wed, 2010-10-06 at 20:08 +0200, ext Shahar Levi wrote:
>> Add 11n ability in scan, connection and using MCS rates.
>> The configuration is temporary due to the code incomplete and
>> still in testing process. That plans to be remove in the future.
>>
>> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
>> ---
> 
> Some comments below.  Again, mostly style-related.
> 
> 
>> diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
>> index 0d334d6..92465c8 100644
>> --- a/drivers/net/wireless/wl12xx/Makefile
>> +++ b/drivers/net/wireless/wl12xx/Makefile
>> @@ -19,3 +19,4 @@ obj-$(CONFIG_WL1271_SDIO)	+= wl1271_sdio.o
>>  
>>  # small builtin driver bit
>>  obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx_platform_data.o
>> +
> 
> I guess this extra empty line was included accidentally here? There are
> no other changes in the Makefile, so please remove this change.

fixed
> 
> 
>> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
>> index bef2c24..7dd1257 100644
>> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
>> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
>> @@ -841,10 +841,21 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>>  
>>  	/* peek into the rates configured in the STA entry */
>>  	spin_lock_irqsave(&wl->wl_lock, flags);
>> -	if (sta && sta->supp_rates[conf->channel->band] != wl->sta_rate_set) {
>> +	if (sta &&
>> +	    (sta->supp_rates[conf->channel->band] !=
>> +	    (wl->sta_rate_set & HW_BG_RATES_MASK))) {
>>  		wl->sta_rate_set = sta->supp_rates[conf->channel->band];
> 
> Shouldn't this be |= here like the one below? Otherwise the HT rates
> will be zeroed.  Okay, this would be fixed below, because the zeroed HT
> rates will not match the configured rates, but in some cases that will
> be unnecessary.

I add line that clean MCS bits before ssetting it:
    if (sta &&
	    sta->ht_cap.ht_supported &&
	    ((wl->sta_rate_set >> HW_HT_RATES_OFFSET) !=rate_set
	      sta->ht_cap.mcs.rx_mask[0])) {
		/* Clean MCS bits before setting them */
		wl->sta_rate_set &= CONF_HW_BG_RATES_MASK;
		wl->sta_rate_set |= (sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET);
		set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
	}

> 
> 
>>  		set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
>>  	}
>> +
>> +	if (sta &&
>> +	    sta->ht_cap.ht_supported &&
>> +	    ((wl->sta_rate_set >> HW_HT_RATES_OFFSET) !=
>> +	      sta->ht_cap.mcs.rx_mask[0])) {
>> +		wl->sta_rate_set |=
>> +		(sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET);
>> +		set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
>> +	}
>>  	spin_unlock_irqrestore(&wl->wl_lock, flags);
>>  
>>  	/* queue the packet */
>> @@ -1697,6 +1708,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
>>  {
>>  	enum wl1271_cmd_ps_mode mode;
>>  	struct wl1271 *wl = hw->priv;
>> +	struct ieee80211_sta *sta = ieee80211_find_sta(vif, bss_conf->bssid);
>>  	bool do_join = false;
>>  	bool set_assoc = false;
>>  	int ret;
>> @@ -1915,6 +1927,21 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
>>  		}
>>  	}
>>  
>> +	if (sta) {
>> +		if (changed & BSS_CHANGED_HT) {
>> +			ret = wl1271_acx_set_ht_capabilities(wl,
>> +							     &sta->ht_cap,
>> +							     true);
>> +			ret = wl1271_acx_set_ht_information(wl,
>> +						bss_conf->ht_operation_mode);
>> +			}
>> +		else
>> +			if (changed & BSS_CHANGED_ASSOC)
>> +				ret = wl1271_acx_set_ht_capabilities(wl,
>> +								&sta->ht_cap,
>> +								false);
>> +	}
>> +
> 
> 
> The closing brace is indented wrongly here.  And you should also use
> braces in the else block (see Documentation/CodingStyle).
> 
> But in any case, you could reduce the indentation and prevent unaligned
> parameters in the wl1271_acx_* calls if you do this:
> 
> 	if (sta && changed & BSS_CHANGED_HT) {
> 
> and
> 
> 	if (sta && changed & BSS_CHANGED_ASSOC)

fixed
> 
> 
>> @@ -2255,6 +2285,7 @@ static struct ieee80211_supported_band wl1271_band_5ghz = {
>>  	.n_channels = ARRAY_SIZE(wl1271_channels_5ghz),
>>  	.bitrates = wl1271_rates_5ghz,
>>  	.n_bitrates = ARRAY_SIZE(wl1271_rates_5ghz),
>> +	.ht_cap	= WL12xx_HT_CAP,
>>  };
> 
> You forgot the #ifdef around .ht_cap here.  Actually, it might be nicer
> to put the #ifdef around the macro itself, so you can explicitly set
> the .ht_supported flag to false if 11n is not configured.

fixed
> 
> 
>>  static const u8 *wl1271_band_rate_to_idx[] = {
>> diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
>> index 94da5dd..109a470 100644
>> --- a/drivers/net/wireless/wl12xx/wl1271_rx.c
>> +++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
>> @@ -53,6 +53,10 @@ static void wl1271_rx_status(struct wl1271 *wl,
>>  	status->band = wl->band;
>>  	status->rate_idx = wl1271_rate_to_idx(wl, desc->rate);
>>  
>> +	/* 11n support */
>> +	if (desc->rate <= CONF_HW_RXTX_RATE_MCS0)
>> +		status->flag |= RX_FLAG_HT;
>> +
>>  	status->signal = desc->rssi;
> 
> Should this be #ifdef'ed also?

No, in case of HT not supported the HW will not set MCS rate.
> 
>  
>>  	/*
>> diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
>> index 1b8295c..af54fef 100644
>> --- a/drivers/net/wireless/wl12xx/wl1271_tx.c
>> +++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
>> @@ -236,6 +236,15 @@ u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set)
>>  		rate_set >>= 1;
>>  	}
>>  
>> +	/* MCS rates indication are on bits 16 - 23 */
>> +	rate_set >>= HW_HT_RATES_OFFSET - band->n_bitrates;
>> +
>> +	for (bit = 0; bit < 8; bit++) {
>> +		if (rate_set & 0x1)
>> +			enabled_rates |= (CONF_HW_BIT_RATE_MCS_0 << bit);
>> +		rate_set >>= 1;
>> +	}
>> +
> 
> And this? #ifdef here as well, maybe? 

No, in case of HT not supported MCS bit in rate_set will not be set.
> 
> 

