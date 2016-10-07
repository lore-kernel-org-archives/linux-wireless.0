Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38969 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754556AbcJGLnP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Oct 2016 07:43:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v5] ath9k: Switch to using mac80211 intermediate software queues.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160902140030.11798-1-toke@toke.dk>
References: <20160902140030.11798-1-toke@toke.dk>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tim Shepard <shep@alum.mit.edu>, Felix Fietkau <nbd@nbd.name>
Message-Id: <20161007114314.E5CEE61AF6@smtp.codeaurora.org> (sfid-20161007_134319_416294_13616422)
Date: Fri,  7 Oct 2016 11:43:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke Høiland-Jørgensen wrote:
> This switches ath9k over to using the mac80211 intermediate software
> queueing mechanism for data packets. It removes the queueing inside the
> driver, except for the retry queue, and instead pulls from mac80211 when
> a packet is needed. The retry queue is used to store a packet that was
> pulled but can't be sent immediately.
> 
> The old code path in ath_tx_start that would queue packets has been
> removed completely, as has the qlen limit tunables (since there's no
> longer a queue in the driver to limit).
> 
> Based on Tim's original patch set, but reworked quite thoroughly.
> 
> Cc: Tim Shepard <shep@alum.mit.edu>
> Cc: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Depends on:

bb42f2d13ffc mac80211: Move reorder-sensitive TX handlers to after TXQ dequeue

Patch set to Awaiting Upstream.

-- 
https://patchwork.kernel.org/patch/9311037/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
