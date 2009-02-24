Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49462 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbZBXFQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 00:16:53 -0500
Subject: Re: [PATCH v2 3/5] cfg80211: Add AP beacon regulatory hints
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090224022923.GK4264@tesla>
References: <1235193641-17993-1-git-send-email-lrodriguez@atheros.com>
	 <1235193641-17993-4-git-send-email-lrodriguez@atheros.com>
	 <1235440730.4455.51.camel@johannes.local>  <20090224022923.GK4264@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xn+9GafHWcqv7wqVsRU7"
Date: Mon, 23 Feb 2009 18:47:43 -0800
Message-Id: <1235443663.4455.79.camel@johannes.local> (sfid-20090224_061700_638848_5D54A915)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xn+9GafHWcqv7wqVsRU7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-23 at 18:29 -0800, Luis R. Rodriguez wrote:
> On Mon, Feb 23, 2009 at 05:58:50PM -0800, Johannes Berg wrote:
> > On Sat, 2009-02-21 at 00:20 -0500, Luis R. Rodriguez wrote:
> >=20
> > > +static bool freq_is_chan_12_13_14(u16 freq)
> > > +{
> > > +	if (freq =3D=3D ieee80211_channel_to_frequency(12) ||
> > > +	    freq =3D=3D ieee80211_channel_to_frequency(13) ||
> > > +	    freq =3D=3D ieee80211_channel_to_frequency(14))
> > > +		return true;
> > > +	return false;
> > > +}
> > > +
> > > +int regulatory_hint_found_beacon(struct wiphy *wiphy,
> > > +				 struct ieee80211_channel *beacon_chan,
> > > +				 gfp_t gfp)
> > > +{
> > > +	struct reg_beacon *reg_beacon;
> > > +
> > > +	if (likely((beacon_chan->beacon_found ||
> > > +	    (beacon_chan->flags & IEEE80211_CHAN_RADAR) ||
> > > +	    (beacon_chan->band =3D=3D IEEE80211_BAND_2GHZ &&
> > > +	     !freq_is_chan_12_13_14(beacon_chan->center_freq)))))
> > > +		return 0;
> >=20
> > This doesn't seem right, shouldn't it use the world regulatory domain t=
o
> > check against rather than hardcoding it?
>=20
> I'm not sure I understand, can you elaborate on what you mean.

Well this looks like a check "is it outside the world regulatory domain
but in 2.4 ghz", right? So it should check the world regulatory domain,
rather than hardcoding?

johannes

--=-xn+9GafHWcqv7wqVsRU7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo1/KAAoJEKVg1VMiehFYU9sP/iEt6vIU9G57xHHEIFgmGwlm
++sN9xlltQUlRDQde1Osz2Bs/x/kC55Usd475iqsMQ9YsMzn8g4Vgn60Ykx59fQ2
lknnZp5I8b44GGFN9adZi3nQqdPfSaJE/DJUi96AZpSY9ZqppsOLboiUOCkKHyko
6/Si+Xvdk5KbTb4mSxl0CnqKnp+UaVQ6yFTg98xXpXo4hNx9s5g/ttxn6s/KNqua
CFBG9wUAfN2bk0uwCm0oYtwJaK0U1LdmL8jRQPL8R65f5bfKZZt9F++p4sT52sYf
tukmPizTf5FxttbngoH2h5DIYsRMatV8+EOn/EBH55PALEdy/3goRCOw0QT7BXlj
PjMgggtTNSBnb5pkX0m2Aiau9w8m+yABR9zlMFP1ILZiXQdhY3ivjaIdimXP7z4X
kLEibmAHWy9aIVj8s0ffpPpQzrcbKRL9/4GrkHNfTbGW3TNkliebkl8TeuhWiIUw
88xl/ycFPn3751zsAz5R4bh9aaeeFhNIMbYLLFu1BfSD3CnL5Xp5NDThHdQI31uy
V2GizVPcN7Z7tnmDy+yQTU59igUdS3BZqUMr9NOHj8kQ8OpW79muBdvxx3Lmjwk+
7Hos8+u+kZC6fNUpdkvpzojVs2sPnfaEbRgtJ6HHzad9UQTOr12T1kuDMRND5k4F
DAvzgaFPJsJ86oFSVWuB
=zYT/
-----END PGP SIGNATURE-----

--=-xn+9GafHWcqv7wqVsRU7--

