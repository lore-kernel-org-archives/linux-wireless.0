Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60296 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab1ERXak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 19:30:40 -0400
Message-ID: <4DD4569C.7080303@candelatech.com> (sfid-20110519_013043_489742_71FE78A5)
Date: Wed, 18 May 2011 16:30:36 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wireless: Support can-scan-one logic.
References: <1305586296-23147-1-git-send-email-greearb@candelatech.com>	 (sfid-20110517_005202_689056_9240F1AF) <1305759738.8827.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1305759738.8827.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/18/2011 04:02 PM, Johannes Berg wrote:
> On Mon, 2011-05-16 at 15:51 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> Enable this by passing a -1 for a scan frequency.
>
> I still don't think we should do that, especially not with -1. That's
> totally non-netlink like inband signalling. I'll also reply to your
> other mail though since I don't think it makes sense to have this sort
> of convenience function in the kernel.

It's virtually impossible (as far as I can tell) to carry an
out-of-tree netlink patch that uses a new netlink message
and still keep things backwards-compat when someone adds a
new message to the upstream kernel.  So, the -1 hack works
well for me.

If it were to go into the kernel proper, then we could
add a proper flag to the netlink API and start using
that.

If you just don't like the feature, thats OK...it is a pretty
specialized feature, and easy enough to carry in my own tree.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

