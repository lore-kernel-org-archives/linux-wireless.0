Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56069 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbZC3Kjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:39:35 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@opfer-online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <1238407043.24972.25.camel@johannes.local> (sfid-20090330_115732_529983_0928B643)
References: <1238349195.24972.5.camel@johannes.local>
	 <1238403987.24972.14.camel@johannes.local>
	 <200903301154.10067.mb@bu3sch.de>
	 (sfid-20090330_115542_001932_2A670424)  <1238407043.24972.25.camel@johannes.local>
	 (sfid-20090330_115732_529983_0928B643)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Us1WuZ18OdCaOsAgx2OA"
Date: Mon, 30 Mar 2009 12:39:30 +0200
Message-Id: <1238409570.24972.33.camel@johannes.local> (sfid-20090330_123938_825000_88EFD3FC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Us1WuZ18OdCaOsAgx2OA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 11:57 +0200, Johannes Berg wrote:

> > > One thing I was wondering about -- should we just implement polling v=
ia
> > > a single work struct that iterates all those rfkill drivers that need
> > > polling? I've given them each an own right now, but that seems
> > > unnecessary.
> >=20
> > If it doesn't add new locking problems (global locks, etc...) that'd be=
 OK.
>=20
> Hm, indeed, it probably would -- rfkill_register needs a global lock
> while being called from the driver, and the polling would need the same
> lock while calling into the driver.

We can work around that by cancelling the work whenever we want to
modify the list -- that way the work doesn't need to take any locks. Not
sure it's worth it though, that makes the code harder to follow.

johannes

--=-Us1WuZ18OdCaOsAgx2OA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0KFgAAoJEKVg1VMiehFYx7gQAMAglhb8nxbLa4+fcvFHeGQu
D5RjXrDxpmOB5DzDVMgOVgeZ4OmMiYVon0I+lZseYcFEIMx0UNSkhBine4BnJx+Y
cCdlM7THNcjT6qoXRw+4Dj5Ey7EL5T3LTgrg9MPI5A0D3Wse4b9esTMnpH4ckJ2y
lVJYrbaQuZt+Ee/DJ/0z5cvt/X5p0A0uSIrprs4eKbA/bXojt+iGK+4t/7F2wgCr
Ot2Mfa9a7CzWU2BERjyjf5iqgWHyUrnjP2T/i+MVXti3T8R/3xV9+lr9bpAC1rsP
1RduZU9U3Aj08DhkplM+IJU9gWRJziZ669+xnsko1BaNMFju/jRFw58pjMXcdb+M
JRhAYBLVi9S/N4qrswLaM8T6gtup+mE5T2ispGVmNdq5oGxTnHrovim3Ywgonpqu
vwrScWCwirh0ajPhfp2D0Naszle7FB5H5QtCdqBgTCZHtLilYoAXNbnK2MJ02svX
56x9GwagDq05XDPTd54hr5A+drjW2trJTLH+pm1oiF32Y9QBKhwferrLT7Gx0ISa
KpcHkuae8E6p0aOok0K1NY2sTqYVTtPCQzIZ+QYeW0SeKdn5zg7mqeCEdyFcFOWa
IHfete+Y1QTM4mCCawd4EXWI68G/0DExl37khdMjtK8/Ctd8zOUT0onyz+SvGBoZ
QJXcmzHmeChMzPfY+kyt
=khU5
-----END PGP SIGNATURE-----

--=-Us1WuZ18OdCaOsAgx2OA--

