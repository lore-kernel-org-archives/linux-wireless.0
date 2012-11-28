Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36964 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957Ab2K1SZq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 13:25:46 -0500
Message-ID: <1354127104.25524.33.camel@cumari.coelho.fi> (sfid-20121128_192549_434754_F6BDDDF4)
Subject: Re: [PATCH 01/20] wl12xx/wl18xx: update default fw logger's settings
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>, Ido Reis <idor@ti.com>
Date: Wed, 28 Nov 2012 20:25:04 +0200
In-Reply-To: <CA+XVXfeayZphowex+j7Ed0Mn+pWVjvKwzUntfTAQiYQ9SszL0w@mail.gmail.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-2-git-send-email-arik@wizery.com>
	 <1354113278.25524.28.camel@cumari.coelho.fi>
	 <CA+XVXfeayZphowex+j7Ed0Mn+pWVjvKwzUntfTAQiYQ9SszL0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 19:46 +0200, Arik Nemtsov wrote:
> On Wed, Nov 28, 2012 at 4:34 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
> >> From: Ido Reis <idor@ti.com>
> >>
> >> update the fw logger mode to continuous, and output to dbgpins (uart).
> >>
> >> Signed-off-by: Ido Reis <idor@ti.com>
> >> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> >> ---
> >
> > I think for upstream it's best to keep it as it was? Most people won't
> > have the debug pins and won't want to get them continuously.  Sending to
> > the host and only on demand seems more reasonable to me.
> 
> I think the default settings should be the ones the dev people are
> using. For production a customer can (and will) change this via a
> wlconf file.

I disagree.  What goes upstream is not for the developers, but for the
users.  Developers can more easily change the wlconf file (they know
about it), end-users can just send us what we ask, without having to
mangle with wlconf.


> I also know firsthand that the SDIO logger is pretty bad (misses
> logs). The only way to get decent logging is via the dbg pins.

The dbg pins also miss logs sometimes, when they come too fast.  For
"real life" (ie. mainline) we should assume that most users won't have a
board with dbg pins exposed.

We can keep this patch in our internal tree.

--
Luca.

