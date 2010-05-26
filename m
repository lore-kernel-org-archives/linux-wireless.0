Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36234 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab0EZRt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 13:49:27 -0400
Received: by pwi7 with SMTP id 7so310984pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 10:49:27 -0700 (PDT)
Message-ID: <4BFD5F2F.4050708@gmail.com>
Date: Wed, 26 May 2010 10:49:35 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Arnd Hannemann <arnd@arndnet.de>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@gmail.com
Subject: Re: [PATCH]wireless:ath9k Fix ath_print in xmit.c
References: <1274894056-2866-1-git-send-email-justinmattock@gmail.com> <4BFD5A49.4050601@arndnet.de>
In-Reply-To: <4BFD5A49.4050601@arndnet.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/26/2010 10:28 AM, Arnd Hannemann wrote:
> Am 26.05.2010 19:14, schrieb Justin P. Mattock:
>    
>> ath_print in xmit.c should say "Reseting hardware"
>> instead of Reaseting HAL!(since HAL is being fazed out).
>> dmesg shows:
>> [ 8660.899624] ath: Failed to stop TX DMA in 100 msec after killing last frame
>> [ 8660.899676] ath: Unable to stop TxDMA. Reset HAL!
>>
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
>> index 3db1917..2a0558e 100644
>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>> @@ -1198,7 +1198,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
>>   		int r;
>>
>>   		ath_print(common, ATH_DBG_FATAL,
>> -			  "Unable to stop TxDMA. Reset HAL!\n");
>> +			  "Unable to stop TxDMA. Reseting hardware!\n");
>>
>>      
> 1.) Should'nt it read "Resetting"
> 2.) Why "common" ? Seems it is ath9k specific so message should read
> "ath9k: Failed to stop TX DMA"
> 3.) While we are at it write "TX DMA" instead of "TxDMA" just to be
> consistent...
>    

pretty bad!! I cant spell.
>>
>>   		spin_lock_bh(&sc->sc_resetlock);
>>   		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, false);
>>
>>      
> Best regards,
> Arnd
>
>
>    
o.k. re-submitted, with the above fixes, if good
let me know..(a bit confused with the signed off
stuff(if I need to re-du to add the correct signed-off's
let me know))

Justin P. mattock
