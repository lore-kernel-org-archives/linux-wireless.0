Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45943 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbYI3Soq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 14:44:46 -0400
Subject: Re: [PATCH 1/3] mac80211: free up 2 bytes in skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48E20BFC.6040904@openwrt.org>
References: <48E20B7C.2040405@openwrt.org>  <48E20BFC.6040904@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fVgZYVKMAN1bmAJiFcQk"
Date: Tue, 30 Sep 2008 20:44:42 +0200
Message-Id: <1222800282.7064.62.camel@johannes.berg> (sfid-20080930_204525_032287_1796ADD1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fVgZYVKMAN1bmAJiFcQk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-30 at 13:22 +0200, Felix Fietkau wrote:
> Free up 2 bytes in skb->cb to be used for multi-rate retry.
> Move iv_len and icv_len initialization into key alloc.
>=20
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

The mac80211 changes look good to me, the driver stuff I cannot really
judge.

>=20
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -337,8 +337,6 @@
>  			unsigned long jiffies;
>  			s8 rts_cts_rate_idx, alt_retry_rate_idx;
>  			u8 retry_limit;
> -			u8 icv_len;
> -			u8 iv_len;
>  		} control;
>  		struct {
>  			u64 ampdu_ack_map;
> @@ -635,6 +633,8 @@
>   */
>  struct ieee80211_key_conf {
>  	enum ieee80211_key_alg alg;
> +	u8 icv_len;
> +	u8 iv_len;
>  	u8 hw_key_idx;
>  	u8 flags;
>  	s8 keyidx;
> --- a/drivers/net/wireless/b43/xmit.c
> +++ b/drivers/net/wireless/b43/xmit.c
> @@ -252,7 +252,7 @@
>  		}
> =20
>  		/* Hardware appends ICV. */
> -		plcp_fragment_len +=3D info->control.icv_len;
> +		plcp_fragment_len +=3D info->control.hw_key->icv_len;
> =20
>  		key_idx =3D b43_kidx_to_fw(dev, key_idx);
>  		mac_ctl |=3D (key_idx << B43_TXH_MAC_KEYIDX_SHIFT) &
> @@ -260,7 +260,7 @@
>  		mac_ctl |=3D (key->algorithm << B43_TXH_MAC_KEYALG_SHIFT) &
>  			   B43_TXH_MAC_KEYALG;
>  		wlhdr_len =3D ieee80211_hdrlen(fctl);
> -		iv_len =3D min((size_t) info->control.iv_len,
> +		iv_len =3D min((size_t) info->control.hw_key->iv_len,
>  			     ARRAY_SIZE(txhdr->iv));
>  		memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
>  	}
> --- a/drivers/net/wireless/b43legacy/xmit.c
> +++ b/drivers/net/wireless/b43legacy/xmit.c
> @@ -243,7 +243,7 @@
> =20
>  		if (key->enabled) {
>  			/* Hardware appends ICV. */
> -			plcp_fragment_len +=3D info->control.icv_len;
> +			plcp_fragment_len +=3D info->control.hw_key->icv_len;
> =20
>  			key_idx =3D b43legacy_kidx_to_fw(dev, key_idx);
>  			mac_ctl |=3D (key_idx << B43legacy_TX4_MAC_KEYIDX_SHIFT) &
> @@ -252,7 +252,7 @@
>  				   B43legacy_TX4_MAC_KEYALG_SHIFT) &
>  				   B43legacy_TX4_MAC_KEYALG;
>  			wlhdr_len =3D ieee80211_hdrlen(wlhdr->frame_control);
> -			iv_len =3D min((size_t)info->control.iv_len,
> +			iv_len =3D min((size_t)info->control.hw_key->iv_len,
>  				     ARRAY_SIZE(txhdr->iv));
>  			memcpy(txhdr->iv, ((u8 *)wlhdr) + wlhdr_len, iv_len);
>  		} else {
> --- a/net/mac80211/wep.c
> +++ b/net/mac80211/wep.c
> @@ -313,9 +313,6 @@
>  {
>  	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> =20
> -	info->control.iv_len =3D WEP_IV_LEN;
> -	info->control.icv_len =3D WEP_ICV_LEN;
> -
>  	if (!(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
>  		if (ieee80211_wep_encrypt(tx->local, skb, tx->key))
>  			return -1;
> --- a/net/mac80211/wpa.c
> +++ b/net/mac80211/wpa.c
> @@ -152,9 +152,6 @@
>  	int len, tail;
>  	u8 *pos;
> =20
> -	info->control.icv_len =3D TKIP_ICV_LEN;
> -	info->control.iv_len =3D TKIP_IV_LEN;
> -
>  	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
>  	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
>  		/* hwaccel - with no need for preallocated room for IV/ICV */
> @@ -374,9 +371,6 @@
>  	u8 *pos, *pn;
>  	int i;
> =20
> -	info->control.icv_len =3D CCMP_MIC_LEN;
> -	info->control.iv_len =3D CCMP_HDR_LEN;
> -
>  	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
>  	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
>  		/* hwaccel - with no need for preallocated room for CCMP "
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -1164,7 +1164,7 @@
> =20
>  	if (info->control.hw_key) {
>  		keyidx =3D info->control.hw_key->hw_key_idx;
> -		pktlen +=3D info->control.icv_len;
> +		pktlen +=3D info->control.hw_key->icv_len;
>  	}
>  	ret =3D ah->ah_setup_tx_desc(ah, ds, pktlen,
>  		ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
> --- a/drivers/net/wireless/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath9k/xmit.c
> @@ -237,7 +237,7 @@
> =20
>  	if (tx_info->control.hw_key) {
>  		txctl->keyix =3D tx_info->control.hw_key->hw_key_idx;
> -		txctl->frmlen +=3D tx_info->control.icv_len;
> +		txctl->frmlen +=3D tx_info->control.hw_key->icv_len;
> =20
>  		if (tx_info->control.hw_key->alg =3D=3D ALG_WEP)
>  			txctl->keytype =3D ATH9K_KEY_TYPE_WEP;
> --- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
> @@ -56,10 +56,10 @@
>  	 * note that these lengths should only be added when
>  	 * mac80211 does not generate it.
>  	 */
> -	overhead +=3D tx_info->control.icv_len;
> +	overhead +=3D key->icv_len;
> =20
>  	if (!(key->flags & IEEE80211_KEY_FLAG_GENERATE_IV))
> -		overhead +=3D tx_info->control.iv_len;
> +		overhead +=3D key->iv_len;
> =20
>  	if (!(key->flags & IEEE80211_KEY_FLAG_GENERATE_MMIC)) {
>  		if (key->alg =3D=3D ALG_TKIP)
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -374,7 +374,7 @@
>  	struct queue_entry *entry =3D rt2x00queue_get_entry(queue, Q_INDEX);
>  	struct txentry_desc txdesc;
>  	struct skb_frame_desc *skbdesc;
> -	unsigned int iv_len =3D IEEE80211_SKB_CB(skb)->control.iv_len;
> +	unsigned int iv_len;
> =20
>  	if (unlikely(rt2x00queue_full(queue)))
>  		return -EINVAL;
> @@ -410,8 +410,11 @@
>  	 * the frame so we can provide it to the driver seperately.
>  	 */
>  	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc.flags) &&
> -	    !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc.flags))
> +	    !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc.flags) &&
> +		(IEEE80211_SKB_CB(skb)->control.hw_key !=3D NULL)) {
> +		iv_len =3D IEEE80211_SKB_CB(skb)->control.hw_key->iv_len;
>  		rt2x00crypto_tx_remove_iv(skb, iv_len);
> +	}
> =20
>  	/*
>  	 * It could be possible that the queue was corrupted and this
> --- a/net/mac80211/key.c
> +++ b/net/mac80211/key.c
> @@ -281,6 +281,20 @@
>  	key->conf.alg =3D alg;
>  	key->conf.keyidx =3D idx;
>  	key->conf.keylen =3D key_len;
> +	switch (alg) {
> +	case ALG_WEP:
> +		key->conf.iv_len =3D WEP_IV_LEN;
> +		key->conf.icv_len =3D WEP_ICV_LEN;
> +		break;
> +	case ALG_TKIP:
> +		key->conf.iv_len =3D TKIP_IV_LEN;
> +		key->conf.icv_len =3D TKIP_ICV_LEN;
> +		break;
> +	case ALG_CCMP:
> +		key->conf.iv_len =3D CCMP_HDR_LEN;
> +		key->conf.icv_len =3D CCMP_MIC_LEN;
> +		break;
> +	}
>  	memcpy(key->conf.key, key_data, key_len);
>  	INIT_LIST_HEAD(&key->list);
>  	INIT_LIST_HEAD(&key->todo);
>=20

--=-fVgZYVKMAN1bmAJiFcQk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI4nOWAAoJEKVg1VMiehFYoboQAIHqytg8xr8Yzx+e4yFi6SXC
LxTHbEetmCfjku0/g7QVayUlWrs6IgvHaywUifVudnnBiK56BZbIstPbP3ICy3N5
PK+NVzd1AmZfzvCbp6jeMOdtypu5RgHFJ5qHoHy0a2QZm3WD7Y45aActs903oFZJ
djfnc+MMdjgPO5JqvWm1YffLiXd3Cz+9YMmhG4Dp+h4EvR7gR7XizxYEs028KRCn
/SQHDsKy8I9gx5CGmi53qn3wDgY8Da+VcYw5pIkchNpG7kez0Zf9vPnjf9uKgj/x
E55m2biBZCWhug11o0tBEmiSr1U3uWnyjrOeIrQftVnLUUvviUC/nsifn6qOOkGu
FkpNFCr8RKZtrkg3dlstTmKJ2bP5mk+LkXmhoj6D68NEKuFMcaKFOPORi3tCmR/a
FSxUvS8goBd69jkvtvPTfVuBA/uz5JqTAsluTyY+Le4r6XlZyz0eq9qpBSwdQL0G
bhHyLVDz8cBQ4Bxl6IZD8hdJZU8v2iwqpGD2c+ESyBbYy/nnOC3wY6kaxsb77LkA
BcDV5bO1A4Ob7ahz68kGXyJ3zNUkSYnXhLg3Kq64N36pRVo+Op3F1K84LY1lwodP
6hG0feBOTtARXbCBjINWUDm44votu9IiyXwoeNcPLiQawMkNfA9zDk2Mqwc0t1Oh
8q32ZRslE7wJLUUozJJ5
=cErB
-----END PGP SIGNATURE-----

--=-fVgZYVKMAN1bmAJiFcQk--

