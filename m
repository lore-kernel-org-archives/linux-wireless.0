Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56691 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbcBRVyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 16:54:23 -0500
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when building
 IEs.
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
 <1453807009.2759.23.camel@sipsolutions.net>
 <56A78E8F.1080505@candelatech.com> <1454576521.2564.6.camel@sipsolutions.net>
 <56B38FD1.40902@candelatech.com> <1455827536.2084.35.camel@sipsolutions.net>
 <56C62C4E.7020600@candelatech.com>
 <1455828330.2084.38.camel@sipsolutions.net>
 <56C630B7.7020604@candelatech.com>
 <1455830078.2084.47.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56C63D8B.9020900@candelatech.com> (sfid-20160218_225430_554345_F3D6A199)
Date: Thu, 18 Feb 2016 13:54:19 -0800
MIME-Version: 1.0
In-Reply-To: <1455830078.2084.47.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2016 01:14 PM, Johannes Berg wrote:
> On Thu, 2016-02-18 at 12:59 -0800, Ben Greear wrote:
>
>> Oh.  In that case, what if this happens:
>>
>> wiphy created and init
>> vdev created, vht copied from wiphy
>> ....
>> wiphy vht info changes?  Can this ever happen?  I'm thinking maybe
>> when
>>    a user uses 'iw' to set the rx/rx chainmask on a phy?  Possibly
>> nasty debugfs hacks that have worked so far?
>
> Ah, but I don't think this is something that's supposed to happen.
>
> Then again, there were some people talking about this last week, with a
> use case that seemed valid (shared antennas and reconfiguration or so),
> but we can require that to cause some action to propagate it. My gut
> reaction was to just re-register the entire wiphy, but that may be too
> big of a hammer.
>
> In any case, I think this isn't something we really need to consider
> too much. If there are bugs in this area then we'll fix them one way or
> another (or perhaps we'll just never find them since I don't expect
> many people to use this functionality).
>
>> So, I think it should be more like:
>>
>> if (vdata->have-user-config) {
>>     return sdata->user_config_vht & sdata->wiphy->vht;
>> }
>> else {
>>     return sdata->wiphy->vht;
>> }
>>
>> Point of the above 'code' is that we do not want to ever have
>> duplicate state (ie, a copy of wiphy->vht in sdata->vht, because then
>> they can get out of sync.  But, we can have a set of over-ride data
>> in sdata, and since we logically AND that with wiphy data, then we
>> should never exceed the capabilities of either sdata or wiphy.
>>
>> That make sense?
>
> Yeah, it does, at least if you assume that the capabilities can
> actually change. We assume they don't though, hostapd/wpa_s for example
> will never re-query them after startup.

Restarting supplicant, even if it came to that, might be less
of an issue than having to re-create the vdev to have it grab
proper new settings from the wiphy...

> I also don't like the whole "call a function to get the capabilities"
> not much more than what you have now in the code, since then we'll have
> to deal with allocations (or stack memory) for the data we want and it
> just generally makes the code using the capabilities much more complex
> (for a pretty fringe use case.)
>
> I'd much rather have the data structure that we can use as today
> without additional hoops to jump through, just possibly "redirecting"
> it for the use cases you have in mind.

Well, it would be easy enough to make a method that updated an vdev/sdata->vht from
wiphy, so could just call that as needed (ie, when certain things set or
are changed by wiphy).

>> Ok, the details of mac80211 have leaked out of my skull since the
>> start of this thread...I'll see if I can make a stab at implementing
>> this proposal.  But, likely it will be a bit, as I'm swamped with
>> other things at the moment.  If someone else is interested in trying
>> this, then of course be my guest!
>>
>
> Looked like Cedric Debarge had a similar idea, I've pointed him to this
> thread (as you probably saw.)

Yeah, I tried to read the patch when first posted, but I am not
sure I understand what he is trying to do.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

