Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38236 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbeIRG1b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 02:27:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 17 Sep 2018 17:57:34 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v4 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <153711973109.9231.7094211814263758096.stgit@alrua-x1.karlstad.toke.dk>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
 <153711973109.9231.7094211814263758096.stgit@alrua-x1.karlstad.toke.dk>
Message-ID: <13400b5f9bdb5e36c6afabd071cc7b0d@codeaurora.org> (sfid-20180918_025738_424858_4AEF4965)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-16 10:42, Toke Høiland-Jørgensen wrote:
> +/**
> + * ieee80211_return_txq - return a TXQ previously acquired by
> ieee80211_next_txq()
> + *
> + * @hw: pointer as obtained from ieee80211_alloc_hw()
> + * @txq: pointer obtained from station or virtual interface
> + *
> + * Should only be called between calls to 
> ieee80211_txq_schedule_start()
> + * and ieee80211_txq_schedule_end().
> + */
> +void ieee80211_return_txq(struct ieee80211_hw *hw, struct 
> ieee80211_txq *txq);
> +
> 
return_txq() should return a bool to inform the driver that whether txq 
is
queued back or not. Otherwise the same txq will be served indefinitely
until txq becomes empty. This problem occurs when the driver is running 
out
of hw descriptors or driver sends only N frames (< backlog_packets).

Also an option to add the node at head or tail would be preferred. If 
return_txq
adds node at head of list, then it is forcing the driver to serve same 
txq until it
becomes empty. Also this will not allow the driver to send N frames from 
each txqs.

> +/**
> + * ieee80211_txq_schedule_start - acquire locks for safe scheduling of 
> an AC
> + *
> + * @hw: pointer as obtained from ieee80211_alloc_hw()
> + * @ac: AC number to acquire locks for
> + *
> + * Acquire locks needed to schedule TXQs from the given AC. Should be 
> called
> + * before ieee80211_next_txq() or ieee80211_schedule_txq().
> + */
Typo error. s/schedule_txq()/return_txq()/.

-Rajkumar
