Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:12600 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaJLR7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Oct 2014 13:59:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"Michal Kazior" <michal.kazior@tieto.com>
Subject: Re: [PATCH v2] ath10k: fix kernel panic while shutting down AP
References: <1412942907-24760-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Sun, 12 Oct 2014 20:59:15 +0300
In-Reply-To: <1412942907-24760-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Fri, 10 Oct 2014 17:38:27 +0530")
Message-ID: <87bnphb24s.fsf@kamboji.qca.qualcomm.com> (sfid-20141012_195935_169696_DACD6B4D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Based on GFP flag given to DMA coherent allocation, the behaviour of
> dma_free_coherent is changed. This behavioural diffrence is noticeable
> in ARM platform. If DMA memory is allocated with GFP_KERNEL, free
> coherent can not be called inside spin lock. This is causing kernel
> crash in ARM platforms. Fix this by changing GFP flag to atomic.
>
> Cc: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, applied.

I modified the commit log a bit to mention the possible commit causing
this:

commit 82d7aba71541a308bc19e869f7cf7423672dee37
Author: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Date:   Fri Oct 10 17:38:27 2014 +0530

    ath10k: fix kernel panic while shutting down AP
    
    Based on GFP flag given to DMA coherent allocation, the behaviour of
    dma_free_coherent is changed. This behavioural diffrence is noticeable
    in ARM platform. If DMA memory is allocated with GFP_KERNEL, free
    coherent can not be called inside spin lock. This is causing kernel
    crash in ARM platforms. Fix this by changing GFP flag to atomic.
    
    This is most likely a regression from commit 64badcb6d645 ("ath10k: workaround
    fw beaconing bug").
    
    Cc: Michal Kazior <michal.kazior@tieto.com>
    Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>


-- 
Kalle Valo
