Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33399 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbdEATip (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 May 2017 15:38:45 -0400
Date: Mon, 1 May 2017 12:38:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Brian Norris <briannorris@chromium.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mwifiex: pcie: add card_reset() support
Message-ID: <20170501193841.GB34444@dtor-ws> (sfid-20170501_213957_338988_2BC99860)
References: <20170501193700.89264-1-briannorris@chromium.org>
 <20170501193700.89264-2-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170501193700.89264-2-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 01, 2017 at 12:37:00PM -0700, Brian Norris wrote:
> Similar to the SDIO driver, we should implement this so that we will
> automatically reset the device whenever there's a command timeout or
> similar.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> ---
> v3: keep all the new reset code in patch 2, not patch 1
> 
> v2: use atomic test/set, based on Dmitry's suggestion
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 5f56e8e6d612..78688ff6ecd0 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -2822,6 +2822,13 @@ static void mwifiex_pcie_device_dump_work(struct mwifiex_adapter *adapter)
>  	mwifiex_upload_device_dump(adapter, drv_info, drv_info_size);
>  }
>  
> +static void mwifiex_pcie_card_reset_work(struct mwifiex_adapter *adapter)
> +{
> +	struct pcie_service_card *card = adapter->card;
> +
> +	pci_reset_function(card->dev);
> +}
> +
>  static void mwifiex_pcie_work(struct work_struct *work)
>  {
>  	struct pcie_service_card *card =
> @@ -2830,6 +2837,9 @@ static void mwifiex_pcie_work(struct work_struct *work)
>  	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP,
>  			       &card->work_flags))
>  		mwifiex_pcie_device_dump_work(card->adapter);
> +	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET,
> +			       &card->work_flags))
> +		mwifiex_pcie_card_reset_work(card->adapter);
>  }
>  
>  /* This function dumps FW information */
> @@ -2842,6 +2852,14 @@ static void mwifiex_pcie_device_dump(struct mwifiex_adapter *adapter)
>  		schedule_work(&card->work);
>  }
>  
> +static void mwifiex_pcie_card_reset(struct mwifiex_adapter *adapter)
> +{
> +	struct pcie_service_card *card = adapter->card;
> +
> +	if (!test_and_set_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags))
> +		schedule_work(&card->work);
> +}
> +
>  static void mwifiex_pcie_free_buffers(struct mwifiex_adapter *adapter)
>  {
>  	struct pcie_service_card *card = adapter->card;
> @@ -3271,6 +3289,7 @@ static struct mwifiex_if_ops pcie_ops = {
>  	.cleanup_mpa_buf =		NULL,
>  	.init_fw_port =			mwifiex_pcie_init_fw_port,
>  	.clean_pcie_ring =		mwifiex_clean_pcie_ring_buf,
> +	.card_reset =			mwifiex_pcie_card_reset,
>  	.reg_dump =			mwifiex_pcie_reg_dump,
>  	.device_dump =			mwifiex_pcie_device_dump,
>  	.down_dev =			mwifiex_pcie_down_dev,
> -- 
> 2.13.0.rc0.306.g87b477812d-goog
> 

-- 
Dmitry
