Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:33035 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab3I0SzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 14:55:20 -0400
Received: by mail-bk0-f52.google.com with SMTP id e11so1099769bkh.39
        for <linux-wireless@vger.kernel.org>; Fri, 27 Sep 2013 11:55:19 -0700 (PDT)
Message-ID: <5245D495.3010505@gmail.com> (sfid-20130927_205524_575967_F742FFBB)
Date: Fri, 27 Sep 2013 20:55:17 +0200
From: Daniel Mack <zonque@gmail.com>
MIME-Version: 1.0
To: Bing Zhao <bzhao@marvell.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
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

Actually, just out of pure curiosity, I would be interested whether the
issue is also as easily reproducible on other platform like Chromebooks.
Could anyone give that a try maybe?


Thanks,
Daniel


> 
> mwifiex_main_process() is called from both the SDIO handler and
> the workqueue. In case an interrupt occurs right after the
> int_status check, but before updating the mwifiex_processing flag,
> this interrupt gets lost, resulting in a command timeout and
> consequently a card reset.
> 
> Let main_proc_lock protect both int_status and mwifiex_processing
> flag. This fixes the interrupt lost issue.
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

