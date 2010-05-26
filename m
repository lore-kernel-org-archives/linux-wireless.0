Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35274 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab0EZSHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 14:07:53 -0400
Received: by pvg3 with SMTP id 3so1240044pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 11:07:53 -0700 (PDT)
Message-ID: <4BFD638A.7060908@gmail.com>
Date: Wed, 26 May 2010 11:08:10 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linville@tuxdriver.com, arnd@arndnet.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Fix ath_print in xmit for harware reset.
References: <1274896002-10866-1-git-send-email-justinmattock@gmail.com> 	<AANLkTimrFUYIkTQ7ev-AL0V8y0Lot064h8JK_fU81Lyr@mail.gmail.com> 	<4BFD620B.8010301@gmail.com> <AANLkTilrXZCtJpTrynPlC0FbNfpXcfgYg1Pd6_2oOZml@mail.gmail.com>
In-Reply-To: <AANLkTilrXZCtJpTrynPlC0FbNfpXcfgYg1Pd6_2oOZml@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/26/2010 11:03 AM, Luis R. Rodriguez wrote:
> On Wed, May 26, 2010 at 11:01 AM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>    
>> On 05/26/2010 10:50 AM, Luis R. Rodriguez wrote:
>>      
>>> On Wed, May 26, 2010 at 10:46 AM, Justin P. Mattock
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
>>>> ---
>>>>   drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
>>>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c
>>>> b/drivers/net/wireless/ath/ath9k/xmit.c
>>>> index 3db1917..617db8e 100644
>>>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>>>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>>>> @@ -1198,7 +1198,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool
>>>> retry_tx)
>>>>                 int r;
>>>>
>>>>                 ath_print(common, ATH_DBG_FATAL,
>>>> -                         "Unable to stop TxDMA. Reset HAL!\n");
>>>> +                         "ath9k: Failed to stop TX DMA. Resetting
>>>> hardware!\n");
>>>>
>>>>          
>>> Nack, No need to put "ath9k:" since ath_print already prepends "ath: "
>>>
>>>    Luis
>>>
>>>
>>>        
>> ah.. so the ATH_DBG_FATAL takes care of that?
>> resent..
>>      
> No FATAL just makes sure it prints all the time, even if you do not
> have debugging enabled. Go read ath_print() though.
>
>    Luis
>
>    
alright!!

Justin P. Mattock
