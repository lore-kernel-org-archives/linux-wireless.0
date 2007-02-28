Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47504 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451AbXB1OvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:51:22 -0500
Subject: Re: [PATCH 14/28] rt2x00: Create rt2x00lib module
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702281507.13004.IvDoorn@gmail.com>
References: <200702281507.13004.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lOjoBJA9sc9Brh1Fyasb"
Date: Wed, 28 Feb 2007 15:50:56 +0100
Message-Id: <1172674256.5015.15.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lOjoBJA9sc9Brh1Fyasb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 15:07 +0100, Ivo van Doorn wrote:

>  config RT2X00
> -	bool "Ralink driver support"
> +	tristate "Ralink driver support"
>  	depends on NET_RADIO && MAC80211 && EXPERIMENTAL
>  	---help---
>  	This will enable the experimental support for the Ralink drivers,
> @@ -7,6 +7,10 @@ config RT2X00
> =20
>  	These drivers will make use of the Devicescape ieee80211 stack.
> =20
> +	This option will build the rt2x00 library which is required by
> +	each individual driver, when compiled as a module,
> +	this library will be called "rt2x00lib.ko".

I think I'd prefer having a new symbol CONFIG_RT2X00_LIB that is
selected by all sub-drivers that use it so that RT2X00 is a config-only
symbol.

Btw, you really need to use quilt or such, the Date: header line on
patch 8 is 6 seconds before patch 7 etc., they appear all out of order,
and having them as a reply to the 0/28 would be nice too.

johannes

--=-lOjoBJA9sc9Brh1Fyasb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5ZbQ/ETPhpq3jKURAgRbAJ4v2nbNMM5b1Zl2tmgumC8AQpML8wCfUcPu
WwfkGnizjcA1rC/Q59F153Y=
=+B0U
-----END PGP SIGNATURE-----

--=-lOjoBJA9sc9Brh1Fyasb--

