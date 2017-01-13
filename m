Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:34244 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751553AbdAMWyJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 17:54:09 -0500
Received: by mail-pf0-f175.google.com with SMTP id 127so37128628pfg.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 14:54:09 -0800 (PST)
Date: Fri, 13 Jan 2017 14:54:06 -0800
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>
Subject: Re: [PATCH 2/2] mwifiex: pcie: don't delay for sleep cookie when not
 required
Message-ID: <20170113225405.GB14772@google.com> (sfid-20170113_235421_197960_52AE947C)
References: <20170112210232.18554-1-briannorris@chromium.org>
 <20170112210232.18554-2-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170112210232.18554-2-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 12, 2017 at 01:02:32PM -0800, Brian Norris wrote:
> Wifi modules like 8997 don't support the "sleep cookie", and so most of
> the time, we just time out in the mwifiex_delay_for_sleep_cookie()
> function ("max count reached while accessing sleep cookie"). This is a
> waste of time, and we should skip it for modules without the sleep
> cookie flag.
> 
> Additionally, this delay is sometimes counterproductive. For instance,
> when PCIe ASPM is enabled, this extra delay can leave the link idle for
> long enough to re-enter a low-power state even while we are trying to
> wake the module, compounding an additional delay when it comes time to
> read the next register (e.g., the interrupt status). On some systems,
> this is detrimental to overall system latency.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> Tested on Marvell 8997, but would be good to get confirmation from Marvell.

It would still be good to get comment from Marvell here, but elsewhere,
they've told me that this breaks the expected handshake procedure. I'm
still not quite sure how that is true, considering that we time out in
the mwifiex_delay_for_sleep_cookie() all the time anyway (so what's the
point of waiting then?)...

But anyway I think I have discovered a proper root cause [1] that is
causing my latency problems above. I'll post a v2 which replaces the
current patch with something else.

Brian

[1] The short version: re-reading the interrupt status register from the
card after we've sent it to sleep takes a long time. We shouldn't do
that.

>  drivers/net/wireless/marvell/mwifiex/pcie.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 435ba879ef29..11e0673617c7 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -1712,11 +1712,13 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
>  					    "Write register failed\n");
>  				return -1;
>  			}
> -			mwifiex_delay_for_sleep_cookie(adapter,
> -						       MWIFIEX_MAX_DELAY_COUNT);
> -			while (reg->sleep_cookie && (count++ < 10) &&
> -			       mwifiex_pcie_ok_to_access_hw(adapter))
> -				usleep_range(50, 60);
> +			if (reg->sleep_cookie) {
> +				mwifiex_delay_for_sleep_cookie(adapter,
> +							       MWIFIEX_MAX_DELAY_COUNT);
> +				while ((count++ < 10) &&
> +				       mwifiex_pcie_ok_to_access_hw(adapter))
> +					usleep_range(50, 60);
> +			}
>  			mwifiex_pcie_enable_host_int(adapter);
>  			mwifiex_process_sleep_confirm_resp(adapter, skb->data,
>  							   skb->len);
> -- 
> 2.11.0.390.gc69c2f50cf-goog
> 
