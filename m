Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59348 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbbCaP4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 11:56:39 -0400
Message-ID: <551AC3B6.1040001@candelatech.com> (sfid-20150331_175644_926590_84B884DD)
Date: Tue, 31 Mar 2015 08:56:38 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211_hwsim: notify user-space about channel change.
References: <1424217588-29558-1-git-send-email-greearb@candelatech.com>  	  (sfid-20150218_005956_617537_D2A9B91F) <1424692155.2782.6.camel@sipsolutions.net>  	 <54EB66CC.1030800@candelatech.com>   <1424772714.2192.16.camel@sipsolutions.net>   <54EC8C5D.5090400@candelatech.com>  <1424788834.2192.34.camel@sipsolutions.net>  <5500AE12.6040103@candelatech.com> <1427812067.2057.27.camel@sipsolutions.net>
In-Reply-To: <1427812067.2057.27.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/31/2015 07:27 AM, Johannes Berg wrote:
> On Wed, 2015-03-11 at 14:05 -0700, Ben Greear wrote:
> 
>> I took a look at the hw-scan code a bit...I guess we might could do additional
>> info calls to user-space as we iterate through the channels while scanning?
>>
>> A real driver would be causing the NIC to change channels at these junctures,
>> either by directly setting registers or sending some message off to the
>> target NIC's cpu, right?
> 
> Well, depends. Our driver just asks the firmware to do the scan, and it
> will do all the scheduling by itself, i.e. it'll go through the channels
> at convenient times etc.

I do not want to offload scanning in user-space, which is the equivalent
of what your driver is doing as far as the kernel is concerned?  If someone wants
to do that in the future, then sure, they can implement such a thing.

>> I would assume that off-channel work could do similar logic.
> 
> Yeah.
> 
>> Is that the sort of thing you had in mind?
> 
> To be honest, I'm not really sure myself. It seems to really do this
> you'd also need powersave handling (tell the AP you're going to sleep
> when scanning) and potentially P2P-GO NoA handling (tell the clients
> you're going to sleep).

Yes, I have plans to do that sort of thing..but I have not looked into
it properly yet.  Either way, it seems a bit orthogonal to changing
the channel..like first we send the PS packets, then change channel,
etc.


> The thing with hwsim right now is that it totally makes use of its
> ability to be on as many channels at the same time as it wants, so it
> doesn't have to worry about that, but if you want to actually have the
> channel "changed" then we need to handle a lot more details.

One step at a time I think...my patch should not break anything..userspace
that doesn't care can simply ignore the new message.

Thanks,
Ben

> 
> johannes
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

