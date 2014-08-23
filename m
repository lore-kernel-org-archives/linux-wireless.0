Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53080 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbaHWTVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 15:21:42 -0400
Message-ID: <1408821688.4672.108.camel@deadeye.wl.decadent.org.uk> (sfid-20140823_212145_662666_C8694E7D)
Subject: reglib bugs
From: Ben Hutchings <ben@decadent.org.uk>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Sat, 23 Aug 2014 12:21:28 -0700
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-IUTbH2K3oTDVZ7EutxMQ"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IUTbH2K3oTDVZ7EutxMQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Some simple bugs I found by inspection:

- reglib_parse_country_dfs() always overflows the alpha2[] array by one
byte as sscanf() will write a terminating null byte.

- reglib_parse_country_dfs() can overflow the dfs_region_alpha[] array,
given invalid input.  If the input is always trusted then this may not
matter.

- reglib_deduce_band() can never return 60 (GHz) as the 5 GHz condition
will have been matched already.

- reg_rule_optimize_rd() has a bounds check on rule_idx but it's
off-by-one.

Ben.

--=20
Ben Hutchings
One of the nice things about standards is that there are so many of them.

--=-IUTbH2K3oTDVZ7EutxMQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU/jpvee/yOyVhhEJAQoQJA/+KhoIHMDcEPZQ4cHEeWONRQEO4QK8aqQu
vuvaZj9awiHc5p2dbxXuTalVIE3SLwzxxU69waZiu+pL/UG6wONCj1827rgQN9bu
iRD3wfj2Z+gU/rYEUB9XvC3nW5NKrB7t+EXvvkuCEr5yTWwB5FvzRXPnJLiIlEaH
MMCHZv0rH6Kwo2A/f7MVsCHyyjLGE81jwE5/DGMbOw9lIRF/wbIm631XWY8gZLU2
XWGDYlS4+LQ9IGuuWQwm633agADmzFETktL6+48DkTxmdW9G0J7wa2zAewLz9x/C
h6jZHtLgl48/W51RuiqM359HdtdwjTz5uAkZ77tgRXsJk+D90tHAz4DrzXWUMGd7
Lzwk8x+sHEuN4411JFwDONbIXDs8dE24z7UdjXJgFcJHpMJ7YugFTQ2JeBFPhSaY
+ARoAypwm92sjFNEh3MVwn6RrGrjBrNvMbU7OEQ6CovRwhrAqPsvLEZP719Ut1v6
obHqwS4GQfUsah6CZhbSPCTQIqweVGoCl6P7CGzE2gr1Y1fomwEbQm/dbGsfGIoQ
gcm53OnD16afhL6NjuBrqe07Qs06kXattafSJf9BOBU7stwIYCWdSMN4VUdYFVNR
ACMOUei0kW3R2zoyxPDA1EFsfRo0xbD33+E8TV+ZY34Ql7Flz443hqDkDZDfht9J
cb9z7nXDPCs=
=BFhR
-----END PGP SIGNATURE-----

--=-IUTbH2K3oTDVZ7EutxMQ--
