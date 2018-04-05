Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:45426 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751251AbeDEUxH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 16:53:07 -0400
Received: by mail-pl0-f66.google.com with SMTP id v18-v6so18957809ply.12
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2018 13:53:06 -0700 (PDT)
Date: Thu, 5 Apr 2018 13:53:36 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Loic Poulain <loic.poulain@linaro.org>
Cc: kvalo@codeaurora.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH] wcn36xx: Add missing fall through comment in smd.c
Message-ID: <20180405205336.GJ453@tuxbook-pro> (sfid-20180405_225310_801499_0D2628DC)
References: <1522929109-23271-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522929109-23271-1-git-send-email-loic.poulain@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu 05 Apr 04:51 PDT 2018, Loic Poulain wrote:

> This prevents GCC warning.
> 

Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 7cc2928..7b79e0b 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -2135,6 +2135,7 @@ static int wcn36xx_smd_hw_scan_ind(struct wcn36xx *wcn, void *buf, size_t len)
>  	switch (rsp->type) {
>  	case WCN36XX_HAL_SCAN_IND_FAILED:
>  		scan_info.aborted = true;
> +		/* fall through */
>  	case WCN36XX_HAL_SCAN_IND_COMPLETED:
>  		mutex_lock(&wcn->scan_lock);
>  		wcn->scan_req = NULL;
> -- 
> 2.7.4
> 
> 
> _______________________________________________
> wcn36xx mailing list
> wcn36xx@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/wcn36xx
