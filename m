Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64849 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752183AbcKICWi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 21:22:38 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v5] ath9k: Switch to using mac80211 intermediate software queues.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160902140030.11798-1-toke@toke.dk>
References: <20160902140030.11798-1-toke@toke.dk>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
CC: <make-wifi-fast@lists.bufferbloat.net>,
        <linux-wireless@vger.kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tim Shepard <shep@alum.mit.edu>, Felix Fietkau <nbd@nbd.name>
Message-ID: <1cd07522568b40a6a3e2db6170153c74@euamsexm01a.eu.qualcomm.com> (sfid-20161109_032243_450145_407CB2D7)
Date: Wed, 9 Nov 2016 03:22:30 +0100
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

All dependencies have trickled down to ath.git but unfortunately doesn't apply
anymore, so please rebase. Hopefully the last time :)

While at it, could you also add to the commit log some info how awesome this
patch is from user's point of view and how it helps. For example, before and
and after numbers and other results.

error: patch failed: drivers/net/wireless/ath/ath9k/xmit.c:921
error: drivers/net/wireless/ath/ath9k/xmit.c: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9311037/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
