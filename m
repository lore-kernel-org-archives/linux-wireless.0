Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbZCYLIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 07:08:30 -0400
Subject: Re: [PATCH] mac80211: Fix bug in getting rx status for frames
 pending in reorder buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1237978407-5397-1-git-send-email-vasanth@atheros.com>
References: <1237978407-5397-1-git-send-email-vasanth@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QHwmMqGENglpM3wpCBSl"
Date: Wed, 25 Mar 2009 12:02:53 +0100
Message-Id: <1237978973.4320.154.camel@johannes.local> (sfid-20090325_120832_479623_5DD9EF97)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QHwmMqGENglpM3wpCBSl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-25 at 16:23 +0530, Vasanthakumar Thiagarajan wrote:
> Currently rx status for frames which are completed from reorder buffer
> is taken from it's cb area which is wrong, cb is not holding the rx statu=
s.
> This results in dropping almost all frames from reorder buffer when secur=
ity
> is enabled by doing double decryption (first in hw, second in sw because =
of wrong
> rx status). This patch copies rx status into cb area before the frame is =
put
> into reorder buffer. After this patch, there is a significant improvement=
 in
> throughput with ath9k + WPA2(AES).

Interesting. For ieee80211_rx_irqsafe() packets this is already in the
cb area.

I've been pondering for a while just requiring drivers to put it in
there to start with -- thoughts?

What's the case where the Rx status is NULL?

johannes

> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  net/mac80211/rx.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 64ebe66..5fa7aed 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -29,6 +29,7 @@
>  static u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
>  					   struct tid_ampdu_rx *tid_agg_rx,
>  					   struct sk_buff *skb,
> +					   struct ieee80211_rx_status *status,
>  					   u16 mpdu_seq_num,
>  					   int bar_req);
>  /*
> @@ -1688,7 +1689,7 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
>  		/* manage reordering buffer according to requested */
>  		/* sequence number */
>  		rcu_read_lock();
> -		ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, NULL,
> +		ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, NULL, NULL,
>  						 start_seq_num, 1);
>  		rcu_read_unlock();
>  		return RX_DROP_UNUSABLE;
> @@ -2293,6 +2294,7 @@ static inline u16 seq_sub(u16 sq1, u16 sq2)
>  static u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
>  					   struct tid_ampdu_rx *tid_agg_rx,
>  					   struct sk_buff *skb,
> +					   struct ieee80211_rx_status *rxstatus,
>  					   u16 mpdu_seq_num,
>  					   int bar_req)
>  {
> @@ -2374,6 +2376,8 @@ static u8 ieee80211_sta_manage_reorder_buf(struct i=
eee80211_hw *hw,
> =20
>  	/* put the frame in the reordering buffer */
>  	tid_agg_rx->reorder_buf[index] =3D skb;
> +	memcpy(tid_agg_rx->reorder_buf[index]->cb, rxstatus,
> +	       sizeof(*rxstatus));
>  	tid_agg_rx->stored_mpdu_num++;
>  	/* release the buffer until next missing frame */
>  	index =3D seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn)
> @@ -2399,7 +2403,8 @@ static u8 ieee80211_sta_manage_reorder_buf(struct i=
eee80211_hw *hw,
>  }
> =20
>  static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
> -				     struct sk_buff *skb)
> +				     struct sk_buff *skb,
> +				     struct ieee80211_rx_status *status)
>  {
>  	struct ieee80211_hw *hw =3D &local->hw;
>  	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
> @@ -2448,7 +2453,7 @@ static u8 ieee80211_rx_reorder_ampdu(struct ieee802=
11_local *local,
> =20
>  	/* according to mpdu sequence number deal with reordering buffer */
>  	mpdu_seq_num =3D (sc & IEEE80211_SCTL_SEQ) >> 4;
> -	ret =3D ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb,
> +	ret =3D ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb, status,
>  						mpdu_seq_num, 0);
>   end_reorder:
>  	return ret;
> @@ -2512,7 +2517,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct=
 sk_buff *skb,
>  		return;
>  	}
> =20
> -	if (!ieee80211_rx_reorder_ampdu(local, skb))
> +	if (!ieee80211_rx_reorder_ampdu(local, skb, status))
>  		__ieee80211_rx_handle_packet(hw, skb, status, rate);
> =20
>  	rcu_read_unlock();

--=-QHwmMqGENglpM3wpCBSl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyg9bAAoJEKVg1VMiehFY/L4QAJUz2bthfPIa4sZ7zi8wuI4f
KXdKKE4T9+eD4YnXvTRrsK923ezyafzmmNVFEbrmIj8S0G/Gsas4bkw8LYw6AFqW
MXch6fPOrziSJja5iS6J9P4tEkZTiRsUaPJ4iKD4hN9Ol/unNh1WNIGQGk2ygyu6
dUrLJaMCrSZG5DK1zEU+oPOfwPZYJwrNvZAEyW4eEpRMh+/GXvsTuDnAM2fHoFzv
VDBOSpx1+mfuppQuioxiwQwuEau2AnvEJTpWTXxC/jeSeTSKwH3sFVxEmkIpqHuU
7vhp36SfAdRpriEYaNF/V2vghFJZPnw/CjDGA4ofm+A1rEf6dObRI4t2WEaD0MED
kpqCls9nqRETuYRVj2m0+A2iPrxNZ0bz3kPs58jO9dTZubYY5d6Mt2uzRvlIC7si
ryxewMivkAxpbry5QIv9A30wlh6izxYCb8M+yoSYn8+wIG3fkV3vmz8rogjzhdQ2
UbbfWlgum1uXmRDmOPsvztNZa3udIUqSBXCl/ejNOcEBlijc7Ij0shkVBXhTGwrE
Gf3JX6eT6dtpzy5cwrUZMGiQFI3OZUb/NAmbWW130c/W2xBXOkdMMj0MIh7FjNSF
4jWVV+pJvPmQDaaFS4vRJrNMk8oj161Ttr3DW6hwHTJwbeCFwKoFU+QlRQBBs+Ly
YS+Tv05mzmNHes4p1MBY
=bZM8
-----END PGP SIGNATURE-----

--=-QHwmMqGENglpM3wpCBSl--

