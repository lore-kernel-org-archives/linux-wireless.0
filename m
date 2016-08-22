Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48724 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756206AbcHVPoB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 11:44:01 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
        Tim Shepard <shep@alum.mit.edu>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v4] ath9k: Switch to using mac80211 intermediate software queues.
References: <20160706193417.13080-1-toke@toke.dk>
        <20160805160346.10545-1-toke@toke.dk>
Date: Mon, 22 Aug 2016 18:43:54 +0300
In-Reply-To: <20160805160346.10545-1-toke@toke.dk> ("Toke \=\?utf-8\?Q\?H\?\=
 \=\?utf-8\?Q\?\=C3\=B8iland-J\=C3\=B8rgensen\=22's\?\=
        message of "Fri, 5 Aug 2016 18:03:46 +0200")
Message-ID: <87mvk44xmt.fsf@purkki.adurom.net> (sfid-20160822_174418_862260_1B85DD00)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke Høiland-Jørgensen <toke@toke.dk> writes:

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
> ---
> Changes since v3 (most due to Felix; thanks!):
>   - Correctly notify mac80211 when there are packets in the retry queue
>     on powersave start/stop.
>   - Get rid of ath_tx_aggr_resume().
>   - Some readability changes and additional WARN_ON/BUG_ON in
>     appropriate places.

This is great work but due to the regressions I'm not sure if this will
be ready for 4.9. To get more testing time I wonder if we should wait
for 4.10? IMHO applying this in the end of the cycle is too risky and we
should try to maximise the time linux-next by applying this just after
-rc1 is released.

Thoughts?

-- 
Kalle Valo
