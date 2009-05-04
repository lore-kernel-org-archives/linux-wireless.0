Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57501 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbZEDH4P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 03:56:15 -0400
Subject: Re: [PATCH] add basic support for parsing country information
 element
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241413787-3185-1-git-send-email-marcel@holtmann.org>
References: <1241413787-3185-1-git-send-email-marcel@holtmann.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Fa75UN5GhFcgyJgwgDQz"
Date: Mon, 04 May 2009 09:56:12 +0200
Message-Id: <1241423772.8683.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Fa75UN5GhFcgyJgwgDQz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-05-03 at 22:09 -0700, Marcel Holtmann wrote:
> ---
>  scan.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>=20
> diff --git a/scan.c b/scan.c
> index 2976115..c503487 100644
> --- a/scan.c
> +++ b/scan.c
> @@ -91,6 +91,16 @@ static void print_ign(unsigned char type, unsigned cha=
r len, unsigned char *data
>  	/* ignore for now, not too useful */
>  }
> =20
> +static void print_country(unsigned char type, unsigned char len, unsigne=
d char *data)
> +{
> +	int i;
> +
> +	printf("\tCountry: %.*s data:", 3, data);

IIRC the third characters there is a space if it's in- and outdoor, it
might make sense to parse it instead of just printing it?

johannes

--=-Fa75UN5GhFcgyJgwgDQz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/p+aAAoJEKVg1VMiehFYNQIP/A3maLN5yzqBbh84UO+40jXk
zIuRYwyUvBONvkTUpZyGvzHl5y+sp3GQZdSD4Ti6uCBVAUNtYjSMxxVFn/124Qct
nWCOqIMqG5kd/cX0KDHF6RWmD7V2wJwxWzsaXL1ziJH5cp0Mg27T0mRS5Ml+YCK5
LEf5zsUqqYO0yG+CpAYNaCYs7C1Lxo+prM19USSWMMKBNf4Oxl7CwX4GXzc9pvLT
okCNfbsFLXOgZWsK26fs9/76AAGp4VSxJRPK6C75kSx/uzgOCMscaMUB7Og3nCWw
EBdHZsvAasJicODAOI9Lx/aQ1UiBmOmKiMx2ISywxJOGpvIPlI95hjg2mBmwG4Pn
Q9jqX2Rr/n38krnkASgYFQ65GPbVUfwZDGjzd1b9gPYnUWlvIadfaVps07BEzQ2l
sXOR2s7w6Fbww7JkTAM+QSe+6dxgV4PQffE9QE84qKY0NK02rqMwgWT7wqL2fnr4
WTHk7Vl1jGhdZof5x5dygTvMITXYPSoilb/RGOJsRsq1XORqNLIuooa1GBOfH87F
sl6fJDEZfMnryjEKNnY41QPWd75xFs2YIBCMGIYy/S6AEbchDCLh2241uYcNTBSQ
cLehkjsMxT5/sA1gjf7OoKZ4pZd8iXXUthOuZZZ55+zu30sKIq+mYFlePIpUkXMb
D1ODz7LyA0nzeo57YBUT
=3POs
-----END PGP SIGNATURE-----

--=-Fa75UN5GhFcgyJgwgDQz--

