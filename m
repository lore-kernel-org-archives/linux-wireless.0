Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58760 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbXLXOLB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Dec 2007 09:11:01 -0500
Subject: Re: [PATCH 1/1] mac80211: restructure __ieee80211_rx
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11984961994110-git-send-email-ron.rindjunsky@intel.com>
References: <11984961994110-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hdFnUfrKdAOZv8Asgt9f"
Date: Mon, 24 Dec 2007 15:10:51 +0100
Message-Id: <1198505451.4103.40.camel@johannes.berg> (sfid-20071224_141107_265233_2EE4C637)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hdFnUfrKdAOZv8Asgt9f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-12-24 at 13:36 +0200, Ron Rindjunsky wrote:
> This patch makes a separation between Rx frame pre-handling which stays i=
n
> __ieee80211_rx and Rx frame handlers, moving to __ieee80211_rx_handle_pac=
ket.
> Although this separation has no affect in regular mode of operation, this=
 kind
> of mechanism will be used in A-MPDU frames reordering as it allows accumu=
lation
> of frames during pre-handling, dispatching them to later handling when ne=
cessary.
>=20
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>

That looks really good to me. I'll remove the qos pre-handler too after
you get your a-mpdu patches into the tree.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/rx.c |   86 ++++++++++++++++++++++++++++++-----------------=
-----
>  1 files changed, 50 insertions(+), 36 deletions(-)
>=20
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index e94cf30..bcc232c 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -272,11 +272,11 @@ ieee80211_rx_h_parse_qos(struct ieee80211_txrx_data=
 *rx)
