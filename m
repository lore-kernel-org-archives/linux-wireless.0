Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51354 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYA1RJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 12:09:23 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: mac80211 crash in ieee80211_sta_scan_work
Date: Mon, 28 Jan 2008 18:07:25 +0100
Cc: Tomas Winkler <tomasw@gmail.com>, stefano.brivio@polimi.it,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <479D9B5F.5000304@lwfinger.net> <1ba2fa240801280148r27fac26ep5403bc8ccfc6d37a@mail.gmail.com> <20080128151200.GC5835@tuxdriver.com>
In-Reply-To: <20080128151200.GC5835@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200801281807.26267.mb@bu3sch.de> (sfid-20080128_170927_441504_6399BAFB)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 28 January 2008 16:12:00 John W. Linville wrote:
> On Mon, Jan 28, 2008 at 11:48:51AM +0200, Tomas Winkler wrote:
> > On Jan 28, 2008 11:37 AM,  <stefano.brivio@polimi.it> wrote:
> > > Quoting Tomas Winkler <tomasw@gmail.com>:
> > >
> > > > There are too many issues with API change patch. I think it is a good
> > > > direction but it's really unstable I think we need to give another
> > > > round before it can be applied.
> > >
> > > That has already been applied. I suggest that you point out the
> > > iwl4965 bugs you generically reported so that they can be fixed as well.
> > >
> > We've seen already patches to be un-applied, reverted.
> > I'll fix the bugs that's not problem but it takes time. I'm just
> > worried about the other users that find driver unusable.
> 
> I'm going to hold it back from 2.6.25.  We can work on it for 2.6.26.

The new band API is really really needed. I already have dozens of FIXMEs
in b43 that will automatically go away once the mac80211 API is changed.
Lots of FIXMEs will be added if this is not merged.

Please apply this patch and apply fixes inside of the 2.6.25 development
cycle. We are in a _development_ kernel. Kernels _do_ break in development
stages. That is the whole reason why development kernels exist.

So if we push this patch to 2.6.26 another bug appears. Should we push
it to 2.6.27 then instead of simply fixing it in the development cycle?

Besides that, _nobody_ will test the patch, if it's not applied to your
tree. So the situation will not be better when you apply it in the
next development cycle.

And for users complaining about a development kernel being unusable, well,
what to say about them? I'd say the right answer would be: Go and use
a stable kernel!

Please realize that delaying this patch means increasing the pain for
driver developers that need this patch for another 80-100 days.

-- 
Greetings Michael.
