Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43185 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbXCCLSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 06:18:39 -0500
Received: from [84.135.251.95] (helo=[10.0.0.4])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HNSBj-0005cT-E8
	for linux-wireless@vger.kernel.org; Sat, 03 Mar 2007 11:14:07 +0000
Subject: question: /sys/class/net/*/wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Xls4zepbtzkc11PGx/Tq"
Date: Sat, 03 Mar 2007 12:18:11 +0100
Message-Id: <1172920691.4966.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Xls4zepbtzkc11PGx/Tq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

It just occurred to me that /sys/class/net/*/wireless/ completely
depends on wireless extensions. Since we're attempting to kill wireless
extensions and hopefully will succeed in doing that some time soon, it
is possible that people will be running with mac80211 drivers w/o
CONFIG_WIRELESS_EXT.

This leaves us in a sticky situation. People with CONFIG_WIRELESS_EXT
will have /sys/class/net/*/wireless/ directories, but people without
won't, and CONFIG_WIRELESS_EXT will not be necessary for a lot of
people.

Thus, I think we'll need to offer a /sys/class/net/*/wireless/ directory
for cfg80211-only systems as well, since that'd also be the only way to
tell if a device is wireless from sysfs. However, I'd much rather have
that dir called ieee80211 in accordance with what we're doing elsewhere.
But pre-802.11 equipment also uses wireless ext. Hmm :)

We could create ieee80211 and create a symlink to it.

Another thing we could do is simply deprecate the wireless directory
there, but then wireless-ext users wouldn't have a way to tell if a
netdev is wireless from sysfs.... Kinda feels like a "caught between a
rock and a hard place" type of situation to me right now but I'm sure
someone can come up with something perfect :P

johannes

--=-Xls4zepbtzkc11PGx/Tq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF6Vlz/ETPhpq3jKURAljZAJwLF0OhSVH5rYrXM93XZsRx3I5uTQCffsHS
cUOLx/uQDEZ2UhdOjB9DlkA=
=A9wR
-----END PGP SIGNATURE-----

--=-Xls4zepbtzkc11PGx/Tq--

