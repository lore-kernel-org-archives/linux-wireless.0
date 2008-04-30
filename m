Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:34894 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132AbYD3RZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 13:25:39 -0400
Received: by fg-out-1718.google.com with SMTP id 19so229298fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2008 10:25:36 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/3] mac80211: QoS related cleanups
Date: Wed, 30 Apr 2008 19:29:20 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20080429151858.253229000@sipsolutions.net> <20080429152042.544902000@sipsolutions.net>
In-Reply-To: <20080429152042.544902000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804301929.21347.IvDoorn@gmail.com> (sfid-20080430_192530_684707_070F0C0C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> --- everything.orig/net/mac80211/wme.c	2008-04-29 11:22:40.000000000 +0200
> +++ everything/net/mac80211/wme.c	2008-04-29 11:25:41.000000000 +0200
> @@ -19,16 +19,22 @@
>  #include "wme.h"
>  
>  /* maximum number of hardware queues we support. */
> -#define TC_80211_MAX_QUEUES 16
> +#define QD_MAX_QUEUES (IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_QUEUES)
> +/* current number of hardware queues we support. */
> +#define QD_NUM(hw) ((hw)->queues + (hw)->ampdu_queues)
>  
> +/*
> + * Default mapping in classifier to work with default
> + * queue setup.
> + */
>  const int ieee802_1d_to_ac[8] = { 2, 3, 3, 2, 1, 1, 0, 0 };
>  
>  struct ieee80211_sched_data
>  {
> -	unsigned long qdisc_pool[BITS_TO_LONGS(TC_80211_MAX_QUEUES)];
> +	unsigned long qdisc_pool[BITS_TO_LONGS(QD_MAX_QUEUES)];
>  	struct tcf_proto *filter_list;
> -	struct Qdisc *queues[TC_80211_MAX_QUEUES];
> -	struct sk_buff_head requeued[TC_80211_MAX_QUEUES];
> +	struct Qdisc *queues[QD_MAX_QUEUES];
> +	struct sk_buff_head requeued[QD_MAX_QUEUES];
>  };
>  
>  static const char llc_ip_hdr[8] = {0xAA, 0xAA, 0x3, 0, 0, 0, 0x08, 0};
> @@ -95,7 +101,7 @@ static inline int wme_downgrade_ac(struc
>  
>  /* positive return value indicates which queue to use
>   * negative return value indicates to drop the frame */
> -static inline int classify80211(struct sk_buff *skb, struct Qdisc *qd)
> +static int classify80211(struct sk_buff *skb, struct Qdisc *qd)
>  {
>  	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
> @@ -106,7 +112,7 @@ static inline int classify80211(struct s
>  	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)) {
>  		/* management frames go on AC_VO queue, but are sent
>  		* without QoS control fields */
> -		return IEEE80211_TX_QUEUE_DATA0;
> +		return 0;
>  	}
>  
>  	if (0 /* injected */) {
> @@ -141,14 +147,16 @@ static inline int classify80211(struct s
>  static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
>  {
>  	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
> +	struct ieee80211_hw *hw = &local->hw;
>  	struct ieee80211_sched_data *q = qdisc_priv(qd);
>  	struct ieee80211_tx_packet_data *pkt_data =
>  		(struct ieee80211_tx_packet_data *) skb->cb;
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
>  	unsigned short fc = le16_to_cpu(hdr->frame_control);
>  	struct Qdisc *qdisc;
> -	int err, queue;
>  	struct sta_info *sta;
> +	int err;
> +	u16 queue;
>  	u8 tid;
>  
>  	if (pkt_data->flags & IEEE80211_TXPD_REQUEUE) {
> @@ -158,7 +166,7 @@ static int wme_qdiscop_enqueue(struct sk
>  		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
>  		if (sta) {
>  			int ampdu_queue = sta->tid_to_tx_q[tid];
> -			if ((ampdu_queue < local->hw.queues) &&
> +			if ((ampdu_queue < QD_NUM(hw)) &&
>  			    test_bit(ampdu_queue, q->qdisc_pool)) {
>  				queue = ampdu_queue;
>  				pkt_data->flags |= IEEE80211_TXPD_AMPDU;
> @@ -174,6 +182,9 @@ static int wme_qdiscop_enqueue(struct sk
>  
>  	queue = classify80211(skb, qd);
>  
> +	if (unlikely(queue >= local->hw.queues))
> +		queue = local->hw.queues - 1;
> +
>  	/* now we know the 1d priority, fill in the QoS header if there is one
>  	 */
>  	if (WLAN_FC_IS_QOS_DATA(fc)) {
> @@ -193,8 +204,8 @@ static int wme_qdiscop_enqueue(struct sk
>  		sta = sta_info_get(local, hdr->addr1);
>  		if (sta) {
>  			int ampdu_queue = sta->tid_to_tx_q[tid];
> -			if ((ampdu_queue < local->hw.queues) &&
> -				test_bit(ampdu_queue, q->qdisc_pool)) {
> +			if ((ampdu_queue < QD_NUM(hw)) &&
> +			    test_bit(ampdu_queue, q->qdisc_pool)) {
>  				queue = ampdu_queue;
>  				pkt_data->flags |= IEEE80211_TXPD_AMPDU;
>  			} else {
> @@ -205,17 +216,6 @@ static int wme_qdiscop_enqueue(struct sk
>  		rcu_read_unlock();
>  	}
>  
> -	if (unlikely(queue >= local->hw.queues)) {
> -#if 0
> -		if (net_ratelimit()) {
> -			printk(KERN_DEBUG "%s - queue=%d (hw does not "
> -			       "support) -> %d\n",
> -			       __func__, queue, local->hw.queues - 1);
> -		}
> -#endif
> -		queue = local->hw.queues - 1;
> -	}
> -
>  	if (unlikely(queue < 0)) {
>  			kfree_skb(skb);
>  			err = NET_XMIT_DROP;

With queue now unsigned, the above check will always be false:
net/mac80211/wme.c: In function 'wme_qdiscop_enqueue':
net/mac80211/wme.c:219: warning: comparison is always false due to limited range of data type

Ivo
