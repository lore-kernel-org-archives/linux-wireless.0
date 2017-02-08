Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35395 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752775AbdBHKsE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 05:48:04 -0500
Received: by mail-pf0-f177.google.com with SMTP id f144so41600429pfa.2
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2017 02:47:15 -0800 (PST)
Subject: Re: [PATCH V3 3/9] brcmfmac: merge two remaining brcmf_err macros
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170202213321.11591-1-zajec5@gmail.com>
 <20170202213321.11591-3-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <585f9747-7171-3021-5df5-e0dd12c5dccd@broadcom.com> (sfid-20170208_115157_877988_46FEB6E9)
Date: Wed, 8 Feb 2017 10:52:10 +0100
MIME-Version: 1.0
In-Reply-To: <20170202213321.11591-3-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2-2-2017 22:33, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Now we always have __brcmf_err function we can do perfectly fine with
> just one macro.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V3: Add this (new) patch
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> index 441a6661eac0..066126123e96 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> @@ -47,20 +47,16 @@
>  
>  __printf(2, 3)
>  void __brcmf_err(const char *func, const char *fmt, ...);
> -#ifndef CONFIG_BRCM_TRACING
> -/* Macro for error messages. net_ratelimit() is used when driver
> - * debugging is not selected. When debugging the driver error
> - * messages are as important as other tracing or even more so.
> +/* Macro for error messages. When debugging / tracing the driver all error
> + * messages are important to us.
>   */
>  #define brcmf_err(fmt, ...)						\
>  	do {								\
> -		if (IS_ENABLED(CONFIG_BRCMDBG) || net_ratelimit())	\
> +		if (IS_ENABLED(CONFIG_BRCMDBG) ||			\
> +		    IS_ENABLED(CONFIG_BRCM_TRACING) ||			\
> +		    net_ratelimit())					\
>  			__brcmf_err(__func__, fmt, ##__VA_ARGS__);	\
>  	} while (0)
> -#else
> -#define brcmf_err(fmt, ...) \
> -	__brcmf_err(__func__, fmt, ##__VA_ARGS__)
> -#endif
>  
>  #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
>  __printf(3, 4)
> 
