Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbZFBNyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 09:54:23 -0400
Subject: Re: [PATCH] nl80211: use GFP_ATOMIC for michael mic failure message
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20090602131222.GA30509@tuxdriver.com>
References: <20090602040503.GA5385@hash.localnet>
	 <20090602131222.GA30509@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-B+3PwYSa3t+Yv4lI2lfO"
Date: Tue, 02 Jun 2009 15:54:17 +0200
Message-Id: <1243950857.4516.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-B+3PwYSa3t+Yv4lI2lfO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-02 at 09:12 -0400, John W. Linville wrote:
> On Tue, Jun 02, 2009 at 12:05:04AM -0400, Bob Copeland wrote:
> > nl80211_michael_mic_failure can be called in atomic context but
> > does a GFP_KERNEL allocation.  Fixes the error below:
>=20
> This is not the first one of these.  Anyone care to audit nl80211.c for o=
thers?

We should just make them all take a gfp_t argument and use that instead
so the caller gets to specify it... Anyone want to do that?

johannes

--=-B+3PwYSa3t+Yv4lI2lfO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJS8FAAoJEODzc/N7+QmasZIQAJBlVFmAjXLPtC+TSFlk6zbC
M8Z00beFYa6yRJuTUp5Nq6IuTthF6H+2NT2zLkCJKhwuegUy448lSdEYR0rnZvzo
0RZXUlboWmt8u2qrWzpYgvxCFVkkYHBxQX/uNMt9oHRGR4lx5r9rA1g1TNnbq43y
dlBechm2FbUvVzySIxmlRLtxoi1681PA1yKuhEiXtr7+U/B1mNYIYIhqKlZVpabE
5Jwnjk0UCm535OaTUbPaZVaMmO0v+us/L4wioK2qHuA8rgxFoGjsxP2TrjWxogWT
kXNWAuiSa61/5MqEF/OE54mSm+3IFZXTs1ChD9aVNLargv7ZkdfRiMIYC1/pCDyp
qeoYDHSqVvm25Vng/yV+vXKbZxVryc5gPg2O+Mu2NS9dltnlMIR2a064adhOugHP
lHFrMYdp/ugZkz+cQbvjMcyBdPkJNpXjpdDrIrVLp89FkBkw6ZVG6FRwXeDQIY4J
Pumr8Pi54FcZbTzmlckxD2t5fZ00TPsyyDUHLkoIHqqToAnzaJLNYiqJXrHodrRR
hAcwcgkAuCaqr5saItiJKD8Uh91dBEA6tP6ixGvOxLOYl9czNi8yeA4AZVbvjYDa
xBvOphLYlrwzWHtFYOeT5ScmSrurumXIGePOtuvrmHzmEYvoNClibp1VqqmMIXZa
kAJDy5i7lupWYiFWYB2/
=ZLiN
-----END PGP SIGNATURE-----

--=-B+3PwYSa3t+Yv4lI2lfO--

