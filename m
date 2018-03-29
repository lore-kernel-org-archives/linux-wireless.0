Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60372 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbeC2I7H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 04:59:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] wcn36xx: dequeue all pending indicator messages
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180319062754.24464-1-daniel@zonque.org>
References: <20180319062754.24464-1-daniel@zonque.org>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        Daniel Mack <daniel@zonque.org>
Message-Id: <20180329085906.D25A860F8F@smtp.codeaurora.org> (sfid-20180329_105911_008404_EBB35DF9)
Date: Thu, 29 Mar 2018 08:59:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> wrote:

> In case wcn36xx_smd_rsp_process() is called more than once before
> hal_ind_work was dispatched, the messages will end up in hal_ind_queue,
> but wcn36xx_ind_smd_work() will only look at the first message in that
> list.
> 
> Fix this by dequeing the messages from the list in a loop, and only stop
> when it's empty.
> 
> This issue was found during a review of the driver. In my tests, that
> race never actually occured.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

f276ba06e8b2 wcn36xx: dequeue all pending indicator messages

-- 
https://patchwork.kernel.org/patch/10291683/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
