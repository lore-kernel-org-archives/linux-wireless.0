Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56727 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421Ab2BXPga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 10:36:30 -0500
Subject: Re: [RFC] mac80211: Filter duplicate IE ids
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAMcMvsihYU93DjdqKYHW2xKiNbFD1YBqESx6NAkgKARCf-FjDQ@mail.gmail.com> (sfid-20120224_162609_881741_F7CCCE9D)
References: <20120224033729.9256A205A0@glenhelen.mtv.corp.google.com>
	 <1330068877.3426.6.camel@jlt3.sipsolutions.net>
	 <CAMcMvsi_v=gb9UF3tHSZ11fnh83iE9bK7nSiwL1GB-tDqW47jQ@mail.gmail.com>
	 <1330093741.3426.19.camel@jlt3.sipsolutions.net>
	 <CAMcMvsihYU93DjdqKYHW2xKiNbFD1YBqESx6NAkgKARCf-FjDQ@mail.gmail.com>
	 (sfid-20120224_162609_881741_F7CCCE9D)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 16:36:28 +0100
Message-ID: <1330097788.3426.29.camel@jlt3.sipsolutions.net> (sfid-20120224_163636_140387_62EC7816)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-02-24 at 07:25 -0800, Paul Stewart wrote:

> >> > I suppose better to accept such service degradation than not connect,
> >> > but I wonder if we should log a warning when we actually try to use such
> >> > an AP?
> >>
> >> Let me know where you'd like it.
> >
> > How about having a flag in the BSS struct (ieee80211_bss) and printing a
> > message when we use that BSS struct for assoc? E.g. in
> > ieee80211_mgd_assoc()? I'm not sure I fully understand where this
> > actually has any effect.
> 
> How do we clear this flag?  Let's say we got one corrupted beacon and
> from then on, everything was ducky.  We set the flag flag on the
> corrupted beacon.  Do we clear it on an unblemished probe response?
> Are these really two flags, since beacons and probe responses
> sometimes have different subsets of info, or does a valid probe
> response clear both flags?

Huh, good questions. Which info do we end up using? Just the one that
was not corrupted? I think we always use the last IEs, no?

Hmm. You said in the bug that supported rates were really only affected,
and this caused an issue with the supported rates that we send, because
we restrict ourselves to the rates the AP advertises (due to other buggy
APs ...)

Maybe then it doesn't matter all that much.

OTOH, why should we ever reset the flag? Eventually the BSS entry will
be deleted anyway? And if we keep reconnecting to it, maybe there's some
other bug?

I'm not really sure -- open to suggestions. I just think that in order
to actually notice such things in the future we should print something
so we don't get confused.

johannes

