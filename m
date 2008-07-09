Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53595 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbYGIT5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 15:57:48 -0400
Subject: Re: [PATCH 2/4] mac80211: wme.c replace QD_NUM macro with static
	inline
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1215632672.476.85.camel@brick> (sfid-20080709_214438_247406_7CFB8ABA)
References: <1215632672.476.85.camel@brick>
	 (sfid-20080709_214438_247406_7CFB8ABA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tSEQkHhe8hAAQOfRb6aG"
Date: Wed, 09 Jul 2008 21:57:00 +0200
Message-Id: <1215633420.3246.47.camel@johannes.berg> (sfid-20080709_215753_788163_0E458ED4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tSEQkHhe8hAAQOfRb6aG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

While I don't really disagree with this patch, let's not do it at least
for now so we don't break davem's TX MQ rework needlessly.

On Wed, 2008-07-09 at 12:44 -0700, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  net/mac80211/wme.c |   37 ++++++++++++++++++++-----------------
>  1 files changed, 20 insertions(+), 17 deletions(-)
>=20
> diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
> index 5c666f7..a6cb0df 100644
> --- a/net/mac80211/wme.c
> +++ b/net/mac80211/wme.c
> @@ -20,8 +20,11 @@
> =20
>  /* maximum number of hardware queues we support. */
>  #define QD_MAX_QUEUES (IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_QUEUES=
)
> -/* current number of hardware queues we support. */
> -#define QD_NUM(hw) ((hw)->queues + (hw)->ampdu_queues)
> +
> +static unsigned int qd_num_hw_queues(const struct ieee80211_hw *hw)
> +{
> +	return hw->queues + hw->ampdu_queues;
> +}
> =20
>  /*
>   * Default mapping in classifier to work with default
> @@ -157,7 +160,7 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, s=
truct Qdisc* qd)
>  		tid =3D skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
>  		if (sta) {
>  			int ampdu_queue =3D sta->tid_to_tx_q[tid];
> -			if ((ampdu_queue < QD_NUM(hw)) &&
> +			if ((ampdu_queue < qd_num_hw_queues(hw)) &&
>  			    test_bit(ampdu_queue, q->qdisc_pool)) {
>  				queue =3D ampdu_queue;
>  				info->flags |=3D IEEE80211_TX_CTL_AMPDU;
> @@ -194,7 +197,7 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, s=
truct Qdisc* qd)
>  		sta =3D sta_info_get(local, hdr->addr1);
>  		if (sta) {
>  			int ampdu_queue =3D sta->tid_to_tx_q[tid];
> -			if ((ampdu_queue < QD_NUM(hw)) &&
> +			if ((ampdu_queue < qd_num_hw_queues(hw)) &&
>  			    test_bit(ampdu_queue, q->qdisc_pool)) {
>  				queue =3D ampdu_queue;
>  				info->flags |=3D IEEE80211_TX_CTL_AMPDU;
> @@ -257,7 +260,7 @@ static struct sk_buff *wme_qdiscop_dequeue(struct Qdi=
sc* qd)
>  	int queue;
> =20
>  	/* check all the h/w queues in numeric/priority order */
> -	for (queue =3D 0; queue < QD_NUM(hw); queue++) {
> +	for (queue =3D 0; queue < qd_num_hw_queues(hw); queue++) {
>  		/* see if there is room in this hardware queue */
>  		if (__netif_subqueue_stopped(local->mdev, queue) ||
>  		    !test_bit(queue, q->qdisc_pool))
> @@ -292,7 +295,7 @@ static void wme_qdiscop_reset(struct Qdisc* qd)
> =20
>  	/* QUESTION: should we have some hardware flush functionality here? */
> =20
> -	for (queue =3D 0; queue < QD_NUM(hw); queue++) {
> +	for (queue =3D 0; queue < qd_num_hw_queues(hw); queue++) {
>  		skb_queue_purge(&q->requeued[queue]);
>  		qdisc_reset(q->queues[queue]);
>  	}
> @@ -309,7 +312,7 @@ static void wme_qdiscop_destroy(struct Qdisc* qd)
> =20
>  	tcf_destroy_chain(&q->filter_list);
> =20
> -	for (queue =3D 0; queue < QD_NUM(hw); queue++) {
> +	for (queue =3D 0; queue < qd_num_hw_queues(hw); queue++) {
>  		skb_queue_purge(&q->requeued[queue]);
>  		qdisc_destroy(q->queues[queue]);
>  		q->queues[queue] =3D &noop_qdisc;
> @@ -357,7 +360,7 @@ static int wme_qdiscop_init(struct Qdisc *qd, struct =
nlattr *opt)
>  		err =3D wme_qdiscop_tune(qd, opt);
> =20
>  	/* create child queues */
> -	for (i =3D 0; i < QD_NUM(hw); i++) {
> +	for (i =3D 0; i < qd_num_hw_queues(hw); i++) {
>  		skb_queue_head_init(&q->requeued[i]);
>  		q->queues[i] =3D qdisc_create_dflt(qd->dev, &pfifo_qdisc_ops,
>  						 qd->handle);
> @@ -389,7 +392,7 @@ static int wme_classop_graft(struct Qdisc *qd, unsign=
ed long arg,
>  	struct ieee80211_hw *hw =3D &local->hw;
>  	unsigned long queue =3D arg - 1;
> =20
> -	if (queue >=3D QD_NUM(hw))
> +	if (queue >=3D qd_num_hw_queues(hw))
>  		return -EINVAL;
> =20
>  	if (!new)
> @@ -413,7 +416,7 @@ wme_classop_leaf(struct Qdisc *qd, unsigned long arg)
>  	struct ieee80211_hw *hw =3D &local->hw;
>  	unsigned long queue =3D arg - 1;
> =20
> -	if (queue >=3D QD_NUM(hw))
> +	if (queue >=3D qd_num_hw_queues(hw))
>  		return NULL;
> =20
>  	return q->queues[queue];
> @@ -426,7 +429,7 @@ static unsigned long wme_classop_get(struct Qdisc *qd=
, u32 classid)
>  	struct ieee80211_hw *hw =3D &local->hw;
>  	unsigned long queue =3D TC_H_MIN(classid);
> =20
> -	if (queue - 1 >=3D QD_NUM(hw))
> +	if (queue - 1 >=3D qd_num_hw_queues(hw))
>  		return 0;
> =20
>  	return queue;
> @@ -452,7 +455,7 @@ static int wme_classop_change(struct Qdisc *qd, u32 h=
andle, u32 parent,
>  	struct ieee80211_local *local =3D wdev_priv(qd->dev->ieee80211_ptr);
>  	struct ieee80211_hw *hw =3D &local->hw;
> =20
> -	if (cl - 1 > QD_NUM(hw))
> +	if (cl - 1 > qd_num_hw_queues(hw))
>  		return -ENOENT;
> =20
>  	/* TODO: put code to program hardware queue parameters here,
> @@ -469,7 +472,7 @@ static int wme_classop_delete(struct Qdisc *qd, unsig=
ned long cl)
>  	struct ieee80211_local *local =3D wdev_priv(qd->dev->ieee80211_ptr);
>  	struct ieee80211_hw *hw =3D &local->hw;
> =20
> -	if (cl - 1 > QD_NUM(hw))
> +	if (cl - 1 > qd_num_hw_queues(hw))
>  		return -ENOENT;
>  	return 0;
>  }
> @@ -482,7 +485,7 @@ static int wme_classop_dump_class(struct Qdisc *qd, u=
nsigned long cl,
>  	struct ieee80211_local *local =3D wdev_priv(qd->dev->ieee80211_ptr);
>  	struct ieee80211_hw *hw =3D &local->hw;
> =20
> -	if (cl - 1 > QD_NUM(hw))
> +	if (cl - 1 > qd_num_hw_queues(hw))
>  		return -ENOENT;
>  	tcm->tcm_handle =3D TC_H_MIN(cl);
>  	tcm->tcm_parent =3D qd->handle;
> @@ -500,7 +503,7 @@ static void wme_classop_walk(struct Qdisc *qd, struct=
 qdisc_walker *arg)
>  	if (arg->stop)
>  		return;
> =20
> -	for (queue =3D 0; queue < QD_NUM(hw); queue++) {
> +	for (queue =3D 0; queue < qd_num_hw_queues(hw); queue++) {
>  		if (arg->count < arg->skip) {
>  			arg->count++;
>  			continue;
> @@ -623,7 +626,7 @@ int ieee80211_ht_agg_queue_add(struct ieee80211_local=
 *local,
>  		return -EPERM;
> =20
>  	/* try to get a Qdisc from the pool */
> -	for (i =3D local->hw.queues; i < QD_NUM(&local->hw); i++)
> +	for (i =3D local->hw.queues; i < qd_num_hw_queues(&local->hw); i++)
>  		if (!test_and_set_bit(i, q->qdisc_pool)) {
>  			ieee80211_stop_queue(local_to_hw(local), i);
>  			sta->tid_to_tx_q[tid] =3D i;
> @@ -659,7 +662,7 @@ void ieee80211_ht_agg_queue_remove(struct ieee80211_l=
ocal *local,
> =20
>  	/* return the qdisc to the pool */
>  	clear_bit(agg_queue, q->qdisc_pool);
> -	sta->tid_to_tx_q[tid] =3D QD_NUM(hw);
> +	sta->tid_to_tx_q[tid] =3D qd_num_hw_queues(hw);
> =20
>  	if (requeue)
>  		ieee80211_requeue(local, agg_queue);

--=-tSEQkHhe8hAAQOfRb6aG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdRgJAAoJEKVg1VMiehFYwZAQAL1fxLO4/cqHDwSQaJuTBaps
RP4a24I8zMWOLJSf9w4/SFf4OyzfOFYDknGlVuVwP9qksj3vikAMiLQKdWRzcEeL
l1Zzr9ItQzzbCujh9LWsn1in8S9DVA6TwP6SIfTqyBUBeNkyDcKyhsCC+3J0iyPa
oMlmWfDRz9Iy8lBBPG++betwpBe0YPjMmlHZSicYeWZHGtxvrVneSLVv4RiGprlY
FJm/EeuTUsqEkXUJLzicX9u8WeS7648naBsZNVLQ8+EqyV7kkAVFOKJjShuucu39
W+l/WwdtEfcDlatWVeAl6+9kSDh72bkhsTZM6g6aAzuNVCNlNeOgRk0LPH2h7gnC
srJmBZpwlGLdmZqTYlXNtWCX5z4G6VejRQCvtRSY3CKYw/TQBqET03YHZbuG5Nbb
YJeiozod8iqERpf6e7yEdlrJY9H2dFF5lIB8WWTCayPYQd+kXD/gAvqkwjieeiPA
yuga2UKqyWNhQZnV96LSK6CwCvO3Y+HE46D+QM9R+SIHd8smo0TG0ys1qtki1pJW
ob9vtQRMp1gFEwPNPQRNw8aUepUxlQmQN6oJfLvDfT7bOdsZLxZzKjSdo2RfBiUI
mwnT6t7uJlZVxWs8EocUxWYWl6p3yAuQvMDurRIsZIeAlAAA8al3ORUsEZ3vH95w
7aMz+QaOnw5mLBWG0BHU
=F4NE
-----END PGP SIGNATURE-----

--=-tSEQkHhe8hAAQOfRb6aG--

