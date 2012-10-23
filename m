Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43687 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab2JWRvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 13:51:08 -0400
Message-ID: <1351014695.10322.8.camel@jlt4.sipsolutions.net> (sfid-20121023_195112_865726_316479E2)
Subject: Re: [PATCH] mac80211: mesh STAs only process mesh beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Date: Tue, 23 Oct 2012 19:51:35 +0200
In-Reply-To: <CAG6hwVNN1wSAbX8yvjU3ooA_WifG5-x+iS5R5WBeLgFDb3E3bg@mail.gmail.com> (sfid-20121023_194929_986035_9E74B0A3)
References: <1350784990-14242-1-git-send-email-thomas@cozybit.com>
	 <1350912743.10166.10.camel@jlt4.sipsolutions.net>
	 <CAG6hwVNN1wSAbX8yvjU3ooA_WifG5-x+iS5R5WBeLgFDb3E3bg@mail.gmail.com>
	 (sfid-20121023_194929_986035_9E74B0A3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-10-23 at 10:49 -0700, Thomas Pedersen wrote:
> On Mon, Oct 22, 2012 at 6:32 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sat, 2012-10-20 at 19:03 -0700, Thomas Pedersen wrote:
> >> Before, a mesh STA would execute some code on behalf of AP or IBSS
> >> beacons. Since the mesh stack currently does not consider anything but
> >> other mesh STAs interesting, limit processing to just these and save a
> >> little overhead.
> >
> > I can apply this, but I think while you're at it the function deserves a
> > bit more thought:
> >
> >> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> >
> >> -     if (elems.mesh_id && elems.mesh_config &&
> >> -         mesh_matches_local(sdata, &elems))
> >> +     if (mesh_matches_local(sdata, &elems))
> >>               mesh_neighbour_update(sdata, mgmt->sa, &elems);
> >>
> >>       if (ifmsh->sync_ops)
> >
> > Why would you want to invoke sync_ops when the mesh is somebody else's
> > mesh, i.e. doesn't match local?
> 
> Right now we only allocate a sta_info if mesh_matches_local, so
> sync_ops should simply fail its sta_info lookup and return.
> 
> In the future we might want to allocate station entries for non-peers
> as well since it is useful to track the Toffset of non-peer neighbors
> for beacon collision avoidance and scheduling MCCAOP interference
> periods. This is also required by the standard FWIW.

Ok, fair enough. FWIW, Antonio is also working on tracking non-peer
stations (not as station entries, but separately) so maybe you should
collaborate.

Applied your patch.

johannes

