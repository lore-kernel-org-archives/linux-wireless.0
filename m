Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:49759 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbXJAIlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2007 04:41:49 -0400
Received: by wa-out-1112.google.com with SMTP id v27so4474277wah
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2007 01:41:48 -0700 (PDT)
Message-ID: <1ba2fa240710010141x24a639a0k5cc3fefe06887557@mail.gmail.com>
Date: Mon, 1 Oct 2007 10:41:48 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: handle_ba_action
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071001000439.1c9ae7b1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20071001000439.1c9ae7b1.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It will be replaced with something like

#ifdef CONFIG_MAC80211_HT_AGG
        /* move to Tx aggregation for a certain DA/TID.
         * return the starting frame's sequence number in start_seq_nums.
         * If aggregation can not be started on a certain TID return error,
         * else return success */
        int (*ht_tx_agg_start)(struct ieee80211_hw *hw, const u8 *ra, u16 tid,
                                        u16 *start_seq_num);

        /* stop Tx aggregation for a certain DA/TID.
         * If aggregation can not be stopped on a certain TID return error,
         * else return success. generator field gives the HW an indication who
         * requests to stop the aggregation - recipient (0) or initiator (1)
         */
        int (*ht_tx_agg_stop)(struct ieee80211_hw *hw, const u8 *ra, u16 tid);

        /* move to Rx aggregation for a certain DA/TID.
         * If aggregation can not be started on a certain TID return error,
         * else return success */
        int (*ht_rx_agg_start)(struct ieee80211_hw *hw, const u8 *ra, u16 tid,
                                u16 start_seq_num);

        /* stop Rx aggregation for a certain DA/TID.
         * If aggregation can not be stopped on a certain TID return error,
         * else return success. generator field gives the HW an indication who
         * requests to stop the aggregation - recipient (0) or initiator (1)
        */
        int (*ht_rx_agg_stop)(struct ieee80211_hw *hw, const u8 *ra, u16 tid,
                                int generator);
#endif /* CONFIG_MAC80211_HT_AGG */

On 10/1/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> Whoever added this to include/net/mac80211.h forgot to update
> the ieee80211_ops comment block.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
