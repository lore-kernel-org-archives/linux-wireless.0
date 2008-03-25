Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59023 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbYCYP3s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 11:29:48 -0400
Subject: Re: [RFC] mac80211: handling Qdisc issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com
In-Reply-To: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-glBmlLxEJb4DNqypdK6c"
Date: Tue, 25 Mar 2008 14:00:26 +0100
Message-Id: <1206450026.16475.261.camel@johannes.berg> (sfid-20080325_152951_989987_0767DCD4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-glBmlLxEJb4DNqypdK6c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Sorry for the long delay, I totally had forgotten about this patch.

I don't directly see any problems this introduces, but given that my
original patch was still work-in-progress there are a number of things
I'm not entirely sure about.

Let's see if I can remember them.

First off, I really dislike drivers having to do #ifdef
CONFIG_NETDEVICES_MULTIQUEUE. But I think that can fairly easily be
solved by making mac80211 ignore the hw->queues and hw->ampdu_queues in
the non-MAC80211_QOS case.

Secondly, during making this patch I noticed that mac80211 always
announces QoS capability even if the kernel was configured without
NET_SCHED, in which case we can't actually do QoS. However, I'm not
entirely sure what the IEEE 802.11 spec mandates in this case, I would
welcome opinions on that. I tend to think we shouldn't announce QoS
support, but on the other hand we still have rudimentary QoS support in
that we're able to parse and send QoS frames although we can't actually
do real QoS. Same goes for HT, we can, in that case, accept ampdu
streams but not send them.

I have just discovered that adm8211 seems to be unable to even send
QoS-type frames, so I think we should make mac80211's QoS-support also
depend on hw->queues >=3D 4 and not announce QoS support in any other
case. Any objections to that? HT support of course follows since a HT
STA must implement QoS. We could make the code then set hw->queues to 1
when MAC80211_QOS is disabled and be done with it.

A further item I'd like to do is make the qdisc have actual
configuration, but that's of course not necessary with this patch.

Overall, I think we can merge this patch modulo a few minor things among
which, of course, is that it doesn't apply as-is any more. A few code
comments (that may well be caused by myself since I wrote the original
code) below.

> --- a/drivers/net/wireless/b43/dma.c
> +++ b/drivers/net/wireless/b43/dma.c
> @@ -1294,7 +1294,12 @@ int b43_dma_tx(struct b43_wldev *dev,
>  		hdr->frame_control |=3D cpu_to_le16(IEEE80211_FCTL_MOREDATA);
>  	} else {
>  		/* Decide by priority where to put this frame. */
> -		ring =3D priority_to_txring(dev, ctl->queue);
> +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
> +		ring =3D priority_to_txring(dev, skb->queue_mapping);
> +#else
> +		/* XXX: b43 qos needs a lot of work */
> +		ring =3D 1;
> +#endif

I think that can go in favour of using skb_get_queue_mapping(), and that
should work then since QoS was implemented.

> --- a/drivers/net/wireless/b43legacy/dma.c
> +++ b/drivers/net/wireless/b43legacy/dma.c
> @@ -1323,7 +1323,11 @@ int b43legacy_dma_tx(struct b43legacy_wldev *dev,
>  	int err =3D 0;
>  	unsigned long flags;
> =20
> -	ring =3D priority_to_txring(dev, ctl->queue);
> +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
> +	ring =3D priority_to_txring(dev, skb->queue_mapping);
> +#else
> +	ring =3D 1;
> +#endif

Same here, of course, although b43legacy only implements ring 1 IIRC and
skb_get_queue_mapping returns 0 in the non-MQ case, so it'll need a bit
of further work. For now, I guess leaving both these pieces of code as
is would be fine, though of course it doesn't actually apply now and
will need some changes.
=20
>  	tx_status->retry_count =3D tx_resp->failure_frame;
> -	tx_status->queue_number =3D status;
> -	tx_status->queue_length =3D tx_resp->bt_kill_count;
> -	tx_status->queue_length |=3D tx_resp->failure_rts;

This raises the question whether we actually need to keep this. I
removed it because it seemed that we don't need it since mac80211 says
which queue we send on and doesn't care if the driver deviates from that
(while of course it hopes it won't.)

>  /**
> @@ -714,7 +679,12 @@ enum ieee80211_hw_flags {
>   * @max_noise: like @max_rssi, but for the noise value.
>   *
>   * @queues: number of available hardware transmit queues for
> - *	data packets. WMM/QoS requires at least four.
> + *	data packets. WMM/QoS requires at least four, these
> + *	queues need to have configurable access parameters.

Come to think of it... Maybe we should add that if the hardware uses a
queue for beaconing then that queue shouldn't be included in this
number. Can do later though with proper docs on QoS though.

> +config MAC80211_QOS
> +	def_bool y
> +	depends on MAC80211
> +	depends on NET_SCHED
> +	depends on NETDEVICES_MULTIQUEUE

This makes me think that now maybe we should have a Kconfig symbol that
is just a display saying "QoS/HT will not be available" in the Kconfig,
just as a comment, in the other case. Not necessary for this patch, of
course, since it's just a helpful hint to the user.

> @@ -1485,8 +1478,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  		return result;
> =20
>  	/* for now, mdev needs sub_if_data :/ */
> -	mdev =3D alloc_netdev(sizeof(struct ieee80211_sub_if_data),
> -			    "wmaster%d", ether_setup);
> +	mdev =3D alloc_netdev_mq(sizeof(struct ieee80211_sub_if_data),
> +			       "wmaster%d", ether_setup,
> +			       hw->queues + hw->ampdu_queues);
>  	if (!mdev)
>  		goto fail_mdev_alloc;
> =20
> @@ -1578,6 +1572,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  		goto fail_wep;
>  	}
> =20
> +	if (hw->queues > IEEE80211_MAX_QUEUES)
> +		hw->queues =3D IEEE80211_MAX_QUEUES;
> +	if (hw->ampdu_queues > IEEE80211_MAX_AMPDU_QUEUES)
> +		hw->ampdu_queues =3D IEEE80211_MAX_AMPDU_QUEUES;
> +
>  	ieee80211_install_qdisc(local->mdev);
> =20
>  	/* add one default STA interface */

That looks the wrong way around, shouldn't it first sanitise the numbers
and then allocate the master? I may well have made that mistake myself.
Of course, assuming drivers give sane numbers, nothing will ever happen.

> @@ -1089,8 +1069,14 @@ static int __ieee80211_tx(struct ieee80211_local *=
local, struct sk_buff *skb,
>  		for (i =3D 0; i < tx->u.tx.num_extra_frag; i++) {
>  			if (!tx->u.tx.extra_frag[i])
>  				continue;
> -			if (__ieee80211_queue_stopped(local, control->queue))
> -				return IEEE80211_TX_FRAG_AGAIN;
> +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
> +			if (__netif_subqueue_stopped(local->mdev,
> +					tx->u.tx.extra_frag[i]->queue_mapping))
> +				return NETDEV_TX_BUSY; /* XXX: FRAG AGAIN! */
> +#else
> +			if (netif_queue_stopped(local->mdev))
> +				return NETDEV_TX_BUSY; /* XXX: FRAG AGAIN! */
> +#endif

I think this "XXX: FRAG AGAIN" is the big TODO item in this patch. We
need to figure out a way to not retransmit the whole packet. What will
happen right now is that we'll give the skb back to the stack and then
get it back again into ieee80211_master_start_xmit which would cause us
to fragment it again and retransmit all fragments. I think we can solve
this by putting a fragment bitmap into skb->cb[].

I'm fine with doing that in a follow-up patch as long as you modify this
patch to disable fragmentation completely for a while, that way we won't
cause unexpected behaviour for the <1% of people who actually use
fragmentation :)

Another thing playing into this is that with the tkip field removed from
struct ieee80211_tx_control again, we can actually fit that into
skb->cb. Hence, we wouldn't need to copy around all the data all the
time and could even leave it in skb->cb when passing the skb to drivers,
only drivers that need skb->cb themselves would have to copy it out to
some other structure.

If you just disable fragmentation for now I can probably help work on
the remaining issues.

> +#define QD_NUM(hw) hw->queues + hw->ampdu_queues

Although it's not used in a context where it matters right now, I think
this should be parenthesized

> @@ -653,10 +632,13 @@ int ieee80211_ht_agg_queue_add(struct ieee80211_loc=
al *local,
>  	DECLARE_MAC_BUF(mac);
> =20
>  	/* prepare the filter and save it for the SW queue
> -	 * matching the recieved HW queue */
> +	 * matching the received HW queue */
> +
> +	if (!local->hw.ampdu_queues)
> +		return -EPERM;

Is that the right error code?
=20
> @@ -665,13 +647,10 @@ int ieee80211_ht_agg_queue_add(struct ieee80211_loc=
al *local,
>  			 * on this tid first we need to drain them
>  			 * on the previous queue
>  			 * since HT is strict in order */
> -#ifdef CONFIG_MAC80211_HT_DEBUG
> -			if (net_ratelimit())
>  				printk(KERN_DEBUG "allocated aggregation queue"
>  					" %d tid %d addr %s pool=3D0x%lX",
>  					i, tid, print_mac(mac, sta->addr),
>  					q->qdisc_pool[0]);
> -#endif /* CONFIG_MAC80211_HT_DEBUG */

That seems wrong.

johannes

--=-glBmlLxEJb4DNqypdK6c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+j3aaVg1VMiehFYAQJsmg/+OWSgY9NTHY29EVYr55Hn427pSrHHBbU9
mGOkA+rXZ3dKafTJURjmlmeljCowxy/a4E2E7K+QRdMi5xDg/fqOFdc4S8ekA27S
y0lPUJUE+AmhR+LbSUGG/7BPPWRTDx94LZg8H5z1P1s7UUJm4YuHyyoG8r3Ocv1O
5dayQrYPi+rmSCRHJLjR34OICZK6pqO9MDTWExwjJ8kzcIp4KtSiZYdskDldu58M
TsjbMfk+tF8O/mgXNXCbXOOqBLqrU8c5PBsAVvSsfmYydDvB40Ld6iT6plQxoemq
sgJtK1+PFZbGfF+XB9PwUdumQf91qAJFIoWwLFzKyWA9LOxc+4OQ/UewVAgJ8Rwx
3hyBKCUynE8t/1s1IQz6K7cove/edoy1lD1D2wV+V4dt+K3Awcm5Pe6myCYt9+sX
ItwBDvlcUHxrYzLFhV1d1kvvVkozLfwPmwdnQD0Wp4dTByZQ7pwIKldInKXr8jLe
UBfitpcPLbb8J5MkxzOeDxDVtKRbG/Vv1oMhAI5KEnluuZwCyS798mwQywl1gE1p
zXIcDpwTgf6kunKuG7h4xJjEB/gBDUxrE2Fn6Qd1XMC+0vVZEoeTU24pbmeTS7hy
37NRuOlBnGBOwJNyv6TYH4FTdmLS5IXQS03q1BVGDJCaT5m9fINSEtMd9D/oSdKr
3j2Bm+FQvH0=
=PVpV
-----END PGP SIGNATURE-----

--=-glBmlLxEJb4DNqypdK6c--

