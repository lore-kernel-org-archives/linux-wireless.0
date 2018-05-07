Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:36160 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752081AbeEGTcc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 15:32:32 -0400
Date: Mon, 7 May 2018 21:30:43 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Matt Redfearn <matt.redfearn@mips.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression caused by commit 882164a4a928
Message-ID: <20180507213043.727cee15@wiggum> (sfid-20180507_213246_623409_F5269FE3)
In-Reply-To: <874ljj2spt.fsf@kamboji.qca.qualcomm.com>
References: <7bbc067a-c412-3d2e-174a-abc31b46e246@lwfinger.net>
 <20180507204317.52992b6c@wiggum>
 <874ljj2spt.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/O_DufF+FEAEFW5+p0hXEcFA"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/O_DufF+FEAEFW5+p0hXEcFA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 07 May 2018 22:03:58 +0300
Kalle Valo <kvalo@codeaurora.org> wrote:

> Michael B=C3=BCsch <m@bues.ch> writes:
>=20
> > On Mon, 7 May 2018 10:44:34 -0500
> > Larry Finger <Larry.Finger@lwfinger.net> wrote:
> > =20
> >> Although commit 882164a4a928 ("ssb: Prevent build of PCI host features=
 in=20
> >> module") appeared to be harmless, it leads to complete failure of driv=
ers b43.  =20
> > =20
> >>   config SSB_DRIVER_PCICORE_POSSIBLE
> >>          bool
> >> -       depends on SSB_PCIHOST && SSB =3D y
> >> +       depends on SSB_PCIHOST && (SSB =3D y || !MIPS)
> >>          default y
> >>=20
> >>   config SSB_DRIVER_PCICORE =20
> >
> >
> > https://patchwork.kernel.org/patch/10161131/
> >
> > Could we _please_ switch to not applying patches to ssb or b43, if
> > nobody acked (or better reviewed) a patch?
> >
> > We had multiple changes to ssb and b43 in the recent past that did not
> > have a review at all and broke something. I don't think such software
> > quality is acceptable at all.
> > So please revert 882164a4a928. =20
>=20
> Yes, someone please send a revert so that this can be fixed quickly for
> v4.17.

Uhm, can you just type git revert 882164a4a928? :)
Or do I have to send you a pull request?

> > I'm sorry that this patch slipped through the cracks of my inbox.
> > But the reaction to that shall not be to just apply the patch. It
> > shall be to resubmit it for review. =20
>=20
> The thing is that in general I do not have time to ping people for every
> patch, I get enough of emails as is. If there are no review comments I
> have to assume the patch is ok to apply.

Yes, I understand that pinging people can be annoying and time
consuming. But we have tools like patchwork. Why isn't pinging
(semi)automated? Patchwork should really track the review status of a
patch.
I think the concept of no-comments =3D everything-ok is
fundamentally broken. But it has always been that way for wireless and
lots of other subsystems.

> But as ssb has had two major regressions recently I'm going to
> significantly raise the bar for ssb patches, and will refuse to apply
> random patches if they have not been tested with b43/b44.

Thanks.

--=20
Michael

--Sig_/O_DufF+FEAEFW5+p0hXEcFA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlrwqWMACgkQ9TK+HZCN
iw4jcBAAkclVNRB6XMZJ2Z+f5+6vNu45KEZ4CvpmY5WD78f4dK2dT0BNwbRv9v63
ZO1g6sBuYMBSFgySUW7BuSNHqTTb1Y9Ye+iNuG5Y1WPVHbmdBFPn+D/Tr3lDloRW
/f/auW6OB1dYN7A4k3S0+vTeaRwhPbcCRMp0pP3Vk0EXBh0rxgKYkHM0zL/sYhLv
6y4geiQewQ+WClgJXzxm5P+2P41S2uAdubFkAmoLveMvZX1UrHNJxjXMu56T/0Rf
H4XGHWeHqTlQR74BIhHXl2ZVO7t1wqfUKPn8AsojdW148aGxYO1qbDEbNohXYQIu
pE8FTUyMYWL4IcyPqvZnzs19J3rmoNKuDcw9k76yEO30jNPijeYDOXzSAmTS4CVA
a+dKo81OCBxQO43x73if08hlCafH83ZEfREZQtyj7V2woOASc4/E2uzfprOtjclv
kIZvuNPETu36/s/b1QnorXUvQLPT5UHt8rmAJo4unGFQpVgIR/gL3Ihztvwp0w6z
yUGySmUIm3w8rILUhVzEAVBmnLubDjXDvTeO2JMPMpkRR65dIBzo72WUGpFnoHg+
5qf8GptyAY9UoS6qUB23oReB48uTPX1Ho8eDmSxtTs/ojxBHAl1sB06f8q3b3vjg
8IajhdSjphWcU4gVVmPQPNosTiHvVgTX9De2IqDhp4xqBA81kmo=
=nC4V
-----END PGP SIGNATURE-----

--Sig_/O_DufF+FEAEFW5+p0hXEcFA--
