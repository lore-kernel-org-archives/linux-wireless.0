Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbYIXPe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 11:34:27 -0400
Subject: Re: [RFC v2] basic background scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <hschaa@suse.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200809241719.28983.hschaa@suse.de>
References: <200809241636.38762.hschaa@suse.de>
	 <1222267578.4257.33.camel@johannes.berg>
	 <200809241719.28983.hschaa@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VPbaQCff7gP+52pL+Rla"
Date: Wed, 24 Sep 2008 17:33:41 +0200
Message-Id: <1222270421.4257.37.camel@johannes.berg> (sfid-20080924_173430_938402_2F621289)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VPbaQCff7gP+52pL+Rla
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-24 at 17:19 +0200, Helmut Schaa wrote:
> Am Mittwoch, 24. September 2008 16:46:18 schrieb Johannes Berg:
> > On Wed, 2008-09-24 at 16:36 +0200, Helmut Schaa wrote:
> > > Could somebody please have a look at the TODO comments (I have no ide=
a
> > > how to wait until all null-func frames are ACKed)? Thanks.
> >
> > It's not really possible.
>=20
> :(

What I meant to say is that it'll give problems with drivers that don't
do status reporting properly, and what are you going to do when one of
them fails anyway? retry it? how long? assume the connection was lost if
it isn't acked? I see little point in it to start with.

> > > +				netif_tx_wake_all_queues(sdata->dev);
> >
> > This is worsening a problem we already have -- you can enable queues
> > that the driver asked to be disabled. Until we fix that, I don't think
> > we should tempt our luck even more.
>=20
> I see! That's really problematic.
> Do you have already an idea on how to fix it?

Not really; introduce bits somewhere to keep track of who wants to
enable/disable queues I guess.

> > And why is sw_scanning false if bg_scanning is true anyway?=20
>=20
> During a background scan the sw_scanning flag is set when a scan phase is
> active and unset when an operation phase is active. Therefore I did not n=
eed
> to adapt all checks for sw_scanning.

Oh, hmm, ok, that might make the enum problematic. Or do something like

SCAN_OFF,
SCAN_BG,
SCAN_SW,
SCAN_HW

then you can check for scan >=3D SCAN_SW

johannes

--=-VPbaQCff7gP+52pL+Rla
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI2l3RAAoJEKVg1VMiehFYX8sP/3pBYj3MW5OZr6tuSI75CaxX
/4BmXFndxMsZ6EKGu/chuADx8daDugbBEPh/cFttYZTwb2LCzIZQyHJy90P/msQr
b9T/GiMoDbiOVWka9mPXlEYA/rVfVniYOeyAxWfkwYrTHB2hnfHTMG4WxZqj6igt
5oOjfCgnq53fPL/2h5qIZD0hQgoNwjT4EGPk8Dpw4fC9ikvPJjvmQ8TrmfWdF9Ov
bnoaViOK6uwB2wfg6083mbR9DYWyKnbP2BVX4FAOgxicavOFQrOnrHdqdlfWkW7A
AoAALJPkN6RV3Oni9om7zfDj69v9BeHkTR+kp/bvA91yi2QVQuXc0/cuhsdF2/x4
0Aa94m7gz5d5+OGLgevYybD2SJAv+cRhzEK1CUySTWe4TsirZhRnhGr2Ww5Olgeq
9GIslaVeH2P84x9tPyu1ijUYoWvjnYBO1OT0OJksqZFwmChuKfR9AG40Hqhoe6sC
IbBmIbYusWotSEUxSBRZcC3bp+jtaPqStFG/OwIYgIByq7T2XoqLUHU8FOvFQFzw
MmGgtF0HICdIuOG21fongLfI0iGP5mCN0tD/PB50YE26XQPk65LsGEHCfcjyNZBq
xUKB4diYr1l4XYGs8RaaL+Ezrw0d30wvDRiTnk7itnlkbxPXZnYRGqXbzyaQvvCc
GYo8JH1ISYmRPZbPeFlV
=D2Yy
-----END PGP SIGNATURE-----

--=-VPbaQCff7gP+52pL+Rla--

