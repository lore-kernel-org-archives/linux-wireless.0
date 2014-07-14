Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40722 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbaGNNSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 09:18:07 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so4095128wgh.17
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2014 06:18:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1404803407.4419.3.camel@jlt4.sipsolutions.net>
References: <1403860015-31601-1-git-send-email-michal.kazior@tieto.com>
	<1403860015-31601-2-git-send-email-michal.kazior@tieto.com>
	<1404803407.4419.3.camel@jlt4.sipsolutions.net>
Date: Mon, 14 Jul 2014 15:18:05 +0200
Message-ID: <CA+BoTQ=8UU+S8F_OhALShkoD5jT7Lj-m2oZ=B5HhmSwEuDyxpw@mail.gmail.com> (sfid-20140714_151811_671180_7A33A9C1)
Subject: Re: [RFC/RFT 1/2] mac80211: add support for Rx reordering offloading
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Denton Gentry <denton.gentry@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 July 2014 09:10, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-06-27 at 11:06 +0200, Michal Kazior wrote:
>
>> +/**
>> + * ieee80211_start_rx_ba_session_offl - start a Rx BA session
>> + *
>> + * Some device drivers may offload part of the Rx aggregation flow including
>> + * AddBa/DelBa negotiation but may otherwise be incapable of full Rx
>> + * reordering.
>> + *
>> + * Create structures responsible for reordering so device drivers may call here
>> + * when they complete AddBa negotiation.
>> + *
>> + * @vif: &struct ieee80211_vif pointer from the add_interface callback
>> + * @addr: station mac address
>> + * @dialog_token:
>> + * @timeout: session timeout (in TU)
>
> Why would you need the dialog token (and why no docs?) and timeout?

Good point. I'll remove both.


>> + * @start_seq_num: starting frame sequence number
>> + * @tid: the rx tid
>
>> + * @buf_size: max number of frames in reorder buffer
>
> The buf_size also isn't really needed, is it? We are allowed to use a
> bigger buffer, I believe?

Good point. I'll use the max buffer size macro.


>> +void ieee80211_start_rx_ba_session_offl(struct ieee80211_vif *vif,
>> +                                     const u8 *addr, u8 dialog_token,
>> +                                     u16 timeout, u16 start_seq_num,
>> +                                     u16 tid, u16 buf_size)
>> +{
>> +     struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
>> +     struct ieee80211_local *local = sdata->local;
>> +     struct ieee80211_rx_agg *rx_agg;
>> +     struct sk_buff *skb = dev_alloc_skb(0);
>> +
>> +     if (unlikely(!skb))
>> +             return;
>> +
>> +     rx_agg = (struct ieee80211_rx_agg *) &skb->cb;
>> +     memcpy(&rx_agg->addr, addr, ETH_ALEN);
>> +     rx_agg->dialog_token = dialog_token;
>> +     rx_agg->timeout = timeout;
>> +     rx_agg->start_seq_num = start_seq_num;
>> +     rx_agg->ba_policy = 1;
>> +     rx_agg->tid = tid;
>> +     rx_agg->buf_size = buf_size;
>> +
>> +     skb->pkt_type = IEEE80211_SDATA_QUEUE_RX_AGG_START;
>> +     skb_queue_tail(&sdata->skb_queue, skb);
>> +     ieee80211_queue_work(&local->hw, &sdata->work);
>
> This seems problematic, since packets might be received immediately.
>
> On the teardown path it should probably also be invalidated immediately,
> no?
>
> Then again, we have the same problem already? Hmm.

Yeah. You have to go through the iface worker so you can race with
data frames coming in in ieee80211_rx() either way.

You'd have to make ampdu_action() atomic, replace sta->ampdu_mlme.mtx
with a spinlock and move some del_timer_sync() around - at least
that's what I've found after taking a quick look.


Michał
