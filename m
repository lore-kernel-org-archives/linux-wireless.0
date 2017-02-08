Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:32770 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753955AbdBHJJK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 04:09:10 -0500
Received: by mail-pf0-f171.google.com with SMTP id y143so40928555pfb.0
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2017 01:09:10 -0800 (PST)
Subject: Re: [PATCH V3 1/9] brcmfmac: merge two brcmf_err macros into one
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170202213321.11591-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <cb47d783-9c8f-36aa-1b82-5c7d7b78920e@broadcom.com> (sfid-20170208_101021_052379_F90F7525)
Date: Wed, 8 Feb 2017 10:02:58 +0100
MIME-Version: 1.0
In-Reply-To: <20170202213321.11591-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2-2-2017 22:33, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This allows simplifying the code by adding a simple IS_ENABLED check for
> CONFIG_BRCMDB symbol.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V3: Re-add this patch (it was initially submited as RFC)
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> index 6687812770cc..1fe4aa973a92 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> @@ -45,20 +45,16 @@
>  #undef pr_fmt
>  #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
>  
> +#ifndef CONFIG_BRCM_TRACING
>  /* Macro for error messages. net_ratelimit() is used when driver
>   * debugging is not selected. When debugging the driver error
>   * messages are as important as other tracing or even more so.
>   */
> -#ifndef CONFIG_BRCM_TRACING
> -#ifdef CONFIG_BRCMDBG
> -#define brcmf_err(fmt, ...)	pr_err("%s: " fmt, __func__, ##__VA_ARGS__)
> -#else
>  #define brcmf_err(fmt, ...)						\
>  	do {								\
> -		if (net_ratelimit())					\
> +		if (IS_ENABLED(CONFIG_BRCMDBG) || net_ratelimit())	\
>  			pr_err("%s: " fmt, __func__, ##__VA_ARGS__);	\
>  	} while (0)
> -#endif
>  #else
>  __printf(2, 3)
>  void __brcmf_err(const char *func, const char *fmt, ...);
> 
