Return-Path: <SRS0=h0Fo=ML=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF19C43143
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 10:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40739206B2
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 10:06:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="b9rO9yjQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40739206B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbeI2QeF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Sep 2018 12:34:05 -0400
Received: from mail.toke.dk ([52.28.52.200]:48891 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727761AbeI2QeF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Sep 2018 12:34:05 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1538215573; bh=HDoStnazTwk9rhUNxlaGetxPNZjh7LCyAmJE4FgxHMc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=b9rO9yjQQkVV4c3FivU7/gGcgtlGGp5onn1lmd1e1WPA2uYXnYmJ14mghsX6Jl+fP
         RYjyVeXTLs+N3G0upNvOLW/Uq72+/9JI+kQwNraySxSyvAvgoaQj21VPoU3dAfHD2J
         fwLoY6adNth6ij33CYVMpWCz9R+HUhncinBWEw9DWmq35Aj5PYWNnJ4EZN45lMyy81
         8shkeXTYqrziWr6ihdSQxL3AhQjYxfoj4PvG7WyfAE8D9JF0hawoqFif1OTNzj0A7U
         pftovFVF4bcSDCvwhGdacBq/I/NnZHl3NGd2s8WKxc/YEkRDlgDaCt6K8VZp0Ikf9M
         nFq2EhcpCgOlw==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: Re: [RFC v2 1/2] ath10k: migrate to mac80211 txq scheduling
In-Reply-To: <1538176574-5580-1-git-send-email-rmanohar@codeaurora.org>
References: <1538176574-5580-1-git-send-email-rmanohar@codeaurora.org>
Date:   Sat, 29 Sep 2018 12:06:13 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87k1n4botm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> ath10k maintains common txqs list for all stations. This txq
> management can be removed by migrating to mac80211 txq APIs
> and let mac80211 handle txqs reordering based on reported airtime.
> By doing this, txq fairness maintained in ath10k i.e processing
> N frames per txq is removed. By adapting to mac80211 APIs,
> ath10k will support mac80211 based airtime fairness algorithm.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/core.c   |  2 -
>  drivers/net/wireless/ath/ath10k/core.h   |  3 --
>  drivers/net/wireless/ath/ath10k/htc.h    |  1 -
>  drivers/net/wireless/ath/ath10k/htt_rx.c |  8 +++
>  drivers/net/wireless/ath/ath10k/mac.c    | 92 +++++++++++++-------------=
------
>  5 files changed, 45 insertions(+), 61 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireles=
s/ath/ath10k/core.c
> index cf3c47b8cb2d..0684f87abc9b 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -3068,9 +3068,7 @@ struct ath10k *ath10k_core_create(size_t priv_size,=
 struct device *dev,
>=20=20
>  	mutex_init(&ar->conf_mutex);
>  	spin_lock_init(&ar->data_lock);
> -	spin_lock_init(&ar->txqs_lock);
>=20=20
> -	INIT_LIST_HEAD(&ar->txqs);
>  	INIT_LIST_HEAD(&ar->peers);
>  	init_waitqueue_head(&ar->peer_mapping_wq);
>  	init_waitqueue_head(&ar->htt.empty_tx_wq);
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireles=
s/ath/ath10k/core.h
> index f6e5c29f74e7..d3e20aaf8023 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -1054,10 +1054,7 @@ struct ath10k {
>=20=20
>  	/* protects shared structure data */
>  	spinlock_t data_lock;
> -	/* protects: ar->txqs, artxq->list */
> -	spinlock_t txqs_lock;
>=20=20
> -	struct list_head txqs;
>  	struct list_head arvifs;
>  	struct list_head peers;
>  	struct ath10k_peer *peer_map[ATH10K_MAX_NUM_PEER_IDS];
> diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless=
/ath/ath10k/htc.h
> index 51fda6c23f69..cb30add7dd33 100644
> --- a/drivers/net/wireless/ath/ath10k/htc.h
> +++ b/drivers/net/wireless/ath/ath10k/htc.h
> @@ -51,7 +51,6 @@
>   */
>=20=20
>  #define HTC_HOST_MAX_MSG_PER_RX_BUNDLE        8
> -#define HTC_HOST_MAX_MSG_PER_TX_BUNDLE        16
>=20=20
>  enum ath10k_htc_tx_flags {
>  	ATH10K_HTC_FLAG_NEED_CREDIT_UPDATE =3D 0x01,
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wirel=
ess/ath/ath10k/htt_rx.c
> index f2405258a6d3..f2aaa2f7a022 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -2379,6 +2379,7 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath10=
k *ar, struct sk_buff *skb)
>  	u8 tid;
>  	int ret;
>  	int i;
> +	bool may_tx;
>=20=20
>  	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx tx fetch ind\n");
>=20=20
> @@ -2451,8 +2452,13 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath1=
0k *ar, struct sk_buff *skb)
>  		num_msdus =3D 0;
>  		num_bytes =3D 0;
>=20=20
> +		ieee80211_txq_schedule_start(hw, txq->ac);
> +		may_tx =3D ieee80211_txq_may_transmit(hw, txq);
>  		while (num_msdus < max_num_msdus &&
>  		       num_bytes < max_num_bytes) {
> +			if (!may_tx)
> +				break;
> +
>  			ret =3D ath10k_mac_tx_push_txq(hw, txq);
>  			if (ret < 0)
>  				break;
> @@ -2460,6 +2466,8 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath10=
k *ar, struct sk_buff *skb)
>  			num_msdus++;
>  			num_bytes +=3D ret;
>  		}
> +		ieee80211_return_txq(hw, txq);
> +		ieee80211_txq_schedule_end(hw, txq->ac);
>=20=20
>  		record->num_msdus =3D cpu_to_le16(num_msdus);
>  		record->num_bytes =3D cpu_to_le32(num_bytes);
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless=
/ath/ath10k/mac.c
> index 97548f96a2f7..3b441179a36c 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -3874,7 +3874,6 @@ static void ath10k_mac_txq_init(struct ieee80211_tx=
q *txq)
>=20=20
>  static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq=
 *txq)
