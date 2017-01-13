Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:35228 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdAMWti (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 17:49:38 -0500
Received: by mail-pf0-f179.google.com with SMTP id f144so37465796pfa.2
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 14:49:38 -0800 (PST)
Date: Fri, 13 Jan 2017 14:49:34 -0800
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>
Subject: Re: [PATCH 1/2] mwifiex: pcie: use posted write to wake up firmware
Message-ID: <20170113224933.GA14772@google.com> (sfid-20170113_235005_369570_F4305E69)
References: <20170112210232.18554-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170112210232.18554-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 12, 2017 at 01:02:31PM -0800, Brian Norris wrote:
> Depending on system factors (e.g., the PCIe link PM state), the first
> read to wake up the Wifi firmware can take a long time. There is no
> reason to use a (blocking, non-posted) read at this point, so let's just
> use a write instead. Write vs. read doesn't matter functionality-wise --
> it's just a dummy operation.
> 
> This has been shown to decrease the time spent blocking in this function
> on a Rockchip RK3399 SoC.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 66226c615be0..435ba879ef29 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -458,7 +458,6 @@ static void mwifiex_delay_for_sleep_cookie(struct mwifiex_adapter *adapter,
>  /* This function wakes up the card by reading fw_status register. */
>  static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
>  {
> -	u32 fw_status;
>  	struct pcie_service_card *card = adapter->card;
>  	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
>  
> @@ -468,10 +467,10 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
>  	if (reg->sleep_cookie)
>  		mwifiex_pcie_dev_wakeup_delay(adapter);
>  
> -	/* Reading fw_status register will wakeup device */
> -	if (mwifiex_read_reg(adapter, reg->fw_status, &fw_status)) {
> +	/* Accessing fw_status register will wakeup device */
> +	if (mwifiex_write_reg(adapter, reg->fw_status, 0)) {

As Amit noted to me elsewhere, the firmware only writes this status once
at FW init time to FIRMWARE_READY_PCIE, and we later check it in a few
places. So I noticed that this actually breaks re-probing the adapter
(e.g., 'rmmod mwifiex_pcie; modprobe mwifiex_pcie'); the second time,
we'll fail to find the FIRMWARE_READY_PCIE signature, and so we'll
abort.

I'll resend this patch with s/0/FIRMWARE_READY_PCIE/ instead.

Brian

>  		mwifiex_dbg(adapter, ERROR,
> -			    "Reading fw_status register failed\n");
> +			    "Writing fw_status register failed\n");
>  		return -1;
>  	}
>  
> -- 
> 2.11.0.390.gc69c2f50cf-goog
> 
