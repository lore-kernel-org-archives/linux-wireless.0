Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52484 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967069AbeCAKBL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 05:01:11 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ath10k: Enable IOMMU support for WCN3990 target
References: <1518685448-15317-1-git-send-email-govinds@codeaurora.org>
Date: Thu, 01 Mar 2018 12:01:06 +0200
In-Reply-To: <1518685448-15317-1-git-send-email-govinds@codeaurora.org>
        (Govind Singh's message of "Thu, 15 Feb 2018 14:34:08 +0530")
Message-ID: <877eqwqfml.fsf@kamboji.qca.qualcomm.com> (sfid-20180301_110117_293163_CD802DA0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> writes:

> When an IOMMU device is available on the platform bus, allocate
> an IOMMU domain and attach the wlan target to it.
> WCN3990 target can then attach an DMA I/O virtual address
> space to scan out of bound transactions.
>
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/snoc.c | 100 ++++++++++++++++++++++++++++++++-
>  drivers/net/wireless/ath/ath10k/snoc.h |   3 +
>  2 files changed, 101 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index cd21b25..502263d 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -26,6 +26,10 @@
>  #include <linux/platform_device.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/clk.h>
> +#include <asm/dma-iommu.h>
> +#include <linux/iommu.h>
> +#include <linux/dma-mapping.h>

Kbuild bot reported a problem with arm64 but strangely I cannot find the
full report. Anyway, this was the warning:

drivers/net/wireless/ath/ath10k/snoc.c:29:10: fatal error:
asm/dma-iommu.h: No such file or directory

Any ideas? Adding also Arnd, the grand master of compilation problems :)

Full patch here:

https://patchwork.kernel.org/patch/10220719/

-- 
Kalle Valo
