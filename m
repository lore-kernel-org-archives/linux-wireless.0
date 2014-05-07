Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbaEGLRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 07:17:19 -0400
Message-ID: <1399461426.10517.16.camel@jlt4.sipsolutions.net> (sfid-20140507_131723_560192_CC4291BE)
Subject: Re: [PATCH v4 2/5] mac80211: use chanctx reservation for AP CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Wed, 07 May 2014 13:17:06 +0200
In-Reply-To: <CA+BoTQmygnk161oi=AUwfFM4U-r8TxuJVcHPMbsOG+QCzB03hQ@mail.gmail.com> (sfid-20140507_114135_873360_B581D97F)
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-3-git-send-email-michal.kazior@tieto.com>
	 <1399387345.4218.44.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=FqfB46Bd6iC3F=Ps=b4f6CP77p5d6f4fiVLUttCYQjg@mail.gmail.com>
	 <1399449912.5038.7.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnJ7N=UtDu_tySg8uYrQg9i+BvuYrwez7x-LUVinroWDw@mail.gmail.com>
	 <1399453631.10517.10.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmygnk161oi=AUwfFM4U-r8TxuJVcHPMbsOG+QCzB03hQ@mail.gmail.com>
	 (sfid-20140507_114135_873360_B581D97F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 11:41 +0200, Michal Kazior wrote:

> > I'm not really sure how this would work though - drivers that have
> > firmware generating beacons don't generally seem to be in a position to
> > just stop that aspect and continue operating otherwise, with active
> > clients and all that. It seems to me this might be really difficult to
> > implement.
> 
> Yeah. This seems like a problem for template drivers. But on the other
> hand if they are capable of handling CSA IE counter they should
> understand CSA, shouldn't they?

Yeah but that doesn't mean they can simply stop beaconing for "extended"
periods of time.

> > Remind me why we're doing this - didn't you originally have something in
> > mind that was forcing them all to be synchronized with the switch?
> 
> No, not really.
> 
> With per-vif CSA requests you can end up submitting requests between
> vif TBTTs, no? Having an atomic "switch vif1,vif2,vif3 to chanX" could
> help - although currently ieee80211_beacon_get() isn't really
> synchronized well so you still hit the problem.
> 
> And how do you expect to deal with multi-vif with APs with different
> beacon intervals? Those inherently can't be tightly synchronized. The
> same goes for AP+STA if you start AP first (with the other way around
> you could, in theory, match STA's AP TBTT with your own).

I'm not really sure all of these are cases that we need to consider
though?

Multi-BSS I totally see, but if you're trying to do that with different
beacon intervals you're probably in a world of pain already - not sure
we should support that to start with...

AP/GO-follows-STA I can also see, due to regulatory and concurrent
BSS/P2P usage.

As for those other cases, are they really relevant?

johannes

