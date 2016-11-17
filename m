Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47484 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934126AbcKQRZP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 12:25:15 -0500
Message-ID: <1479403511.13485.4.camel@sipsolutions.net> (sfid-20161117_182534_691148_9901EDB5)
Subject: Re: [PATCH 8/8] Print frequency of radar events.
From: Benjamin Berg <benjamin@sipsolutions.net>
To: Henrik Eriksson <henrik.eriksson@axis.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, sw@simonwunderlich.de
Date: Thu, 17 Nov 2016 18:25:11 +0100
In-Reply-To: <20161117172134.GB14213@lnxhenriken2.se.axis.com> (sfid-20161117_182137_909159_3E8FDC86)
References: <20161107145943.16761-1-benjamin@sipsolutions.net>
         <20161107145943.16761-9-benjamin@sipsolutions.net>
         <20161117172134.GB14213@lnxhenriken2.se.axis.com>
         (sfid-20161117_182137_909159_3E8FDC86)
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-RRhHiQGPeE/pWYINYdLE"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RRhHiQGPeE/pWYINYdLE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-11-17 at 18:21 +0100, Henrik Eriksson wrote:
> On Mon,=C2=A0Nov=C2=A007,=C2=A02016=C2=A0at=C2=A015:59:43=C2=A0+0100, Ben=
jamin Berg wrote:
> > > > +			if (!tb[NL80211_ATTR_RADAR_EVENT] || !tb[NL80211_ATTR_WIPHY_FRE=
Q])
> > > > +				printf("BAD radar event");
>=20
> Should not this end the parsing here or at least avoid getting the value =
of
> the NULL attributes below?=C2=A0=C2=A0I do not know if libnl nla_get_u32(=
) is
> intended to be NULL safe, but following
> https://www.infradead.org/~tgr/libnl/doc/api/attr_8c_source.html#l00624
> it seems like you will get whatever u32 value is at address
> (NULL+)NLA_HDRLEN, assuming it is readable.=C2=A0=C2=A0The original behav=
ior was to
> do nothing if tb[NL80211_ATTR_RADAR_EVENT] was not set.
>=20
> > > > +			freq =3D nla_get_u32(tb[NL80211_ATTR_WIPHY_FREQ]);
> > > > +			event_type =3D nla_get_u32(tb[NL80211_ATTR_RADAR_EVENT]);

Yes, my version of the patch was somewhat broken in that regard.
Johannes fixed it before merging and it will now correctly print "BAD
radar event\n" and stop processing in case one of the entries is
missing.

Benjamin
--=-RRhHiQGPeE/pWYINYdLE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEgVSeanxpB7WrDIKT0SNopmGFbCAFAlgt5/cACgkQ0SNopmGF
bCCRBA/+IAbqpWkAqzj53MPSeHVQ6BLHlS84P9KVHCHv1sZAdFdpnTjBpOTzLn8j
LvWN8NZNg2k3BQ3SvkYLg7H6LiQK9ICJblbha/grVimQtBlfeGI8jOPLHbA4AkBq
56B0mfrwgKxCX7S0TR6w94+4RNrVDh+gMFxC5Q82ukR1MDz+ZM7n0JZuoNS2vqxd
0uz4YuzhyTdDt6cwawyVklV37k5+pJed7Lf60ZUUvzcHosYCy1nlJ2e8cmRvM9X7
f21rEXUmt+mxj85Ekm9f7eaBoBVSe3wyjkENtFWiLlH42Bh9X04fQ0FJX6ex35GC
m3AvWQwO8YBTQjK4aoV1P/1DB1yInBJxwXJWPR+hTkKUeXU09rG0SiA40m07Fnu2
8uRYB9pf7F/H5U3Wq9Kbt38ghaVOZf0GFvM+noaovPxIKuV/UxZqRpV9v2e0lTVG
8xYLu04fobFg3foqKSAAOfkqwhzAzxC3Bu86SWGKfQ3skWekXNDuKS3uKPXmfZ1I
/X2AJFYrA/dSTxzShzAhK0MiVEi12B6diiIEqkpWaOzRe8U+oWTOdVbkrgC6f9xO
D6ZyJVnmlN53a0PsRc6hOd4H7qz/xRIpEUtYSvM/n1LN5dhZoQsNxgDYQbg8FThi
mrElIaw/uTe1Ou2DzeXCUxVpJbVP7LtH7XriHRGvItavqBjW58I=
=nMWd
-----END PGP SIGNATURE-----

--=-RRhHiQGPeE/pWYINYdLE--
