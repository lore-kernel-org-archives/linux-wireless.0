Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:50403 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752730AbeFZLZn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 07:25:43 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: Re: [PATCH] mac80211: add stop/start logic for software TXQs
In-Reply-To: <1529997415-20551-1-git-send-email-mpubbise@codeaurora.org>
References: <1529997415-20551-1-git-send-email-mpubbise@codeaurora.org>
Date: Tue, 26 Jun 2018 13:25:46 +0200
Message-ID: <878t71n611.fsf@toke.dk> (sfid-20180626_132547_513469_667A84A7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Manikanta Pubbisetty <mpubbise@codeaurora.org> writes:

> We can still invoke netif stop/wake APIs when wake_tx_queue is
> implemented but this could lead to packet drops in network layer;
> adding stop/start logic for software TXQs in mac80211 instead makes
> more sense; the change proposed adds the same in mac80211.

I agree with the approach; having packets queued in mac80211 while the
queues are stopped also means that CoDel can react to them when they are
resumed again.


> +	list_for_each_entry_rcu(sta, &local->sta_list, list) {
> +		if (!atomic_read(&sta->txqs_paused))
> +			continue;
> +
> +		atomic_set(&sta->txqs_paused, 0);

I'm not terribly well-versed in the kernel atomics, but doesn't the
split of read and set kinda defeat the point of using them? Also, as
this is under RCU, why do you need an atomic in the first place?

-Toke
