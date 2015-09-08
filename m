Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbbIHEsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 00:48:38 -0400
Date: Mon, 7 Sep 2015 21:48:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: Chaehyun Lim <chaehyun.lim@gmail.com>, johnny.kim@atmel.com,
	rachel.kim@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/5] staging: wilc1000: wilc_msgqueue.c: use kmalloc with
 GFP_ATOMIC
Message-ID: <20150908044837.GA13090@kroah.com> (sfid-20150908_064918_024582_18A454B9)
References: <1441640199-1507-1-git-send-email-chaehyun.lim@gmail.com>
 <1441640199-1507-4-git-send-email-chaehyun.lim@gmail.com>
 <55EE468B.20803@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <55EE468B.20803@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 08, 2015 at 11:23:07AM +0900, Tony Cho wrote:
> 
> 
> On 2015년 09월 08일 00:36, Chaehyun Lim wrote:
> >This patch use kmalloc with GFP_ATOMIC instead of WILC_MALLOC.
> >It is inside the spin lock region.
> >
> >Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> >---
> >  drivers/staging/wilc1000/wilc_msgqueue.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
> >index 76d2e63..41244ce 100644
> >--- a/drivers/staging/wilc1000/wilc_msgqueue.c
> >+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
> >@@ -72,7 +72,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
> >  	WILC_NULLCHECK(s32RetStatus, pstrMessage);
> >  	pstrMessage->u32Length = u32SendBufferSize;
> >  	pstrMessage->pstrNext = NULL;
> >-	pstrMessage->pvBuffer = WILC_MALLOC(u32SendBufferSize);
> >+	pstrMessage->pvBuffer = kmalloc(u32SendBufferSize, GFP_ATOMIC);
> >  	WILC_NULLCHECK(s32RetStatus, pstrMessage->pvBuffer);
> >  	memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);
> 
> I want just to let you know this file will be soon changed.

That doesn't matter, the first one to submit a change goes "first",
everything that comes afterward needs to deal with that.  We never tell
someone that a patch isn't ok just because at some time in the future
something else might change.  That drives away developers and was one of
the primary reasons other open source kernels have failed in the past.

greg k-h
