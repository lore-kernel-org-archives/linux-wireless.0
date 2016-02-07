Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34009 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbcBGHZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2016 02:25:33 -0500
Received: by mail-lb0-f169.google.com with SMTP id cw1so68885162lbb.1
        for <linux-wireless@vger.kernel.org>; Sat, 06 Feb 2016 23:25:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1454668864-31777-1-git-send-email-nbd@openwrt.org>
References: <1454668864-31777-1-git-send-email-nbd@openwrt.org>
Date: Sun, 7 Feb 2016 09:25:31 +0200
Message-ID: <CANUX_P3xJBopdHcNjwJ2UcXLPZcNHJtE+mC2=3i8b4p=J8kjXQ@mail.gmail.com> (sfid-20160207_082537_174754_F6B008F1)
Subject: Re: [RFC v2] mac80211: add A-MSDU tx support
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 5, 2016 at 12:41 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Requires software tx queueing support. frag_list support (for zero-copy)
> is optional.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Looks nice!
This would allow us to create aggregates of TCP Acks, the problem is
that when you are mostly receiving data, the hardware queues are
pretty much empty (nothing besides the TCP Acks which should go out
quickly) so that packets don't pile up in the software queues and
hence you don't have enough material to build an A-MSDU.
I guess that for AP oriented devices, this is ideal solution since you
can't rely on TSO (packets are not locally generated) and this allows
to build an A-MSDU without adding more latency since you build an
A-MSDU with packets that are already in the queue waiting instead of
delaying transmission of the first packet.
IIRC, the latter was the approach chose by the new Marvell driver
posted a few weeks ago. This approach is better in my eyes.
For iwlwifi which is much more station oriented (of GO which is
basically an AP with locally generated traffic), I took the TSO
approach. I guess we could try to change iwlwifi to use your tx
queues, and check how that works. This would allow us to have A-MSDU
on bridged traffic as well, although this use case is much less common
for Intel devices.

One small question below.

[snip]

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
> +       int max_amsdu_len;
> +       __be16 len;
> +       void *data;
> +       bool ret = false;
> +       int n = 1;
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
> +       /*
> +        * A-MPDU limits maximum MPDU size to 4095 bytes. Since aggregation
> +        * sessions are started/stopped without txq flush, use the limit here
> +        * to avoid having to de-aggregate later.
> +        */
> +       max_amsdu_len = min_t(int, sta->sta.max_amsdu_len, 4095);

So you can't get 10K A-MSDUs? I don't see where you check that you
have an A-MPDU session here. You seem to be applying the 4095 limit
also for streams that are not an A-MPDU?
I guess you could check if the sta is a VHT peer, in that case, no
limit applies.

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
> +       if (!ieee80211_amsdu_prepare_head(sdata, fast_tx, head))
> +               goto out;
> +
> +       frag_tail = &skb_shinfo(head)->frag_list;
> +       while (*frag_tail) {
> +            frag_tail = &(*frag_tail)->next;
> +                n++;
> +       }
> +
> +       if (local->hw.max_tx_amsdu_subframes &&
> +           n > local->hw.max_tx_amsdu_subframes)
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
> @@ -2817,6 +2964,10 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
