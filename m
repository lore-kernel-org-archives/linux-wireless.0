Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:48557 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933978AbZLFS1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 13:27:13 -0500
Message-ID: <4B1BF68D.8060907@web.de>
Date: Sun, 06 Dec 2009 19:23:09 +0100
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFT] ar9170: AP broadcast buffering
References: <200911290206.07784.chunkeey@googlemail.com>
In-Reply-To: <200911290206.07784.chunkeey@googlemail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD0D1C8999B8DA94CFCF3144B"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD0D1C8999B8DA94CFCF3144B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Christian Lamparter wrote:
> This patch should fix "broadcast traffic before DTIM beacon",
> But there is a downside: the broadcast (e.g arp) frames
> might get delayed and won't make it in time.
>=20
> let me know, if this patch does any good, or not...

Mmm, how is this supposed to work? I still haven't started hacking on
this as well, but I read a bit about DTIM. One thing I think to have
understood is that the DTIM interval is typically larger than the beacon
interval. There is even some interrupt on ar9170 indicating this event,
it's just not enabled yet.

Moreover, I do not yet understand how deferring multicast frames works
in this patch. How are they filtered out from normal frames and queued
until the beacon event? (But that misunderstanding might be due to the
fact that I haven't read the whole driver code yet.)

Jan

> ---
> diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wir=
eless/ath/ar9170/ar9170.h
> index b99a8c2..c3d1349 100644
> --- a/drivers/net/wireless/ath/ar9170/ar9170.h
> +++ b/drivers/net/wireless/ath/ar9170/ar9170.h
> @@ -176,6 +176,7 @@ struct ar9170 {
>  	/* beaconing */
>  	struct sk_buff *beacon;
>  	struct work_struct beacon_work;
> +	struct work_struct cab_work;
>  	bool enable_beacon;
> =20
>  	/* cryptographic engine */
> @@ -278,6 +279,7 @@ int ar9170_set_basic_rates(struct ar9170 *ar);
>  int ar9170_set_hwretry_limit(struct ar9170 *ar, u32 max_retry);
>  int ar9170_update_beacon(struct ar9170 *ar);
>  void ar9170_new_beacon(struct work_struct *work);
> +void ar9170_send_buffered(struct work_struct *work);
>  int ar9170_upload_key(struct ar9170 *ar, u8 id, const u8 *mac, u8 ktyp=
e,
>  		      u8 keyidx, u8 *keydata, int keylen);
>  int ar9170_disable_key(struct ar9170 *ar, u8 id);
> diff --git a/drivers/net/wireless/ath/ar9170/mac.c b/drivers/net/wirele=
ss/ath/ar9170/mac.c
> index 857e861..805b4f4 100644
> --- a/drivers/net/wireless/ath/ar9170/mac.c
> +++ b/drivers/net/wireless/ath/ar9170/mac.c
> @@ -463,7 +463,6 @@ void ar9170_new_beacon(struct work_struct *work)
>  {
>  	struct ar9170 *ar =3D container_of(work, struct ar9170,
>  					 beacon_work);
> -	struct sk_buff *skb;
> =20
>  	if (unlikely(!IS_STARTED(ar)))
>  		return ;
> @@ -475,6 +474,24 @@ void ar9170_new_beacon(struct work_struct *work)
> =20
>  	ar9170_update_beacon(ar);
> =20
> + out:
> +	mutex_unlock(&ar->mutex);
> +}
> +
> +void ar9170_send_buffered(struct work_struct *work)
> +{
> +	struct ar9170 *ar =3D container_of(work, struct ar9170,
> +					 cab_work);
> +	struct sk_buff *skb;
> +
> +	if (unlikely(!IS_STARTED(ar)))
> +		return ;
> +
> +	mutex_lock(&ar->mutex);
> +
> +	if (!ar->vif)
> +		goto out;
> +
>  	rcu_read_lock();
>  	while ((skb =3D ieee80211_get_buffered_bc(ar->hw, ar->vif)))
>  		ar9170_op_tx(ar->hw, skb);
> diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wirel=
ess/ath/ar9170/main.c
> index 20f04ab..f027d74 100644
> --- a/drivers/net/wireless/ath/ar9170/main.c
> +++ b/drivers/net/wireless/ath/ar9170/main.c
> @@ -660,6 +660,10 @@ void ar9170_handle_command_response(struct ar9170 =
*ar, void *buf, u32 len)
>  		 * YY always 00
>  		 * B1-B4 "should" be the number of send out beacons.
>  		 */
> +
> +		if (ar->vif && ar->vif->type =3D=3D NL80211_IFTYPE_AP)
> +			ieee80211_queue_work(ar->hw, &ar->cab_work);
> +
>  		break;
> =20
>  	case 0xc3:
> @@ -1294,6 +1298,7 @@ static void ar9170_op_stop(struct ieee80211_hw *h=
w)
>  	cancel_delayed_work_sync(&ar->led_work);
>  #endif
>  	cancel_work_sync(&ar->beacon_work);
> +	cancel_work_sync(&ar->cab_work);
> =20
>  	mutex_lock(&ar->mutex);
> =20
> @@ -2549,6 +2554,7 @@ void *ar9170_alloc(size_t priv_size)
>  	}
>  	ar9170_rx_reset_rx_mpdu(ar);
>  	INIT_WORK(&ar->beacon_work, ar9170_new_beacon);
> +	INIT_WORK(&ar->cab_work, ar9170_send_buffered);
>  	INIT_DELAYED_WORK(&ar->tx_janitor, ar9170_tx_janitor);
>  	INIT_LIST_HEAD(&ar->tx_ampdu_list);
> =20


--------------enigD0D1C8999B8DA94CFCF3144B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAksb9o0ACgkQitSsb3rl5xQeLQCdEYpJaLx73+tms3JG2cWFoPwQ
sEgAoMOCf+o34ioErul/qCqJG5O+WLlk
=3XGJ
-----END PGP SIGNATURE-----

--------------enigD0D1C8999B8DA94CFCF3144B--
