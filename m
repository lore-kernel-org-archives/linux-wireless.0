Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbYDMIHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2008 04:07:39 -0400
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas =?ISO-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Vladimir Koutny <vlado@ksp.sk>
In-Reply-To: <1208072495.4111.10.camel@johannes.berg> (sfid-20080413_084148_084338_B7DE3981)
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
	 <200804021932.26046.IvDoorn@gmail.com> <47FE8FAD.9020802@archlinux.org>
	 <200804121246.44236.IvDoorn@gmail.com>  <4800F76C.7000801@archlinux.org>
	 (sfid-20080412_185459_927704_9BFD3D28)  <1208072495.4111.10.camel@johannes.berg>
	 (sfid-20080413_084148_084338_B7DE3981)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6+fVytmX8rlV69qd8JKa"
Date: Sun, 13 Apr 2008 10:07:29 +0200
Message-Id: <1208074049.4111.18.camel@johannes.berg> (sfid-20080413_090757_131055_65BB9A71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6+fVytmX8rlV69qd8JKa
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> > I compiled half a dozen kernels and now figured it out. This is the=20
> > patch that causes rt2500pci to be slow. If I revert it, it is fast agai=
n:
> > http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commitdiff;h=3Dd43c7b37ad787173d08683f05eadeea0398fefdf

> That's odd. But that patch looks a bit fishy now that I look at it, care
> to try below change (manually, this isn't a patch)?
>=20
> johannes
>=20
>         bool use_protection =3D (erp_value & WLAN_ERP_USE_PROTECTION) !=
=3D 0;
> -       bool use_short_preamble =3D (erp_value & WLAN_ERP_BARKER_PREAMBLE=
) =3D=3D 0;
> =EF=BB=BF=EF=BB=BF+       bool use_short_preamble =3D (erp_value & WLAN_E=
RP_BARKER_PREAMBLE) !=3D 0;
>         DECLARE_MAC_BUF(mac);

No, wait, I'm confused, the original patch is correct. As far as I can
tell, the code there is correct. The bug in that code was actually
introduced by me based on the wrong thinking I just did again.

johannes

--=-6+fVytmX8rlV69qd8JKa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAG/QKVg1VMiehFYAQJLoA/+InCvtovQzkcTJP1Jw3kQcqB1BKaxBpWc
pyBQcD1CxSF+XLkpypNUIagOlVji2odcEs0+dKheYBPND67nu8qjhga2xUb8ZRmJ
oth46ynkONPoiChb7ahfMAtFgyIG5fFZNoL4vRL2tGfFyYvjLdjnheExRb3mzh5s
5sdWAoY63Rdqhs8SfcDtm4VFFl5hd2qQj6ZTncVcT37wfAiEKQfV6pUKuP/0+KjU
GaFAp7duzVjIjTshzj9UZeE5TEkZF2bCJmmP1ppujY/UnV9RFsRYusk9V+LuKtjk
pI2L2IUooatBqX9PqMlkCNTnZjSC7XZZhnu9hBiIrRacfhvKUxiCdJn00I76r5CH
uVIQRM4mkNeS9QmV+Pe5SzedJ8hjSZck3HHwxDUY7WYF4h2VdrMzFW+hJnwWL83u
+K2Lni0NeMEaWCX3EasHKUgJWymZtTMaWsHVa+fyUv/VOGY0v0kpguad4h4kCfB7
SEFoo0k33ikxdIsPylv4w2UfjcAw4fD0ePpeLFXSWeZyJ2KVaUuq+3rACIiFjeda
llbeR12AMciK6Kk+5c+AFSRk0OlG5G2imbxJhwUPj5jp7zHKadzTHcPkqoeceRIh
+ZZgcqup9cnY9h0fHtw/XXkSAD6UsFpJ2zVvq7p72XMfqMFm80Tyeu/jk+zHr2eW
Dq4SO3GcNW4=
=J5LE
-----END PGP SIGNATURE-----

--=-6+fVytmX8rlV69qd8JKa--

