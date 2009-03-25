Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37647 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZCYMRa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 08:17:30 -0400
Subject: Re: [PATCH V2] mac80211: Fix bug in getting rx status for frames
 pending in reorder buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1237982651-6761-1-git-send-email-vasanth@atheros.com>
References: <1237982651-6761-1-git-send-email-vasanth@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DPN/aVhmsxBruhAxPjKw"
Date: Wed, 25 Mar 2009 13:16:48 +0100
Message-Id: <1237983408.4320.159.camel@johannes.local> (sfid-20090325_131734_761136_1F254538)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DPN/aVhmsxBruhAxPjKw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-25 at 17:34 +0530, Vasanthakumar Thiagarajan wrote:
> Currently rx status for frames which are completed from reorder buffer
> is taken from it's cb area which is not always right, cb is not holding
> the rx status when driver uses mac80211's non-irq rx handler to pass it's
> received frames. This results in dropping almost all frames from reorder=20
> buffer when security is enabled by doing double decryption (first in hw,=20
> second in sw because of wrong rx status). This patch copies rx status int=
o=20
> cb area before the frame is put into reorder buffer. After this patch,=20
> there is a significant improvement in throughput with ath9k + WPA2(AES).
>=20
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

I'll look at putting it there in the drivers right away for .31, this
should probably get a Cc: stable@kernel.org too.

johannes

> ---
> v2
> ---
> As issue lies only in non-irq rx handler path, change
> the commit log accordingly.
>=20
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

--=-DPN/aVhmsxBruhAxPjKw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyiCtAAoJEKVg1VMiehFYkucP/RYRXtQ5NCDLNKVbWJi24WbG
Z4q4SemQeoGxy8x6zTMFQHAYbXTC2LCxy6daGXv2Y9YCARA1dqU/Nf3KWdWUfhrd
nkZ2MOONNKe2nzdqZSZyFeFeVPqp7Jzt4HXenx/jD1lRRTpkGyXGOu9+Q5G3kIly
u5EPbskd1DsYTMgMhiGY/wd6DIBgl4czv0xkQlU02Z9O/rYybVor901xUpTBH4YA
Q9m4GOxioBRogLQqaxUdd1NVBAhEEPasK6fzSirRJ+/X9DCb+pgyuVecpDbKMcbG
E+tVEo8zUplpvY/QFq1beqmK7ldtbIL6EFsEEXQoq8eSHYee2eP1SQt2Yvl8a5qC
weeiGXeiVbUAYoeNVzm4bke2OPQ7L4MQAwEqWEf4L40TFqw0bt7BkvFwp3SPcn9a
/ovDvH4p4Gjb6e9okn+k3IvOZMkcAxGB0SN3wV350ZMB2BoFTxkhCvPTl5rGzSqZ
q5NP8QHKkXBGjmlbD+yBJTHZGxAnW6CzIUU3zOLF7Q1kxW0MoXFngKfxGChYsP3h
BRIaw8P4vHjlSqd/nSYL613BP1U2HIkjzWtOg1jCPKOuwWYqwfC5pj7qJwV4Z0sC
opfaZdq4wWEzHD5BBVYHXlYkO+/0ZhRHNqYGzKczUbogYgHVQWlJyuUloexBj2OI
h24ErxsnD6xy9+B6Ia3z
=sIEh
-----END PGP SIGNATURE-----

--=-DPN/aVhmsxBruhAxPjKw--

