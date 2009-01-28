Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40265 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZA1Nib (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 08:38:31 -0500
Subject: Re: [RFC PATCH v2 2/2] mac80211: use ps-poll when dynamic power
	save  mode is disabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, vivek.natraj@gmail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240901280526m199cb01dwc5fa62a50edca853@mail.gmail.com> (sfid-20090128_142650_285609_1DE7EF72)
References: <20090122114240.31443.18218.stgit@tikku>
	 <20090122114546.31443.79387.stgit@tikku>
	 <1ba2fa240901231528m21f13c1m43721f1d673e7cc7@mail.gmail.com>
	 <874ozj964m.fsf@litku.valot.fi>
	 <1ba2fa240901280346v6b4000b9m74eef26aabf86419@mail.gmail.com>
	 <1233147624.4071.1.camel@johannes.local>
	 <1ba2fa240901280526m199cb01dwc5fa62a50edca853@mail.gmail.com>
	 (sfid-20090128_142650_285609_1DE7EF72)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XcWGNcMj+IsDVlXtY0zG"
Date: Wed, 28 Jan 2009 14:36:41 +0100
Message-Id: <1233149801.4071.12.camel@johannes.local> (sfid-20090128_143835_894356_98AC9364)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XcWGNcMj+IsDVlXtY0zG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-28 at 15:26 +0200, Tomas Winkler wrote:

> > I **completely** disagree on this. The non-unit index is a **horrible**
> > thing because it says **nothing** of interest to the user. The only
> > approach the user can then take is try which value will give him the
> > desired behaviour, and it will differ across all hardware combinations.
> > Therefore, it's completely _useless_.
>=20
> What I suggest is to have rich configuration for setting different
> parameters so this is more flexible with different HW but in run time
> only play with single number to create uniform interface for user
> space.

Which is completely pointless, as I'm saying, because the user has no
idea what to base the decision on. This might be nice for a developer to
play with this, but for a user it's completely useless because they
cannot base the decision on any information.

Basically, you're saying: Let us vary the blackbox parameters for you,
and we'll give you a 0-5 scale on which to select. Except that the user
has no idea what 0-5 mean in terms of what he's trying to do.

That just means we'll end up with howtos like this:
"If you have Intel hardware, and want to use VOIP, then you need to do
iwconfig wlan0 power index 2, because otherwise the latency is
unacceptable (if you have bad hearing 3 might be acceptable); if you're
just running ICQ then 5 is fine."

Can you see what I'm trying to say?

> I'm not sure that you want to user jungle with all the numbers, we run
> empirical tests for very long time how do you want to user space take
> the decision.

No, we definitely do NOT want userspace to juggle any of the numbers.
But that's completely orthogonal. We want userspace to tell us what it
needs, and adjust all the possible parameters based on that. We
definitely do not want userspace to give us an arbitrary number it
obtained by rolling a dice.

> > What we really need to do is tie into the pm_qos framework and make
> > latency guarantees.
>=20
> Even pm_qos doesn't talk directly in language of all  PM paramters you
> need to configure so this is just equivalent to my proposition and can
> be staged after the legacy PM is implemented. Also PM doesn't map only
> to traffic requirements.

No, you're thinking too technical if you say this is equivalent to your
proposition. Yes, it is similar in that userspace gives us one or two
values and we select a number of parameters based on these values. But
it is _completely_ different in that userspace actually has a good idea
what the parameters it can tell us _do_. Unlike an arbitrary power index
it can only select by rolling a dice and hoping it'll work.

johannes

--=-XcWGNcMj+IsDVlXtY0zG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgF9nAAoJEKVg1VMiehFYKgoQALPmWJDSJB4XjA3NLYEWNr3J
FfxlK2Vj71qswOrYt2pgjF0DccsAR4GgsOzwEH95wXhvA1PKW1H6Ab3B2K86BHVv
oOe4oESg17Wp0lu0EsYfENoJFW2F4QjTE7ReBAyudhcyV0712Rv0qOGQcFLk6/i+
rXKzi8yk81YY1XN4FJviL8Q7Cp9e7tA2ngvd/OJ9fkCxP5OxBx4bS/fVdNRoiMu5
cRwwvckenb7IZcX6ISGMjN3kz5ZXm5R9Gl6q5vx/B8ZNkIDWpO7hHRdY2m2edzIY
Py4wvcDt/bUzaN04b9BEMepYrSFsIdaOUXHJoOSaQDJXysTFWwJz09QZrOwdNwC1
H8puN1i/6rOJDD5wpzk8/Ym2fvaw5Hvvo+kOQsxN50CDxzyBkLb8tFBWjg3RIXKI
EaFLJWHBqs/QqcKdaJEf7WjC5V7l0XdwKzi6Nl79MSzR2jM1PrPmuj1j4naOB+5g
oItpw8VD+1X/3990n7GAcs9G7rQX7qYRHZZBjbJ1taF1seInmgop3pVloCamPOsx
IbtQ+TVFy+nGviVlnLGRdfhU3aKyYZdDQmH7Z4hub9kArygHVnLmLHyaBlY9g42L
qvtNNIQx7p54X864//K50HJmDH0tX+3e+AFju+ThA3Y7os0J/noOuePLpFn2dLkd
vHjtwg52oehRE4G0lwhR
=2R7h
-----END PGP SIGNATURE-----

--=-XcWGNcMj+IsDVlXtY0zG--

