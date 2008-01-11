Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759947AbYAKV2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 16:28:12 -0500
Subject: Re: [RFC PATCH 03/10] mac80211: A-MPDU Tx adding basic
	functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11999857493027-git-send-email-ron.rindjunsky@intel.com>
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
	 <11999857493027-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3EJaGHzy+gm1wZSdg2YB"
Date: Fri, 11 Jan 2008 17:51:48 +0100
Message-Id: <1200070308.3861.203.camel@johannes.berg> (sfid-20080111_212814_551469_17C698C1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3EJaGHzy+gm1wZSdg2YB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	sta =3D sta_info_get(local, ra);
> +	if (!sta) {
> +		printk(KERN_ERR "Could not find the station\n");
> +		return -ENOENT;
> +	}
> +
> +	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
> +
> +	/* we have tried too many times, reciever does not want A-MPDU */

typo: "receiver"

> +	if (sta->ampdu_mlme.tid_tx[tid].addba_req_num >	HT_AGG_MAX_RETRIES) {
> +		ret =3D -EBUSY;
> +		goto start_ba_exit;

Can this counter reset somehow? Or do we only implicitly reset it when
the station disassociates and associates again?

> +	/* FIXME: need a better way to ensure that TX flow won't interrupt us*/
> +	/* until the end of the call to requeue function */
> +	spin_lock_bh(&local->mdev->queue_lock);

Hm. I think the queue lock here is pretty much the only way. On the
other hand, maybe here's the point where we should talk about
multi-queue ethernet devices?

> +	if (local->ops->ampdu_action)
> +		ret =3D local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_START,
> +						ra, tid, &start_seq_num);
> +
> +	if (ret) {
> +		/* No need to requeue the packets in the agg queue, since we
> +		 * held the tx lock: no packet could be enqueued to the newly
> +		 * allocated queue */
> +		ieee80211_ht_agg_queue_remove(local, sta, tid, 0);
> +#ifdef CONFIG_MAC80211_HT_DEBUG
> +		printk(KERN_DEBUG "BA request denied - HW or queue unavailable"
> +				" for tid %d\n", tid);
> +#endif /* CONFIG_MAC80211_HT_DEBUG */
> +		spin_unlock_bh(&local->mdev->queue_lock);
> +		*state =3D HT_AGG_STATE_IDLE;
> +		goto start_ba_exit;
> +	}
> +
> +	/* Will put all the packets in the new SW queue */
> +	ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
> +	spin_unlock_bh(&local->mdev->queue_lock);
> +
> +	/* We have most probably almost emptied the legacy queue */
> +	ieee80211_wake_queue(local_to_hw(local), ieee802_1d_to_ac[tid]);
> +
> +	/* send an addBA request */
> +	sta->ampdu_mlme.dialog_token_allocator++;
> +	sta->ampdu_mlme.tid_tx[tid].dialog_token =3D
> +			sta->ampdu_mlme.dialog_token_allocator;
> +	sta->ampdu_mlme.tid_tx[tid].ssn =3D start_seq_num;
> +
> +	ieee80211_send_addba_request(sta->dev, ra, tid,
> +			 sta->ampdu_mlme.tid_tx[tid].dialog_token,
> +			 sta->ampdu_mlme.tid_tx[tid].ssn,
> +			 0x40, 5000);
> +
> +	/* activate the timer for the recipient's addBA response */
> +	sta->ampdu_mlme.tid_tx[tid].addba_resp_timer.expires =3D
> +				jiffies + ADDBA_RESP_INTERVAL;
> +	add_timer(&sta->ampdu_mlme.tid_tx[tid].addba_resp_timer);
> +	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
> +
> +start_ba_exit:
> +	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
> +	sta_info_put(sta);
> +	return ret;
> +}
> +EXPORT_SYMBOL(ieee80211_start_tx_ba_session);

Why is this exported? I thought this is the first step of enabling
aggregation?


> +	/* check if the TID is in aggregation */
> +	state =3D &sta->ampdu_mlme.tid_tx[tid].state;
> +	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
> +
> +	if (*state !=3D HT_AGG_STATE_OPERATIONAL) {
> +		printk(KERN_ERR "Call to %s, whith AGG non operational\n",
> +								__func__);
> +		ret =3D -ENOENT;
> +		goto stop_BA_exit;

I dislike the __func__ usage here, why not just say "tried to disable TX
aggregation while not operational" or something? Typo: "with".

> +	/* Tell the driver to stop its HW queue */
> +	if (local->ops->ampdu_action)
> +		ret =3D local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_STOP,
> +						ra, tid, NULL);

Does it really stop the hw queue? Isn't that more like "stop
aggregation"? Does the hardware actually have queues for each of these?
Hm. I'm familiar enough with this I think.

