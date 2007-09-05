Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47558 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378AbXIEObn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 10:31:43 -0400
Subject: Re: [RFC 2/2] mac80211: revamp interface and filter configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200709051023.48927.flamingice@sourmilk.net>
References: <20070821161845.165557000@sipsolutions.net>
	 <20070905051626.GA12198@deine-taler.de>
	 <1188991396.9942.97.camel@johannes.berg>
	 <200709051023.48927.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kIACCROf7ZiQe6wPEcJE"
Date: Wed, 05 Sep 2007 16:33:03 +0200
Message-Id: <1189002783.9942.110.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kIACCROf7ZiQe6wPEcJE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-05 at 10:23 -0400, Michael Wu wrote:

> That's just a general rule of thumb. configure_filter holds the tx lock s=
o=20
> it's actually safe to do that there.

Good point.

>  In other cases, it can be buggy (some tx=20
> code can get stuck) and racy (frames can get enqueued after stopping the=20
> queues). The first can be fixed in mac80211, but the second can't be.=20

I think that we should be able to get all this resolved when we rip out
the queue code and implement multiqueue devices. But if I want to do
that I need to reverse engineer b43 QoS first to have multiple queues ;)

> For=20
> most cases, stopping the hardware queue(s) should be done instead and=20
> possibly flushing the queue or waiting for it to empty, if you're trying =
to=20
> adjust the radio.

In this case it's about adjusting the MAC (filtering) and I'm not even
sure the the USB device has a queue that can be stopped.

johannes

--=-kIACCROf7ZiQe6wPEcJE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3r4f/ETPhpq3jKURAs8pAJ41JY52NAtdgHHzSMVcKlgzWazseQCeMgXl
8BoddKdKhu+WOg5bTrt8j9w=
=eNBR
-----END PGP SIGNATURE-----

--=-kIACCROf7ZiQe6wPEcJE--

