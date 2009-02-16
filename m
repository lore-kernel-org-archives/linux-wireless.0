Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43746 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbZBPIwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 03:52:31 -0500
Subject: Re: [PATCH 06/10] cfg80211: propagate -ENOMEM during
	regulatory_init()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Greg KH <greg@kroah.com>
In-Reply-To: <43e72e890902160018r40d8c694qa1da55c9fa7ec376@mail.gmail.com> (sfid-20090216_091915_110909_54CB4C2A)
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-7-git-send-email-lrodriguez@atheros.com>
	 <1234695674.4219.50.camel@johannes.local>
	 <43e72e890902160018r40d8c694qa1da55c9fa7ec376@mail.gmail.com>
	 (sfid-20090216_091915_110909_54CB4C2A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zO6zePBcYbKgqkcPfzcJ"
Date: Mon, 16 Feb 2009 09:52:25 +0100
Message-Id: <1234774345.4219.106.camel@johannes.local> (sfid-20090216_095235_146817_E76C4DD3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zO6zePBcYbKgqkcPfzcJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-16 at 00:18 -0800, Luis R. Rodriguez wrote:

> > I disagree with this patch -- there's so much that can go wrong even if
> > allocating the message here is ok that imho it's hardly useful to check
> > for errors here.
>=20
> Huh?? ENOMEM is the only error we are propagating  -- that itself
> seems reasonable to propagate.
>=20
> > crda could fail, not be installed, etc.
>=20
> This is never propagated to the kernel, that is not what this patch
> does. Those failures you mentioned should not prevent cfg80211 from
> moving on.
>=20
> All this patch does is propagate -ENOMEMs.

Yes, all those other possible crda failures do not prevent cfg80211 from
moving on. But being unable to create a uevent could very well also be
treated as a crda failure, and then how is it different from crda
failing in userspace to warrant stopping cfg80211 from moving on?

johannes

--=-zO6zePBcYbKgqkcPfzcJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmSlGAAoJEKVg1VMiehFY8LEP/3LPqSas6qY9EEo9MPwmNYKh
R7THWkOgz36OhNjXH6cFNb/1enbe9Sr6CQYcni74VDsKNhZQ5xNy6VOxaAN21dG/
HJpmG8VoIvhBLO0AzzyHzwkbK5jHsaqbzSaj4cbB3LkcxD6j0fAFmUxQUp8KkRQI
ay9TGn6TszoIHFtD9dm02zlu75ORirqKsYJqUlwE+qrj4qu4WoXHn7jw0W3dZSGc
nHI4gsOlwUCPlqN9LTv1YQKh7v2NwN8FAhSK+suwjeLX8Y+MLnz0KHBBB2FoNjX3
jmRZThvol2AEAmwyaI+agrLYBkc7gV9xVCet2WZWAEoSzCDVyO5q5rT0s52zQDRF
yle9BVTsQI83/iGlPKcLNZYzpsVoY45W+LTnUUt8gqvHjQsy5pUw4Q0tbFKXjF9Q
Vs1VjyAz2CQgUN3ZYML1ggiyZOr8jw57pmldG49VV6c2mbE11eS2RQKBKxzUUV4V
n5Tu/dSR7uWyD3In6ZLIyEh/X4Ff9p/xnbcShdSvqNQL9j4dYPqM/79UgCfZYOQK
NpjUzuZRPYgePSDceMjl2J72aABjovuetqZb/JDg9WHcdD2h+ZDYqMlEoHLdWVxv
s9FdTUOxwyL3gVXIF0IxUxZJyfRCNH1z9vrAOzBHiM09Di5jyCRtTqIs+jc1MF5N
AMFZCaz5QRQRgjSgHhLx
=T4CW
-----END PGP SIGNATURE-----

--=-zO6zePBcYbKgqkcPfzcJ--

