Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53451 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab2B1H5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 02:57:09 -0500
Message-ID: <4F4C88D0.9050402@qca.qualcomm.com> (sfid-20120228_085713_678795_445F3639)
Date: Tue, 28 Feb 2012 09:57:04 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix random system lockup
References: <1328772432-21074-1-git-send-email-vthiagar@qca.qualcomm.com> <4F4B9085.6080603@qca.qualcomm.com> <20120228052811.GC2892@vasanth-laptop>
In-Reply-To: <20120228052811.GC2892@vasanth-laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/2012 07:28 AM, Vasanthakumar Thiagarajan wrote:
> On Mon, Feb 27, 2012 at 04:17:41PM +0200, Kalle Valo wrote:
>> On 02/09/2012 09:27 AM, Vasanthakumar Thiagarajan wrote:
>>> From: Raja Mani <rmani@qca.qualcomm.com>
>>>
>>> The commit "ath6kl: Use a mutex_lock to avoid
>>> race in diabling and handling irq" introduces a
>>> state where ath6kl_sdio_irq_handler() would be waiting
>>> to claim the sdio function for receive indefinitely
>>> when things happen in the following order.
>>>
>>> ath6kl_sdio_irq_handler()
>>> 	- aquires mtx_irq
>>> 	- sdio_release_host()
>>> 					ath6kl_sdio_irq_disable()
>>> 						- sdio_claim_host()
>>> 						- sleep on mtx_irq
>>> 	ath6kl_hif_intr_bh_handler()
>>> 		- (indefinitely) wait for the sdio
>>> 		  function to be released to exclusively claim
>>> 		  it again for receive operation.
>>>
>>> Fix this by replacing the mtx_irq with an atomic
>>> variable and a wait_queue.
>>>
>>> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
>>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
>>
>> I would really like to avoid using atomic variable if at all possible. I
>> was trying to think other options and what if we take in
>> ath6kl_sdio_irq_disable() mtx_irq before calling sdio_claim_host().
>> Wouldn't that solve the deadlock?
> 
> Ok, the goal is to process any pending interrupts before disabling the interrupt.
> Taking mutex before sdio_claim_host() would have a deadlock condition like the following
> 
> sdio_claim_host()			ath6kl_sdio_irq_disable()
> 						- Acquire mtx_irq
> ath6kl_sdio_irq_handler() 			- Trying to claim sdio func() 
>   - waiting on mtx_irq

Yeah, that's true. I really would not want to apply this patch but I
guess there is no other option :(

Kalle
