Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34407 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab1ISMFJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 08:05:09 -0400
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1316408970.2157.9.camel@cumari>
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
	 <1316408970.2157.9.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 14:05:05 +0200
Message-ID: <1316433905.5995.4.camel@jlt3.sipsolutions.net> (sfid-20110919_140528_343966_8F70FFBA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-19 at 08:09 +0300, Luciano Coelho wrote:
> On Sun, 2011-09-18 at 15:03 +0300, Eliad Peller wrote: 
> > In some cases the driver might want to change the
> > default dynamic ps timeout (e.g. coex activity adds
> > latency to the rx/tx path, which might result in
> > redundant psm entrance).

> Let's see what Johannes is going to say about this change in mac80211,
> but IIRC this timeout used to exist with WEXT, but it was not
> implemented in nl80211.  We (at Nokia, probably Juuso) tried to
> implement it a long time ago, but after some discussions with Johannes,
> it was decided that this value wouldn't be settable from userspace at
> least.  I don't know if it was considered setting it from the driver
> side, though.

Yeah it's a good question ... but in this case there actually is some
actual reason for it -- I think it's probably used for BT coexist?
Obviously the user can't make an informed choice in that scenario, but
the device might actually be able to? My biggest objection back then was
that the user has no real reason to play with it, and the latency
properties of it are better done in other ways.

Which actually makes me think that having a completely fixed value from
the driver might not be a good thing? I mean, yes, we allow wext to
override it, but really we want this to be controlled by the latency
requirements I think. That's obviously something of a pipe dream right
now since nothing seems to ever use that, but ...

So anyway, do we really want this to be completely fixed by the driver?
Maybe a range would be better?

johannes

