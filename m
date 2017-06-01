Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35848 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751247AbdFAJsZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 05:48:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: cw1200: Fix a sleep-in-atomic bug in cw1200_tx_confirm_cb and
 cw1200_cqm_bssloss_sm
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1496284574-11056-1-git-send-email-baijiaju1990@163.com>
References: <1496284574-11056-1-git-send-email-baijiaju1990@163.com>
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: pizza@shaftnet.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@163.com>
Message-Id: <20170601094825.02EF96074D@smtp.codeaurora.org> (sfid-20170601_114857_883039_FCAC620A)
Date: Thu,  1 Jun 2017 09:48:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jia-Ju Bai <baijiaju1990@163.com> wrote:

> The driver may sleep under a spin lock, and the function call path is:
> cw1200_tx_confirm_cb (acquire the lock by spin_lock)
>   __cw1200_cqm_bssloss_sm
>     cancel_work_sync --> may sleep
> 
> cw1200_cqm_bssloss_sm
>   __cw1200_cqm_bssloss_sm
>     cancel_work_sync --> may sleep
> 
> To fix it, the lock is released before cancel_work_sync, and the lock 
> is acquired again after this function.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>

I assume that you haven't tested this on a real device and only compile tested.
You should mention that in the commit log.

Releasing a lock held by calling function is evil. Did you do any lock analysis
or are you just blindly releasing locks to fix a warning in your tool?

Also I would like to have an ack from a reviewer before I can take patches like
this.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9758613/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
