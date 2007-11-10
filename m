Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49475 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbXKJKKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Nov 2007 05:10:18 -0500
Subject: Re: [PATCH 3/4] o80211s: (mac80211s) basic mesh interface support
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <473516ee.26d7720a.3f57.ffff8233@mx.google.com> (sfid-20071110_022658_985099_309C7497)
References: <473516ee.26d7720a.3f57.ffff8233@mx.google.com>
	 (sfid-20071110_022658_985099_309C7497)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5O2GDsl4PM/EOeAHdZsE"
Date: Sat, 10 Nov 2007 11:11:39 +0100
Message-Id: <1194689500.7258.61.camel@johannes.berg> (sfid-20071110_101034_865005_4BEF61F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5O2GDsl4PM/EOeAHdZsE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -474,6 +474,7 @@ enum ieee80211_if_types {
>  	IEEE80211_IF_TYPE_AP,
>  	IEEE80211_IF_TYPE_STA,
>  	IEEE80211_IF_TYPE_IBSS,
> +	IEEE80211_IF_TYPE_MESH,

What happened to Dan's suggestion of calling this MESH_STA? And maybe in
nl80211 as well? I might've missed something, was there a conclusion?

Debugfs code looks good.

>  static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
>  {
> +	int meshhdrlen;
> +	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +
> +	meshhdrlen =3D (sdata->type =3D=3D IEEE80211_IF_TYPE_MESH) ? 5 : 0;
> +
>  	/* FIX: what would be proper limits for MTU?
>  	 * This interface uses 802.3 frames. */
> -	if (new_mtu < 256 || new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6) {
> +	if (new_mtu < 256 ||
> +		new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6 - meshhdrlen) {
>  		printk(KERN_WARNING "%s: invalid MTU %d\n",
>  		       dev->name, new_mtu);
>  		return -EINVAL;

Are you sure this is appropriate? As the comment says, interface is
802.3 framed. Don't the 802.11 specifications usually keep the frame
payload length and require the device to handle longer frames?

> +	atomic_t mesh_seqnum;

Hmm. Do we really need an atomic_t here?

=20
> +	case IEEE80211_IF_TYPE_MESH:
> +		if (!mesh_allocated) {
> +			/* Allocate all mesh structures when creating the first
> +			 * mesh interface.
> +			 */
> +			mesh_pathtbl_init();
> +			mesh_allocated =3D 1;
> +		}
> +		/* fall thru */

Will there be other structures to allocate? Maybe we should instead push
the "already" check into the _init()?

> +	/* TODO: check for expired neighbors, paths and frames to non resolved
> +	 * hw addresses
> +	 */

Seems dangerous to actually run the code w/o this, no?


> +	mgmt->u.beacon.beacon_int =3D
> +		cpu_to_le16(local->hw.conf.beacon_int);

Hmm. This is interesting. The beacon interval is a pure beacon
configuration after my patches, but here we're using it without having
userspace set up a beacon. What do we do in the IBSS case?

> +static int o80211s_getmeshpath(struct sk_buff *skb, struct nlmsghdr *nlh=
,
> +		void *arg)
> +{
> +	return 0;
> +}

Uh huh. Why is this here? Should it be filled?

> +	read_lock(&mesh_paths_lock);

When do we need the mesh paths? Should the structure use RCU maybe?

> +	if (sdata->type =3D=3D IEEE80211_IF_TYPE_MESH) {
> +		int meshhdrlen =3D ieee80211_get_mesh_hdrlen(
> +				(struct ieee80211s_hdr *) skb->data);
> +		/* Copy mesh header on cb to be used if forwarded.
> +		 * It will be used as mesh header template at
> +		 * tx.c:ieee80211_subif_start_xmit() if interface
> +		 * type is mesh and skb->pkt_type =3D=3D PACKET_OTHERHOST
> +		 */
> +		memcpy(skb->cb, skb->data + hdrlen, meshhdrlen);
> +		hdrlen +=3D meshhdrlen;

Thanks for the explanation. This only happens when we dev_queue_xmit()
it right away in the mesh forwarding code, right?

> +	/* Mesh forwarding */
> +	if (sdata->type =3D=3D IEEE80211_IF_TYPE_MESH) {
> +		u8 *mesh_ttl =3D &((struct ieee80211s_hdr *)skb->cb)->ttl;

Oh it's used here too :)

> @@ -230,6 +231,9 @@ ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data=
 *tx)
>  	     (tx->fc & IEEE80211_FCTL_STYPE) !=3D IEEE80211_STYPE_PROBE_REQ))
>  		return TXRX_DROP;
> =20
> +	if (tx->sdata->type =3D=3D IEEE80211_IF_TYPE_MESH)
> +		return TXRX_CONTINUE;

Is this right or should there be some other "is forwarded frame" check
to go with this? I'm not sure but it seems that frames we send via the
netdev need to be still checked? Or not because they're just injected
into the mesh? I think I'm confused.

> +	case IEEE80211_IF_TYPE_MESH:
> +		fc |=3D IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS;
> +		/* RA TA DA SA */
> +		if (is_multicast_ether_addr(skb->data))
> +			memcpy(hdr.addr1, skb->data, ETH_ALEN);
> +		else if (ieee80211s_nh_lookup(skb->data, hdr.addr1)) {

I think you should use RCU for the locking in the neighbour table. This
code should (IIRC) be under rcu read-side lock already so the neighbour
table reading would be lockless. Since updates are infrequent, RCU is a
good tradeoff.

> +EXPORT_SYMBOL(ieee80211_get_mesh_hdrlen);

Don't export this.

> +int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
> +		struct ieee80211_sub_if_data *sdata)
> +{
> +	/* TODO: create a per mesh interface atomic sequence counter */
> +	int mesh_seqnum  =3D atomic_inc_return(&sdata->u.sta.mesh_seqnum);

Since you use new_mesh_header only from within the TX code which is
serialised, you don't need atomic. Also, this *is* per-mesh interface
(sdata), the TODO makes no sense.

> +EXPORT_SYMBOL(ieee80211_new_mesh_header);

Don't export this either.

johannes

--=-5O2GDsl4PM/EOeAHdZsE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzWD2qVg1VMiehFYAQLXFA/7BX9XCt+f1HKySefg6tHZwY6OS2dwwWsn
/3jbhqpLBhsubnDBfzpFT3NiMIdXrgvpoDAxGP9V97ZMrnIa1IGOhVpnuPyB9ZjD
tXIqpibuR4j19+qUbLYdgl1qGW6PGjvZDtRBbS4ySmpfPvARpjBnv1C0/tdtu4hW
nwGZ6re/L38gwo17nQ98Q8KkOGJzwxtMcGEvprUo7vjxynAzS3Ryf5uqD0KnHYE/
ZV5UUAdmuuNBbBKu1yKR1bnFG7grmksAOZp37zzSPqXkDIlQ3OwKomENk4qJvIzz
wzSTy6Nm7bHXs2gezz263FEfDh4MXXxbjtAhAelGM1+tF0JOjA0Ty6we3ZVR3Cau
qX/om2FXtQkPXcnn4nP8rk5DYhVJbM3ol6dOZAsQ1IgcotGMeLADN0L/n/xiSNEh
FcW7CMufsG68U+sLXDEeeMHY+W7uvWU7bRwTql/CWJoFLkDRcgendHQYGdBzcgtZ
jW+WnvTEXipDaI+1VC82R4L6C1yalaOYbaTE8Z0xN3vt41EwopfmWEzR/++RMFat
Arin/K4tVv9vZw5ttYst6VVv3Ejo6OyTVBbSUK/I4kXAWeRK2wE9VGIeTmNRUiLD
f8n5w+bPzM5vFZu7ywkKLSrnm4BKyR8PJWA/OhB5vb234OSFdtD8KiblLJ7mKIaB
QjfeMz80g0M=
=nZSp
-----END PGP SIGNATURE-----

--=-5O2GDsl4PM/EOeAHdZsE--

