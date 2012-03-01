Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10311 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085Ab2CAHf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 02:35:58 -0500
Message-ID: <4F4F26D8.1070006@qca.qualcomm.com> (sfid-20120301_083601_989381_D35A017F)
Date: Thu, 1 Mar 2012 09:35:52 +0200
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

Thanks, applied with a minor change due to indentation:

static bool ath6kl_sdio_is_on_irq(struct ath6kl *ar)
{
	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);

	return !atomic_read(&ar_sdio->irq_handling);
}

		ret = wait_event_interruptible(ar_sdio->irq_wq,
				       ath6kl_sdio_is_on_irq(ar));

Kalle
