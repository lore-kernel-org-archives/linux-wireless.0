Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48698 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYFXJLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 05:11:38 -0400
Subject: Re: mac80211: workqueue & RTNL lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a32f33a40806240203w29d0caf7p6e2956d82d48e013@mail.gmail.com> (sfid-20080624_110328_016001_BC202CDE)
References: <200806230042.41219.IvDoorn@gmail.com>
	 <200806230030.42776.mb@bu3sch.de>
	 <a32f33a40806230130t11022b31p3d9997ab5e449fe6@mail.gmail.com>
	 <200806231120.41519.mb@bu3sch.de>
	 <a32f33a40806230417i68e4d19aj76a481d7dbf2c611@mail.gmail.com>
	 <1214297515.8967.253.camel@johannes.berg>
	 <a32f33a40806240203w29d0caf7p6e2956d82d48e013@mail.gmail.com>
	 (sfid-20080624_110328_016001_BC202CDE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4/lhGKpmuecJOZw9xu4i"
Date: Tue, 24 Jun 2008 11:10:58 +0200
Message-Id: <1214298658.8967.266.camel@johannes.berg> (sfid-20080624_111141_624909_2DB9B176)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4/lhGKpmuecJOZw9xu4i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-24 at 11:03 +0200, Ivo Van Doorn wrote:

> > Ouch. Any way you can use the atomic iterator there?
>=20
> No because of rt2500usb and rt73usb who need scheduling,
> and this bug is in exactly the same function as before where we had
> the scheduling while atomic problem when you introduced the atomic iterat=
or. ;)

Ok :)

> > Or if not, can you use schedule_work and cancel_work_sync to take care
> > of things?
>=20
> I thought about that it cancel_work_sync will cause exactly the same prob=
lem,
> stop() holds the rtnl lock, rt2x00 work waits for rtnl lock, mac80211
> calls stop(), rt2x00 waits until tasks are completed but one of those
> is still waiting on the rtnl lock.
>=20
> However I could use the non-synchronized version for cancelling the work
> and add a check to see if the work should be cancelled within the
> rtnl-protected area.

Oh, right, your work is actually taking the RTNL. We will not get the
->stop callback rtnl-free no matter what we do. And we can probably not
even get it free of whatever lock we need for the netdev list either
way...

However, the interface iterator will simply not run at all if ->stop has
already succeeded since no interfaces would be UP, so you don't really
have to protect it against that, you only have to make sure it's not
running when you unregister your hardware struct, and _that_ doesn't
have the rtnl taken so you can use cancel_work_sync() there.

> > I would like to keep the mac80211 workqueue rtnl-free because
> > otherwise locking is going to get ugly.
>=20
> We need a big warning in mac80211.h then that tells that the non-atomic i=
terator
> or any other rtnl locking cannot be used in the mac80211 workqueue.

Agreed, care to prepare a patch?

johannes

--=-4/lhGKpmuecJOZw9xu4i
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYLoeAAoJEKVg1VMiehFYBloP/iONul+v6teonlLkncpe+fui
VS/xsboiRkQsay8hew2eRG/g7A1hyxh3YkEzNIxxWub72I19PH7sp2XiktLU54IQ
VBOgUyhl4gd6moXSorZqbGCPTniIOTUHZZHMw/fvrlxEXt3H0NaR5cizUw5l2ONX
jpLTYDUo+2tltkHgU9hNIUoIgKtGR7c7Dj8MWI35yWz1seR1w5wceUENWDnCcuF6
x19xaHD7EITzEgyBB5j4d5AUoJbwRobNzIhS53viI/J03q1tgivBMXp0ZxR6yqHT
U5aBuJCWpMhUx+NOY0mns2NsOGLUI+cF3S4zl4P39vuMQifxnWb0rJ6pafk4jMMQ
onea7W3NOkqHRgvImxVg1NvoL2pRMirZ+PBbPy3WRkA9i82I3pCnbXDj1eqmTBaP
PA8efi2shvuaDQj5LAz67HjZBcmmpJclElQ6yGtNqVrIy1rWyxw7dc6CNld0oEhm
Muhu1O0LzXL13h2/2rvuEMsvSolPlHBr3Z6GPKCo2GGxgM74gxoerMsGYHhp1pO5
g0r7ir8VEy31jFxICPzw0nw92GNI7hyZlwn6M1/5nXtSvtgKPqztqRsG0mXKOp1H
+LOh5bGMA7rQUzdmmIYsECEcM76juz9qdnxp2y+qZx6LdVDesIZcz2Qz4rw2zY4s
s6+oILqVCYCwIks8B5Ke
=m00m
-----END PGP SIGNATURE-----

--=-4/lhGKpmuecJOZw9xu4i--

