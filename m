Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34235 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbXICIeu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 04:34:50 -0400
Subject: Re: [RFC 2/2] mac80211: revamp interface and filter configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <46DB6C7B.3020001@gentoo.org>
References: <20070821161845.165557000@sipsolutions.net>
	 <20070821161942.938977000@sipsolutions.net>  <46DB6C7B.3020001@gentoo.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FxGaWO7C2ImZAEcxaDfy"
Date: Mon, 03 Sep 2007 10:36:09 +0200
Message-Id: <1188808569.14564.22.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FxGaWO7C2ImZAEcxaDfy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-09-02 at 22:07 -0400, Daniel Drake wrote:

> This is slightly freaky for zd1211rw and probably other USB drivers. In=20
> most cases we can't act upon any of those filter flag changes in atomic=20
> context.

Yeah, I know, but it's running under the tx lock and I haven't seen a
way to drop that (yet)

> We could defer work like we do for multicast lists, but then the driver=20
> would be lying in that it would return from configure_filter saying that=20
> it has honoured some flags without actually having done so (yet).

Yup, I saw that you do that anyway so didn't think much of it.

> Will that be a problem? I'm thinking maybe not, since the flags only=20
> affect RX and we can't determine which frames will be in the air at any=20
> time. [as opposed to such atomicity problems that relate to TX, we can=20
> just disable TX until the work has completed]

It does matter a bit for scanning, if you have BSSID filters that affect
beacons and probe responses then you would want to turn those off before
transmitting the next probe response. However, when the multicast_count
parameter is -1 to indicate no changes in the multicast list (and you
then need to use the cached hash value in zd1211) the callback actually
*can* sleep.

This is a rather weird area of the patch. Splitting it up into two
callbacks makes no sense, and so far I have not understood why it runs
under the TX lock so haven't changed it.

> > +	 * This callback is must be implemented.
> > +	 */
>=20
> Typo.

Good point, thanks.

Slightly updated patch at
http://johannes.sipsolutions.net/patches/kernel/all/2007-09-03-08:32/021-ma=
c80211-filter-flags.patch

johannes

--=-FxGaWO7C2ImZAEcxaDfy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG28d5/ETPhpq3jKURAnwyAKCKLNQ2C6yMwnRqr7Gu6A6d+Hf2AACfWHLe
L6tVlJyrvXTVt5W9VZtC/e4=
=ZKSR
-----END PGP SIGNATURE-----

--=-FxGaWO7C2ImZAEcxaDfy--

