Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:50840 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaB1KN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 05:13:56 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 0/8] ath10k: performance improvements
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1393485587-16879-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 28 Feb 2014 12:13:51 +0200
In-Reply-To: <1393485587-16879-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 27 Feb 2014 08:19:39 +0100")
Message-ID: <87ppm7bl40.fsf@kamboji.qca.qualcomm.com> (sfid-20140228_111402_490467_815283F3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> These patches aim at reducing host CPU load and
> thus improve performance on low-end systems.
>
> In my setup I get a relative improvement of
> 100mbps for both UDP Tx and Rx.
>
>                Tx ----->
> laptop:eth---eth:AP135:ath10k---ath10k:laptop
>                <----- Rx
>
>
> v2:
>  * improve comments/commit messages
>  * fix unbalanced locking
>  * fix var naming (s/err/ret)
>  * fix sparse/checkpatch/buildbot warnings
>  * remove code that didn't belong here
>  * split batch tx/rx into 2 patches
>    (+ath10k: reduce htt tx/rx spinlock overhead)
>
> v3:
>  * just a resend (due to my mail-server issues the
>    other day not all of the v2 patches had been
>    sent out)
>
> Michal Kazior (8):
>   ath10k: remove DMA mapping wrappers
>   ath10k: remove is_aborted from skb_cb
>   ath10k: replace send_head() with tx_sg()
>   ath10k: bypass htc for htt tx path
>   ath10k: batch htt tx/rx completions
>   ath10k: reduce htt tx/rx spinlock overhead
>   ath10k: remove pci completion list
>   ath10k: minimize coherent dma accesses

Thanks, all eight patches applied.

-- 
Kalle Valo
