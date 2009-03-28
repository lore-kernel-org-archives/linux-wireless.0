Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbZC1RmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 13:42:09 -0400
Subject: Re: [PATCH 7/8] mac80211: fix aggregation to not require queue stop
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
In-Reply-To: <20090328045529.GF5543@bombadil.infradead.org>
References: <20090323162834.154525349@sipsolutions.net>
	 <20090323163053.344441542@sipsolutions.net>
	 <20090328045529.GF5543@bombadil.infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QeUolAlzggDAE1+u1+Ck"
Date: Sat, 28 Mar 2009 18:41:58 +0100
Message-Id: <1238262118.4217.13.camel@johannes.local> (sfid-20090328_184223_520778_5A2401E6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QeUolAlzggDAE1+u1+Ck
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-28 at 00:55 -0400, Luis R. Rodriguez wrote:


> > This changes how mac80211 behaves towards drivers that support
> > aggregation but have no hardware queues -- those drivers will now
> > not be handed packets while the aggregation session is being
> > established, but only after it has been fully established.
>=20
> That's fine from a logical point of view as compromise here as our
> ampdu start should be relatively quick. Now while I can say this
> from a logical point of view this patch obviously needed more
> testing but lets see how it holds up and I'm glad you're the one
> who wrote it. I'm confident there won't be any issues but that
> is something I cannot gaurantee just based on the review. We now
> need to go out and tests this. All other patches previous to this
> make 100% perfect sense.

:)
I think it also makes more _sense_ to not ask the driver to handle these
frames, because we won't set the AMPDU flag correctly if the session
start is declined.

