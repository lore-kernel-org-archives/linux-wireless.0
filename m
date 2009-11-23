Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33207 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbZKWTaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 14:30:08 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so2196737ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 11:30:14 -0800 (PST)
Message-ID: <4B0AE2C3.10200@gmail.com>
Date: Mon, 23 Nov 2009 20:30:11 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] rt2x00: Only initialize HT on rt2800 devices that
 support it.
References: <1258960565-26736-1-git-send-email-gwingerde@gmail.com> <1258960565-26736-2-git-send-email-gwingerde@gmail.com> <200911231912.17436.IvDoorn@gmail.com>
In-Reply-To: <200911231912.17436.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/09 19:12, Ivo van Doorn wrote:
> On Monday 23 November 2009, Gertjan van Wingerde wrote:
>> Some RT28xx/RT30xx devices don't support 802.11n, when they are combined with
>> the RF2020 chipset. Ensure that HT is disabled for these devices.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> ---
>>  drivers/net/wireless/rt2x00/rt2800lib.c |   59 +++++++++++++++++--------------
>>  1 files changed, 32 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index e94f1e1..ac393c3 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -2070,34 +2070,39 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>>  	}
>>  
>>  	/*
>> -	 * Initialize HT information.
>> +	 * Initialize HT information, unless when we're on RF2020, which doesn't
>> +	 * support 802.11n.
>>  	 */
>> -	spec->ht.ht_supported = true;
>> -	spec->ht.cap =
>> -	    IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
>> -	    IEEE80211_HT_CAP_GRN_FLD |
>> -	    IEEE80211_HT_CAP_SGI_20 |
>> -	    IEEE80211_HT_CAP_SGI_40 |
>> -	    IEEE80211_HT_CAP_TX_STBC |
>> -	    IEEE80211_HT_CAP_RX_STBC |
>> -	    IEEE80211_HT_CAP_PSMP_SUPPORT;
>> -	spec->ht.ampdu_factor = 3;
>> -	spec->ht.ampdu_density = 4;
>> -	spec->ht.mcs.tx_params =
>> -	    IEEE80211_HT_MCS_TX_DEFINED |
>> -	    IEEE80211_HT_MCS_TX_RX_DIFF |
>> -	    ((rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH) - 1) <<
>> -		IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
>> -
>> -	switch (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH)) {
>> -	case 3:
>> -		spec->ht.mcs.rx_mask[2] = 0xff;
>> -	case 2:
>> -		spec->ht.mcs.rx_mask[1] = 0xff;
>> -	case 1:
>> -		spec->ht.mcs.rx_mask[0] = 0xff;
>> -		spec->ht.mcs.rx_mask[4] = 0x1; /* MCS32 */
>> -		break;
>> +	if (!rt2x00_rf(chip, RF2020)) {
>> +		spec->ht.ht_supported = true;
>> +		spec->ht.cap =
>> +			IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
>> +			IEEE80211_HT_CAP_GRN_FLD |
>> +			IEEE80211_HT_CAP_SGI_20 |
>> +			IEEE80211_HT_CAP_SGI_40 |
>> +			IEEE80211_HT_CAP_TX_STBC |
>> +			IEEE80211_HT_CAP_RX_STBC |
>> +			IEEE80211_HT_CAP_PSMP_SUPPORT;
>> +		spec->ht.ampdu_factor = 3;
>> +		spec->ht.ampdu_density = 4;
>> +		spec->ht.mcs.tx_params =
>> +			IEEE80211_HT_MCS_TX_DEFINED |
>> +			IEEE80211_HT_MCS_TX_RX_DIFF |
>> +			((rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH) - 1) <<
>> +				IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
>> +
>> +		switch (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH)) {
>> +		case 3:
>> +			spec->ht.mcs.rx_mask[2] = 0xff;
>> +		case 2:
>> +			spec->ht.mcs.rx_mask[1] = 0xff;
>> +		case 1:
>> +			spec->ht.mcs.rx_mask[0] = 0xff;
>> +			spec->ht.mcs.rx_mask[4] = 0x1; /* MCS32 */
>> +			break;
>> +		}
>> +	} else {
>> +		spec->ht.ht_supported = false;
> 
> Isn't it sufficient to only set spec->ht.ht_supported to true or false?
> mac80211 should ignore all ht parameters if ht_supported is set to
> false anyway (and it saves quite a lot of indenting).
> 

I wasn't sure of that. I presume that that would be the case. Not sure if it
is clean to initialize all the ht parameters when it isn't necessary, but I'm
indifferent to that.

I'll respin with your suggestion.

---
Gertjan.

