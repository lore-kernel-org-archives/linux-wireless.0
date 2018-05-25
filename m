Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33754 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966243AbeEYMGQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 08:06:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Maya Erez <merez@codeaurora.org>
Cc: Gidon Studinski <gidons@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 3/7] wil6210: initialize TX and RX enhanced DMA rings
References: <1526227375-31881-1-git-send-email-merez@codeaurora.org>
        <1526227375-31881-4-git-send-email-merez@codeaurora.org>
Date: Fri, 25 May 2018 15:06:12 +0300
In-Reply-To: <1526227375-31881-4-git-send-email-merez@codeaurora.org> (Maya
        Erez's message of "Sun, 13 May 2018 19:02:51 +0300")
Message-ID: <87muwokki3.fsf@purkki.adurom.net> (sfid-20180525_140728_064484_7014DA09)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <merez@codeaurora.org> writes:

> From: Gidon Studinski <gidons@codeaurora.org>
>
> Enhanced DMA design includes the following rings:
> - Single RX descriptor ring is used for all VIFs
> - Multiple RX status rings are supported, to allow RSS
> - TX descriptor ring is allocated per connection
> - A single TX status ring is used for all TX descriptor rings
>
> This patch initializes and frees the above descriptor and
> status rings.
>
> The RX SKBs are handled by a new entity of RX buffers manager,
> which handles RX buffers, each one points to an allocated SKB.
> During Rx completion processing, the driver extracts a buffer
> ID which is used as an index to the buffers array.
> After the SKB is freed the buffer is moved from the 'active'
> list to the 'free' list, indicating it can be used for another
> descriptor. During Rx refill, SKBs are allocated and attached
> to 'free' buffers. Those buffers are attached to new descriptors
> and moved to the 'active' list.
>
> Signed-off-by: Gidon Studinski <gidons@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>

[...]

> --- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
> +++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
> @@ -32,6 +32,10 @@
>  module_param(ftm_mode, bool, 0444);
>  MODULE_PARM_DESC(ftm_mode, " Set factory test mode, default - false");
>  
> +static bool use_enhanced_dma_hw = true;
> +module_param(use_enhanced_dma_hw, bool, 0444);
> +MODULE_PARM_DESC(use_enhanced_dma_hw, " Use enhanced or legacy DMA HW. Default: true when available");

Similarly as with debugfs, please document in the commit log any changes
in module parameters.

-- 
Kalle Valo
