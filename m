Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58530 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbeC2I5v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 04:57:51 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: Fix firmware crash due to corrupted buffer address
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180315113133.28791-1-rfried@codeaurora.org>
References: <20180315113133.28791-1-rfried@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>,
        Ramon Fried <rfried@codeaurora.org>
Message-Id: <20180329085750.BE73F602BA@smtp.codeaurora.org> (sfid-20180329_105754_884018_85414A04)
Date: Thu, 29 Mar 2018 08:57:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <rfried@codeaurora.org> wrote:

> wcn36xx_start_tx function retrieves the buffer descriptor from the
> channel control queue to start filling tx buffer information. However,
> nothing prevents this same buffer to be concurrently accessed in a
> concurent tx call, leading to potential buffer coruption and firmware
> crash (observed during iperf test). The channel control queue should
> only be accessed and updated with the channel lock.
> 
> Fix this issue by using a local buffer descriptor which will be copied
> in the thread-safe wcn36xx_dxe_tx_frame.
> 
> Note that buffer descriptor size is few bytes so the introduced copy
> overhead is insignificant. Moreover, this allows to keep the locked
> section minimal.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

e5f9908155c9 wcn36xx: Fix firmware crash due to corrupted buffer address

-- 
https://patchwork.kernel.org/patch/10284261/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
