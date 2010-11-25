Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:60980 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab0KYFdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 00:33:25 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 21:33:11 -0800
From: Paul Shaw <Paul.Shaw@Atheros.com>
To: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 24 Nov 2010 21:33:21 -0800
Subject: RE: [PATCH] ath9k: Add support for Adaptive Power Management
Message-ID: <BD672EAEE3AD2C47A7120B0973C3FB3A47F2E6771A@SC1EXMB-MBCL.global.atheros.com>
References: <1290525147-6927-1-git-send-email-mshajakhan@atheros.com>
 <4CEBE389.1020209@openwrt.org> <4CEC9D6B.1000506@atheros.com>
 <4CED4E32.3050502@openwrt.org> <4CEDE506.5020800@atheros.com>
In-Reply-To: <4CEDE506.5020800@atheros.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think Mohammed explained the key points of why this feature is in the upper layer (above the HAL).
I went back and forth on this myself before implementing it above the HAL in our internal code base (newma).

It would have been much simpler to implement in the HAL, but I chose to place it above the HAL because
1. The HAL is supposed to be dumb and stateless. How to set the individual fields of the tx descriptor is decided above the HAL. The HAL just fills in the hw specific descriptor.
2. This feature will span multiple HALs (ar9300 and future HALs)
3. The upper layer already contains code to manipulate the tx chain mask.  This is just another feature that manipulates the tx chain mask.  
4. The APM feature will not be applied to all tx frames (e.g. PAPRD transmits should be unmodified).  This was probably the deciding factor in placing APM above the HAL.

Hope this gives some insight into the decision.  

Thanks,
Paul


-----Original Message-----
From: Mohammed Shajakhan 
Sent: Wednesday, November 24, 2010 8:25 PM
To: Felix Fietkau
Cc: linville@tuxdriver.com; Luis Rodriguez; Paul Shaw; linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Add support for Adaptive Power Management

On Wednesday 24 November 2010 11:11 PM, Felix Fietkau wrote:
> On 2010-11-24 6:06 AM, Mohammed Shafi wrote:
>    
>> On Tuesday 23 November 2010 09:23 PM, Felix Fietkau wrote:
>>      
>>> On 2010-11-23 4:12 PM, Mohammed Shafi Shajakhan wrote:
>>>
>>>        
>>>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>>>
>>>> This feature is to mitigate the problem of certain 3
>>>> stream chips that exceed the PCIe power requirements.An EEPROM flag
>>>> controls which chips have APM enabled which is basically read from
>>>> miscellaneous configuration element of the EEPROM header.
>>>>
>>>> This workaround will reduce power consumption by using 2 Tx chains for
>>>> Single and Double stream rates (5 GHz only).All self generated frames
>>>> (regardless of rate) are sent on 2 chains when this feature is
>>>> enabled(Chip Limitation).
>>>>
>>>> Cc: Paul Shaw<paul.shaw@atheros.com>
>>>> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>>> Tested-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>I
>>>>
>>>>          
>>> I think this code would get a lot more concise if you'd move it to
>>> ar9003_mac.c, since this issue is AR9003 specific anyway.
>>> It would also allow you to avoid adding yet another redundant ath_softc
>>> capability flag, as the driver part really doesn't need to be concerned
>>> with this.
>>>
>>>        
>> Thanks for reviewing the code and for your valuable comments.
>> 1.I get a feeling when we add this to ar9003_mac.c this feature won't be
>> much explicit  and might be hard to debug if any issue comes.You might
>> have noticed we might be using APM only for non-PAPRD frames.
>> 2.This feature may be applicable for future 3 stream chips (or) in case
>> of Power Management we can even disable the third chain (1S and 2S
>> rates) while trading of throughput slightly for all 3 stream chips.
>> 3.Yes ath_softc flag might be reduntant I will look into it.
>> 4.There were so many things directly available in xmit.c such as rate
>> descriptor,band(5Ghz or 2 Ghz) we are using,whether its a PAPRD frame,
>> to looking for single stream and double stream etc.I really dont know
>> whether all these things will be available directly available in
>> ar9003_mac.c but it would be very difficult to track them and do all the
>> right things.
>>           I will surely look to concise the code in near future , but now
>> I think we can have it in upstream.I had tested it and there were no
>> issues in fucntionality.
>>      
> Makes sense, let's get your change in then.
>    
Thanks for your understanding. Currently I don't have clear idea to 
implement the same in the ar9003_mac.c  and if I do it now, the testing 
again will be taking a lot of time to make sure that this does not 
affects stability,throughput etc.For instance initially there was a drop 
in throughput only because when the legacy rates are enabled with APM 
and I had no clue it was due to PAPRD frames (a more experienced person 
figured that out).
> After I'm done cleaning up the tx aggregation path, I intend to
> consolidate all the functions that deal with preparing the tx
> descriptor, as the API for that in ath9k_hw has become quite messy.
>    
Ok sure and Paul who conceived this idea might have thought of this and 
thats why he would have implemented in the driver part.
> That will lead to fewer reads/writes to uncached memory and will also
> make it much easier to implement the cleanups that I suggested.
>    
Thanks.
> - Felix
> .
>
>    
