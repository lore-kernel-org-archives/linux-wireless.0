Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44045 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2E2X3q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 19:29:46 -0400
Message-ID: <4FC55BE7.7010807@candelatech.com> (sfid-20120530_012950_634296_DA1EEA8E)
Date: Tue, 29 May 2012 16:29:43 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Limit number of pending skbs.
References: <1338332576-26427-1-git-send-email-greearb@candelatech.com> <4FC55A83.6030602@openwrt.org>
In-Reply-To: <4FC55A83.6030602@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/29/2012 04:23 PM, Felix Fietkau wrote:
> On 2012-05-30 1:02 AM, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> Current code will allow any number of pending skbs, and
>> this can OOM the system when used with something like
>> the pktgen tool (which may not back off properly if
>> queue is stopped).
>>
>> Possibly this is just a bug in our version of pktgen,
>> but either way, it seems reasonable to add a limit
>> so that it is not possible to go OOM in this manner.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
> Adding a module parameter in a workaround for a possibly broken module
> seems a bit excessive to me.
>
> Also, I'm not sure adding such a silent packet drop is a good idea. At
> the very least, it should complain loudly to encourage people to fix the
> actual bug instead of just papering over it.
>
> When the driver cannot accept more packets, the queue stop should
> prevent the network stack from spamming mac80211 with more packets. Your
> pktgen seems to be ignoring this, so please fix it instead of adding
> workarounds to mac80211.

Ok, I'll work on pktgen next time I get a chance.

I recall I had to add a hack (that was not wanted upstream)
to get pktgen to even work with mac80211 interfaces w/out crashing
the kernel, so probably no one else is using it anyway.

I did verify that with user-space UDP sockets running at similar
speed the pending buffers did not fill up at all.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

