Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21085 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab1EXGUe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 02:20:34 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 23:20:03 -0700
Date: Tue, 24 May 2011 11:50:07 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: wake up chip before initializing PAPRD table
Message-ID: <20110524061955.GA5175@ath9k-test> (sfid-20110524_082037_455875_09CF10B1)
References: <1306213263-4028-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1306213263-4028-1-git-send-email-mshajakhan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 24, 2011 at 10:31:03AM +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> in PAPRD table initialization path we have register read. so make sure
> that the chip is awake. currently PAPRD is disabled.
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index a198ee3..af8aa9e 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -394,6 +394,8 @@ void ath_paprd_calibrate(struct work_struct *work)
>  	if (!caldata)
>  		return;
>  
> +	ath9k_ps_wakeup(sc);
> +
>  	if (ar9003_paprd_init_table(ah) < 0)
>  		return;
Have you tested power save with this patch? ps_restore is missing here...
>  
> @@ -411,7 +413,6 @@ void ath_paprd_calibrate(struct work_struct *work)
>  	memcpy(hdr->addr2, hw->wiphy->perm_addr, ETH_ALEN);
>  	memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
>  
> -	ath9k_ps_wakeup(sc);
>  	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
>  		if (!(common->tx_chainmask & BIT(chain)))
>  			continue;
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
