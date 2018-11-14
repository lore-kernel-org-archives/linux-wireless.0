Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C86C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 17:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1601D2145D
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 17:40:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="gq/Bz5MY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1601D2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbeKODov (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 22:44:51 -0500
Received: from mail.toke.dk ([52.28.52.200]:57649 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725759AbeKODov (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 22:44:51 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1542217241; bh=Iuv3WYVxNIS4kR3kN1xGY4Z8dxMXie06FtiAXqitQ7M=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=gq/Bz5MYLgeXC17uiiBdooP0cjAHqIk1z3GiIn5pNlLhi41mIwvj19R1yV8rOnyWQ
         qiYANXDN/zTpkjhaXrQT3zRRFSv2h3xYizWfCFyyzNTMRdnJwxdy/RxrIbrIo6Oyja
         w/MsoJifmy/sshIN12nft2tlqReXzQQq9gHc1IlienIFqcF9ICQWrd+FobriJzDeSl
         PN2Iaz8vj/A+HBqGmF6U+mnim/77Jdss/+Wt9k4d8RdSJiVPt50vq9zapFlKTuUhxA
         QB4OEWgrBRXXqClx813TkjVaPoaUGYOYVc1qxaExACUbssaIH8PUGuxjKKBcHY8ciC
         e5Kdtwyxq2hrA==
To:     Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net
Subject: Re: [PATCH v3 3/6] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <e5344cad-2a18-a938-f2ed-43870027251c@nbd.name>
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org> <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org> <e5344cad-2a18-a938-f2ed-43870027251c@nbd.name>
Date:   Wed, 14 Nov 2018 09:40:38 -0800
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <871s7nv9pl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> On 2018-11-12 23:51, Rajkumar Manoharan wrote:
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>>=20
>> This adds airtime accounting and scheduling to the mac80211 TXQ
>> scheduler. A new callback, ieee80211_sta_register_airtime(), is added
>> that drivers can call to report airtime usage for stations.
>>=20
>> When airtime information is present, mac80211 will schedule TXQs
>> (through ieee80211_next_txq()) in a way that enforces airtime fairness
>> between active stations. This scheduling works the same way as the ath9k
>> in-driver airtime fairness scheduling. If no airtime usage is reported
>> by the driver, the scheduler will default to round-robin scheduling.
>>=20
>> For drivers that don't control TXQ scheduling in software, a new API
>> function, ieee80211_txq_may_transmit(), is added which the driver can use
>> to check if the TXQ is eligible for transmission, or should be throttled=
 to
>> enforce fairness. Calls to this function must also be enclosed in
>> ieee80211_txq_schedule_{start,end}() calls to ensure proper locking.
>>=20
>> The API ieee80211_txq_may_transmit() also ensures that TXQ list will be
>> aligned aginst driver's own round-robin scheduler list. i.e it rotates
>> the TXQ list till it makes the requested node becomes the first entry
>> in TXQ list. Thus both the TXQ list and driver's list are in sync.
>>=20
>> Co-Developed-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
>> ---
>>  include/net/mac80211.h     | 59 ++++++++++++++++++++++++++++++
>>  net/mac80211/cfg.c         |  3 ++
>>  net/mac80211/debugfs.c     |  3 ++
>>  net/mac80211/debugfs_sta.c | 50 ++++++++++++++++++++++++--
>>  net/mac80211/ieee80211_i.h |  2 ++
>>  net/mac80211/main.c        |  4 +++
>>  net/mac80211/sta_info.c    | 44 +++++++++++++++++++++--
>>  net/mac80211/sta_info.h    | 13 +++++++
>>  net/mac80211/status.c      |  6 ++++
>>  net/mac80211/tx.c          | 90 +++++++++++++++++++++++++++++++++++++++=
++++---
>>  10 files changed, 264 insertions(+), 10 deletions(-)
>>=20
>> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
>> index aa4afbf0abaf..a1f1256448f5 100644
>> --- a/net/mac80211/status.c
>> +++ b/net/mac80211/status.c
>> @@ -818,6 +818,12 @@ static void __ieee80211_tx_status(struct ieee80211_=
hw *hw,
>>  			ieee80211_sta_tx_notify(sta->sdata, (void *) skb->data,
>>  						acked, info->status.tx_time);
>>=20=20
>> +		if (info->status.tx_time &&
>> +		    wiphy_ext_feature_isset(local->hw.wiphy,
>> +					    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
>> +			ieee80211_sta_register_airtime(&sta->sta, tid,
>> +						       info->status.tx_time, 0);
>> +
>>  		if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
>>  			if (info->flags & IEEE80211_TX_STAT_ACK) {
>>  				if (sta->status_stats.lost_packets)
> I think the same is needed in ieee80211_tx_status_ext.

Right, good point.

>> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>> index 305965283506..3f417e80e041 100644
>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> @@ -3660,12 +3680,74 @@ void ieee80211_return_txq(struct ieee80211_hw *h=
w,
>>  	lockdep_assert_held(&local->active_txq_lock[txq->ac]);
>>=20=20
>>  	if (list_empty(&txqi->schedule_order) &&
>> -	    (!skb_queue_empty(&txqi->frags) || txqi->tin.backlog_packets))
>> -		list_add_tail(&txqi->schedule_order,
>> -			      &local->active_txqs[txq->ac]);
>> +	    (!skb_queue_empty(&txqi->frags) || txqi->tin.backlog_packets)) {
>> +		/* If airtime accounting is active, always enqueue STAs at the
>> +		 * head of the list to ensure that they only get moved to the
>> +		 * back by the airtime DRR scheduler once they have a negative
>> +		 * deficit. A station that already has a negative deficit will
>> +		 * get immediately moved to the back of the list on the next
>> +		 * call to ieee80211_next_txq().
>> +		 */
>> +		if (txqi->txq.sta &&
>> +		    wiphy_ext_feature_isset(local->hw.wiphy,
>> +					    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
>> +			list_add(&txqi->schedule_order,
>> +				 &local->active_txqs[txq->ac]);
>> +		else
>> +			list_add_tail(&txqi->schedule_order,
>> +				      &local->active_txqs[txq->ac]);
>> +	}
>>  }
> This part doesn't really make much sense to me, but maybe I'm
> misunderstanding how the code works.
> Let's assume we have a driver like ath9k or mt76, which tries to keep a
> number of aggregates in the hardware queue, and the hardware queue is
> currently empty.
> If the current txq entry is kept at the head of the schedule list,
> wouldn't the code just pull from that one over and over again, until
> enough packets are transmitted by the hardware and their tx status
> processed?
> It seems to me that while fairness is still preserved in the long run,
> this could lead to rather bursty scheduling, which may not be
> particularly latency friendly.

Yes, it'll be a bit more bursty when the hardware queue is completely
empty. However, when a TX completion comes back, that will adjust the
deficit of that sta and cause it to be rotated on the next dequeue. This
obviously relies on the fact that the lower-level hardware queue is
sufficiently shallow to not add a lot of latency. But we want that to be
the case anyway. In practice, it works quite well for ath9k, but not so
well for ath10k because it has a large buffer in firmware.

If we requeue the TXQ at the end of the list, a station that is taking
up too much airtime will fail to be throttled properly, so the
queue-at-head is kinda needed to ensure fairness...

-Toke
