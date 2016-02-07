Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:58418 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbcBGVDi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2016 16:03:38 -0500
Subject: Re: [RFC v3] mac80211: add A-MSDU tx support
To: Emmanuel Grumbach <egrumbach@gmail.com>
References: <1454851282-31464-1-git-send-email-nbd@openwrt.org>
 <CANUX_P3L+U2-HsJpQcHd0e5iw9eAwQnhkNNmRtCZqKGw42Su0A@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56B7B121.6090407@openwrt.org> (sfid-20160207_220342_021906_5486F564)
Date: Sun, 7 Feb 2016 22:03:29 +0100
MIME-Version: 1.0
In-Reply-To: <CANUX_P3L+U2-HsJpQcHd0e5iw9eAwQnhkNNmRtCZqKGw42Su0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-02-07 21:16, Emmanuel Grumbach wrote:
> On Sun, Feb 7, 2016 at 3:21 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> Requires software tx queueing support. frag_list support (for zero-copy)
>> is optional.
>>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>>  include/net/mac80211.h     |  17 +++++
>>  net/mac80211/agg-tx.c      |   5 ++
>>  net/mac80211/debugfs.c     |   2 +
>>  net/mac80211/ieee80211_i.h |   1 +
>>  net/mac80211/tx.c          | 168 +++++++++++++++++++++++++++++++++++++++++++++
>>  5 files changed, 193 insertions(+)
>>
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index 5714774..31dca81 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -2127,6 +2142,8 @@ struct ieee80211_hw {
>>         u8 max_rate_tries;
>>         u8 max_rx_aggregation_subframes;
>>         u8 max_tx_aggregation_subframes;
>> +       u8 max_tx_amsdu_subframes;
>> +       u8 max_tx_fragments;
> 
> I have to see I still don't understand why drivers would want to limit
> the number of subframes. Limiting the number of frags should be
> enough, don't you think?
Makes sense, I'll remove it.

>>         u8 offchannel_tx_hw_queue;
>>         u8 radiotap_mcs_details;
>>         u16 radiotap_vht_details;

>> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>> index a5aa275..f37f729 100644
>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> @@ -1324,6 +1324,10 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
>>  out:
>>         spin_unlock_bh(&txqi->queue.lock);
>>
>> +       if (skb && skb_has_frag_list(skb) &&
>> +           !ieee80211_hw_check(&local->hw, TX_FRAG_LIST))
>> +               skb_linearize(skb);
>> +
>>         return skb;
>>  }
>>  EXPORT_SYMBOL(ieee80211_tx_dequeue);
>> @@ -2763,6 +2767,166 @@ void ieee80211_clear_fast_xmit(struct sta_info *sta)
>>                 kfree_rcu(fast_tx, rcu_head);
>>  }
>>
>> +static int ieee80211_amsdu_pad(struct sk_buff *skb, int subframe_len)
>> +{
>> +       int amsdu_len = subframe_len + sizeof(struct ethhdr);
>> +       int padding = (4 - amsdu_len) & 3;
>> +
>> +       if (padding)
>> +               memset(skb_put(skb, padding), 0, padding);
>> +
>> +       return padding;
>> +}
>> +
>> +static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
>> +                                        struct ieee80211_fast_tx *fast_tx,
>> +                                        struct sk_buff *skb)
>> +{
>> +       struct ieee80211_local *local = sdata->local;
>> +       struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>> +       struct ieee80211_hdr *hdr;
>> +       struct ethhdr amsdu_hdr;
>> +       int hdr_len = fast_tx->hdr_len - sizeof(rfc1042_header);
>> +       int subframe_len = skb->len - hdr_len;
>> +       void *data;
>> +       u8 *qc;
>> +
>> +       if (info->control.flags & IEEE80211_TX_CTRL_AMSDU)
>> +               return true;
>> +
>> +       if (skb_headroom(skb) < sizeof(amsdu_hdr) || skb_tailroom(skb) < 3) {
>> +               I802_DEBUG_INC(local->tx_expand_skb_head);
>> +
>> +               if (pskb_expand_head(skb, sizeof(amsdu_hdr), 3, GFP_ATOMIC)) {
>> +                       wiphy_debug(local->hw.wiphy,
>> +                                   "failed to reallocate TX buffer\n");
>> +                       return false;
>> +               }
>> +       }
>> +
>> +       subframe_len += ieee80211_amsdu_pad(skb, subframe_len);
>> +
>> +       amsdu_hdr.h_proto = cpu_to_be16(subframe_len);
>> +       memcpy(amsdu_hdr.h_source, skb->data + fast_tx->sa_offs, ETH_ALEN);
>> +       memcpy(amsdu_hdr.h_dest, skb->data + fast_tx->da_offs, ETH_ALEN);
>> +
>> +       data = skb_push(skb, sizeof(amsdu_hdr));
>> +       memmove(data, data + sizeof(amsdu_hdr), hdr_len);
>> +       memcpy(data + hdr_len, &amsdu_hdr, sizeof(amsdu_hdr));
>> +
>> +       hdr = data;
>> +       qc = ieee80211_get_qos_ctl(hdr);
>> +       *qc |= IEEE80211_QOS_CTL_A_MSDU_PRESENT;
>> +
>> +       info->control.flags |= IEEE80211_TX_CTRL_AMSDU;
>> +
>> +       return true;
>> +}
>> +
>> +static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
>> +                                     struct sta_info *sta,
>> +                                     struct ieee80211_fast_tx *fast_tx,
>> +                                     struct sk_buff *skb)
>> +{
>> +       struct ieee80211_local *local = sdata->local;
>> +       u8 tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
>> +       struct ieee80211_txq *txq = sta->sta.txq[tid];
>> +       struct txq_info *txqi;
>> +       struct sk_buff **frag_tail, *head;
>> +       int subframe_len = skb->len - ETH_ALEN;
>> +       u8 max_subframes = 0xff;
>> +       int max_frags = local->hw.max_tx_fragments;
>> +       int max_amsdu_len;
>> +       __be16 len;
>> +       void *data;
>> +       bool ret = false;
>> +       int n = 1, nfrags;
>> +
>> +       if (!ieee80211_hw_check(&local->hw, TX_AMSDU))
>> +               return false;
>> +
>> +       if (!txq)
>> +               return false;
>> +
>> +       txqi = to_txq_info(txq);
>> +       if (test_bit(IEEE80211_TXQ_NO_AMSDU, &txqi->flags))
>> +               return false;
>> +
>> +       if (sta->sta.max_amsdu_subframes)
>> +               max_subframes = min(max_subframes,
>> +                                   sta->sta.max_amsdu_subframes);
>> +
>> +       if (local->hw.max_tx_amsdu_subframes)
>> +               max_subframes = min(max_subframes,
>> +                                   local->hw.max_tx_amsdu_subframes);
>> +
>> +       spin_lock_bh(&txqi->queue.lock);
>> +
>> +       head = skb_peek_tail(&txqi->queue);
>> +       if (!head)
>> +               goto out;
>> +
>> +       if (skb->len + head->len > max_amsdu_len)
>> +               goto out;
>> +
>> +       /*
>> +        * HT A-MPDU limits maximum MPDU size to 4095 bytes. Since aggregation
>> +        * sessions are started/stopped without txq flush, use the limit here
>> +        * to avoid having to de-aggregate later.
>> +        */
>> +       if (skb->len + head->len > 4095 &&
>> +           !sta->sta.vht_cap.vht_supported)
>> +               goto out;
>> +
>> +       if (!ieee80211_amsdu_prepare_head(sdata, fast_tx, head))
>> +               goto out;
>> +
>> +       nfrags = 1 + skb_shinfo(skb)->nr_frags;
>> +       nfrags += 1 + skb_shinfo(head)->nr_frags;
>> +       frag_tail = &skb_shinfo(head)->frag_list;
>> +       while (*frag_tail) {
>> +               nfrags += 1 + skb_shinfo(*frag_tail)->nr_frags;
>> +           frag_tail = &(*frag_tail)->next;
>> +               n++;
>> +       }
>> +
>> +       if (max_subframes && n > max_subframes)
> 
> max_subframes can't be 0. You set it to 0xff at the beginning.
Right, thanks.

- Felix
