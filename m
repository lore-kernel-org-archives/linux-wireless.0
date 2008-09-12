Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39438 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbYILTT3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 15:19:29 -0400
Date: Fri, 12 Sep 2008 12:19:19 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: The new regulatory code kills my wireless
Message-ID: <20080912191919.GA7722@tesla> (sfid-20080912_211933_280898_C5E534CA)
References: <48CAA8D6.1030605@lwfinger.net> <20080912174036.GC6134@tesla> <48CAB90C.5090302@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <48CAB90C.5090302@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 12, 2008 at 11:46:36AM -0700, Larry Finger wrote:
> Luis R. Rodriguez wrote:
> > On Fri, Sep 12, 2008 at 10:37:26AM -0700, Larry Finger wrote:
> >> After pulling the latest git from wireless-testing, my wireless
> >> failed. I bisected this to be commit
> >> 544ec9a11fdef5142a76a8eb4b186a80a272c035, "cfg80211: Add new wireless
> >> regulatory infrastructure".
> --snip--
> >
> > Please apply johill's patch, "[PATCH] cfg80211: fix regdomain macro"
> 
> That patch fixed the problem. For someone following this thread, the
> patch is by Johannes Berg.
> 
> I can understand when some oddball hardware causes a corner-case
> problem - I just had one with an ancient laptop - but somehow, I
> expect that most people will use the old regulatory option, at least
> for a while. Shouldn't the most rudimentary testing have caught this
> problem?

Well no, IMHO people *should not* use the old regulatory stuff if
possible, the idea is to kill it ASAP, you should only use the old
regulatory stuff if you *need* to, meaning you have some dependency
on the old module parameter for some strange odd ball reason or if
you cannot compile and install crda or iw.

But yes, you are right testing should have caught this, and I appologize
for that. Thing is I have crda installed and if you have it you won't
see this issue as this macro is only used for the static regulatory
domains. But yes, I should have caught it.

  Luis
