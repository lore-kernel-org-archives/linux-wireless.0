Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762143AbZC3WJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 18:09:27 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <1238406057.24972.23.camel@johannes.local> (sfid-20090330_114105_983781_83388221)
References: <1238349195.24972.5.camel@johannes.local>
	 (sfid-20090329_195345_745378_2F2074B3)  <1238406057.24972.23.camel@johannes.local>
	 (sfid-20090330_114105_983781_83388221)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FwOSINpEgxVuGMrzrqaw"
Date: Tue, 31 Mar 2009 00:08:54 +0200
Message-Id: <1238450934.5970.55.camel@johannes.local> (sfid-20090331_000943_320116_AF1C5069)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FwOSINpEgxVuGMrzrqaw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 11:40 +0200, Johannes Berg wrote:

>  * tosa - done now in new patch, but not even compile-tested
>    (http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-rfkill=
-rewrite.patch)

One problem here remains -- the LED trigger name was forced to be
"tosa-bt" in that code -- that is no longer possible now that struct
rfkill is opaque. I think we should simply standardise the name to
something like
	"<rfkill-name>-radio"

Thoughts? I don't want to call it <..>-rfkill or rfkill-<..> because
that would seem to imply inverted polarity.

johannes

--=-FwOSINpEgxVuGMrzrqaw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0UL0AAoJEKVg1VMiehFY+kEP/AqbA7G9cL9TCZchQ4dIncJK
dB/IEm2undCsPzljvA++OGqlIAPGQehBcRkLKWh9Rg2SsmwMCjDL5NNAMBLWAciP
cpr0/GgyycVeF0Y9LKVA1VgdS6tne3K/496Vth+4XmnSDM29jEZ14k4DEP8ZLn0W
SnVfeCYn9gSWTlDPsJw+0dO1o61v4BTgoBxArnoN8E+bPoBBInG9v6QEYiNjyvXe
a7Kz3xx7yzkGuDtwK+v+IcyYTDkl7C7onyqSR+QHgbv1JpsIdGts/xza0Je6H5xF
BixhD+E2WBnE79jqHv0u3lAQI3zbRtNhdvCnKuwfJm1bOdC2zkwBidU3wlX6iyyx
QBu85llR8cnAum7m1WuUm3tV0kyZLge4rvFVhcE6yfTts6rjEXdCljCD+3oVMYpo
c7fxB4E4X2J//+TjY47XA2q/rrWEs9HQlX18mnbFXpo4cQOiaAZ9TftpahT2X8OA
mZibSg2x2OiCGA56dSgZ00O2Hoqxga9G/xsMmgnGTW4ZHzRw/4t8b/VhB1Iza9Js
PHjl5wlfcQ2xDNbl3vm9NF1kWgwMED+7wg9ecuI0GfUEOktuapITHzIoV4wSgJDC
YjxUoaffnTr6oRRYFFozQNQ/7fBKg62wpa9ZCTAknwlLdqbXO7NW7jFHTOkEa1do
gyY71WEHrexP+iXPN6Jd
=sUrH
-----END PGP SIGNATURE-----

--=-FwOSINpEgxVuGMrzrqaw--

