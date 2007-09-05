Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40163 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbXIEOTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 10:19:49 -0400
Subject: Re: [RFC 2/2] mac80211: revamp interface and filter configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200709051616.25044.mb@bu3sch.de>
References: <20070821161845.165557000@sipsolutions.net>
	 <20070905051626.GA12198@deine-taler.de>
	 <1188991396.9942.97.camel@johannes.berg>  <200709051616.25044.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4UwqGU5LSwRyLbhxhbNO"
Date: Wed, 05 Sep 2007 16:21:16 +0200
Message-Id: <1189002076.9942.107.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4UwqGU5LSwRyLbhxhbNO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-05 at 16:16 +0200, Michael Buesch wrote:

> > > 1) Use ieee80211_stop_queues() in ->configure_filter() and
> > >    ieee80211_wake_queues() at the end of the workqueue function.
> > >=20
> > > 2) Throw away all packets until the workqueue function
> > >    terminates.
> > >=20
> > > 3) Implement our own tx queue.
> > >=20
> > > I prefer to do option (1) because it wouldn't require adding
> > > additional fields to our private structure beside the work_struct
> > > for the workqueue function, it is simple to implement and it would
> > > not throw away any packets. Are there any side effects that I have
> > > overlooked?
> >=20
> > I think Michael says it's currently buggy if called outside of ->tx().
>=20
> Yes, we had a bug in b43 where we used it in the periodic workqueue.
> It causes really hard to track down system freezes on UP
> systems due to races with the TX code.
> It will hang and busy wait in the qdisc code when this triggers.
> I didn't see a fix for this, yet.
> But I think a fix could probably be to take the netif_tx_lock
> in the ieee80211_stop_queues() function, so we make sure that no
> TX is in progress while we stop it.

Ok. Of course, for zd1211 it'd be easy to set a flag in
configure_filter() and check that flag in tx() and if it's set then call
stop_queues().

johannes

--=-4UwqGU5LSwRyLbhxhbNO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3rtc/ETPhpq3jKURAqZgAJ421M14GWJGtIW8kNOiiX7HG/R7YQCeKmIZ
DLd0hGY0FM9j4mye0weGQZU=
=+vcI
-----END PGP SIGNATURE-----

--=-4UwqGU5LSwRyLbhxhbNO--

