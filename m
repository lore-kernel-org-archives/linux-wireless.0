Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:61495 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbZJPWLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 18:11:14 -0400
Received: by fxm18 with SMTP id 18so2969448fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 15:11:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
	 <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
Date: Sat, 17 Oct 2009 00:11:16 +0200
Message-ID: <1ba2fa240910161511j5272df99o812d132a3778659@mail.gmail.com>
Subject: Re: [PATCH 01/16] iwmc3200wifi: add BGN sdio device id
From: Tomas Winkler <tomasw@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 16, 2009 at 7:18 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> Add BGN SKU sdio device id.
>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>

I will remove SDIO_DEVICE_ID_INTEL_IWMC3200WIF from sdio_ids.h


> ---
>  drivers/net/wireless/iwmc3200wifi/sdio.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.c b/drivers/net/wireless/iwmc3200wifi/sdio.c
> index 8b1de84..38026b7 100644
> --- a/drivers/net/wireless/iwmc3200wifi/sdio.c
> +++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
> @@ -493,8 +493,10 @@ static void iwm_sdio_remove(struct sdio_func *func)
>  }
>
>  static const struct sdio_device_id iwm_sdio_ids[] = {
> -       { SDIO_DEVICE(SDIO_VENDOR_ID_INTEL,
> -                     SDIO_DEVICE_ID_INTEL_IWMC3200WIFI) },
> +       /* Global/AGN SKU */
> +       { SDIO_DEVICE(SDIO_VENDOR_ID_INTEL, 0x1403) },
> +       /* BGN SKU */
> +       { SDIO_DEVICE(SDIO_VENDOR_ID_INTEL, 0x1408) },
>        { /* end: all zeroes */ },
>  };
>  MODULE_DEVICE_TABLE(sdio, iwm_sdio_ids);
> --
> 1.6.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
