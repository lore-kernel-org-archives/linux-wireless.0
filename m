Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:34493 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751678AbeAZSrn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 13:47:43 -0500
Subject: Re: [PATCH v2] bcma: Replace mdelay with usleep_range in
 bcma_pmu_resources_init
To: Jia-Ju Bai <baijiaju1990@gmail.com>, kvalo@codeaurora.org,
        zajec5@gmail.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1516984715-9237-1-git-send-email-baijiaju1990@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <26b48669-16b9-1acf-cd22-63cd40ffd913@lwfinger.net> (sfid-20180126_194757_252620_227CF3DF)
Date: Fri, 26 Jan 2018 12:47:41 -0600
MIME-Version: 1.0
In-Reply-To: <1516984715-9237-1-git-send-email-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2018 10:38 AM, Jia-Ju Bai wrote:
> After checking all possible call chains to bcma_pmu_resources_init() here,
> my tool finds that this function is never called in atomic context,
> namely never in an interrupt handler or holding a spinlock.
> Thus mdelay can be replaced with usleep_range to avoid busy wait.
> 
> This is found by a static analysis tool named DCNS written by myself.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
> v2:
> * Use usleep_range(2000, 2500), instead of (1500, 2000) in v1.
> 
> ---
>   drivers/bcma/driver_chipcommon_pmu.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
> index f1eb4d3..478948c 100644
> --- a/drivers/bcma/driver_chipcommon_pmu.c
> +++ b/drivers/bcma/driver_chipcommon_pmu.c
> @@ -203,7 +203,7 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
>   	 * Add some delay; allow resources to come up and settle.
>   	 * Delay is required for SoC (early init).
>   	 */
> -	mdelay(2);
> +	usleep_range(2000, 2500);

I have no means of testing this patch, but it should be OK.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>


>   }
>   
>   /* Disable to allow reading SPROM. Don't know the adventages of enabling it. */
> 
