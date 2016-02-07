Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33727 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbcBGUQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2016 15:16:30 -0500
Received: by mail-lf0-f52.google.com with SMTP id m1so85915123lfg.0
        for <linux-wireless@vger.kernel.org>; Sun, 07 Feb 2016 12:16:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1454851282-31464-1-git-send-email-nbd@openwrt.org>
References: <1454851282-31464-1-git-send-email-nbd@openwrt.org>
Date: Sun, 7 Feb 2016 22:16:28 +0200
Message-ID: <CANUX_P3L+U2-HsJpQcHd0e5iw9eAwQnhkNNmRtCZqKGw42Su0A@mail.gmail.com> (sfid-20160207_211634_646091_69E34C71)
Subject: Re: [RFC v3] mac80211: add A-MSDU tx support
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 7, 2016 at 3:21 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Requires software tx queueing support. frag_list support (for zero-copy)
> is optional.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  include/net/mac80211.h     |  17 +++++
>  net/mac80211/agg-tx.c      |   5 ++
>  net/mac80211/debugfs.c     |   2 +
>  net/mac80211/ieee80211_i.h |   1 +
>  net/mac80211/tx.c          | 168 +++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 193 insertions(+)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 5714774..31dca81 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -709,6 +709,7 @@ enum mac80211_tx_info_flags {
>   * @IEEE80211_TX_CTRL_PS_RESPONSE: This frame is a response to a poll
>   *     frame (PS-Poll or uAPSD).
>   * @IEEE80211_TX_CTRL_RATE_INJECT: This frame is injected with rate information
> + * @IEEE80211_TX_CTRL_AMSDU: This frame is an A-MSDU frame
>   *
>   * These flags are used in tx_info->control.flags.
>   */
> @@ -716,6 +717,7 @@ enum mac80211_tx_control_flags {
>         IEEE80211_TX_CTRL_PORT_CTRL_PROTO       = BIT(0),
>         IEEE80211_TX_CTRL_PS_RESPONSE           = BIT(1),
>         IEEE80211_TX_CTRL_RATE_INJECT           = BIT(2),
> +       IEEE80211_TX_CTRL_AMSDU                 = BIT(3),
>  };
>
>  /*
> @@ -1964,6 +1966,12 @@ struct ieee80211_txq {
>   *     order and does not need to manage its own reorder buffer or BA session
>   *     timeout.
>   *
> + * @IEEE80211_HW_TX_AMSDU: Hardware (or driver) supports software aggregated
> + *     A-MSDU frames. Requires software tx queueing support.
> + *
> + * @IEEE80211_HW_TX_FRAG_LIST: Hardware (or driver) supports sending frag_list
> + *     skbs, needed for zero-copy software A-MSDU.
> + *
>   * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
>   */
>  enum ieee80211_hw_flags {
> @@ -2001,6 +2009,8 @@ enum ieee80211_hw_flags {
>         IEEE80211_HW_BEACON_TX_STATUS,
>         IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR,
>         IEEE80211_HW_SUPPORTS_REORDERING_BUFFER,
> +       IEEE80211_HW_TX_AMSDU,
> +       IEEE80211_HW_TX_FRAG_LIST,
>
>         /* keep last, obviously */
>         NUM_IEEE80211_HW_FLAGS
> @@ -2073,6 +2083,11 @@ enum ieee80211_hw_flags {
>   *     size is smaller (an example is LinkSys WRT120N with FW v1.0.07
>   *     build 002 Jun 18 2012).
>   *
> + * @max_tx_amsdu_subframes: maximum number of subframes used in software
> + *     A-MSDU aggregation
> + *
> + * @max_tx_fragments: maximum fragments per (A-)MSDU.
> + *
>   * @offchannel_tx_hw_queue: HW queue ID to use for offchannel TX
>   *     (if %IEEE80211_HW_QUEUE_CONTROL is set)
>   *
> @@ -2127,6 +2142,8 @@ struct ieee80211_hw {
>         u8 max_rate_tries;
>         u8 max_rx_aggregation_subframes;
>         u8 max_tx_aggregation_subframes;
> +       u8 max_tx_amsdu_subframes;
> +       u8 max_tx_fragments;

I have to see I still don't understand why drivers would want to limit
the number of subframes. Limiting the number of frags should be
enough, don't you think?

>         u8 offchannel_tx_hw_queue;
>         u8 radiotap_mcs_details;
>         u16 radiotap_vht_details;
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index 4932e9f..42fa810 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-taxx.c
> @@ -935,6 +935,7 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
>                                   size_t len)
>  {
>         struct tid_ampdu_tx *tid_tx;
> +       struct ieee80211_txq *txq;
>         u16 capab, tid;
>         u8 buf_size;
>         bool amsdu;
> @@ -945,6 +946,10 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
>         buf_size = (capab & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK) >> 6;
>         buf_size = min(buf_size, local->hw.max_tx_aggregation_subframes);
>
> +       txq = sta->sta.txq[tid];
> +       if (!amsdu && txq)
> +               set_bit(IEEE80211_TXQ_NO_AMSDU, &to_txq_info(txq)->flags);
> +
>         mutex_lock(&sta->ampdu_mlme.mtx);
>
>         tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
> diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
> index e433d0c..847779d 100644
> --- a/net/mac80211/debugfs.c
> +++ b/net/mac80211/debugfs.c
> @@ -127,6 +127,8 @@ static const char *hw_flag_names[NUM_IEEE80211_HW_FLAGS + 1] = {
>         FLAG(BEACON_TX_STATUS),
>         FLAG(NEEDS_UNIQUE_STA_ADDR),
>         FLAG(SUPPORTS_REORDERING_BUFFER),
> +       FLAG(TX_AMSDU),
> +       FLAG(TX_FRAG_LIST),
>
>         /* keep last for the build bug below */
>         (void *)0x1
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index a49c103..e68d8db 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -799,6 +799,7 @@ struct mac80211_qos_map {
>  enum txq_info_flags {
>         IEEE80211_TXQ_STOP,
>         IEEE80211_TXQ_AMPDU,
> +       IEEE80211_TXQ_NO_AMSDU,
>  };
>
>  struct txq_info {
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index a5aa275..f37f729 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1324,6 +1324,10 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
>  out:
>         spin_unlock_bh(&txqi->queue.lock);
>
> +       if (skb && skb_has_frag_list(skb) &&
> +           !ieee80211_hw_check(&local->hw, TX_FRAG_LIST))
> +               skb_linearize(skb);
> +
>         return skb;
>  }
>  EXPORT_SYMBOL(ieee80211_tx_dequeue);
> @@ -2763,6 +2767,166 @@ void ieee80211_clear_fast_xmit(struct sta_info *sta)
>                 kfree_rcu(fast_tx, rcu_head);
>  }
>
> +static int ieee80211_amsdu_pad(struct sk_buff *skb, int subframe_len)
> +{
> +       int amsdu_len = subframe_len + sizeof(struct ethhdr);
> +       int padding = (4 - amsdu_len) & 3;
> +
> +       if (padding)
> +               memset(skb_put(skb, padding), 0, padding);
> +
> +       return padding;
> +}
> +
> +static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
> +                                        struct ieee80211_fast_tx *fast_tx,
> +                                        struct sk_buff *skb)
> +{
> +       struct ieee80211_local *local = sdata->local;
> +       struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +       struct ieee80211_hdr *hdr;
> +       struct ethhdr amsdu_hdr;
> +       int hdr_len = fast_tx->hdr_len - sizeof(rfc1042_header);
> +       int subframe_len = skb->len - hdr_len;
> +       void *data;
> +       u8 *qc;
> +
> +       if (info->control.flags & IEEE80211_TX_CTRL_AMSDU)
> +               return true;
> +
> +       if (skb_headroom(skb) < sizeof(amsdu_hdr) || skb_tailroom(skb) < 3) {
> +               I802_DEBUG_INC(local->tx_expand_skb_head);
> +
> +               if (pskb_expand_head(skb, sizeof(amsdu_hdr), 3, GFP_ATOMIC)) {
> +                       wiphy_debug(local->hw.wiphy,
> +                                   "failed to reallocate TX buffer\n");
> +                       return false;
> +               }
> +       }
> +
> +       subframe_len += ieee80211_amsdu_pad(skb, subframe_len);
> +
> +       amsdu_hdr.h_proto = cpu_to_be16(subframe_len);
> +       memcpy(amsdu_hdr.h_source, skb->data + fast_tx->sa_offs, ETH_ALEN);
> +       memcpy(amsdu_hdr.h_dest, skb->data + fast_tx->da_offs, ETH_ALEN);
> +
> +       data = skb_push(skb, sizeof(amsdu_hdr));
> +       memmove(data, data + sizeof(amsdu_hdr), hdr_len);
> +       memcpy(data + hdr_len, &amsdu_hdr, sizeof(amsdu_hdr));
> +
> +       hdr = data;
> +       qc = ieee80211_get_qos_ctl(hdr);
> +       *qc |= IEEE80211_QOS_CTL_A_MSDU_PRESENT;
> +
> +       info->control.flags |= IEEE80211_TX_CTRL_AMSDU;
> +
> +       return true;
> +}
> +
> +static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
> +                                     struct sta_info *sta,
> +                                     struct ieee80211_fast_tx *fast_tx,
> +                                     struct sk_buff *skb)
> +{
> +       struct ieee80211_local *local = sdata->local;
> +       u8 tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
> +       struct ieee80211_txq *txq = sta->sta.txq[tid];
> +       struct txq_info *txqi;
> +       struct sk_buff **frag_tail, *head;
> +       int subframe_len = skb->len - ETH_ALEN;
> +       u8 max_subframes = 0xff;
> +       int max_frags = local->hw.max_tx_fragments;
> +       int max_amsdu_len;
> +       __be16 len;
> +       void *data;
> +       bool ret = false;
> +       int n = 1, nfrags;
> +
> +       if (!ieee80211_hw_check(&local->hw, TX_AMSDU))
> +               return false;
> +
> +       if (!txq)
> +               return false;
> +
> +       txqi = to_txq_info(txq);
> +       if (test_bit(IEEE80211_TXQ_NO_AMSDU, &txqi->flags))
> +               return false;
> +
> +       if (sta->sta.max_amsdu_subframes)
> +               max_subframes = min(max_subframes,
> +                                   sta->sta.max_amsdu_subframes);
> +
> +       if (local->hw.max_tx_amsdu_subframes)
> +               max_subframes = min(max_subframes,
> +                                   local->hw.max_tx_amsdu_subframes);
> +
> +       spin_lock_bh(&txqi->queue.lock);
> +
> +       head = skb_peek_tail(&txqi->queue);
> +       if (!head)
> +               goto out;
> +
> +       if (skb->len + head->len > max_amsdu_len)
> +               goto out;
> +
> +       /*
> +        * HT A-MPDU limits maximum MPDU size to 4095 bytes. Since aggregation
> +        * sessions are started/stopped without txq flush, use the limit here
> +        * to avoid having to de-aggregate later.
> +        */
> +       if (skb->len + head->len > 4095 &&
> +           !sta->sta.vht_cap.vht_supported)
> +               goto out;
> +
> +       if (!ieee80211_amsdu_prepare_head(sdata, fast_tx, head))
> +               goto out;
> +
> +       nfrags = 1 + skb_shinfo(skb)->nr_frags;
> +       nfrags += 1 + skb_shinfo(head)->nr_frags;
> +       frag_tail = &skb_shinfo(head)->frag_list;
> +       while (*frag_tail) {
> +               nfrags += 1 + skb_shinfo(*frag_tail)->nr_frags;
> +           frag_tail = &(*frag_tail)->next;
> +               n++;
> +       }
> +
> +       if (max_subframes && n > max_subframes)

max_subframes can't be 0. You set it to 0xff at the beginning.

> +               goto out;
> +
> +       if (max_frags && nfrags > max_frags)
> +               goto out;
> +
> +       if (skb_headroom(skb) < 8 || skb_tailroom(skb) < 3) {
> +               I802_DEBUG_INC(local->tx_expand_skb_head);
> +
> +               if (pskb_expand_head(skb, 8, 3, GFP_ATOMIC)) {
> +                       wiphy_debug(local->hw.wiphy,
> +                                   "failed to reallocate TX buffer\n");
> +                       goto out;
> +               }
> +       }
> +
> +       subframe_len += ieee80211_amsdu_pad(skb, subframe_len);
> +
> +       ret = true;
> +       data = skb_push(skb, ETH_ALEN + 2);
> +       memmove(data, data + ETH_ALEN + 2, 2 * ETH_ALEN);
> +
> +       data += 2 * ETH_ALEN;
> +       len = cpu_to_be16(subframe_len);
> +       memcpy(data, &len, 2);
> +       memcpy(data + 2, rfc1042_header, ETH_ALEN);
> +
> +       head->len += skb->len;
> +       head->data_len += skb->len;
> +       *frag_tail = skb;
> +
> +out:
> +       spin_unlock_bh(&txqi->queue.lock);
> +
> +       return ret;
> +}
> +
>  static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
>                                 struct net_device *dev, struct sta_info *sta,
>                                 struct ieee80211_fast_tx *fast_tx,
> @@ -2817,6 +2981,10 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
>
>         ieee80211_tx_stats(dev, skb->len + extra_head);
>
> +       if ((hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) &&
> +           ieee80211_amsdu_aggregate(sdata, sta, fast_tx, skb))
> +               return true;
> +
>         /* will not be crypto-handled beyond what we do here, so use false
>          * as the may-encrypt argument for the resize to not account for
>          * more room than we already have in 'extra_head'
> --
> 2.2.2
>
