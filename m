Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51443 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664AbXBSVD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 16:03:26 -0500
Subject: Re: [PATCH 06/10] d80211: update for wiphy api
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <20070219214919.44838d97@griffin.suse.cz>
References: <20070215144241.847938000@sipsolutions.net>
	 <20070215144258.819563000@sipsolutions.net>
	 <20070219214919.44838d97@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-16x0p/hv6P9Sn+neTiIg"
Date: Mon, 19 Feb 2007 22:03:19 +0100
Message-Id: <1171918999.15489.18.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-16x0p/hv6P9Sn+neTiIg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-19 at 21:49 +0100, Jiri Benc wrote:

> Couldn't we just allow embedding of wiphy into a custom structure?
> Something like:
>=20
> struct ieee80211_hw {
> 	struct wiphy wiphy;
> 	...
> }
>=20
> This way the memory could become less fragmented and less pointer
> dereferencing would be needed.

Actually, if you look at the memory layout in ieee80211.c, struct
ieee80211_hw is part of the private area allocated along with the struct
wiphy, so it really is:

[internal stuff]
struct wiphy {
...
}
struct ieee80211_hw {
...
}

What we could do is add

static inline struct wiphy *priv_to_wiphy(void *priv)
{
	return container_of(priv, struct wiphy, priv);
}

to the net/wireless.h header. Then we could drop the wiphy field
completely.

johannes

--=-16x0p/hv6P9Sn+neTiIg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF2hCX/ETPhpq3jKURAqJMAJ9StYqmKcGcJTq7PwOkrPC5ZuNBMwCfYSY+
gdUyq+rgDrOI3aHFUYod/gk=
=wKQv
-----END PGP SIGNATURE-----

--=-16x0p/hv6P9Sn+neTiIg--

