Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60878 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab1GOVA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 17:00:26 -0400
Subject: Re: [PATCH 1/5] mac80211: give if_mesh a beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAG6hwVONFH+vkSasF7AaSaqvHK78wwNtZesi0RSUnuCi17d9Fw@mail.gmail.com> (sfid-20110715_213042_753766_17EB6895)
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	 <1310600747-9583-2-git-send-email-thomas@cozybit.com>
	 <1310723669.4164.18.camel@jlt3.sipsolutions.net>
	 <CAG6hwVONFH+vkSasF7AaSaqvHK78wwNtZesi0RSUnuCi17d9Fw@mail.gmail.com>
	 (sfid-20110715_213042_753766_17EB6895)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 23:00:24 +0200
Message-ID: <1310763624.4164.29.camel@jlt3.sipsolutions.net> (sfid-20110715_230030_431933_CB371186)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-07-15 at 12:30 -0700, Thomas Pedersen wrote:

> >> +     if (ieee80211_vif_is_mesh(&sdata->vif))
> >> +             rcu_assign_pointer(sdata->u.mesh.beacon, new);

> The ifdef is already in ieee80211_vif_is_mesh()

Yeah but sdata->u.mesh doesn't exist without mesh configured.

> > what's + 400? You can't really think the TIM IE is that long?
> 
> No, but you're right, that number is pretty arbitrary. Maximum length
> of mesh IEs currently (Mesh ID + Mesh Conf + Mesh Awake) is only 47.
> Since mesh IEs have to be added during beacon time, might it make
> sense to track the needed length in the if_mesh?

Maybe just add a comment what's included in the 400?

> > Also ... since you'll need PS support eventually anyway, maybe you
> > should refactor "struct ieee80211_if_ap" into something AP-specific
> > (currently only VLANs) and the rest, and then use "the rest" in mesh as
> > well to make all this code more unified.
> 
> I like this approach much better. Are you suggesting just factoring
> out the PS data, or taking it further and creating a generic "if which
> beacons"?

Well, I don't think "iface which beacons" is really what we need here --
IBSS sends beacons as well but we don't really have PS support there and
it'd be different anyway. But on the other hand, if you also factor out
the beacon pointer, you can embed that into both. Like I said, I think
from struct ..._if_ap you only have the vlan list that you don't want?

johannes

