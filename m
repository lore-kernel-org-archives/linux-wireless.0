Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47266 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbeIUDOu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 23:14:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 20 Sep 2018 14:29:19 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>
Subject: Re: [PATCH RFC v4 0/4] Move TXQ scheduling into mac80211
In-Reply-To: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
Message-ID: <6f97d6300d514c0b6577c9c9376b98a8@codeaurora.org> (sfid-20180920_232922_845410_241C57AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-16 10:42, Toke Høiland-Jørgensen wrote:
> Another update, addressing most of the concerns raised in the last 
> round:
> 
> - Added schedule_start()/end() functions that adds locking around the
>   whole scheduling operation, which means we can get rid of the 'first'
>   parameter to ieee80211_next_txq().
> 
Toke,

Wouldn't this start()/end() APIs cause deadlock if mac80211 tries to 
acquire
active_txq_lock[ac] again? Or am I missing?

schedule_start()
while (next_txq()) {
   push_txq -> tx_dequeue()
   return_txq()
}
schedule_end()

tx_dequeue()
  ieee80211_free_txskb
   -> ieee80211_report_used_skb
    -> ieee80211_tdls_td_tx_handle
     -> ieee80211_subif_start_xmit
     -> __ieee80211_subif_start_xmit
       -> ieee80211_xmit_fast
         -> ieee80211_queue_skb
          -> schedule_and_wake_txq

-Rajkumar
