Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52167 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760475Ab2EJSMv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 14:12:51 -0400
Message-ID: <1336673569.4334.29.camel@jlt3.sipsolutions.net> (sfid-20120510_201255_587194_FAA565F1)
Subject: Re: [RFC] nl80211: don't require netdev UP for wdev
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
Date: Thu, 10 May 2012 20:12:49 +0200
In-Reply-To: <CAG6hwVPrbJ1ZQP=UqFd+oqFL8zm+qcRpbAUhrG+6gRe01rejSA@mail.gmail.com> (sfid-20120510_200741_521219_7303FF5E)
References: <1335479316-2933-1-git-send-email-thomas@cozybit.com>
	 <1336554945.4323.12.camel@jlt3.sipsolutions.net>
	 <CAG6hwVPrbJ1ZQP=UqFd+oqFL8zm+qcRpbAUhrG+6gRe01rejSA@mail.gmail.com>
	 (sfid-20120510_200741_521219_7303FF5E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Thomas,


> > I don't think this patch is correct -- mac80211 will get updated even if
> > the device isn't even started which will likely cause trouble. Even if
> > not though, this all doesn't match any kind of multi-channel concept. We
> > treat the channel as part of the temporary setup, e.g. part of the
> > association. AP and mesh are the only ones that are different today I
> > think.
> >
> > Overall, I don't think setting the channel & doing mesh setup separately
> > is really a good API.
> >
> > From mac80211's (and other drivers if they existed) POV the channel
> > should be given with the mesh_join command, like for IBSS.
> >
> > Now, obviously, requiring userspace to do that would be an API change.
> > We probably don't want that, so I would suggest to change cfg80211 to
> > track the channel and then pass it to join_mesh as one of the mesh
> > parameters. This could be made work even when somebody attempts to set
> > the channel before the interface is up, but we'd have to be careful
> > about interface type changes.
> 
> Unfortunately, when __nl80211_set_channel() is called we may or may
> not have a wdev, so there is nowhere to store the interface-specific
> channel and type.

Well, but if you don't have a wdev, is the setting relevant at all? Or
does it take effect later? This all isn't very well-defined I guess.

> We could shove these into a cfg80211_registered_device, but now just
> "last channel for this wiphy" is tracked, and that doesn't seem to
> help your multi-channel operation.

So you'd want to allow setting the channel on the phy, and have it take
effect for mesh? Is that really something we need to support? I'd think
almost everyone would set the channel on the netdev?

> If the above is correct, how about we leave the existing API as-is and
> simply extend join_mesh to take a channel attribute?

We could, but that'd mean that it can be NULL if the user doesn't set
it, which seems a bit odd to me too and then the driver again would have
to sort it out. I'd prefer if we could sort it out in cfg80211 so the
driver (mac80211) is simpler.

> Also, with IBSS the desired channel is pushed to the driver along with
> the setup parameters. What do you think about calling
> __nl80211_set_channel() directly instead of relying on the cfg80211
> driver to handle this?

No, that's certainly not possible. In IBSS the channel is just the
default channel if we don't find an IBSS. And in any case I'd rather
call set_channel less than more.

johannes

