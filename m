Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37322 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbbJNKjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 06:39:18 -0400
Received: by wijq8 with SMTP id q8so74881361wij.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 03:39:17 -0700 (PDT)
Date: Wed, 14 Oct 2015 13:39:13 +0300
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH V2] staging: wilc1000: wilc_msgqueue.c : remove the goto
 ERRORHANDER
Message-ID: <20151014103913.GB25667@zed.strato> (sfid-20151014_123922_302345_1A9D498E)
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

If the semaphore should not be released if an error happens, you can
ignore my comments. 
 
> >I'd suggest, that instead of trying to return immediately, you'd better
> >move error handling code to the end of the function and use goto and
> >several labels to do appropriate cleanups depending on when the error
> >was caught. E.g.
> 
> I don't want to use goto statement as possible as I can. Do you concern semaphore uses in this function?
> Thanks for your review,
> Tony.
> 
> >
> >mem_free:
> >	kfree(pstrMessage);
> >release_lock:	
> >	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
> >release_sem:
> >	up(&pHandle->sem);
> >out:
> >	return result;
> >
> >>+		kfree(pstrMessage);
> >>+		return -ENOMEM;
> >>  	}
> >>  	/* add it to the message queue */
> >>@@ -103,14 +106,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
> >>  	up(&pHandle->hSem);
> >>-ERRORHANDLER:
> >>-	/* error occured, free any allocations */
> >>-	if (pstrMessage) {
> >>-		kfree(pstrMessage->pvBuffer);
> >>-		kfree(pstrMessage);
> >>-	}
> >>-
> >>-	return result;
> >>+	return 0;
> >>  }
> >>  /*!
> >>-- 
> >>1.9.1
> >>
> >>_______________________________________________
> >>devel mailing list
> >>devel@linuxdriverproject.org
> >>http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> 
