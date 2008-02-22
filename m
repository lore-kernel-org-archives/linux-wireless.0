Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759575AbYBVNzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 08:55:10 -0500
Subject: mac80211: STA info size
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Wf+TC6sFkEE2JURa/Vy6"
Date: Fri, 22 Feb 2008 11:15:07 +0100
Message-Id: <1203675307.26341.29.camel@johannes.berg> (sfid-20080222_135522_503776_EAFA1171)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Wf+TC6sFkEE2JURa/Vy6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I was just reorganising struct sta_info to clarify the locking (will
send another mail about that) and noticed that due to the HT stuff, each
STA info struct currently (after my reorg) takes 2432 bytes. Almost 2000
of those are in struct sta_ampdu_mlme which is most likely not used for
most STAs.

Do you think that is too much memory per station? It'd probably be
possible to allocate the sta_ampdu_mlme dynamically when needed, no?

johannes

--=-Wf+TC6sFkEE2JURa/Vy6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR76gqqVg1VMiehFYAQLPrRAAlREZMKFv61uQec5Of3LN8nZL3EvmgBa5
7u1mIiLXvgO6NyVpK7o0jLZMTtHN4mKjeGuzu6W1G+4JVZsNO5S+pZtuowfprSn8
/mLXje2dJHc5iB32mB4LkImukXl0kjX/47wpMkGbWS/qHt6Fq/kwUbcAQcs4aGYF
r0I1ml7h7Mn9RZc4OiuTRgH7EbN2gbUqMbE4/2WOgBTs+DrKiivPp73ig6HX9Fjg
nE4fEl4OJgl6ZoB6Z4OlZnAadH4q9+jKm1edVh/lafFRSLJGkDjQAS3M5DPZudHd
yYRXtZv0QVkb/FN81amVZME5NiY7ovY+ReE2A4J9YXQOt7VUx94jrkvUhHXDm/qZ
pkn7FPp7RKfBsL5dWs5+bJaJsCKOpgnG6bWxHWvhseVtYeJy8QxvRSjcIOqehpGA
yVXGhRvyngXY9lgGkJD6mKPWDh5I7ZlYXDUmaFan/gUhvNIq5yN6Mm0jmYEv+GPD
hf7xk+q2DT8viXpLZRP1/BUtvagfCdjUWf6Qs7ENoQka0te/YTQMLFQA5e7h7yln
fWlCvss6XXxIdrePqRLrFWGDTpKyMOhvS9MacRWBuJCNmvRXzb+qT2kfyRNCgk6O
5ctFPchRT1m1S1aM8GxsmJU3/yZyEvAnUoNY2u/chQZU+Cubh2W6ShW3UJsJ4m4j
jT9VB9v1qQI=
=Rpc2
-----END PGP SIGNATURE-----

--=-Wf+TC6sFkEE2JURa/Vy6--

