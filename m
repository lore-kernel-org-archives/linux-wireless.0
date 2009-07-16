Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42265 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZGPImW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 04:42:22 -0400
Subject: Re: [PATCH v3] cfg80211: rework key operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1247713627.3695.60.camel@debian>
References: <1247051586.4755.81.camel@johannes.local>
	 <1247052613.12857.0.camel@johannes.local>
	 <1247055774.24749.0.camel@johannes.local> <1247647086.3695.48.camel@debian>
	 <1247650666.14973.0.camel@johannes.local>
	 <1247669030.10754.1.camel@johannes.local> <1247713627.3695.60.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Nn55YC+mEFnp9oKlHbTs"
Date: Thu, 16 Jul 2009 10:41:40 +0200
Message-Id: <1247733700.10754.105.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Nn55YC+mEFnp9oKlHbTs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 11:07 +0800, Zhu Yi wrote:

> > As discussed with Samuel, there's a possibility to pass _all_ WEP keys
> > directly to connect(), if desirable, instead of adding them with the
> > key hooks later.
>=20
> I think this should be the right way to go. Currently we have no way to
> connect to WEP APs (both open and shared) with iwconfig. Because the
> driver needs to set the correct cipher before connect. But the key
> callbacks are only called after connected... IWAUTH is expected to be
> the place to set the cipher here, but unfortunately iwconfig doesn't use
> it. Passing the WEP keys to connect() can solve this issue. The driver
> can at least parsing the connect parameters to set the correct cipher
> before connect.

We could also check the keys and pass the right cipher from cfg80211, in
this case. Should be easy.

johannes

--=-Nn55YC+mEFnp9oKlHbTs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXue7AAoJEODzc/N7+Qma+UoP/A7Y+NXsJfhuxfA4cb3urn3u
QyQSl/Z0dzFfJVeCWiDwtrNjZE6H4tWt77ac9OIDpWMs56zOcfQFrcKEKXlxjIWP
gXYyB3kGA5cCdHU9AbZyggtTm/OezQCRvXtVU2V8zr+QHawqZc/wLAEa1IXABLbE
VEcDvSxcYyk3tKw5PVew0+8H+zcZsd+i/Sg0LLqmLM7gxCLmHDz+tPGUEE3/UIU9
3xge5Qr8qlF2Ru7RRiQcflnBxRPdeBcaKTycMXbl86YZechBlR6XOP47nQx1z49Y
LOpKyO8ykbpY+oFuD2Cp6NON7hvTt4CLsaFK8XCx++3BXAVISzvOE9eyVpWtJNKs
R0NlWzyA34g9JXRb8a1KjA7PBs+rMYTMQiBbSIZrxhSJ8BH0obQ7nENLtJkvowM2
gWaEic9zXwOQfOGWBGdjdP6Lr2B4VuMYw0P+1djGouz+IQE7/9fGcsXYnEFHAhfS
7ItmNlRls9enl94Z73djKyrxzU3QsDiLzN+EZF128z9k5SarjU0j6Nq0A17dAai0
ElJTs85I9fAR5p78AkYfaFEMOwjSBhVlm2JFp8GH08edMRYjKVRqNGUmqDi/dACD
cWUOD/i/sGr/CvtXV9nFCJBg3U81PRMoyGSpc2+gMtlxCbS0WHwYls2LsTFQgOPk
ZUcyg1opa74n6scv9lUZ
=WMef
-----END PGP SIGNATURE-----

--=-Nn55YC+mEFnp9oKlHbTs--

