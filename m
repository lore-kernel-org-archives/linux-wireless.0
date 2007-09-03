Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54547 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbXICOJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 10:09:39 -0400
Subject: Re: [RFC 2/2] mac80211: revamp interface and filter configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1188811750.14564.32.camel@johannes.berg>
References: <20070821161845.165557000@sipsolutions.net>
	 <20070821161942.938977000@sipsolutions.net>  <46DB6C7B.3020001@gentoo.org>
	 <1188811750.14564.32.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-P4wLrsuwnbQpAF8xI2WR"
Date: Mon, 03 Sep 2007 12:57:15 +0200
Message-Id: <1188817035.14564.44.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-P4wLrsuwnbQpAF8xI2WR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-03 at 11:29 +0200, Johannes Berg wrote:
> And I'll also look into getting it non-atomic. We're
> not protected against concurrent execution anyway, but I expect drivers
> would handle that? Or do we want that here? We can't protect all
> callbacks among each other anyway with the tx() callback etc...

Ah, I see now, no way to do it because the networking core already locks
around set_multicast_list using netif_tx_lock_bh, probably for good
reason. And then propagating that lock to the master device is the right
thing to do as well. Looks like you'll have to continue offloading the
actual reconfiguration to the workqueue when called from set_multicast.

And in fact, it seems that to protect against concurrent modification in
different code paths I'll have to use the tx lock when calling this from
the MLME code. Can you make sure that the filter will be reconfigured
before further packets are transmitted, that is packets that are going
to go into ->tx() after ->configure_filter()?

johannes

--=-P4wLrsuwnbQpAF8xI2WR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG2+iL/ETPhpq3jKURAvN5AJ9z/AbqY5cKQmSW5zcLsqK3pLj9bwCeIi5W
x4ARqhf8lyznlJdTjlPUJJE=
=meuI
-----END PGP SIGNATURE-----

--=-P4wLrsuwnbQpAF8xI2WR--

