Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47441 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaBQPBy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 10:01:54 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT 0/7] ath10k: performance improvements
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 17 Feb 2014 17:01:49 +0200
In-Reply-To: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 17 Feb 2014 10:32:36 +0100")
Message-ID: <87y5193hr6.fsf@kamboji.qca.qualcomm.com> (sfid-20140217_160220_168825_1012C0D6)
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

Nice!

>                Tx ----->
> laptop:eth---eth:AP135:ath10k---ath10k:laptop
>                <----- Rx
>
>
> Michal Kazior (7):
>   ath10k: remove DMA mapping wrappers
>   ath10k: remove is_aborted from skb_cb
>   ath10k: replace send_head() with tx_sg()
>   ath10k: bypass htc for htt tx path
>   ath10k: batch htt tx/rx completions
>   ath10k: remove pci completion list
>   ath10k: minimize coherent dma accesses

I know this is RFC still, but I did some compilation tests and saw
these:

drivers/net/wireless/ath/ath10k/htt_rx.c:274:17: warning: context imbalance in 'ath10k_htt_rx_amsdu_pop' - unexpected unlock
drivers/net/wireless/ath/ath10k/htt_tx.c:436: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/htt_tx.c:493: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/htt_rx.c:1214: WARNING: line over 80 characters

-- 
Kalle Valo
