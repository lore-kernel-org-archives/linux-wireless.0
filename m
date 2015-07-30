Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:50595 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbbG3N4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 09:56:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: Fix memory alloc failure in qca99x0 during wmi svc rdy event
References: <1437456178-7862-1-git-send-email-rmani@qti.qualcomm.com>
Date: Thu, 30 Jul 2015 16:56:33 +0300
In-Reply-To: <1437456178-7862-1-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Tue, 21 Jul 2015 10:52:57 +0530")
Message-ID: <87zj2d3g1a.fsf@kamboji.qca.qualcomm.com> (sfid-20150730_155646_660125_4A7CD97C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> Host memory required for firmware is allocated while handling
> wmi service ready event. Right now, wmi service ready is handled
> in tasklet context and it calls dma_alloc_coherent() with atomic
> flag (GFP_ATOMIC) to allocate memory in host needed for firmware.
> The problem is, dma_alloc_coherent() with GFP_ATOMIC fails in
> the platform (at least in AP platform) where it has less atomic
> pool memory (< 2mb). QCA99X0 requires around 2 MB of host memory
> for one card, having additional QCA99X0 card in the same platform
> will require similarly amount of memory. So, it's not guaranteed that
> all the platform will have enough atomic memory pool.
>
> Fix this issue, by handling wmi service ready event in workqueue
> context and calling dma_alloc_coherent() with GFP_KERNEL. mac80211 work
> queue will not be ready at the time of handling wmi service ready.
> So, it can't be used to handle wmi service ready. Also, register work
> gets scheduled during insmod in existing ath10k_wq and waits for
> wmi service ready to completed. Both workqueue can't be used for
> this purpose. New auxiliary workqueue is added to handle wmi service
> ready.
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>

Thanks, both patches applied. And I fixed the sparse warning myself.

-- 
Kalle Valo
