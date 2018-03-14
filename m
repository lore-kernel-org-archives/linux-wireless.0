Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38176 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751155AbeCNJ41 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 05:56:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: Protect queue draining by rcu_read_lock()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180202103645.12215-1-toke@toke.dk>
References: <20180202103645.12215-1-toke@toke.dk>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        stable@vger.kernel.org
Message-Id: <20180314095626.9E35360592@smtp.codeaurora.org> (sfid-20180314_105630_133517_EF9DEA91)
Date: Wed, 14 Mar 2018 09:56:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke Høiland-Jørgensen wrote:

> When ath9k was switched over to use the mac80211 intermediate queues,
> node cleanup now drains the mac80211 queues. However, this call path is
> not protected by rcu_read_lock() as it was previously entirely internal
> to the driver which uses its own locking.
> 
> This leads to a possible rcu_dereference() without holding
> rcu_read_lock(); but only if a station is cleaned up while having
> packets queued on the TXQ. Fix this by adding the rcu_read_lock() to the
> caller in ath9k.
> 
> Fixes: 50f08edf9809 ("ath9k: Switch to using mac80211 intermediate software queues.")
> Cc: stable@vger.kernel.org
> Reported-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

182b19171098 ath9k: Protect queue draining by rcu_read_lock()

-- 
https://patchwork.kernel.org/patch/10196453/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
