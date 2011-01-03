Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33825 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab1ACH32 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 02:29:28 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 02 Jan 2011 23:29:11 -0800
Message-ID: <4D217ACB.6020601@atheros.com>
Date: Mon, 3 Jan 2011 12:59:15 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] Revert "ath9k: Parse DTIM period from mac80211"
References: <1293691681-3574-1-git-send-email-mshajakhan@atheros.com> <871v4xgdfp.fsf@purkki.adurom.net> <20110102085300.GA14217@jm.kir.nu>
In-Reply-To: <20110102085300.GA14217@jm.kir.nu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 02 January 2011 02:23 PM, Jouni Malinen wrote:
> On Sat, Jan 01, 2011 at 11:50:50AM +0200, Kalle Valo wrote:
>    
>> Mohammed Shafi Shajakhan<mshajakhan@atheros.com>  writes:
>>      
>>> * Preventing association with broken AP's
>>>        
>> How can different dtim value cause problems with association? Power
>> save should not be even enabled during association. Or do you mean
>> there are problems after association, for example during eap
>> negotation?
>>      
> It is not the DTIM value, it is the part of having to receive a Beacon
> frame before even trying to associate. This is very much a corner case,
> but well, that behavior did change with the commit.
>
>    
>>> * Adds latency in roaming
>>>        
>> We should try to solve this problem differently than hardcoding dtim.
>> There are other ways to trigger roaming than just following beacons.
>> And if there's no data, there's no need to roam either.
>>      
> This is about the part of waiting for Beacon frame before trying to
> associate, not about hardcoding DTIM for any other purpose.
>
>    
>>> So its better to always use the safe value of '1' for dtim period
>>>        
>> By hardcoding dtim you increase the power consumption in the case when
>> there is no data traffic, so it's not definitely better in all cases.
>>   di
>> I would prefer to fix the real issues instead of hardcoding dtim. And
>> if it's really essential to hardcode it now, please add a big fat
>> warning indicating that this is a temporary solution and should be
>> fixed properly without hardcoding anything.
>>      
  I agree .In the ath9k  we wake up for every beacons, and even 
obtaining the DTIM period will not change it, unless we change the wake 
up time to be based on DTIM period. I thought of changing it, but was 
afraid that it might introduce some other critical problems.
> The real issue (as far as I can tell) was that ath9k was changed to
> require mac80211 to get it DTIM period before association. I'm not aware
> of any need for that with ath9k. It should have no problems updating PS
> parameters after association and as such, should not require mac80211 to
> figure DTIM period out before being able to associate. This change is
> not about hardcoding DTIM period; it is about removing unneeded change
> that added extra latency without any real gain.
>
>    
As the power save does not seems to be configured based on this I 
thought there wont be no issues in getting the actual DTIM period, but 
never had a clue this might have introduced these problems.
