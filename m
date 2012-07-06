Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51198 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab2GFPvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 11:51:24 -0400
Message-ID: <1341589880.16893.11.camel@jlt3.sipsolutions.net> (sfid-20120706_175128_002536_25B14283)
Subject: Re: [PATCH 4/4] cfg80211: add cellular base station regulatory hint
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Date: Fri, 06 Jul 2012 17:51:20 +0200
In-Reply-To: <CAB=NE6XNmrS=kqoptMg67JhBQUJfYa=jUFz+aU-4E91vzqjnTg@mail.gmail.com> (sfid-20120706_174809_720952_BB17E456)
References: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com>
	 <1341357315-8053-5-git-send-email-rodrigue@qca.qualcomm.com>
	 <1341394944.4482.9.camel@jlt3.sipsolutions.net>
	 <CAB=NE6UfGuOh843dSx7NG7UYtEiDVcLUJbu6nFnBJs-Qk4tszw@mail.gmail.com>
	 <1341474303.4455.5.camel@jlt3.sipsolutions.net>
	 <CAB=NE6Uw1pso+HmVAahMvT3BZ0AheWxXuhJFLedvsHKXsUn11g@mail.gmail.com>
	 <1341556785.4462.0.camel@jlt3.sipsolutions.net>
	 <CAB=NE6XmbAu+xkLHYaBt=z6zdxXME5cOoANUd_3yEr+va_jb8g@mail.gmail.com>
	 <1341583919.16893.3.camel@jlt3.sipsolutions.net>
	 <CAB=NE6XNmrS=kqoptMg67JhBQUJfYa=jUFz+aU-4E91vzqjnTg@mail.gmail.com>
	 (sfid-20120706_174809_720952_BB17E456)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-06 at 08:47 -0700, Luis R. Rodriguez wrote:

> > I guess the question is -- what does that code really enable, if the
> > driver doesn't also set the feature flag? If it doesn't mean anything
> > without the flag I think we don't need the extra core option?
> 
> Ah -- good question. It'd just be the core. The core can support the
> base station hint or not but apart from the core we could technically
> also have a scenario today where perhaps one 802.11 card does support
> the station hint another does not. It is true that with no 802.11 card
> present having the core makes no sense but in practice we would, or at
> the very least we'd have the mac80211_hwsim.
> 
> So as I designed this I realized we really did have to consider the
> core getting this Vs a card getting this hint. The core getting the
> hint would only happen as-is with the onus option enabled, so if we
> want the onus option only to be a gate to other options then
> technically the feature would be for the core, while drivers would
> have the options to enable / disable the same feature given that this
> requires testing / maybe some changes in the firmware.

I'm not sure I really understand what you're saying :-)

What I really wanted to know though is this: If the core code is
enabled, what effect does receiving a "blessed" hint have on devices
that don't set the flag? If there's no effect vs. an "unblessed" hint,
then I think we don't need another option?

johannes

