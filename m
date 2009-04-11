Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZDKLeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Apr 2009 07:34:14 -0400
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1239395434.13792.3.camel@maxim-laptop> (sfid-20090410_223110_294055_69850902)
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
	 (sfid-20090407_145137_740898_8D0C40FD)  <1239109001.22453.40.camel@johannes.local>
	 <1239109497.15015.12.camel@maxim-laptop>
	 (sfid-20090407_150534_375314_4DA28551)  <1239110010.22453.41.camel@johannes.local>
	 <1239110412.15015.23.camel@maxim-laptop>
	 (sfid-20090407_152021_060436_AEF9110F)  <1239110860.4084.0.camel@johannes.local>
	 <1239112310.15015.25.camel@maxim-laptop>
	 <1239135878.17958.11.camel@maxim-laptop>
	 (sfid-20090407_222443_633750_085B264D)  <1239136637.7475.57.camel@johannes.local>
	 <1239395434.13792.3.camel@maxim-laptop>
	 (sfid-20090410_223110_294055_69850902)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cIiVCE7xJKDOing6CbRd"
Date: Sat, 11 Apr 2009 13:34:11 +0200
Message-Id: <1239449651.17031.42.camel@johannes.local> (sfid-20090411_133417_212159_B921F452)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cIiVCE7xJKDOing6CbRd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-10 at 23:30 +0300, Maxim Levitsky wrote:

> It is.
>=20
> I have just compiled iwlwifi.git tree, and same message is there:
>=20
>=20
>=20
> > [ 1666.298390] ------------[ cut here ]------------
> > [ 1666.298395] WARNING: at /home/maxim/software/kernel/linux-2.6/net/wi=
reless/core.h:79 nl80211_send_wiphy+0x8bd/0xa20 [cfg80211]()
> > [ 1666.298399] Hardware name: Aspire 5720    =20

> > [ 1666.298473] Pid: 13164, comm: wpa_supplicant Tainted: P           2.=
6.29-wl #19
> > [ 1666.298477] Call Trace:
> > [ 1666.298490]  [<ffffffff80241320>] warn_slowpath+0xd0/0x130
> > [ 1666.298504]  [<ffffffffa00f9ac6>] ? nl80211_get_wiphy+0x56/0xd0 [cfg=
80211]
> > [ 1666.298512]  [<ffffffff802a8263>] ? __alloc_pages_internal+0xe3/0x4f=
0
> > [ 1666.298525]  [<ffffffffa00f965d>] nl80211_send_wiphy+0x8bd/0xa20 [cf=
g80211]

Then your stacktrace is crap -- please apply the patch I just sent you.

> On top of that I need to note that NM doesn't show signal strenghts
> correctly.
> Instead it shows 100% for all AP except the current active one.

Separate thing -- don't hide it in this thread. I'll not even think
about looking at it here.

johannes

--=-cIiVCE7xJKDOing6CbRd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ4IAxAAoJEKVg1VMiehFY334QALQJkG7apQeycmp9qmTBs7D1
qW6anewEsc++yTamU1/8TS7PBMTx5+fI+7NXq8c5LKnkkIJsrWR/a18q0jyTUN9I
SSH7m4Y6x20qLm4ZNbPS0+hYwaukAtlfK2ebqlJ5NjLXea6mNesn1nQ22s7/ivt4
HipzY8cmxt4x+TDD4IvpQEhieCZagqM5VlUBvd6INrUpm616VeAGpPRXG5JNrnkf
PvrWT2QFk7karxfF7OVANzyPLbqfVw1TsTiGeouVWJMw6/qUHRV93Uf9mFvfFBrq
F0Kf1pw212EEFWD85k6mfz+Z+enTEjd6Ib2k9RzmuA+hcxaREQLQtIkC1i4syyBq
S4TRcQwVZ2CSLUa7ZrCjAlGnXIcDvWXYrj7HzJ94qAW4KDH28w1oThMjzu1AoGeW
GteRy52XhleZdlzDrWURYlq05oidnMyFS1QTgsV5FtkdZGhsbuX6cXVNqVpPiOjI
HNIPxTS1k0RCSod0eX6rE0JOpuIdCG0GK8ep6PV2bb/Wg39jheh2fVrvJAIqy5MK
ulGwKJHWqXA8HFJiQNKiTDg07f1kqCaPeATQ/a5oBaMPHv8HRVsaOPPUFoWpy7v1
JF3my1iYJlPTitIloR9aKqU6szOf8kK9k8dJ4Chr5tuKrmS5B6uqNijoSlIAqqCk
UVnH9z/PNKSWhjTz3EBm
=wnPM
-----END PGP SIGNATURE-----

--=-cIiVCE7xJKDOing6CbRd--

