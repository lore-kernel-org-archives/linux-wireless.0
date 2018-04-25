Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49654 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeDYIVJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 04:21:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: pcie: tighten a check in
 mwifiex_pcie_process_event_ready()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180405111719.GB4218@mwanda>
References: <20180405111719.GB4218@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Message-Id: <20180425082109.78ED5607E5@smtp.codeaurora.org> (sfid-20180425_102114_405242_87E94685)
Date: Wed, 25 Apr 2018 08:21:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> If "evt_len" is 1 then we try to memcpy() negative 3 bytes and it would
> cause memory corruption.
> 
> Fixes: d930faee141b ("mwifiex: add support for Marvell pcie8766 chipset")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 97a6199692ab..7538543d46fa 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -1881,7 +1881,8 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
>  		mwifiex_dbg(adapter, EVENT,
>  			    "info: Event length: %d\n", evt_len);
>  
> -		if ((evt_len > 0) && (evt_len  < MAX_EVENT_SIZE))
> +		if (evt_len > MWIFIEX_EVENT_HEADER_LEN &&
> +		    evt_len < MAX_EVENT_SIZE)
>  			memcpy(adapter->event_body, skb_cmd->data +
>  			       MWIFIEX_EVENT_HEADER_LEN, evt_len -
>  			       MWIFIEX_EVENT_HEADER_LEN);

Patch applied to wireless-drivers-next.git, thanks.

01eca2842874 mwifiex: pcie: tighten a check in mwifiex_pcie_process_event_ready()

-- 
https://patchwork.kernel.org/patch/10324435/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
