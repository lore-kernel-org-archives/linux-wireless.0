Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21030 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZEEPwW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 11:52:22 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 05 May 2009 08:52:23 -0700
Date: Tue, 5 May 2009 08:52:39 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] cfg80211: fix race condition with
	wiphy_apply_custom_regulatory()
Message-ID: <20090505155239.GA29741@tesla>
References: <1241217890-11650-1-git-send-email-lrodriguez@atheros.com> <9b2b86520905020729v331a9581q5d7916b5d36c02fb@mail.gmail.com> <20090504175307.GD8655@tesla> <9b2b86520905050847m5f3b33e2k7d71479888c078e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <9b2b86520905050847m5f3b33e2k7d71479888c078e4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 05, 2009 at 08:47:57AM -0700, Alan Jenkins wrote:
> On 5/4/09, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> > On Sat, May 02, 2009 at 07:29:43AM -0700, Alan Jenkins wrote:
> >> On 5/1/09, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> >> > We forgot to lock using the cfg80211_mutex in
> >> > wiphy_apply_custom_regulatory(). Without the lock
> >> > there is possible race between processing a reply from CRDA
> >> > and a driver calling wiphy_apply_custom_regulatory(). During
> >> > the processing of the reply from CRDA we free last_request and
> >> > wiphy_apply_custom_regulatory() eventually accesses an
> >> > element from last_request in the through freq_reg_info_regd().
> >> >
> >> > This is very difficult to reproduce (I haven't), it takes us
> >> > 3 hours and you need to be banging hard, but the race is obvious
> >> > by looking at the code.
> >> >
> >> > This should only affect those who use this caller, which currently
> >> > is ath5k, ath9k, and ar9170.
> >> >
> >> > EIP: 0060:[<f8ebec50>] EFLAGS: 00210282 CPU: 1
> >> > EIP is at freq_reg_info_regd+0x24/0x121 [cfg80211]
> >>
> >> This looks like the same bug I reported seeing on bootup (100% of the
> >> time).  I'll test wireless-testing again for V9 of the rfkill rewrite,
> >> so at that point I'll try to confirm that this patch fixes my problem.
> >
> > Any luck?
> 
> Ugh, sorry, I can't reproduce it to test the patch.
> 
> I reported that it went away after making CFG80211 built-in, but I
> can't get it back now, even if I turn that back into a module.  Maybe
> I overwrote the original config, or maybe I was being dumb and it only
> happened once in the first place.  I'm confident I'm using the same
> source code (v2.6.30-rc2-21665-gca0be26, clean tree), so that's not
> it.

I don't think its easy to reproduce. Anyway thanks for testing.

  Luis
