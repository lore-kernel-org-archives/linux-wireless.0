Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbYJIJm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 05:42:56 -0400
Subject: Re: [PATCH] p54: honour bss_info_changed's short slot time settings
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200810082052.22847.chunkeey@web.de>
References: <200810082052.22847.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4d+UDaKhS0wGzvszT8tn"
Date: Thu, 09 Oct 2008 11:42:55 +0200
Message-Id: <1223545375.22490.11.camel@johannes.berg> (sfid-20081009_114259_246464_91C6DD88)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4d+UDaKhS0wGzvszT8tn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-08 at 20:52 +0200, Christian Lamparter wrote:
> This patch was made on behalf of Johannes request.
> "mac80211 and IEEE80211_CONF_SHORT_SLOT_TIME"

Nice, thanks.

> Of course, bss_info_changed provides some more useful data.
> e.g.: basic_rates, dtim_period, beacon_int and maybe even more.
> Everything can be hooked up if it's necessary.

It probably should be, yes. Well, beacon_int here is a bit confusing, I
think.

> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p5=
4.h
> index 1d0704f..8da4d30 100644
> --- a/drivers/net/wireless/p54/p54.h
> +++ b/drivers/net/wireless/p54/p54.h
> @@ -81,6 +81,7 @@ struct p54_common {
>  	unsigned int output_limit_len;
>  	struct pda_pa_curve_data *curve_data;
>  	unsigned int filter_flags;
> +	bool use_short_slot;
>  	u16 rxhw;
>  	u8 version;
>  	u8 rx_antenna;
> diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/=
p54/p54common.c
> index 117c7d3..726cba9 100644
> --- a/drivers/net/wireless/p54/p54common.c
> +++ b/drivers/net/wireless/p54/p54common.c
> @@ -909,12 +909,10 @@ static int p54_set_filter(struct ieee80211_hw *dev,=
 u16 filter_type,
>  		memset(filter->bssid, ~0, ETH_ALEN);
>  	else
>  		memcpy(filter->bssid, bssid, ETH_ALEN);
> -
>  	filter->rx_antenna =3D priv->rx_antenna;
> -
>  	if (priv->fw_var < 0x500) {
>  		data_len =3D P54_TX_CONTROL_FILTER_V1_LEN;
> -		filter->v1.basic_rate_mask =3D cpu_to_le32(0x15F);
> +		filter->v1.basic_rate_mask =3D cpu_to_le32(0x15f);
>  		filter->v1.rx_addr =3D cpu_to_le32(priv->rx_end);
>  		filter->v1.max_rx =3D cpu_to_le16(priv->rx_mtu);
>  		filter->v1.rxhw =3D cpu_to_le16(priv->rxhw);
> @@ -926,7 +924,6 @@ static int p54_set_filter(struct ieee80211_hw *dev, u=
16 filter_type,
>  		filter->v2.rxhw =3D cpu_to_le16(priv->rxhw);
>  		filter->v2.timer =3D cpu_to_le16(1000);
>  	}
> -
>  	hdr->len =3D cpu_to_le16(data_len);
>  	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + data_len);
>  	priv->tx(dev, hdr, sizeof(*hdr) + data_len, 1);
> @@ -1096,7 +1093,7 @@ static void p54_set_vdcf(struct ieee80211_hw *dev)
> =20
>  	vdcf =3D (struct p54_tx_control_vdcf *) hdr->data;
> =20
> -	if (dev->conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
> +	if (priv->use_short_slot) {
>  		vdcf->slottime =3D 9;
>  		vdcf->magic1 =3D 0x10;
>  		vdcf->magic2 =3D 0x00;
> @@ -1143,7 +1140,6 @@ static int p54_start(struct ieee80211_hw *dev)
>  		priv->mode =3D NL80211_IFTYPE_MONITOR;
> =20
>  	p54_init_vdcf(dev);
> -
>  	mod_timer(&priv->stats_timer, jiffies + HZ);
>  	return err;
>  }
> @@ -1359,6 +1355,19 @@ static int p54_get_tx_stats(struct ieee80211_hw *d=
ev,
>  	return 0;
>  }
> =20
> +static void p54_bss_info_changed(struct ieee80211_hw *dev,
> +				 struct ieee80211_vif *vif,
> +				 struct ieee80211_bss_conf *info,
> +				 u32 changed)
> +{
> +	struct p54_common *priv =3D dev->priv;
> +
> +	if (changed & BSS_CHANGED_ERP_SLOT) {
> +		priv->use_short_slot =3D info->use_short_slot;
> +		p54_set_vdcf(dev);
> +	}
> +}
> +
>  static const struct ieee80211_ops p54_ops =3D {
>  	.tx			=3D p54_tx,
>  	.start			=3D p54_start,
> @@ -1367,6 +1376,7 @@ static const struct ieee80211_ops p54_ops =3D {
>  	.remove_interface	=3D p54_remove_interface,
>  	.config			=3D p54_config,
>  	.config_interface	=3D p54_config_interface,
> +	.bss_info_changed	=3D p54_bss_info_changed,
>  	.configure_filter	=3D p54_configure_filter,
>  	.conf_tx		=3D p54_conf_tx,
>  	.get_stats		=3D p54_get_stats,
> @@ -1393,7 +1403,6 @@ struct ieee80211_hw *p54_init_common(size_t priv_da=
ta_len)
>  	dev->wiphy->interface_modes =3D BIT(NL80211_IFTYPE_STATION);
> =20
>  	dev->channel_change_time =3D 1000;	/* TODO: find actual value */
> -
>  	priv->tx_stats[0].limit =3D 1;
>  	priv->tx_stats[1].limit =3D 1;
>  	priv->tx_stats[2].limit =3D 1;
>=20

--=-4d+UDaKhS0wGzvszT8tn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7dIcAAoJEKVg1VMiehFYTngQALJLg8ouDpYLEilGKgY4EPFE
eeGVvzJ+XAw0uptQ6eS2qQNlBMjNi2xQ4cHvdObGdo+HkRWAvCciuYeA9BKphPgI
HHaIh2giwaXOCuEK+0jJ75pM22V1zc9nKv+01WWvqJ4SjU5aFu6DyxmQ0eya//Ad
99ayPEfQTSClP3c2VjIydXSDVvcWMsL8F3T1jTfoA5/1ETj2lR2VnclHBUWPCfe2
2cs3uNXuCtED5DY/mG4C0tkGEr9PHZ6IcgU4RS09+TGtD7RZv9lwj6IfDpHG+Nfo
EDcBnWX/5ovjwzmTcIheZvEwhMJTbzKWrncWygmapPe9gmFkQoyvNX8YuoqUHZ/j
baYViXigbD0QUPT+XsA7cN++pqlMbiozMRpuZ1narMBVtUIPgG5YFtwI5qpmNHOs
3oEwpSNezWbefTPX/MrRv2MYg5ROmhzHkRTWuxm1EDlgxvXP0aQLdwDtgxGTllWD
FBGs/Z93ECdFUEVNnjU50cBMHvtbAxMkxLl2WPHn+/5Mfr+7fEFEky70pQW/0pJc
MEki5KdeMFa2kl6uM0wsH72sRxQKXLxOE9pU7SJthjjjwfIEACqL37lMIOlNGSJP
BsMEy8jd+B8bOmxXakSIMWi7v2C9WpPSjnukbs0bypldGkZsdGGkvNR6851pD6sc
XjWa3Jz+SFBHB0oBhBfL
=vfyy
-----END PGP SIGNATURE-----

--=-4d+UDaKhS0wGzvszT8tn--

