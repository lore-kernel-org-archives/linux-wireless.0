Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50283 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbcFQNsS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 09:48:18 -0400
Subject: Re: [PATCH 1/2] ath9k: use mac80211 intermediate software queues
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
References: <20160617090929.31606-1-toke@toke.dk>
 <20160617090929.31606-2-toke@toke.dk>
 <30beabff-a8c6-5431-be09-8f2f83ffc974@nbd.name> <87d1ng3p8g.fsf@toke.dk>
Cc: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
	Tim Shepard <shep@alum.mit.edu>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <372794e9-327a-1ff9-9888-f9826c787801@nbd.name> (sfid-20160617_154825_295176_3E6398AE)
Date: Fri, 17 Jun 2016 15:48:13 +0200
MIME-Version: 1.0
In-Reply-To: <87d1ng3p8g.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-06-17 15:43, Toke Høiland-Jørgensen wrote:
> Felix Fietkau <nbd@nbd.name> writes:
> 
>> On 2016-06-17 11:09, Toke Høiland-Jørgensen wrote:
>>> This patch leaves the code for ath9k's internal per-node per-tid
>>> queues in place and just modifies the driver to also pull from
>>> the new mac80211 intermediate software queues, and implements
>>> the .wake_tx_queue method, which will cause mac80211 to deliver
>>> packets to be sent via the new intermediate queue.
>>> 
>>> Signed-off-by: Tim Shepard <shep@alum.mit.edu>
>>> 
>>> Reworked to not require the global variable renaming in ath9k.
>>> 
>>> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
>>> ---
>>>  drivers/net/wireless/ath/ath9k/ath9k.h     |  16 +++-
>>>  drivers/net/wireless/ath/ath9k/debug_sta.c |   7 +-
>>>  drivers/net/wireless/ath/ath9k/init.c      |   1 +
>>>  drivers/net/wireless/ath/ath9k/main.c      |   1 +
>>>  drivers/net/wireless/ath/ath9k/xmit.c      | 119 +++++++++++++++++++++++++----
>>>  5 files changed, 125 insertions(+), 19 deletions(-)
>>> 
>>> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
>>> index 93b3793..caeae10 100644
>>> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
>>> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
>>> @@ -145,8 +145,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
>>>  #define BAW_WITHIN(_start, _bawsz, _seqno) \
>>>  	((((_seqno) - (_start)) & 4095) < (_bawsz))
>>>  
>>> -#define ATH_AN_2_TID(_an, _tidno)  (&(_an)->tid[(_tidno)])
>>> -
>>>  #define IS_HT_RATE(rate)   (rate & 0x80)
>>>  #define IS_CCK_RATE(rate)  ((rate >= 0x18) && (rate <= 0x1e))
>>>  #define IS_OFDM_RATE(rate) ((rate >= 0x8) && (rate <= 0xf))
>>> @@ -232,8 +230,10 @@ struct ath_buf {
>>>  
>>>  struct ath_atx_tid {
>>>  	struct list_head list;
>>> +	struct sk_buff_head i_q;
>> Do we really need a third queue here? Instead of adding yet another
>> layer of queueing here, I think we should even get rid of buf_q.
> 
> This is definitely something that needs to be improved. One other
> sticking point related to this: in the current version of this patch
> ath_tid_has_buffered() gains a side effect of pulling from the mac80211
> txq, which is obviously not so nice.
> 
> The obvious way to get rid of this is to export a txq_has_buffered()
> function at the mac80211 layer. But avoiding that may be possible; the
> sticking point is what to do with the code paths that do not dequeue
> packets, but check ath_tid_has_buffered() to decide whether to schedule
> the queue and/or to tell ieee80211_sta_set_buffered() about it (these
> are for instance ath_tx_aggr_sleep/wakeup(). Can those just be removed
> (i.e. don't call into ieee80211, and always schedule the txq on wakeup?
> I'm not familiar enough with the intermediate queues to make that
> call...
For tx scheduling, we can use swq_nonempty and deal with false positives.
For power save we should only use ieee80211_sta_set_buffered if the
driver itself has buffered some frames. Indication of packets in the
mac80211 intermediate queue is already taken care of inside mac80211.

- Felix
