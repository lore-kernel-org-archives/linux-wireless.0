Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53186 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609AbYHFPfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 11:35:16 -0400
Subject: Re: [PATCH v3] mac80211: fix use of skb->cb for mesh forwarding
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <4899bd8d.1dbf7e0a.351c.5d69@mx.google.com> (sfid-20080806_170448_701603_CFBFF95C)
References: <4899bd8d.1dbf7e0a.351c.5d69@mx.google.com>
	 (sfid-20080806_170448_701603_CFBFF95C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/2YiJgl2rJcMmWAmRdrI"
Date: Wed, 06 Aug 2008 17:34:39 +0200
Message-Id: <1218036879.23048.11.camel@johannes.berg> (sfid-20080806_173546_330413_E70EC330)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/2YiJgl2rJcMmWAmRdrI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-05 at 19:34 +0200, Luis Carlos Cobo wrote:
> Now we deal with mesh forwarding before the 802.11->802.3 conversion, thu=
s
> eliminating a few unnecessary steps. The next hop lookup is called from
> ieee80211_master_start_xmit() instead of subif_start_xmit(). Until the ne=
xt hop
> is found, RA in the frame will be all zeroes for frames originating from =
the
> device. For forwarded frames, RA will contain the TA of the received fram=
e,
> which will be necessary to send a path error if a next hop is not found.
>=20
> Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/mesh.h         |    5 +--
>  net/mac80211/mesh_hwmp.c    |   19 ++++---
>  net/mac80211/mesh_pathtbl.c |   11 ++---
>  net/mac80211/rx.c           |  116 +++++++++++++++++++++++++------------=
------
>  net/mac80211/tx.c           |   45 +++++++++--------
>  5 files changed, 106 insertions(+), 90 deletions(-)
>=20
> diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
> index 669eafa..7495fbb 100644
> --- a/net/mac80211/mesh.h
> +++ b/net/mac80211/mesh.h
> @@ -214,8 +214,7 @@ void ieee80211s_stop(void);
>  void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
> =20
>  /* Mesh paths */
> -int mesh_nexthop_lookup(u8 *next_hop, struct sk_buff *skb,
> -		struct net_device *dev);
> +int mesh_nexthop_lookup(struct sk_buff *skb, struct net_device *dev);
>  void mesh_path_start_discovery(struct net_device *dev);
>  struct mesh_path *mesh_path_lookup(u8 *dst, struct net_device *dev);
>  struct mesh_path *mesh_path_lookup_by_idx(int idx, struct net_device *de=
v);
> @@ -286,6 +285,4 @@ static inline void mesh_path_activate(struct mesh_pat=
h *mpath)
>  #define mesh_allocated	0
>  #endif
> =20
> -#define MESH_PREQ(skb)	(skb->cb + 30)
> -
>  #endif /* IEEE80211S_H */
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index 7fa149e..08aca44 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -758,29 +758,30 @@ enddiscovery:
>  /**
>   * ieee80211s_lookup_nexthop - put the appropriate next hop on a mesh fr=
ame
>   *
> - * @next_hop: output argument for next hop address
> - * @skb: frame to be sent
> + * @skb: 802.11 frame to be sent
>   * @dev: network device the frame will be sent through
> + * @fwd_frame: true if this frame was originally from a different host
>   *
>   * Returns: 0 if the next hop was found. Nonzero otherwise. If no next h=
op is
>   * found, the function will start a path discovery and queue the frame s=
o it is
>   * sent when the path is resolved. This means the caller must not free t=
he skb
>   * in this case.
>   */
> -int mesh_nexthop_lookup(u8 *next_hop, struct sk_buff *skb,
> -		struct net_device *dev)
> +int mesh_nexthop_lookup(struct sk_buff *skb, struct net_device *dev)
>  {
>  	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
>  	struct sk_buff *skb_to_free =3D NULL;
>  	struct mesh_path *mpath;
> +	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
> +	u8 *dst_addr =3D hdr->addr3;
>  	int err =3D 0;
> =20
>  	rcu_read_lock();
> -	mpath =3D mesh_path_lookup(skb->data, dev);
> +	mpath =3D mesh_path_lookup(dst_addr, dev);
> =20
>  	if (!mpath) {
> -		mesh_path_add(skb->data, dev);
> -		mpath =3D mesh_path_lookup(skb->data, dev);
> +		mesh_path_add(dst_addr, dev);
> +		mpath =3D mesh_path_lookup(dst_addr, dev);
>  		if (!mpath) {
>  			dev_kfree_skb(skb);
>  			sdata->u.sta.mshstats.dropped_frames_no_route++;
> @@ -792,13 +793,13 @@ int mesh_nexthop_lookup(u8 *next_hop, struct sk_buf=
f *skb,
>  	if (mpath->flags & MESH_PATH_ACTIVE) {
>  		if (time_after(jiffies, mpath->exp_time -
>  			msecs_to_jiffies(sdata->u.sta.mshcfg.path_refresh_time))
> -				&& skb->pkt_type !=3D PACKET_OTHERHOST
> +				&& !memcmp(dev->dev_addr, hdr->addr4, ETH_ALEN)
>  				&& !(mpath->flags & MESH_PATH_RESOLVING)
>  				&& !(mpath->flags & MESH_PATH_FIXED)) {
>  			mesh_queue_preq(mpath,
>  					PREQ_Q_F_START | PREQ_Q_F_REFRESH);
>  		}
> -		memcpy(next_hop, mpath->next_hop->addr,
> +		memcpy(hdr->addr1, mpath->next_hop->addr,
>  				ETH_ALEN);
>  	} else {
>  		if (!(mpath->flags & MESH_PATH_RESOLVING)) {
> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
> index 5f88a2e..838ee60 100644
> --- a/net/mac80211/mesh_pathtbl.c
> +++ b/net/mac80211/mesh_pathtbl.c
> @@ -388,18 +388,15 @@ void mesh_path_tx_pending(struct mesh_path *mpath)
>  void mesh_path_discard_frame(struct sk_buff *skb, struct net_device *dev=
)
>  {
>  	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
>  	struct mesh_path *mpath;
>  	u32 dsn =3D 0;
> =20
> -	if (skb->pkt_type =3D=3D PACKET_OTHERHOST) {
> -		struct ieee80211s_hdr *prev_meshhdr;
> -		int mshhdrlen;
> +	if (memcmp(hdr->addr4, dev->dev_addr, ETH_ALEN) !=3D 0) {
>  		u8 *ra, *da;
> =20
> -		prev_meshhdr =3D ((struct ieee80211s_hdr *)skb->cb);
> -		mshhdrlen =3D ieee80211_get_mesh_hdrlen(prev_meshhdr);
> -		da =3D skb->data;
> -		ra =3D MESH_PREQ(skb);
> +		da =3D hdr->addr3;
> +		ra =3D hdr->addr2;
>  		mpath =3D mesh_path_lookup(da, dev);
>  		if (mpath)
>  			dsn =3D ++mpath->dsn;
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index a67ded3..60e9ea1 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1114,20 +1114,9 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *r=
x)
> =20
>  	hdrlen =3D ieee80211_get_hdrlen(fc);
> =20
> -	if (ieee80211_vif_is_mesh(&sdata->vif)) {
> -		int meshhdrlen =3D ieee80211_get_mesh_hdrlen(
> +	if (ieee80211_vif_is_mesh(&sdata->vif))
> +		hdrlen +=3D ieee80211_get_mesh_hdrlen(
>  				(struct ieee80211s_hdr *) (skb->data + hdrlen));
> -		/* Copy on cb:
> -		 *  - mesh header: to be used for mesh forwarding
> -		 * decision. It will also be used as mesh header template at
> -		 * tx.c:ieee80211_subif_start_xmit() if interface
> -		 * type is mesh and skb->pkt_type =3D=3D PACKET_OTHERHOST
> -		 *  - ta: to be used if a RERR needs to be sent.
> -		 */
> -		memcpy(skb->cb, skb->data + hdrlen, meshhdrlen);
> -		memcpy(MESH_PREQ(skb), hdr->addr2, ETH_ALEN);
> -		hdrlen +=3D meshhdrlen;
> -	}
> =20
>  	/* convert IEEE 802.11 header + possible LLC headers into Ethernet
>  	 * header
> @@ -1274,38 +1263,6 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx=
)
>  		}
>  	}
> =20
> -	/* Mesh forwarding */
> -	if (ieee80211_vif_is_mesh(&sdata->vif)) {
> -		u8 *mesh_ttl =3D &((struct ieee80211s_hdr *)skb->cb)->ttl;
> -		(*mesh_ttl)--;
> -
> -		if (is_multicast_ether_addr(skb->data)) {
> -			if (*mesh_ttl > 0) {
> -				xmit_skb =3D skb_copy(skb, GFP_ATOMIC);
> -				if (xmit_skb)
> -					xmit_skb->pkt_type =3D PACKET_OTHERHOST;
> -				else if (net_ratelimit())
> -					printk(KERN_DEBUG "%s: failed to clone "
> -					       "multicast frame\n", dev->name);
> -			} else
> -				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.sta,
> -							     dropped_frames_ttl);
> -		} else if (skb->pkt_type !=3D PACKET_OTHERHOST &&
> -			compare_ether_addr(dev->dev_addr, skb->data) !=3D 0) {
> -			if (*mesh_ttl =3D=3D 0) {
> -				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.sta,
> -							     dropped_frames_ttl);
> -				dev_kfree_skb(skb);
> -				skb =3D NULL;
> -			} else {
> -				xmit_skb =3D skb;
> -				xmit_skb->pkt_type =3D PACKET_OTHERHOST;
> -				if (!(dev->flags & IFF_PROMISC))
> -					skb  =3D NULL;
> -			}
> -		}
> -	}
> -
>  	if (skb) {
>  		/* deliver to local stack */
>  		skb->protocol =3D eth_type_trans(skb, dev);
> @@ -1436,6 +1393,63 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
>  }
> =20
>  static ieee80211_rx_result debug_noinline
> +ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
> +{
> +	struct ieee80211_hdr *hdr;
> +	struct ieee80211s_hdr *mesh_hdr;
> +	unsigned int hdrlen;
> +	struct sk_buff *skb =3D rx->skb, *fwd_skb;
> +
> +	hdr =3D (struct ieee80211_hdr *) skb->data;
> +	hdrlen =3D ieee80211_hdrlen(hdr->frame_control);
> +	mesh_hdr =3D (struct ieee80211s_hdr *) (skb->data + hdrlen);
> +
> +	if (!ieee80211_is_data(hdr->frame_control))
> +		return RX_CONTINUE;
> +
> +	if (!mesh_hdr->ttl)
> +		/* illegal frame */
> +		return RX_DROP_MONITOR;
> +
> +	if (compare_ether_addr(rx->dev->dev_addr, hdr->addr3) =3D=3D 0)
> +		return RX_CONTINUE;
> +
> +	mesh_hdr->ttl--;
> +
> +	if (rx->flags & IEEE80211_RX_RA_MATCH) {
> +		if (!mesh_hdr->ttl)
> +			IEEE80211_IFSTA_MESH_CTR_INC(&rx->sdata->u.sta,
> +						     dropped_frames_ttl);
> +		else {
> +			struct ieee80211_hdr *fwd_hdr;
> +			fwd_skb =3D skb_copy(skb, GFP_ATOMIC);
> +
> +			if (!fwd_skb && net_ratelimit())
> +				printk(KERN_DEBUG "%s: failed to clone mesh frame\n",
> +						   rx->dev->name);
> +
> +			fwd_hdr =3D  (struct ieee80211_hdr *) fwd_skb->data;
> +			/*
> +			 * Save TA to addr1 to send TA a path error if a
> +			 * suitable next hop is not found
> +			 */
> +			memcpy(fwd_hdr->addr1, fwd_hdr->addr2, ETH_ALEN);
> +			memcpy(fwd_hdr->addr2, rx->dev->dev_addr, ETH_ALEN);
> +			fwd_skb->dev =3D rx->local->mdev;
> +			fwd_skb->iif =3D rx->dev->ifindex;
> +			dev_queue_xmit(fwd_skb);
> +		}
> +	}
> +
> +	if (is_multicast_ether_addr(hdr->addr3) ||
> +	    rx->dev->flags & IFF_PROMISC)
> +		return RX_CONTINUE;
> +	else
> +		return RX_DROP_MONITOR;
> +}
> +
> +
> +static ieee80211_rx_result debug_noinline
>  ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
>  {
>  	struct net_device *dev =3D rx->dev;
> @@ -1668,10 +1682,12 @@ static void ieee80211_invoke_rx_handlers(struct i=
eee80211_sub_if_data *sdata,
>  	rx->sdata =3D sdata;
>  	rx->dev =3D sdata->dev;
> =20
> -#define CALL_RXH(rxh)		\
> -	res =3D rxh(rx);		\
> -	if (res !=3D RX_CONTINUE)	\
> -		goto rxh_done;
> +#define CALL_RXH(rxh)			\
> +	do {				\
> +		res =3D rxh(rx);		\
> +		if (res !=3D RX_CONTINUE)	\
> +			goto rxh_done;  \
> +	} while (0);
> =20
>  	CALL_RXH(ieee80211_rx_h_passive_scan)
>  	CALL_RXH(ieee80211_rx_h_check)
> @@ -1683,6 +1699,8 @@ static void ieee80211_invoke_rx_handlers(struct iee=
e80211_sub_if_data *sdata,
>  	/* must be after MMIC verify so header is counted in MPDU mic */
>  	CALL_RXH(ieee80211_rx_h_remove_qos_control)
>  	CALL_RXH(ieee80211_rx_h_amsdu)
> +	if (ieee80211_vif_is_mesh(&sdata->vif))
> +		CALL_RXH(ieee80211_rx_h_mesh_fwding);
>  	CALL_RXH(ieee80211_rx_h_data)
>  	CALL_RXH(ieee80211_rx_h_ctrl)
>  	CALL_RXH(ieee80211_rx_h_mgmt)
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 771ec68..4788f7b 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1301,6 +1301,7 @@ int ieee80211_master_start_xmit(struct sk_buff *skb=
,
>  				struct net_device *dev)
>  {
>  	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> +	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
>  	struct net_device *odev =3D NULL;
>  	struct ieee80211_sub_if_data *osdata;
>  	int headroom;
> @@ -1328,6 +1329,20 @@ int ieee80211_master_start_xmit(struct sk_buff *sk=
b,
> =20
>  	osdata =3D IEEE80211_DEV_TO_SUB_IF(odev);
> =20
> +	if (ieee80211_vif_is_mesh(&osdata->vif) &&
> +	    ieee80211_is_data(hdr->frame_control)) {
> +		if (ieee80211_is_data(hdr->frame_control)) {
> +			if (is_multicast_ether_addr(hdr->addr3))
> +				memcpy(hdr->addr1, hdr->addr3, ETH_ALEN);
> +			else
> +				if (mesh_nexthop_lookup(skb, odev))
> +					return  0;
> +			if (memcmp(odev->dev_addr, hdr->addr4, ETH_ALEN) !=3D 0)
> +				IEEE80211_IFSTA_MESH_CTR_INC(&osdata->u.sta,
> +							     fwded_frames);
> +		}
> +	}
> +
>  	may_encrypt =3D !skb->do_not_encrypt;
> =20
>  	headroom =3D osdata->local->tx_headroom;
> @@ -1472,30 +1487,17 @@ int ieee80211_subif_start_xmit(struct sk_buff *sk=
b,
>  	case IEEE80211_IF_TYPE_MESH_POINT:
>  		fc |=3D cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
>  		/* RA TA DA SA */
> -		if (is_multicast_ether_addr(skb->data))
> -			memcpy(hdr.addr1, skb->data, ETH_ALEN);
> -		else if (mesh_nexthop_lookup(hdr.addr1, skb, dev))
> -				return 0;
> +		memset(hdr.addr1, 0, ETH_ALEN);
>  		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
>  		memcpy(hdr.addr3, skb->data, ETH_ALEN);
>  		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
> -		if (skb->pkt_type =3D=3D PACKET_OTHERHOST) {
> -			/* Forwarded frame, keep mesh ttl and seqnum */
> -			struct ieee80211s_hdr *prev_meshhdr;
> -			prev_meshhdr =3D ((struct ieee80211s_hdr *)skb->cb);
> -			meshhdrlen =3D ieee80211_get_mesh_hdrlen(prev_meshhdr);
> -			memcpy(&mesh_hdr, prev_meshhdr, meshhdrlen);
> -			sdata->u.sta.mshstats.fwded_frames++;
> -		} else {
> -			if (!sdata->u.sta.mshcfg.dot11MeshTTL) {
> -				/* Do not send frames with mesh_ttl =3D=3D 0 */
> -				sdata->u.sta.mshstats.dropped_frames_ttl++;
> -				ret =3D 0;
> -				goto fail;
> -			}
> -			meshhdrlen =3D ieee80211_new_mesh_header(&mesh_hdr,
> -							       sdata);
> +		if (!sdata->u.sta.mshcfg.dot11MeshTTL) {
> +			/* Do not send frames with mesh_ttl =3D=3D 0 */
> +			sdata->u.sta.mshstats.dropped_frames_ttl++;
> +			ret =3D 0;
> +			goto fail;
>  		}
> +		meshhdrlen =3D ieee80211_new_mesh_header(&mesh_hdr, sdata);
>  		hdrlen =3D 30;
>  		break;
>  #endif
> @@ -1543,7 +1545,8 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
>  	 * Drop unicast frames to unauthorised stations unless they are
>  	 * EAPOL frames from the local station.
>  	 */
> -	if (unlikely(!is_multicast_ether_addr(hdr.addr1) &&
> +	if (!ieee80211_vif_is_mesh(&sdata->vif) &&
> +		unlikely(!is_multicast_ether_addr(hdr.addr1) &&
>  		      !(sta_flags & WLAN_STA_AUTHORIZED) &&
>  		      !(ethertype =3D=3D ETH_P_PAE &&
>  		       compare_ether_addr(dev->dev_addr,

--=-/2YiJgl2rJcMmWAmRdrI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImcSMAAoJEKVg1VMiehFYmqQP/0BdEnPOMxcsehLAy4gWub5f
n/RY3l6e6roiIfIdGDlx/lW+bBNy/hCV7y+7AY4uvAG7riLz1zOe+iGpTXhxM7JI
xqNjm837NmjWyVLqtaiz/GmoAp+4TknZBofbqIZEeGxUW4D9diAauwC/wF/XaiDC
SVeGpvF6nTvKlx2ThDGrWdM3LFmQQFyxNmmwt9XyxFLVu4f67dtMoqrG8P+yqHSD
V7qz5xsJOu6E9Ei5PR+A6iziIWa6lnoSvSicAHxj8W7Z351KkNBY7JI6dTHuEway
+IYVSrC68LdhgvEjO3FLF2FCLhbpoil5llcRfAATKjeWWpIL0SEDNH8uGK5BBKmq
MBa7nUnCaxgij1mvgBI8hRyPZFMsY77QUn3prVuQmXgKsrOnucbBUcvkFXlG6WT0
kzuGgeWfOk5QzyTrFYs0JoZWemBeu2dRSPB37Wn+wWHJ8nZfFkP5G+wbU/3sL0nY
8fxzDjCY3oAfgnbCYF/4B/9txEk0Z22lk0lD6L+D7NFekzlfa/jJj6oj0OwKGPhr
DJM8/zpMwLdF0RmVShQI4icooL2xfxL1uaEHX00Nj+0OwTTtJoeQu5PYf4Iu9Ybt
QwaFHCI0kOQCSHw/mfPEXbChqqxDOXrQKc3TS4pumU562701X5NzsbdR57euCYla
Uq82OlOeJ3m5eSfQxftf
=C2v+
-----END PGP SIGNATURE-----

--=-/2YiJgl2rJcMmWAmRdrI--

