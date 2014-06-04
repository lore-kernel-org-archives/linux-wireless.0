Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34393 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbaFDMDT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 08:03:19 -0400
Message-ID: <1401883383.6079.21.camel@jlt4.sipsolutions.net> (sfid-20140604_140322_407917_2BCA8ED9)
Subject: Re: [PATCH v2 0/2] mac80211: fix csa counters
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Wed, 04 Jun 2014 14:03:03 +0200
In-Reply-To: <CA+BoTQm+GPUzgxTut+umhuSQZS6m+=e5FzeSGpg64Xy=2A3cUQ@mail.gmail.com> (sfid-20140604_140008_104302_11E28399)
References: <1401345535-22991-1-git-send-email-michal.kazior@tieto.com>
	 <1401824450.4157.33.camel@jlt4.sipsolutions.net>
	 <CA+BoTQm+GPUzgxTut+umhuSQZS6m+=e5FzeSGpg64Xy=2A3cUQ@mail.gmail.com>
	 (sfid-20140604_140008_104302_11E28399)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-06-04 at 14:00 +0200, Michal Kazior wrote:
> On 3 June 2014 21:40, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Thu, 2014-05-29 at 08:38 +0200, Michal Kazior wrote:
> >> Hi,
> >>
> >> I was seeing strange WARN_ON splat loops and
> >> crashes while I was testing my multi-vif CSA.
> >>
> >> CSA counters weren't properly reset and on some
> >> failpaths this caused a mess. There were also
> >> possible SMP inconsitencies/races.
> >
> > Thanks. This doesn't seem to apply any more though, something in
> > ieee80211_csa_is_complete(). I think the fixup is easy, but would prefer
> > if you'd do it since (hopefully :) ) you can also check the result.
> >
> > I'm guessing the conflict is with some of Andrei's recent patches.
> 
> That's strange. I thought I've based it on top of latest
> mac80211-next/master when I sent it.
> 
> I've also just rebased it locally on latest mac80211-next/master and
> git wasn't complaining about conflicts at all.

Hmm, you're right, sorry. I was probably trying to apply the patches in
the wrong order.

> Anyway, I'll re-send it later.

Ok, thanks.

johannes

