Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32940 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752580AbeC1Rqp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 13:46:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 28 Mar 2018 20:46:44 +0300
From: merez@codeaurora.org
To: Colin King <colin.king@canonical.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH][next] wil6210: fix potential null dereference of ndev
 before null check
In-Reply-To: <20180328174027.31551-1-colin.king@canonical.com>
References: <20180328174027.31551-1-colin.king@canonical.com>
Message-ID: <49ef31bc36217349a4801dc2eba4735c@codeaurora.org> (sfid-20180328_194706_735391_90281E31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-28 20:40, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer ndev is being dereferenced before it is being null checked,
> hence there is a potential null pointer deference. Fix this by only
> dereferencing ndev after it has been null checked
> 
> Detected by CoverityScan, CID#1467010 ("Dereference before null check")
> 
> Fixes: e00243fab84b ("wil6210: infrastructure for multiple virtual 
> interfaces")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/ath/wil6210/main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/wil6210/main.c
> b/drivers/net/wireless/ath/wil6210/main.c
> index a4b413e8d55a..82aec6b06d09 100644
> --- a/drivers/net/wireless/ath/wil6210/main.c
> +++ b/drivers/net/wireless/ath/wil6210/main.c
> @@ -391,7 +391,7 @@ static void wil_fw_error_worker(struct work_struct 
> *work)
>  	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
>  						fw_error_worker);
>  	struct net_device *ndev = wil->main_ndev;
> -	struct wireless_dev *wdev = ndev->ieee80211_ptr;
> +	struct wireless_dev *wdev;
> 
>  	wil_dbg_misc(wil, "fw error worker\n");
> 
> @@ -399,6 +399,7 @@ static void wil_fw_error_worker(struct work_struct 
> *work)
>  		wil_info(wil, "No recovery - interface is down\n");
>  		return;
>  	}
> +	wdev = ndev->ieee80211_ptr;
> 
>  	/* increment @recovery_count if less then WIL6210_FW_RECOVERY_TO
>  	 * passed since last recovery attempt

Reviewed-by: Maya Erez <merez@codeaurora.org>

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
