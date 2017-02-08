Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:36716 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752874AbdBHLET (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 06:04:19 -0500
Received: by mail-pg0-f43.google.com with SMTP id v184so48234592pgv.3
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2017 03:03:16 -0800 (PST)
Subject: Re: [PATCH V3 4/9] brcmfmac: add struct brcmf_pub parameter to the
 __brcmf_err
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170202213321.11591-1-zajec5@gmail.com>
 <20170202213321.11591-4-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <2812805e-9108-284f-2165-34624d603364@broadcom.com> (sfid-20170208_120551_037010_260AA49C)
Date: Wed, 8 Feb 2017 10:54:53 +0100
MIME-Version: 1.0
In-Reply-To: <20170202213321.11591-4-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2-2-2017 22:33, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This will allow getting struct device reference from the passed
> brcmf_pub for the needs of dev_err. More detailed messages are really
> important for home routers which frequently have 2 (or even 3) wireless
> cards supported by brcmfmac.
> 
> Note that all calls are yet to be updated as for now brcmf_err macro
> always passes NULL. This will be handled in following patch to make this
> change easier to review.

I prefer brcmf_err() to have struct device reference directly instead of
using brcmf_pub. That would remove the need for patches 5 till 7 as bus
specific code already has struct device. So I have acked the first three
patches, but would like to revise 8 and 9.

Kalle,

I acked the first three patches. Can those three still go in for 4.11?

Regards,
Arend
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V2: Add missing include
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h        | 2 ++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c     | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h      | 9 +++++----
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c | 4 +++-
>  4 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> index 76693df34742..35d4801a62e6 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> @@ -17,6 +17,8 @@
>  #ifndef BRCMFMAC_BUS_H
>  #define BRCMFMAC_BUS_H
>  
> +#include <linux/device.h>
> +
>  #include "debug.h"
>  
>  /* IDs of the 6 default common rings of msgbuf protocol */
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> index 33b133f7e63a..f8ce597c4781 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -219,7 +219,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
>  }
>  
>  #ifndef CONFIG_BRCM_TRACING
> -void __brcmf_err(const char *func, const char *fmt, ...)
> +void __brcmf_err(struct brcmf_pub *pub, const char *func, const char *fmt, ...)
>  {
>  	struct va_format vaf;
>  	va_list args;
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> index 066126123e96..99acc095c834 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> @@ -19,6 +19,8 @@
>  
>  #include <linux/net.h>	/* net_ratelimit() */
>  
> +struct brcmf_pub;
> +
>  /* message levels */
>  #define BRCMF_TRACE_VAL		0x00000002
>  #define BRCMF_INFO_VAL		0x00000004
> @@ -45,8 +47,8 @@
>  #undef pr_fmt
>  #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
>  
> -__printf(2, 3)
> -void __brcmf_err(const char *func, const char *fmt, ...);
> +__printf(3, 4)
> +void __brcmf_err(struct brcmf_pub *pub, const char *func, const char *fmt, ...);
>  /* Macro for error messages. When debugging / tracing the driver all error
>   * messages are important to us.
>   */
> @@ -55,7 +57,7 @@ void __brcmf_err(const char *func, const char *fmt, ...);
>  		if (IS_ENABLED(CONFIG_BRCMDBG) ||			\
>  		    IS_ENABLED(CONFIG_BRCM_TRACING) ||			\
>  		    net_ratelimit())					\
> -			__brcmf_err(__func__, fmt, ##__VA_ARGS__);	\
> +			__brcmf_err(NULL, __func__, fmt, ##__VA_ARGS__);\
>  	} while (0)
>  
>  #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
> @@ -99,7 +101,6 @@ do {									\
>  
>  extern int brcmf_msg_level;
>  
> -struct brcmf_pub;
>  #ifdef DEBUG
>  void brcmf_debugfs_init(void);
>  void brcmf_debugfs_exit(void);
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
> index fe6755944b7b..329cb65eb78b 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
> @@ -18,10 +18,12 @@
>  
>  #ifndef __CHECKER__
>  #define CREATE_TRACE_POINTS
> +#include "bus.h"
> +#include "core.h"
>  #include "tracepoint.h"
>  #include "debug.h"
>  
> -void __brcmf_err(const char *func, const char *fmt, ...)
> +void __brcmf_err(struct brcmf_pub *pub, const char *func, const char *fmt, ...)
>  {
>  	struct va_format vaf = {
>  		.fmt = fmt,
> 
