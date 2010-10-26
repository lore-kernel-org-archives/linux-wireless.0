Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62607 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab0JZE2L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 00:28:11 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 21:28:00 -0700
Message-ID: <4CC658CF.8010304@atheros.com>
Date: Tue, 26 Oct 2010 09:57:59 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Properly assign boolean types Signed-off-by: Mohammed
 Shafi Shajakhan <mshajakhan@atheros.com>
References: <1287990961-2619-1-git-send-email-mshajakhan@atheros.com> <20101025162854.GA1970@tux>
In-Reply-To: <20101025162854.GA1970@tux>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I will make the change send a new patch.Thanks Luis.
regards,
shafi

On Monday 25 October 2010 09:58 PM, Luis Rodriguez wrote:
> On Mon, Oct 25, 2010 at 12:16:01AM -0700, Mohammed Shajakhan wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>      
> Your SOB is missing, and you put it on the subject
>
>    Luis
>
>    
>> ---
>>   drivers/net/wireless/ath/ath9k/rc.c |    9 ++++++---
>>   1 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
>> index 0cee90c..0c70839 100644
>> --- a/drivers/net/wireless/ath/ath9k/rc.c
>> +++ b/drivers/net/wireless/ath/ath9k/rc.c
>> @@ -1444,12 +1444,15 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
>>   		ath_rc_priv->neg_ht_rates.rs_nrates = j;
>>   	}
>>
>> -	is_cw40 = sta->ht_cap.cap&  IEEE80211_HT_CAP_SUP_WIDTH_20_40;
>> +	is_cw40 = (sta->ht_cap.cap&  IEEE80211_HT_CAP_SUP_WIDTH_20_40) ?
>> +		true : false;
>>
>>   	if (is_cw40)
>> -		is_sgi = sta->ht_cap.cap&  IEEE80211_HT_CAP_SGI_40;
>> +		is_sgi = (sta->ht_cap.cap&  IEEE80211_HT_CAP_SGI_40) ?
>> +			true : false;
>>   	else if (sc->sc_ah->caps.hw_caps&  ATH9K_HW_CAP_SGI_20)
>> -		is_sgi = sta->ht_cap.cap&  IEEE80211_HT_CAP_SGI_20;
>> +		is_sgi = (sta->ht_cap.cap&  IEEE80211_HT_CAP_SGI_20) ?
>> +			true : false
>>
>>   	/* Choose rate table first */
>>
>> -- 
>> 1.7.0.4
>>
>>      
> .
>
>    
