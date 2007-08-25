Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764189AbXHYIDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Aug 2007 04:03:05 -0400
Subject: Re: [PATCH] mac80211: use internal network device stats
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070824112934.2e377bce@localhost>
References: <20070824112934.2e377bce@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4Ql4VGO5ie1mAPF9Ypb4"
Date: Sat, 25 Aug 2007 10:04:02 +0200
Message-Id: <1188029042.9529.15.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4Ql4VGO5ie1mAPF9Ypb4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-24 at 11:29 -0700, Stephen Hemminger wrote:
> Stats are now available for device usage inside network_device

Ah, good point. Thanks.

> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/ieee80211.c   |   44 ++++++++++++++------------------------=
------
>  net/mac80211/ieee80211_i.h |    2 --
>  2 files changed, 14 insertions(+), 32 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index 8ec5ed1..28cca19 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -1892,8 +1892,8 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
>  	pkt_data->do_not_encrypt =3D no_encrypt;
> =20
>  	skb->dev =3D local->mdev;
> -	sdata->stats.tx_packets++;
> -	sdata->stats.tx_bytes +=3D skb->len;
> +	dev->stats.tx_packets++;
> +	dev->stats.tx_bytes +=3D skb->len;
> =20
>  	/* Update skb pointers to various headers since this modified frame
>  	 * is going to go through Linux networking code that may potentially
> @@ -1966,8 +1966,8 @@ ieee80211_mgmt_start_xmit(struct sk_buff *skb, stru=
ct net_device *dev)
> =20
>  	pkt_data->do_not_encrypt =3D !(fc & IEEE80211_FCTL_PROTECTED);
> =20
> -	sdata->stats.tx_packets++;
> -	sdata->stats.tx_bytes +=3D skb->len;
> +	dev->stats.tx_packets++;
> +	dev->stats.tx_bytes +=3D skb->len;
> =20
>  	dev_queue_xmit(skb);
> =20
> @@ -2492,13 +2492,6 @@ struct dev_mc_list *ieee80211_get_mc_list_item(str=
uct ieee80211_hw *hw,
>  }
>  EXPORT_SYMBOL(ieee80211_get_mc_list_item);
> =20
> -static struct net_device_stats *ieee80211_get_stats(struct net_device *d=
ev)
> -{
> -	struct ieee80211_sub_if_data *sdata;
> -	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> -	return &(sdata->stats);
> -}
> -
>  static void ieee80211_if_shutdown(struct net_device *dev)
>  {
>  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> @@ -2893,8 +2886,8 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
> =20
>  	skb2 =3D NULL;
> =20
> -	sdata->stats.rx_packets++;
> -	sdata->stats.rx_bytes +=3D skb->len;
> +	dev->stats.rx_packets++;
> +	dev->stats.rx_bytes +=3D skb->len;
> =20
>  	if (local->bridge_packets && (sdata->type =3D=3D IEEE80211_IF_TYPE_AP
>  	    || sdata->type =3D=3D IEEE80211_IF_TYPE_VLAN) && rx->u.rx.ra_match)=
 {
> @@ -3041,11 +3034,9 @@ ieee80211_rx_mgmt(struct ieee80211_local *local, s=
truct sk_buff *skb,
>  {
>  	struct ieee80211_frame_info *fi;
>  	const size_t hlen =3D sizeof(struct ieee80211_frame_info);
> -	struct ieee80211_sub_if_data *sdata;
> +	struct net_device *dev =3D local->apdev;
> =20
> -	skb->dev =3D local->apdev;
> -
> -	sdata =3D IEEE80211_DEV_TO_SUB_IF(local->apdev);
> +	skb->dev =3D dev;
> =20
>  	if (skb_headroom(skb) < hlen) {
>  		I802_DEBUG_INC(local->rx_expand_skb_head);
> @@ -3060,8 +3051,8 @@ ieee80211_rx_mgmt(struct ieee80211_local *local, st=
ruct sk_buff *skb,
>  	ieee80211_fill_frame_info(local, fi, status);
>  	fi->msg_type =3D htonl(msg_type);
> =20
> -	sdata->stats.rx_packets++;
> -	sdata->stats.rx_bytes +=3D skb->len;
> +	dev->stats.rx_packets++;
> +	dev->stats.rx_bytes +=3D skb->len;
> =20
>  	skb_set_mac_header(skb, 0);
>  	skb->ip_summed =3D CHECKSUM_UNNECESSARY;
> @@ -3123,8 +3114,8 @@ ieee80211_rx_monitor(struct net_device *dev, struct=
 sk_buff *skb,
>  	rthdr->antsignal =3D status->ssi;
> =20
>   out:
> -	sdata->stats.rx_packets++;
> -	sdata->stats.rx_bytes +=3D skb->len;
> +	dev->stats.rx_packets++;
> +	dev->stats.rx_bytes +=3D skb->len;
> =20
>  	skb_set_mac_header(skb, 0);
>  	skb->ip_summed =3D CHECKSUM_UNNECESSARY;
> @@ -4784,7 +4775,7 @@ void ieee80211_if_setup(struct net_device *dev)
>  	dev->wireless_handlers =3D &ieee80211_iw_handler_def;
>  	dev->set_multicast_list =3D ieee80211_set_multicast_list;
>  	dev->change_mtu =3D ieee80211_change_mtu;
> -	dev->get_stats =3D ieee80211_get_stats;
> +
>  	dev->open =3D ieee80211_open;
>  	dev->stop =3D ieee80211_stop;
>  	dev->uninit =3D ieee80211_if_reinit;
> @@ -4796,7 +4787,7 @@ void ieee80211_if_mgmt_setup(struct net_device *dev=
)
>  	ether_setup(dev);
>  	dev->hard_start_xmit =3D ieee80211_mgmt_start_xmit;
>  	dev->change_mtu =3D ieee80211_change_mtu_apdev;
> -	dev->get_stats =3D ieee80211_get_stats;
> +
>  	dev->open =3D ieee80211_mgmt_open;
>  	dev->stop =3D ieee80211_mgmt_stop;
>  	dev->type =3D ARPHRD_IEEE80211_PRISM;
> @@ -5225,13 +5216,6 @@ void ieee80211_wake_queues(struct ieee80211_hw *hw=
)
>  }
>  EXPORT_SYMBOL(ieee80211_wake_queues);
> =20
> -struct net_device_stats *ieee80211_dev_stats(struct net_device *dev)
> -{
> -	struct ieee80211_sub_if_data *sdata;
> -	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> -	return &sdata->stats;
> -}
> -
>  static int __init ieee80211_init(void)
>  {
>  	struct sk_buff *skb;
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 6f7bae7..4ffdcfe 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -285,7 +285,6 @@ struct ieee80211_sub_if_data {
>  	unsigned int promisc:1;
>  	unsigned int use_protection:1; /* CTS protect ERP frames */
> =20
> -	struct net_device_stats stats;
>  	int drop_unencrypted;
>  	int eapol; /* 0 =3D process EAPOL frames as normal data frames,
>  		    * 1 =3D send EAPOL frames through wlan#ap to hostapd
> @@ -729,7 +728,6 @@ void ieee80211_if_setup(struct net_device *dev);
>  void ieee80211_if_mgmt_setup(struct net_device *dev);
>  int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
>  				 const char *name);
> -struct net_device_stats *ieee80211_dev_stats(struct net_device *dev);
> =20
>  /* ieee80211_ioctl.c */
>  extern const struct iw_handler_def ieee80211_iw_handler_def;

--=-4Ql4VGO5ie1mAPF9Ypb4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGz+Jy/ETPhpq3jKURAo+dAJ0aBcy+5lAbXmwABznqXj6dq9qndACfTWBc
fz5DKKlDJnRWvuZwcUrDv1M=
=aSHv
-----END PGP SIGNATURE-----

--=-4Ql4VGO5ie1mAPF9Ypb4--

