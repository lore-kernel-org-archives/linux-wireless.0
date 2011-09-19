Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54907 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1ISGxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 02:53:00 -0400
Message-ID: <4E76E6C8.3080003@qca.qualcomm.com> (sfid-20110919_085307_604991_F09459FC)
Date: Mon, 19 Sep 2011 09:52:56 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Indicate the roaming capability of the firmware
References: <1316167723-2346-1-git-send-email-nataraja@qca.qualcomm.com>
In-Reply-To: <1316167723-2346-1-git-send-email-nataraja@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/16/2011 01:08 PM, Vivek Natarajan wrote:
> Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/init.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
> index b9b13a0..38d7e94 100644
> --- a/drivers/net/wireless/ath/ath6kl/init.c
> +++ b/drivers/net/wireless/ath/ath6kl/init.c
> @@ -1494,6 +1494,8 @@ static int ath6kl_init(struct net_device *dev)
>  	if (!status)
>  		goto ath6kl_init_done;
>  
> +	ar->wdev->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
> +
>  err_htc_stop:
>  	ath6kl_htc_stop(ar->htc_target);
>  err_rxbuf_cleanup:

You have to document what this change means in practise and what issue
it is actually fixing. (firmware/wpas getting out of sync, wpas not
handling roaming after the flag is set etc.)

Also please address Sam's comment.

Kalle
