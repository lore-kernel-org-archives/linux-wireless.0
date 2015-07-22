Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58021 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbbGVGQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 02:16:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Marty Faltesek <mfaltesek@google.com>
Cc: linux-wireless@vger.kernel.org, dgentry@google.com,
	apenwarr@google.com
Subject: Re: [PATCH] ath10k: Improve performance by reducing tx_lock contention.
References: <1437527130-15232-1-git-send-email-mfaltesek@google.com>
Date: Wed, 22 Jul 2015 09:16:49 +0300
In-Reply-To: <1437527130-15232-1-git-send-email-mfaltesek@google.com> (Marty
	Faltesek's message of "Tue, 21 Jul 2015 21:05:30 -0400")
Message-ID: <87wpxslnse.fsf@kamboji.qca.qualcomm.com> (sfid-20150722_081702_748315_21210B2B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marty Faltesek <mfaltesek@google.com> writes:

> From: Qi Zhou <qizhou@google.com>
>
> During tx completion, tx_lock is held for longer than required, preventing
> efficient refill of htt->pending_tx. Refactor the code so that only MSDU
> related operations are protected by the lock.
>
> Improves downstream performance on a 3x3 client from 495 to 580 Mbps.

It would be good to mention the actual platform/CPU as I guess this
improvement is platform specific?

> Signed-off-by: Denton Gentry <dgentry@google.com>
> Signed-off-by: Avery Pennarun <apenwarr@google.com>
> [mfaltesek@google.com: removed conflicting code for tracking msdu_ids.]
> Signed-off-by: Marty Faltesek <mfaltesek@google.com>
>
> Change-Id: Ia0fe8b037033c3335b5632b7276c3b0e33e738d4

No gerrit tags, please.

So that patchwork finds the patch please send it to the ath10k list and
cc linux-wireless as documented here:

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/sources#submitting_patches

-- 
Kalle Valo
