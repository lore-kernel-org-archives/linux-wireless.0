Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:52599 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751225AbdBLPWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Feb 2017 10:22:08 -0500
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH] ath9k: clean up and fix ath_tx_count_airtime
References: <20170212132931.43510-1-nbd@nbd.name>
Date: Sun, 12 Feb 2017 16:22:02 +0100
In-Reply-To: <20170212132931.43510-1-nbd@nbd.name> (Felix Fietkau's message of
        "Sun, 12 Feb 2017 14:29:31 +0100")
Message-ID: <87lgtb5t9h.fsf@alrua-karlstad> (sfid-20170212_162211_939797_FB82A50C)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> ath_tx_count_airtime is doing a lot of unnecessary work:
>
> - Redundant station lookup
> - Redundant rcu_read_lock/unlock
> - Useless memcpy of bf->rates
> - Useless NULL check of bf->bf_mpdu
> - Redundant lookup of the skb tid
>
> Additionally, it tries to look up the mac80211 queue index from the txq,
> which fails if the frame was delivered via the power save queue.
>
> This patch fixes all of these issues by passing down the right set of
> pointers instead of doing extra work
>
> Cc: stable@vger.kernel.org
> Fixes: 63fefa050477 ("ath9k: Introduce airtime fairness scheduling betwee=
n stations")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Not sure if there's anything for stable to do with this; don't think the
airtime fairness code has gone into a release yet? Otherwise:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

-Toke
