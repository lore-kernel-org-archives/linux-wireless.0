Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:49418 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab0LRKjp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 05:39:45 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 18 Dec 2010 02:39:30 -0800
Message-ID: <4D0C8F66.50407@atheros.com>
Date: Sat, 18 Dec 2010 16:09:34 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Properly initialize channel table for 2GHz
References: <1292598876-8242-1-git-send-email-mshajakhan@atheros.com> <AANLkTiky2ODWt-ocSy_+=9k9_E=7ekvLMLbQtir-cd-r@mail.gmail.com>
In-Reply-To: <AANLkTiky2ODWt-ocSy_+=9k9_E=7ekvLMLbQtir-cd-r@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 18 December 2010 01:21 AM, Luis R. Rodriguez wrote:
> On Fri, Dec 17, 2010 at 7:14 AM, Mohammed Shafi Shajakhan
> <mshajakhan@atheros.com>  wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> ath9k channel table for 2Ghz does not seems to initialize the 'band'
>> parameter.Though it does not seems to cause any visible issue it looks
>> odd when we initialize the 'band' parameter for 5Ghz channel table while
>> not so for 2Ghz.
>>
>> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/init.c |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
>> index 1238795..b0e5e71 100644
>> --- a/drivers/net/wireless/ath/ath9k/init.c
>> +++ b/drivers/net/wireless/ath/ath9k/init.c
>> @@ -48,6 +48,7 @@ MODULE_PARM_DESC(pmqos, "User specified PM-QOS value");
>>   /* We use the hw_value as an index into our private channel structure */
>>
>>   #define CHAN2G(_freq, _idx)  { \
>> +       .band = IEEE80211_BAND_2GHZ, \
>>         .center_freq = (_freq), \
>>         .hw_value = (_idx), \
>>         .max_power = 20, \
>>      
> That's fine but its not needed at all as the band is already
> kzalloc()'d so it gets zeroed out and the IEEE80211_BAND_2GHZ enum is
> 0, so its not required to be explicit and set it. But if it gives you
> the warm fuzzies sure.
>    
Oh ok fine, then no problem. I could not trace any  warnings if 'band' 
parameter was not used, as the code looked suspicious I had sent a patch.
thanks,
shafi

>    Luis
>    
