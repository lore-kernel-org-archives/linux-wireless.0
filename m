Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48375 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZK1Njt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 08:39:49 -0500
Subject: Re: rfkill: persistent device suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ian Molton <ian.molton@collabora.co.uk>,
	linux-acpi@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>
In-Reply-To: <20091128132752.GD17373@khazad-dum.debian.net>
References: <4A37A3E1.8060606@tuffmail.co.uk>
	 <1245161645.13461.3.camel@johannes.local> <4A37AEB7.6060405@tuffmail.co.uk>
	 <20090618030806.GE29569@khazad-dum.debian.net>
	 <20091128124158.GB17373@khazad-dum.debian.net>
	 <1259413945.5428.21.camel@johannes.local>
	 <20091128132752.GD17373@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-p/jXZQ+dRDEX7xjYl9Rp"
Date: Sat, 28 Nov 2009 14:39:49 +0100
Message-ID: <1259415589.5428.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p/jXZQ+dRDEX7xjYl9Rp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-28 at 11:27 -0200, Henrique de Moraes Holschuh wrote:

> > static int rfkill_resume(struct device *dev)
> > {
> >         struct rfkill *rfkill =3D to_rfkill(dev);
> >         bool cur;
> >=20
> >         if (!rfkill->persistent) {
> >                 cur =3D !!(rfkill->state & RFKILL_BLOCK_SW);
> >                 rfkill_set_block(rfkill, cur);
> >         }
>=20
> The issue I am reporting is _only_ about persistent devices, so it is the
> if(!rfkill->persistent) that is the problem.  It works perfectly for the
> other devices.

So then I don't understand -- if the device specifically said that it
was persistent, what kind of help does it need, and why does it not just
unset persistent if it needs it?

johannes


--=-p/jXZQ+dRDEX7xjYl9Rp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLESgiAAoJEODzc/N7+Qma2TQQAIDyK0af5ZPF0dVRS9cJRDwB
tq51TN0Oi6zFcDXWHO3BUTA6noRHqltZfHSn31pm/fFVbs151XjX5NM7UG/GE8gr
ijpSBSTd9Nljwkn5USxBi/7ffHkDiBoWnXzfRU2WodTfoi3/GJTDe9c6S88Jqhkc
Lml/LzyXBOaRDNJDPW/iK0ywl70HpzHdiGZ2ExkWmN/Cx2x/E9GoRuybphNL2AfJ
pDRoEvkgPHxPFEPs2yi5oT1w80Ya213zXThbvj2jntWDEQdfy6fasnRJBgN6PhGM
D6imGfkk7EaZ5XIjw2fUb5BRBTa1Gd92192G5pkKBwFOtoyab0pVUnXqANqpR47e
Vmi0lD3S6K1XtsxXnnfTGhkfYwRBvOJh4rrrRTVPpTLTczvB4qBDnpHQ1pz+3J0H
GTCT4s7Hi2KfRmUO2vZvWGQJ+VWaMmf01PPkKhouBBrDNOMwGCh29O5bhHPM++cV
h9MExFG5JnPnCyzLEmTqswLvNPWkyyMgstwDHg1mub5Fbag4Td8y3PPCGUu7v3h8
sb4gQDXmq19pYgwQG/zgoRQfwKnN6rp6DEA6/wDhYHuqpf71adajY7q/E2YpA5Tm
35aHVmDP83SAf4OiCY4SmHsanUIVM62ZHVoLnm5WrFPAVLI6gnZCpPCheOnlWm3G
RRZ8icCgvOu8nHjiTKmw
=u9fF
-----END PGP SIGNATURE-----

--=-p/jXZQ+dRDEX7xjYl9Rp--

