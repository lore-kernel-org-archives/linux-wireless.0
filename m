Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48812 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab1AaRaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 12:30:35 -0500
Message-ID: <4D46F1B4.1020504@candelatech.com>
Date: Mon, 31 Jan 2011 09:30:28 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC v3] mac80211:  Optimize scans on current operating channel.
References: <1296074238-4012-1-git-send-email-greearb@candelatech.com>	 <1296136347.3622.55.camel@jlt3.sipsolutions.net>	 <4D41BA91.30608@candelatech.com>	 <1296220846.5118.1.camel@jlt3.sipsolutions.net>	 <4D431778.1000604@candelatech.com> <1296482183.3812.29.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296482183.3812.29.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2011 05:56 AM, Johannes Berg wrote:
>
>>> However -- I was thinking of something else, not data packets. While
>>> scanning, all received beacons will be handed to the scan code. But if
>>> the mlme code isn't told to stop looking for them, it'll still expect to
>>> see the beacons.
>>
>> Currently, it seems mlme timers are stopped when we start scanning,
>> and then started when scanning is complete.
>
> Ok, I wasn't quite sure about that part -- whether it happened when
> going off-channel or when starting scan. If it happened while going
> off-channel this would've been problematic here.
>
>> However, I don't see any similar effort in the work_work() method
>> when it goes off-channel.
>>
>> Should we move the timer pause&  restart logic into the offchannel_stop_vifs
>> and offchannel_return methods?
>
> Well, sort of no, and sort of yes -- both will disrupt that code in a
> sense, but even scanning on the same channel will disrupt it due to the
> beacon diversion, unless we copy the beacons and give them to both sides
> (scan and mlme)?

Seems to me both sides should get them.  I'll try to figure out how to
do that properly today.

But, if work_work() takes us off-channel often enough, wouldn't that
cause undue beacon loss and/or timed-out tx acks?  Are there any guarantees
about how often and how long work_work() can take us off-channel?

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
