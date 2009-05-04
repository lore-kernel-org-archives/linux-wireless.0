Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55526 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZEDHeu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 03:34:50 -0400
Subject: Re: [PATCH] add support for parsing WPA and RSN/WPA2 information
 elements
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241412381-2778-1-git-send-email-marcel@holtmann.org>
References: <1241412381-2778-1-git-send-email-marcel@holtmann.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SZk9g09DVXcE5yCgyNsF"
Date: Mon, 04 May 2009 09:34:47 +0200
Message-Id: <1241422487.6866.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SZk9g09DVXcE5yCgyNsF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-05-03 at 21:46 -0700, Marcel Holtmann wrote:
> =20
> +static unsigned char vendor_oui[3] =3D { 0x00, 0x50, 0xf2 };
> +static unsigned char cipher_oui[3] =3D { 0x00, 0x0f, 0xac };

??
00-50-f2 is "WiFi OUI" (registered to Microsoft), 00-0f-ac is "802.11
OUI", registered to 802.11.

> +static void print_cipher(const unsigned char *oui, unsigned char *data)
> +{

Why are you passing in the OUI?

> +	if (memcmp(data, oui, 3) =3D=3D 0) {
> +		switch (data[3]) {
> +		case 0x00:
> +			printf("Use group cipher suite");
> +			break;
> +		case 0x01:
> +			printf("WEP-40");
> +			break;
> +		case 0x02:
> +			printf("TKIP");
> +			break;
> +		case 0x04:
> +			printf("CCMP");
> +			break;
> +		case 0x05:
> +			printf("WEP-104");
> +			break;
> +		default:
> +			printf("Reserved (%.02x)", data[3]);
> +			break;
> +		}
> +	} else if (memcmp(data, vendor_oui, 3) =3D=3D 0)
> +		printf("Vendor specific (%.02x)", data[3]);
> +	else
> +		printf("Other");

That's wrong, if it matches the "vendor_oui" which you should rename to
"oui_wifi" or something then it's not "Vendor specific", then it's from
WiFi, if it doesn't match then you could print out the OUI of the vendor
it belongs to.

> +static void print_auth(const unsigned char *oui, unsigned char *data)

same here

> +static void print_wpa(const char *ie, const unsigned char *oui,
> +		      unsigned char len, unsigned char *data)

again, no need to pass in the OUI.

> +	bool first =3D true;
> +	__u16 version, count, capa;
> +	int i;
> +
> +	printf("\t%s:", ie);
> +
> +	if (len < 2) {
> +		printf(" <too short> data:");
> +		for(i =3D 0; i < len; i++)
> +			printf(" %.02x", data[i]);
> +		printf("\n");
> +		return;
> +	}
> +
> +	version =3D data[0] + (data[1] << 8);
> +	tab_on_first(&first);
> +	printf("\t * Version: %d\n", version);
> +
> +	data +=3D 2;
> +	len -=3D 2;
> +
> +	if (len < 4) {
> +		tab_on_first(&first);
> +		printf("\t * Group cipher: TKIP\n");
> +		printf("\t * Pairwise ciphers: TKIP\n");
> +		return;
> +	}

Huh? I don't quite understand this? Is that some backward compat code?
Or is this some WPA1 thing I don't know about?

> +static void print_rsn(unsigned char type, unsigned char len, unsigned ch=
ar *data)
> +{
> +	print_wpa("WPA2", cipher_oui, len, data);
> +}

That's "oui_80211" I guess, not "cipher_oui". Ok I see now why you want
to pass in the OUI... However, it would be better to just duplicate the
code, I think for example 11w won't be announced in WPA1 IEs so we
shouldn't parse it there when we add support for parsing it to RSN IEs.

johannes


--=-SZk9g09DVXcE5yCgyNsF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/pqUAAoJEKVg1VMiehFYnWEQAJjaJ7SnfdRR/2RihqkBGSXS
EhPY6znpPDAqxrm05MJubKBZG85jAB4PcGsjVRop3lorQUm+ShPkAUhS+151eXal
XKX9BhJagYwT75qTlG/foAfrgsYa3GDCpUA+5cw8hLjrSd/eBqOm/Pj8xYC+E03S
Z4ZEtwxDzXEXsb9fHjyWeJHA6Ab6GInEG1x8jpR2aSLl1SXX5fX8oktM34AYshHV
Jh67EO2Mcrix5VZStms48ZQqickfDPVKuB2nXtlj6PYV6X/6UYB2rgeZNGeBveRP
1AcDD44avk8xDvnjt8Z6729o2bltZx2VoR9bbqc6B6ttnktawFI2vrcwWS2IruM0
MYZ9jLlGIejyEQgViYuQAeLdTCGjYiCWPY7GNCA/UbyG8Q45QcHArkAr8QWZqiUr
fvc/LjaPEHN1gy2OLhsD/nEoXQzydLu7TCsphQsoV4jJOJNVjQRrbBj716s6vrD9
5XSDT5SMaJLKA17SGX3kfK6NTj0cJ51cCAItO3HsBok5KmqzqZ387cyMNSQJF0YH
L/M55fKz3hGdJ57SIiBnQsz3zdSUjNAfp+ntVkWZwORjeiKFjzbdUfG2gjCCP9Fh
FR+fXSniwj9S1VpGoELlvYRvlNNc7xAbgJwvmGYakiylXF2bnpzP/5rOVZt3J3Te
xqDdtNqXeICfgofEYXEU
=CaA2
-----END PGP SIGNATURE-----

--=-SZk9g09DVXcE5yCgyNsF--

