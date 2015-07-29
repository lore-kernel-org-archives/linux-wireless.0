Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20741 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbbG2I2D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 04:28:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marty Faltesek <mfaltesek@google.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<dgentry@google.com>, <apenwarr@google.com>
Subject: Re: [PATCH v2] ath10k: Improve performance by reducing tx_lock contention.
References: <1437597504-25554-1-git-send-email-mfaltesek@google.com>
Date: Wed, 29 Jul 2015 11:27:44 +0300
In-Reply-To: <1437597504-25554-1-git-send-email-mfaltesek@google.com> (Marty
	Faltesek's message of "Wed, 22 Jul 2015 16:38:24 -0400")
Message-ID: <87h9on74hr.fsf@kamboji.qca.qualcomm.com> (sfid-20150729_102924_901524_2CA96109)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marty Faltesek <mfaltesek@google.com> writes:

> From: Qi Zhou <qizhou@google.com>
>
> During tx completion, tx_lock is held for longer than required, preventing
> efficient refill of htt->pending_tx. Refactor the code so that only MSDU
> related operations are protected by the lock.
>
> Improves downstream performance on a dual-core ARM Freescale LS1024A
> (f.k.a. Mindspeed Comcerto 2000) AP with a 3x3 client from 495 to 580 Mbps.
> Other CPU bound multicore systems may also benefit.
>
> Signed-off-by: Denton Gentry <dgentry@google.com>
> Signed-off-by: Avery Pennarun <apenwarr@google.com>
> [mfaltesek@google.com: removed conflicting code for tracking msdu_ids.]
> Signed-off-by: Marty Faltesek <mfaltesek@google.com>

Thanks, applied.

-- 
Kalle Valo
