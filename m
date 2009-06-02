Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50640 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZFBVBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 17:01:12 -0400
Subject: Re: [RFT 3/3] b43/legacy: port to cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <4A2592C5.10803@lwfinger.net>
References: <20090602111027.460530075@sipsolutions.net>
	 <200906021641.11019.mb@bu3sch.de> <1243973079.6461.3.camel@johannes.local>
	 <200906022208.46288.mb@bu3sch.de> <1243973487.7176.1.camel@johannes.local>
	 <4A2592C5.10803@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mkJhMBiC41wBqAf1xYdY"
Date: Tue, 02 Jun 2009 23:01:10 +0200
Message-Id: <1243976470.7176.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mkJhMBiC41wBqAf1xYdY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-02 at 15:59 -0500, Larry Finger wrote:

> I'm trying to test, but I get an oops on boot. I'm still tracking it
> and I lose the reason off the top of the screen, but the trace is:
>=20
> queue_work + 0x1a
> schedule_work + 0x16
> rfkill_resume_polling + 0x23
> wiphy_rfkill_start_polling + 0x35 (Line 452 of net/wireless/core.c)
> b43_op_start + 0x172  (Line 4336 of drivers/net/wireless/b43/main.c)
>=20
> The offsets are appropriate for wireless-testing and x86_64. The line
> in b43_op_start is the one just before the mutex_unlock.
>=20
> Is it possible that we reached this point without hw->wiphy being set?

Thanks for testing. This doesn't happen on a current wireless-testing
tree I hope? I'll look more into it tomorrow, need some sleep now.

johannes

--=-mkJhMBiC41wBqAf1xYdY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJZMTAAoJEODzc/N7+Qma/PUP/Rurp4Bv9Rqhk0Azd7k7OOsU
kfN53C1pipPYl+u+W+mfon28GU1ZPeCNzeyAEY81BPOH87eJbHPkhKgHGimUJGh+
Miq8r0QSYVPb0KMctIAzqUjfoja4s0giPTVLaxQTHCxRP7YHbKVWeCg7/hO/6IuT
+8Y3m7Fo/nD4wYmReoa5V5UiPvKVYLcP0P4U7AOWEc/kVm3qv17+RzTUPl86ju0f
4OcN85Rbcz+F5bo77p3zMUD0eZY1d83lglXcoiNwclIPOzXgiuXJEzRJloRA7MAb
DNo2QLalE/uG42kRmUQCDTvVgrUaMk8HA7mYHAQ9pp3t/qcIS8N+ID6LG3h3Qaqi
iPkSk244zIqnABOpO7Bui5kGElj7Z2QKT8rbZIsPH4lgfvVhFZMIXS5+vdqc7eET
nGbnNo9zBk7s97aQJYhEdvyckXSokv9AcX6V/LW+qoTk783L48GCdJIIubneSOob
smoqkK1IBaicw5udaIZD/Z8esvK8MgtHq9ugVM6HpUBSNf4PoOVfIGWrLyRx1psm
OyAGjsMwAXGKfFb6Iw9TmKSCilgk0+4YKuTwCRGvjGrtd5ZIOsPE1yv4OS1aIzh+
xYaNq3oV4oCk6JIwNxCmDrkkJyw31En/6f/fR2pu/RLomjm1Ex8bmneEGyXnJZ5M
jVC6XLe93gKEGig7xDbA
=v8Dy
-----END PGP SIGNATURE-----

--=-mkJhMBiC41wBqAf1xYdY--

