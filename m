Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40484 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbXGRKNA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 06:13:00 -0400
Subject: Re: [PATCH] rtl8187: ensure priv->hwaddr is always valid
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200707172025.19979.mb@bu3sch.de>
References: <200707151709.55429.flamingice@sourmilk.net>
	 <1184578463.3773.1.camel@johannes.berg>  <200707172025.19979.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+/YJjTAa95g9IjTFADos"
Date: Wed, 18 Jul 2007 12:10:03 +0200
Message-Id: <1184753403.4658.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+/YJjTAa95g9IjTFADos
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-07-17 at 20:25 +0200, Michael Buesch wrote:

> I'd suggest changing this behaviour in the stack, as this bug will
> be made again for new drivers in the future.
> What about pointing mac_addr to a 00:00:00:00:00 const static mac address=
,
> instead of passing a NULL pointer?

I disagree. Having the if statement in the driver doesn't hurt and
neither does having a static zero mac address, but hardware that does
require special setup instead of a zero mac address would have to do
is_zero_etheraddr() or something to figure it out.

johannes

--=-+/YJjTAa95g9IjTFADos
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGneb7/ETPhpq3jKURAv/ZAJwJ0l6zcW+uOfUmCSIONzybqZZWkQCdHQ7f
bbyyIRO72rbovuheGuuwqJY=
=v+EO
-----END PGP SIGNATURE-----

--=-+/YJjTAa95g9IjTFADos--

