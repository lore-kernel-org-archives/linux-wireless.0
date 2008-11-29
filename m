Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbYK2Vln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 16:41:43 -0500
Subject: Re: [PATCH 1/6 v2] mac80211: add sta_notify_ps callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>
In-Reply-To: <200811292232.56550.chunkeey@web.de>
References: <200811292232.56550.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DZxgOnpTlYxfXDtESmVf"
Date: Sat, 29 Nov 2008 22:41:37 +0100
Message-Id: <1227994897.3542.17.camel@johannes.berg> (sfid-20081129_224147_569634_98E52504)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DZxgOnpTlYxfXDtESmVf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-29 at 22:32 +0100, Christian Lamparter wrote:
> This patch is necessary in order to provide a proper Access point support=
 for p54.
>=20
> Unfortunately for us, there is no documented way to disable the interferi=
ng
> power save buffering mechanism in firmware completely.
>=20
> Therefore we give in and notify the driver through our new sta_notify_ps =
callback,=20
> so that we can update the filter state.
>=20
> Signed-off-by: Christian Lamparter <chunkeey@web.de>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> BTW, the extra patch for mac80211_hwsim is no longer needed...
> This is all for wireless-testing.
> ---
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 6a1d4ea..a6baf37 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -779,6 +779,19 @@ enum sta_notify_cmd {
>  };
> =20
>  /**
> + * enum sta_notify_ps_cmd - sta power save notify command
> + *
> + * Used with the sta_notify_ps() callback in &struct ieee80211_ops to
> + * notify the driver if a station made a power state transition.
> + *
> + * @STA_WILL_SLEEP: a station is now sleeping
> + * @STA_WOKE_UP: a sleeping station woke up
> + */
> +enum sta_notify_ps_cmd {
> +	STA_NOTIFY_SLEEP, STA_NOTIFY_AWAKE,
> +};
> +
> +/**
>   * enum ieee80211_tkip_key_type - get tkip key
>   *
>   * Used by drivers which need to get a tkip key for skb. Some drivers ne=
ed a
> @@ -1248,6 +1261,9 @@ enum ieee80211_ampdu_mlme_action {
>   * @sta_notify: Notifies low level driver about addition or removal
>   *	of associated station or AP.
>   *
> + * @sta_ps_notify: Notifies low level driver about the power state trans=
ition
> + *	of a associated station. Must be atomic.
> + *
>   * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
>   *	bursting) for a hardware TX queue.
>   *
> @@ -1314,6 +1330,8 @@ struct ieee80211_ops {
>  	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
>  	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  			enum sta_notify_cmd, struct ieee80211_sta *sta);
> +	void (*sta_notify_ps)(struct ieee80211_hw *hw,
> +			enum sta_notify_ps_cmd, struct ieee80211_sta *sta);
>  	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
>  		       const struct ieee80211_tx_queue_params *params);
>  	int (*get_tx_stats)(struct ieee80211_hw *hw,
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 5a1a60f..3bf056e 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -654,10 +654,14 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx=
)
>  static void ap_sta_ps_start(struct sta_info *sta)
>  {
>  	struct ieee80211_sub_if_data *sdata =3D sta->sdata;
> +	struct ieee80211_local *local =3D sdata->local;
>  	DECLARE_MAC_BUF(mac);
> =20
>  	atomic_inc(&sdata->bss->num_sta_ps);
>  	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL);
> +	if (local->ops->sta_notify_ps)
> +		local->ops->sta_notify_ps(local_to_hw(local), STA_WILL_SLEEP,
> +					  &sta->sta);
>  #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
>  	printk(KERN_DEBUG "%s: STA %s aid %d enters power save mode\n",
>  	       sdata->dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
> @@ -675,6 +679,9 @@ static int ap_sta_ps_end(struct sta_info *sta)
>  	atomic_dec(&sdata->bss->num_sta_ps);
> =20
>  	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
> +	if (local->ops->sta_notify_ps)
> +		local->ops->sta_notify_ps(local_to_hw(local), STA_WOKE_UP,
> +					  &sta->sta);
> =20
>  	if (!skb_queue_empty(&sta->ps_tx_buf))
>  		sta_info_clear_tim_bit(sta);
>=20

--=-DZxgOnpTlYxfXDtESmVf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJMbcNAAoJEKVg1VMiehFYIgcQAL3A20xi+lW+WawZ2we5jeK1
jW4p9voSQVoIN9Yz1O9LaEWX+DFkHtutlSW34J917ixyAQ9Al/KjPZveblxIqJhT
1SMOoIZIpzoAnSWg16rUuKmNUkWuYef6jjB40o57QJPyX3LZTcukjEOyoS100ef3
/EerYdmeXRS1Hu57pDKv903TIwktUt6fsLqg5ZXdmvXKBGF1ZTWeo3TyOY6h2xAr
isJiGTunKB6lhtGgVTepSQ3ETvW3hwGS1EkvSi0hb2+CRumhjdcrEQeTkr6/YWaF
lwdQNomwOg1TzDDD85NnbOwgwg0beJGKc1BR7El2c+y3WLNx15//VxItc/qGQBRq
qs57SVCaADpc1aMEccYaLsEIuSOIps9RgJawUtWAtwkgrbiqffurK7uOimMTtoiC
Any9tzDdD0Cqu3MDwTDki6iosTvQmUL/YpQUcmgobPGeTaADCSfg5VTMB6OFKeWe
mngLW0EX86em7sHQyxIuOTiP/+2+ZgeB2YZ/9IrpTDTKHNkYHUdyvbtUPC5iJEQ9
cAnsmvzxP0MTqeh4CLQDDrRpldsAlod41N4fyNtwJHiutO2LQ5e+NnR1F5seLbKx
jXpdawob+6r/Oo2MVUxQfhIRwYtnZWL2qvrznopUhj1eZeravvj92N8RG5YMujIk
tt+EQIy5PF4LQCFpU7Vm
=Il4i
-----END PGP SIGNATURE-----

--=-DZxgOnpTlYxfXDtESmVf--

