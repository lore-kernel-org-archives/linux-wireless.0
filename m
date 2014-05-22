Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44558 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbaEVOhn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:37:43 -0400
Message-ID: <1400769454.4174.22.camel@jlt4.sipsolutions.net> (sfid-20140522_163747_967070_FC75DEAE)
Subject: Re: [PATCH 1/3] mac80211: move csa counters from sdata to
 beacon/presp
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 22 May 2014 16:37:34 +0200
In-Reply-To: <CA+BoTQmw6taxwxHtK99BQXgGugu6aDrGUOCz+-MvUo52JoWrpw@mail.gmail.com> (sfid-20140522_155348_321691_FA0123D1)
References: <1400765294-14732-1-git-send-email-michal.kazior@tieto.com>
	 <1400765294-14732-2-git-send-email-michal.kazior@tieto.com>
	 <1400766195.4174.13.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmw6taxwxHtK99BQXgGugu6aDrGUOCz+-MvUo52JoWrpw@mail.gmail.com>
	 (sfid-20140522_155348_321691_FA0123D1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-22 at 15:53 +0200, Michal Kazior wrote:

> >>  static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
> >> -                                struct cfg80211_beacon_data *params)
> >> +                                struct cfg80211_beacon_data *params,
> >> +                                const u16 *csa_counter_offset_beacon,
> >> +                                int n_csa_counter_offset_beacon,
> >> +                                const u16 *csa_counter_offset_presp,
> >> +                                int n_csa_counter_offset_presp,
> >> +                                u8 csa_count)
> >
> > But that seems overkill. Maybe those CSA-related arguments could be in
> > some new struct so you don't have to pass "..., NULL, 0, NULL, 0, 0"?
> 
> I didn't want to invent a structure just to pass a bunch of arguments.

I don't see any problem with that?

> Hmm.. maybe we can move counter offsets into cfg80211_beacon_data?
> This would apply to cfg80211_csa_settings as well.

I don't think that's a good idea, since the cfg80211_beacon_data is used
in places where that wouldn't make sense, that would confuse the API.
You could use "struct cfg80211_csa_settings" here I suppose, but I think
a new struct is perfectly reasonable.

johannes

