Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56679 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab1CDTww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 14:52:52 -0500
Subject: Re: [PATCH 6/7] mac80211: Parse RSN information element to
 determine if a peer needs authentication
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
In-Reply-To: <AANLkTi=kJ2bsJ32snu62BTDkXgJXz-vgVQJGDcbgi5jO@mail.gmail.com>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
	 <1299208307-9428-7-git-send-email-thomas@cozybit.com>
	 <1299238635.4348.6.camel@jlt3.sipsolutions.net>
	 <AANLkTim-cdTV6dsZg9MmMFMejkN8SpNYr=RBY-s8kiF=@mail.gmail.com>
	 <1299266307.3742.5.camel@jlt3.sipsolutions.net>
	 <AANLkTi=kJ2bsJ32snu62BTDkXgJXz-vgVQJGDcbgi5jO@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 20:52:49 +0100
Message-ID: <1299268369.3837.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-04 at 11:45 -0800, Javier Cardona wrote:

> I thought the RSN parsing was required at least for the case where a
> station is open and discovers another station.  If the other station
> wants security, we (the open mesh) should leave that station alone.
> But I guess the same can be achieved by just detecting the presence of
> an RSN IE without parsing it (there was logic for that already).

Right.

> So, in summary, you are suggesting that we pass the kernel something
> like dot11MeshSecurityActivated when joining the mesh, in addition to
> the RSN IE.  And use the presence of the RSN IE in received beacons to
> determine if other nodes have their security activated or not.

Yes.

> > Actually, looking at your patch in more detail, it would seem like it
> > allows somebody to hijack the mesh by pretending it is an open network.
> > If the RSN IE isn't present, mesh_neighbour_update() gets passed false
> > for the rsn_enabled parameter -- even if the mesh should be secure --
> > and then the peer would be allowed to join just because it said it
> > didn't support RSN. Surely in that case it shouldn't be allowed to join?
> 
> You are right.  We would need to check if security is enabled before
> creating a peer with no RSN info.

Right -- we just check our own dot11MeshSecurityActivated, and if so
never create a peer but let userspace handle it. And if that is false,
we create a peer if (and only if) it has no RSN information.

johannes

