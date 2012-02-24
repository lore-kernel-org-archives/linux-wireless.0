Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56396 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab2BXPsQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 10:48:16 -0500
Subject: Re: [RFC] mac80211: Filter duplicate IE ids
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAMcMvsjPcBsur8ftSXVPzvPaCEEOPh+mYSr3MLV7Aa23reFBNA@mail.gmail.com> (sfid-20120224_164409_423757_01F87ADD)
References: <20120224033729.9256A205A0@glenhelen.mtv.corp.google.com>
	 <1330068877.3426.6.camel@jlt3.sipsolutions.net>
	 <CAMcMvsi_v=gb9UF3tHSZ11fnh83iE9bK7nSiwL1GB-tDqW47jQ@mail.gmail.com>
	 <1330093741.3426.19.camel@jlt3.sipsolutions.net>
	 <CAMcMvsihYU93DjdqKYHW2xKiNbFD1YBqESx6NAkgKARCf-FjDQ@mail.gmail.com>
	 <1330097788.3426.29.camel@jlt3.sipsolutions.net>
	 <CAMcMvsjPcBsur8ftSXVPzvPaCEEOPh+mYSr3MLV7Aa23reFBNA@mail.gmail.com>
	 (sfid-20120224_164409_423757_01F87ADD)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 16:48:15 +0100
Message-ID: <1330098495.3426.30.camel@jlt3.sipsolutions.net> (sfid-20120224_164819_820720_4FC53100)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-02-24 at 07:43 -0800, Paul Stewart wrote:

> > Huh, good questions. Which info do we end up using? Just the one that
> > was not corrupted? I think we always use the last IEs, no?
> >
> > Hmm. You said in the bug that supported rates were really only affected,
> > and this caused an issue with the supported rates that we send, because
> > we restrict ourselves to the rates the AP advertises (due to other buggy
> > APs ...)
> >
> > Maybe then it doesn't matter all that much.
> >
> > OTOH, why should we ever reset the flag?
> 
> If my over-the-air captures are any indication, with some probability
> you will receive a corrupted beacon from time to time -- perhaps not
> due to a broken AP, but just from it being corrupted over the air.
> FCS could catch that most times, but perhaps sometimes not.  If you
> carry that flag along with you as long as the BSS exists (as long as
> the AP is in view) despite tens or hundreds of intact receptions
> afterwards, the importance of the error message diminishes.

Yes, good point. Actually we (currently) only care about (extended)
supported rates, so maybe we should reset whenever we take those from an
intact frame?

johannes

