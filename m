Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:34338 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755145AbdBVTyx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Feb 2017 14:54:53 -0500
Received: by mail-qk0-f177.google.com with SMTP id s186so13198609qkb.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Feb 2017 11:54:53 -0800 (PST)
Subject: Re: [PATCH v2] ath10k: Remove return statement from a void function
To: Marcin Rokicki <marcin.rokicki@tieto.com>,
        ath10k@lists.infradead.org
References: <1487672891-8584-1-git-send-email-marcin.rokicki@tieto.com>
Cc: linux-wireless@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <b7ac6892-4cbd-bd60-382f-5c51e9ae588a@broadcom.com> (sfid-20170222_205457_444430_A8FF0682)
Date: Wed, 22 Feb 2017 20:54:49 +0100
MIME-Version: 1.0
In-Reply-To: <1487672891-8584-1-git-send-email-marcin.rokicki@tieto.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 21-2-2017 11:28, Marcin Rokicki wrote:
> The empty 'return;' statement in a void function should be
> used to return from somewhere else than the end.
> 
> Signed-off-by: Marcin Rokicki <marcin.rokicki@tieto.com>
> ---
> 
> Changes for v2
>  -remove only return statement instead of empty err label
>   which can be used in the future
> 
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 59729aa..a22d3c9 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2311,7 +2311,7 @@ static void ath10k_core_register_work(struct work_struct *work)
>  	/* TODO: It's probably a good idea to release device from the driver
>  	 * but calling device_release_driver() here will cause a deadlock.
>  	 */
> -	return;
> +	;

Not exactly what I meant. Just drop the whole line include semicolon.

Regards,
Arend

>  }
>  
>  int ath10k_core_register(struct ath10k *ar, u32 chip_id)
> 
