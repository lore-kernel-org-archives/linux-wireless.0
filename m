Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37324 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752511AbeGDPNt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 11:13:49 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] libertas: fix suspend and resume for SDIO connected cards
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180627185845.31799-1-daniel@zonque.org>
References: <20180627185845.31799-1-daniel@zonque.org>
To: Daniel Mack <daniel@zonque.org>
Cc: ulf.hansson@linaro.org, chris@printf.net,
        linux-mmc@vger.kernel.org, libertas-dev@lists.infradead.org,
        linux-wireless@vger.kernel.org, Daniel Mack <daniel@zonque.org>
Message-Id: <20180704151349.52E3C6028D@smtp.codeaurora.org> (sfid-20180704_171653_111846_7F6CCCCA)
Date: Wed,  4 Jul 2018 15:13:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> wrote:

> Prior to commit 573185cc7e64 ("mmc: core: Invoke sdio func driver's PM
> callbacks from the sdio bus"), the MMC core used to call into the power
> management functions of SDIO clients itself and removed the card if the
> return code was non-zero. IOW, the mmc handled errors gracefully and didn't
> upchain them to the pm core.
> 
> Since this change, the mmc core relies on generic power management
> functions which treat all errors as a reason to cancel the suspend
> immediately. This causes suspend attempts to fail when the libertas
> driver is loaded.
> 
> To fix this, power down the card explicitly in if_sdio_suspend() when we
> know we're about to lose power and return success. Also set a flag in these
> cases, and power up the card again in if_sdio_resume().
> 
> Fixes: 573185cc7e64 ("mmc: core: Invoke sdio func driver's PM callbacks from the sdio bus")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> Reviewed-by: Chris Ball <chris@printf.net>
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Patch applied to wireless-drivers-next.git, thanks.

7444a8092906 libertas: fix suspend and resume for SDIO connected cards

-- 
https://patchwork.kernel.org/patch/10492407/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
