Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from void.printf.net ([192.34.86.38]:57670 "EHLO void.printf.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752298AbeF0XpW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 19:45:22 -0400
Date: Thu, 28 Jun 2018 00:13:42 +0100
From: Chris Ball <chris@printf.net>
To: Daniel Mack <daniel@zonque.org>
Cc: ulf.hansson@linaro.org, linux-mmc@vger.kernel.org,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] libertas: fix suspend and resume for SDIO connected
        cards
Message-ID: <20180627231342.GA32539@void.printf.net> (sfid-20180628_014526_133536_220B97DE)
References: <20180627185845.31799-1-daniel@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180627185845.31799-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 27, 2018 at 08:58:45PM +0200, Daniel Mack wrote:
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
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Chris Ball <chris@printf.net>

Thanks, looks good.

Reviewed-by: Chris Ball <chris@printf.net>

-- 
Chris Ball   <http://printf.net/>
