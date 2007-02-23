Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214AbXBWUwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 15:52:51 -0500
Subject: Re: [PATCH] d80211: create net/wireless/Kconfig and make nl80211  optional
From: Johannes Berg <johannes@sipsolutions.net>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <45DF518B.5060809@linux.intel.com>
References: <45DF518B.5060809@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gSGXGuWy7O8c5U3nq6kv"
Date: Fri, 23 Feb 2007 21:52:35 +0100
Message-Id: <1172263955.3870.85.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gSGXGuWy7O8c5U3nq6kv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-02-23 at 12:41 -0800, James Ketrenos wrote:
> Move the wireless Kconfig options into their own wireless/Kconfig and
> add a CONFIG_CFG80211_NL80211 configuration option to allow nl80211
> support to be optionally included (default =3Dy)

I think this one is missing the changes in net/Kconfig.

And I should have looked closer before, sorry.

+config CFG80211
+        tristate "Improved wireless configuration API"
+        select WIRELESS_EXT

Why is that select WIRELESS_EXT? CFG80211 doesn't need that, d80211 does
and correctly selects it.

johannes

--=-gSGXGuWy7O8c5U3nq6kv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF31QT/ETPhpq3jKURApXHAJ9B8BYv8ZmBFOk7xIUNrPCd3IKisQCfRkQi
AMBEIZja4jqmSZrYrvxYaik=
=y7eG
-----END PGP SIGNATURE-----

--=-gSGXGuWy7O8c5U3nq6kv--

