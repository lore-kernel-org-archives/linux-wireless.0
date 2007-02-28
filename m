Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54372 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbXB1SgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 13:36:21 -0500
Subject: Re: [PATCH] rt2x00: split RT2X00 option
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702281926.38820.IvDoorn@gmail.com>
References: <200702281926.38820.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jnaW2/L474gF1+Ej2Ukf"
Date: Wed, 28 Feb 2007 19:35:56 +0100
Message-Id: <1172687756.5015.65.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jnaW2/L474gF1+Ej2Ukf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 19:26 +0100, Ivo van Doorn wrote:

> Make the debug(fs) config options depend on this new
> config option.

I like that.
=20
>  config RT2X00_DEBUGFS
>  	tristate "Ralink debugfs support"
> -	depends on RT2X00 && DEBUG_FS
> +	depends on RT2X00 && RT2X00_LIB && DEBUG_FS
>  	---help---
>  	Enable creation of debugfs files for the rt2x00 drivers.
>  	These debugfs files support both reading and writing of the

If you think hard about it, this also solves the problem of having
drivers built-in when the debugfs module isn't. But couldn't you just
link the debugfs module into the lib module instead of making it an own
module? I don't see any point in having it separate since there will be
a dependency anyway.

johannes

--=-jnaW2/L474gF1+Ej2Ukf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5cuL/ETPhpq3jKURArhzAJ97uK1NfHOJe/PFFEfEcdnzP9ys5gCfVGpy
ZUx9+qNEZkCbcb21JnOVrAw=
=ws3G
-----END PGP SIGNATURE-----

--=-jnaW2/L474gF1+Ej2Ukf--

