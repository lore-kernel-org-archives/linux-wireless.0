Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62729 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab0JZEgk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 00:36:40 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 21:36:29 -0700
Message-ID: <4CC65AD3.9070800@atheros.com>
Date: Tue, 26 Oct 2010 10:06:35 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>,
	Bob Copeland <me@bobcopeland.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Properly assign boolean types Signed-off-by: Mohammed
 Shafi Shajakhan <mshajakhan@atheros.com>
References: <1287990961-2619-1-git-send-email-mshajakhan@atheros.com> <4CC5A936.7070009@candelatech.com>
In-Reply-To: <4CC5A936.7070009@candelatech.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks , thought of that, but the code seems to use true/false approach, 
will send a new patch with this simple fix.
thanks,
shafi

On Monday 25 October 2010 09:28 PM, Ben Greear wrote:
> On 10/25/2010 12:16 AM, Mohammed Shafi Shajakhan wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> ---
>>    drivers/net/wireless/ath/ath9k/rc.c |    9 ++++++---
>>    1 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
>> index 0cee90c..0c70839 100644
>> --- a/drivers/net/wireless/ath/ath9k/rc.c
>> +++ b/drivers/net/wireless/ath/ath9k/rc.c
>> @@ -1444,12 +1444,15 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
>>    		ath_rc_priv->neg_ht_rates.rs_nrates = j;
>>    	}
>>
>> -	is_cw40 = sta->ht_cap.cap&   IEEE80211_HT_CAP_SUP_WIDTH_20_40;
>> +	is_cw40 = (sta->ht_cap.cap&   IEEE80211_HT_CAP_SUP_WIDTH_20_40) ?
>> +		true : false;
>>      
> Maybe use:
> is_cw40 = !!(sta->ht_cap.cap&   IEEE80211_HT_CAP_SUP_WIDTH_20_40);
>
> Seems a bit simpler to me...
>
> Ben
>
>
>    
>>    	if (is_cw40)
>> -		is_sgi = sta->ht_cap.cap&   IEEE80211_HT_CAP_SGI_40;
>> +		is_sgi = (sta->ht_cap.cap&   IEEE80211_HT_CAP_SGI_40) ?
>> +			true : false;
>>    	else if (sc->sc_ah->caps.hw_caps&   ATH9K_HW_CAP_SGI_20)
>> -		is_sgi = sta->ht_cap.cap&   IEEE80211_HT_CAP_SGI_20;
>> +		is_sgi = (sta->ht_cap.cap&   IEEE80211_HT_CAP_SGI_20) ?
>> +			true : false
>>
>>    	/* Choose rate table first */
>>
>>      
>
>    
