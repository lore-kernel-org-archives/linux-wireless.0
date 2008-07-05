Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59878 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYGETXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 15:23:16 -0400
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: Fix NULL pointer error
	in	adhoc/master mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Bryan Batten <BryanBatten@sbcglobal.net>, linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807052126.16913.IvDoorn@gmail.com> (sfid-20080705_211945_165330_117F5339)
References: <200807051511.57995.IvDoorn@gmail.com>
	 <200807052042.47008.IvDoorn@gmail.com>
	 <1215283415.6848.14.camel@johannes.berg>
	 <200807052126.16913.IvDoorn@gmail.com>
	 (sfid-20080705_211945_165330_117F5339)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4lClqVabIue6S89XmyDK"
Date: Sat, 05 Jul 2008 21:22:56 +0200
Message-Id: <1215285776.6848.21.camel@johannes.berg> (sfid-20080705_212318_331674_43BFB486)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4lClqVabIue6S89XmyDK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-07-05 at 21:26 +0200, Ivo van Doorn wrote:
> On Saturday 05 July 2008, Johannes Berg wrote:
> >=20
> > > Hmm, in that case I have to fix something in the beacondone handler
> > > to prevent it requesting a beacon when mac80211 hasn't supplied anyth=
ing
> > > yet..
> >=20
> > I was working in this area... Can you take a quick look at this patch
> > and let me know what you think?
> > http://johannes.sipsolutions.net/patches/kernel/all/2008-07-05-18%3a42/=
mac80211-beacon-revamp.patch
>=20
> Patch looks good to me, it wouldn't change anything about the above since=
 t2x00 would still
> call ieee80211_beacon_get() when the beacon wasn't provided by mac80211 y=
et.

Oh, of course, I just was writing on the patch and read your mail and
replied instead of sending you another one :)

One thing I'm worried about is the sequence numbers, but that bug is
already there... IIRC you needed software sequence numbers for your
drivers, but what about the beacons? I haven't _changed_ anything, but
IBSS beacons seem to not get a software sequence number.

> But the flags that mark what has changed is definately a good idea,
> that will prevent some redundant register writes. :)

:)
Only once you use the flags. My patch is intentionally minimal.

johannes

--=-4lClqVabIue6S89XmyDK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIb8oLAAoJEKVg1VMiehFYCMkQAIE9QzQvgj55gcCCOL7s6rqm
57lnn7V3OG3WHvviTPU+C2zQaHUKaTH34R4U/eiYU0zfqgMuJkOJibUtQCRNqf9T
a37b3mb70IqxQwI3Kad1fRBDgZO0F7iAR+ddDAtZWwD2Q7RGeL9tWl3XIi9zJX4p
ZyY0dT1hcxVad3KHVY7A1rrUzbafEKessDWAWmMRayqhS3Eq7uL1WBZRpNuH+Icq
W+Kfs3nLs+vEYm+ZMfpQwEFYyP+qkqqWwTFOgX8quusHf4aKw/CQ5YyYYPnVnn3l
yhECS+Lrak4RjFDHaj9qfH6wrtvzLYaB6Ve1brrhj7aaTPcRZ1J93EjsVdJ6HqdO
cuhjygFE5DahSJTScrjFNo78cUkl1B33i/B0VpiZ7Z+aDAQLwY1z38uQ1SIt0S5j
+/nYjIi2onrQZpLG9VpLiP3pIZXKQj//8Zo+7hcGUtl1xpDmmfY999hFLJLFVdKC
KlYGhZucWyH0wx4kiPYTVF01ZFgsXiacdzhTtAQ4em1ieT+f+w6fU2TcSbrjPRIb
YR/JTUREk0IAtmG29UWxIxEGxpGt/PtgzuI0ajgtxDSzjraPPQbmC3Od1muPZD/t
qNxnvyPZ6qXYUl0obvr6Ka69zUI4eg1ngms/LmuBS9Hn4rzlviuXNeLByzzMMhv+
+n7fjgh1xfLyt5TaRH3w
=cnWe
-----END PGP SIGNATURE-----

--=-4lClqVabIue6S89XmyDK--

