Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52887 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab1CYQYE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 12:24:04 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimvLzgO1VHAbYz0uh-TVBGdLr-aDcyaGyzS2QMi@mail.gmail.com>
References: <AANLkTi=CSK8nRF7CTzsq06Bk8Cr74ZcwJBf53_wWbpnv@mail.gmail.com> <AANLkTimvLzgO1VHAbYz0uh-TVBGdLr-aDcyaGyzS2QMi@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 25 Mar 2011 18:23:43 +0200
Message-ID: <AANLkTimevrNU+JC=KvMzpGfip7cimPMo2cmBzvPiMb9R@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] sdio: add power_restore support with
 MMC_PM_KEEP_POWER mode
To: Wilson Loi <wlsloi@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 25, 2011 at 6:00 AM, Wilson Loi <wlsloi@gmail.com> wrote:
> Another patch file
> ----------------------------
>
> diff -ruN a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c

Please follow Documentation/SubmittingPatches when submitting patches,
or at least just add -p to diff, otherwise it's a bit difficult to
follow. thanks.

>      mmc_bus_put(host);
>
> -    mmc_power_off(host);
> +    if (!ret && !(host->pm_flags & MMC_PM_KEEP_POWER))
> +        mmc_power_off(host);

...
>
> -    mmc_power_up(host);
> +    if (!(host->pm_flags & MMC_PM_KEEP_POWER))
> +        mmc_power_up(host);
>      ret = host->bus_ops->power_restore(host);


I have the same question here: if you driver doesn't want its card to
be powered down, why does it invoke (or let runtime PM invoke on its
behalf) mmc_power_save_host() in the first place ?
