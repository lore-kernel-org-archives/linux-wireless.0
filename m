Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39077 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab1KHSQz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 13:16:55 -0500
Message-ID: <4EB9720B.8080704@candelatech.com> (sfid-20111108_191700_758052_20A5D041)
Date: Tue, 08 Nov 2011 10:16:43 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v6 1/2] wireless:  Support ht-capabilities over-rides.
References: <1320707676-17255-1-git-send-email-greearb@candelatech.com>  (sfid-20111108_001449_233997_95FF19FA) <1320740099.4304.5.camel@jlt3.sipsolutions.net>  <4EB96A5C.8040606@candelatech.com> <1320775251.24797.31.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320775251.24797.31.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2011 10:00 AM, Johannes Berg wrote:
> On Tue, 2011-11-08 at 09:43 -0800, Ben Greear wrote:

>>> Also how would you feel about rejecting, instead of silently ignoring,
>>> things that we do look at but don't support, e.g. a wrong A-MSDU
>>> setting? Alternatively, cfg80211 could modify the settings in a way that
>>> drivers don't have to worry about the "downgrade only" part.
>>
>> I dislike that as well, for similar reasons.  Getting an -EINVAL back
>> from a netlink call gives very little info to the user anyway...who
>> knows what exactly was invalid?  Perhaps a printk warning coming out
>> of mac80211 when it checks for the restrictions against what the
>> driver supports would be more useful?
>
> Fair enough. I think what I'm really after is having a way to know wtf
> we're using when you requested something. That would probably be more
> useful overall.

The current ht_cap settings for each station are in debugfs, so hopefully it
would not be that difficult to add it to a netlink response.  Perhaps
it's already there..I haven't looked yet.

> FWIW, I did talk to some people at the kernel summit about the -EINVAL
> thing and maybe there's an idea to send back the invalid attribute at
> least, but doesn't really matter here. I'm OK with just allowing it all
> since it's not going to be used a lot anyway.

Ok, I'll add some printks.

>>> Finally, I think we need a tad more documentation about how this is
>>> supposed to work in case somebody wants to implement it on non-mac80211.
>>> The way it's done right now it seems fairly error prone, with all
>>> restrictions that the driver needs to implement like not allowing the
>>> a-MSDU size to be increased.
>>
>> Well, who knows...in their driver maybe the restrictions are not
>> the same.  I think that adding more info about what fields are
>> currently supported for mac80211 might be useful, but trying to
>> generalize restrictions for drivers that have not even implemented
>> any of this seems like useless overhead.
>
> Well, it goes both ways though, having more validation up front will
> make it a lot easier for new drivers to implement it because they don't
> have to bother with the validation, and I really don't see any way that
> a driver might allow making the a-MPDU spacing *smaller*, if it could
> deal with smaller it'd advertise that to start with.
>
> OTOH, if you request a connect(), you don't even know the band and
> technically a driver could have different capabilities on different
> bands.

Lets see if any other drivers try to support these features.  Anyone
doing that work will likely see some ways to make use of common code
and things can be shuffled then.  As written, the patches are not overly
invasive, so I think we can move stuff around later without too much
trouble.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