> > +	/*
> > +	 * While we're asking the driver about the aggregation,
> > +	 * stop the AC queue so that we don't have to worry
> > +	 * about frames that came in while we were doing that,
> > +	 * which would require us to put them to the AC pending
> > +	 * afterwards which just makes the code more complex.
> > +	 */
> > +	ieee80211_stop_queue_by_reason(
> > +		&local->hw, ieee80211_ac_from_tid(tid),
> > +		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
> > +
>=20
> ath9k's ampdu start is pretty quick anyway, so this
> won't be for long.

Yup.

> > +/*
> > + * splice packets from the STA's pending to the local pending,
> > + * requires a call to ieee80211_agg_splice_finish and holding
> > + * local->ampdu_lock across both calls.
> > + */
> > +static void ieee80211_agg_splice_packets(struct ieee80211_local *local=
,
> > +					 struct sta_info *sta, u16 tid)
> > +{
> > +	unsigned long flags;
> > +	u16 queue =3D ieee80211_ac_from_tid(tid);
> > +
> > +	ieee80211_stop_queue_by_reason(
> > +		&local->hw, queue,
> > +		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
>=20
> No point in stopping the queue if the STA's tid queue is empty.

Hmm, true I guess.

> > @@ -602,22 +637,19 @@ void ieee80211_stop_tx_ba_cb(struct ieee
> >  			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
> > =20
> >  	spin_lock_bh(&sta->lock);
> > +	spin_lock(&local->ampdu_lock);
> > =20
> > -	if (*state & HT_AGG_STATE_INITIATOR_MSK &&
> > -	    hw->ampdu_queues) {
> > -		/*
> > -		 * Wake up this queue, we stopped it earlier,
> > -		 * this will in turn wake the entire AC.
> > -		 */
> > -		ieee80211_wake_queue_by_reason(hw,
> > -			hw->queues + sta->tid_to_tx_q[tid],
> > -			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
> > -	}
> > +	ieee80211_agg_splice_packets(local, sta, tid);
>=20
> Is it possible for ieee80211_stop_tx_ba_cb() to be called while
> state of the tid is not yet operational? from what I can tell
> that's the only case when we would have added skbs to the STA's tid
> pending queue.

This happens when the session is denied by the peer.

> >  	*state =3D HT_AGG_STATE_IDLE;
> > +	/* from now on packets are no longer put onto sta->pending */
>=20
> I think it would help to refer to the pendign queue consitantly instead
> as something like "STA's TID pending queue" as that is what it is. We als=
o
> now have the local->pending queue. STA's pending queue seems to imply
> its also used for non-aggregation sessions.
>=20
> See -- if the state is not operation nothing would have gone
> been put into the STA's tid pending queue. Might also be worth
> mentioning that in the comment.

Hmm, yeah, might rewrite the comments a bit. Mind if I do a separate
patch later?

> > @@ -1013,20 +1013,53 @@ __ieee80211_tx_prepare(struct ieee80211_
> >  		 */
> >  	}
> > =20
> > +	/*
> > +	 * If this flag is set to true anywhere, and we get here,
> > +	 * we are doing the needed processing, so remove the flag
> > +	 * now.
> > +	 */
> > +	info->flags &=3D ~IEEE80211_TX_INTFL_NEED_TXPROCESSING;
> > +
> >  	hdr =3D (struct ieee80211_hdr *) skb->data;
> > =20
> >  	tx->sta =3D sta_info_get(local, hdr->addr1);
> > =20
> > -	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control)) {
> > +	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
> > +	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)) {
>=20
> Hm, why were we not crashing here before? I figure we would have
> with something like this:
>=20
> state =3D &tx->sta->ampdu_mlme.tid_state_tx[tid];
>=20
> That it itself should be separate patch, but too late now. Anyway
> the new added check for IEEE80211_HW_AMPDU_AGGREGATION should go
> to stable.

Nah, state_tx always exists (and will be IDLE) but this was just an
added check to make us not need the spinlock for non-ampdu hw.

> >  		unsigned long flags;
> > +		struct tid_ampdu_tx *tid_tx;
> > +
> >  		qc =3D ieee80211_get_qos_ctl(hdr);
> >  		tid =3D *qc & IEEE80211_QOS_CTL_TID_MASK;
> > =20
> >  		spin_lock_irqsave(&tx->sta->lock, flags);
> > +		/*
> > +		 * XXX: This spinlock could be fairly expensive, but see the
> > +		 *	comment in agg-tx.c:ieee80211_agg_tx_operational().
> > +		 *	One way to solve this would be to do something RCU-like
> > +		 *	for managing the tid_tx struct and using atomic bitops
> > +		 *	for the actual state -- by introducing an actual
> > +		 *	'operational' bit that would be possible. It would
> > +		 *	require changing ieee80211_agg_tx_operational() to
> > +		 *	set that bit, and changing the way tid_tx is managed
> > +		 *	everywhere, including races between that bit and
> > +		 *	tid_tx going away (tid_tx being added can be easily
> > +		 *	committed to memory before the 'operational' bit).
> > +		 */
> > +		tid_tx =3D tx->sta->ampdu_mlme.tid_tx[tid];
> >  		state =3D &tx->sta->ampdu_mlme.tid_state_tx[tid];
> > -		if (*state =3D=3D HT_AGG_STATE_OPERATIONAL)
> > +		if (*state =3D=3D HT_AGG_STATE_OPERATIONAL) {
> >  			info->flags |=3D IEEE80211_TX_CTL_AMPDU;
>=20
> See, when its operational we don't add stuff to the STA's TID pending=20
> queue.
>=20
> This piece:
>=20
> > +		} else if (*state !=3D HT_AGG_STATE_IDLE) {
> > +			/* in progress */
> > +			queued =3D true;
> > +			info->flags |=3D IEEE80211_TX_INTFL_NEED_TXPROCESSING;
> > +			__skb_queue_tail(&tid_tx->pending, skb);
> > +		}
>=20
> Can probably be ported to stable too, to just TX_DROP.

No, why? We're handing the frames to the driver. It wants to handle
those frames before agg session is started correctly. That's what I was
referring to before with this making more sense now.

> > @@ -1251,7 +1295,12 @@ static int ieee80211_tx(struct net_devic
> >  			do {
> >  				next =3D skb->next;
> >  				skb->next =3D NULL;
> > -				skb_queue_tail(&local->pending[queue], skb);
> > +				if (unlikely(txpending))
> > +					skb_queue_head(&local->pending[queue],
> > +						       skb);
> > +				else
> > +					skb_queue_tail(&local->pending[queue],
> > +						       skb);
>=20
> For someone who hasn't read all the pending queue code stuff the above wo=
uld be
> a little brain twister. It might be good to leave a comment explaining wh=
y
> txpendign would be set and why we add it to the head (i.e. because the "s=
kb" sent
> at a previous time was put into a pending queue). Maybe even rename txpen=
ding to
> something like skb_was_pending.

Ok that might make some sense, though as a parameter you can easily see
where it's coming from, I think :) I agree that the entire code is a
little brain twister...

> > @@ -1360,7 +1407,7 @@ int ieee80211_master_start_xmit(struct s
> >  		       "originating device\n", dev->name);
> >  #endif
> >  		dev_kfree_skb(skb);
> > -		return 0;
> > +		return NETDEV_TX_OK;
>=20
> All these NETDEV_TX_OK could've gone into a separate patch.

I guess, they're also not strictly necessary since 0 =3D=3D TX_OK :)

johannes

--=-QeUolAlzggDAE1+u1+Ck
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzmFjAAoJEKVg1VMiehFYt34P/0HEBbdDEZJ4hMCPzTIgWid8
AKItCmxP/gy9bqPZlwrQZFpQ3Gkid7RMMnbghm6GAJXs7UYkAMkOlWlOMWQQO2Ft
2TMsvccL31RH2vNesORMpm0tl6HdFjd0f2lhN70vW6Gd1hpSo3dhUjnOuzHsofg/
7mPKZPL4x87KEBQ5vBNrPxMvR1c3whKANLgwhcbJzTxS3DXyot1Sn5HlhdTZUAGM
zbCe76K/QHZVUr6lvTc4vOth3OjckJnKhFoW4vudABhvfuVN6c/jTT252L86ElJp
RnX2pOTU5C1P1AQijI+uW3eZoaPTeu3L1zRnI7mkrIU3YSuwbygp8lrCQo71/Mvj
q9phTvNOWeaQl8bnsCJefyxWQDKC2TwFlULfmpWl/DnLpxWrmfFtqeFMEMG2TIVm
bx8gp5fg8obxlMaD71EiEdvrWKCOG7mjTWy8wVwpBQynJ+loTcaAEZitOxi5Oj8/
m5JpbIzs7YEG6eGGHzrRqEWA0a8ULeMwpKz1soNcwlHRpw7Dt6Nd1QCxOuLBqEnP
qSRpHkBOFGeMFezFiDD9erYRVhu3ukZkOUcFHUkxwNasu2RdnqsNtjhMDo/8sh3j
CgMHUTQPKVXvpF+cdMslhu6azOLtLc2z0zw2gr9MtIbbSFiKEp7rVktF8DgnwTXc
4FUUZvrvDkmnhtuVrZ3r
=jxv8
-----END PGP SIGNATURE-----

--=-QeUolAlzggDAE1+u1+Ck--

