Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:28176 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761105Ab2EIUhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 16:37:34 -0400
Date: Wed, 9 May 2012 16:37:30 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Kevin Groeneveld <kgroeneveld@gmail.com>
Cc: Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
Message-ID: <20120509203730.GE17416@shaftnet.org> (sfid-20120509_223744_098309_E60EECE1)
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
 <4FA15A70.2020108@stericsson.com>
 <CABF+-6VjWxN6mP4E+7WoR=RZxmSU70GPbua77Vmw+z=JnnKcUg@mail.gmail.com>
 <CAMG6FYgcep04reRKFe6vjpW+THbCT=+FnJ_-eLrcgE7+3UJEfA@mail.gmail.com>
 <CABF+-6XSA8OOjwuQqM-iDKHVTriJ04BzfA-VN0MqVAiN_ZrsEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ryJZkp9/svQ58syV"
In-Reply-To: <CABF+-6XSA8OOjwuQqM-iDKHVTriJ04BzfA-VN0MqVAiN_ZrsEA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ryJZkp9/svQ58syV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 09, 2012 at 02:56:34PM -0400, Kevin Groeneveld wrote:
> Can I just delete the PTA record?  (Easier said than done since it is
> a binary file... but it can be done.)
>=20
> Are there any other records in the SDD file that could cause problems?

For any given design with the cw1200, you're likely to need an SDD file=20
specific to that design.  That's because the SDD file includes GPIO=20
mappings to control the RF front end, plus things like bluetooth=20
coexistence parameters, reference clocking information, and some=20
calibration data and output power limitations.  Oh, and a macaddr too,=20
but that's generally overridden by the device driver anyway (eg via=20
platform data)

Most wifi chipsets requiring this sort of information have an embedded=20
or attached eeprom, but the cw1200 doesn't (presumably for cost=20
reasons), as it was intended to be used in cellphones that already=20
maintained per-device platform data.

So in short, there's no way to include a generic SDD file that will work=20
on all cw1200-based modules, and there's no way to detect which=20
particular cw1200-based device has been plugged in without the=20
information in the SDD file.  It's a right kerfuffle.

 - Solomon [who has some experience with this chipset...]
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--ryJZkp9/svQ58syV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFPqtWKPuLgii2759ARAjO6AKDGgkZX697qXsbt3ffki46PQMYHtwCeMIOB
4nUJBrMVPhc8KlmVys8+Zak=
=Orhv
-----END PGP SIGNATURE-----

--ryJZkp9/svQ58syV--
