Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:39245 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab2FZSz0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 14:55:26 -0400
Date: Tue, 26 Jun 2012 20:55:34 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Will Hawkins <hawkinsw@opentechinstitute.org>,
	Will Hawkins <hawkinsw@opentechinitiative.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Help tracing NL80211_CMD_AUTHENTICATE as event in IBSS mode
Message-ID: <20120626185533.GA7932@ritirata.org> (sfid-20120626_205533_636587_B535033A)
References: <24f-4fe93400-17-239c5900@2266046>
 <1340693584.4662.3.camel@jlt3.sipsolutions.net>
 <4FE9E201.1010903@opentechinstitute.org>
 <1340728873.4484.6.camel@jlt3.sipsolutions.net>
 <4FE9E6F0.2070909@opentechinstitute.org>
 <1340730210.4484.11.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
In-Reply-To: <1340730210.4484.11.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 26, 2012 at 07:03:30PM +0200, Johannes Berg wrote:
> On Tue, 2012-06-26 at 12:44 -0400, Will Hawkins wrote:
>=20
> > > Huh, now I'm confused, why would it need the authenticate frames for
> > > IBSS? As far as I can tell, it looks at CMD_NEW_STA, which calls
> > > nl80211_new_station_event(),=20
> >=20
> > This is what I understand as well.
> >=20
> > which in IBSS sends EVENT_IBSS_RSN_START to
> > > the supplicant core -- that will trigger the 4-way-handshake. No? Hen=
ce
> > > it doesn't need to register for auth frames, it never needs them, sin=
ce
> > > RSN uses open auth, if any is even used in IBSS at all.
> >=20
> > This is where I am still trying to figure out exactly how it works.
>=20
> I believe that when the new station is added (NEW_STA event), it will
> simply send out a 1/4 EAPOL frame. Since both do that, I guess it does
> some kind of de-duplication? Whoever sends it first wins or something,
> but I don't really know. Maybe we should take the discussion to the
> hostap list at this point :-)

Yeah, Johannes is right when saying that NEW_STA simply makes wpa_s trigger=
 a
EVENT_IBSS_RSN_START that will start a 4-way handshake.

Auth frames are not used at all in wpa_s for IBSS/RSN. Auth frames are only=
 used
in the kernel to remove and then add again a station from the neighbour lis=
t. In
this way wpa_s will first purge that station and then will add it again tha=
nks
to another NEW_STA event.

@johannes: de-duplication? IBSS/RSN assumes that each node runs an authenti=
cator
and a supplicant. Does this mean that we need exactly two 4-way handshakes?=
 Why
should we have a "winner"?

Cheers,



--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk/qBaUACgkQpGgxIkP9cwcsZgCaA3+OOEn3EjKyl8wO7wAB9nrD
zV0AnAk1b2E3iIG//sW7FtNzfYXA4vPs
=jC+S
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
