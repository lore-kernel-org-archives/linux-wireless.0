Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:33879 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbZBMHfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 02:35:32 -0500
Received: by yx-out-2324.google.com with SMTP id 8so581956yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 23:35:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234509436.1327.25.camel@johannes.local>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-6-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-7-git-send-email-lrodriguez@atheros.com>
	 <1234508187.1327.19.camel@johannes.local>
	 <43e72e890902122309q61036a23k2efeb14fe3a6e814@mail.gmail.com>
	 <43e72e890902122314m2966471dm3a9485a91e8e927@mail.gmail.com>
	 <43e72e890902122314r6b9e881cg5538523780e808ef@mail.gmail.com>
	 <1234509436.1327.25.camel@johannes.local>
Date: Thu, 12 Feb 2009 23:35:30 -0800
Message-ID: <43e72e890902122335l6580dbc1m44702996cc8200e4@mail.gmail.com> (sfid-20090213_083542_175384_E72082A4)
Subject: Re: [PATCH 6/6] cfg80211: move regulatory hints to workqueue
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 11:17 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-02-12 at 23:14 -0800, Luis R. Rodriguez wrote:
>
>> >>> Yes, but I need to look at the one Reinette posted and fix that one,
>> >>> which will probably require a different solution.
>> >>
>> >> Oh I didn't see that one. How different?
>> >
>> > I see an rtnl lock issue against scanning and the drv mutex. Doesn't
>> > seem to be related to regulatory. So how would that affect a path to
>> > move hints to a workqueue?
>>
>> Oh you mean the rntl_lock() and drv mutex is _still_ an issue?
>
> Well, regardless of regulatory, we now have two paths:
>
> nl80211: cfg80211_mutex  -->  drv->mutex  -->  rtnl
> wext:    rtnl  -->  cfg80211_mutex  -->  drv->mutex
>
> which is clearly not a good plan.
>
> Therefore, I'll probably have to implement solution (1) from what I sent
> you, and invert the locking in nl80211. That would fix your the
> immediate problem with regulatory as well, because that was:
>
> rtnl  --->  (regulatory_hint) --->  cfg80211_mutex  -->  drv->mutex

Yup I see. So as it stands in this patch user reg hint now is:

reg_mutex --> cfg80211_mutex

Driver hint also does the same so it seems your fix on nl80211 would
probably just tap this series on the nl80211_req_set_reg().

I also think using a workqueue would be good here anyway, the only
negative thing I've seen is loading takes a bit longer.

  Luis
