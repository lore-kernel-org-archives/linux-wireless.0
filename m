Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbYK1WOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 17:14:24 -0500
Subject: Re: [RFC v3 2/4] mac80211: implement dynamic power save
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227901784-5325-3-git-send-email-kalle.valo@nokia.com> (sfid-20081128_205007_402908_98B496DF)
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
	 <1227901784-5325-3-git-send-email-kalle.valo@nokia.com>
	 (sfid-20081128_205007_402908_98B496DF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HZPVAe/Tio0UaOP4Wg6S"
Date: Fri, 28 Nov 2008 23:14:20 +0100
Message-Id: <1227910460.3543.3.camel@johannes.berg> (sfid-20081128_231426_245526_0CEB7A7B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HZPVAe/Tio0UaOP4Wg6S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-28 at 21:49 +0200, Kalle Valo wrote:

> +	/* always wake queues to avoid having them stopped forever */
> +	netif_tx_wake_all_queues(local->mdev);

I think we really need to think about keeping track of _who_ wanted the
queues stopped now... We have a number of users of stopping queues now:

 * driver, obviously
 * scanning code
 * PS code
 * ..?

So when the driver wants a queue stopped, but the PS code wakes them up,
the driver will end up having to drop a packet, which isn't really good.
We really need to keep track, for each queue, who wants it
stopped/started and then only start the real queue if all the code
consents.

johannes

--=-HZPVAe/Tio0UaOP4Wg6S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJMG05AAoJEKVg1VMiehFYlikP/iZZfBEFtYA6EGqJtqKbN6hx
EkNEihX6H+fpydWZbeBT+GsAdDNyhW8duEXt/DCpLyj4vl7Mc7VLkx0C91Nb/gv0
Uo5bc35Ism3/JBVl+WwcEgEpNdBVasn88g9BCmQWRwIO9XdVpi+JL7Dv54OgPzcg
dahzqZPUNzUFzhIjqI3KCA6chjyEcef4LMGx+MO7G4uJ2x2/ng90jOYpgRzEO/J2
cpXpoAscFINGp1T9wDHmItqPxTdNwzRhnLmZryxPDXumA3WSwDeC63Y6X9GPcvt3
edKxrW9o0szz/D7/nFECkfCXzR6IjHLAV2E3RsHpdx6l0Rldg7//1dydpRu5V9fb
9tdKdO3IeqrWV5JRWskkavKl5elt3Q4aJre1AInQT5N+VmX+7xJuovLafv8WGcRc
aJ8jYfPVQNdLc0s+LaDn6ic64VDKN9+mq7XU0uK0sk4jMn65SJeFNYHq5rMWYFMS
UEY9gNnZ+kKoI/wU2bbNIL74ZWrhfpexZe1G3Dk7/w3BgxLdIn/sMAxCANZU7QOl
QQTKGvo4WyVRB4yTMgd9XxL92vPAsQYJjLCDk6QfzOhWLdZ/ZBOlkVKgFxorRyid
M0hJiZmzLSswsR4NeKWkic5VBmESUmIF+u89UwnIycTLIcfD6usndeXImwx4C9k7
gXQJBOQ4N1b0Q7u+DRCN
=yaiB
-----END PGP SIGNATURE-----

--=-HZPVAe/Tio0UaOP4Wg6S--

