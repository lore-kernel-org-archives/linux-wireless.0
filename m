Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbXIELWC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 07:22:02 -0400
Subject: Re: [RFC 2/2] mac80211: revamp interface and filter configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Ulrich Kunitz <kune@deine-taler.de>
Cc: Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <20070905051626.GA12198@deine-taler.de>
References: <20070821161845.165557000@sipsolutions.net>
	 <20070821161942.938977000@sipsolutions.net> <46DB6C7B.3020001@gentoo.org>
	 <1188811750.14564.32.camel@johannes.berg>
	 <1188817035.14564.44.camel@johannes.berg>
	 <20070905051626.GA12198@deine-taler.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XJQ3rlBLyXsnrkBJowrX"
Date: Wed, 05 Sep 2007 13:23:16 +0200
Message-Id: <1188991396.9942.97.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XJQ3rlBLyXsnrkBJowrX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-05 at 07:16 +0200, Ulrich Kunitz wrote:

> I see three options to achieve this:
>=20
> 1) Use ieee80211_stop_queues() in ->configure_filter() and
>    ieee80211_wake_queues() at the end of the workqueue function.
>=20
> 2) Throw away all packets until the workqueue function
>    terminates.
>=20
> 3) Implement our own tx queue.
>=20
> I prefer to do option (1) because it wouldn't require adding
> additional fields to our private structure beside the work_struct
> for the workqueue function, it is simple to implement and it would
> not throw away any packets. Are there any side effects that I have
> overlooked?

I think Michael says it's currently buggy if called outside of ->tx().

johannes

--=-XJQ3rlBLyXsnrkBJowrX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3pGk/ETPhpq3jKURAn+lAJ4kNP4A0GLQbonllYBDvDYtcSj9CACcC7Pu
wRMP8trGeAbfkHICvwf5Kyg=
=m1RX
-----END PGP SIGNATURE-----

--=-XJQ3rlBLyXsnrkBJowrX--

