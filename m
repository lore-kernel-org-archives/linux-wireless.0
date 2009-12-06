Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:53672 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934047AbZLFSQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 13:16:30 -0500
Message-ID: <4B1BF4FF.2040707@web.de>
Date: Sun, 06 Dec 2009 19:16:31 +0100
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/5] ar9170: improve network latency
References: <200911290052.51819.chunkeey@googlemail.com>
In-Reply-To: <200911290052.51819.chunkeey@googlemail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE34110A77B4E95B1E2C8C9C5"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE34110A77B4E95B1E2C8C9C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Christian Lamparter wrote:
> AR9170 has the bad habit of choking when traffic builds up.
> Tests have shown that this can partially be attributed to
> a huge buildup of backlogged frames.
>=20
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> low priority.

I disagree about this classification. :)

I'm running your series for two days now on my ar9170-based AP, and
obviously this patch improved the "chokiness" under suboptimal reception
conditions greatly. No regressions noticed so far. Please merge.

Thanks a lot,
Jan

> ---
> diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wir=
eless/ath/ar9170/ar9170.h
> index d95a7d4..44c54b8 100644
> --- a/drivers/net/wireless/ath/ar9170/ar9170.h
> +++ b/drivers/net/wireless/ath/ar9170/ar9170.h
> @@ -152,6 +152,8 @@ struct ar9170_sta_tid {
> =20
>  #define AR9170_NUM_TX_STATUS		128
>  #define AR9170_NUM_TX_AGG_MAX		30
> +#define AR9170_NUM_TX_LIMIT_HARD       AR9170_TXQ_DEPTH
> +#define AR9170_NUM_TX_LIMIT_SOFT       (AR9170_TXQ_DEPTH - 10)
> =20
>  struct ar9170 {
>  	struct ieee80211_hw *hw;
> diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wirel=
ess/ath/ar9170/main.c
> index cbf59b1..3cec2f1 100644
> --- a/drivers/net/wireless/ath/ar9170/main.c
> +++ b/drivers/net/wireless/ath/ar9170/main.c
> @@ -430,7 +430,7 @@ void ar9170_tx_callback(struct ar9170 *ar, struct s=
k_buff *skb)
>  	spin_lock_irqsave(&ar->tx_stats_lock, flags);
>  	ar->tx_stats[queue].len--;
> =20
> -	if (skb_queue_empty(&ar->tx_pending[queue])) {
> +	if (ar->tx_stats[queue].len < AR9170_NUM_TX_LIMIT_SOFT) {
>  #ifdef AR9170_QUEUE_STOP_DEBUG
>  		printk(KERN_DEBUG "%s: wake queue %d\n",
>  		       wiphy_name(ar->hw->wiphy), queue);
> @@ -1716,6 +1716,21 @@ static void ar9170_tx(struct ar9170 *ar)
> =20
>  	for (i =3D 0; i < __AR9170_NUM_TXQ; i++) {
>  		spin_lock_irqsave(&ar->tx_stats_lock, flags);
> +		frames =3D min(ar->tx_stats[i].limit - ar->tx_stats[i].len,
> +			     skb_queue_len(&ar->tx_pending[i]));
> +
> +		if (remaining_space < frames) {
> +#ifdef AR9170_QUEUE_DEBUG
> +			printk(KERN_DEBUG "%s: tx quota reached queue:%d, "
> +			       "remaining slots:%d, needed:%d\n",
> +			       wiphy_name(ar->hw->wiphy), i, remaining_space,
> +			       frames);
> +#endif /* AR9170_QUEUE_DEBUG */
> +			frames =3D remaining_space;
> +		}
> +
> +		ar->tx_stats[i].len +=3D frames;
> +		ar->tx_stats[i].count +=3D frames;
>  		if (ar->tx_stats[i].len >=3D ar->tx_stats[i].limit) {
>  #ifdef AR9170_QUEUE_DEBUG
>  			printk(KERN_DEBUG "%s: queue %d full\n",
> @@ -1733,25 +1748,8 @@ static void ar9170_tx(struct ar9170 *ar)
>  			__ar9170_dump_txstats(ar);
>  #endif /* AR9170_QUEUE_STOP_DEBUG */
>  			ieee80211_stop_queue(ar->hw, i);
> -			spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
> -			continue;
> -		}
> -
> -		frames =3D min(ar->tx_stats[i].limit - ar->tx_stats[i].len,
> -			     skb_queue_len(&ar->tx_pending[i]));


--------------enigE34110A77B4E95B1E2C8C9C5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAksb9QIACgkQitSsb3rl5xR8dACguDMfImyUNfaxAS4KfQ2+3EmO
kbsAoNRuas7KgMPP7Ct6sR4+79FwMWxB
=cbVZ
-----END PGP SIGNATURE-----

--------------enigE34110A77B4E95B1E2C8C9C5--
