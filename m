Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:64573 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab2GIN1I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 09:27:08 -0400
Date: Mon, 9 Jul 2012 15:27:15 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2] nl/cfg/mac80211: add set_mcast_rate API
Message-ID: <20120709132715.GF4488@ritirata.org> (sfid-20120709_152712_671801_3B5B345E)
References: <1341739885-15385-1-git-send-email-ordex@autistici.org>
 <1341791503-12542-1-git-send-email-ordex@autistici.org>
 <1341839146.4455.40.camel@jlt3.sipsolutions.net>
 <20120709131813.GD4488@ritirata.org>
 <1341839999.4455.48.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WlEyl6ow+jlIgNUh"
In-Reply-To: <1341839999.4455.48.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--WlEyl6ow+jlIgNUh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 09, 2012 at 03:19:59PM +0200, Johannes Berg wrote:
> On Mon, 2012-07-09 at 15:18 +0200, Antonio Quartulli wrote:
>=20
> > > So this is kinda broken. In fact, the whole basic rate thing is broken
> > > it seems.
> > >=20
> > > The mcast rate is per band, as it should, since you could find the sa=
me
> > > BSSID on a 5 GHz channel and then jump to that channel if the TSF is
> > > higher...
> > >=20
> > > However, the basic rates aren't, which is wrong: the basic rates bitm=
ap
> > > could be 1,2,6,9. If the driver is like most drivers, that translates=
 to
> > > a bitmap of 0x33. But 0x33, for most drivers, if applied to the 5 GHz
> > > rates means 6,9,24,36. See why this is broken? A rate bitmap can't be
> > > siwtched around between bands and still make any sense.
> >=20
> > I see, I wrongly thought that nl80211_parse_mcast_rate() was checking i=
f the
> > provided mcast_rate belongs to the basic_rate set of the band which we =
are now.
>=20
> Well, ok, don't get confused -- there's no basic rate set "of the band",
> it's a BSS property.
>=20
> > But that's wrong! nl80211_parse_mcast_rate() only checks if the provided
> > mcast_rate exists somewhere...
>=20
> It checks that each rate exists in the band that it's for.
>=20
> > > Oh, also, I'm not sure why you do BIT(... -1), but that's unrelated.
> > > What kind of value is the mcast rate? A rate index, or a number?
> > >=20
> >=20
> > it's an index and actually it's the index +1, as reported in mac80211.h:
> >=20
> >  * @mcast_rate: per-band multicast rate index + 1 (0: disabled)
>=20
> also in the cfg80211 API?

yes

>=20
> johannes

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--WlEyl6ow+jlIgNUh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk/63DMACgkQpGgxIkP9cwcaqACdGl6+fMtcTqgP9B9y5Vz1VLsJ
HloAoIuAAJMeVX+Hlgf5sCAXo2NjkQtu
=9u6U
-----END PGP SIGNATURE-----

--WlEyl6ow+jlIgNUh--
