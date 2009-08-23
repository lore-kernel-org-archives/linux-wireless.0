Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbZHWJLX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Aug 2009 05:11:23 -0400
Subject: Re: [PATCH] Implementation of the IEEE80211_RADIOTAP_RATE option
From: Johannes Berg <johannes@sipsolutions.net>
To: Rafael Laufer <rlaufer@CS.UCLA.EDU>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A906B4C.6010208@cs.ucla.edu>
References: <4A8DED03.2050502@cs.ucla.edu>
	 <1250842695.13872.5.camel@johannes.local>
	 <69e28c910908210630m47eda1eegcd502c212736decd@mail.gmail.com>
	 <4A8EE182.6040709@cs.ucla.edu> <1250927308.23605.6.camel@johannes.local>
	 <4A906B4C.6010208@cs.ucla.edu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-shQ4WTS/XeRTgstNuWQU"
Date: Sun, 23 Aug 2009 11:11:20 +0200
Message-Id: <1251018680.23605.29.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-shQ4WTS/XeRTgstNuWQU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-08-22 at 15:03 -0700, Rafael Laufer wrote:

> >> + * @IEEE80211_TX_CTL_RATE_RADIOTAP: completely internal to mac80211,
> >> + *	used to indicate that the rate was defined in the received radiota=
p
> >> + *	header and therefore the rate control algorithm should not change =
it.
> >>    =20
> >
> > This should be an internal flag, the driver doesn't care.
> >  =20
>=20
> right, and where are those set?

It's just a naming thing really. Look at the other flags.

> >> +		/* Get the rate parameter from the radiotap header,=20
> >> +		 * allowing rate selection on a per-packet basis=20
> >> +		 */
> >>    =20
> >
> > coding style
> >  =20
>=20
> I am a newbie, I am gonna look into the coding style, but I assume you=20
> are talking about the missing blank line in the beginning

What Kalle said. Sorry to be a bit terse at times.

> This is a good point and now I see that G=C3=A1bor pointed this out as we=
ll.=20
> There are other fields in the radiotap header that define the RTS and=20
> DATA retries. However, if those fields are not set, there must be a=20
> default value in this case. Are there any?

Well there's the short and long retry counts, that could be used I
guess. It would make some sense to do that. And the RTS/CTS-to-self
determination should probably be made by the network in absence of
explicit configuration, but the tx_h_rate_ctrl function should do that
already I think, even if you skip the rate control algorithm. Same with
short preamble or not. If you want to support only the rate, I suspect
that leaving the flags and setting just the rate index/count will be
sufficient. Unfortunately, you'll have to take a closer look at the code
to determine it.

johannes

--=-shQ4WTS/XeRTgstNuWQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKkQe0AAoJEODzc/N7+Qmao2IQAKO1WEc1hrEUv1lF/j+NvcRX
QKKlOKHR8hQ76aA0q7rjfRRl/6+/bFbCF3xeixQ4sKEeBnPxayu6y1kZhbCTllEc
u+j5cxwI0J4e6JBL/1FXvxhqMMnAaC+Opd5YqS3TVYY5yY/g1cAxfhZiPHitEXOq
s1PuirYKjVOoe093EZxRT2BRfS99RvjF3eomMdd1emPGjP4gaBqok2nqiA3Teqjb
ed5UMzQZIxWzSFCaow6efPhIxLGDw799lixIpSoYwWWHscCs5i3QalSuPZnTH2GV
kWLPie83b97hJRwG9ho7VYkadzaCqanjK0kQOf0x7WGxteJEeTS9Zenc16MSI4cR
0AIfU7qssub9B25XlaTZkDQDZ44FZcR5FxibwAI0UyG1kojdEoeMeHRl9TdmAz58
zfGFrYNxHhqXwIATk18t7Ha6ekizBirC07yEpu6RSWojfJTuMkpMJeUtot9i2jjF
NgSOMDshjoRf+uNyNW4EsiDFLNemdXvIYiY7RgOYNEAskABdPTnx30dzMEcKED8X
J52HLQbB+q4rqmvmifL+VwqRKohaIMyro7FOOblhIB4OIq+jCYZ1EQcBOaw95rE4
aXyrRXAboBauNEB9ofg5/VhyMrfbfiu7JP2c8gGZlhaJiwoBG7jZoMgh/xPYGCLh
exOacwCbTmHraJcu8Fm9
=NY/J
-----END PGP SIGNATURE-----

--=-shQ4WTS/XeRTgstNuWQU--

