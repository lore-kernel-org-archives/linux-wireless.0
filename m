Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50620 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1KHSJD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 13:09:03 -0500
Message-ID: <4EB9703B.6030006@candelatech.com> (sfid-20111108_190908_775782_C887C516)
Date: Tue, 08 Nov 2011 10:08:59 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT/FYI] mac80211: revert on-channel work optimisations
References: <1320772222.24797.22.camel@jlt3.sipsolutions.net>  <4EB96416.5040700@candelatech.com>  <1320772727.24797.23.camel@jlt3.sipsolutions.net>  <4EB9661F.9040901@candelatech.com> <1320775001.24797.26.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320775001.24797.26.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2011 09:56 AM, Johannes Berg wrote:
> On Tue, 2011-11-08 at 09:25 -0800, Ben Greear wrote:
>
>> That's fine by me, I found the code complex as well.  All the tmp
>> and scan and active channel pointers makes for a real mess.
>
> Indeed.
>
>> But if
>> you want multiple vifs to work well, then you really need to be able
>> to continue to function on-channel when some other vif is scanning
>> on that channel.  My use of the wifi stack requires this to work,
>> so if it takes any significant time to get the new code in I'm going
>> to have to stick with my complex crap.
>
> And I'm not saying you shouldn't, but I think for upstream right now
> it's not really a good thing. I wish I could say otherwise but given the
> bugs we have here etc. I don't really feel very confident.

Are there any open bugs right now that seem to be because of the
scanning and work optimizations, or are you just paranoid that
there are more that are not found or well understood yet?

If there is something reported, I'll make a try at fixing it.

> Now with multi-channel stuff it's all going to change anyway, each vif
> will have its own channel and the device will have to mostly sort out
> the scheduling by itself, ath9k will have to do some tricks in the
> driver, maybe with some help in mac80211, and off-channel stuff will be
> interesting too ...

Is someone already working on this, or planning to do so soon?  At least
to me, the multi-channel stuff appears fundamentally broken since I'm
not aware of any NIC that can listen in two channels at once.  Flipping
from channel to channel seems like at best it is going to give bad latency,
and probably lots of packet loss as well.  What is the use-case for this
feature, anyway?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

