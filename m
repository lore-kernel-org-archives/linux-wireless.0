Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15737 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab0CZBcl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 21:32:41 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 18:32:41 -0700
Date: Thu, 25 Mar 2010 18:32:39 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Derek Smithies <derek@indranet.co.nz>
CC: Bruno Randolf <br1@einfach.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"bob@bobcopeland.com" <bob@bobcopeland.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] [PATCH 00/10] ANI for ath5k
Message-ID: <20100326013239.GE2385@tux>
References: <20100325054603.10697.48915.stgit@tt-desk>
 <alpine.DEB.2.00.1003261001530.24989@kauri.acheron.indranet.co.nz>
 <20100325211311.GG7651@tux>
 <201003260927.57491.br1@einfach.org>
 <alpine.DEB.2.00.1003261416120.24989@kauri.acheron.indranet.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.00.1003261416120.24989@kauri.acheron.indranet.co.nz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 25, 2010 at 06:21:50PM -0700, Derek Smithies wrote:
> 
> On Fri, 26 Mar 2010, Bruno Randolf wrote:
> 
> >>>> - Improve beacon averaging algorithm for IBSS:
> >>> is to turn ani off. which means the issue you raised else where of
> >>> providing reasonable userland controls (not via debugfs) becomes
> >>> important.
> >>
> >> If ANI helps IBSS so much then why not just default to turning it
> >> off within the driver?
> >
> > i would say in most standard cases, IBSS nodes are close together or at a
> > similar distance, so it does make sense to use ANI by default.
> Nope - I disagree. You have made a dangerous assumption, to asume
> that
>    IBSS node are close together or at a similar distance
> 
> if you have a network of ibss nodes, and then look at the rate tables of 
> the different nodes (minstrel is great here - it gives a fair and accurte 
> represetation of the best rate possible to other nodes) you see there is 
> some variation in the optimal rates between nodes.Which suggests that 
> using some automatic ani algorithm in an ibss network will foreever lower 
> performance for those nodes at the edge of the network.

Can't we use the coverage class for this stuff? Only thing is it would need
to be set. Do we even send the coverage class IE ? I don't think we do, that
part of the country IE and last time I reviewed the country IE building
on hostapd it didn't have it. IBSS is handled on mac80211 though so...
we'd have to add it there. I guess its a lot of work, but would help
with this no?

> > as well, we all agree that there should be userland controls. the questions is
> > just about the interface to use.
> 
> Definately - need userland controls. The default for IBSS should have 
> ANI off. If the user wants to "futz" with it, they can. With ANI off for 
> IBSS, you ensure that on startup, the network has the greatest chance of 
> working.

  Luis
