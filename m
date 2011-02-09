Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:28706 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776Ab1BIOzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:55:38 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 06:55:17 -0800
Message-ID: <4D52AAE5.4050300@atheros.com>
Date: Wed, 9 Feb 2011 20:25:33 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: =?UTF-8?B?QmrDtnJuIFNtZWRtYW4=?= <bjorn.smedman@venatech.se>,
	Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 1/1] ath9k: Update comments for not parsing DTIM period
References: <1297093108-28541-1-git-send-email-mshajakhan@atheros.com> <AANLkTimXCXW8mT8tPbSuCDpwyyD=NSRyBvFcC2Y+Nq7N@mail.gmail.com> <20110209143853.GA6519@jm.kir.nu>
In-Reply-To: <20110209143853.GA6519@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 February 2011 08:08 PM, Jouni Malinen wrote:
> On Tue, Feb 08, 2011 at 10:22:39PM +0100, Björn Smedman wrote:
>    
>> On Mon, Feb 7, 2011 at 4:38 PM, Mohammed Shafi Shajakhan
>> <mshajakhan@atheros.com>  wrote:
>>      
>>> -        * Some times we dont parse dtim period from mac80211, in that case
>>> -        * use a default value
>>> +        * We don't parse dtim period from mac80211 during the driver
>>> +        * initialization as it breaks association with hidden-ssid
>>> +        * AP and it causes latency in roaming
>>>        
>    
>> I realize I'm not the perfect representative for the intended audience
>> but I don't understand that comment at all. The previous one made
>> sense to me, but the new one seems to refer to some logic somewhere
>> else. In ath_beacon_config() I expect AP/IBSS logic but the comment
>> seems to be about some special case for a STA vif associating with a
>> hidden access point, no? I don't understand that special case either
>> but that is more easily attributable to ignorance. :)
>>      
> While I agree that the proposed comment is quite confusing, this
> function is actually used even in station mode to set beacon timers for
> when to wake up for receiving beacon frames, etc. However, I don't see
> why this comment should really be here. In addition, this should really
> be fixed by updating DTIM period after the first Beacon frame is
> received. Forcing a wait for that Beacon frame is the one that causes
> the extra latency; I don't remember why exactly this would break
> hidden SSID case unless there is another bug somewhere.
>    
Jouni I had validate few times with our AP and it does broke assoc with 
hidden SSID AP.

thanks,
shafi

> ath9k does not need to know the DTIM period before association and the
> first call to this function may need to handle the 0 ->  1 safety check.
> This should then be followed by another call (likely new code in
> mac80211 needed for this) to update the timers after the DTIM period has
> been learned post-association.
>
>    
