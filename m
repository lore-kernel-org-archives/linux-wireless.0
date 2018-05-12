Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:57694 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750739AbeELIB5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 04:01:57 -0400
Date: Sat, 12 May 2018 10:01:36 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJl?= =?UTF-8?B?Y2tp?= <zajec5@gmail.com>,
        Matt Redfearn <matt.redfearn@mips.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V2 1/2] Revert "ssb: Prevent build of PCI host features
 in module"
Message-ID: <20180512100136.1d26e6d3@wiggum> (sfid-20180512_100218_958697_669F4520)
In-Reply-To: <877eo9b9d9.fsf@codeaurora.org>
References: <20180511091715.1989-1-zajec5@gmail.com>
 <CACna6ry-91oR1u697NRymLsN28fnnHDp9OQrdiVwA7A3KTV1fg@mail.gmail.com>
 <87bmdmcxf6.fsf@codeaurora.org>
 <727571cb-5d1f-2d99-b050-979edd02106f@lwfinger.net>
 <877eo9b9d9.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/y0/esRxeuCrNiC5ERnZP_M1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/y0/esRxeuCrNiC5ERnZP_M1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 12 May 2018 10:50:42 +0300
Kalle Valo <kvalo@codeaurora.org> wrote:

> Larry Finger <Larry.Finger@lwfinger.net> writes:
>=20
> > On 05/11/2018 05:13 AM, Kalle Valo wrote: =20
> >> Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:
> >> =20
> >>> On 11 May 2018 at 11:17, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> w=
rote: =20
>  [...] =20
> >>>
> >>> As these patches fix regression/build error, I believe both should get
> >>> into 4.17. =20
> >>
> >> How much confidence do we have that we don't need to end up reverting
> >> patch 2 as well? I rather be pushing patch 2 to 4.18 so that there's
> >> more time for testing and waiting for feedback. =20
> >
> > Although I do not have the hardware to test the builds, I worked
> > closely with the OP in the bug at b.r.c noted above. From that effort,
> > it became clear what configuration variables were missing to cause the
> > x86 failures. Patch 2 satisfies the requirement, and prevents the
> > build problems found by the MIPS users. Both patches are needed in
> > 4.17. =20
>=20
> And I assume Michael is ok with this approach as well as I haven't heard
> from him. I'll then push both of these to 4.17.
>=20

Yes, I'm OK with the patch, if we have a third patch that cleans up the
PCI_DRIVERS_LEGACY dependency by moving it to SSB_PCICORE_HOSTMODE
where it belongs. (This doesn't need to go into the stable tree.)
We currently implicitly get that via dependency chain, so this is OK
for now as-is.

--=20
Michael

--Sig_/y0/esRxeuCrNiC5ERnZP_M1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlr2n2AACgkQ9TK+HZCN
iw695BAAhoC7EPb+kHIBFNjdHD2KndNs+tkhA6AhdG+l+IKrddKIip+dn7B7g++I
cHUkpn9492Tu0ZCpk9QKODJtIG9hxli7E96AP+kFcpRQ9kxKmx9a259b9CqrYLNp
A2MeNxbb2Ix8kSbSeKar80IXH4x7GpR3SKRhUGdIbvWgVMuiqiSMSWvZLnVX3Q/s
Uf1I65uon6ElQTo6CBVrSc0D3F/WBvwKly8gCEPkktVdL5TqrE3SMqkI4u2rDt8A
tazmBeco+qs0oFFCE7OxncFI0XURFqtaDGQQZpf7fBE0b+JutDcJcLE6BkMu71OJ
6cFPsQgcf5Cv5Kv+qG0k7oYcYie5C9K7PF2Kqh+/NGUfu93VrKwmHto9p6SyHsrz
1sfkl0/E0QG8K5Ezi//jvlPKCIEbgTiSoFe5Lem1GT9fI+4BIxDpdTwbzGxNAklJ
0EkLK2LDGhj2EgBTR9O9fW+GUlv1kRUy47LBHCImojrdCuw/acnw/Hg012BQSMcr
rCz0P+3dSKKIKgZu0pgNWJD6yDQaxLJWfRd9f985t8ijPtdFfjZubQcCYjz1O5i0
/o5EnFJBnDhc/gsGqBuffK+uJq1ML2OY50zDIN97OMNfrUCw+Voq/UbjIg40eYT8
gZXYyrQEQuG25TnG+wlF2uDKKFwOqDqZSHdSSOh9e3lMq2TYBa8=
=YIVI
-----END PGP SIGNATURE-----

--Sig_/y0/esRxeuCrNiC5ERnZP_M1--
