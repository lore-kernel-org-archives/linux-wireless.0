Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423006AbXBHNQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 08:16:11 -0500
Subject: Re: [RFC PATCH 1/3] wireless: add cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070207073557.GA14703@infradead.org>
References: <20070131013717.GA28076@tuxdriver.com>
	 <20070207004626.GA23096@tuxdriver.com>
	 <20070207004747.GB23096@tuxdriver.com>
	 <20070207073557.GA14703@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5hJmvDu1H5atGTKGJIgf"
Date: Thu, 08 Feb 2007 14:12:57 +0100
Message-Id: <1170940377.4385.48.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5hJmvDu1H5atGTKGJIgf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> > +/*
> > + * This is the new wireless configuration interface.
>=20
> I don't think new makes a lot of sense here, it's hopefully the
> standad one soon.

Heh. I suppose it'll need a better description anyway.

> > + *
> > + * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
> > + */
> > +
> > +#include "core.h"
> > +#include <linux/if.h>
> > +#include <linux/module.h>
> > +#include <linux/err.h>
> > +#include <net/genetlink.h>
> > +#include <net/cfg80211.h>
> > +#include <linux/mutex.h>
> > +#include <linux/list.h>
>=20
> This include order seems odd.  We normally include local headers
> last and net/ after linux/

Oh well. I often just stick in what I need in the order I needed it ;)
I'll change it.

> > +MODULE_AUTHOR("Johannes Berg");
> > +MODULE_LICENSE("GPL");
>=20
> Can you please add a MODULE_DESCRIPTION aswell?

Sure. Then again, didn't you just ask for "why can this be a module at
all" too? :)

> > +
> > +/* RCU might be appropriate here since we usually
> > + * only read the list, and that can happen quite
> > + * often because we need to do it for each command */
> > +LIST_HEAD(cfg80211_drv_list);
> > +DEFINE_MUTEX(cfg80211_drv_mutex);
>=20
> Any reason these are non-static?  They aren't actually used outside
> of this file, and in general having non-static lists isn't very nice,
> we prefer having proper accessor functions.

They'll be used in nl80211 which wasn't part of this patchset. Having
accessor functions for lists is nice as long as it's add/remove, but I
don't like having iterator functions with callbacks and all that much.
And in fact, a list_for_each() is the only thing done with this list...
I'd prefer keeping it this way.

> > --- /dev/null
> > +++ b/net/wireless/wext-compat.c
> > @@ -0,0 +1,25 @@
> > +/* NOT YET */
> > +
>=20
> huh?  this file isn't added to the build process and only contains
> a (non-standard formatted) comment.  No point in adding it in this
> patch.

Heh, yeah, it's replaced right away in the next one. I just had wanted
to document the thoughts that went into that.

johannes

--=-5hJmvDu1H5atGTKGJIgf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFyyHZ/ETPhpq3jKURAlyPAJ9rtnJci00UoJ8WX7qJOwsWNakLLQCfb6Fj
R7nQQaT2hFdzsElSEeTaMRM=
=1YF/
-----END PGP SIGNATURE-----

--=-5hJmvDu1H5atGTKGJIgf--

