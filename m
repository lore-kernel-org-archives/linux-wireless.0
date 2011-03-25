Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50954 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1CYQTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 12:19:08 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=CSK8nRF7CTzsq06Bk8Cr74ZcwJBf53_wWbpnv@mail.gmail.com>
References: <AANLkTi=CSK8nRF7CTzsq06Bk8Cr74ZcwJBf53_wWbpnv@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 25 Mar 2011 18:18:48 +0200
Message-ID: <AANLkTinhbwsm_wOBDW5-WBrP0tfLUZMmuY18eGTkr4e4@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] sdio: add power_restore support with
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

Hello Wilson,

On Fri, Mar 25, 2011 at 5:58 AM, Wilson Loi <wlsloi@gmail.com> wrote:
> The current power_restore handler only support cut off mode.
> It is better to support keep power mode too.

This doesn't make much sense really;

mmc_power_save_host() and mmc_power_restore_host() are invoked by
runtime PM when it is time to power off/on the card.

If your driver doesn't want the power to go, it should just maintain a
positive runtime PM usage_count (e.g. in case it's an SDIO driver,
don't call pm_runtime_put{_sync} after being probed).

>  static const struct mmc_bus_ops mmc_sdio_ops = {
>      .remove = mmc_sdio_remove,
>      .detect = mmc_sdio_detect,
>      .suspend = mmc_sdio_suspend,
>      .resume = mmc_sdio_resume,
> -    .power_restore = mmc_sdio_power_restore,
> +    .power_save = mmc_sdio_suspend,
> +    .power_restore = mmc_sdio_resume,

This can break SDIO runtime PM.

While -ENOSYS is a valid return value for mmc_sdio_suspend (it tells
mmc_suspend_host to remove the entire MMC card on system suspend), it
will be treated as an error by runtime PM.

In addition, this can really yield unexpected results, since drivers
do not expect their suspend/resume handlers to be called during
runtime PM transitions.
