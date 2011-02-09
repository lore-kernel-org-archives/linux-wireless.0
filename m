Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21901 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab1BIFNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 00:13:07 -0500
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 08 Feb 2011 21:12:47 -0800
Message-ID: <4D522256.70405@atheros.com>
Date: Wed, 9 Feb 2011 10:42:54 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 1/1] ath9k: Update comments for not parsing DTIM period
References: <1297093108-28541-1-git-send-email-mshajakhan@atheros.com> <AANLkTimXCXW8mT8tPbSuCDpwyyD=NSRyBvFcC2Y+Nq7N@mail.gmail.com>
In-Reply-To: <AANLkTimXCXW8mT8tPbSuCDpwyyD=NSRyBvFcC2Y+Nq7N@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 February 2011 02:52 AM, Björn Smedman wrote:
> On Mon, Feb 7, 2011 at 4:38 PM, Mohammed Shafi Shajakhan
> <mshajakhan@atheros.com>  wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> Add few comments for not parsing DTIM period from mac80211
>>
>> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/beacon.c |    5 +++--
>>   1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
>> index 87ba44c..fcb36ab 100644
>> --- a/drivers/net/wireless/ath/ath9k/beacon.c
>> +++ b/drivers/net/wireless/ath/ath9k/beacon.c
>> @@ -721,8 +721,9 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
>>                 cur_conf->beacon_interval = 100;
>>
>>         /*
>> -        * Some times we dont parse dtim period from mac80211, in that case
>> -        * use a default value
>> +        * We don't parse dtim period from mac80211 during the driver
>> +        * initialization as it breaks association with hidden-ssid
>> +        * AP and it causes latency in roaming
>>          */
>>         if (cur_conf->dtim_period == 0)
>>                 cur_conf->dtim_period = 1;
>>      
> I realize I'm not the perfect representative for the intended audience
> but I don't understand that comment at all. The previous one made
> sense to me, but the new one seems to refer to some logic somewhere
> else. In ath_beacon_config() I expect AP/IBSS logic but the comment
> seems to be about some special case for a STA vif associating with a
> hidden access point, no? I don't understand that special case either
> but that is more easily attributable to ignorance. :)
>    
I also have don't have much idea. I saw that by parsing the DTIM 
period(in init.c ,IEEE80211_HW_NEED_DTIM_PERIOD) from the mac80211 it 
broke association with hidden-SSID AP .I shall dig deep into this in future.

thanks,
shafi

> Best regards,
>
> Björn
> .
>
>    
