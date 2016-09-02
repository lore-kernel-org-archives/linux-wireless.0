Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:51432 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751660AbcIBJiP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 05:38:15 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: make-wifi-fast@lists.bufferbloat.net,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v5] mac80211: Move reorder-sensitive TX handlers to after
        TXQ dequeue.
References: <20160830131548.6014-1-toke@toke.dk>
        <20160901160312.31540-1-toke@toke.dk>
        <CAKf6xptJrniYA3Q2pYN4DkpKf_30dNJTdHqm+jCM=enDRSQhJQ@mail.gmail.com>
Date: Fri, 02 Sep 2016 11:27:12 +0200
In-Reply-To: <CAKf6xptJrniYA3Q2pYN4DkpKf_30dNJTdHqm+jCM=enDRSQhJQ@mail.gmail.com>
        (Jason Andryuk's message of "Thu, 1 Sep 2016 22:48:50 -0400")
Message-ID: <87mvjq649b.fsf@toke.dk> (sfid-20160902_113818_986841_FBC754F7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> On Thu, Sep 1, 2016 at 12:03 PM, Toke H=C3=B8iland-J=C3=B8rgensen <toke@t=
oke.dk> wrote:
>> @@ -1481,33 +1506,57 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee=
80211_hw *hw,
>>  {
>>         struct ieee80211_local *local =3D hw_to_local(hw);
>>         struct txq_info *txqi =3D container_of(txq, struct txq_info, txq=
);
>> -       struct ieee80211_hdr *hdr;
>>         struct sk_buff *skb =3D NULL;
>>         struct fq *fq =3D &local->fq;
>>         struct fq_tin *tin =3D &txqi->tin;
>> +       struct ieee80211_tx_info *info;
>>
>>         spin_lock_bh(&fq->lock);
>>
>>         if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags))
>>                 goto out;
>>
>> +begin:
>>         skb =3D fq_tin_dequeue(fq, tin, fq_tin_dequeue_func);
>>         if (!skb)
>>                 goto out;
>>
>>         ieee80211_set_skb_vif(skb, txqi);
>>
>> -       hdr =3D (struct ieee80211_hdr *)skb->data;
>> -       if (txq->sta && ieee80211_is_data_qos(hdr->frame_control)) {
>> +       info =3D IEEE80211_SKB_CB(skb);
>> +       if (txq->sta && info->control.flags & IEEE80211_TX_CTRL_FAST_XMI=
T) {
>>                 struct sta_info *sta =3D container_of(txq->sta, struct s=
ta_info,
>>                                                     sta);
>> -               struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
>> +               struct ieee80211_fast_tx *fast_tx;
>>
>> -               hdr->seq_ctrl =3D ieee80211_tx_next_seq(sta, txq->tid);
>> -               if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
>> -                       info->flags |=3D IEEE80211_TX_CTL_AMPDU;
>> -               else
>> -                       info->flags &=3D ~IEEE80211_TX_CTL_AMPDU;
>> +               fast_tx =3D rcu_dereference(sta->fast_tx);
>> +               if (WARN_ON(!fast_tx)) {
>> +                       /* lost the fast_tx pointer while the packet was=
 queued */
>> +                       ieee80211_free_txskb(hw, skb);
>> +                       goto begin;
>> +               }
>> +               ieee80211_xmit_fast_finish(sta->sdata, sta, fast_tx, skb=
, false);
>> +       } else {
>> +               struct ieee80211_tx_data tx =3D { };
>> +
>> +               __skb_queue_head_init(&tx.skbs);
>> +               tx.local =3D local;
>> +               if (txq->sta) {
>> +                       struct sta_info *sta =3D container_of(txq->sta,
>> +                                                           struct sta_i=
nfo,
>> +                                                           sta);
>
> sta is unneeded give the assignment below?

Yeah, you're right. Think that was left over from a previous version.
Thanks for spotting it :)

-Toke
