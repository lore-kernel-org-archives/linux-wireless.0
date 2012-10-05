Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:53440 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721Ab2JEQv7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 12:51:59 -0400
Date: Fri, 5 Oct 2012 18:51:53 +0200
From: Sven Eckelmann <sven@narfation.org>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	lindner_marek@yahoo.de
Subject: Re: [ath9k-devel] [PATCHv2] ath9k_hw: Handle
 AR_INTR_SYNC_HOST1_FATAL on AR9003
Message-ID: <20121005165152.GA4473@sven-atom.home.narfation.org> (sfid-20121005_185203_078405_80D52B74)
References: <1348756862-8788-1-git-send-email-sven@narfation.org>
 <506B0628.6070201@openwrt.org>
 <CAJ-Vmo=bu=j+=z_TAeE3--Sn5oAEbkEG-HDqK=6okR8xmmWpSQ@mail.gmail.com>
 <2629427.e28b8DS3gI@bentobox>
 <506ED3D4.7050107@openwrt.org>
 <CAJ-VmonKjxmquSUg99kAtPWVwHH-4zTooF1Xvj9mGUyjWL5pCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
In-Reply-To: <CAJ-VmonKjxmquSUg99kAtPWVwHH-4zTooF1Xvj9mGUyjWL5pCA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 05, 2012 at 09:21:40AM -0700, Adrian Chadd wrote:
> On 5 October 2012 05:34, Felix Fietkau <nbd@openwrt.org> wrote:
>=20
> > ---
> > --- a/drivers/net/wireless/ath/ath9k/ani.c
> > +++ b/drivers/net/wireless/ath/ath9k/ani.c
> > @@ -307,7 +307,8 @@ void ath9k_ani_reset(struct ath_hw *ah,
> >                 if (IS_CHAN_2GHZ(chan)) {
> >                         ah->ani_function =3D (ATH9K_ANI_SPUR_IMMUNITY_L=
EVEL |
> >                                             ATH9K_ANI_FIRSTEP_LEVEL);
> > -                       if (AR_SREV_9300_20_OR_LATER(ah))
> > +                       if (AR_SREV_9300_20_OR_LATER(ah) &&
> > +                           ah->caps.rx_chainmask !=3D 1)
> >                                 ah->ani_function |=3D ATH9K_ANI_MRC_CCK;
> >                 } else
> >                         ah->ani_function =3D 0;
>=20
> Well, is it a RX chainmask thing, or is it a chip thing?
>=20
> It's totally possible to have an RX chainmask of say 0x2 or 0x4..

What are you trying to tell us?

> Also to figure out which registers triggered the interrupt is likely
> going to be a bit .. special. Maybe keep a circular buffer of the last
> N register accesses and dump them in time order whenever you get an
> interrupt.

Maybe you missed that part of the conversation, but this was exactly what I
did. You can even find one of my debug patches which implements it (but many
fancy hacks are missing).

Kind regards,
	Sven

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJQbxAoAAoJEF2HCgfBJntG9X0QAM9Ga7tclldN1cmeYMo718mg
LlPECpR+Is9UL8gHp+GIo/ToT/q8ruTVoLAbO9c93lIrWWT6zFzv2hqGscy4JcUO
VoSyx/fdlGBeLfV5eHEpLPUOvmlwieK8qeySHHOwRkz8EFnDav1xy2/sH+kNxFV1
dRO0tIHzYNwMDGVAOlg4SWwUWHLnJmbT8Xusyw6BDJut+HJd39i4tb+6m7qNG4Sw
9YktraFTjjn+HhRvb4UJLU6y7RtJhEf8K6Mho+o07XY977zWzFlkEjjes2FdE+L7
F+SQIA5/E+vT2vm3LRMrTGBd58lHbdUWN3GINS3JWLOA5Tl/Dg2tXoH+n5KPSi7+
w4vfPysIvJPEqEOKOsiMEUL1BCGa8RuFijDEo3kxcVhsTxznwpDQWNvXH1ADcv7+
U5KvCWPX+Lh9duVkSQey8JB47NHQ4SQR9nfrntnGCmBdaTuRofKRb7ccWB47tjmH
Xh1wZEeldpA3i2yZ1qlx8Uido49zPR7haV50pNDO3SC3wN7dX/cHr3qggq6PoFEZ
j4jYBz7ITt5i4TCCJ4EdiGZD4pcuak/I+B7jjoAmmd2lYH1xhuDb9tfFFKNvD+BG
7x3jANIyQ+c+q5iNe0gvJ+VQhSnFD1VuA2uiLgfFfn23jjjAYv1Il9at4JETpPxC
mQSvY4QtS2HWUcdVyX8n
=WBwq
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
