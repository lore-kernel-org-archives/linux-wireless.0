Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:60026 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751498AbeENSCS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 14:02:18 -0400
Date: Mon, 14 May 2018 20:02:05 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Chris Vine <vine35792468@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: Regression: bcm4312 lp-phy device not working in 4.17-rc5
 kernel
Message-ID: <20180514200205.47814f60@wiggum> (sfid-20180514_200221_897229_D35AE8DD)
In-Reply-To: <20180514195539.74686870@wiggum>
References: <20180514184953.001c06412efcf2b16fdc59ac@gmail.com>
 <20180514195539.74686870@wiggum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/KpQJHEqftyvlQTpPVqDy5Tg"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/KpQJHEqftyvlQTpPVqDy5Tg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 14 May 2018 19:55:39 +0200
Michael B=C3=BCsch <m@bues.ch> wrote:

> On Mon, 14 May 2018 18:49:53 +0100
> Chris Vine <vine35792468@gmail.com> wrote:
>=20
> > I have an old netbook with a Broadcom bcm4312 802.11b/g lp-phy
> > [14e4:4315] (rev 01) wifi device.  This works up to and including the
> > 4.16 kernel, but not with 4.17-rc5.
> >=20
> > The b43, mac80211, cfg80211, ssb and mmc_core modules are loaded OK, as
> > is the firmware, and the wlan0 interface will come up, but any attempt
> > to use the interface fails and it cannot (for example) scan.
> >=20
> > No useful error messages are given.  The interface (wlan0) is just
> > reported as not being ready. =20
>=20
> Hi,
>=20
> thanks for your report.
>=20
> Can you please provide all kernel log messages anyway?
> And what does "not ready" mean exactly?
>=20
> It would be extremely helpful if you'd do a git bisect to find the
> commit that broke it.
>=20

Ok, I just noticed that mainline still contains the ssb breakage.

So you are most likely hitting this:
https://patchwork.kernel.org/patch/10393729/


--=20
Michael

--Sig_/KpQJHEqftyvlQTpPVqDy5Tg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlr5zx0ACgkQ9TK+HZCN
iw4oUg/+M1VfwlDinadcJhE+RC/e5K+XKpi17U6ORxRlS+gup2F9YFNXAHeNkP6x
STdO2nG9VpGDe90K3U8FNsj7tyjEZWJx8Dm9yfAHl0LVzim1Ft4GJxKBsq82oDCP
ieW0UlHp6KEQYZMfpWPygITz4nmTcTpT1QfVK9RtUZLdy4oExrdodWWWeKhw1nXN
wD+InM0N/vzKlwePdiINJNicm5Hqk+lpLyG1dd07HFB8VbhdQViVkY13+RYBu8W+
w294cNEriykcF/R8qr0gkVM0/0CauzBzOpWKBSEufV/mVxb0FDgoXn3R1KvcC2+x
VoGumQC/roxu0W5PRof8nFH2XTONg6/+m2R9WRCAgx0Ap6/xixVBR5X+59ZwVhV8
Jxj5CxvqeMxawv2MVI6cLKpsd9RGP4aagBwxCQsyK/dqETBhRNL7S5v8M1JasiY9
EQanPKnccY7Z4lPeGdN7PwCVLTi0aljHB5Ic0AzjtHloyEu/el0S4nrQ/TD0t4Gd
VX+X2RoFFPrfw16lD9IpOfxn7ueXLpm5LdE6lsZ1HlQd2r+zd/tQo1+Ocn8r1gmq
e++bnEwE7hNgn4oi0F1Wx7vp6u5nRvWuaish2LOk7jp2fYjs3VTtVY+a09D7Sc+O
o9wGNhFtX9zCuv1Kd73eWSnHrJSl/2SqtX1aqwChDIOjihwpTCY=
=/BuN
-----END PGP SIGNATURE-----

--Sig_/KpQJHEqftyvlQTpPVqDy5Tg--
