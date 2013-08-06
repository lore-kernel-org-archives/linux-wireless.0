Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52552 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab3HFJi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 05:38:26 -0400
Message-ID: <5200C408.4010107@openwrt.org> (sfid-20130806_113837_607796_A1E7513A)
Date: Tue, 06 Aug 2013 11:38:16 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 10/12] ath9k: use software queues for un-aggregated data
 packets
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org> <1375732583-39001-10-git-send-email-nbd@openwrt.org> <20992.46948.427492.675142@gargle.gargle.HOWL>
In-Reply-To: <20992.46948.427492.675142@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-08-06 10:44 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> +		aggr = !!(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
>> +		if ((aggr && txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) ||
>> +		    (!aggr && txq->axq_depth >= ATH_NON_AGGR_MIN_QDEPTH))
>> +			break;
>> +
>> +		ath_set_rates(tid->an->vif, tid->an->sta, bf);
>> +		if (aggr)
>> +			last = ath_tx_form_aggr(sc, txq, tid, &bf_q, bf,
>> +						tid_q, &aggr_len);
>> +		else
>> +			ath_tx_form_burst(sc, txq, tid, &bf_q, bf, tid_q);
>> +
>> +		if (list_empty(&bf_q))
>> +			return;
> 
> Handling non-AMPDU and AMPDU packets in the same path makes the code hard
> to follow. Since a TID can either have aggregated or unaggregated packets,
> why not separate the logic early, maybe in the schedule() function ?
When aggregation is enabled on a TID, it can still hold some
non-aggregated packets that need to be sent out first until it starts
forming A-MPDUs. I think separating this early doesn't work.

- Felix

