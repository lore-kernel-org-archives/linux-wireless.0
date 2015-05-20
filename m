Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:36553 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbbETOdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 10:33:03 -0400
Received: by igbpi8 with SMTP id pi8so103811451igb.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2015 07:33:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432123792-4155-7-git-send-email-arend@broadcom.com>
References: <1432123792-4155-1-git-send-email-arend@broadcom.com>
	<1432123792-4155-7-git-send-email-arend@broadcom.com>
Date: Wed, 20 May 2015 16:33:01 +0200
Message-ID: <CACna6ryt5uNkBXAk8chFyMEQVJLdHELLdA_V5TrLcaAikrTZeg@mail.gmail.com> (sfid-20150520_163313_738262_AAE286A0)
Subject: Re: [PATCH 6/6] brcmfmac: Add support for host platform NVRAM loading.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 May 2015 at 14:09, Arend van Spriel <arend@broadcom.com> wrote:
> From: Hante Meuleman <meuleman@broadcom.com>
>
> Host platforms such as routers supported by OpenWRT can
> support NVRAM reading directly from internal NVRAM store.
> With this patch the nvram load routines will fall back to
> this method when there is no nvram file and support is
> available in the kernel.

FWIW it's OpenWrt :)


> This patch relies on a change which has been submitted to the
> linux-mips maintainer [1]. However, the brcmfmac code that relies on
> it is under CONFIG_BCM47XX flag. Still need to know whether that
> patch will be accepted or not before applying this one.

Yeah, lets give this patch a few days at least, so we can be sure
it'll be properly synced with MIPS work.
I'm OK with brcmfmac internal changes (you may send them now as
separated patch if you want to), but lets be careful with
bcm47xx_nvram.h part.


> @@ -19,6 +19,9 @@
>  #include <linux/device.h>
>  #include <linux/firmware.h>
>  #include <linux/module.h>
> +#if IS_ENABLED(CONFIG_BCM47XX)
> +#include <linux/bcm47xx_nvram.h>
> +#endif

This header is safe to include on any arch, as well as all functions
are. Drop the #if please.


> @@ -66,6 +71,27 @@ struct nvram_parser {
>         bool multi_dev_v2;
>  };
>
> +#if IS_ENABLED(CONFIG_BCM47XX)
> +static char *brcmf_nvram_get_contents(size_t *nvram_size)
> +{
> +       return bcm47xx_nvram_get_contents(nvram_size);
> +}
> +
> +static void brcmf_nvram_release_contents(char *nvram)
> +{
> +       bcm47xx_nvram_release_contents(nvram);
> +}
> +#else
> +static char *brcmf_nvram_get_contents(size_t *nvram_size)
> +{
> +       return NULL;
> +}
> +
> +static void brcmf_nvram_release_contents(char *nvram)
> +{
> +}
> +#endif

Everything you put in #else simply re-implements what you sent for
MIPS tree. We don't want to duplicate that code.
Also applying above code will break building wireless-drivers-next on
MIPS, we can't push this patch.

I can understand you are looking for a way to get this patch into
current -next and to somehow sync work across trees. I'm against
anything like merging MIPS tree to wireless-driver-next, but I may
have some idea.
I think the best way for achieving this is to rework your patch to
modify include/linux/bcm47xx_nvram.h. You could modify it the same way
you did in your patch for MIPS tree, except for
bcm47xx_nvram_get_contents. Don't implement this function for real (in
.c file), but instead make in dummy inline in a bcm47xx_nvram.h like:
static inline char *bcm47xx_nvram_get_contents(size_t *val_len)
{
        /* TODO: Implement in .c file */
        return NULL;
}

-- 
Rafał
