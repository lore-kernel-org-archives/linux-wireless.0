Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55233 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab2KNRlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 12:41:18 -0500
Message-ID: <50A3D7BA.1010700@candelatech.com> (sfid-20121114_184121_514510_83D3CBFA)
Date: Wed, 14 Nov 2012 09:41:14 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 'ip' blocking for long time trying to down station
References: <5091ADDD.4050407@candelatech.com>   (sfid-20121101_000206_244719_62ADC7A2) <1352884491.9510.2.camel@jlt4.sipsolutions.net>  <50A3D138.7010906@candelatech.com> <1352914094.9510.38.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352914094.9510.38.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/14/2012 09:28 AM, Johannes Berg wrote:
> On Wed, 2012-11-14 at 09:13 -0800, Ben Greear wrote:
>
>>> I'm guessing that the other interfaces are actually re-scheduling work
>>> items while this is trying to flush ... I'm not really sure how to
>>> improve this behaviour though.
>>
>> That seems very likely, as other stations would be trying to associate
>> in this scenario....
>>
>> Can we just purge all of this interface's work items from the list w/out flushing
>> everyone else's work?
>
> Actually, what I said doesn't quite make sense. We evidently use
> flush_work() which doesn't care about *new* items, so I suppose it just
> has to wait so long because there are other items already that are
> taking a long time.
>
> However, it seems that doing flush_work() is completely pointless,
> cancel_work_sync() would be just as effective -- the work exits right
> away if the interface is no longer marked running, and it is marked
> not-running before we even do the flush_work(). So using
> cancel_work_sync() should be safe here and would avoid the long delay
> you're seeing.
>
> Could you try this? The flush_work() is in iface.c:ieee80211_do_stop()

I will try this, but it will be a few days before I can get to it
most likely.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

