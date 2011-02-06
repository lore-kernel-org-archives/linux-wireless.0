Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63749 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1BFUXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 15:23:25 -0500
Received: by iwn9 with SMTP id 9so3954111iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Feb 2011 12:23:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D4EFF68.9060101@candelatech.com>
References: <4D4EF004.3040109@candelatech.com> <4D4EF99D.5020601@openwrt.org>
 <4D4EFC76.6090000@candelatech.com> <4D4EFD87.4010005@openwrt.org> <4D4EFF68.9060101@candelatech.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Sun, 6 Feb 2011 12:23:04 -0800
Message-ID: <AANLkTin6ia8mYsS4LOFTyZoD-dKUgUBGo6uMFt=FjTcY@mail.gmail.com>
Subject: Re: Scanning and channel types.
To: Ben Greear <greearb@candelatech.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Could be rate selection.

Ben, a sanity check:  is it possible for the device to be associated
to an "HT-Only" AP and thus not be able to sent NO_HT packets?  Could
that be why there might need to be a channel change sometimes?

Dan

On Sun, Feb 6, 2011 at 12:07 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 02/06/2011 11:59 AM, Felix Fietkau wrote:
>>
>> On 2011-02-06 8:54 PM, Ben Greear wrote:
>>>
>>> On 02/06/2011 11:42 AM, Felix Fietkau wrote:
>>>>
>>>> On 2011-02-06 8:01 PM, Ben Greear wrote:
>>>>>
>>>>> Current code always sets the channel type to NO_HT when scanning.
>>>>>
>>>>>   From what I can tell, we should be able to send NO_HT packets on
>>>>> any channel type, and for passive scanning, it should not matter
>>>>> at all what channel-type we are using.
>>>>>
>>>>> I tested relaxing scanning to use the current channel type
>>>>> when scanning on the operating channel, and it seems to
>>>>> work.
>>>>>
>>>>> Does anyone see any problems with this approach?
>>>>
>>>> One thing you should make sure is that once you're done associating to
>>>> an NO_HT or HT20 AP (and you have no other interfaces to consider), the
>>>> channel mode must not be HT40 - otherwise it could reduce throughput.
>>>
>>> That is currently handled correctly by the ieee80211_set_channel_type
>>> method, as far as I can tell...
>>>
>>> Regardless of that, in my multi-vif testing, I see lower throughput when
>>> using HT40- than using HT20 (between 128 ath9k vif machine and 1 VAP
>>> ath9k machine).
>>> The VIFS all claim 300Mbps rate.
>>> I haven't looked into this any further at this point...
>>
>> Well, with HT40 you take a hit from not just the busy time of the
>> primary channel, but also from the busy time of the extension channel.
>> If you have other wifi activity on the extension channel, then it's
>> normal that this would reduce throughput.
>
> There were a few other APs on that channel, but they were not doing any
> active work
> (just beacons and such).  The two ath9k systems were very busy
> talking to each other.  My typical work-load is STA sending to STA
> through the AP.
>
> So, would that scenario be likely to cause the slowdown that you
> mention?
>
> Thanks,
> Ben
>
>>
>> - Felix
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
