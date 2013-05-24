Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3EXUcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 16:32:36 -0400
Message-ID: <1369427550.13623.3.camel@johannes> (sfid-20130524_223240_064816_4B8A57C3)
Subject: Re: [RFC 06/12] mac80211: notify bridge when leaving mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>,
	open80211s <devel@lists.open80211s.org>
Date: Fri, 24 May 2013 22:32:30 +0200
In-Reply-To: <CAG6hwVPah-8FjH=ntFPzxMzXi5ePcmG-UEhdsvEgHkJVE9khYQ@mail.gmail.com> (sfid-20130522_030953_079668_4D426723)
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
	 <1367548442-8229-7-git-send-email-thomas@cozybit.com>
	 <1367934155.8328.21.camel@jlt4.sipsolutions.net>
	 <CAG6hwVPah-8FjH=ntFPzxMzXi5ePcmG-UEhdsvEgHkJVE9khYQ@mail.gmail.com>
	 (sfid-20130522_030953_079668_4D426723)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-05-21 at 18:09 -0700, Thomas Pedersen wrote:
> Hey, Sorry for the late response.

Me too :)

> >>       netif_carrier_off(sdata->dev);
> >> +     if (sdata->dev->priv_flags & IFF_BRIDGE_PORT)
> >> +             /* stop bridge transmissions */
> >> +             call_netdevice_notifiers(NETDEV_CHANGE, sdata->dev);
> >
> > Err, this seems like a really bad hack? I don't really think drivers
> > should call that?
> 
> Why not? We're just notifying the bridge interface that this port has
> gone down, to avoid dereferencing a null pointer (on bridge flood
> traffic) after the mesh_bss has been removed.
> 
> Is cfg80211_leave_mesh() an acceptable location for this fix?

I'm not really convinced it's an acceptable fix in itself? Why should we
ever have to call netdev notifiers, that seems odd to me. Also why would
that prevent a crash? Wouldn't we just drop packets for the mesh if we
aren't joined in a mesh any more? Or something like that? Accessing the
priv flags and then calling the netdev notifiers seems really strange to
me. If this was necessary, then wouldn't netif_carrier_off() do it
internally?

johannes

