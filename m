Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423000AbXBHNQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 08:16:11 -0500
Subject: Re: [RFC PATCH 3/3] cfg80211: add wext-compatible client
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070207075420.GB14703@infradead.org>
References: <20070131013717.GA28076@tuxdriver.com>
	 <20070207004626.GA23096@tuxdriver.com>
	 <20070207004747.GB23096@tuxdriver.com>
	 <20070207004832.GC23096@tuxdriver.com>
	 <20070207004929.GD23096@tuxdriver.com>
	 <20070207075420.GB14703@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4cQu2s596MHEmtBBfU/+"
Date: Thu, 08 Feb 2007 14:13:06 +0100
Message-Id: <1170940386.4385.49.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4cQu2s596MHEmtBBfU/+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-07 at 07:54 +0000, Christoph Hellwig wrote:

> Do we really have to add this directly to struct net_device and bloat it
> for all users?  I'd put this behind  ieee80211_ptr instead unless there's
> a good reason against that.

Well, the reason currently is that cfg80211 treats ieee80211_ptr as an
opaque cookie, it doesn't need to know what it points to.

Of course, I intend to change that too...

> > +config CFG80211_WEXTNL_COMPAT
> > +	bool "cfg80211 WE-netlink compatibility"
> > +	depends CFG80211 && CFG80211_WEXT_COMPAT
> > +	---help---
> > +	This option allows using devices whose drivers have been
> > +	converted to use the new cfg80211 with wireless extensions
> > +	over rtnetlink, providing WE-20 compatibility. Note that
> > +	cfg80211's "native" interface is nl80211 using generic netlink.
> > +	The wireless extensions are being deprecated and the netlink
> > +	based API for WE was never configured by default, nor do any
> > +	userspace tools use this feature.
> > +
> > +	This option exists only to make Jean happy. Say N.
>=20
> Should we really put this code in?  It seems like unessecary bloat to me.

Yeah. Jean disappeared anyway, I'll kill it.

> > @@ -2798,6 +2799,39 @@ int dev_ioctl(unsigned int cmd, void __user *arg=
)
> >  					ret =3D -EFAULT;
> >  				return ret;
> >  			}
> > +#ifdef CONFIG_CFG80211_WEXT_COMPAT
> > +			/* Take care of cfg80211 WE compatibility */
> > +			if (cmd >=3D SIOCIWFIRST && cmd <=3D SIOCIWLAST) {
> > +				/* If command is `set a parameter', or
> > +				 * `get the encoding parameters', check if
> > +				 * the user has the right to do it */
> > +				if (IW_IS_SET(cmd) || cmd =3D=3D SIOCGIWENCODE
> > +				    || cmd =3D=3D SIOCGIWENCODEEXT) {
> > +					if (!capable(CAP_NET_ADMIN))
> > +						return -EPERM;
> > +				}
> > +				dev_load(ifr.ifr_name);
> > +				rtnl_lock();
> > +				/* Follow me in net/wireless/wext-compat.c */
> > +				ret =3D cfg80211_wext_ioctl(&ifr, cmd);
> > +				rtnl_unlock();
> > +				if (ret =3D=3D 0 && IW_IS_GET(cmd) &&
> > +				    copy_to_user(arg, &ifr,
> > +						 sizeof(struct ifreq)))
> > +					ret =3D -EFAULT;
> > +				/* haha, I cheat here by allowing a driver or
> > +				 * stack to have both WE or CFG80211-WE for
> > +				 * a little while during conversion... hope that
> > +				 * ENOSYS is only used to indicate not implemented
> > +				 *
> > +				 * if wireless extensions are not configured
> > +				 * then this is the last thing here so that
> > +				 * if we fall through we return -EINVAL
> > +				 */
> > +				if (ret !=3D -ENOSYS)
> > +					return ret;
> > +			}
>=20
> Can we split this into a nice little helper function in wext-compat.c
> or a dummy macro if it's not configured?

I guess I can do that. Maybe I'll do the same with wext too.

> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -56,6 +56,9 @@
> >  #include <linux/wireless.h>
> >  #include <net/iw_handler.h>
> >  #endif	/* CONFIG_NET_WIRELESS_RTNETLINK */
> > +#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
> > +#include <net/cfg80211.h>
> > +#endif
>=20
> There's not point in including headers conditionally.

It helps ccache when you change that header, but yeah, let's just
include it.

> This looks odd. Kbuild filters out duplicate objects, so something like
> the snipplet below should work aswell:
>=20
> obj-$(CONFIG_WIRELESS_EXT)		+=3D wext-common.o wext-old.o
> obj-$(CONFIG_CFG80211_WEXT_COMPAT)	+=3D wext-common.o wext-compat.o=09

Hah, good point, I never even thought of something that would just
duplicate it.

> > +#ifdef CONFIG_CFG80211_WEXT_COMPAT
> > +/* wext compatibility must be compiled in...
> > + * this extern is in wext-compat.c */
>=20
> Is there really a point in making cfg80211 a loadable module?
> This whle operation vector stuff looks like a lot of unnessecary
> complexity to me.

I think there is point in doing it as it allows us to replace it with an
out-of-tree newer version for getting it into the hands of users who
might not want to replace their whole kernel.

> > new file mode 100644
> > index 0000000..c1de1d7
> > --- /dev/null
> > +++ b/net/wireless/wext-common.c
> > @@ -0,0 +1,610 @@
> > +/* common wext support routines, proc interface and events */
>=20
> This is mostly Jean's old code, right?  Probably wants at least some
> attribution.

Yeah, good point, it's mostly code that moved from that file to here.

> Btw, if we submit cfg80211 for inclusion there should be at least one pat=
ch
> in the series actually converts a driver to use it.  Both to make this
> code not dead and give people and example on how to use the cfg80211
> infrastructure.

I guess I could make softmac use it.

johannes

--=-4cQu2s596MHEmtBBfU/+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFyyHi/ETPhpq3jKURAq7JAJ9iGQtdpfN4esuYlvPkVQW+PsAmMQCgqs7q
UwC6evotpZYb5X9okDLTQmI=
=zrhX
-----END PGP SIGNATURE-----

--=-4cQu2s596MHEmtBBfU/+--

