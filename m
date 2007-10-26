Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbXJZKys (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 06:54:48 -0400
Subject: Re: [PATCH] fix dynamic wep
From: Johannes Berg <johannes@sipsolutions.net>
To: dragoran <drago01@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>, Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <4721C4D1.3050000@gmail.com> (sfid-20071026_114349_758731_13CC6C41)
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>
	 <1193127280.3069.261.camel@debian.sh.intel.com>
	 <1193148453.8648.20.camel@localhost.localdomain>
	 (sfid-20071023_150810_118446_E87EE8F5)  <1193161034.7733.38.camel@johannes.berg>
	 <1193238423.2557.41.camel@localhost.localdomain>
	 <1193318969.6092.19.camel@johannes.berg>  <4721C4D1.3050000@gmail.com>
	 (sfid-20071026_114349_758731_13CC6C41)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-H+eDx/SZEcxfaOdiCawR"
Date: Fri, 26 Oct 2007 12:55:48 +0200
Message-Id: <1193396148.4406.59.camel@johannes.berg> (sfid-20071026_115459_475603_C5F00098)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H+eDx/SZEcxfaOdiCawR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

As I said as a reply to the other mail, this is totally bogus, you
misunderstood the privacy_mismatch() return value.


> -            sdata->u.sta.key_management_enabled =3D !!data->value;
> +            sdata->u.sta.key_management_enabled =3D data->value;

This is just wrong, !! is there for a reason. I think
key_management_enabled is a smaller datatype so if data->value is large
enough you'll get 0 here for nonzero data->value without !!.

johannes

--=-H+eDx/SZEcxfaOdiCawR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyHHs6Vg1VMiehFYAQJ6kQ//cCw2YfMJHww7u98ldJ1SoDmhl0RIbeuH
TPruA/+YWqNrA2CmtrFVeZupuKMeDNQQ1OowoL8tA3oH1SKof8nzw/8wfELdg0yR
PisLNFdZtdtgV2l+83luMZjfuNFY2bp96Iy1ua29G5Gm1r9Hv8SMjahf9Wpr0xz9
zFuxXBRL3pN5ID2NHBDO/U+WX0zkLNECZOgatO2JJSG1p8W9u1wi+1wUaaTSsSRA
CMjV3C2WD0Vz6wdMj//3/SPgtsCFR5eDSnuzG3apQkuxymPMczRYAoDyG8+e5owh
QQC6AXJmnfYiwuInpSv34mvngd/OyAIB4vASgrtpfD/ndSVBJGocogloTIppoK4f
auGuovgYdHDlBXy9UO/XGM/3m0gwdK8Xz5sORd5eqidc+yOV2XmvMHqJK/mEKHJq
gu6auItgAtPuFvHFXnWlbzroZvoOvbBqvOTE+eUBM0RXMG92LuTlr15ssxlqxdLK
vXUMaYaCu/stXhCkFs4cSyCWKEKHvb42Pk7Y+Uq3ggA3ob+o8hOTr8fioAweLySL
EDLfeYA6sxQAxTJdHA/cfvCIU3+MuGVrvTqMTtb/oHzNduQeHQYN6tQYvRALWDu5
CdqF98fXCsEfHVSKTI1hzOw+fyxYqYH3TcTC7vGdvT0YF15Q9eYf5NhKPgOdFb2O
0gx8Td2CYEU=
=Dt3I
-----END PGP SIGNATURE-----

--=-H+eDx/SZEcxfaOdiCawR--

