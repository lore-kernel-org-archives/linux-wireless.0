Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50108 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbcGHO1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 10:27:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] ath9k: Switch to using mac80211 intermediate software queues.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160706193417.13080-1-toke@toke.dk>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
CC: <linux-wireless@vger.kernel.org>,
	<make-wifi-fast@lists.bufferbloat.net>,
	<ath9k-devel@lists.ath9k.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Tim Shepard <shep@alum.mit.edu>, Felix Fietkau <nbd@nbd.name>
Message-ID: <ac5b5bc6532d4fe7ae3198124ecce7fc@euamsexm01a.eu.qualcomm.com> (sfid-20160708_162712_921217_287555D3)
Date: Fri, 8 Jul 2016 16:26:54 +0200
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

Nice work. Because this is such a significant change, and to maximise testing
time, I'm planning to queue this for 4.9 (so I would apply this to ath-next in
3-4 weeks after the merge window closes). But anyone who wants to test this can
use master-pending branch from my ath.git tree (uses wireless-testing as the
baseline). Sounds good?

Testing and review feedback very welcome!

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9216993/

