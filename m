Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:62705 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab2GINSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 09:18:06 -0400
Date: Mon, 9 Jul 2012 15:18:13 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2] nl/cfg/mac80211: add set_mcast_rate API
Message-ID: <20120709131813.GD4488@ritirata.org> (sfid-20120709_151810_781125_38E26548)
References: <1341739885-15385-1-git-send-email-ordex@autistici.org>
 <1341791503-12542-1-git-send-email-ordex@autistici.org>
 <1341839146.4455.40.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
In-Reply-To: <1341839146.4455.40.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 09, 2012 at 03:05:46PM +0200, Johannes Berg wrote:
> On Mon, 2012-07-09 at 01:51 +0200, Antonio Quartulli wrote:
>=20
> > +static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_de=
vice *dev,
> > +				    int mcast_rate[IEEE80211_NUM_BANDS])
> > +{
> > +	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> > +	u32 basic_rates =3D sdata->vif.bss_conf.basic_rates;
> > +	int i;
> > +
> > +	/* check if the mcast_rates are also in basic_rates */
> > +	for (i =3D 0; i < IEEE80211_NUM_BANDS; i++)
> > +		if (!(basic_rates & BIT(mcast_rate[i] - 1)))
> > +			return -EINVAL;
>=20
> So this is kinda broken. In fact, the whole basic rate thing is broken
> it seems.
>=20
> The mcast rate is per band, as it should, since you could find the same
> BSSID on a 5 GHz channel and then jump to that channel if the TSF is
> higher...
>=20
> However, the basic rates aren't, which is wrong: the basic rates bitmap
> could be 1,2,6,9. If the driver is like most drivers, that translates to
> a bitmap of 0x33. But 0x33, for most drivers, if applied to the 5 GHz
> rates means 6,9,24,36. See why this is broken? A rate bitmap can't be
> siwtched around between bands and still make any sense.

I see, I wrongly thought that nl80211_parse_mcast_rate() was checking if the
provided mcast_rate belongs to the basic_rate set of the band which we are =
now.

But that's wrong! nl80211_parse_mcast_rate() only checks if the provided
mcast_rate exists somewhere...

>=20
> Oh, also, I'm not sure why you do BIT(... -1), but that's unrelated.
> What kind of value is the mcast rate? A rate index, or a number?
>=20

it's an index and actually it's the index +1, as reported in mac80211.h:

 * @mcast_rate: per-band multicast rate index + 1 (0: disabled)



> johannes

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk/62hUACgkQpGgxIkP9cwcrZwCeI6sZS06zfHQ/Ttui9UlWErvZ
iKgAn0p26rfAPRNhQO/hVgg5slA4d8f6
=+6pS
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
