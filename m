Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab2EJTwL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 15:52:11 -0400
Message-ID: <1336679529.4334.35.camel@jlt3.sipsolutions.net> (sfid-20120510_215214_391012_85BB35D1)
Subject: Re: [RFC] nl80211: don't require netdev UP for wdev
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
Date: Thu, 10 May 2012 21:52:09 +0200
In-Reply-To: <CAG6hwVNTRYpr_H4za0Jf8gVU2=W5f6ZmzCiZsK4Ad2cGa26jDQ@mail.gmail.com> (sfid-20120510_214803_866961_870A1B62)
References: <1335479316-2933-1-git-send-email-thomas@cozybit.com>
	 <1336554945.4323.12.camel@jlt3.sipsolutions.net>
	 <CAG6hwVPrbJ1ZQP=UqFd+oqFL8zm+qcRpbAUhrG+6gRe01rejSA@mail.gmail.com>
	 <1336673569.4334.29.camel@jlt3.sipsolutions.net>
	 <CAG6hwVNTRYpr_H4za0Jf8gVU2=W5f6ZmzCiZsK4Ad2cGa26jDQ@mail.gmail.com>
	 (sfid-20120510_214803_866961_870A1B62)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-10 at 12:47 -0700, Thomas Pedersen wrote:

> > We could, but that'd mean that it can be NULL if the user doesn't set
> > it, which seems a bit odd to me too and then the driver again would have
> > to sort it out. I'd prefer if we could sort it out in cfg80211 so the
> > driver (mac80211) is simpler.
> 
> For this, we can store a default channel and type in the default mesh config.

That would still break older userspace though, it would get the default
channel instead of the channel it set before, right?

> >> Also, with IBSS the desired channel is pushed to the driver along with
> >> the setup parameters. What do you think about calling
> >> __nl80211_set_channel() directly instead of relying on the cfg80211
> >> driver to handle this?
> >
> > No, that's certainly not possible. In IBSS the channel is just the
> > default channel if we don't find an IBSS. And in any case I'd rather
> > call set_channel less than more.
> 
> So cfg80211_set_freq() from cfg80211_join_mesh() is out, too?

I think we should just pass the channel to the join_mesh callback.

I just did this a bit for AP mode. Now, in AP mode we have one
advantage: we can rely on userspace setting the channel because
hostapd/wpa_s always does that. For mesh, we may not have that luxury?

For AP, it looks roughly like this:
http://p.sipsolutions.net/35913f571ea5bd43.txt

Maybe we can do something similar for mesh and mostly get rid of setting
the channel directly.

johannes

