Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56345 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYFRHXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 03:23:07 -0400
Subject: Re: BUG: mac80211: Some connections hanging in 2.6.26-rc6...
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Price <andy@andrewprice.me.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <g38o2j$1uh$1@ger.gmane.org> (sfid-20080617_181742_447297_198DA5E5)
References: <g38o2j$1uh$1@ger.gmane.org>
	 (sfid-20080617_181742_447297_198DA5E5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RQtJy4eq9DIfVKvm8kVa"
Date: Wed, 18 Jun 2008 09:22:29 +0200
Message-Id: <1213773749.3803.155.camel@johannes.berg> (sfid-20080618_092312_001553_C7015F22)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RQtJy4eq9DIfVKvm8kVa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This also affects some http requests such as loading slashdot but not
> others (perhaps small ones?) such as twitter API http requests. It does
> not seem to affect connections to other machines on my LAN, only ones
> over the internet.
>=20
> I've tried tcpdumping to get more info but when I run tcpdump the
> connections work again (if a tiny bit slower).

Can you try tcpdump with the -p flag? promisc mode might affect things.

> I've bisected this bug down to 608961a5eca8d3c6bd07172febc27b5559408c5d
> "mac80211: Use skb_header_cloned() on TX path." and naively reverting
> this change seems to make the bug go away.

That's odd, and I can't find an explanation for it off-hand.

johannes

--=-RQtJy4eq9DIfVKvm8kVa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWLewAAoJEKVg1VMiehFYvL8P/1OtRRSEbKN+uVTNCfB3Thzf
V4sOT0U7Ku2bVjYfcfKrj5et6nrczA2KY7E2aetSkUAyI9tOzdDvyF1oQuBJ1TIA
T0AOl7NPz2qRgx4IiMA0MNR3iZdnd3+DSrx/7PjM+dvF8GZfJt3Z9k+ICGPrlUIJ
OjL0br9o71BCJ3BxRgdCM8mgs6ROD7FZPbqMJHbWqIxT/5nurJWxPIGVl7/3nGCW
RzszbM94vkW9zulVx3pCoMX30gvGx55f+OLE2jcVcI+87j313dGK4BsOO51ZnGdo
tlgOR/KOt19zBKn9Dq2FQb/XjpLLdIfZXsW3QPQstwXr0XWHzpbnCbCy7PRWJoUs
QFFhx4s+0FiJv6HMpMVbMvJgf4A31yzDfEnHXPNcRHsBW0PmJgdxXk3mBJbvvqsz
zckXjPPuj2nTeanrf9j2aBYA25Y8KOSqwFjvG2AMbxbR7KIFdiIyUR9PpqyQZWds
VadMmGQcxtnpGwlkx/k9kJGyv2mdqiPIry6cq2Hpgj9NknPkB8CAkpWd3xa2cI+p
+DM49U5/3QKj7NNc0IEkYNoiaONmto5W6XSLsguW8k9h4Ku+oSKPpxJxk02xXJR3
feUDfatrxobPKVh4z7SCxyPQOrCqccHhi80Y/cA0w2MO00cQnS43/0NcUtVGtF3R
y1mkseKcCorYlpoPEZld
=oEUs
-----END PGP SIGNATURE-----

--=-RQtJy4eq9DIfVKvm8kVa--

