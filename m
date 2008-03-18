Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546AbYCSTpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:45:16 -0400
Subject: Re: [PATCH v2] mac80211: configure default wmm params correctly
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Koutny <vlado@work.ksp.sk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <47E0228F.7090901@work.ksp.sk>
References: <47DFBA13.3060508@work.ksp.sk>
	 <1205846472.16475.46.camel@johannes.berg>  <47DFC762.10307@work.ksp.sk>
	 <1205849813.16475.48.camel@johannes.berg>  <47E01816.6050004@work.ksp.sk>
	 <1205869095.16475.54.camel@johannes.berg>  <47E0228F.7090901@work.ksp.sk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aExOXq/K40pUZKM6QuqI"
Date: Tue, 18 Mar 2008 21:15:16 +0100
Message-Id: <1205871316.16475.56.camel@johannes.berg> (sfid-20080319_194712_990069_214EAF42)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aExOXq/K40pUZKM6QuqI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-03-18 at 21:14 +0100, Vladimir Koutny wrote:
> > I don't know what CodingStyle says, but I very much prefer
> >=20
> > if (local->hw..... &&
> >     have_higher_than_11mbit)
> > 	sdata->flags |=3D ...
> >=20
> > since that visually puts the continuation of the condition together wit=
h
> > the start of it. Mind changing that?
> No problem (and better don't ask what CodingStyle thinks about spaces..)
> Here we go:

Thanks.

> ---
> Default WMM params have to be set according to beacon/probe response
> information prior to authentication (or IBSS start/join); beacon queue
> is configured only in IBSS. This does not affect the use of 'real' WMM
> params as reported by AP.
>=20
> Signed-off-by: Vladimir Koutny <vlado@ksp.sk>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index 8b991eb..14d80e0 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -220,6 +220,61 @@ static int ecw2cw(int ecw)
>  	return (1 << ecw) - 1;
>  }
>=20
> +
> +static void ieee80211_sta_def_wmm_params(struct net_device *dev,
> +					 struct ieee80211_sta_bss *bss,
> +					 int ibss)
> +{
> +	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_local *local =3D sdata->local;
> +	int i, have_higher_than_11mbit =3D 0;
> +
> +
> +	/* cf. IEEE 802.11 9.2.12 */
> +	for (i =3D 0; i < bss->supp_rates_len; i++)
> +		if ((bss->supp_rates[i] & 0x7f) * 5 > 110)
> +			have_higher_than_11mbit =3D 1;
> +
> +	if (local->hw.conf.channel->band =3D=3D IEEE80211_BAND_2GHZ &&
> +	    have_higher_than_11mbit)
> +		sdata->flags |=3D IEEE80211_SDATA_OPERATING_GMODE;
> +	else
> +		sdata->flags &=3D ~IEEE80211_SDATA_OPERATING_GMODE;
> +
> +
> +	if (local->ops->conf_tx) {
> +		struct ieee80211_tx_queue_params qparam;
> +		int i;
> +
> +		memset(&qparam, 0, sizeof(qparam));
> +
> +		qparam.aifs =3D 2;
> +
> +		if (local->hw.conf.channel->band =3D=3D IEEE80211_BAND_2GHZ &&
> +		    !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE))
> +			qparam.cw_min =3D 31;
> +		else
> +			qparam.cw_min =3D 15;
> +
> +		qparam.cw_max =3D 1023;
> +		qparam.txop =3D 0;
> +
> +		for (i =3D IEEE80211_TX_QUEUE_DATA0; i < NUM_TX_DATA_QUEUES; i++)
> +			local->ops->conf_tx(local_to_hw(local),
> +					   i + IEEE80211_TX_QUEUE_DATA0,
> +					   &qparam);
> +
> +		if (ibss) {
> +			/* IBSS uses different parameters for Beacon sending */
> +			qparam.cw_min++;
> +			qparam.cw_min *=3D 2;
> +			qparam.cw_min--;
> +			local->ops->conf_tx(local_to_hw(local),
> +					   IEEE80211_TX_QUEUE_BEACON, &qparam);
> +		}
> +	}
> +}
> +
>  static void ieee80211_sta_wmm_params(struct net_device *dev,
>  				     struct ieee80211_if_sta *ifsta,
>  				     u8 *wmm_param, size_t wmm_param_len)
> @@ -2289,6 +2344,8 @@ static int ieee80211_sta_join_ibss(struct net_devic=
e *dev,
>  					rates |=3D BIT(j);
>  		}
>  		ifsta->supp_rates_bits[local->hw.conf.channel->band] =3D rates;
> +
> +		ieee80211_sta_def_wmm_params(dev, bss, 1);
>  	} while (0);
>=20
>  	if (skb) {
> @@ -3274,6 +3331,7 @@ static int ieee80211_sta_config_auth(struct net_dev=
ice *dev,
>  			ieee80211_sta_set_ssid(dev, selected->ssid,
>  					       selected->ssid_len);
>  		ieee80211_sta_set_bssid(dev, selected->bssid);
> +		ieee80211_sta_def_wmm_params(dev, selected, 0);
>  		ieee80211_rx_bss_put(dev, selected);
>  		ifsta->state =3D IEEE80211_AUTHENTICATE;
>  		ieee80211_sta_reset_auth(dev, ifsta);
> @@ -3448,43 +3506,10 @@ int ieee80211_sta_set_ssid(struct net_device *dev=
, char *ssid, size_t len)
>  {
>  	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
>  	struct ieee80211_if_sta *ifsta;
> -	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
>=20
>  	if (len > IEEE80211_MAX_SSID_LEN)
>  		return -EINVAL;
>=20
> -	/* TODO: This should always be done for IBSS, even if IEEE80211_QOS is
> -	 * not defined. */
> -	if (local->ops->conf_tx) {
> -		struct ieee80211_tx_queue_params qparam;
> -		int i;
> -
> -		memset(&qparam, 0, sizeof(qparam));
> -
> -		qparam.aifs =3D 2;
> -
> -		if (local->hw.conf.channel->band =3D=3D IEEE80211_BAND_2GHZ &&
> -		    !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE))
> -			qparam.cw_min =3D 31;
> -		else
> -			qparam.cw_min =3D 15;
> -
> -		qparam.cw_max =3D 1023;
> -		qparam.txop =3D 0;
> -
> -		for (i =3D IEEE80211_TX_QUEUE_DATA0; i < NUM_TX_DATA_QUEUES; i++)
> -			local->ops->conf_tx(local_to_hw(local),
> -					   i + IEEE80211_TX_QUEUE_DATA0,
> -					   &qparam);
> -
> -		/* IBSS uses different parameters for Beacon sending */
> -		qparam.cw_min++;
> -		qparam.cw_min *=3D 2;
> -		qparam.cw_min--;
> -		local->ops->conf_tx(local_to_hw(local),
> -				   IEEE80211_TX_QUEUE_BEACON, &qparam);
> -	}
> -
>  	ifsta =3D &sdata->u.sta;
>=20
>  	if (ifsta->ssid_len !=3D len || memcmp(ifsta->ssid, ssid, len) !=3D 0)
>=20

--=-aExOXq/K40pUZKM6QuqI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+Ai0qVg1VMiehFYAQIMGQ//eHp5ba6ti4X/j2mxCIlTocbu311wQzA4
2q867gfRwhlLHwrtrpvA0G7PUvYKdHaNe/7GhmlM4Yfjb+EASsWxNejl3NaQ0Nlb
CVOjct6U4OZFNtsXip9WvqMfhfTi4dJgKII4FySCo5U0lShfnTaNU1H9L2AKoVU9
u7wuh6NDDtycVmR7TPisu9vx4lqIvp3v1B4WCswv7D5AZ7/EkvCbdqspLpZCBRhy
aPf+QS7dyPLDzd53XaLth1kbP1OoA/TsRdiz0j6pOsBwhASyGV5k4EYGnVOYL4B4
mrMk1n1b2Ric1oWKg352CnmpeKv/7PCocwQpSaaD4mZyyqWSu92JjSncJbO6YDtb
8f23NeWlq0uZGIQAlw82VWzx+Tp2DZWrv9R2lcDtpdjLdfoVDx7dcs+U/bRpS95J
z6PQVx6X6FqLEFtrpoF+epwVzfZySNs05uzV7CI45/utggvqN3qILZHq7Bv+NiVM
6bkpmqMlyGCGQ0JBUChi+jSyeQvgcD4ChPVAQz4PyihqoBy47MKwW/HhKuWpySGk
3CUbU3zsGSRIx7FkqtHCQpl3mpYM73gqNX6/ef5rn1gDGnCCU/c7QTiNZk2AudX1
ylhUgDNd3LunGPh3AvNjIn49eXblLe3xyeShaBqzNxojHZNTABLXgpcCyt+xbaeL
Kz/LTZsgO3c=
=spgF
-----END PGP SIGNATURE-----

--=-aExOXq/K40pUZKM6QuqI--

