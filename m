Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56097 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbZF0IUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jun 2009 04:20:07 -0400
Subject: Re: [RFC 00/11] cfg80211 connect API + wireless extension move
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A43E002.2060309@gmail.com>
References: <20090624120745.239294066@sipsolutions.net>
	 <43e72e890906241324n341f4988wc6e7325ee389e71e@mail.gmail.com>
	 <4A43E002.2060309@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xIqpUvuFXCCZD96ArKPf"
Date: Fri, 26 Jun 2009 23:01:58 +0200
Message-Id: <1246050118.21314.82.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xIqpUvuFXCCZD96ArKPf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-25 at 21:37 +0100, Dave wrote:

> Regarding patch 11 (the internalise one), would it be better to:
>  * continue to export cfg80211_wext_* for now
>  * set mac80211s dev->wireless_handler to &cfg80211_wext_handler in
> iface.c (via a #define that's NULL if !CONFIG_WEXT)
>  * specify a release when we expect all drivers, or at least those
> anyone cares about, to have converted?
>=20
> That removes the WE dependency from mac80211 but allows drivers to
> gradually implement cfg80211 support. I originally attempted doing it in
> one hit - that sucked, but may have been due to not having a clear idea
> of how cfg80211 is supposed to work.

Another idea I just had is that we could do everything like my
internalise patch, but have an if (!netdev->wireless_handlers) before
the assignment. That way, people could still have their own wireless
handlers. Additionally, subject to a Kconfig symbol, we could still
export the handlers, something like this:

config NEED_CFG80211_WEXT_HANDLERS
	bool

#ifdef CONFIG_NEED_...
#define EXPORT_WEXT(sym)		EXPORT_SYMBOL_GPL(sym)
#define __wext_static
static inline void cfg80211_assign_wext_handlers(netdev, handlers)
{
	if (!dev->wireless_handlers)
		dev->wireless_handlers =3D h;
}
#else
#warn "Having custom wireless handlers is deprecated!!"
#define EXPORT_WEXT(sym)
#define __wext_static		static
static inline void cfg80211_assign_wext_handlers(netdev, handlers)
{
	dev->wireless_handlers =3D h;
}
#endif

or something like that. Then drivers that are in transition could select
NEED_... and transition call by call even in the future after we switch
to the central model. Is it worth it? I don't know.

johannes

--=-xIqpUvuFXCCZD96ArKPf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKRTdCAAoJEODzc/N7+QmatH4P/R3Cl3Mq25Yu9Bzu98rpdXk+
cwQLQYfHFMPO9GDgRm0IyTsU1xekfLXR80TTjHdTHchUck89j2upcTJzBYDDpeuB
bN7lW/S9svPF2O1ZTrA/oPwXMinkLw0fIRrXzJnTpTSO/NiDVHXmRH4x7/nve7XW
7q7mtNupXGqhKyu+u/VhfbkAz3pk4ejICzcS+UDkUlSTLJexwu2E+oYAfT5FD2FU
7sJBZ2Kf+hQi1OrIESwGC9vGfkQHUJ/ng+JCmg268RTyX42S9F819weMjNj+Um7O
4XeRZO11mUEThTB0x4s/tMrrtuNAr4Pe4STy/toVTfcUtuVlO/pEfiAb5l1itDja
utZwgJ3959k50DmAx2EA7njHdU3qUimjHWvnT4TE+o6S+H5dysA5wdcGqz0n5c1K
ee6l6QgtuXOiGvT8R4SEpt2P09UzAah+hBrh9YrRovCuSYZdcD3NLPpZQvtd2AFk
o8DvsQlthFZb7pjuA9PRfWNBu15ZfSLi9NRz4lDVCQUQDs1tUhPcutRf36jt8BYR
OpvqihmsofQYjrFIXxZrtWqZb2ON9/rbD0+ZNNQj22F3LxVW4cUAvA61RbcUujJb
Cb/JvfZQwphlLRDAqVKI0ke10jEBavFkD2uligX7J0L4oD8QdiQdNYi0xktGV/QS
gijTAA79TKFRfl1/9saO
=QxrV
-----END PGP SIGNATURE-----

--=-xIqpUvuFXCCZD96ArKPf--

