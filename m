Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31770 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab2B0ORq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 09:17:46 -0500
Message-ID: <4F4B9085.6080603@qca.qualcomm.com> (sfid-20120227_151749_980862_180BAAB8)
Date: Mon, 27 Feb 2012 16:17:41 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix random system lockup
References: <1328772432-21074-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1328772432-21074-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2012 09:27 AM, Vasanthakumar Thiagarajan wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> The commit "ath6kl: Use a mutex_lock to avoid
> race in diabling and handling irq" introduces a
> state where ath6kl_sdio_irq_handler() would be waiting
> to claim the sdio function for receive indefinitely
> when things happen in the following order.
> 
> ath6kl_sdio_irq_handler()
> 	- aquires mtx_irq
> 	- sdio_release_host()
> 					ath6kl_sdio_irq_disable()
> 						- sdio_claim_host()
> 						- sleep on mtx_irq
> 	ath6kl_hif_intr_bh_handler()
> 		- (indefinitely) wait for the sdio
> 		  function to be released to exclusively claim
> 		  it again for receive operation.
> 
> Fix this by replacing the mtx_irq with an atomic
> variable and a wait_queue.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

I would really like to avoid using atomic variable if at all possible. I
was trying to think other options and what if we take in
ath6kl_sdio_irq_disable() mtx_irq before calling sdio_claim_host().
Wouldn't that solve the deadlock?

Kalle
