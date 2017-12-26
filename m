Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:43337 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750926AbdLZUNP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Dec 2017 15:13:15 -0500
Received: by mail-pl0-f68.google.com with SMTP id z5so18342391plo.10
        for <linux-wireless@vger.kernel.org>; Tue, 26 Dec 2017 12:13:15 -0800 (PST)
Date: Tue, 26 Dec 2017 12:13:12 -0800
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Colin King <colin.king@canonical.com>,
        Loic Poulain <loic.poulain@linaro.org>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] wcn36xx: remove redundant assignment to
 msg_body.min_ch_time
Message-ID: <20171226201312.GA7480@builder> (sfid-20171226_211341_433510_388F117E)
References: <20171219170401.15154-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171219170401.15154-1-colin.king@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue 19 Dec 09:04 PST 2017, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> msg_body.min_ch_time is being assigned twice; remove the redundant
> first assignment.
> 
> Detected by CoverityScan, CID#1463042 ("Unused Value")
> 

Happy to see Coverity working for us :)


This should have had a:

Fixes: 2f3bef4b247e ("wcn36xx: Add hardware scan offload support")

> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 2914618a0335..bab2eca5fcac 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -625,7 +625,6 @@ int wcn36xx_smd_start_hw_scan(struct wcn36xx *wcn, struct ieee80211_vif *vif,
>  	INIT_HAL_MSG(msg_body, WCN36XX_HAL_START_SCAN_OFFLOAD_REQ);
>  
>  	msg_body.scan_type = WCN36XX_HAL_SCAN_TYPE_ACTIVE;
> -	msg_body.min_ch_time = 30;
>  	msg_body.min_ch_time = 100;

But I strongly suspect the second line is supposed to be max_ch_time.

@Loic, do you agree?

Regards,
Bjorn
