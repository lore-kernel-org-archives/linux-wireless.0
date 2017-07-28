Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51902 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752436AbdG1Ovg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:51:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: usb: unlock on error in mwifiex_usb_tx_aggr_tmo()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170710072115.2y4ukbl7x4rk4bac@mwanda>
References: <20170710072115.2y4ukbl7x4rk4bac@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxm@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20170728145135.D98EC60915@smtp.codeaurora.org> (sfid-20170728_165141_795090_621F6E87)
Date: Fri, 28 Jul 2017 14:51:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> We need to unlock if mwifiex_usb_prepare_tx_aggr_skb() fails.
> 
> Fixes: a2ca85ad721d ("mwifiex: usb: add timer to flush aggregation packets")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
> index cb1753e43ef4..880ef1cb4088 100644
> --- a/drivers/net/wireless/marvell/mwifiex/usb.c
> +++ b/drivers/net/wireless/marvell/mwifiex/usb.c
> @@ -1112,7 +1112,7 @@ static void mwifiex_usb_tx_aggr_tmo(unsigned long context)
>  	if (err) {
>  		mwifiex_dbg(adapter, ERROR,
>  			    "prepare tx aggr skb failed, err=%d\n", err);
> -		return;
> +		goto unlock;
>  	}
>  
>  	if (atomic_read(&port->tx_data_urb_pending) >=
> @@ -1133,6 +1133,7 @@ static void mwifiex_usb_tx_aggr_tmo(unsigned long context)
>  done:
>  	if (err == -1)
>  		mwifiex_write_data_complete(adapter, skb_send, 0, -1);
> +unlock:
>  	spin_unlock_irqrestore(&port->tx_aggr_lock, flags);
>  }

Patch applied to wireless-drivers-next.git, thanks.

fe0c94be77a0 mwifiex: usb: unlock on error in mwifiex_usb_tx_aggr_tmo()

-- 
https://patchwork.kernel.org/patch/9832397/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
