Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34768 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaFEQDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 12:03:53 -0400
Message-ID: <539094E8.9020305@candelatech.com> (sfid-20140605_180356_644589_54EF9477)
Date: Thu, 05 Jun 2014 09:03:52 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Firmware debugging patches?
References: <53891ACD.7070902@candelatech.com> <87wqczz3h9.fsf@kamboji.qca.qualcomm.com> <538CA904.4000508@candelatech.com> <87ioojz1b1.fsf@kamboji.qca.qualcomm.com> <538CB782.1000509@candelatech.com> <87k38vpr28.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87k38vpr28.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2014 03:51 AM, Kalle Valo wrote:
> Hi,
> 
> sorry for jumping in late, I get too much email as usual :/
> 
> Ben Greear <greearb@candelatech.com> writes:
> 
>> [Good stuff snipped, adding linux-wireless as this is a more
>> general issue if we are going to consider general framework]
>>
>>
>> Maybe we should start with goals before getting to implementation
>> details.  Here's my wish list that is ath10k specific, but probably
>> similar to other firmware users:
>>
>> 1)  We need the firmware crash text currently printed to
>> /var/log/messages.
>>
>> 2)  It would be nice to get the firmware RAM and stack dumps at time of
>> crash to debug more interesting crashes.
>>
>> 3)  It would be nice to know about firmware debug messages for
>> the period of time directly before the crash (maybe 2-5 minutes?)
>>
>> 4)  It would be nice to have this interleaved with kernel, supplicant,
>> and related logs.
> 
> I would add:
> 
> 5) A generic user space interface so that the same user space tool can
>    store firmware crash dumps from all wireless drivers and no need to
>    reinvent the wheel.

Looks like the plan to move the feature up into mac80211 once
we get the lower-level details sorted would take care of this.

> 
>> If we are storing crashes for something like ethtool to report, we need
>> RAM and/or disk storage so the firmware RAM dumps and such can be stored until
>> the user and/or automated tools ask for them.  We need some way to automatically
>> clean up old crashes so disk/ram is not overly utilized.  For APs,
>> they are low on both RAM and 'disk', so storing crash logs for any
>> length of time may be problematic.
> 
> I think most, if not all, wireless drivers store the firmware binary in
> RAM forever. I'm having hard time to believe that storing one instance
> (the latest one) of firmware crash dump would make any difference.
> That's why I'm not worried about RAM usage.

I'm concerned about the contents of the target's RAM, not the firmware
binary image.  Each crash would want to store a snapshot of the target's
RAM, including bss regions, stack(s), etc.  Basically, a poor man's
re-implementation of a core file.  In practice, this works out to
less that 100k bytes I think, so likely anything that can run ath10k
has that much memory to spare for debugging efforts...

I think this is resolved well enough in my patch (and iwlwifi does
it slightly differently, but should work too).

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

