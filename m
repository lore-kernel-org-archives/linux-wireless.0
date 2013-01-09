Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:56532 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3AIOdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 09:33:16 -0500
Date: Wed, 9 Jan 2013 15:33:04 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Adrian Chadd <adrian@freebsd.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] nl80211: allow ad-hoc to set WMM parameters from
 outside
Message-ID: <20130109143304.GA23469@pandem0nium> (sfid-20130109_153319_972408_43D83857)
References: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <CAJ-Vmom91BS5fPas+FWsaqQwm-ZVcZckUXB2vQgoEXtKiOH6mA@mail.gmail.com>
 <20130109131540.GA22836@pandem0nium>
 <201301091510.49723.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
In-Reply-To: <201301091510.49723.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Christian,

On Wed, Jan 09, 2013 at 03:10:49PM +0100, Christian Lamparter wrote:
> On Wednesday, January 09, 2013 02:15:40 PM Simon Wunderlich wrote:
> > On Tue, Jan 08, 2013 at 09:28:44AM -0800, Adrian Chadd wrote:
> > > I still populate the WME fields; I need to "fix" paying attention to
> > > them in the adhoc case.
> >=20
> > Applying the EDCA parameters in the hardware and sending "standard" WME=
 IEs
> > (without EDCA parameter sets) is understandable, Linux does that too.=
=20
>=20
> Well, the WFA WMM Specification v1.2 costs $99 (last time I checked, whic=
h wasn't
> too long ago). However Johannes told me that the WMM IE should not be add=
ed
> to IBSS beacons.

I don't have the spec, and I don't intend to buy it. :)

But: We do have WMM IE sent by Linux IBSS STAs even today. The difference t=
o the AP
WMM IEs is that it doesn't include EDCA parameters (cwmin/max, aifs, ...). =
But still,
this is useful to detect that the other IBBS station is WMM-capable: we can=
 then
use QOS_DATA frames, use noack, etc ...
>=20
> However, we can still pack some EDCA parameters into beacons, probe/(re-)=
assoc
> resps because there's an alternative IE. The "EDCA Parameter Set IE" is p=
art of
> 802.11-2012 8.4.2.31 - The Element ID is 12 [Table 8-54].

Ah didn't know that - thanks for pointing that out. Although I'm still in f=
avor of
not sending anything in IBSS and do local changes only. :)
>=20
> [Note: It's worth mentioning that the WFA WMM spec was just a stop-gap me=
asure
> until 802.11e was ready. Here's an article which explains this weird bit =
of
> history, unfortunately it is in German
> <http://www.heise.de/netze/artikel/Parallelnorm-WMM-223736.html>]
>=20
> Regards,
> 	Chr

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDtf6AACgkQrzg/fFk7axbEFQCgpThv1yKA5DPIT57EEmuNcWCq
2PkAoIzve77LmHmcGRkKlgzQ6DQ4BseM
=tXBG
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
