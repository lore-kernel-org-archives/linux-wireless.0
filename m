Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:40134 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab2GINZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 09:25:17 -0400
Date: Mon, 9 Jul 2012 15:25:27 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2] nl/cfg/mac80211: add set_mcast_rate API
Message-ID: <20120709132527.GE4488@ritirata.org> (sfid-20120709_152522_902049_8B458824)
References: <1341739885-15385-1-git-send-email-ordex@autistici.org>
 <1341791503-12542-1-git-send-email-ordex@autistici.org>
 <1341839146.4455.40.camel@jlt3.sipsolutions.net>
 <1341839551.4455.47.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ytoMbUMiTKPMT3hY"
In-Reply-To: <1341839551.4455.47.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ytoMbUMiTKPMT3hY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 09, 2012 at 03:12:31PM +0200, Johannes Berg wrote:
> On Mon, 2012-07-09 at 15:05 +0200, Johannes Berg wrote:
> > On Mon, 2012-07-09 at 01:51 +0200, Antonio Quartulli wrote:
> >=20
> > > +static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_=
device *dev,
> > > +				    int mcast_rate[IEEE80211_NUM_BANDS])
> > > +{
> > > +	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev=
);
> > > +	u32 basic_rates =3D sdata->vif.bss_conf.basic_rates;
> > > +	int i;
> > > +
> > > +	/* check if the mcast_rates are also in basic_rates */
> > > +	for (i =3D 0; i < IEEE80211_NUM_BANDS; i++)
> > > +		if (!(basic_rates & BIT(mcast_rate[i] - 1)))
> > > +			return -EINVAL;
> >=20
> > So this is kinda broken. In fact, the whole basic rate thing is broken
> > it seems.
> >=20
> > The mcast rate is per band, as it should, since you could find the same
> > BSSID on a 5 GHz channel and then jump to that channel if the TSF is
> > higher...
> >=20
> > However, the basic rates aren't, which is wrong: the basic rates bitmap
> > could be 1,2,6,9. If the driver is like most drivers, that translates to
> > a bitmap of 0x33. But 0x33, for most drivers, if applied to the 5 GHz
> > rates means 6,9,24,36. See why this is broken? A rate bitmap can't be
> > siwtched around between bands and still make any sense.
>=20
> Ok actually maybe it's not broken. We adopt the basic rates from the
> network we join, I guess, and the original basic rates specified from
> userspace are only used when we actually *create* the network?

mhmm.. I have to check

>=20
> Still though, comparing the bits for all bands against the same bitmap
> like you did in the above code is just wrong :-)
>=20

right, I should select the BAND which we are using and check that index onl=
y.

> Maybe we shouldn't bother at all. If we'd join another network, we might
> have to downgrade the mcast rate, but then if some peer leaves or we
> join another one ... it gets messy quickly.
>=20

it's adhoc! :-)


> Since all of this is probably for special cases anyway, maybe we should
> just not check the mcast rate and if you set a stupid one you don't get
> packets through to all peers? Could be hard to debug though ...

definitely hard.
we should keep the intersection of all the rates we have seen and chose the=
 one
set by the user if possible or the highest mandatory we have in our set. So=
unds
too easy :-)




--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--ytoMbUMiTKPMT3hY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk/628cACgkQpGgxIkP9cwfA5wCfUAdPysA8DBPE239X5TTwlizs
LToAoIJ/pt1MiOjn1kGhDENeRe511mzS
=TYcU
-----END PGP SIGNATURE-----

--ytoMbUMiTKPMT3hY--
