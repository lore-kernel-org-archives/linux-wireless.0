Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbYIPIIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 04:08:43 -0400
Subject: Re: [RFC V2] mac80211: re-enable aggregation on 2.6.27
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com, ron.rindjunsky@intel.com,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1221550508-3338-1-git-send-email-tomas.winkler@intel.com>
References: <>  <1221550508-3338-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PAOCzS4GymMNpfo48yhp"
Date: Tue, 16 Sep 2008 10:07:51 +0200
Message-Id: <1221552471.8916.17.camel@johannes.berg> (sfid-20080916_100847_100054_1E3EC90B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PAOCzS4GymMNpfo48yhp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-16 at 10:35 +0300, Tomas Winkler wrote:
> Re-enable aggregation by addressing skb->cb overwrites
> after insertion into the qdisc. Aggregation was disabled
> after the new TX multiqueue changes were introduced. Instead
> of relying on the skb->cb we use two flags on the skb.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>=20
> Users have been reporting low rates on 2.6.27 with 11n drivers, the
> problem is been 11n aggregation was disabled due to the new TX multique
> changes. We should have addressed this sooner but we just got to it now.
>=20
> Without addressing this we won't get 11n aggregation on 2.6.27. I tried
> to minimize the changes required. I'm about to test this, it compiles.
>=20
> If this doesn't get upstream for 27 perhaps distributions are willing to
> carry it around then and if so oh well (grr...).
>=20
> V2:
>  1. removed skbuff ->is_part_ampdu
>  2. fixed compilation warnings

Looks better. However, still problems remain.

ieee80211_start_tx_ba_session has a comment saying

                /* No need to requeue the packets in the agg queue, since w=
e
                 * held the tx lock: no packet could be enqueued to the new=
ly
                 * allocated queue */

which is clearly no longer true since there is no TX lock. You should
maintain a similar invariant instead, namely that sta->tid_to_tx_q[tid]
isn't updated until after ampdu_action(), in which case also no frames
will go to the aggregation queue.

However, to avoid reordering issues at aggregation start, you also need
to stop the AC queue the TID falls into, to restart it only after
ieee80211_requeue. This is tricky as it might be stopped due to a scan
starting at the same time, so additional bookkeeping about who stopped a
queue for what reason will be needed so you don't enable a queue that
the scan has stopped or vice versa.

As for ieee80211_requeue, it will need to be run from process context to
be able to synchronize_rcu() at the beginning of the function to make
sure any concurrent select_queue() has finished. That way, it can be
sure that all frames on the queues will be properly classified: when
aggregation was just _enabled_ frames after synchronize_rcu() will go to
the aggregation queue and we can safely requeue the frames on the AC
queue; when aggregation was just _disabled_ after synchronize_rcu() no
frames will go to the aggregation queue any more.

Note that for both cases both queues have to be stopped, the aggregation
queue is easy to handle since it can just start out in stopped until
ieee80211_requeue is run from the workqueue, but for the AC queue as I
mentioned this requires extra bookkeeping to not collide with the driver
or the scan stopping queues. Incidentally, it looks as though the scan
might collide with the driver here, the fact that we allow pending
packets probably rescues us here, but we cannot rely on that for
aggregation because there we need it for correct ordering.

I think that covers it all, but I might be wrong.

johannes

--=-PAOCzS4GymMNpfo48yhp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIz2lTAAoJEKVg1VMiehFYSbYP/jfGBWPcfu9jtJxtod3qMOCZ
pcvWO9Hr+kJzr7oXJNxpkW6S4JwNFfNqXt/T4iwbaCPO8cy/UevuUidXR6lmRtYB
jxY+1SVA/Ct1BGDaT/U1tZsbO+vDW2vWfbnqx5Yo55wLK9T3AC/3hRCI47cLVZ8i
VuJ2L2TSZblOdHwa+pTkz39WIoWIpVK2qcJ7UOaf6h0g+Tu7UFQM+QSAzCZzIG7a
ecno59ZSRQhYZeP1RRR5IC43x+1ArUnPA+LqTZrs8j7bcLCZIGZx5XkSEkumdTEX
Kt6HEDHZbZb/qvu527viAHuEJ1yR6MbiiEI08CW36YFjTPPoFW4qrBoPyfJ5bH8E
weEmCdI+io5bysOKZ10rj67z1jTbeOUP7lunQw80tmt937BPpposvzJCy0G6SzTN
bRcpRb738fUqqxmwsN/MM7bPWvSBpqxxE85NmltgbhDs3M/tYl4T8TpKCPrWAykD
MZ9lvdyUHrFJJFRLBChHo9mUwcdwo4NKtedpzC/bV/KTqnkadSd4DoeBGuK3RALb
e0R1FVZffkFuExFatQjzlsk4JR0/Trvh77Ey5tk5nQAin2pIg7BNs76Glt74MPF6
QtVbsXmY8H5/OnbukqtSKExQU0/k7df+MNHNHMl9qTHU5qN6BZUicfEAdj+ofsvM
4QEKX+nVgqXaPJxhQRPY
=tkJt
-----END PGP SIGNATURE-----

--=-PAOCzS4GymMNpfo48yhp--

