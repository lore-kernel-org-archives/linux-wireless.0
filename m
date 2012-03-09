Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41828 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2CIJIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 04:08:13 -0500
Received: by pbcun15 with SMTP id un15so2347434pbc.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 01:08:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1331139615.3519.18.camel@jlt3.sipsolutions.net>
References: <1331137230-12430-1-git-send-email-helmut.schaa@googlemail.com>
	<1331139615.3519.18.camel@jlt3.sipsolutions.net>
Date: Fri, 9 Mar 2012 10:08:13 +0100
Message-ID: <CAGXE3d_fMnjyHJ7zkz53Dvv0eL+MKC6sDJwpvOQQrK+R=f2iBw@mail.gmail.com> (sfid-20120309_100822_535649_60B1BE27)
Subject: Re: [PATCH] mac80211: Limit TID buffering during BA session setup/teardown
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 7, 2012 at 6:00 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2012-03-07 at 17:20 +0100, Helmut Schaa wrote:
>> While setting up or tearing down a BA session mac80211 is buffering
>> pending frames for the according TID. However, there's currently no
>> limit on how many frames are buffered possibly leading to an out-of-
>> memory situation. This can happen on systems with little memory when
>> the CPU is fully loaded since the BA session work is executed in
>> process context while frames can still come via softirq.
>>
>> Apply a limitation to the TIDs pending queue to avoid consuming
>> too much memory in this situation.
>>
>> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>> ---
>>  net/mac80211/tx.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>> index 1be0ca2..4b07828 100644
>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> @@ -1060,6 +1060,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
>>  {
>>       bool queued = false;
>>       bool reset_agg_timer = false;
>> +     struct sk_buff *purge_skb = NULL;
>>
>>       if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
>>               info->flags |= IEEE80211_TX_CTL_AMPDU;
>> @@ -1101,8 +1102,13 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
>>                       info->control.vif = &tx->sdata->vif;
>>                       info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
>>                       __skb_queue_tail(&tid_tx->pending, skb);
>> +                     if (skb_queue_len(&tid_tx->pending) > STA_MAX_TX_BUFFER)
>> +                             purge_skb = __skb_dequeue(&tid_tx->pending);
>>               }
>>               spin_unlock(&tx->sta->lock);
>> +
>> +             if (purge_skb)
>> +                     dev_kfree_skb(purge_skb);
>
> Shouldn't we stop the netdev queues or something instead?

As discussed privately (because I was unable to use the mail client on
my mobile phone
correctly :) ) it would be possible to stop the netdev queues instead
of dropping frames for
this STA/TID here.

But since the situation can also be triggered externally (by delaying
the ADDBA response
for example) I think stopping the netdev queues in this case is
problematic as it will affect
all STAs/TIDs and not only the one.

Hence, I still think the taken approach is reasonable.

Helmut
