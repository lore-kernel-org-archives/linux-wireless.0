Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43912 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab0LHS23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 13:28:29 -0500
Message-ID: <4CFFCE47.8040305@candelatech.com>
Date: Wed, 08 Dec 2010 10:28:23 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Tejun Heo <tj@kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com> <1289594998.3736.11.camel@jlt3.sipsolutions.net> <4CDDAA3B.9090007@candelatech.com> <1289596096.3736.13.camel@jlt3.sipsolutions.net> <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com> <4CE292F7.4090200@kernel.org> <1289929258.3673.1.camel@jlt3.sipsolutions.net> <4CE396A9.1050908@kernel.org> <1290020005.3777.6.camel@jlt3.sipsolutions.net> <4CE4C8DD.6010806@kernel.org> <51f5dd53c39a77fff4efc1a99b189725@localhost> <4CE4D41F.1080005@kernel.org> <1290099585.3801.1.camel@jlt3.sipsolutions.net> <4CE68AF4.8060507@kernel.org> <1290189452.3768.3.camel@jlt3.sipsolutions.net> <4CE6E430.6080804@candelatech.com> <AANLkTimf9D-HP8i99ReVrTqcDHrWchT=HSeTywe_=as0@mail.gmail.com> <4CFFC214.6000608@candelatech.com> <4CFFCC31.1050408@candelatech.com>
In-Reply-To: <4CFFCC31.1050408@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/08/2010 10:19 AM, Ben Greear wrote:
> On 12/08/2010 09:36 AM, Ben Greear wrote:
>> On 11/19/2010 02:27 PM, Luis R. Rodriguez wrote:
>>> On Fri, Nov 19, 2010 at 12:55 PM, Ben Greear<greearb@candelatech.com>
>>> wrote:
>>>> On 11/19/2010 09:57 AM, Johannes Berg wrote:
>>>>>
>>>>> On Fri, 2010-11-19 at 15:34 +0100, Tejun Heo wrote:
>>>>>
>>>>>> Awesome. :-)
>>>>>>
>>>>>> Ben, if you have trouble generating full trace, please let me know if
>>>>>> there's something I can buy which isn't too expensive to reproduce
>>>>>> the
>>>>>> problem. I would be happy to track it down myself.
>>>>>
>>>>> Maybe you can try Ben's setup in kvm (or directly on your box if you
>>>>> like) with mac80211_hwsim. From a mac80211 POV it should be almost
>>>>> equivalent, although it'll do different memory allocation patterns
>>>>> etc.
>>>>
>>>> I tried manually backing out my patch, and now I can no longer
>>>> reproduce
>>>> the problem. Maybe something in -rc2 fixed it, or maybe some changes
>>>> to my environment just made it harder to hit.
>>>>
>>>> If you see no logical reason why calling flush_work with RTNL held
>>>> would cause trouble, then I guess we can just leave the code as is
>>>> for now.
>>>>
>>>> If you do want to play with this yourself, I think any ath5k type
>>>> adapter
>>>> with 64+ virtual stations configured would be a valid test case. My
>>>> application calls ifdown/ifup on them a few times after being created
>>>> and then generates traffic (and gathers stats, calls 'iwconfig', etc).
>>>> As configured in the original scenario that reproduced the problem,
>>>> the STAs had no encryption and were all associating with a single AP.
>>>> wpa_supplicant was not being used.
>>>
>>> FWIW, I had to do similar tests before and Ben offered up a perl
>>> script to do something similar to what his proprietary app does upon
>>> device bring up. I've modified it just a bit and you can find it here:
>>>
>>> http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/poo.pl
>>
>> Well, I backed out my work-around patch yesterday, and then let
>> the system run overnight. This morning it is mostly dead, spewing
>> OOM errors and with a bunch of 'sh' processes using maximum amount
>> of CPU, blocked on trying to acquire rtnl.
>>
>> There is one 'ip' process that appears to hold rtnl and is trying
>> to call ieee80211_do_stop, which is probably blocked down in
>> the work-queue logic just like last time. Lots of worker processes
>> attempting to grab rtnl (and many other processes as well.)
>>
>> Lockdep was disabled because a proprietary module of mine was attempted
>> to be loaded, but it doesn't actual load due to symbol mismatch
>> (it's compiled against a non-debug kernel).
>>
>> If the lockdep info is critical, I can attempt to reproduce with
>> my module completed removed from the file system so it cannot attempt
>> to load, but it seems like last time the 'sysrq t' was of more interest
>> anyway.
>>
>> I have uploaded what I believe is a full 'sysrq t' output, interspersed
>> with OOM warnings that are constantly spewing to the console,
>> here:
>>
>> http://www.candelatech.com/~greearb/minicom_ath9k_log.txt
>
> And here's a log with lockdep enabled:
>
> http://www.candelatech.com/~greearb/minicom_ath9k_log2.txt
>
> The sysrq output starts at line 1346 in this file.
>
> Seems I have a decent environment for reproducing this today,
> in case you have any debug you'd like me to add.

And one more thing:  It seems it doesn't always block forever.
The system in that last trace actually recovered after a
minute or two, though it periodically enters the blocked
state again.

I'm going to re-add my hack, but will be happy to remove
it and test more if you guys want to help debug the problem.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

