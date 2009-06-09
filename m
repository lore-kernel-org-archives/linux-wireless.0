Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbZFIIyr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 04:54:47 -0400
Subject: Re: [PATCH 1/3] mac80211: fix - drop frames for sta with no valid
 rate
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, j@w1.fi, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
In-Reply-To: <1244536211-22535-2-git-send-email-lrodriguez@atheros.com>
References: <1244536211-22535-1-git-send-email-lrodriguez@atheros.com>
	 <1244536211-22535-2-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cjs2sTXif+oXdu/JfkTW"
Date: Tue, 09 Jun 2009 10:54:11 +0200
Message-Id: <1244537651.4672.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cjs2sTXif+oXdu/JfkTW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-09 at 04:30 -0400, Luis R. Rodriguez wrote:
> If we're associated and scanning mac80211 will allow through
> nullfunc and probe request frames. When we're scanning on a
> different band than the one we're associated on we should
> not send nullfunc frames to the sta on that band as it would
> be the incorrect band.
>=20
> Lets catch the case where no valid rate is usable when associated
> and discard those frames and warn only for the case the frame is
> not a nullfunc or probe request as those are the only accounted
> for frames mac80211 should allow through while scanning.
>=20
> This fixes an oops which occured due to an assert in ath9k:
>=20
> http://marc.info/?l=3Dlinux-wireless&m=3D124277331319024
>=20
> The assert was happening because the rate control algorithm
> figures it should find at least one valid dual stream or
> single stream rate. Since we allow mac80211 to send get_rate
> callback for drivers for a sta on invalid band no valid will
> actually have been found and hence the assert.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  include/net/mac80211.h |   11 +++++++++++
>  net/mac80211/tx.c      |   38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 49 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 17d61d1..9559efa 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2103,6 +2103,17 @@ rate_lowest_index(struct ieee80211_supported_band =
*sband,
>  	return 0;
>  }
> =20
> +static inline
> +bool rate_usable_index_exists(struct ieee80211_supported_band *sband,
> +			      struct ieee80211_sta *sta)
> +{
> +	unsigned int i;
> +
> +	for (i =3D 0; i < sband->n_bitrates; i++)
> +		if (rate_supported(sta, sband->band, i))
> +			return true;
> +	return false;
> +}
> =20
>  int ieee80211_rate_control_register(struct rate_control_ops *ops);
>  void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 1436f74..03f9a4e 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -511,6 +511,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx=
)
>  	int i, len;
>  	bool inval =3D false, rts =3D false, short_preamble =3D false;
>  	struct ieee80211_tx_rate_control txrc;
> +	u32 sta_flags;
> =20
>  	memset(&txrc, 0, sizeof(txrc));
> =20
> @@ -543,7 +544,44 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *t=
x)
>  	     (tx->sta && test_sta_flags(tx->sta, WLAN_STA_SHORT_PREAMBLE))))
>  		txrc.short_preamble =3D short_preamble =3D true;
> =20
> +	sta_flags =3D tx->sta ? get_sta_flags(tx->sta) : 0;
> +
> +	/*
> +	 * Lets not bother rate control if we're associated and cannot
> +	 * talk to the sta. It makes little since for this to happen,
> +	 * it should mean we're scanning on another band somehow some frames
> +	 * got through the TX queue -- these should have been not been added
> +	 * to our TX queue. There is one excemption to this, but we handle
> +	 * these below.
> +	 */
> +
> +	if (unlikely((tx->local->sw_scanning) &&
> +	    (sta_flags & WLAN_STA_ASSOC) &&
> +	    !rate_usable_index_exists(sband, &tx->sta->sta))) {
> +		/*
> +		 *  The only accounted for frames of this type in
> +		 *  mac80211 are probe requests and null func frames,
> +		 *  so just warn for other drop of frames. Drop the
> +		 *  frames anyway as we have no usable bit rate.
> +		 */

Can we not avoid this situation to start with by flushing the master
device queues before we go scan?

johannes

--=-cjs2sTXif+oXdu/JfkTW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKLiMsAAoJEODzc/N7+Qma3VAQAJZelhyRwrGBHULeMo56lcR6
kv4fLDF+ymSViLMUzSAs190yJXdqGqQL7IBF6mLBPEpBMB2ENVX7qrKNHoL4IXlA
/vCOaY7y4xP58h5DXCZGHiJN0KOH9XOAo3gmwbPGFM8xOjxUDUisevckp09VD9Px
3DSll8OR7J+MEZ/Fop+rD90CqfyaguA+cLn4D8KJy/ulfE1WJsVS+CAFC+CxTXOS
FdnV9no7dqp7ZMdPwV2TlbJ5yn3WoNr+XM8LQPCj0scSpeT42xhREX1j81sDU70I
9siymvyriH8IakrOZKozqfYTnNdfqgTxHRrfRkWIMVS8/UcGkt3u3oFssbfrYhFH
Lhw8b7qOvFL9EkMj+n3fVeCV1uWZfL9r6052GhDpzfsX5qRQILzQo+OuePbKn8Su
arIFMatFpxuXpZuPVY0fOnpy/y+fuxZvRfWKAT3buMTxLdcZrkzBsVNq2SYXQfC7
CZalA26N/GsxwzB3FdJkSOGnPPKFIpDkAg18tXkknS+jMzlbqPBCoVQKbF3Tu9Ry
ebZdqvluJevB2k1lgnZ7Zzx92ZIZpJ87cQYxk/HmE6R7tlvZDQsss/W//rp74ek6
Dqm6Lmb8+GNl2zr8msyODXs1eix0i10hi+Z+RGRHrLUBBNj9HhP+nL+uAEs+HgCK
OsU3I5tDqNac095GJQ9s
=NpOw
-----END PGP SIGNATURE-----

--=-cjs2sTXif+oXdu/JfkTW--

