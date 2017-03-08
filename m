Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0179.hostedemail.com ([216.40.44.179]:55091 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753096AbdCHQfH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 11:35:07 -0500
Message-ID: <1488990890.2210.33.camel@perches.com> (sfid-20170308_173549_292427_5BF7D840)
Subject: Re: [PATCH v3] brcmfmac: Do not print the firmware version as an
 error
From: Joe Perches <joe@perches.com>
To: Hans de Goede <hdegoede@redhat.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Date: Wed, 08 Mar 2017 08:34:50 -0800
In-Reply-To: <20170308082321.4755-1-hdegoede@redhat.com>
References: <20170308082321.4755-1-hdegoede@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-03-08 at 09:23 +0100, Hans de Goede wrote:
> Using pr_err for things which are not errors is a bad idea. E.g. it
> will cause the plymouth bootsplash screen to drop back to the text
> console so that the user can see the error, which is not what we
> normally want to happen.
> 
> Instead add a new brcmf_info macro and use that.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> -Fix brcm_err typo (should be brcmf_err) in CONFIG_BRCM_TRACING case
> Changes in v3:
> -Use do { } while (0) around macro

why?  Single statement macros do not need a do/while

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
[]
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

#define brcmf_info(fmt, ...)
	pr_info("%s: " fmt, __func__, ##__VA_ARGS__)

> +
>  #define brcmf_dbg(level, fmt, ...) no_printk(fmt, ##__VA_ARGS__)

I think the separate defines for DEBUG/CONFIG_BRCM_TRACING
are not necessary.
