Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35119 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751787AbdEATiL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 May 2017 15:38:11 -0400
Date: Mon, 1 May 2017 12:38:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Brian Norris <briannorris@chromium.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mwifiex: initiate card-specific work atomically
Message-ID: <20170501193807.GA34444@dtor-ws> (sfid-20170501_213956_801681_9673317E)
References: <20170501193700.89264-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170501193700.89264-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 01, 2017 at 12:36:59PM -0700, Brian Norris wrote:
> The non-atomic test + set is a little awkward here, and it technically
> means we might double-schedule work unnecessarily. AFAICT, this is not
> really a problem, since the extra "work" will be a no-op (the flag(s)
> will be cleared by then), but it's still an anti-pattern.
> 
> Rewrite this to use the atomic test_and_set_bit() helper instead.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> ---
> v3: fix bisectability (unused code warning) -- some code from patch 2
>     crept in here
> 
> v2: new
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c |  9 +++------
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 16 +++++-----------
>  2 files changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index ac62bce50e96..5f56e8e6d612 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -2837,12 +2837,9 @@ static void mwifiex_pcie_device_dump(struct mwifiex_adapter *adapter)
>  {
>  	struct pcie_service_card *card = adapter->card;
>  
> -	if (test_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags))
> -		return;
> -
> -	set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
> -
> -	schedule_work(&card->work);
> +	if (!test_and_set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP,
> +			      &card->work_flags))
> +		schedule_work(&card->work);
>  }
>  
>  static void mwifiex_pcie_free_buffers(struct mwifiex_adapter *adapter)
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index 0af1c6733c92..d38d31bb9b79 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -2533,12 +2533,8 @@ static void mwifiex_sdio_card_reset(struct mwifiex_adapter *adapter)
>  {
>  	struct sdio_mmc_card *card = adapter->card;
>  
> -	if (test_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags))
> -		return;
> -
> -	set_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
> -
> -	schedule_work(&card->work);
> +	if (!test_and_set_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags))
> +		schedule_work(&card->work);
>  }
>  
>  /* This function dumps FW information */
> @@ -2546,11 +2542,9 @@ static void mwifiex_sdio_device_dump(struct mwifiex_adapter *adapter)
>  {
>  	struct sdio_mmc_card *card = adapter->card;
>  
> -	if (test_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags))
> -		return;
> -
> -	set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
> -	schedule_work(&card->work);
> +	if (!test_and_set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP,
> +			      &card->work_flags))
> +		schedule_work(&card->work);
>  }
>  
>  /* Function to dump SDIO function registers and SDIO scratch registers in case
> -- 
> 2.13.0.rc0.306.g87b477812d-goog
> 

-- 
Dmitry
