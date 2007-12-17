Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbXLQSG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 13:06:58 -0500
Subject: Re: [PATCH 3/8] mac80211: A-MPDU Rx adding basic functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11979070781347-git-send-email-ron.rindjunsky@intel.com>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070781347-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Z8ZefVcLjEAN2aVWBUc7"
Date: Mon, 17 Dec 2007 19:06:41 +0100
Message-Id: <1197914801.4885.74.camel@johannes.berg> (sfid-20071217_180701_381913_2C4B07AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Z8ZefVcLjEAN2aVWBUc7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +/* BACK parties */

Please write out "block-ack" or "BACK (block-ack)" :)
 =20
> +#define IEEE80211_MIN_AMPDU_BUF 0x8
> +#define IEEE80211_MAX_AMPDU_BUF 0x40

Any comments on what these represent? Should they be tunable?

> +	if (tid_agg_rx->state !=3D HT_AGG_STATE_IDLE) {
> +#ifdef CONFIG_MAC80211_HT_DEBUG
> +		if (net_ratelimit())
> +			printk(KERN_DEBUG "unexpected Block Ack Req from "
> +				"%s on tid %u\n",
> +				print_mac(mac, mgmt->sa), tid);
> +#endif /* CONFIG_MAC80211_HT_DEBUG */
> +		goto end;
> +	}
> +
> +	/* prepare reordering buffer */
> +	tid_agg_rx->reorder_buf =3D
> +		kmalloc(buf_size * sizeof(struct sk_buf *), GFP_ATOMIC);
> +	if (!tid_agg_rx->reorder_buf) {
> +		printk(KERN_ERR "can not allocate reordering buffer "
> +						"to tid %d\n", tid);
> +		tid_agg_rx->state =3D HT_AGG_STATE_IDLE;

That's unnecessary, you can't get here w/ state !=3D IDLE afaict.

> +		goto end;
> +	}
> +	memset(tid_agg_rx->reorder_buf, 0,
> +		buf_size * sizeof(struct sk_buf *));
> +
> +	if (local->ops->ampdu_action)
> +		ret =3D local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_START,
> +					       sta->addr, tid, start_seq_num);
> +	if (ret) {
> +#ifdef CONFIG_MAC80211_HT_DEBUG
> +		if (net_ratelimit())
> +			printk(KERN_DEBUG "A-MPDU on tid %d result: %s", tid,
> +			(ret =3D=3D -EOPNOTSUPP)? "Not Supported": "Driver Error");

I'm not sure we need to ratelimit debug messages, and I think we should
print out the error code. People who are writing a driver will need to
decipher the number but it's an error they return so I think we should
give them a chance to see which error path was hit.

> +void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
> +				u16 initiator, u16 reason_code)
> +{
> +	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
> +	struct sk_buff *skb;
> +	struct ieee80211_mgmt *mgmt;
> +	u16 params;
> +
> +	skb =3D dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom + 1 +
> +					sizeof(mgmt->u.action.u.delba));
> +
> +	if (!skb) {
> +		printk(KERN_ERR "%s: failed to allocate buffer "
> +					"for delba frame\n", dev->name);

Do we send this as a reply to anything, ie. should it be rate-limited
too?

> +void ieee80211_sta_stop_rx_BA_session(struct net_device *dev, u8 *ra, u1=
6 tid,
> +					u16 initiator, u16 reason)
> +{

> +	/* check if the TID is in opertional state */

small typo

> +	/* stop HW Rx aggregation */
> +	if (local->ops->ampdu_action) {

Can we get into that path with ops->ampdu_action =3D=3D NULL? I'd think not
because state is required to be active... I'd rather stick in a
	BUG_ON(!local->ops->ampdu_action)
because it seems to me that'd be a mac80211 bug.

> + * After receiving Block Ack Request (BAR) we activated a
> + * timer after each frame arrives from the originator.
> + * if this timer expires ieee80211_sta_stop_rx_BA_session will be execut=
ed.
> + */
> +void sta_rx_agg_session_timer_expired(unsigned long data)
> +{
> +	/* not an elegant detour, but there is no choice as the timer passes
> +	* only one argument, and ieee80211_local is needed here */
> +	int *ptid =3D (int *)data;
> +	int *timer_to_id =3D ptid - *ptid;
> +	struct sta_info *temp_sta =3D container_of(timer_to_id, struct sta_info=
,
> +					 timer_to_tid[0]);

I think this needs more comments. I can, after a while, see what it
does, but I'm not even sure it's correct. The whole timer_to_id thing is
only for this code?

> +	struct ieee80211_local *local =3D temp_sta->local;
> +	struct sta_info *sta;
> +	u16 tid =3D (u16)*ptid;
> +	sta =3D sta_info_get(local, temp_sta->addr);

Missing newline.

> +	if (!sta)
> +		return;

Why do you even do a sta_info_get() on the temp_sta's addr? Either you
already have a good pointer or the whole thing will access invalid
memory.

johannes

--=-Z8ZefVcLjEAN2aVWBUc7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2a6sKVg1VMiehFYAQJ+Gw/+NzYf89QWa7XVEEBvCRc8VZqN6Zd9epsn
aQRnRlvNrC7OoUBfhLjrlq0XAYDIu3MdTbyhFqQkBSWhcXL88LUOSdc5o2428oXR
kr+ZL+B0Qgcnj1P/PIuAOmA5lBQXJvMxHgQpvr1xfQrqDjRPakswXq8FJDuhC8hZ
EO9UyUbr/X0ZFPzSO2kjgoLfBzRIxDxHjfLeNBF/41h//46UYhcee4Q19qsyk7lK
Uuc0wrNDihL31qS8GwnOaKhP0OWbcHUZe7my78KGvd7XFe+TXuVaEpuYId+KeGQO
Dbkb9sSSbWP76aSHMLluWh4dEJfYW5hbUEQcrmG5KqNo1662Bbe1nPsUPH7Jywfs
Q/jEky13o/H+iqmsS+K6RBWMna555jZ7aQml01pP2KWgoSLrI20nhyLJISgqV3F0
BVinjzm/1S/fY6nhCQe41GxiPB6w22FDUnNtjG8Do0XJxXvuk/QZh5ZcPr4qUVCT
6YQi+jXW1mqQlhZz7MzMXsVwAzLmRobqgjvL8qxyLRyJPO6UvxYrU7qx3hDj0niM
uHwSk9BcFw7M3UXRfAKCOD1GBomUtr5DUcW4VRrrUCf/01mOmdQSvPILNF/u1mfE
DmX4jg54Exy1zjohYZAwccXcDFDzSFO5pl/MGHqrhEKHcoknLVL1VmQ9YZ6y5y9U
uUTH7+/GCg0=
=IhXI
-----END PGP SIGNATURE-----

--=-Z8ZefVcLjEAN2aVWBUc7--

