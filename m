Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:41649 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab0LCEoS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 23:44:18 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 20:44:03 -0800
Message-ID: <4CF87597.5080900@atheros.com>
Date: Fri, 3 Dec 2010 10:14:07 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Properly use unlikely check macro
References: <1291044477-2317-1-git-send-email-mshajakhan@atheros.com> <20101202202127.GF2358@tuxdriver.com>
In-Reply-To: <20101202202127.GF2358@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 03 December 2010 01:51 AM, John W. Linville wrote:
> On Mon, Nov 29, 2010 at 08:57:57PM +0530, Mohammed Shafi Shajakhan wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> AUTOSLEEP feature is enabled only AR9003 and later chips.So unlikely
>> macro should be used only to check whether auto-sleep feature is enabled
>>
>> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/recv.c |    6 +++---
>>   1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>> index 262c815..751ee1b 100644
>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>> @@ -1743,10 +1743,10 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>>   		}
>>
>>   		spin_lock_irqsave(&sc->sc_pm_lock, flags);
>> -		if (unlikely(ath9k_check_auto_sleep(sc) ||
>> -			     (sc->ps_flags&  (PS_WAIT_FOR_BEACON |
>> +		if ((sc->ps_flags&  (PS_WAIT_FOR_BEACON |
>>   					      PS_WAIT_FOR_CAB |
>> -					      PS_WAIT_FOR_PSPOLL_DATA))))
>> +					      PS_WAIT_FOR_PSPOLL_DATA)) ||
>> +				unlikely(ath9k_hw_check_auto_sleep(sc)))
>>   			ath_rx_ps(sc, skb);
>>   		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
>>      
> What tree is this against?
>    
2.6.37-rc4 ..Any problems in applying.Do I have to resend it based on 
the latest pull ?
thanks,
shafi
