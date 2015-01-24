Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:53344 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbAXJ0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 04:26:34 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Hong Xu <hong@topbug.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] ath9k_htc: Add a module parameter to disable blink
References: <1422091103-10579-1-git-send-email-hong@topbug.net>
Date: Sat, 24 Jan 2015 11:26:27 +0200
In-Reply-To: <1422091103-10579-1-git-send-email-hong@topbug.net> (Hong Xu's
	message of "Sat, 24 Jan 2015 01:18:23 -0800")
Message-ID: <87sif0il6k.fsf@kamboji.qca.qualcomm.com> (sfid-20150124_102648_418260_08C4184C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hong Xu <hong@topbug.net> writes:

> Add an option "blink" to enable or disable the LED blink. The default
> value is set to 1 so that existing users would not experience any
> unexpected changes.
>
> Signed-off-by: Hong Xu <hong@topbug.net>
> ---
>  drivers/net/wireless/ath/ath9k/htc.h          | 3 +++
>  drivers/net/wireless/ath/ath9k/htc_drv_gpio.c | 4 ++++
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c | 4 ++++
>  3 files changed, 11 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
> index 9dde265..300d367 100644
> --- a/drivers/net/wireless/ath/ath9k/htc.h
> +++ b/drivers/net/wireless/ath/ath9k/htc.h
> @@ -44,6 +44,9 @@
>  
>  extern struct ieee80211_ops ath9k_htc_ops;
>  extern int htc_modparam_nohwcrypt;
> +#ifdef CONFIG_MAC80211_LEDS
> +extern int ath9k_htc_led_blink;
> +#endif

Did you check that this applies to wireless-drivers-next? Didn't I
already apply this patch?

If your patch is already applied, you need to send a new patch to fix
the compilation error.

-- 
Kalle Valo
