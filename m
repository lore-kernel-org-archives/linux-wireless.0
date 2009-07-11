Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZGKRtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2009 13:49:24 -0400
Subject: Re: [PATCH v2] mac80211: cancel/restart all timers across
 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <m2hbxjky1q.fsf@igel.home>
References: <1242391067.5799.53.camel@johannes.local>
	 <1242553242.10005.76.camel@johannes.local>  <m2hbxjky1q.fsf@igel.home>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SMNl61tGZtX0i8JKFtMD"
Date: Sat, 11 Jul 2009 19:49:22 +0200
Message-Id: <1247334562.30647.111.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SMNl61tGZtX0i8JKFtMD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-11 at 18:02 +0200, Andreas Schwab wrote:
>=20
> Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org> writes:
>=20
> > We forgot to cancel all timers in mac80211 when suspending.
> > In particular we forgot to deal with some things that can
> > cause hardware reconfiguration -- while it is down.
>=20
> This is breaking suspend on my iBook.

Yeah, bug 13337, we've figured out why too, I need two or three days to
figure out whether it's race-free, but the fix at
http://mid.gmane.org/8763dznnki.fsf@scholz.fias.uni-frankfurt.de works.

johannes

--=-SMNl61tGZtX0i8JKFtMD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKWNCeAAoJEODzc/N7+Qmap9gP/A5n9R+uq7OqZchthMEFern2
DNfE3fygN8RfW6bts6ucKzfaFHCMVbYNHMn8JwjOtihxoAupMV4easfP1ryc6zoP
3Dzm+PBSSw8VVl/HADkG4ieW4Lquu81YhzxCVPTKUyE4oX1U/y10ARtQ9smwRVTk
doWh/bTgjkOdFF+zg5gL1bjayOG8PeKuoS4MgYVhDopVg0WjUU+xiBeCYqQYdj+R
BXJlSgRDr51RCqxOHkRq8zN7S5Qc5FTRcZvxbYd4F0MRMi+35Uuehq7vu5Le6Tz8
Cq0NXySrE4A7e7/vsjwoD0k07E7GqttP3zshvsff6Y5+obg6T36h2D3oQnZLxY7z
5k3MlKYfREV3qkQhaC686lGdBQXgME9uIyoBN3BHrYZw+mvp/jYNof5TT2CcGfTF
l9wNPcaAQ1bukTyIaZX5iRu5aV0rdu/GEVUBL46m8sewleJvrRmH6/AgM31O8jWt
zRNNJQNCm1uPYqbHCeed+9mTpJFrZ1PNWXmTWXKMiqeoCRcB9ohgk4O8xAERFvFc
7vYCMg6KV49uVJq8bco1a5izRK33v6Ze3yDvz5vlWyzrG/bLoV72uaNyUj4o8JYZ
5KI+efbCXpulugaET8gHQ/Bm3Uy0M53CAIO/4MXNHWDNm8u652i0Bnp++1K9i5g3
Bu+v8WFq7jmg/dyztEKx
=P4yl
-----END PGP SIGNATURE-----

--=-SMNl61tGZtX0i8JKFtMD--

