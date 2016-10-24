Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33739 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753901AbcJXXrY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 19:47:24 -0400
Received: by mail-pf0-f194.google.com with SMTP id i85so17746614pfa.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 16:47:23 -0700 (PDT)
Date: Mon, 24 Oct 2016 16:47:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        briannorris@google.com
Subject: Re: [PATCH 2/5] mwifiex: use spinlock for 'mwifiex_processing' in
 shutdown_drv
Message-ID: <20161024234720.GB15034@dtor-ws> (sfid-20161025_014727_907888_097F3190)
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
 <1477318892-22877-2-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1477318892-22877-2-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 24, 2016 at 07:51:29PM +0530, Amitkumar Karwar wrote:
> This variable is guarded by spinlock at all other places. This patch
> takes care of missing spinlock usage in mwifiex_shutdown_drv().
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/init.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
> index 82839d9..8e5e424 100644
> --- a/drivers/net/wireless/marvell/mwifiex/init.c
> +++ b/drivers/net/wireless/marvell/mwifiex/init.c
> @@ -670,11 +670,14 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
>  
>  	adapter->hw_status = MWIFIEX_HW_STATUS_CLOSING;
>  	/* wait for mwifiex_process to complete */
> +	spin_lock_irqsave(&adapter->main_proc_lock, flags);
>  	if (adapter->mwifiex_processing) {
> +		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
>  		mwifiex_dbg(adapter, WARN,
>  			    "main process is still running\n");
>  		return ret;
>  	}
> +	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);

What happens if adapter->mwifiex_processing will become true here?

>  
>  	/* cancel current command */
>  	if (adapter->curr_cmd) {
> -- 
> 1.9.1
> 

-- 
Dmitry
