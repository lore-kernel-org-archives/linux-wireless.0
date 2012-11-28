Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:41649 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab2K1UAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 15:00:37 -0500
Message-ID: <1354132796.25524.36.camel@cumari.coelho.fi> (sfid-20121128_210042_711528_D4A12836)
Subject: Re: [PATCH 01/20] wl12xx/wl18xx: update default fw logger's settings
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>, Ido Reis <idor@ti.com>
Date: Wed, 28 Nov 2012 21:59:56 +0200
In-Reply-To: <CA+XVXfctapfgvf5VA-CzyZseX=x6VebfeVSmdxTvtLzT=YQBjA@mail.gmail.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-2-git-send-email-arik@wizery.com>
	 <1354113278.25524.28.camel@cumari.coelho.fi>
	 <CA+XVXfeayZphowex+j7Ed0Mn+pWVjvKwzUntfTAQiYQ9SszL0w@mail.gmail.com>
	 <1354127104.25524.33.camel@cumari.coelho.fi>
	 <CA+XVXfctapfgvf5VA-CzyZseX=x6VebfeVSmdxTvtLzT=YQBjA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 21:12 +0200, Arik Nemtsov wrote:
> On Wed, Nov 28, 2012 at 8:25 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Wed, 2012-11-28 at 19:46 +0200, Arik Nemtsov wrote:
> >> On Wed, Nov 28, 2012 at 4:34 PM, Luciano Coelho <coelho@ti.com> wrote:
> >> > On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
> >> >> From: Ido Reis <idor@ti.com>
> >> >>
> >> >> update the fw logger mode to continuous, and output to dbgpins (uart).
> >> >>
> >> >> Signed-off-by: Ido Reis <idor@ti.com>
> >> >> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> >> >> ---
> >> >
> >> > I think for upstream it's best to keep it as it was? Most people won't
> >> > have the debug pins and won't want to get them continuously.  Sending to
> >> > the host and only on demand seems more reasonable to me.
> >>
> >> I think the default settings should be the ones the dev people are
> >> using. For production a customer can (and will) change this via a
> >> wlconf file.
> >
> > I disagree.  What goes upstream is not for the developers, but for the
> > users.  Developers can more easily change the wlconf file (they know
> > about it), end-users can just send us what we ask, without having to
> > mangle with wlconf.
> 
> I think the users won't know what to do with this anyway without some
> guidance from TI during debugging, so this argument is pretty moot
> IMHO.

Yeah, no use to keep arguing.


> I guess we also differ in our point of view about this stuff. When I'm
> constantly working with an evolving driver, it helps to have the
> default tuned to my needs.

Your needs, so keep a patch in your tree.  Or, the proper way, fine-tune
your wlconf binary file! :)


> >> I also know firsthand that the SDIO logger is pretty bad (misses
> >> logs). The only way to get decent logging is via the dbg pins.
> >
> > The dbg pins also miss logs sometimes, when they come too fast.  For
> > "real life" (ie. mainline) we should assume that most users won't have a
> > board with dbg pins exposed.
> >
> > We can keep this patch in our internal tree.
> 
> I'm for keeping as little stuff as possible in the internal tree.

I'm for avoiding patches changing this configuration all the time in the
mainline.  In fact, this whole hardcoded wlconf struct was not supposed
to be there at all (did you notice that the driver prints out an *error*
if you don't have a proper wlconf file?).

--
Luca.

