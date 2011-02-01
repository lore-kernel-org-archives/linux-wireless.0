Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:39215 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab1BAU6i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 15:58:38 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 01/18] wl1251: fix queue stopping/waking for TX path
References: <4D45A589.9040905@davizone.at> <4D45B7B6.4090102@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 01 Feb 2011 22:58:35 +0200
In-Reply-To: <4D45B7B6.4090102@davizone.at> (David Gnedt's message of "Sun\, 30 Jan 2011 20\:10\:46 +0100")
Message-ID: <87oc6vcw04.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> The queue stopping/waking functionality was broken in a way that could
> cause the TX to stall if the right circumstances are met.
>
> The problem was caused by tx_work, which is scheduled on each TX operation.
> If the firmware buffer is full, tx_work does nothing. In combinition with
> stopped queues or non-continues transfers, tx_work is never scheduled again.
> Moreover the low watermark introduced by
> 9df86e2e702c6d5547aced7f241addd2d698bb11 never takes effect because of some
> old code.
>
> Solve this by scheduling tx_work every time tx_queue is non-empty and
> firmware buffer is freed on tx_complete.
>
> This also solves a possible but unlikely case: If less frames than the high
> watermark are queued, but more than firmware buffer can hold. This results
> in queues staying awake but the only scheduled tx_work doesn't transfer all
> frames, so the remaining frames are stuck in the queue until more frames
> get queued and tx_work is scheduled again.

This looks good. Unfortunately I wasn't able to test it yet, but if it
solves your issue I think it's best to get it in now. 

Thanks for fixing this.

> Signed-off-by: David Gnedt <david.gnedt@davizone.at>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
