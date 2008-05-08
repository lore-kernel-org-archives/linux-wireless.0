Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbYEHI6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 04:58:05 -0400
Subject: Re: [PATCH/RFC] mac80211: fix association with some APs
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <hschaa@suse.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200805081030.57966.hschaa@suse.de>
References: <200805081030.57966.hschaa@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WVAU56cg1OdG1CULZLnv"
Date: Thu, 08 May 2008 10:57:13 +0200
Message-Id: <1210237033.3547.30.camel@johannes.berg> (sfid-20080508_105706_388560_47FB1BE4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WVAU56cg1OdG1CULZLnv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-08 at 10:30 +0200, Helmut Schaa wrote:
> Some APs refuse association if the supported rates contained in the assoc=
iation
> request do not match its own supported rates. This patch introduces a new
> function which builds the intersection between the AP's supported rates a=
nd the
> client's supported rates to work around such problems. The same approach =
is
> already used in ipw2200 for example.

Clearly, somebody didn't read the spec. *sigh*

Quote:

10.3.3.1.2, parameter table (emphasis mine):

OperationalRateSet

The set of data rates that the STA desires
to use for communication within the BSS.
The STA must be able to receive at each
of the data rates listed in the set. This set
                                     ^^^^^^^^
is a superset of the rates contained in the
^^^^^^^^^^^^^^^^^^^^^^^^^^
BSSBasicRateSet parameter.



> =20
> +	rates_len =3D ieee80211_compatible_rates(bss, sband, &rates);
> +	supp_rates_len =3D rates_len;
> +	if (supp_rates_len > 8)
> +		supp_rates_len =3D 8;

Please add a comment here why we do this, preferably including at least
one broken AP (so we can blame somebody ;) )

> +	if (count =3D=3D 8)
> +	{

and fix this tiny coding style problem please.

johannes

--=-WVAU56cg1OdG1CULZLnv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCLAZ6Vg1VMiehFYAQLlCQ/+Po+JgKd4uqjwMehKNKIymdXXWR68UjV7
h1UTjuIMqBQab4VWwEE2AFaPUTOFDC+Bce6dKaKx1fNjFWXRk8gMcdWVb5i9nAbv
5FXFbPgnFGBHWjUGxcNGyKuX2TpWGR2istO+IWMsslIr3iwp511/EypGAzHK3pXA
POMmgv6XQbj4nlkTs0s3/N7+65MujGZiK3Yl4KxDtMeUnBRdoHU0Z5ESqoMESJGj
aaQqlzTDGh4WJUXqxeHtsCF9a4a6SmXhAziC9hKeOszyJ4ejSoccOhpVTjhWKZ6h
82wWZezHLM1x5apeVkbEyGI5RbrxdewKEGfQ7tC9SP4sVZ4L9Fbhpb4jpgJz8bZq
gECT7bwHkIppSmcZ1DWHNXV4TFum32bFPVemig4+G33dHG02D1tnhD28t2RfN5O9
zOQfwuvmtdKmQF0TgFlDC5w/OazPNHOkW5cr9jW8HMsfTUa6apUlwVt0BCorWd/J
HIjW3ap92/LIMS7naEJKbn5lgj/jRFmYQV9nnIOSWbdrxvFzyPufI3zKO1EWojXr
8b6Q9V2WKH2Q+ufBXMWkGtUeVcgv09zcK3bbi7pPfEgTVWb9JKYghXFxf+hirX7M
pytDjh4sCKyVoAiWMWLNU8qbLD3+LCvpuc7W4jwVLGmnQ7bOoO2F+aMNK/OXnG0s
9ySvEVTlWKQ=
=D8eW
-----END PGP SIGNATURE-----

--=-WVAU56cg1OdG1CULZLnv--

