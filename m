Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53931 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab0EZSLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 14:11:51 -0400
Received: by pwi7 with SMTP id 7so321385pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 11:11:50 -0700 (PDT)
Message-ID: <4BFD6478.8090700@gmail.com>
Date: Wed, 26 May 2010 11:12:08 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linville@tuxdriver.com, arnd@arndnet.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH][RESEND] ath9k: Fix ath_print in xmit for hardware reset.
References: <1274896804-19441-1-git-send-email-justinmattock@gmail.com> 	<AANLkTilII7C41BTshkXyCmAU81LQ3fJF0ogq_BLVv6w-@mail.gmail.com> 	<4BFD636B.3070607@gmail.com> <AANLkTikIfbrD7t122jJG-ODU5qb9sbGVIGrHlNJ7w2ia@mail.gmail.com>
In-Reply-To: <AANLkTikIfbrD7t122jJG-ODU5qb9sbGVIGrHlNJ7w2ia@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/26/2010 11:09 AM, Luis R. Rodriguez wrote:
> On Wed, May 26, 2010 at 11:07 AM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>    
>> On 05/26/2010 11:02 AM, Luis R. Rodriguez wrote:
>>      
>>> On Wed, May 26, 2010 at 11:00 AM, Justin P. Mattock
>>> <justinmattock@gmail.com>    wrote:
>>>
>>>        
>>>> ath_print in xmit.c should say "Reseting hardware"
>>>> instead of Resetting HAL!(since HAL is being fazed out).
>>>> dmesg shows:
>>>> [ 8660.899624] ath: Failed to stop TX DMA in 100 msec after killing last
>>>> frame
>>>> [ 8660.899676] ath: Unable to stop TxDMA. Reset HAL!
>>>>
>>>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>>
>>>>
>>>>          
>>> For next time, no need for extra spaces between the SOB and the ---.
>>> And instead of RESEND do [PATCH v2]. Please read:
>>>
>>> http://wireless.kernel.org/en/developers/Documentation/git-guide
>>>
>>>
>>>        
>> o.k.!!
>>      
>>>> ---
>>>>   drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
>>>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c
>>>> b/drivers/net/wireless/ath/ath9k/xmit.c
>>>> index 3db1917..09cb13c 100644
>>>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>>>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>>>> @@ -1198,7 +1198,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool
>>>> retry_tx)
>>>>                 int r;
>>>>
>>>>                 ath_print(common, ATH_DBG_FATAL,
>>>> -                         "Unable to stop TxDMA. Reset HAL!\n");
>>>> +                         "Failed to stop TX DMA. Resetting
>>>> hardware!\n");
>>>>
>>>>                 spin_lock_bh(&sc->sc_resetlock);
>>>>                 r = ath9k_hw_reset(ah, sc->sc_ah->curchan, false);
>>>>
>>>>          
>>> Thanks, this is good.
>>>
>>>    Luis
>>>
>>>
>>>        
>> what about all the signed-off's? should I
>> resend with all of those, or no?
>>      
> I do not get what you are asking.
>
>    Luis
>
>    
all the people that gave there 00.02$ on this to
make it all-good

Justin P. Mattock
