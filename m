Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:34437 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbbEVFCH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 01:02:07 -0400
Date: Fri, 22 May 2015 07:00:35 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Fix EFUSE_ANA8M map value
Message-ID: <20150522070035.711c6195@wiggum> (sfid-20150522_070238_535611_93D470EB)
In-Reply-To: <555E5433.7000904@lwfinger.net>
References: <20150521214421.15983b0a@milhouse>
 <555E5433.7000904@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/bZ0YGXJ_+1E_nytLmMzXKfG"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/bZ0YGXJ_+1E_nytLmMzXKfG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 21 May 2015 16:54:59 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On 05/21/2015 02:44 PM, Michael B=C3=BCsch wrote:
> > The map entry EFUSE_ANA8M is supposed to be a bit mask of the SYS_CLK r=
egister (see efuse.c)
> > It doesn't make sense to assign the enumeration value EFUSE_ANA8M. Assi=
gn the bitmask ANA8M instead.
> > rtl8192se does not have ANA8M, so use 0 as bitmask.
> >
> > Signed-off-by: Michael Buesch <m@bues.ch>
> >
> > ---
> >
> > This is RFC, because I don't really know the device.
> > The rtl8192se part of the patch is just a guess, because this driver's =
reg.h doesn't have an ANA8M define.
>=20
> I think the patch is correct. Certainly loading an array entry with the o=
ffset=20
> of the array makes little sense. This change makes the older drivers=20
> (rtl8192c{e,u} and rtl8192se match the newer ones.
>=20
> Once I test the patch, I will send it on to Kalle with my S-o-b.


Thanks. I did this, because I have an rtl8192cu device that does not work (=
even with this patch).
It doesn't return any scan results. I'll have to debug this further. Any su=
ggestions?

--=20
Michael

--Sig_/bZ0YGXJ_+1E_nytLmMzXKfG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVXrfzAAoJEPUyvh2QjYsOwX4QANHNu6a8l96lUaPnfkiNTszp
pBOMz5OpfR8gxoBuvrgiM6jjsv7w6e4eFGT8GjhL8/EuOZKbO0lltuFYElsx4owA
+gieNT7NW/NRN+lAqXtnCXQpcSIYBkVpzEf6xpXrMYarNMgcF2nGihrNt9ApAFFF
r7Tw6l7Oe5FSJiFaqAOXU2hHv08wcxDab11Gwn4TEwMfWY8eUcGHNIXS3poxbhR1
QebDm/+KCqzJ+Mny58BD/woYojdOp58lm7kUDHHNAU7eOB8vFVnRCcOudetwoLbI
ZmTuZowvl49TrZkRB+UPI+elrnsLS3xeElG30FGzS3aaI6HLnFqLIiS+qB1Hhelb
mYsMO0MJNOTg+JwxVr9rg/TdH1KVhUhS4YeQ1FhrpO5j13K/c02ebr64nItf2kv5
lwG0vM9IOBYY78dLuyqlui3uaOAp8tv7+NxbX/BjBPb1bX/fvcPN2GVvmyJmSSzj
03tr63oaqjd4SyHybbobzsnqUxOSUiJR0eIzW21nO8jVa9MluvXBNsTbLp+khHyf
DCt3zwjKmMnob094+T7j328mx+cfVzcZaPNVm1oJdyNskX3BB59WtnRtoyL9+2bP
EtJR0GFmMWx5feXOXN7dZrkXdllmWh4gEOK2lUwxApbUYxsPftB4RwvSNR28S/4b
z1bbfnrdRA/QjsxhDBe1
=2uYa
-----END PGP SIGNATURE-----

--Sig_/bZ0YGXJ_+1E_nytLmMzXKfG--
