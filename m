Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:55504 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab3HFI5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 04:57:25 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20992.46948.427492.675142@gargle.gargle.HOWL> (sfid-20130806_105729_490367_1A775FED)
Date: Tue, 6 Aug 2013 14:14:20 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 10/12] ath9k: use software queues for un-aggregated data packets
In-Reply-To: <1375732583-39001-10-git-send-email-nbd@openwrt.org>
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
	<1375732583-39001-10-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> +		aggr = !!(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
> +		if ((aggr && txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) ||
> +		    (!aggr && txq->axq_depth >= ATH_NON_AGGR_MIN_QDEPTH))
> +			break;
> +
> +		ath_set_rates(tid->an->vif, tid->an->sta, bf);
> +		if (aggr)
> +			last = ath_tx_form_aggr(sc, txq, tid, &bf_q, bf,
> +						tid_q, &aggr_len);
> +		else
> +			ath_tx_form_burst(sc, txq, tid, &bf_q, bf, tid_q);
> +
> +		if (list_empty(&bf_q))
> +			return;

Handling non-AMPDU and AMPDU packets in the same path makes the code hard
to follow. Since a TID can either have aggregated or unaggregated packets,
why not separate the logic early, maybe in the schedule() function ?

Sujith
