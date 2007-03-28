Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055AbXC1Qd5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 12:33:57 -0400
Subject: Re: debugging network manager association failure?
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1175093530.6907.10.camel@localhost.localdomain>
References: <1175023571.5151.3.camel@johannes.berg>
	 <1175093530.6907.10.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lQHOlDGn8wEdJcElSGaH"
Date: Wed, 28 Mar 2007 18:32:27 +0200
Message-Id: <1175099547.5151.64.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lQHOlDGn8wEdJcElSGaH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-03-28 at 10:52 -0400, Dan Williams wrote:

> There's been weird errors with wpa_supplicant that I can't quite wrap my
> head around.  There are two cases:
>=20
> 1) NM can't connect to wpa_supplicant's control socket sometimes; this
> is fixed by using the D-Bus interface

I'm pretty sure it is connected, looking at the strace I see some things
sent to a socket.

> 2) The _same_ settings sent to wpa_supplicant via NM, and those same
> settings in the config file, produce different results.  I've compared
> the settings of quite a few cases of this and found no appreciable
> differences, but still NM fails to associate.  I was kind of hoping this
> would all go away with the switch to the D-Bus interface in 0.7, because
> the socket-based control interface has been so much of a hassle.  But it
> probably needs to be fixed for the 0.6.x branch.

Strange stuff.

> Could you possibly get some driver traces of what happens in the driver
> for plain wpa_supplicant and then with NM+wpa_supplicant?  If the config
> that NM is sending to wpa_supplicant is the same, then the only thing I
> can think of is some randomly different driver state or interaction
> between the 3 unrelated to the specific config info that's causing
> associations to fail.

What exactly would you want? A printk in all the ioctl handlers in
mac80211 that shows all the parameters set?

johannes

--=-lQHOlDGn8wEdJcElSGaH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCpib/ETPhpq3jKURAi/8AKCo4FvtrDHzwL9dQ76BFHoPWKHb6QCgji32
UoryqREQ8cxJlV7A2vZoOSY=
=6aJx
-----END PGP SIGNATURE-----

--=-lQHOlDGn8wEdJcElSGaH--

