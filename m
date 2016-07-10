Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:61724 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbcGJJ3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2016 05:29:25 -0400
Subject: Re: [PATCH v4 3/3] ath9k: parse the device configuration from an OF
 node
To: =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
 <20160709232834.31654-1-martin.blumenstingl@googlemail.com>
 <20160709232834.31654-4-martin.blumenstingl@googlemail.com>
 <87inwe9wfb.fsf@miraculix.mork.no>
Cc: ath9k-devel@venema.h4ckr.net, devicetree@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	mcgrof@do-not-panic.com, galak@codeaurora.org,
	ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
	pawel.moll@arm.com, robh+dt@kernel.org, kvalo@codeaurora.org,
	chunkeey@googlemail.com, arend.vanspriel@broadcom.com,
	julian.calaby@gmail.com
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <57821536.3020000@rempel-privat.de> (sfid-20160710_112930_451916_D65FE8CB)
Date: Sun, 10 Jul 2016 11:28:22 +0200
MIME-Version: 1.0
In-Reply-To: <87inwe9wfb.fsf@miraculix.mork.no>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2G07aagLxm6TmdhJgFd3JVxrEk0FhicIL"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2G07aagLxm6TmdhJgFd3JVxrEk0FhicIL
Content-Type: multipart/mixed; boundary="Id1sqr1CI0Gfbo1lLbu8qAhs6d0UmrCV7"
From: Oleksij Rempel <linux@rempel-privat.de>
To: =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
 Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel@venema.h4ckr.net, devicetree@vger.kernel.org,
 linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
 mcgrof@do-not-panic.com, galak@codeaurora.org,
 ijc+devicetree@hellion.org.uk, mark.rutland@arm.com, pawel.moll@arm.com,
 robh+dt@kernel.org, kvalo@codeaurora.org, chunkeey@googlemail.com,
 arend.vanspriel@broadcom.com, julian.calaby@gmail.com
Message-ID: <57821536.3020000@rempel-privat.de>
Subject: Re: [PATCH v4 3/3] ath9k: parse the device configuration from an OF
 node
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
 <20160709232834.31654-1-martin.blumenstingl@googlemail.com>
 <20160709232834.31654-4-martin.blumenstingl@googlemail.com>
 <87inwe9wfb.fsf@miraculix.mork.no>
In-Reply-To: <87inwe9wfb.fsf@miraculix.mork.no>

--Id1sqr1CI0Gfbo1lLbu8qAhs6d0UmrCV7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 10.07.2016 um 02:19 schrieb Bj=C3=B8rn Mork:
> Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:
>=20
>> +	if (of_property_read_bool(np, "qca,clk-25mhz"))
>> +		ah->is_clk_25mhz =3D true;
>> +
>> +	if (of_property_read_bool(np, "qca,disable-2ghz"))
>> +		ah->disable_2ghz =3D true;
>> +
>> +	if (of_property_read_bool(np, "qca,disable-5ghz"))
>> +		ah->disable_5ghz =3D true;
>=20
> This is bike-shedding, but how about
>=20
> 	ah->is_clk_25mhz =3D of_property_read_bool(np, "qca,clk-25mhz");
> 	ah->disable_2ghz =3D of_property_read_bool(np, "qca,disable-2ghz");
> 	ah->disable_5ghz =3D of_property_read_bool(np, "qca,disable-5ghz");
>=20
> instead?

Hm... i assume each WiFi hw in the world can reuse this settings, may be
it i worth to use generic names?

--=20
Regards,
Oleksij


--Id1sqr1CI0Gfbo1lLbu8qAhs6d0UmrCV7--

--2G07aagLxm6TmdhJgFd3JVxrEk0FhicIL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAleCFUYACgkQHwImuRkmbWkbfQD/QmWNTeL6XkKEncYbzGKQijUk
Yuv3MxQ2qc5oFBiTMpYA/038A3ay4mfifoGXoi5Mm1VRVZPLMKmyYHCJu07APQng
=Cglo
-----END PGP SIGNATURE-----

--2G07aagLxm6TmdhJgFd3JVxrEk0FhicIL--
