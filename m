Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:40765 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab3AGLlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 06:41:49 -0500
Date: Mon, 7 Jan 2013 12:40:48 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: Antonio Quartulli <antonio@open-mesh.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Will Hawkins <hawkinsw@opentechinstitute.org>
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH response
Message-ID: <20130107114048.GH27589@ritirata.org> (sfid-20130107_124153_837690_74FBF140)
References: <1355146824-25012-1-git-send-email-antonio@open-mesh.com>
 <1355146824-25012-2-git-send-email-antonio@open-mesh.com>
 <1356706268.9922.23.camel@jlt4.sipsolutions.net>
 <20130102063255.GA27676@open-mesh.com>
 <50E400A7.5060100@lri.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0z5c7mBtSy1wdr4F"
In-Reply-To: <50E400A7.5060100@lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--0z5c7mBtSy1wdr4F
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 02, 2013 at 10:40:55AM +0100, Nicolas Cavallari wrote:
> On 02/01/2013 07:32, Antonio Quartulli wrote:
> > Hi Johannes,
> >=20
> > On Fri, Dec 28, 2012 at 03:51:08 +0100, Johannes Berg wrote:
> >> Anyway this part is really confusing. If userspace is handling auth
> >> frames, should the kernel really mark the station as authenticated? Wh=
at
> >> then is the point in handling auth frames in userspace??
>=20
> In IBSS mode, the "auth" state is essentially a no-op with the current co=
de, just saying.
>=20
> I do open system authentication in userspace, partly to fix these race co=
nditions in a
> clean way, and to have more control over it in a more convenient way. Tha=
t way, it is
> possible to hack things like retrying authentication at the user will if =
it failed the
> first time.
> I can also handle stations that do not answer auth frames much easier, su=
ch as skipping
> open system authentication if the other station engage actually tries to =
authenticate with us.
>=20
> >> Any chance we could converge on a single implementation here?
> >>
> >=20
> > Maybe yes :)
> >=20
> > I think that leaving the station not AUTHenticated and let userspace do=
 so would
> > be the best approach..but then we need a way to enable userspace to do =
it :)
>=20
> What would happen to old userspace that expect that to be done in the ker=
nel ?

if the userspace did not register for auth frames, then authentication will=
 be
handled in the kernel (as I'm doing/changing now), while if the userspace
registered for such frames, then the kernel will assume that the authentica=
tion
will be handled by the userspace somehow and will not deal with it (but aga=
in,
in this way we need a command to let userspace set the AUTHenticated flag o=
n a
station).

Cheers,


> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--0z5c7mBtSy1wdr4F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ6rQ/AAoJEADl0hg6qKeOwzsQAKJcJyjC8X7+GJSGFDSC758z
OCKS/sbtZbF8RmYfCMggMiJF+Fmj2O/28+VeYCPZAsEwA0Guiur0I5INJdCewete
4b/4dlgmMVdt5Se9bI8lWW8d+Nd6KXlccJo2W9WQTKzZGZNMfo0xUk49UY3NQEZf
7ggcyrrCxPQyquBuMfdbd3AuMv9ZlQFekDFtJcc7F9LbAtSRKMRUaRP21mUWaHzZ
M8DP4usnzM1uo4fbk8pAxd8wu+HUEH4Brd0eNjMqMbMXGq09o5X5EJwWzlstDp7X
P8+iNZWF2/TNa7Wh6QXD/1E4ifYLuWtJerchRX634N5vxvLbA+VqzMnEhjJTmQMs
GyI2LdTriVlGwxRF5EyRMNd0POOjTtAyZX5RVjX9uYQyOLDtmITzWccpKyG8uuM9
2tVf/usRc3p+OI9iB4mHAqzSpOI/pmpnge3PQdMFY42DzEBmgHPGKdFlXXCvHX2r
sy8t9eup5kzmx0CCotNQ+4ABqqV9FjSjAajK1l7aMAOFEKxDAr6qGIzTi+O0jhN+
DPvWxECqe+hLR0RVWvOfY1pVpssnP96lUjPST4lQP1RHS+woZntwlbhTgZRcISVp
UTvQMtD7j5YUcJK8iU85hQX/lPnlutkPqkuTZGCESyPnsfwaXPf7AJBNz+TbpOoc
vPeGYLGJsjDU1e4mGQJY
=tFV9
-----END PGP SIGNATURE-----

--0z5c7mBtSy1wdr4F--
