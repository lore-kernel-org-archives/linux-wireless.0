Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbYLIOrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 09:47:15 -0500
Subject: Re: [PATCH v2] p54usb: rewriting rx/tx routines to make use of
	usb_anchor's facilities
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20081209143530.GA3653@tuxdriver.com>
References: <200812091514.37634.chunkeey@web.de>
	 <20081209143530.GA3653@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-v0zdultIiSYu9mzERsjO"
Date: Tue, 09 Dec 2008 15:46:39 +0100
Message-Id: <1228833999.1029.0.camel@johannes.berg> (sfid-20081209_154718_362388_6FE7EF63)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-v0zdultIiSYu9mzERsjO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 09:35 -0500, John W. Linville wrote:
> On Tue, Dec 09, 2008 at 03:14:37PM +0100, Christian Lamparter wrote:
> > Alan Stern found several flaws in p54usb's implementation and annotated=
:=20
> > "usb_kill_urb() and similar routines do not expect an URB's completion
> > routine to deallocate it.  This is almost obvious -- if the URB is deal=
located
> > before the completion routine returns then there's no way for usb_kill_=
urb
> > to detect when the URB actually is complete."
> >=20
> > This patch addresses all known limitations in the old implementation an=
d fixes
> > khub's "use-after-freed" hang, when SLUB debug's poisoning option is en=
abled.
> >=20
> > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> > Cc: stable@kernel.org
>=20
> That's a big patch for so late in the cycle.  Is there a bugzilla open fo=
r it?

No, but we can open one ;) It's strange, but nobody but me apparently
found the bug so far, even though it has been in there forever. Might be
due to slub debugging being disabled by default even if you enable
SLUB_DEBUG in Kconfig (you also need to enable SLUB_DEBUG_ON)

johannes

--=-v0zdultIiSYu9mzERsjO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPoTKAAoJEKVg1VMiehFYSdUP/R4ei99b9KAguzjdzXZphnHS
RApr0r35R8BM9/zQOjRgnkppsTPUpi/rpsnQG4ggZZNJ5iq1/9FqRzXZoQZxgwuz
uLY7ID9wvZJTH6Ajt7eUgr44N/0u9x766/2OgX63olMkx4gk/z0iCn+w6OYfha5T
eXKJcVLHY1DZs8J4FPAI9NVsj55qR6oV2GX2YhS6A5Aweilp0qelRh5xBfHIcwL6
760rf8yuT4W2+CAX+gxyZANh4NOA6Uxz/jKUWWFqwWpY8cikZRLx/vJqTfOPWe8q
HBHuoz0z3D6faTOlUULyO/zVFsGrhccWpf1rI6CbMHgCGmus/iiml+RjSLZUwur0
mb/QdjWWVT8/0bpMfcr+NcCOz1PBAA+LejXCXlp45+65sfm6zdj0nqiQ9VowaujW
pfAQ4ZWUflaDl+i51TL1Uqcc2OgnP7InufTsbdVifo4nq9TlhF5Xcf6p7swUMGCF
smvp7BvXbcJpDzWyo5wlv6AgNpNt8cWA3Nq681i8eCOrE32w/0xRZceHndw4x2dD
omB8ORb5oJS98n0C6IYqDYKz0edO5N197chbH7inSpMmx1RuqhMRbangmBGSwuWQ
kZaR+du07qUA30ujJGufgLcG1sT0MLnxm/LoDRPmdYnWcCDqDIkZmXL87Hin0RRt
MPVO3+GF1wKiDHrphmX0
=6p+6
-----END PGP SIGNATURE-----

--=-v0zdultIiSYu9mzERsjO--

