Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44784 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732259AbeGKAQI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 20:16:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 10 Jul 2018 17:14:33 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <153115422491.7447.12479559048433925372.stgit@alrua-x1>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
 <153115422491.7447.12479559048433925372.stgit@alrua-x1>
Message-ID: <361a221dd15e44028fd35440df657a3d@codeaurora.org> (sfid-20180711_021438_222135_F5C7A59B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-09 09:37, Toke Høiland-Jørgensen wrote:
[...]
> +/**
> + * ieee80211_schedule_txq - add txq to scheduling loop
> + *
> + * @hw: pointer as obtained from ieee80211_alloc_hw()
> + * @txq: pointer obtained from station or virtual interface
> + * @reset_seqno: Whether to reset the internal scheduling sequence 
> number,
> + *               allowing this txq to appear again in the current 
> scheduling
> + *               round (see doc for ieee80211_next_txq()).
> + *
> + * Returns %true if the txq was actually added to the scheduling,
> + * %false otherwise.
> + */
> +bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
> +			    struct ieee80211_txq *txq,
> +			    bool reset_seqno);
> +
> +/**
> + * ieee80211_next_txq - get next tx queue to pull packets from
> + *
> + * @hw: pointer as obtained from ieee80211_alloc_hw()
> + * @ac: filter returned txqs with this AC number. Pass -1 for no 
> filtering.
> + * @inc_seqno: Whether to increase the scheduling sequence number. 
> Setting this
> + *             to true signifies the start of a new scheduling round. 
> Each TXQ
> + *             will only be returned exactly once in each round 
> (unless its
> + *             sequence number is explicitly reset when calling
> + *             ieee80211_schedule_txq()).
> + *
Toke,

Seems like seqno is internal to mac80211 and meant for active_txq list 
manipulation.
If so, why would drivers have to worry about increment or resetting 
seqno? IMHO to
avoid over serving same txq, two lists (activeq and waitq) can be used 
and always
add new txq into waitq list. So that driver will not worry about 
mac80211 txq
manipulation. Please correct me If Im wrong.

ieee80211_schedule_txq
    - if schedule_order empty, add txq into waitq list tail.

ieee80211_next_txq
    - if activeq empty,
         - move waitq list into activeq

    - if activeq not empty
         - fetch appropriate txq from activeq
         - remove txq from activeq list.

    - If txq found, return txq else return NULL

-Rajkumar
