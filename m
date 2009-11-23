Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59252 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006AbZKWLej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 06:34:39 -0500
Subject: Re: [PATCH] mwl8k: split driver by chipset
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20091123112916.GT20214@mail.wantstofly.org>
References: <1258931158.12095.33.camel@localhost.localdomain>
	 <20091123110211.GS20214@mail.wantstofly.org>
	 <1258974789.7094.162.camel@johannes.local>
	 <20091123112916.GT20214@mail.wantstofly.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-D84LX6/Di1/mi0y+pwu/"
Date: Mon, 23 Nov 2009 12:34:41 +0100
Message-ID: <1258976081.7094.164.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D84LX6/Di1/mi0y+pwu/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-23 at 12:29 +0100, Lennert Buytenhek wrote:

> This has the problem that e.g. if someone creates a STA interface first,
> and we load the STA firmware image in response to that, and then creates
> an additional AP interface, we'd have reload the chip while there's
> still an active interface (the original STA one), which seems somewhat
> involved.  Just rejecting the second add_interface() seems undesirable,
> as then the outcome of two add_interface() calls will depend on their
> order.
>=20
> (AP firmware supports both AP and STA interfaces, but e.g. it doesn't
> do STA power save and such.)
>=20
> It'll also have some consequences if there are monitor interfaces, as
> e.g. STA firmware allows fine-grained control over the receive filter,
> while the AP firmware does not.

Hah well in that case it won't really work because you really shouldn't
change capabilities on the fly. I have no useful idea then, sorry.

johannes

--=-D84LX6/Di1/mi0y+pwu/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLCnNLAAoJEODzc/N7+Qmar2EP/29Ppgup+5w9u9h30ujhclGD
wL51uXAAOS+WpT5+5NeIgZvHEEFHh9lnDFzp/0hM6ftVPX8BL+JoJulUC3IVw+XK
YoIf4MMneTMkBLgRcgiXjQVvP5IgWQkJbg/uPSlQr32Fy9hbZS5tsZLJXVLWVuqK
21bSMDH1u1FGseC25oWZXo5AObtw134hTG++s74F5NPUCOp2iIuJdltK8QZRWrpd
P5TxMFegw/sQpKRIfsCRocQHXrfa8AsfMIDtOs7gPr8orTTY2SM5h3qakfV0Vu6g
nJ0Sj9xT6txMliEuX1JAaxblQXYY8fpKClj8TZ+V8pMmRZyu3flYWk8IMrBAEw+K
KCadd4kvdDLbaE1n6YnrJjwwSr89Asz7JOqFugdXTk7RgkvQneYLUV2RIMUtHvsL
zuSBVv2e23PNLBu89+2/mYuOXKxwjK0IAQ60poqZ0/rYCl/zy52Glni3BBKkchCt
MprBtsLzO9lL8y06iN3iNpFfxsrtCoPpbvZJ4O2NZ83LQP7AIqeXkSPHzI8Sl6cn
xM0l8ES8brUdm026ce3+jpn62ulOKbiFhE1sTf07CKHb+O1G8A5tJ3JoUcbxUssD
CE+x8V51xow6oT/mP4hN1mhZP4w08pUjsh0sX2LEqsOyLVcFvA9j1V3WncjGmu+Q
Gs7wNohANbTNvABtbUFc
=X8LR
-----END PGP SIGNATURE-----

--=-D84LX6/Di1/mi0y+pwu/--