>  {
> -	struct ath10k_txq *artxq;
>  	struct ath10k_skb_cb *cb;
>  	struct sk_buff *msdu;
>  	int msdu_id;
> @@ -3882,12 +3881,6 @@ static void ath10k_mac_txq_unref(struct ath10k *ar=
, struct ieee80211_txq *txq)
>  	if (!txq)
>  		return;
>=20=20
> -	artxq =3D (void *)txq->drv_priv;
> -	spin_lock_bh(&ar->txqs_lock);
> -	if (!list_empty(&artxq->list))
> -		list_del_init(&artxq->list);
> -	spin_unlock_bh(&ar->txqs_lock);
> -
>  	spin_lock_bh(&ar->htt.tx_lock);
>  	idr_for_each_entry(&ar->htt.pending_tx, msdu, msdu_id) {
>  		cb =3D ATH10K_SKB_CB(msdu);
> @@ -3927,7 +3920,6 @@ static bool ath10k_mac_tx_can_push(struct ieee80211=
_hw *hw,
>  	struct ath10k_txq *artxq =3D (void *)txq->drv_priv;
>=20=20
>  	/* No need to get locks */
> -
>  	if (ar->htt.tx_q_state.mode =3D=3D HTT_TX_MODE_SWITCH_PUSH)
>  		return true;
>=20=20
> @@ -4014,48 +4006,44 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *h=
w,
>  	return skb_len;
>  }
>=20=20
> -void ath10k_mac_tx_push_pending(struct ath10k *ar)
> +static int ath10k_mac_schedule_txq(struct ieee80211_hw *hw, u32 ac)
>  {
> -	struct ieee80211_hw *hw =3D ar->hw;
>  	struct ieee80211_txq *txq;
> -	struct ath10k_txq *artxq;
> -	struct ath10k_txq *last;
> -	int ret;
> -	int max;
> -
> -	if (ar->htt.num_pending_tx >=3D (ar->htt.max_num_pending_tx / 2))
> -		return;
> -
> -	spin_lock_bh(&ar->txqs_lock);
> -	rcu_read_lock();
> -
> -	last =3D list_last_entry(&ar->txqs, struct ath10k_txq, list);
> -	while (!list_empty(&ar->txqs)) {
> -		artxq =3D list_first_entry(&ar->txqs, struct ath10k_txq, list);
> -		txq =3D container_of((void *)artxq, struct ieee80211_txq,
> -				   drv_priv);
> +	int ret =3D 0;
>=20=20
> -		/* Prevent aggressive sta/tid taking over tx queue */
> -		max =3D HTC_HOST_MAX_MSG_PER_TX_BUNDLE;
> -		ret =3D 0;
> -		while (ath10k_mac_tx_can_push(hw, txq) && max--) {
> +	ieee80211_txq_schedule_start(hw, ac);
> +	while ((txq =3D ieee80211_next_txq(hw, ac))) {
> +		while (ath10k_mac_tx_can_push(hw, txq)) {
>  			ret =3D ath10k_mac_tx_push_txq(hw, txq);
>  			if (ret < 0)
>  				break;
>  		}
> +		ieee80211_return_txq(hw, txq);
> +		ath10k_htt_tx_txq_update(hw, txq);
> +		if (ret =3D=3D -EBUSY)
> +			break;
> +	}
> +	ieee80211_txq_schedule_end(hw, ac);
>=20=20
> -		list_del_init(&artxq->list);
> -		if (ret !=3D -ENOENT)
> -			list_add_tail(&artxq->list, &ar->txqs);
> +	return ret;
> +}
>=20=20
> -		ath10k_htt_tx_txq_update(hw, txq);
> +void ath10k_mac_tx_push_pending(struct ath10k *ar)
> +{
> +	struct ieee80211_hw *hw =3D ar->hw;
> +	u32 ac;
> +
> +	if (ar->htt.num_pending_tx >=3D (ar->htt.max_num_pending_tx / 2))
> +		return;
>=20=20
> -		if (artxq =3D=3D last || (ret < 0 && ret !=3D -ENOENT))
> +	rcu_read_lock();
> +
> +	for (ac =3D 0; ac < IEEE80211_NUM_ACS; ac++) {
> +		if (ath10k_mac_schedule_txq(hw, ac) =3D=3D -EBUSY)
>  			break;
>  	}
>=20=20
>  	rcu_read_unlock();
> -	spin_unlock_bh(&ar->txqs_lock);
>  }
>  EXPORT_SYMBOL(ath10k_mac_tx_push_pending);
>=20=20
> @@ -4293,31 +4281,25 @@ static void ath10k_mac_op_tx(struct ieee80211_hw =
*hw,
>  static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
>  					struct ieee80211_txq *txq)
>  {
> -	struct ath10k *ar =3D hw->priv;
> -	struct ath10k_txq *artxq =3D (void *)txq->drv_priv;
> -	struct ieee80211_txq *f_txq;
> -	struct ath10k_txq *f_artxq;
> +	u8 ac =3D txq->ac;
>  	int ret =3D 0;
> -	int max =3D HTC_HOST_MAX_MSG_PER_TX_BUNDLE;
> -
> -	spin_lock_bh(&ar->txqs_lock);
> -	if (list_empty(&artxq->list))
> -		list_add_tail(&artxq->list, &ar->txqs);
>=20=20
> -	f_artxq =3D list_first_entry(&ar->txqs, struct ath10k_txq, list);
> -	f_txq =3D container_of((void *)f_artxq, struct ieee80211_txq, drv_priv);
> -	list_del_init(&f_artxq->list);
> +	ieee80211_txq_schedule_start(hw, ac);
> +	txq =3D ieee80211_next_txq(hw, ac);
> +	ieee80211_txq_schedule_end(hw, ac);

You should really defer this schedule_end() until the scheduling episode
actually, y'know, ends... :)

> +	if (!txq)
> +		return;
>=20=20
> -	while (ath10k_mac_tx_can_push(hw, f_txq) && max--) {
> -		ret =3D ath10k_mac_tx_push_txq(hw, f_txq);
> +	while (ath10k_mac_tx_can_push(hw, txq)) {
> +		ret =3D ath10k_mac_tx_push_txq(hw, txq);
>  		if (ret < 0)
>  			break;
>  	}
> -	if (ret !=3D -ENOENT)
> -		list_add_tail(&f_artxq->list, &ar->txqs);
> -	spin_unlock_bh(&ar->txqs_lock);
> -
> -	ath10k_htt_tx_txq_update(hw, f_txq);
> +	if (ret =3D=3D -EBUSY) {
> +		ieee80211_txq_schedule_start(hw, ac);
> +		ieee80211_return_txq(hw, txq);
> +		ieee80211_txq_schedule_end(hw, ac);
> +	}

And ieee80211_return_txq() should be called regardless of the return
code (it'll do it's own checking and do nothing if the queue is empty).


-Toke
