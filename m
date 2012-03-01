Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:41519 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab2CAM4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 07:56:11 -0500
Date: Thu, 1 Mar 2012 15:57:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: bojan prtvar <prtvar.b@gmail.com>
Cc: walter harms <wharms@bfs.de>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 1/4 v2] rndis_wlan: integer overflows in
 rndis_wlan_do_link_up_work()
Message-ID: <20120301125739.GF22598@mwanda> (sfid-20120301_135616_774642_1E95BBE2)
References: <20120229063555.GC18031@elgon.mountain>
 <4F4DE009.7010808@bfs.de>
 <20120301070208.GH1003@mwanda>
 <CAOmT4fS1jnywLoiMJjewFi2-w1UHySNPCEhAbrZwW01OS1hV6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aZoGpuMECXJckB41"
In-Reply-To: <CAOmT4fS1jnywLoiMJjewFi2-w1UHySNPCEhAbrZwW01OS1hV6w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--aZoGpuMECXJckB41
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 01, 2012 at 10:51:37AM +0100, bojan prtvar wrote:
> Hi,
>=20
>=20
> On Thu, Mar 1, 2012 at 8:02 AM, Dan Carpenter <dan.carpenter@oracle.com> =
wrote:
> >
> >
> >
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > v2: Fixed a style issue for Walter Harms. =A0Changed > 0 to !=3D 0.
> >
>=20
> Why not just=A0 if (req_ie_len) and if (resp_ie_len) ?
>=20

It could go either way.  I wrote it that way first, then I decided
that zero was a special enough case to draw attention to it.  In
this case it felt like zero was its own thing.

For allocation failures I would do:
	foo =3D kmalloc();
	if (!foo)
		return -ENOMEM;
Allocation failures are not interesting and the NULL doesn't have a
special meaning and doesn't need explanation.

Hard to explain.

regards,
dan carpenter

--aZoGpuMECXJckB41
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPT3JDAAoJEOnZkXI/YHqREvkP/0ZENWWco18TQFrRD+ylLztR
BAnQPTYgPNeZZ3inGnTQjvrdHAHwlx46l8JjJf3U+odu+YiZdlORm/MjoHec0G5F
FtfpUZcRvMnox3iZa1dIfJ6E/x650m3SYl5bwMJIEvGlyWdv03JfBwZcdP7Mjcq5
kFaatlFUxV8p0awsknwlS8seynlsGzOJhvvDbniDyU2v/hqlvxfpnwJySDUerCMa
uodTNkC3YWwbT6a6jfBhUdw92anhB81mqf6FKaT1XetSSjhc+wbv/wghehhel4mx
tC/xwKYG9+ynGJXS5kCnZm1lTL7CFtnYRddTforST7Xr4P2OKFInumJfGPOkjys0
Xa/8dAtNkNrPwNqbTBI56OA4Vq1kudADPIT9zgGodoJFWzTgennFOppn4W0U1OGz
BZ3V+GS0sr79FKqswjHpVSE2kVts6KoRW6kGuZRuYqpoOysWbouYqO2CpD0Fw/Mp
9rzeRdwg86dyuLDCp6MD3J/mxJ0CQB7x12MVNhRkl49x+bth5PDg6QgWzv5V6nMJ
MCRjP29Kkaj5vOUCWdtkfMYAFGboa/rlcr9JUYxxX/T12kRHE3cMQ1hgGJuqAL9R
daqiABiE6MPFZLYYqMFRsCubWUx2ff5mAu9g/ma6HFAFSRFIzhwxvNaM5n2dV+1e
vEtC8xcu12uxyor+2qLu
=Jzph
-----END PGP SIGNATURE-----

--aZoGpuMECXJckB41--
