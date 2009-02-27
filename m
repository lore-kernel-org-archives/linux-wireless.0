Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40363 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbZB0Vxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 16:53:53 -0500
Subject: Re: IBSS issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <18855.49469.357603.258110@gargle.gargle.HOWL> (sfid-20090227_113639_436536_7D575971)
References: <18855.26210.618690.891378@gargle.gargle.HOWL>
	 <20090227082545.291220@gmx.net> <20090227090140.291190@gmx.net>
	 <18855.45396.45156.609477@gargle.gargle.HOWL>
	 <20090227101911.291200@gmx.net>
	 <18855.49469.357603.258110@gargle.gargle.HOWL>
	 (sfid-20090227_113639_436536_7D575971)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F6c3b2p+r4igGGoXha69"
Date: Fri, 27 Feb 2009 22:53:50 +0100
Message-Id: <1235771630.7426.93.camel@johannes.local> (sfid-20090227_225356_245781_64A4D666)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F6c3b2p+r4igGGoXha69
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-27 at 16:02 +0530, Sujith wrote:
> Alina Friedrichsen wrote:
> > Maybe because the scanning code was changed? But I have discovered this=
 bug
> > at the end of the last year before the scanning code was changed the la=
st time.
>=20
> Not sure, but this is a bug for sure.
>=20
> > > And it can be fixed by
> > > making use of the scan start/stop mac80211 callbacks.
> >=20
> > I think a much cleaner way would be if the ath9k_hw_write_associd() hon=
or the FIF_BCN_PRBRESP_PROMISC flag and determine with it if sc->curbssid s=
hould be set or ath_bcast_mac. So the the old sc->curbssid setting is saved=
. And then remove the following code...
> >=20
> > if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
> >         memcpy(sc->curbssid, ath_bcast_mac, ETH_ALEN);
> >         sc->curaid =3D 0;
> >=20
> > ...so that ath9k_hw_write_associd() is called if the FIF_BCN_PRBRESP_PR=
OMISC is cleared at the end of the scanning, too. So that it can set the BS=
SID in the hardware back to sc->curbssid.
> >=20
>=20
> Sure, either way works, since FIF_BCN_PRBRESP_PROMISC is set only during =
scanning
> anyway.

It can be set manually with monitor interface I think.

johannes

--=-F6c3b2p+r4igGGoXha69
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJqGDrAAoJEKVg1VMiehFYN9oP/is5GOyH9vaGjpUsJ7NWp/aW
lq28gHFagyenNJROnmbbB7fT48x6LTK3G8dkzaNNV0nOBncSqEUMvX5c5s3HdTEu
4JqTDZN+xqS9Xh/sHmWScR+0L+STia2H8RetNWWTevzxUux1PEVGDukm1mstO2Ev
5LLIIq0PVZj8ZaWAGbE9GGUsHt7Ni26Zx0mK0dnP1Wi38AcndMkZ84sfQr2S+7ro
M61EMct74r/NdODGJqmJrVAelzAEjKM0WCVGc5YkAMlmgX5LY6ePRLxEt3jE5OtY
ciQJZVhtHa05po9TZ7ObmW/FDxwhM6M03O9syxR8TaYARo5H1ohU18wJ7Gasbz5W
7V4z6fVwk7BP+7YEQ/i+ind5CHmhcZNwQVw3Xi9pXmLql6rYwYWle3ldHvG4DBOD
iz6fhFRZyQgoGT6gGakFSmS6mJZlhsmR7yK8r5aB5aRdWI3fdCNgsdEt9HnlBI3b
jmByF+8tE+L1BI1esY+zxHbVYS3V7HSiT1IbXt+UMFHBWLp5shm0eJx9WNjyJ89w
y9QQrTHZ1mBW81pbKNVKmuNiRPLvetSiKit7WL2YcNU/CSC7LNiGdDAoDcccg1Jb
39F+ous1LD4QlEbLzttfNZoyqZXgSD6ynNyMZLTEn0ClsMXQIyd04nj5JOBVxOzY
RIRQYANedOSpvT6ZGX94
=LiOl
-----END PGP SIGNATURE-----

--=-F6c3b2p+r4igGGoXha69--

