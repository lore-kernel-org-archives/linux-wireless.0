Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:49627 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263Ab3BLKaO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 05:30:14 -0500
Message-ID: <511A1867.6060708@neratec.com> (sfid-20130212_113020_865710_72F0C836)
Date: Tue, 12 Feb 2013 11:24:39 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [BUG] Beacon loss event every second
References: <5118F682.8000502@neratec.com> <1360592857.8738.30.camel@jlt4.sipsolutions.net> <51190341.40806@neratec.com> <87bobpc0ft.fsf@purkki.adurom.net> <511A15D4.6070808@neratec.com> <877gmdbzkc.fsf@purkki.adurom.net>
In-Reply-To: <877gmdbzkc.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/2013 11:23 AM, Kalle Valo wrote:
> Wojciech Dubowik <Wojciech.Dubowik@neratec.com> writes:
>
>> I have a test pc with 3x AR9590 and 2x AR9390. Machine is based on i7
>> and hyperthreading is on so I have 8 cores.
>> I am using latest wireless testing ath9k and 3.8rc7 kernel.
>>
>> What I see is that for some extended periods odf time beacons are not
>> processed in ieee80211_rx_mgmt_beacon
>> and that's why I get beacon loss. I am using 30ms beacon period.
>>
>>
>> What is really funny, that I get this beacon loss message every
>> second. Like is sth was locking ifmgd->mtx mutex
>> at constant intervals.
>>
>>
>> I will try to disable all cores and run in again to see if it's rcu problem.
> You could also try wireless-next or wireless-testing to pinpoint if the
> problem is in wireless code or not.
>
I see it on wireless-testing and mac80211-next. I will try with other 
driver later today.

I can see also other problem like authentication frame always timing out 
the first time
but I will handle it later.
