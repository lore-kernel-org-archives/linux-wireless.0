Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbXC1JLd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:11:33 -0400
Subject: found: PHY transmission errors in bcm43xx-mac80211 master mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zGb50ikZjGD6TwFpfs0g"
Date: Tue, 27 Mar 2007 11:39:41 +0200
Message-Id: <1174988381.5710.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zGb50ikZjGD6TwFpfs0g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

So I figured out where the PHY transmission errors come from. That's
when the firmware tries to respond to a probe request, apparently the
driver/mac80211/hostapd don't handle probe response offloading and thus
the whole settings for probe responses are invalid, leading to phy
transmission errors. mac80211 or hostapd actually respond to the probe
responses then but it'd be nice if we could actually use the
offloading :)

johannes

--=-zGb50ikZjGD6TwFpfs0g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCOZd/ETPhpq3jKURAj7xAKCo9jsJ5RReoSb3uwb0vhsRhvLEBQCdFfDr
hvOs6gyLioLjTEP+hVHBGZw=
=0mGv
-----END PGP SIGNATURE-----

--=-zGb50ikZjGD6TwFpfs0g--

