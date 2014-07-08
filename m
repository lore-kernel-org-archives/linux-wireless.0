Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53206 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbaGHHKT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2014 03:10:19 -0400
Message-ID: <1404803407.4419.3.camel@jlt4.sipsolutions.net> (sfid-20140708_091022_814551_414D730E)
Subject: Re: [RFC/RFT 1/2] mac80211: add support for Rx reordering offloading
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	Denton Gentry <denton.gentry@gmail.com>
Date: Tue, 08 Jul 2014 09:10:07 +0200
In-Reply-To: <1403860015-31601-2-git-send-email-michal.kazior@tieto.com> (sfid-20140627_111730_127587_DA36C97E)
References: <1403860015-31601-1-git-send-email-michal.kazior@tieto.com>
	 <1403860015-31601-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140627_111730_127587_DA36C97E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-06-27 at 11:06 +0200, Michal Kazior wrote:

> +/**
> + * ieee80211_start_rx_ba_session_offl - start a Rx BA session
> + *
> + * Some device drivers may offload part of the Rx aggregation flow including
> + * AddBa/DelBa negotiation but may otherwise be incapable of full Rx
> + * reordering.
> + *
> + * Create structures responsible for reordering so device drivers may call here
> + * when they complete AddBa negotiation.
> + *
> + * @vif: &struct ieee80211_vif pointer from the add_interface callback
> + * @addr: station mac address
> + * @dialog_token:
> + * @timeout: session timeout (in TU)

Why would you need the dialog token (and why no docs?) and timeout?

> + * @start_seq_num: starting frame sequence number
> + * @tid: the rx tid

> + * @buf_size: max number of frames in reorder buffer

The buf_size also isn't really needed, is it? We are allowed to use a
bigger buffer, I believe?

> +void ieee80211_start_rx_ba_session_offl(struct ieee80211_vif *vif,
> +					const u8 *addr, u8 dialog_token,
> +					u16 timeout, u16 start_seq_num,
> +					u16 tid, u16 buf_size)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +	struct ieee80211_local *local = sdata->local;
> +	struct ieee80211_rx_agg *rx_agg;
> +	struct sk_buff *skb = dev_alloc_skb(0);
> +
> +	if (unlikely(!skb))
> +		return;
> +
> +	rx_agg = (struct ieee80211_rx_agg *) &skb->cb;
> +	memcpy(&rx_agg->addr, addr, ETH_ALEN);
> +	rx_agg->dialog_token = dialog_token;
> +	rx_agg->timeout = timeout;
> +	rx_agg->start_seq_num = start_seq_num;
> +	rx_agg->ba_policy = 1;
> +	rx_agg->tid = tid;
> +	rx_agg->buf_size = buf_size;
> +
> +	skb->pkt_type = IEEE80211_SDATA_QUEUE_RX_AGG_START;
> +	skb_queue_tail(&sdata->skb_queue, skb);
> +	ieee80211_queue_work(&local->hw, &sdata->work);

This seems problematic, since packets might be received immediately.

On the teardown path it should probably also be invalidated immediately,
no?

Then again, we have the same problem already? Hmm.

johannes

