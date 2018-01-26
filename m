Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47894 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753739AbeAZQNF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 11:13:05 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: zajec5@gmail.com, hauke@hauke-m.de, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcma: Replace mdelay with usleep_range in bcma_pmu_resources_init
References: <1516958011-303-1-git-send-email-baijiaju1990@gmail.com>
Date: Fri, 26 Jan 2018 18:13:01 +0200
In-Reply-To: <1516958011-303-1-git-send-email-baijiaju1990@gmail.com> (Jia-Ju
        Bai's message of "Fri, 26 Jan 2018 17:13:31 +0800")
Message-ID: <87y3kkr436.fsf@purkki.adurom.net> (sfid-20180126_171325_534759_AAAF836E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jia-Ju Bai <baijiaju1990@gmail.com> writes:

> After checking all possible call chains to bcma_pmu_resources_init() here,
> my tool finds that this function is never called in atomic context,
> namely never in an interrupt handler or holding a spinlock.
> Thus mdelay can be replaced with usleep_range to avoid busy wait.
>
> This is found by a static analysis tool named DCNS written by myself.
>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/bcma/driver_chipcommon_pmu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
> index f1eb4d3..478948c 100644
> --- a/drivers/bcma/driver_chipcommon_pmu.c
> +++ b/drivers/bcma/driver_chipcommon_pmu.c
> @@ -203,7 +203,7 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
>  	 * Add some delay; allow resources to come up and settle.
>  	 * Delay is required for SoC (early init).
>  	 */
> -	mdelay(2);
> +	usleep_range(1500, 2000);

I would like to have an ack from someone familiar with bcma before I
apply this.

-- 
Kalle Valo
