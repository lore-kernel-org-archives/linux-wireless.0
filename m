Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:35341 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab3BMMug (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 07:50:36 -0500
Message-ID: <511B8ACE.4040408@neratec.com> (sfid-20130213_135041_267331_D22CF2CE)
Date: Wed, 13 Feb 2013 13:45:02 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [BUG] Beacon loss event every second
References: <5118F682.8000502@neratec.com> <1360592857.8738.30.camel@jlt4.sipsolutions.net> <51190341.40806@neratec.com> <87bobpc0ft.fsf@purkki.adurom.net> <511A15D4.6070808@neratec.com> <877gmdbzkc.fsf@purkki.adurom.net> <511A1867.6060708@neratec.com> <511A1D88.6080406@neratec.com>
In-Reply-To: <511A1D88.6080406@neratec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/2013 11:46 AM, Wojciech Dubowik wrote:
> On 02/12/2013 11:24 AM, Wojciech Dubowik wrote:
>> On 02/12/2013 11:23 AM, Kalle Valo wrote:
>>> Wojciech Dubowik <Wojciech.Dubowik@neratec.com> writes:
>>>
>>>> I have a test pc with 3x AR9590 and 2x AR9390. Machine is based on i7
>>>> and hyperthreading is on so I have 8 cores.
>>>> I am using latest wireless testing ath9k and 3.8rc7 kernel.
>>>>
>>>> What I see is that for some extended periods odf time beacons are not
>>>> processed in ieee80211_rx_mgmt_beacon
>>>> and that's why I get beacon loss. I am using 30ms beacon period.
>>>>
>>>>
>>>> What is really funny, that I get this beacon loss message every
>>>> second. Like is sth was locking ifmgd->mtx mutex
>>>> at constant intervals.
>>>>
>>>>
>>>> I will try to disable all cores and run in again to see if it's rcu 
>>>> problem.
>>> You could also try wireless-next or wireless-testing to pinpoint if the
>>> problem is in wireless code or not.
>>>
>> I see it on wireless-testing and mac80211-next. I will try with other 
>> driver later today.
>>
>> I can see also other problem like authentication frame always timing 
>> out the first time
>> but I will handle it later.
> It has turned out that I had bad irq, switch to polling problem. 
> Without interrupts for wireless
> cards I will for sure see such problems.
After solving the bad irq problems I can still see the issue.

It has turned out that when I set beacon interval to less than 40ms I 
get beacon loss events.

My setup is ath9k AP and ath9k STA on the same pc connected with rf 
cable and 40dB attenuator.

I have seen this problem also with earlier versions of wireless testing 
and next.

Wojtek
>
> Sorry for spamming.
>
> Wojtek
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

