Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12557 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab2B1F2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 00:28:11 -0500
Date: Tue, 28 Feb 2012 10:58:14 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix random system lockup
Message-ID: <20120228052811.GC2892@vasanth-laptop> (sfid-20120228_062815_243846_CDADA282)
References: <1328772432-21074-1-git-send-email-vthiagar@qca.qualcomm.com>
 <4F4B9085.6080603@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4F4B9085.6080603@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 04:17:41PM +0200, Kalle Valo wrote:
> On 02/09/2012 09:27 AM, Vasanthakumar Thiagarajan wrote:
> > From: Raja Mani <rmani@qca.qualcomm.com>
> > 
> > The commit "ath6kl: Use a mutex_lock to avoid
> > race in diabling and handling irq" introduces a
> > state where ath6kl_sdio_irq_handler() would be waiting
> > to claim the sdio function for receive indefinitely
> > when things happen in the following order.
> > 
> > ath6kl_sdio_irq_handler()
> > 	- aquires mtx_irq
> > 	- sdio_release_host()
> > 					ath6kl_sdio_irq_disable()
> > 						- sdio_claim_host()
> > 						- sleep on mtx_irq
> > 	ath6kl_hif_intr_bh_handler()
> > 		- (indefinitely) wait for the sdio
> > 		  function to be released to exclusively claim
> > 		  it again for receive operation.
> > 
> > Fix this by replacing the mtx_irq with an atomic
> > variable and a wait_queue.
> > 
> > Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
> > Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> 
> I would really like to avoid using atomic variable if at all possible. I
> was trying to think other options and what if we take in
> ath6kl_sdio_irq_disable() mtx_irq before calling sdio_claim_host().
> Wouldn't that solve the deadlock?

Ok, the goal is to process any pending interrupts before disabling the interrupt.
Taking mutex before sdio_claim_host() would have a deadlock condition like the following

sdio_claim_host()			ath6kl_sdio_irq_disable()
						- Acquire mtx_irq
ath6kl_sdio_irq_handler() 			- Trying to claim sdio func() 
  - waiting on mtx_irq


Vasanth	
