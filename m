Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbZDRR5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 13:57:06 -0400
Subject: Re: rfkill rewrite bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <49EA125F.5060303@tuffmail.co.uk> (sfid-20090418_194847_597250_4374CFCF)
References: <49DCA88E.6060400@tuffmail.co.uk>
	 (sfid-20090408_153722_059382_FB44D658) <1239204090.16477.1.camel@johannes.local>
	 <49DCDD2E.80705@tuffmail.co.uk>  <49E38BBC.5010708@tuffmail.co.uk>
	 (sfid-20090413_205524_915082_56358705) <1239741968.4205.1.camel@johannes.local>
	 <49E98C86.2040308@tuffmail.co.uk>
	 (sfid-20090418_101208_980691_83127E2F) <1240043283.5792.0.camel@johannes.local>
	 <49E9A0C7.8040602@tuffmail.co.uk>
	 (sfid-20090418_114338_695917_3CBF9024) <1240057470.4755.7.camel@johannes.local>
	 <49E9F677.80109@tuffmail.co.uk>
	 (sfid-20090418_174945_153562_3F1E7019) <1240070230.2978.2.camel@johannes.local>
	 <49EA125F.5060303@tuffmail.co.uk> (sfid-20090418_194847_597250_4374CFCF)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3/Pvna15vmfHeX86hOI2"
Date: Sat, 18 Apr 2009 19:57:01 +0200
Message-Id: <1240077421.25100.0.camel@johannes.local> (sfid-20090418_195711_842825_39F93129)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3/Pvna15vmfHeX86hOI2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-18 at 18:48 +0100, Alan Jenkins wrote:

> Ah, I think I see it now.
>=20
> Um, what's the use-case for calling set_sw_state() before registration?=20
> Is it actually needed?

Probably not. I thought you would use it to update the core's idea of
your state. But the core always forces you to its idea of the state :)

> I think it was doing _something_.  If the initial wireless state is
> soft-blocked, but rfkill.default_state =3D 1 (unblocked), then without th=
e
> set_sw_state() call, the wireless would remain soft blocked.  When the
> first sync_work calls rfkill_set_block(false), the "prev" value would
> also be false, so it would return without calling .set_block().  And
> you'd have an inconsistency, because "/sys/class/rfkill/rfkill0/state"
> would say "1" (unblocked).
>=20
> You'd have a similar problem the other way around, if the wireless was
> initially enabled, but the user specified rfkill.default_state =3D 0.
>=20
> So maybe you need a "first time, force sync" flag instead.  That would
> also help if you had a write-only rfkill line, no?

Not sure what you mean -- the sync is always done on register()?

johannes

--=-3/Pvna15vmfHeX86hOI2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6hRqAAoJEKVg1VMiehFYnbQQAI7nD/Yb7yuGiaLC/c/Uvn3L
y1RHUYDZQzuBCR1J4+6Pgv1ybNmv/H7atZ2eCjO9Q/dnxyWFcUBRDa7UfwziUSsq
CtSWvjBfvv6MLjaPSrVMn0fAXc+/fpsE5ywiftHuduRe0QQOvJpN8xhP9LfqTXet
xmU/uUlYp2A0LCHN0demv3IQfl96QV7qX3jARP2OFBB+DjLLoBjVNb6DfmzZo43A
TB7NWT2v5NV9uejdOPW2iljChNz1g6kWJxhJ/0XKFl8d4kvHiYHRknZYltqFOP1n
jrD+EoNMF99Spbdxd/UiNLa6w3Vztnps5W8AbxmunqRKOIHC0F+EM0K8cFDcRbBK
6MeB79aUeb+ukAc+0Nl8vw/QHOhpnC8eQle3ixiVQ+G/LJbjkIz6zPPyNlXYTz3i
VCU+GDtdIT0k8Dlw8MP0+XD/2pfDbdogw6TDAQWDuPPvS/2y3W2oAUxNxQmVSC0m
k3nu4ITT4T5zq140IhgWLMg5NoX9DOMrA4bthy+QdKiFggYrCpf1UeXHufzJaBfm
ZxdZ9pzy0eC43vzA0/caiTvkejiq2KNN+C7br53FaGkGLqmonSnlipe6/ntC8oiP
V7mvcYoXv6XUenMDvstMrNBN5ofeZknwfP2nUF912mNMCTncheOpHdfu9ENxTqnY
kr93E7XpqP9JldmJhP8d
=6xsv
-----END PGP SIGNATURE-----

--=-3/Pvna15vmfHeX86hOI2--

