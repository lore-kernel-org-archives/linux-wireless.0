Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934062AbXC1JP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:15:29 -0400
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and
	association
From: Johannes Berg <johannes@sipsolutions.net>
To: mohamed <mabbas@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wIMfIyG3etHfb6PJeo6P"
Date: Wed, 28 Mar 2007 11:14:17 +0200
Message-Id: <1175073257.5151.27.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wIMfIyG3etHfb6PJeo6P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-26 at 04:38 -0700, mohamed wrote:

> +	/* Get ht capabilities from the device */
> +	int (*get_ht_capab)(struct ieee80211_hw *hw,
> +			    struct ieee80211_ht_capability *ht_cap_param);
> +

Does this really need to return an error? And if so, what happens? You
currently send a blank HT capabilities IE but I think in that case it
should be left out completely. But I don't think it will ever return an
error, it doesn't even need to allocate memory. Just change this to
void?

johannes

--=-wIMfIyG3etHfb6PJeo6P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCjHp/ETPhpq3jKURAl8/AJwNKip6SCGze3HnwjOlxkSb6dA4fgCfTRQt
PMaCE9MPp3vj2hx1bvjSNts=
=ssDs
-----END PGP SIGNATURE-----

--=-wIMfIyG3etHfb6PJeo6P--

