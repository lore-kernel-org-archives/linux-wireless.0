Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:36118 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbZBMH5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 02:57:05 -0500
Received: by yw-out-2324.google.com with SMTP id 5so584693ywh.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 23:57:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234511334.1327.34.camel@johannes.local>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-6-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-7-git-send-email-lrodriguez@atheros.com>
	 <1234508187.1327.19.camel@johannes.local>
	 <43e72e890902122309q61036a23k2efeb14fe3a6e814@mail.gmail.com>
	 <43e72e890902122314m2966471dm3a9485a91e8e927@mail.gmail.com>
	 <43e72e890902122314r6b9e881cg5538523780e808ef@mail.gmail.com>
	 <1234509436.1327.25.camel@johannes.local>
	 <43e72e890902122335l6580dbc1m44702996cc8200e4@mail.gmail.com>
	 <1234511334.1327.34.camel@johannes.local>
Date: Thu, 12 Feb 2009 23:57:04 -0800
Message-ID: <43e72e890902122357g26bf3dd4j930de7c1f6c28280@mail.gmail.com> (sfid-20090213_085711_687515_FA957517)
Subject: Re: [PATCH 6/6] cfg80211: move regulatory hints to workqueue
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 11:48 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-02-12 at 23:35 -0800, Luis R. Rodriguez wrote:
>
>> > Well, regardless of regulatory, we now have two paths:
>> >
>> > nl80211: cfg80211_mutex  -->  drv->mutex  -->  rtnl
>> > wext:    rtnl  -->  cfg80211_mutex  -->  drv->mutex
>> >
>> > which is clearly not a good plan.
>> >
>> > Therefore, I'll probably have to implement solution (1) from what I sent
>> > you, and invert the locking in nl80211. That would fix your the
>> > immediate problem with regulatory as well, because that was:
>> >
>> > rtnl  --->  (regulatory_hint) --->  cfg80211_mutex  -->  drv->mutex
>>
>> Yup I see. So as it stands in this patch user reg hint now is:
>>
>> reg_mutex --> cfg80211_mutex
>
> I don't really care about reg_mutex much, and it probably doesn't matter
> as long as its use is limited. Question is whether we need it, but
> that's a different question.

To answer that question -- reg_mutex just protects the
reg_requests_list linked list. That's it. Without that you could
potentially have two userspace reg hints while the workqueue runs.
Remember that the hints no longer lock except to just add a new
regulatory_request into the reg_requests_list.

>> Driver hint also does the same so it seems your fix on nl80211 would
>> probably just tap this series on the nl80211_req_set_reg().
>
> Yeah, I think I'll work on top of your series anyway so I don't clash
> with the cleanups.

Any other comments on the series?

>> I also think using a workqueue would be good here anyway, the only
>> negative thing I've seen is loading takes a bit longer.
>
> Indeed, it's a good thing because a path like this:
>
> driver_open
>  -> regulatory_hint
>  -> cfg80211 stuff
>   -> driver_reg_notifier
>
> is always deadlock prone since you call into the driver from itself.

I see -- good point.

  Luis
