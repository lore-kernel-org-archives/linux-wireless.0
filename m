Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:51489 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab3JOKjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 06:39:01 -0400
Received: by mail-bk0-f42.google.com with SMTP id my10so3188667bkb.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 03:38:59 -0700 (PDT)
Message-ID: <525D1B3A.8090805@gmail.com> (sfid-20131015_123909_856177_3CE05887)
Date: Tue, 15 Oct 2013 12:38:50 +0200
From: Daniel Mack <zonque@gmail.com>
MIME-Version: 1.0
To: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org
CC: "John W. Linville" <linville@tuxdriver.com>,
	Sven Neumann <s.neumann@raumfeld.com>,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	Dylan Reid <dgreid@chromium.org>,
	Paul Stewart <pstew@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [PATCH 3.12] mwifiex: fix SDIO interrupt lost issue
References: <1380304538-2816-1-git-send-email-bzhao@marvell.com>
In-Reply-To: <1380304538-2816-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27.09.2013 19:55, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> 601216e "mwifiex: process RX packets in SDIO IRQ thread directly"
> introduced a command timeout issue which can be reproduced easily on
> an AM33xx platform using a test application written by Daniel Mack:
> 
> https://gist.github.com/zonque/6579314
> 
> mwifiex_main_process() is called from both the SDIO handler and
> the workqueue. In case an interrupt occurs right after the
> int_status check, but before updating the mwifiex_processing flag,
> this interrupt gets lost, resulting in a command timeout and
> consequently a card reset.
> 
> Let main_proc_lock protect both int_status and mwifiex_processing
> flag. This fixes the interrupt lost issue.

John, could you take this patch trough your tree?


Thanks,
Daniel


> 
> Cc: <stable@vger.kernel.org> # 3.7+
> Reported-by: Sven Neumann <s.neumann@raumfeld.com>
> Reported-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
> Tested-by: Daniel Mack <zonque@gmail.com>
> Reviewed-by: Dylan Reid <dgreid@chromium.org>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: Paul Stewart <pstew@chromium.org>
> ---
>  drivers/net/wireless/mwifiex/main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
> index fd77833..c2b91f5 100644
> --- a/drivers/net/wireless/mwifiex/main.c
> +++ b/drivers/net/wireless/mwifiex/main.c
> @@ -358,10 +358,12 @@ process_start:
>  		}
>  	} while (true);
>  
> -	if ((adapter->int_status) || IS_CARD_RX_RCVD(adapter))
> +	spin_lock_irqsave(&adapter->main_proc_lock, flags);
> +	if ((adapter->int_status) || IS_CARD_RX_RCVD(adapter)) {
> +		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
>  		goto process_start;
> +	}
>  
> -	spin_lock_irqsave(&adapter->main_proc_lock, flags);
>  	adapter->mwifiex_processing = false;
>  	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
>  
> 

