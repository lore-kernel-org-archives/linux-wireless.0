Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49533 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318AbZEDRC5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 13:02:57 -0400
Subject: Re: IEEE80211 Acknowledgement
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Alexandre Becholey <alexandre@shockfish.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200905041855.17435.IvDoorn@gmail.com>
References: <49FF06BB.2090106@shockfish.com>
	 <200905041835.35104.IvDoorn@gmail.com>
	 <1241455195.8683.61.camel@johannes.local>
	 <200905041855.17435.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-H/Dawz3fQfCFCRirPzdu"
Date: Mon, 04 May 2009 19:02:26 +0200
Message-Id: <1241456546.8683.67.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H/Dawz3fQfCFCRirPzdu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 18:55 +0200, Ivo van Doorn wrote:
> On Monday 04 May 2009, Johannes Berg wrote:
> > On Mon, 2009-05-04 at 18:35 +0200, Ivo van Doorn wrote:
> >=20
> > > Well I believe the idea would be that (I'll see if I can dig up a ref=
erence
> > > to the initial discussion about this feature on this list) the driver=
 sets a flag
> > > that mac80211 needs to keep a list of all frames send out to the driv=
er and
> > > listens for ACK's.
> > >=20
> > > As soon as a ACK was passed from driver to mac80211 it could check if
> > > the corresponding frame=20
> >       ^^^^^^^^^^^^^^^^^^^
> >=20
> > Here's the problem. What I'm saying is that there's no way to knowing
> > what the "corresponding frame" is.
>=20
> Hmm, so would there be any alternatives of fixing this problem?

The proper way of fixing this would be a firmware upgrade ;)

Working around it would be possible if the driver queued only a single
frame to the hardware, when it knew the frame needed ACK status, and
flushed all queues before that frame, so it knows exactly about the
frame... This has HUGE overhead and performance impact though, and
requires lots of work in mac80211 to not request status for every frame
to start with.

Since this breaks hostapd operation quite significantly, and I don't see
hostapd changing to accommodate this since that essentially breaks the
ability to be spec compliant (I'm fairly certain some places require
checking for ACK).

An easier way would be to fake a ACK reception in the driver for every
frame...

johannes

--=-H/Dawz3fQfCFCRirPzdu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/x+fAAoJEKVg1VMiehFY79oP/1LcfnP+BftVdgrThzhj8ZPA
o+GPfTJQLVnbTPpuTB2F3l9gv/hkLOVlZxoldMYSaLlU37sYnwm6fPKiGASzoaq2
6ufZ8HbxNL8GkiJc8RAxrEVLA7Unvr6scdipNBrk7whyi/e9K5eX+gguA0JbpN+N
Tu2mHnMLY/c768W3B1Bt2COxpjIKe2HXIzsT0RYfu0qgkDISgjS7owKiAQ8cCwHh
clTJaDthINsCR7SlMRjHH53ZSxw3pOB6sV0OJiZzaQzPGZuL5SwI2eNt16FNnVUN
d51IpX9Re9QfO7ecIXLRki4buqMENRNA78ODfBSyvIs4ff2YKSO0UK9SjTTNDkS7
Q4cheTWIpM82zcIKR+FF8pJN4dyjM7znd5OErt0IYdDvuEWtimVGj2KeknynZ+JD
iWZFmDz8LK5MKV4aarDjqPlnQ9Yfcy/89gGSbizn/CwPzJ3IMxtsEHUg43iczRFo
MiehBxXE72guki2evvLURRFZbF+L471z1Jo56rud+vKfOIB/DPazS/oHNeAcZHVV
CO5J+TUdubZowlNtdLh+bpQLBAIZmKM40KpgR1SBBFlx06MLNYKU5hd0XPh12Q+H
/VS0JGc86LxX6AQPExlNur99aizHJTW91+aI+/JY9mWsuNpzEsqoO0HT9aDKxWPl
Vt2vazS0nrBFS8Pc653k
=2s11
-----END PGP SIGNATURE-----

--=-H/Dawz3fQfCFCRirPzdu--

