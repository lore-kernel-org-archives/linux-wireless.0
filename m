Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33092 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751359AbdBBMqW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 07:46:22 -0500
Subject: Re: [PATCH V2 1/7] brcmfmac: switch to C function (__brcmf_err) for
 printing errors
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170202121659.21130-1-zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <6484b7bf-da37-04ec-8efd-825f44cc12d2@nbd.name> (sfid-20170202_134625_967777_7613F28E)
Date: Thu, 2 Feb 2017 13:46:18 +0100
MIME-Version: 1.0
In-Reply-To: <20170202121659.21130-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-02 13:16, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This will allow extending code and using more detailed messages e.g.
> with the help of dev_err. Note that *two separated* brcmf_err macros
> were replaced thanks to using a simple CONFIG_BRCMDBG symbol check in
> the body.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/common.c | 19 +++++++++++++++++++
>  .../net/wireless/broadcom/brcm80211/brcmfmac/debug.h  | 16 ----------------
>  2 files changed, 19 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> index f7c8c2e80349..05fb778ddd0f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -218,6 +218,25 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
>  	return err;
>  }
>  
> +#ifndef CONFIG_BRCM_TRACING
> +void __brcmf_err(const char *func, const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +
> +	if (!net_ratelimit() && !IS_ENABLED(CONFIG_BRCMDBG))
> +		return;
The IS_ENABLED must not come after net_ratelimit, because net_ratelimit
has side effects.
Also, please keep the IS_ENABLED(CONFIG_BRCMDBG) check inline, since
it's a compile-time check, and that allows gcc to skip unnecessary calls
when disabled.

- Felix
