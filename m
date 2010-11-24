Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44748 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab0KXFG4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 00:06:56 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 21:06:43 -0800
Message-ID: <4CEC9D6B.1000506@atheros.com>
Date: Wed, 24 Nov 2010 10:36:51 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Paul Shaw <Paul.Shaw@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: Add support for Adaptive Power Management
References: <1290525147-6927-1-git-send-email-mshajakhan@atheros.com> <4CEBE389.1020209@openwrt.org>
In-Reply-To: <4CEBE389.1020209@openwrt.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 23 November 2010 09:23 PM, Felix Fietkau wrote:
> On 2010-11-23 4:12 PM, Mohammed Shafi Shajakhan wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> This feature is to mitigate the problem of certain 3
>> stream chips that exceed the PCIe power requirements.An EEPROM flag
>> controls which chips have APM enabled which is basically read from
>> miscellaneous configuration element of the EEPROM header.
>>
>> This workaround will reduce power consumption by using 2 Tx chains for
>> Single and Double stream rates (5 GHz only).All self generated frames
>> (regardless of rate) are sent on 2 chains when this feature is
>> enabled(Chip Limitation).
>>
>> Cc: Paul Shaw<paul.shaw@atheros.com>
>> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>> Tested-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>I
>>      
> I think this code would get a lot more concise if you'd move it to
> ar9003_mac.c, since this issue is AR9003 specific anyway.
> It would also allow you to avoid adding yet another redundant ath_softc
> capability flag, as the driver part really doesn't need to be concerned
> with this.
>    
Thanks for reviewing the code and for your valuable comments.
1.I get a feeling when we add this to ar9003_mac.c this feature won't be 
much explicit  and might be hard to debug if any issue comes.You might 
have noticed we might be using APM only for non-PAPRD frames.
2.This feature may be applicable for future 3 stream chips (or) in case 
of Power Management we can even disable the third chain (1S and 2S 
rates) while trading of throughput slightly for all 3 stream chips.
3.Yes ath_softc flag might be reduntant I will look into it.
4.There were so many things directly available in xmit.c such as rate 
descriptor,band(5Ghz or 2 Ghz) we are using,whether its a PAPRD frame, 
to looking for single stream and double stream etc.I really dont know 
whether all these things will be available directly available in 
ar9003_mac.c but it would be very difficult to track them and do all the 
right things.
         I will surely look to concise the code in near future , but now 
I think we can have it in upstream.I had tested it and there were no 
issues in fucntionality.
thanks,
shafi

> - Felix
> .
>
>    
