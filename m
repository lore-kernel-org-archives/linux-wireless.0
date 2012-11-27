Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:47903 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab2K0TuC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 14:50:02 -0500
Date: Tue, 27 Nov 2012 20:49:52 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Martin Schleier <drahemmaps@gmx.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/3] Add spectral scan support for Atheros AR92xx/AR93xx
Message-ID: <20121127194952.GA530@pandem0nium> (sfid-20121127_205008_031162_5E3E0734)
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <loom.20121127T201036-82@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
In-Reply-To: <loom.20121127T201036-82@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 27, 2012 at 07:16:38PM +0000, Martin Schleier wrote:
> Simon Wunderlich <simon.wunderlich@...> writes:
>=20
> > This patchset is a first request for comments for the upcoming spectral
> > scan feature. It adds a new attribute to nl80211 to ask for a spectral
> > scan while scanning, because we cycle through the channels anyway at
> > this time. If enabled by the driver, spectral scan results will be
> > collected. This feature has been enabled for AR92xx and AR93xx based
> > chipsets. As the FFT samples are very hardware dependent, they are only
> > provided via a debugfs file for further evaluation.
> >=20
> > [3] http://www.wehavemorefun.de/fritzbox/Ath_spectral.ko#Symbole
>=20
> Erm. Just a quick question, since you mentioned this fritzbox ath_spectra=
l.ko
> module... Is your "work" based or related to it, i.e.: did you peek at the
> assembler listings of it, or did someone else write a spec. and you just
> implemented it?=20

I didn't peek in assembler listings or anything, I've mostly followed
hints given on this mailing list or on the web and did some research who
else did implement spectrum scanning. Some of my sources:

http://permalink.gmane.org/gmane.linux.drivers.ath9k.devel/4834
http://comments.gmane.org/gmane.linux.drivers.ath9k.devel/8409
http://wiki.mikrotik.com/wiki/Manual:Spectrum_analyzer

=46rom this, one can grasp that the AR_PHY_SPECTRAL_SCAN has to be used and
some phy errors have to be interpreted (phy error 5 and 38). The rest was
mostly trial and error, including the interpretation of the data - most of
this is guessing and comparing to the Ubiquiti AirView [1] Spectrum analyzer
USB dongle when using an analogue wireless camera. :)

The goal of this was to create the spectral scan feature based on public
information, so the results are probably not optimal yet, but I hope that
this will help to move Qualcomm/Atheros disclosing some information (this s=
eems
to be planned anyway[2]). Otherwise, maybe other people can help
reverse-engineering this. :)

Cheers,
	Simon

[1] http://www.ubnt.com/airview
[2] http://thread.gmane.org/gmane.linux.drivers.ath9k.devel/8409/focus=3D84=
11

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlC1GWAACgkQrzg/fFk7axZ6CgCfQRYLqRJXFJVxydXoCi5RFyt0
6AwAoNPdmsaUFI0F6l8TY4YszAB9UIL4
=JXC+
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
