Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:44506 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbeADRkm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 12:40:42 -0500
Received: by mail-pl0-f66.google.com with SMTP id n13so1412252plp.11
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jan 2018 09:40:42 -0800 (PST)
Date: Thu, 4 Jan 2018 09:40:39 -0800
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Colin King <colin.king@canonical.com>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] wcn36xx: fix incorrect assignment to
 msg_body.min_ch_time
Message-ID: <20180104174039.GL12655@minitux> (sfid-20180104_184114_889955_8641273C)
References: <20171229090732.14928-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171229090732.14928-1-colin.king@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri 29 Dec 01:07 PST 2017, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The second assignment to msg_body.min_ch_time is incorrect, it
> should actually be to msg_body.max_ch_time.
> 
> Thanks to Bjorn Andersson for identifying the correct way to fix
> this as my original fix was incorrect.
> 
> Detected by CoverityScan, CID#1463042 ("Unused Value")
> 
> Fixes: 2f3bef4b247e ("wcn36xx: Add hardware scan offload support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks Colin,

Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 2914618a0335..2a4871ca9c72 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -626,7 +626,7 @@ int wcn36xx_smd_start_hw_scan(struct wcn36xx *wcn, struct ieee80211_vif *vif,
>  
>  	msg_body.scan_type = WCN36XX_HAL_SCAN_TYPE_ACTIVE;
>  	msg_body.min_ch_time = 30;
> -	msg_body.min_ch_time = 100;
> +	msg_body.max_ch_time = 100;
>  	msg_body.scan_hidden = 1;
>  	memcpy(msg_body.mac, vif->addr, ETH_ALEN);
>  	msg_body.p2p_search = vif->p2p;
> -- 
> 2.14.1
> 
