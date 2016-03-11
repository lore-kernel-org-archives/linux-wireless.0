Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:42971 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264AbcCKQbH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 11:31:07 -0500
Date: Fri, 11 Mar 2016 17:30:47 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, kvalo@codeaurora.org
Cc: Jia-Ju Bai <baijiaju1990@163.com>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, joe@perches.com
Subject: Re: [v2, resend] b43: Fix memory leaks in b43_bus_dev_ssb_init and
 b43_bus_dev_bcma_init
Message-ID: <20160311173047.785c2b24@wiggum> (sfid-20160311_173111_376402_5321E79A)
In-Reply-To: <20160311162230.GA5436@sudip-laptop>
References: <1452949690-16387-1-git-send-email-baijiaju1990@163.com>
 <20160311162230.GA5436@sudip-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/LvWfFmCSGtNlKD0VWmHbV29"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/LvWfFmCSGtNlKD0VWmHbV29
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Mar 2016 21:52:30 +0530
Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:

> On Sat, Jan 16, 2016 at 09:08:10PM +0800, Jia-Ju Bai wrote:
> > The memory allocated by kzalloc in b43_bus_dev_ssb_init and
> > b43_bus_dev_bcma_init is not freed.
> > This patch fixes the bug by adding kfree in b43_ssb_remove,
> > b43_bcma_remove and error handling code of b43_bcma_probe.
> >=20
> > Thanks Michael for his suggestion.
> >=20
> > Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com> =20
>=20
> The patch did not apply cleanly. I had to edit the patch to point to
> drivers/net/wireless/broadcom/b43/main.c
>=20
> For CONFIG_B43_SSB part-
> Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>


Ok thanks a lot.
We possibly don't get an bcma tester anytime soon. As this is quite an
important fix, we should probably apply it.

Sudip, can you please update the patch so it applies cleanly on the
current tree? You can add my acked-by if you want.

Kalle, can you please apply it afterwards?

--=20
Michael

--Sig_/LvWfFmCSGtNlKD0VWmHbV29
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW4vK3AAoJEPUyvh2QjYsO7S0P/RXBLOuc1QLe+N3l7D86GpXQ
019U0p1pZaOf2sBOsaG2sjhTuyFpU6cWCOEzPJsddmIDUmc3S2ZzFLwHQsiLtagn
NY1bUwgYJGZMkl3SN+A6Wdxsh803KB3/+ZaKvLVpwlowAg75olwvORH/hn1fLBlk
vBiJdsqo8It0LIIr9eYJvRvwqL51eqlEoWWADcEPG1c7rOaPMGTGAmUdc3x4oNhN
2g6UjQpOPnRt3FsapJyRxoQjKfxUrGAs85jlr7VxVy3Vpz2dB8rz8S4P2xoRZgxv
n9SMCjMvwttt8fPHWX8K5XPlmUdm1g7uyOHfPkQNrcSZjUt9Eq2A1q54zMsFRbvA
LoIJv/fcRvYtBByN8FYPFezs9kcBl1YBMmmaJsD+qRTYn68eomRn0dPRXkJhLO+3
lISsdvC7bLdCsn9Xp54Gjd+gI0ikRCZ770hM81aAfg52+DjlEz4SbsATPQ0dPa6u
Gw3sYuovQB8SADik5i19Eo/izn5u4sZi9eSkIZ64JkT2yA2fUE5pJVYFsFJSZrfh
IlMN1PyfuAXWu3VLsiR/vv/o7EdarMh6diKcv86mGt59e0T7jXx8Utc8i7BEfQ3y
ap3h9+9M5Zn0suEM92TKBRtujYxx8Tl5mQmfN9fJpbmUFoE0gWLd4ohJ9o9rdKvD
CfOXVfhuTYwiyqFgBLJv
=HXOz
-----END PGP SIGNATURE-----

--Sig_/LvWfFmCSGtNlKD0VWmHbV29--
