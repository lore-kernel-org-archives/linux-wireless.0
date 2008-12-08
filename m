Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36622 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYLHTp4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 14:45:56 -0500
Subject: Re: [PATCH 1/2] Add signal strength and bandwith to nl80211station
	info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Henning Rogge <rogge@fgan.de>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812071917.07075.hrogge@googlemail.com> (sfid-20081207_192143_969753_347089B0)
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812071832.20533.hrogge@googlemail.com>
	 <1228671578.22164.48.camel@johannes.berg>
	 <200812071917.07075.hrogge@googlemail.com>
	 (sfid-20081207_192143_969753_347089B0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VfFRLUc+RoRz7QuZqKGG"
Date: Mon, 08 Dec 2008 20:43:35 +0100
Message-Id: <1228765415.22164.107.camel@johannes.berg> (sfid-20081208_204559_525275_3021B3DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VfFRLUc+RoRz7QuZqKGG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-12-07 at 19:17 +0100, Henning Rogge wrote:

> + * @NL80211_RATE_INFO_LEGACY: bitrate for 802.11abg (u16, 100kbit/s)

Your other patch named this _TOTAL, can you rename it to _BITRATE
instead?

> +	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)) {
> +		struct ieee80211_supported_band *sband;
> +		sband =3D sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->ban=
d];
> +		sinfo->txrate.legacy =3D sband->bitrates[sta->last_tx_rate.idx].bitrat=
e;
> +	}
> +	else {
> +		sinfo->txrate.mcs =3D sta->last_tx_rate.idx;
> +	}

Put the else on the same line as the closing brace, please.

> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -14,6 +14,7 @@
>  #include <linux/nl80211.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/netlink.h>
> +#include <net/mac80211.h>
>  #include <net/genetlink.h>
>  #include <net/cfg80211.h>
>  #include "core.h"

That has to go.

And on your second patch:

> +static u16 nl80211_calculate_bitrate(struct rate_info *rate)
> +{
> +       int modulation, streams, bitrate;
> +
> +       if (!(rate->flags & RATE_INFO_FLAGS_MCS))
> +               return rate->legacy;
> +
> +       modulation =3D rate->mcs & 7;
> +       streams =3D rate->mcs >> 3;

I don't think this gives correct results for MCS rates 32 through 76,
does it? It should at least not calculate anything then. If we did it in
userspace then programs could also actually calculate the correct rate
as a float, rather than this approximation. Not that it'll matter, I
guess. Doesn't anybody know how to do the actual calculation?

johannes

--=-VfFRLUc+RoRz7QuZqKGG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPXjbAAoJEKVg1VMiehFY0MQP/RFCUlDXHzA8MH+fSjHPRSvi
BinqjQkvkjFsfv8VCm9QOXJX8Xo9bMdzllAGHRpx0iDrmUlOrPVmvkOO4JvC9HDG
15OP7EVKK+l48Fu397xrcK5COGB6xJiXZaqL7Fhh+dUXamWE6vmuOwcQOprTTNhE
bqioDC37KReV1/45+n1HyxFfSrnWl/ccK7OhgGJ5hmBo9AO8F8jSypm3JOLaEQKx
KLWlcwbngBZTRx+RIF189F4oKtAhTL283VSfcQszftDorKJrlcfN07uX1dngdtgM
lxThOxxryNEQuFWlm8Uc5QXUKj5c1KgfKoNhH4UHcjfXkLJyFoYV96j6qG8P+aqU
Xn4xSAyd6r1+/EuLbCbbUpITOpi/j/8QNOf10gZZNIOQ6ZifhLEA+7RaEXyxvvAG
cWjF1CSk6LXResnO3w5yqLzZvuOr18kMTTgIzHnxxHbCx/Zdh35PriYrUNLTkkTg
G5pGLvJAvwdRjM7auVljp4oMLzYT/dU20Ap/ERuBPEBeN+8EXcERRPCZjMpPjyFC
59T/TyC+SSFQOxn3qGfEXUv0hDiYwCWV4f06Uj8QcUmKQ8J3rFmbuy3gi8YK/pYl
HZuuwFbe6X808+GkrQfj1FtKxTOAGjqlJADjYpPyikAU8/uFlHk+Ws+qZH2u0nwY
CSMLWRQvnaH65jeprHkn
=pzp4
-----END PGP SIGNATURE-----

--=-VfFRLUc+RoRz7QuZqKGG--

