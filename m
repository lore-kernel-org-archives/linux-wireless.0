Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52596 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753949AbeDSQXi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 12:23:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: use READ_ONCE() to access desc->ctrl
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180410173558.32425-1-daniel@zonque.org>
References: <20180410173558.32425-1-daniel@zonque.org>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        Daniel Mack <daniel@zonque.org>
Message-Id: <20180419162338.01C7360C55@smtp.codeaurora.org> (sfid-20180419_182345_516800_4A7495FD)
Date: Thu, 19 Apr 2018 16:23:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> wrote:

> When accessing shared memory to check for the stat of submitted
> descriptors, make sure to use READ_ONCE(). This will guarantee the
> compiler treats these memory locations as volatile and doesn't apply
> any caching.
> 
> While this doesn't fix any particular problem I ran into, it's best
> practice to do it this way.
> 
> Note that this patch also removes the superflous extra condition check
> in the do-while loop in reap_tx_dxes(), as the loop will break
> instantly anyway in that case.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

9ff6fde86fd2 wcn36xx: use READ_ONCE() to access desc->ctrl

-- 
https://patchwork.kernel.org/patch/10333551/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
