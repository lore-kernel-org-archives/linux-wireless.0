Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbbJQE22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 00:28:28 -0400
Date: Fri, 16 Oct 2015 21:28:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: Mike Rapoport <mike.rapoport@gmail.com>,
	devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH V2] staging: wilc1000: wilc_msgqueue.c : remove the goto
 ERRORHANDER
Message-ID: <20151017042826.GB11306@kroah.com> (sfid-20151017_062848_131860_44674C5B)
References: <1444802143-6298-1-git-send-email-tony.cho@atmel.com>
 <20151014083221.GA25667@zed.strato>
 <561E17E7.2080407@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <561E17E7.2080407@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 14, 2015 at 05:52:55PM +0900, Tony Cho wrote:
> 
> 
> On 2015년 10월 14일 17:32, Mike Rapoport wrote:
> >On Wed, Oct 14, 2015 at 02:55:43PM +0900, Tony Cho wrote:
> >>From: Leo Kim <leo.kim@atmel.com>
> >>
> >>This patch removes goto ERRORHANDER and the result variable in wilc_mq_send.
> >>Then, the error type is directly returned. If normal operation, freeing memory
> >>is not needed in this function.
> >>If an error occurs, returns an error after releasing the spin lock.
> >>
> >>Signed-off-by: Leo Kim <leo.kim@atmel.com>
> >>Signed-off-by: Tony Cho <tony.cho@atmel.com>
> >>---
> >>V2: add releasing spinlock before returnig an error when an error happens.
> >>---
> >>  drivers/staging/wilc1000/wilc_msgqueue.c | 28 ++++++++++++----------------
> >>  1 file changed, 12 insertions(+), 16 deletions(-)
> >>
> >>diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
> >>index b13809a..4dfd476 100644
> >>--- a/drivers/staging/wilc1000/wilc_msgqueue.c
> >>+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
> >>@@ -56,35 +56,38 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
> >>  int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
> >>  			     const void *pvSendBuffer, u32 u32SendBufferSize)
> >>  {
> >>-	int result = 0;
> >>  	unsigned long flags;
> >>  	Message *pstrMessage = NULL;
> >>  	if ((!pHandle) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
> >>  		PRINT_ER("pHandle or pvSendBuffer is null\n");
> >>-		result = -EFAULT;
> >>-		goto ERRORHANDLER;
> >>+		return -EFAULT;
> >>  	}
> >>  	if (pHandle->bExiting) {
> >>  		PRINT_ER("pHandle fail\n");
> >>-		result = -EFAULT;
> >>-		goto ERRORHANDLER;
> >>+		return -EFAULT;
> >>  	}
> >>  	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
> >>  	/* construct a new message */
> >>  	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
> >You can make this allocation outisde the spinlock, then there won't be
> >need to release it if the allocation fails.
> >
> >>-	if (!pstrMessage)
> >>+
> >>+	if (!pstrMessage) {
> >>+		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
> >>  		return -ENOMEM;
> >>+	}
> >>+
> >>  	pstrMessage->u32Length = u32SendBufferSize;
> >>  	pstrMessage->pstrNext = NULL;
> >>  	pstrMessage->pvBuffer = kmemdup(pvSendBuffer, u32SendBufferSize,
> >>  					GFP_ATOMIC);
> >>+
> >>  	if (!pstrMessage->pvBuffer) {
> >>-		result = -ENOMEM;
> >>-		goto ERRORHANDLER;
> >>+		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
> >You are still holding pHandle->hSem here. Moreover, all error paths
> >return while still holding pHandle->hSem.
> 
> Can you explain to me what you mean for holding hsem here? Basically, this function cannot release
> 
> the semaphore (of course, this synchronization mechanism will be changed, anyway) if errors happen.
> 
> The thread will do his work when it is released without unexpected situations.
> 
> >I'd suggest, that instead of trying to return immediately, you'd better
> >move error handling code to the end of the function and use goto and
> >several labels to do appropriate cleanups depending on when the error
> >was caught. E.g.
> 
> I don't want to use goto statement as possible as I can. Do you
> concern semaphore uses in this function?

You should use a goto, it will make the error unwinding much easier and
is a very common pattern in Linux kernel code.  It will save you many
lines in this function, please do it that way instead.

thanks,

greg k-h
