Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40584 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab1AaSs6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:48:58 -0500
Message-ID: <4D470416.9020403@candelatech.com>
Date: Mon, 31 Jan 2011 10:48:54 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Recalculate channel-type on iface removal.
References: <1296499072-6721-1-git-send-email-greearb@candelatech.com> <1296499462.3812.41.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296499462.3812.41.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2011 10:44 AM, Johannes Berg wrote:
> On Mon, 2011-01-31 at 10:37 -0800, greearb@candelatech.com wrote:
>
>> Also, use WARN_ON_ONCE instead of WARN_ON if user has
>> ht40- stations in conjunction with ht40+.  It's not
>> really a kernel bug, just a mis-configuration of the
>> user's wifi environment.
>
> But how did we end up here to start with -- shouldn't that have been
> rejected?

The set-channel-type logic will complain, and I imagine the interfaces
will bounce around and attempt to re-associate, but I think it can
get into the mixed state.

Regardless of that, it may be something more mundane where we have
some HT-40 and HT-20 interfaces that can co-exist, but one of those
leaves.  We should still re-calculate in case their leaving changes
the super-chan calculation.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

