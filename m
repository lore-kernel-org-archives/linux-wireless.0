Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34478 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750784AbdCIITe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 03:19:34 -0500
Received: by mail-wm0-f44.google.com with SMTP id 196so34252513wmm.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Mar 2017 00:19:33 -0800 (PST)
Subject: Re: [PATCH v3 1/3] brcmfmac: Do not print the firmware version as an
 error
To: Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170308135017.29867-1-hdegoede@redhat.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <27347c0d-40be-57e3-ba89-6192c50331c5@broadcom.com> (sfid-20170309_091939_033440_506CCFB4)
Date: Thu, 9 Mar 2017 09:19:30 +0100
MIME-Version: 1.0
In-Reply-To: <20170308135017.29867-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8-3-2017 14:50, Hans de Goede wrote:
> Using pr_err for things which are not errors is a bad idea. E.g. it
> will cause the plymouth bootsplash screen to drop back to the text
> console so that the user can see the error, which is not what we
> normally want to happen.
> 
> Instead add a new brcmf_info macro and use that.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> -Fix brcm_err typo (should be brcmf_err) in CONFIG_BRCM_TRACING case
> Changes in v3:
> -Use do { } while (0) around macro
> -Rebase on top of v4.11-rc1
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h  | 9 +++++++++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> index 33b133f..7a2b495 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -161,7 +161,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
>  	strsep(&ptr, "\n");
>  
>  	/* Print fw version info */
> -	brcmf_err("Firmware version = %s\n", buf);
> +	brcmf_info("Firmware version = %s\n", buf);
>  
>  	/* locate firmware version number for ethtool */
>  	ptr = strrchr(buf, ' ') + 1;
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> index 0661261..afb2436 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> @@ -59,6 +59,10 @@ void __brcmf_err(const char *func, const char *fmt, ...);
>  	} while (0)
>  
>  #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
> +
> +/* For debug/tracing purposes treat info messages as errors */
> +#define brcmf_info brcmf_err
> +
>  __printf(3, 4)
>  void __brcmf_dbg(u32 level, const char *func, const char *fmt, ...);
>  #define brcmf_dbg(level, fmt, ...)				\
> @@ -77,6 +81,11 @@ do {								\
>  
>  #else /* defined(DEBUG) || defined(CONFIG_BRCM_TRACING) */
>  
> +#define brcmf_info(fmt, ...)						\
> +	do {								\
> +		pr_info("%s: " fmt, __func__, ##__VA_ARGS__);		\
> +	} while (0)
> +
>  #define brcmf_dbg(level, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
>  
>  #define BRCMF_DATA_ON()		0
> 