> +	/* case HW denied going back to legacy */
> +	if (ret) {
> +		printk(KERN_ERR "Driver could not stop aggregations\n");
> +		*state =3D HT_AGG_STATE_OPERATIONAL;
> +		ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
> +		goto stop_BA_exit;

Is there really a use case for a driver denying this? IOW, can you think
of a good reason why a driver would deny it?

> +EXPORT_SYMBOL(ieee80211_stop_tx_ba_session);

Again, why export this?

> +	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
> +		printk(KERN_ERR "%s, state not HT_ADDBA_REQUESTED_MSK: %d\n",
> +			__func__, *state);

Please just write the message w/o the function name.

> +	if (*state & HT_ADDBA_DRV_READY_MSK)
> +		printk(KERN_ERR "driver already prepared for aggregation\n");

That's a bit odd. Shouldn't it rather be a WARN_ON() because the driver
did something weird?

> +	*state |=3D HT_ADDBA_DRV_READY_MSK;
> +
> +	if (*state =3D=3D HT_AGG_STATE_OPERATIONAL) {
> +		printk(KERN_ERR "%s. OPERATIONNAL\n", __func__);

typo, weird message :)

> +	/* avoid ordering issues: we are the only one that can modify
> +	 * the content of the qdiscs */
> +	spin_lock_bh(&local->mdev->queue_lock);
> +	/* remove the queue for this aggregation */
> +	ieee80211_ht_agg_queue_remove(local, sta, tid, 1);
> +	spin_unlock_bh(&local->mdev->queue_lock);
> +
> +	/* Not scheduling the device leads to a stall in the TX when qdisc */
> +	/* contains more than ~220 packets... */
> +	netif_schedule(local->mdev);

This seems a bit weird, can you explain a bit more?

> +	hdr =3D (struct ieee80211_hdr *) skb_put(skb,
> +					sizeof(struct ieee80211_hdr));
> +	memcpy(&hdr->addr1, ra, ETH_ALEN);
> +	hdr->frame_control =3D tid;

Hrm. This is just strange and hard to understand imho. Can't we just use
some other structure instead of and ieee80211_hdr and push that onto the
queue? Then we shouldn't be using an skb queue any more I guess if we're
going to use it like this. For the skbs we can use skb->cb for our own
list structure, and here we just use another structure that embeds our
list structure...

> +	/* not an elegant detour, but there is no choice as the timer passes
> +	 * only one argument, and verious sta_info are needed here, so init

typo: various, but I think it should read something like "both the
sta_info and the TID are needed here"?

> +	/* check if the TID waits for addBA response */
> +	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
> +	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
> +		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
> +		*state =3D HT_AGG_STATE_IDLE;
> +		printk(KERN_DEBUG "timer expired on tid %d but we are not "
> +				"expecting addBA response there", tid);
> +		goto timer_expired_exit;
> +	}

Couldn't this also happen when the response was just received while the
timer expires but the response grabs the ampdu_tx spinlock before the
timer does? Seems that should be in a comment and not worry about a
printk.

johannes

--=-3EJaGHzy+gm1wZSdg2YB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4eeo6Vg1VMiehFYAQIPZBAArvCefk+V9cnxE9uaC4R1fB86h0L0/ldO
Z4jzwhbwMAct9S+tkFgR1dHwRp1S2aM7OfYdhKwnwjxG0hElmi59kC50s8Q142UD
EwT0HjmO05vwQVE4pi3SIWaD6t8wA3lGpCan1FwseGEq1H93FR4NylZ1tLsJ1Al5
WIz7/NgFQ1d9z2Jcdml/cnvccVo4eEoYyYzUHVYwSM2i/sDxENGYkOydSIMlbLx5
PkTh1Sq9YUsLPBmieMfpDfGAGbRP5F6LPZyQOMguqLRu+k1v4fLv28SAHtEeOyMi
h+ac5xWAd2mPUXCxAHzQxM+2qDJe5oFSOCu5ucvTZEQqDmWbt7R6HPr1nvjIUo5p
0AT2DZ/+ABS6TrmfgPEfTozF752QjysljZgfnjDYJmVVu2BqvqXMHlWOyNnuOHIn
uC5v2dz01MYlji//GrLyMIyMptfnMquQlpbE06d0m+SfGLCJT8KuFtpOTzjA1W1J
6sCKN1xZ6yx1SOqEY1MmcOc3UK1FXjgJ8uBP+ZPJ7Yzv6CYjx4a/s7GiZvH54C8T
khUuz49ZtAd7ZY93ldxdpLgbnXvxT649RBJl6OoKMSWLRSHgEB0+m6Hmixti9jhz
jV3JHf99zJYl0FcyoORXurDAGtA0WqWLD1hQG/hSJDk8KCaitUrztCJYvwkd0WQF
bUEbrmEhlOw=
=mFBh
-----END PGP SIGNATURE-----

--=-3EJaGHzy+gm1wZSdg2YB--

