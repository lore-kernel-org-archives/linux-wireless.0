Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbYGIP4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 11:56:43 -0400
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh
	beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <1215618570.3246.30.camel@johannes.berg> (sfid-20080709_175024_447098_AC2954E9)
References: <200807091511.14288.IvDoorn@gmail.com>
	 <200807091736.55061.IvDoorn@gmail.com>
	 <1215617595.3246.26.camel@johannes.berg>
	 <200807091748.49796.IvDoorn@gmail.com>
	 (sfid-20080709_174000_972007_A27DDD5C)  <1215618570.3246.30.camel@johannes.berg>
	 (sfid-20080709_175024_447098_AC2954E9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9a2y1n3nAoJiadfsqN86"
Date: Wed, 09 Jul 2008 17:55:57 +0200
Message-Id: <1215618957.3246.35.camel@johannes.berg> (sfid-20080709_175646_539102_692CBE38)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9a2y1n3nAoJiadfsqN86
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 17:49 +0200, Johannes Berg wrote:

> Ok so the thing is this: 802.11-2007 7.1.3.4.1 requires that we keep
> sequence counters per TID (and one for "not QoS"), which we only assign
> rather late in the wme code. Because even b43 hardware only keeps track
> of a single sequence counter, it requires not using that counter for QoS
> frames. =EF=BB=BFI suspect no driver except the overly smart iwlwifi gets=
 this
> right.

Even if we fix this, we still haven't solved the problem of the beacon
sequence number. I'm currently favouring putting the burden on the
driver since only =EF=BB=BFrt2400pci and rt2500pci seem to require it and i=
t's
fairly simple to keep a race-free per-VIF counter for non-QoS frames in
the driver (you can just do it under the queue lock), but doing it
race-free in mac80211 will need a bunch of extra locking.

I'll put off the fix until after davem's TX MQ rework though.

johannes

--=-9a2y1n3nAoJiadfsqN86
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdN+JAAoJEKVg1VMiehFY7H8P+QEx8z0NwHFgd/Nh6ex9Ijwk
beERHOgwhOEzcn+MAczMA9fzI4XGz9zThB0T9uBdk/PJICSdesqRnxmGwuEN2kwW
aGol5FyDLJxR/ryroyOvp0gWjMMtsJ6s9Yffg4Im3WaP60VXmYdJ2qKidRCCnw41
1r8xc99YB88/TKUY2gm6yq7O3DiAV4jULJgLn3vrhEg4bhs233aJHtjfA2KKpURu
u9tTHg3YhhhTHEtZ2ekMTTiO06B0WnaJfck1e5oxiEBD0GnZcScQn7g+b9+C5WGZ
ZFmSgo897oBTyaIXhMvcct9kGEsvsxqWDTL63C58aJpMmiTCCd9eJEgwL4fH+rXq
iFUnCd7qJKHLrLt2PL6fCLwprIoFvZHRoanit/YP6PaPqDqF3bdIS407CaEvu2hR
HP/bMlxNaHMxRp4vOLtV3373BLF3iGaP535zz9nEWs8gGiaxTokhRV2HOFGI7w9G
lzemDGmNnKWs2ulkPsnODiOGAzCy9hoPZu++hxnLgM3Z11RyaMWGcuBVkyFcbg0f
x1M4XYBVR+aMUlFHZ4xL7OkLEYWK2MwQDjzhJzfmhr/o9GhzMFbYbUCSSJw9T3Rd
1ek3w+TYwTjaDRpmNHBQrlbjfWJR33RCrASZ9swM5H9Y9rHne8IRb0sxb029dMoP
GrmaidFKe7xNqfU8l4X4
=aOTu
-----END PGP SIGNATURE-----

--=-9a2y1n3nAoJiadfsqN86--

