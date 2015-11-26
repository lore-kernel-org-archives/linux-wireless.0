Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:37138 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbbKZMc4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 07:32:56 -0500
Date: Thu, 26 Nov 2015 13:32:41 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: (bug report) b43: impossible conditions in debugfs
Message-ID: <20151126133241.5bc5a793@wiggum> (sfid-20151126_133320_816226_379368B8)
In-Reply-To: <20151126115924.GI10556@mwanda>
References: <20151126115924.GI10556@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/szlevSCOWKYQeZ8BkO1O0cf"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/szlevSCOWKYQeZ8BkO1O0cf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Nov 2015 14:59:24 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> Hello Michael Buesch,
>=20
> The patch 6bbc321a96d4: "b43: Add debugfs files for random SHM
> access" from Jun 19, 2008, leads to the following static checker
> warning:
>=20
> 	drivers/net/wireless/broadcom/b43/debugfs.c:217 shm32write__write_file()
> 	warn: impossible condition '(mask > 4294967295) =3D> (0-u32max > u32max)'
>=20
> drivers/net/wireless/broadcom/b43/debugfs.c
>    198  static int shm32write__write_file(struct b43_wldev *dev,
>    199                                    const char *buf, size_t count)
>    200  {
>    201          unsigned int routing, addr, mask, set;
>    202          u32 val;
>    203          int res;
>    204 =20
>    205          res =3D sscanf(buf, "0x%X 0x%X 0x%X 0x%X",
>    206                       &routing, &addr, &mask, &set);
>    207          if (res !=3D 4)
>    208                  return -EINVAL;
>    209          if (routing > B43_MAX_SHM_ROUTING)
>    210                  return -EADDRNOTAVAIL;
>    211          if (addr > B43_MAX_SHM_ADDR)
>    212                  return -EADDRNOTAVAIL;
>    213          if (routing =3D=3D B43_SHM_SHARED) {
>    214                  if ((addr % 2) !=3D 0)
>    215                          return -EADDRNOTAVAIL;
>    216          }
>    217          if ((mask > 0xFFFFFFFF) || (set > 0xFFFFFFFF))
>=20
> Both of these conditions are impossible.
>=20
>    218                  return -E2BIG;
>    219 =20
>    220          if (mask =3D=3D 0)
>    221                  val =3D 0;
>    222          else
>    223                  val =3D b43_shm_read32(dev, routing, addr);
>    224          val &=3D mask;
>    225          val |=3D set;
>    226          b43_shm_write32(dev, routing, addr, val);
>    227 =20
>    228          return 0;
>    229  }
>=20
> See also:
> drivers/net/wireless/broadcom/b43/debugfs.c:346 mmio32write__write_file()=
 warn: impossible condition '(mask > 4294967295) =3D> (0-u32max > u32max)'
> drivers/net/wireless/broadcom/b43/debugfs.c:346 mmio32write__write_file()=
 warn: impossible condition '(set > 4294967295) =3D> (0-u32max > u32max)'



Sure. These are intentional.
The compiler will optimize this out.

--=20
Michael

--Sig_/szlevSCOWKYQeZ8BkO1O0cf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWVvvpAAoJEPUyvh2QjYsOyFwP/RI2EOcnR3weCc/n5TqGQC9b
lP3hFfGTndnccIGPWlKhxZATeZokI8Po1DAPS57A/1ary5ZSCDtDIgJ3+OQVlnA7
+N1PEcuL9Lxq0WZerFA1rQe7zwWG7ilYLg1PrR2z74yku7RvuWog4T3446iU040a
vq8WCx/5nVfotbk2Ns7O/7H8zZJzaKn4AEm92oXNyjGmBsdGOuwi+3SiSqcr3N8O
HE3aNhg3RgoqwX4vjFVdkTqyKXgoudG92YSjc1sloAtbNcw38lyhiISd6xM6DYgR
jTvJnwA/hMDG7w5trLUpJYzDtF5SRSmUHenlkBba0LIms60qXhLJQN9QoDbZACGr
o5VijI4aQbyUoStwf9M/NnS9GuKEmr8VQRy0VqKPckB4Ui5Y9Yc8sqy8RSR132MH
uQDGaEWH/ase+JRJCGqgBRAg5rhCMOTn/JelNpqdIYaiAaikPAC/xJTMsEJixnKO
er9ExkjA4LijGTRtENod9syC4oJNPbM3sO0JGR2CT7vcZBWCy7bf891+K9VkdCLh
JRdnieIxujs7APze3E1Q1afJamWqRqe5X9C1EkfVlhnshtYyOTjc9L2L1RqwF8rp
SNb7FPJ/Xn1NUuZ4zngdjxdY7+/3sjLfFPrH+4F940hQ65+axafrNdSYFlYsM+zt
Zv0GfCszrt5ELNFPKE8C
=6tez
-----END PGP SIGNATURE-----

--Sig_/szlevSCOWKYQeZ8BkO1O0cf--
