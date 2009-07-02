Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41704 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZGBJxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 05:53:17 -0400
Subject: Re: [PATCH 8/8 v3.1] mac80211: re-add HT disabling
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>
In-Reply-To: <20090702095134.GA11235@jm.kir.nu>
References: <20090630115245.675553951@sipsolutions.net>
	 <20090630115303.111250594@sipsolutions.net>
	 <20090630132547.GB24667@vasanth-laptop>
	 <1246369077.16643.10.camel@johannes.local>
	 <20090630135207.GC24667@vasanth-laptop>
	 <1246370452.16643.11.camel@johannes.local>
	 <1246433956.16643.35.camel@johannes.local>
	 <20090701101336.GD24667@vasanth-laptop>
	 <1246444959.4131.15.camel@johannes.local>
	 <20090702095134.GA11235@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6/7RbkYQWOTGa6RmZ94t"
Date: Thu, 02 Jul 2009 11:53:17 +0200
Message-Id: <1246528397.16770.31.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6/7RbkYQWOTGa6RmZ94t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-02 at 12:51 +0300, Jouni Malinen wrote:
> On Wed, Jul 01, 2009 at 12:42:39PM +0200, Johannes Berg wrote:
> > On Wed, 2009-07-01 at 15:43 +0530, Vasanthakumar Thiagarajan wrote:
> > > On Wed, Jul 01, 2009 at 01:09:16PM +0530, Johannes Berg wrote:
> > > > @@ -1236,6 +1236,14 @@ static int ieee80211_assoc(struct wiphy
> > > > +       for (i =3D 0; i < req->crypto.n_ciphers_pairwise; i++)
> > > > +               if (req->crypto.ciphers_pairwise[i] =3D=3D WLAN_CIP=
HER_SUITE_WEP40 ||
>=20
> > > for..loop does not seem to be necessary here as it is very unlikely t=
hat
> > > an assoc req will have more than one cipher suite.
>=20
> > True, but so far we've defined the API that way. Should we redefine the
> > API? I keep forgetting what is valid where. Jouni?
>=20
> The (re)association request is only allowed to list one pairwise cipher
> suite (see IEEE 802.11, 8.4.3). Various other use cases for RSN IE
> support multiple cipher suites, but this one does not.

So we have to support multiple for connect() to allow the card/driver to
choose, but a single one for associate()?

johannes

--=-6/7RbkYQWOTGa6RmZ94t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKTIOKAAoJEODzc/N7+QmaKMcP/iBp6eUrJ2zEo8D8tuiScV1b
Jh3QBKHfCT2AgPkKyMzSVIkXSafiOSemrvBSg+L9rFOwsPv8z2EOmipK4A/SCQRQ
i1qBjJB8Q02CgSCeK8FYeh6ehLdhBTVLTah870EF8XL9HzzhAqX4OWOi+Sm8V3XG
/fge+GHn7tp45SM9W9Bl4UcU3E677UUpVXOX58IAS3n4TpFK3/G60IUosMCGTdmL
LIRhdAuDCq3/foqIu67kTbtvxUMd4i7pCFG1U3qq705lgPt9iGxX48MsxpaHq9qk
i58XYwebqyPDX7nLC1lOlhaGc6GnJOOD7S2BrJKdQ9+4X85kWG2jfQNzs7XG18Io
nP8mNbsamSqnVJMBg4tUqRssOWwEul8IFGfti/mi3mifXLTKoKrB3HHXacQ42A9M
0I3M1mENqCZQwX8QDViP4jQyUsjqvMSGgX5mPBAiuqQxnAuVn3uvABuhyWg6PzJh
Abl9rlYxPxrO9VmRVn9huaJuAGrskR2yA51ZUsTrF9rbT/oSKPVj8Z1xbHjkeDfN
6MR5KLTKf4osdAvJTd3oZ53CJT1B7EnfxIm5Qv4cdNaDCcNjPcNEx4kmQFtPtffb
ZBZ1nugZXcfwx+fsWS6tS7PDZ6ZFuszMnMLExuFyM2MEOOK7lbDfiJJO2Bi6Wx2e
wTWraXTgmAQAjIfTzLys
=jyDW
-----END PGP SIGNATURE-----

--=-6/7RbkYQWOTGa6RmZ94t--

