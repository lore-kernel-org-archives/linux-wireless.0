Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49566 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbXCZKAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 06:00:32 -0400
Subject: Re: [PATCH] zd1211rw-mac80211: Fix for monitor mode bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Daniel Drake <dsd@gentoo.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, kune@deine-taler.de
In-Reply-To: <20070326115412.2786c8f4@griffin.suse.cz>
References: <20070325231817.9C5887B409F@zog.reactivated.net>
	 <20070326115412.2786c8f4@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9ZD0NYPTl8VGfJ2zwAnE"
Date: Mon, 26 Mar 2007 11:59:58 +0200
Message-Id: <1174903199.1536.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9ZD0NYPTl8VGfJ2zwAnE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-26 at 11:54 +0200, Jiri Benc wrote:

> But this feature of zd1211 looks interesting. Johannes, shouldn't we
> add a parameter to cfg80211 allowing such packets to be received by
> monitor iterfaces?

Dunno. bcm43xx has this feature too, it even allows you to bypass the
second CRC check in the PLCP header. Picks up your microwave with
that ;)

Maybe take this into account for the driver API when implementing
IFF_PROMISC as we talked about?

> Daniel, does zd1211 send information about failed CRC check with the
> packet? Or do we need to recheck CRC in the stack if the feature
> mentioned above is implemented and there are both regular and monitor
> interface operating?

bcm43xx doesn't tell you when the CRC failed, nor does it tell you when
the PLCP CRC failed (if you want to see those frames). Hence, we'd have
to recheck the CRC(s).

johannes

--=-9ZD0NYPTl8VGfJ2zwAnE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGB5me/ETPhpq3jKURAro8AJ0d8UWJ4l+XL4pN+S/3f0YbTWY0ZgCeL6TA
BVY3RlYAzfH5al1SyHYMd1M=
=Ce/I
-----END PGP SIGNATURE-----

--=-9ZD0NYPTl8VGfJ2zwAnE--

