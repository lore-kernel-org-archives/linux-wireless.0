Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38624 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbZC3J53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 05:57:29 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@opfer-online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <200903301154.10067.mb@bu3sch.de> (sfid-20090330_115542_001932_2A670424)
References: <1238349195.24972.5.camel@johannes.local>
	 <1238403987.24972.14.camel@johannes.local>
	 <200903301154.10067.mb@bu3sch.de> (sfid-20090330_115542_001932_2A670424)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Wtf3eIkpkF49CjDXfdQ1"
Date: Mon, 30 Mar 2009 11:57:23 +0200
Message-Id: <1238407043.24972.25.camel@johannes.local> (sfid-20090330_115732_529983_0928B643)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Wtf3eIkpkF49CjDXfdQ1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 11:54 +0200, Michael Buesch wrote:
> On Monday 30 March 2009 11:06:27 Johannes Berg wrote:
> > On Sun, 2009-03-29 at 19:53 +0200, Johannes Berg wrote:
> > > This patch completely rewrites the rfkill core to address
> > > the following deficiencies:
> > >=20
> > >  * all rfkill drivers need to implement polling where necessary
> > >    rather than having one central implementation
> >=20
> > One thing I was wondering about -- should we just implement polling via
> > a single work struct that iterates all those rfkill drivers that need
> > polling? I've given them each an own right now, but that seems
> > unnecessary.
>=20
> If it doesn't add new locking problems (global locks, etc...) that'd be O=
K.

Hm, indeed, it probably would -- rfkill_register needs a global lock
while being called from the driver, and the polling would need the same
lock while calling into the driver.

johannes

--=-Wtf3eIkpkF49CjDXfdQ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0JeAAAoJEKVg1VMiehFYjOcQAIqNJhXnKd6wo679m377R9lm
JVT5i3Ma5KNUrDUx4Oeiqswb8FweIgV55fdhmyzboavvm0oXY5Hu1Bf4mfs8cSPh
FXZQhOSaym473yNyQmu3+1i5+y1Z6fkApilQiZmL/MiDnpWMmx+wLWMUjQeEu/yx
SX8vP0iDeSw2eEgiv9WsIrmxQZmiiNgKa5Go/QPFN9lEaYC3R5HMqsZ+a2kJVIQB
cNaYP1azUyaRrM6briCPxAzkGcBknkCZaaitTIJIxxkyrZflrW2O/4kexjlcKM+M
xAjQ+MnzdXZPRIwu660B0VeT/CqscnU294b2BBsldRWrPR+QH5FUEDFVQNbk9Mmq
XYse+w3TDPhA9eTvfzjnshW62zRfCwNbeP959lY1mVXIiOncSg1Lq0epYduFwmn6
wE1DFM1xXSV8Ymg9UDhaz4LC98/4YxF0e6jHo0A6frRjor/RPuYjT0q6m5qDh8Ue
e7RUG9pSID97fZRQ0fJcjnTzqzwpVYdADg7QP256cIETThtS386p5gIzG4hHEzRR
ToGRDGtM11g9Lzxvw87JxFcw5HOuXK1ePD1Jd8rczhFrXlhHx2mCjBTsMu9SYn7x
PajV/Vu8NC9CLaeFHTSJDpRQrVVTmFQQe8Ahj1dVfK4F8iSYH8MH5Cp0fRTPC0ef
JzfsUy8RhsP51XVpkTEJ
=VpGQ
-----END PGP SIGNATURE-----

--=-Wtf3eIkpkF49CjDXfdQ1--