>  	return TXRX_CONTINUE;
>  }
> =20
> -static ieee80211_txrx_result
> -ieee80211_rx_h_load_stats(struct ieee80211_txrx_data *rx)
> +
> +u32 ieee80211_rx_load_stats(struct ieee80211_local *local,
> +			      struct sk_buff *skb,
> +			      struct ieee80211_rx_status *status)
>  {
> -	struct ieee80211_local *local =3D rx->local;
> -	struct sk_buff *skb =3D rx->skb;
>  	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
>  	u32 load =3D 0, hdrtime;
>  	struct ieee80211_rate *rate;
> @@ -290,7 +290,7 @@ ieee80211_rx_h_load_stats(struct ieee80211_txrx_data =
*rx)
> =20
>  	rate =3D &mode->rates[0];
>  	for (i =3D 0; i < mode->num_rates; i++) {
> -		if (mode->rates[i].val =3D=3D rx->u.rx.status->rate) {
> +		if (mode->rates[i].val =3D=3D status->rate) {
>  			rate =3D &mode->rates[i];
>  			break;
>  		}
> @@ -315,15 +315,13 @@ ieee80211_rx_h_load_stats(struct ieee80211_txrx_dat=
a *rx)
>  	/* Divide channel_use by 8 to avoid wrapping around the counter */
>  	load >>=3D CHAN_UTIL_SHIFT;
>  	local->channel_use_raw +=3D load;
> -	rx->u.rx.load =3D load;
> =20
> -	return TXRX_CONTINUE;
> +	return load;
>  }
> =20
>  ieee80211_rx_handler ieee80211_rx_pre_handlers[] =3D
>  {
>  	ieee80211_rx_h_parse_qos,
> -	ieee80211_rx_h_load_stats,
>  	NULL
>  };
> =20
> @@ -1594,11 +1592,11 @@ static int prepare_for_handlers(struct ieee80211_=
sub_if_data *sdata,
>  }
> =20
>  /*
> - * This is the receive path handler. It is called by a low level driver =
when an
> - * 802.11 MPDU is received from the hardware.
> + * This is the actual Rx frames handler. as it blongs to Rx path it must
> + * be called with rcu_read_lock protection.
>   */
> -void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
> -		    struct ieee80211_rx_status *status)
> +void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw, struct sk_buf=
f *skb,
> +			    struct ieee80211_rx_status *status, u32 load)
>  {
>  	struct ieee80211_local *local =3D hw_to_local(hw);
>  	struct ieee80211_sub_if_data *sdata;
> @@ -1606,36 +1604,18 @@ void __ieee80211_rx(struct ieee80211_hw *hw, stru=
ct sk_buff *skb,
>  	struct ieee80211_hdr *hdr;
>  	struct ieee80211_txrx_data rx;
>  	u16 type;
> -	int prepres;
> +	int prepares;
>  	struct ieee80211_sub_if_data *prev =3D NULL;
>  	struct sk_buff *skb_new;
>  	u8 *bssid;
> =20
> -	/*
> -	 * key references and virtual interfaces are protected using RCU
> -	 * and this requires that we are in a read-side RCU section during
> -	 * receive processing
> -	 */
> -	rcu_read_lock();
> -
> -	/*
> -	 * Frames with failed FCS/PLCP checksum are not returned,
> -	 * all other frames are returned without radiotap header
> -	 * if it was previously present.
> -	 * Also, frames with less than 16 bytes are dropped.
> -	 */
> -	skb =3D ieee80211_rx_monitor(local, skb, status);
> -	if (!skb) {
> -		rcu_read_unlock();
> -		return;
> -	}
> -
>  	hdr =3D (struct ieee80211_hdr *) skb->data;
>  	memset(&rx, 0, sizeof(rx));
>  	rx.skb =3D skb;
>  	rx.local =3D local;
> =20
>  	rx.u.rx.status =3D status;
> +	rx.u.rx.load =3D load;
>  	rx.fc =3D le16_to_cpu(hdr->frame_control);
>  	type =3D rx.fc & IEEE80211_FCTL_FTYPE;
> =20
> @@ -1682,11 +1662,11 @@ void __ieee80211_rx(struct ieee80211_hw *hw, stru=
ct sk_buff *skb,
>  			continue;
> =20
>  		rx.flags |=3D IEEE80211_TXRXD_RXRA_MATCH;
> -		prepres =3D prepare_for_handlers(sdata, bssid, &rx, hdr);
> +		prepares =3D prepare_for_handlers(sdata, bssid, &rx, hdr);
>  		/* prepare_for_handlers can change sta */
>  		sta =3D rx.sta;
> =20
> -		if (!prepres)
> +		if (!prepares)
>  			continue;
> =20
>  		/*
> @@ -1731,11 +1711,45 @@ void __ieee80211_rx(struct ieee80211_hw *hw, stru=
ct sk_buff *skb,
>  		dev_kfree_skb(skb);
> =20
>   end:
> -	rcu_read_unlock();
> -
>  	if (sta)
>  		sta_info_put(sta);
>  }
> +
> +/*
> + * This is the receive path handler. It is called by a low level driver =
when an
> + * 802.11 MPDU is received from the hardware.
> + */
> +void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
> +		    struct ieee80211_rx_status *status)
> +{
> +	struct ieee80211_local *local =3D hw_to_local(hw);
> +	u32 pkt_load;
> +
> +	/*
> +	 * key references and virtual interfaces are protected using RCU
> +	 * and this requires that we are in a read-side RCU section during
> +	 * receive processing
> +	 */
> +	rcu_read_lock();
> +
> +	/*
> +	 * Frames with failed FCS/PLCP checksum are not returned,
> +	 * all other frames are returned without radiotap header
> +	 * if it was previously present.
> +	 * Also, frames with less than 16 bytes are dropped.
> +	 */
> +	skb =3D ieee80211_rx_monitor(local, skb, status);
> +	if (!skb) {
> +		rcu_read_unlock();
> +		return;
> +	}
> +
> +	pkt_load =3D ieee80211_rx_load_stats(local, skb, status);
> +
> +	__ieee80211_rx_handle_packet(hw, skb, status, pkt_load);
> +
> +	rcu_read_unlock();
> +}
>  EXPORT_SYMBOL(__ieee80211_rx);
> =20
>  /* This is a version of the rx handler that can be called from hard irq

--=-hdFnUfrKdAOZv8Asgt9f
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2+96qVg1VMiehFYAQKcnQ/+NXSnIr3Nhdoo0p/3upU8FZLZnT4II+cD
vZiNqDamdd+6iDGX2VawJlHVvCPNDgxKJYOjNq+fKLj1z8iiEjJcDnakT1OvbkFE
SUWS7YD0Ov5loa+lc2r6irJU0tNBWmsgGgz0SeK4vr1ffutjlt+JRazQ+jkpGtz2
DkggfSwlRi+pq52pOp3CuXR3mBz/PMFdpNSGvzah5jbT0bCHdWE6Gtomw1tQYLFl
M0NX6gdKYu2J3LaF3JV7JOayCaSRaaToLD2w+PK/rzQmP8eqF0tTdwK9pAqyxIOf
3icgg2pFfe9uulsuXXf93nvKP2o8q3IJmI9BMmjsXgg8eDpcdKw/5nz0KdXX2cId
NO9+J1x7se9pzI7dlJGJL5nFtcYOh6UfdHrZe0u6gWSYpH13Eclbaa27KZesjvc/
Z02PHw1UeC03sqKMWV5AGrgl1xMbmuYI2N0OckfhamEq8MHpbw96gN8tcA9hFwNI
hOhgZRD+OIUz/lO+KqsHDOtMN9irPgL7Vh7+ARldO7NDAKctBalLEA73zCZzCL9l
l3/HXiUDWDN2N6KV3C4DohCT2nPZrCSoqLVg8q9nXRRx4pgOUy3dcNvqoeYEskNp
yzNvP6rkYmfijQtgyCAjRMZc7c4DD1Qx5Bj4/M20qvw6oXAJOZGahWy8TH3B/z8r
4ikebmKYk7A=
=XShK
-----END PGP SIGNATURE-----

--=-hdFnUfrKdAOZv8Asgt9f--

