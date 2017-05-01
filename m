Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:32950 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbdEASrg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 May 2017 14:47:36 -0400
Received: by mail-pg0-f50.google.com with SMTP id y4so43307990pge.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 May 2017 11:47:36 -0700 (PDT)
Date: Mon, 1 May 2017 11:47:33 -0700
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mwifiex: initiate card-specific work atomically
Message-ID: <20170501184732.GA53046@google.com> (sfid-20170501_204940_999320_2E9F00F6)
References: <20170501184549.52896-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170501184549.52896-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 01, 2017 at 11:45:48AM -0700, Brian Norris wrote:
> The non-atomic test + set is a little awkward here, and it technically
> means we might double-schedule work unnecessarily. AFAICT, this is not
> really a problem, since the extra "work" will be a no-op (the flag(s)
> will be cleared by then), but it's still an anti-pattern.
> 
> Rewrite this to use the atomic test_and_set_bit() helper instead.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> new in v2
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 13 +++++++++----
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 16 +++++-----------
>  2 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index ac62bce50e96..8e7d6f41a952 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -2837,12 +2837,17 @@ static void mwifiex_pcie_device_dump(struct mwifiex_adapter *adapter)
>  {
>  	struct pcie_service_card *card = adapter->card;
>  
> -	if (test_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags))
> -		return;
> +	if (!test_and_set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP,
> +			      &card->work_flags))
> +		schedule_work(&card->work);
> +}
>  
> -	set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
> +static void mwifiex_pcie_card_reset(struct mwifiex_adapter *adapter)
> +{
> +	struct pcie_service_card *card = adapter->card;
>  
> -	schedule_work(&card->work);
> +	if (!test_and_set_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags))
> +		schedule_work(&card->work);
>  }
>  
>  static void mwifiex_pcie_free_buffers(struct mwifiex_adapter *adapter)

Ooops, mis-split on patch 1 vs. 2. This won't be bisectable! Sorry,
please ignore! Will send v3 soon.
