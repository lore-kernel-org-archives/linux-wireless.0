Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38660 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753746AbeDJPAC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 11:00:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: allocate skbs with GFP_KERNEL during init
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180319063002.24665-1-daniel@zonque.org>
References: <20180319063002.24665-1-daniel@zonque.org>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        Daniel Mack <daniel@zonque.org>
Message-Id: <20180410150001.D691660274@smtp.codeaurora.org> (sfid-20180410_170006_320819_5E8A0660)
Date: Tue, 10 Apr 2018 15:00:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> wrote:

> GFP_ATOMIC should only be used when the allocation is done from atomic
> context. Introduce a new flag to wcn36xx_dxe_fill_skb() and use GFP_KERNEL
> when pre-allocating buffers during init.
> 
> This doesn't fix an issue that was observed in the wild, but it reduces
> the chance of failed allocations under memory pressure.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

5151a673da43 wcn36xx: allocate skbs with GFP_KERNEL during init

-- 
https://patchwork.kernel.org/patch/10291685/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
