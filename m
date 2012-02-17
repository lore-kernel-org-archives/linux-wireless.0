Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47362 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab2BQSi7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 13:38:59 -0500
Message-ID: <4F3E9EBE.60602@candelatech.com> (sfid-20120217_193903_152581_4E0A9BED)
Date: Fri, 17 Feb 2012 10:38:54 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT/FYI] mac80211: revert on-channel work optimisations
References: <1320772222.24797.22.camel@jlt3.sipsolutions.net>  <4EB96416.5040700@candelatech.com>  (sfid-20111108_181718_795911_9F0A2B63) <1329493491.3786.6.camel@jlt3.sipsolutions.net>  <4F3E7CA5.7010207@candelatech.com> <1329502761.3330.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1329502761.3330.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/2012 10:19 AM, Johannes Berg wrote:
> On Fri, 2012-02-17 at 08:13 -0800, Ben Greear wrote:
>
>>> Given the auth/assoc redesign that went in now, are you still carrying
>>> this? Does the redesign address your problem?
>>
>> I haven't looked yet...still stuck back on 3.0 kernel for the
>> most part.
>>
>> I should be moving to 3.3 sometime soon, and will see how it works.
>>
>> I was thinking that I would ignore the work logic for now and probably
>> just focus on re-applying the on-channel scan optimization first.
>>
>> Are you done, or mostly done with the re-architecture you were working on?
>
> Yes, I'm done.
>
>> I know you didn't like the scan optimization from before...do you have any
>> ideas on how it might be done more to your liking?
>
> I, umm, don't even remember what that was about :)

The basic idea is that if the user requests that we only
scan a single channel, and that channel is the operating channel,
we should be able to scan without interrupting any other
packet transmission/reception, and without kicking the NIC to make it go off/on
channel, etc.

Basically I had to complicate the scan state machine
in order to minimize going off-channel (if indeed we are only
scanning one current channel).

I'd want to re-add the logic that let us receive pkts while
scanning (so long as we are scanning on the oper-channel)
as well.

Might be a while before I can get back to this, but I'll
let you know when I get started if no one beats me to it.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

