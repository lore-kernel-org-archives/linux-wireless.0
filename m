Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48974 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYCaMBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 08:01:22 -0400
Subject: Re: rt2500pci, infinite calls to rt2x00mc_configure_filter
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Bas Hulsken <bhulsken@hotmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200803291801.17068.IvDoorn@gmail.com> (sfid-20080329_170212_598272_B4828B38)
References: <1206801246.24689.19.camel@Bas>
	 <200803291553.03955.IvDoorn@gmail.com> <1206808941.22448.22.camel@Bas>
	 <200803291801.17068.IvDoorn@gmail.com>
	 (sfid-20080329_170212_598272_B4828B38)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pFz1P1TWPnnr76hp5pB/"
Date: Mon, 31 Mar 2008 14:01:16 +0200
Message-Id: <1206964876.5468.12.camel@johannes.berg> (sfid-20080331_130130_830695_C5E26C6E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pFz1P1TWPnnr76hp5pB/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ivo,

Thanks for helping debug this. I haven't had a chance to run hostapd
again, been far too busy. As it stands, I'm not sure when I can possibly
get to that.

> > rt2500pci filter_flags: 2
> > rt2500pci MAC changed: 00:0c:f6:14:05:19
>=20
> Packet filter flags of 2 sounds a bit restrictive.
>=20
> Johannes, for Master mode shouldn't the following flags be set as well:
> FIF_PROMISC_IN_BSS
> FIF_CONTROL
>=20
> Or should the driver enable those automatically when master mode is enabl=
ed?

The driver most definitely shouldn't do anything, but neither of those
flags should be needed. In a BSS, all frames from the stations are
addressed to the BSS-MAC, i.e. to the AP, so the regular MAC filter
should allow them through without any sort of promisc. And control
frames aren't needed, those are just ack/cts/... frames.

johannes

--=-pFz1P1TWPnnr76hp5pB/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/DSi6Vg1VMiehFYAQJXOg//S+GCQLy8YL0Gd5k61V27AuHW/4ZAp+An
k+qgKPSMwyMwOg3vW5c/9LTmCuamUVTLi8ZbMH0Qi15d387TPekVRWDc6cRLMdar
dWOiXEtXtVpxpaUKF89e55WPz4LOgRCDzYNDUgQ3xqUDa6t2imeDjYpDFtd1MfG8
EQ0yeR3LoMHjr+vsOZRJ39x0FJUwwr7MLkJJHQOJWcdyT18YT+mIx5L+84zjIUf5
bdViHvRVTNCN1eGqt/Nm1CHFb6hEyeXZvm7vVj2EX76IUm48iFCTld0gnfNTKUtL
Xv+asBGJOjW8waqkW6sSqrKjfo/DQVPX3WKB+1J01eEGATkl2PFmQX25Ud0XGCAB
P5ralXVC317JBD8bMqMCPVQ32/K3KnnFtxsHyDPx1Jq6OkkkEJpGo4rM+vC/21iS
cxk55OSK2G9WvFfRvtbHHaUSiXSzfqFgPngIm6UgLjo95wtJHnnP+SdgC7R+14H4
TpWewqQaHaIllPzxWZQwAKYdN7Kum23bS9UlvA93m2n1/ZToI/W9J1Dv7yIKW3+1
Oepr8Re1wX7TdeyE1uAemlLyqVNSf96RL7+rEN8JDyZuUbBcozWsLJa84j6frzM0
vVxwnW+9Xt7gIIfBdlIGzzdQ7sLkmqkhN0n19Mu+n40SDE6Q36TUzl9mFIL2MgBG
MupS0EeHpUw=
=Ej9h
-----END PGP SIGNATURE-----

--=-pFz1P1TWPnnr76hp5pB/--

