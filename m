Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbYFUMA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2008 08:00:27 -0400
Subject: Re: [PATCH] mac80211: Let drivers have access to TKIP key offets
	for TX and RX MIC
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080621115133.GI17936@ruslug.rutgers.edu>
References: <20080621115133.GI17936@ruslug.rutgers.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Cf9HXchGqS3lL4coq+la"
Date: Sat, 21 Jun 2008 14:00:13 +0200
Message-Id: <1214049613.8967.243.camel@johannes.berg> (sfid-20080621_140054_754883_4873B020)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Cf9HXchGqS3lL4coq+la
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-06-21 at 07:51 -0400, Luis R. Rodriguez wrote:
> Some drivers may want to to use the TKIP key offsets for TX and RX
> MIC so lets move this out.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  include/net/cfg80211.h |    5 +++++
>  net/mac80211/key.h     |   37 ++++++++++++-------------------------
>  2 files changed, 17 insertions(+), 25 deletions(-)
>=20
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index e007508..6cb8b02 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -12,6 +12,11 @@
>   * Copyright 2006, 2007	Johannes Berg <johannes@sipsolutions.net>
>   */
> =20
> +/* Starting offsets for each key for TKIP */
> +#define ALG_TKIP_TEMP_ENCR_KEY		0
> +#define ALG_TKIP_TEMP_AUTH_TX_MIC_KEY	16
> +#define ALG_TKIP_TEMP_AUTH_RX_MIC_KEY	24

put it into nl80211 and give it proper namespace prefixes, please.

> -/* ALG_TKIP
> - * struct ieee80211_key::key is encoded as a 256-bit (32 byte) data bloc=
k:
> - * Temporal Encryption Key (128 bits)
> - * Temporal Authenticator Tx MIC Key (64 bits)
> - * Temporal Authenticator Rx MIC Key (64 bits)
> - */

and why remove the comment? There's a small comment in nl80211.h but it
could be described in more detail.

johannes

--=-Cf9HXchGqS3lL4coq+la
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIXO1JAAoJEKVg1VMiehFYAyMQAMVDRB9tRzg3x6T2K5N+3BON
dlArqqDs/vs5fwyrh34GLbuDSSsbZRo17pr2H0vy7gq9gNdAiKYapEGXuCM7WBg4
bTL0Sghsnd50J7Mf0YDXjPbtPPl22V91UMldjnCkrpoH37NTYwgLqFZIlaDhxREV
gt6EggCWJyw7tSWtSSURXEFsbFExXN6XiXk4vI2Lk8FDBoQ/k9wVnnIXG7XamYYs
Pk6JI3qz7Va8IyewVJGOr4bbb/OvEhZZ5foTkioT750yLrChfegjFxtNpindEVC9
fzbAnZNAs3sZdQIzE9RmfFDKmbQyGrvX2ucVUtHz5AVXCZGTaviHh5HYP73z9CA/
Jf7Qv730iWaWWvEaNArOIA53bjeJpzbhSP/jfwKHF8/fe3fv/O3EQyGeQkOIbCvS
f3p668FiIpA5Cw16yqhfJHJ6NB8QhSNYY98rz9D4Ovc5NBM+mmaxPUFYHw1h7+c4
Nk57j1XyPuYQPvZuTkQ3nEkOuMCi/GLBrYwTGyagwkUZD1/M/sNRshKZQFozesGX
AY4oAb6z2t8YPpVSoBtM0uuL4BOWY1Vk47dfKa8p0AGBM5ENTBvG36wUDmk2kury
covylhwbinGQJOEUeeFuNA0wX12js1UVu9eMfWUgKApXqPTBY+lzDo7J/q1e/nI+
M9wEujMyHSX8JbwKBa0+
=Isn2
-----END PGP SIGNATURE-----

--=-Cf9HXchGqS3lL4coq+la--

