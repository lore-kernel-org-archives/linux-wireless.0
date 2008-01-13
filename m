Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbYAMVwG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 16:52:06 -0500
Subject: Re: [RFC PATCH 03/10] mac80211: A-MPDU Tx adding basic
	functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <rindjon@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470801130718x8069c4fi2eff95a21a11a2f3@mail.gmail.com> (sfid-20080113_151826_406509_4513162A)
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
	 <11999857493027-git-send-email-ron.rindjunsky@intel.com>
	 <1200070308.3861.203.camel@johannes.berg>
	 <c85cb4470801130718x8069c4fi2eff95a21a11a2f3@mail.gmail.com>
	 (sfid-20080113_151826_406509_4513162A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-teuDhXfqrBx09hV2SFeq"
Date: Sun, 13 Jan 2008 22:51:42 +0100
Message-Id: <1200261102.5887.19.camel@johannes.berg> (sfid-20080113_215211_130162_C951B33F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-teuDhXfqrBx09hV2SFeq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > +EXPORT_SYMBOL(ieee80211_start_tx_ba_session);
> >
> > Why is this exported? I thought this is the first step of enabling
> > aggregation?
>=20
> this is the trigger to aggregation, but a load aware entity should
> call it. in my next series of patches i'll work on this issue, but
> basically i would like to give the option to start/stop aggregations
> to other modules (e.g. rate scaling module)

Ah. Let only export it then though, please put the export into that
patch series. Maybe a rate control algorithm should indicate this in
some other way via the callbacks anyway?

> > > +     /* Tell the driver to stop its HW queue */
> > > +     if (local->ops->ampdu_action)
> > > +             ret =3D local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX=
_STOP,
> > > +                                             ra, tid, NULL);
> >
> > Does it really stop the hw queue? Isn't that more like "stop
> > aggregation"? Does the hardware actually have queues for each of these?
> > Hm. I'm familiar enough with this I think.
> >
>=20
> I'll remove this comment anyhow, as it is misleading, but the basic
> idea is what i wrote in 0/10 - first we need to drain all A-MPDUs,
> only then we can delBA, otherwise we are confusing the receiver.

Ok, I'm trying to learn 11n here too, does the hardware need extra
queues for the A-MPDU feature?

> > > +     /* case HW denied going back to legacy */
> > > +     if (ret) {
> > > +             printk(KERN_ERR "Driver could not stop aggregations\n")=
;
> > > +             *state =3D HT_AGG_STATE_OPERATIONAL;
> > > +             ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
> > > +             goto stop_BA_exit;
> >
> > Is there really a use case for a driver denying this? IOW, can you thin=
k
> > of a good reason why a driver would deny it?
>=20
> can't think about one right now, but i am not familiar with other HWs.
> maybe a self contained HW decision based on frames load can lead to
> that. in any case i would like to give the driver this option.

Ok. Let's put

WARN_ON(ret !=3D -EBUSY)

into that if (ret) { block though to force the driver to give exactly
that error code (and document that) so that callers of
ieee80211_stop_tx_ba_session() can discover that the driver failed.

> > > +     /* avoid ordering issues: we are the only one that can modify
> > > +      * the content of the qdiscs */
> > > +     spin_lock_bh(&local->mdev->queue_lock);
> > > +     /* remove the queue for this aggregation */
> > > +     ieee80211_ht_agg_queue_remove(local, sta, tid, 1);
> > > +     spin_unlock_bh(&local->mdev->queue_lock);
> > > +
> > > +     /* Not scheduling the device leads to a stall in the TX when qd=
isc */
> > > +     /* contains more than ~220 packets... */
> > > +     netif_schedule(local->mdev);
> >
> > This seems a bit weird, can you explain a bit more?
>=20
> i'll change the comment here to a clearer one. since the qdisc has
> just been requeued then heavy load (~220 frames queued) might lead us
> to miss a softirq for this qdisc. we can't use ieee80211_wake_queue as
> the qdisc is not necessarily stopped, so this is a solution for it.

Ok. I don't think I've fully understood it yet, but I haven't really
looked into the qdisc stuff at all yet.

> this is a use of an existing mechanism, I wouldn't like another queue
> just for this purpose, though a misuse, i agree. i can either stay
> with this code, use cb for this purpose, or create a new struct in
> mac80211.h, somehting like ieee80211_ra_tid and pass it. what do you
> think os the best?

I think we should use something other than an skb queue here with some
other struct, that other struct would be in skb->cb for the existing skb
cases and would just sit in some new struct ieee80211_ra_tid too for
this case. It's a bit of rework here but I think it'd help the code to
be more readable. Not sure if we should also do it for the unreliable
queue.

> > > +     /* check if the TID waits for addBA response */
> > > +     spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
> > > +     if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
> > > +             spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
> > > +             *state =3D HT_AGG_STATE_IDLE;
> > > +             printk(KERN_DEBUG "timer expired on tid %d but we are n=
ot "
> > > +                             "expecting addBA response there", tid);
> > > +             goto timer_expired_exit;
> > > +     }
> >
> > Couldn't this also happen when the response was just received while the
> > timer expires but the response grabs the ampdu_tx spinlock before the
> > timer does? Seems that should be in a comment and not worry about a
> > printk.
>=20
> the condition is on whether addBA request was sent or not for this
> address and TID, not on the addBA request.

Oh, hmm, ok. But that actually leads me to another problem,
HT_ADDBA_REQUESTED_MSK is never cleared anywhere.

johannes

--=-teuDhXfqrBx09hV2SFeq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4qH7aVg1VMiehFYAQK68Q/9E5jHMzRSD8y92YbQn/GR2L1aACqqo1+X
C2wBA2JEs22OtGba+asQQ6xkZySKy0jIaqh/5e/Y8M25Vzf4nrUqGdRCxrsALIX+
x8Sx0mcec+4FlgNAtrnEKcXPRTuQ7VIdJ25Rzwc7muuB/Yj2TocBzgDS9l79mVSG
fQjQE6i3cc/WtKgYicYuRqhj214H9b7UB7LOvm0T7xyg3q8/ltBST6a2Jp9JAt4r
Z9T7a7OrhqwrkHPCLHEcFL9pREezHDKTrdWXCflNRKr09rFQlW5WzuSGLLrQ6AoB
ZQQSXXNKovNndAY9Lu/Dgj33xyFoD/OuqE90VstW8j4sG6ZA0qocZylQUvhgeQBy
In7Q9MyAwduw1iFLIVUd062Io26/UX6+fxw8fvM5Ej8Mp4c3xi4eHNCEXrsrd5Yb
JHgd5AAvguOAqD1bOarHGZjzgm+S4do6QpofoToJh6cYTPnUo7Lxhh5NNjnRyBEk
ENy93wr51C4KTort5HxT+vqYtOJogMlonxOAjcmH+e4JFF5niOh1qk9PPRbqV3Yb
w81nzjiMS41VgPmZGDoqrd9ctAZYBo2eIfmCvHtEpvUBrrCgpKm9CgHGLBl7QjwZ
BzwpF+rdMl5EoWZ5N2ZFMCYFLcRGiQBITGEueHWDD/+4Pgdf/6Aqb9J25OM98Wdc
RbKRNgDktw0=
=ujnd
-----END PGP SIGNATURE-----

--=-teuDhXfqrBx09hV2SFeq--

