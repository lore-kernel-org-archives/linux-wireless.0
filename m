Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52581 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab1HLTDX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 15:03:23 -0400
Subject: Re: [PATCH 8/8] {nl,cfg,mac}80211: let userspace make meshif mesh
 gate
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>, linville@tuxdriver.com
In-Reply-To: <CAG6hwVMAkkv_OAemfEEGx9Tu3PmTqYq7vvBABw45omOXEx_p4A@mail.gmail.com> (sfid-20110812_210114_505681_70423402)
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
	 <1312933511-9486-9-git-send-email-thomas@cozybit.com>
	 <1312984078.4325.5.camel@jlt3.sipsolutions.net>
	 <CAG6hwVNFUyt7VBEiaNpCoGFmt4eMbvexKA0pUtGi3sj3mwHgZQ@mail.gmail.com>
	 <1313141481.4022.1.camel@jlt3.sipsolutions.net>
	 <CAG6hwVMAkkv_OAemfEEGx9Tu3PmTqYq7vvBABw45omOXEx_p4A@mail.gmail.com>
	 (sfid-20110812_210114_505681_70423402)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 21:03:19 +0200
Message-ID: <1313175799.4022.23.camel@jlt3.sipsolutions.net> (sfid-20110812_210325_241138_23BDDAD5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-08-12 at 12:00 -0700, Thomas Pedersen wrote:

> iw mesh0 set mesh_param mesh_hwmp_rootmode=1
> iw mesh0 set mesh_param mesh_gate_announcements=1
> 
> And the connection between the two would only be apparent to someone
> familiar with our limited implementation. So in v2, it's enough to
> just enable mesh gate announcements and root mode will be turned on
> automagically. This gets sort of ugly if say you turn off root mode
> and still expect gate announcements to work, or disable gate
> announcements and now you're still broadcasting as a root node for
> some reason. (we can't really just disable root mode when we turn of
> gate announcements, since the two should be independent). That said,
> this seems preferable to someone doing 'iw mesh0 set mesh_param
> mesh_gate_announcements=1', and then spending an inordinate time
> debugging when it should just work.

Hmm. I wonder if it then makes sense to allow changing this on the fly
at all?

johannes

