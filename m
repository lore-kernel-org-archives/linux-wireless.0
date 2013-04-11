Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35064 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3DKJ5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 05:57:47 -0400
Message-ID: <1365674261.8272.38.camel@jlt4.sipsolutions.net> (sfid-20130411_115752_749236_0ECD268F)
Subject: Re: [PATCH 1/3] cfg80211: add get_max_tp() API
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 11 Apr 2013 11:57:41 +0200
In-Reply-To: <1365674217.8272.37.camel@jlt4.sipsolutions.net> (sfid-20130411_115708_458330_E6ED0CC9)
References: <1365105442-31876-1-git-send-email-antonio@open-mesh.com>
	 <CAGXE3d98a4pBG=gWKUm9A2RJRN+eic4Zi8dh4grTuqQmW3GOsg@mail.gmail.com>
	 <20130405083956.GA14463@open-mesh.com>
	 <1365168001.8515.28.camel@jlt4.sipsolutions.net>
	 <20130406073309.GB14463@open-mesh.com>
	 <1365503108.8465.34.camel@jlt4.sipsolutions.net>
	 <20130409113406.GC3771@open-mesh.com>
	 <1365674217.8272.37.camel@jlt4.sipsolutions.net>
	 (sfid-20130411_115708_458330_E6ED0CC9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-04-11 at 11:56 +0200, Johannes Berg wrote:
> On Tue, 2013-04-09 at 13:34 +0200, Antonio Quartulli wrote:
> 
> > > Anyway my concern is that you're adding something that's rather minstrel
> > > specific. It's not really usable by any other algorithm, you're
> > > reporting minstrel's estimation of the throughput. If you report the
> > > current "best" rate, that'll probably get you pretty much the same
> > > behaviour overall, but be more portable to other algorithms I think.
> > 
> > I understand your concern. My guess was that every algorithm was "somehow" able
> > to provide such measurement. The point is that the throughput value is computed
> > so that it also take probability of success into consideration.
> > This means that two nodes using the same rate may have different throughputs
> > (and this is important when building our distributed metric).
> > 
> > However, nothing prevents any algorithm to implement the API the way it can do.
> > I've not looked into other RC implementations yet, but I guess they would have a
> > similar value to return too?
> 
> Maybe, yeah.
> 
> Anyway, I think having a separate externally visible API here is
> overkill. It would seem a lot simpler to return it (to userspace) in the
> station information, and (separately) allow other kernel modules to
> request station information as well.
> 
> Also I'm not sure it should be called "max_tp"? It's more like "expected
> throughput" or something like that?

Hm, no, that's not really it either ... It's maybe more like "current
usable data rate" (as opposed to PHY rate?)

johannes

