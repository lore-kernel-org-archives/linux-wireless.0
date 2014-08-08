Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54445 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaHHRZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 13:25:02 -0400
Message-ID: <53E507EB.7030703@candelatech.com> (sfid-20140808_192507_827222_460418EB)
Date: Fri, 08 Aug 2014 10:24:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Dave Taht <dave.taht@gmail.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: Reporting firmware stats to ethtool
References: <53E3F65D.8080102@candelatech.com> <87wqajz6yg.fsf@kamboji.qca.qualcomm.com> <53E4EFCB.5090501@candelatech.com> <CAA93jw429GCjwiD0FQNFudZ0RDEKShZh4iiuOP+g+PpRjFNT7Q@mail.gmail.com> <53E4F6B8.50009@candelatech.com> <53E4FEA9.80803@broadcom.com>
In-Reply-To: <53E4FEA9.80803@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/2014 09:45 AM, Arend van Spriel wrote:
> On 08/08/2014 06:11 PM, Ben Greear wrote:
>> On 08/08/2014 08:55 AM, Dave Taht wrote:
>>> On Fri, Aug 8, 2014 at 8:42 AM, Ben Greear <greearb@candelatech.com> wrote:
>>>> On 08/08/2014 02:06 AM, Kalle Valo wrote:
>>>>> Ben Greear <greearb@candelatech.com> writes:
>>>>>
>>>>>> I'm working on a patch to report the stats seen in debugfs/...ath10k/fw_stats
>>>>>> as ethtool stats, somewhat similar to how ath9k does it.
>>>>>>
>>>>>> I notice that my user-space tool is reporting huge numbers because
>>>>>> the stats are reset to zero when firmware restarts, and so my tool
>>>>>> thinks the stats wrapped.
>>>>>>
>>>>>> I can fix my tool easily enough, but I first wanted to see if
>>>>>> anyone had strong feelings about keeping the stats from resetting
>>>>>> to zero by storing history and calculating diffs in the driver.
>>>>>>
>>>>>> I think my preference is to punt this to user-space, but if
>>>>>> someone feels otherwise, please let me know sooner than later.
>>>>>
>>>>> I also prefer to have this in user space, but how does user space know
>>>>> when the stats have been zeroed?
>>>>
>>>> Poll often enough that it cannot increment more than 2 billion (or other large number)
>>>> between polls, and then if polled value is less than previous (and difference is > 2 billion),
>>>> we know we had a reset and not a wrap.
>>>
>>> I do kind of prefer 64 bit counters in the general case. Nuke it from
>>> orbit, it's the only way to be sure.
>>
>> It's 64-bit to user-space, but that means nothing because firmware
>> uses 32-bit (or even 16 bit in some cases, probably) internally.
>> A great deal of counters are the same, so be very careful when
>> trying to keep long term counters grabbed from firmware/drivers/hardware.
>>
>> And, stations come and go when you re-associate, so all sorts of wifi counters
>> reset themselves all the time...
> 
> Does ath driver notify mac80211 about firmware restart, ie. through ieee80211_restart_hw(). If only user-space could get that info.

We should soon have a udev event on firmware crash (and a way to read that crash log out of
debugfs).  A simple restart (w/out crash) might not be so interesting?

Might be nice to have a fw restart and fw crash counter in ethtool stats in case something
wants to poll that instead of dealing with uevents.  I will add those counters.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

