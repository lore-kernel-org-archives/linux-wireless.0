Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.226]:52294 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbXFLOzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 10:55:17 -0400
Received: by wx-out-0506.google.com with SMTP id t15so1814801wxc
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2007 07:55:16 -0700 (PDT)
Message-ID: <1ba2fa240706120755j570db33cxa4e2b1125feef3df@mail.gmail.com>
Date: Tue, 12 Jun 2007 17:55:16 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [RFC] {cfg,nl}80211 API
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"David Lamparter" <lists@diac24.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1181650117.17599.12.camel@xo-28-0B-88.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <20070611230434.GA13221@charon.n2.diac24.net>
	 <1181639707.29767.57.camel@johannes.berg>
	 <1181650117.17599.12.camel@xo-28-0B-88.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/12/07, Dan Williams <dcbw@redhat.com> wrote:
> On Tue, 2007-06-12 at 11:15 +0200, Johannes Berg wrote:
> > Hi David,
> >
> > Great stuff!
> >
> > >   - getting virtual interfaces works via ifindex, which needs to be known.
> > >     - no dumping (would have locking issues with userspace MLME)
> > >     - use list of vifs from GET_WIPHY
> > >     - only thing it currently should return is vif type. essid & stuff
> > >       should be retrievable via GET_ASSOCIATION, which won't be valid for
> > >       monitor interfaces
> >
> > Hmm, in fact, if we go that route then we can do dumping for vifs (by
> > wiphy I guess) since all this information is available in the kernel,
> > only GET_ASSOCIATION should need a callout. vif type can be dumped just
> > fine.
> >
> > > So, what's left?
> > > - more PHY config stuff?
> > >   - TX power? Should be able to configure a lower value...
> >
> > Yeah, but as we said, this really needs to tie in with any regulatory
> > stuff.
> >
> > >   - antenna selection?
> >
> > Sounds reasonable, needs automatic/... but for .11n it might need some
> > more things. Not sure.
>
> Just a quick question; for .11n and later, do we care about being as
> detailed as specifying each antenna and whether or not each antenna can
> be used for TX and/or RX, and then being able to assign specific
> antennas to either TX or RX?  Or does hardware expose a simpler
> interface like "2x2" or "3x2"?  That means either:
>
> set-antennas([(1, TX & RX), (2, TX & RX), (3, RX)])
>
> or
>
> set-antennas(tx=2, rx=3)
>
> Dan
>
>
You can be explicit and then it's port of hand shake,  Yet antenna
selection/number is part of rate index (MCS) and there it is chosen by
rate scaling alorithm

> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
