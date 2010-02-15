Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab0BOJgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 04:36:40 -0500
Subject: Re: [PATCH 1/2] mac80211: Drop protected data frames that have not
 been decrypted
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr>
References: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lgvbqRY8s8PyzVyEtDj4"
Date: Mon, 15 Feb 2010 10:36:38 +0100
Message-ID: <1266226598.7084.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lgvbqRY8s8PyzVyEtDj4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-15 at 00:37 +0100, Benoit Papillault wrote:
> Fix for the following issue : a STA connected to a WPA2 AP was showing
> frames from others STA in tcpdump on wlan0 (promiscuous mode). In
> fact,
> those frames are not decrypted and appears as 802.3 junk. This patch
> just drops any protected data frames that have not been decrypted.
>=20
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> ---
>  net/mac80211/rx.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index c9755f3..22ae6ee 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1397,6 +1397,14 @@ ieee80211_drop_unencrypted(struct
> ieee80211_rx_data *rx, __le16 fc)
>  		     ieee80211_is_data(fc) &&
>  		     (rx->key || rx->sdata->drop_unencrypted)))
>  		return -EACCES;
> +	/*
> +	 * Drop encrypted frames that have not been decrypted. This
> +	 * happens for frames that are sent by an AP to another STA
> +	 */
> +	if (ieee80211_has_protected(fc) &&
> +	    !(status->flag & RX_FLAG_DECRYPTED)) {
> +		return -EACCES;
> +	}

Comment #1. The && part of the if is useless. Please find out why.

johannes

--=-lgvbqRY8s8PyzVyEtDj4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLeRWiAAoJEODzc/N7+Qma+XEQAJDdZVX2Seby6kYxX24pZI4E
LWLCyFNEUuu1Kcooq+DNLFScy1mjUlzX55uojCX2vNoDUUeZ7UzDoITtaViKt0iM
iGpDWW1p+7JicRZPtHo3WVv/oBdw4oEguN5Pcm+9BJGlx6rQA6fnyGkKbeqMgTtT
MgsLimQ9KmU2E2k9Msj+3t60cX2CUn0vlHkx5ap2BFW5npQnJdF8oC3GaL4JBui/
73e8ib4xtWwgMx0xBsXzTsunlMij02dsG9OnS6jGYIvkjCKIYJPL0hVxHG32fJwI
ikbZi7cxqSyFV65sideHi8pT1TbCO9BzYqQdZmRmk29LcIAxWRxgjOP+b4hGny5z
bUV9xnveRcACkq/JKcc6t/9UNOBgXzkdyY9aOOr46+QUpU53Mf5lJIFD6hebqIwG
dMxQaqzGETaR1F+LHfCr2QinBnjCaEv4+qPGhaOifE+HjcenvmPHxRvzyPtvKgDy
FPic2sOYC7mb8A54Tsf4T2c1ZqA4g1+Z4iYbVL1i401/x0m0bheHCog93QGFgna1
D5H0ZkaD5gAKgyXiYTHlbtAdB8lUIfwD09XDpOoS6lZyVHykOpRtYKVfFgT/DVos
akoAXZZYpfIR+Nbg58yExYu2KuUi75yVbTObMb7PVhYWGmi5bASs1evj+HxRVVZn
3mkSTlJfnvzVGKwDnUfi
=f5RC
-----END PGP SIGNATURE-----

--=-lgvbqRY8s8PyzVyEtDj4--

