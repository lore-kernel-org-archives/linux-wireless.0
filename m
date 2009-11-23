Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41027 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbZKWXXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 18:23:24 -0500
Subject: Re: [PATCH v2 7/8] mac80211: Add define for TX headroom reserved
 by mac80211 itself.
From: Johannes Berg <johannes@sipsolutions.net>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <1259012694-14869-8-git-send-email-gwingerde@gmail.com>
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-2-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-3-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-4-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-5-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-6-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-7-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-8-git-send-email-gwingerde@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rsK7hFmPz6Fv+WYTGixB"
Date: Tue, 24 Nov 2009 00:22:36 +0100
Message-ID: <1259018556.7094.186.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rsK7hFmPz6Fv+WYTGixB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-23 at 22:44 +0100, Gertjan van Wingerde wrote:
> Add a definition of the amount of TX headroom reserved by mac80211 itself
> for its own purposes. Also add BUILD_BUG_ON to validate the value.
> This define can then be used by drivers to request additional TX headroom
> in the most efficient manner.
>=20
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>

That makes more sense to me, thanks.

johannes

> ---
>  include/net/mac80211.h |    6 ++++++
>  net/mac80211/main.c    |    2 ++
>  2 files changed, 8 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 3754ea4..a113458 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1727,6 +1727,12 @@ static inline void ieee80211_rx_ni(struct ieee8021=
1_hw *hw,
>  	local_bh_enable();
>  }
> =20
> +/*
> + * The TX headroom reserved by mac80211 for its own tx_status functions.
> + * This is enough for the radiotap header.
> + */
> +#define IEEE80211_TX_STATUS_HEADROOM	13
> +
>  /**
>   * ieee80211_tx_status - transmit status callback
>   *
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index dd8ec8d..f35d4aa 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -515,6 +515,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  	 * and we need some headroom for passing the frame to monitor
>  	 * interfaces, but never both at the same time.
>  	 */
> +	BUILD_BUG_ON(IEEE80211_TX_STATUS_HEADROOM !=3D
> +			sizeof(struct ieee80211_tx_status_rtap_hdr));
>  	local->tx_headroom =3D max_t(unsigned int , local->hw.extra_tx_headroom=
,
>  				   sizeof(struct ieee80211_tx_status_rtap_hdr));
> =20


--=-rsK7hFmPz6Fv+WYTGixB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLCxkyAAoJEODzc/N7+Qma8W8QAJghed+Wk4SMq0jeCjOYFlfh
3tsnuN3i9CB8kigLDMuwm9kPvCIah22R5AXDQMseqmfjNtnyGgThnkz5OihVLent
Uk/fOv+A7Qao7JDcoehfmyG8/i3YKqeN2VOJMzQv2l/J3FIZRx0jMTA6/BruRqPW
JM6EoY/YHi4tH720M7YCj1+lCaPbFis9wZPPAcNH3N/LKxQGZrXQWncwVTmf/9yA
rzLhow6WJrAFRrXIzOYfjvOhQLvC3gWTK75vTtoXMasokbLylUHv+1bDfTLwIUUP
3ORRSP+XT43Za2c5lKLGvm3Gb72zncAMSMFapTMCEzRQ2WhjSXX7tKE6BVJrDA42
IPzuS8F4JY2gxOQCOC3P78LDb3prOYohaXfQy4zOft9Sdvy86v298EsvqJNrIgcB
uEgqeM3K59yIXXh+NWUmPG3RXjhcEUCMb3Q/NX2WPnTcYhlMnVo+xVAf1b+0cem8
ODkPLICNdfvkJb97ULd63vO6oLiS5qfWM43WQCcE8AVPXpopm5bl6uRrLYXZSp8c
l1hEZthPI7IzklwT7Hbs9eYb1Lm/0GQGXOi+VsqLragRc7P4hIOezK+ceSExoBvt
4fewhLucEjq1Se/A5Vc6K+zO6zOSXs3d8eafGgSjM/ReWN/0NfXHY0Oe+tQ9fVlS
VsSNqUA1A99/wbRE2mcb
=L6qF
-----END PGP SIGNATURE-----

--=-rsK7hFmPz6Fv+WYTGixB--

