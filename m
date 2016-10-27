Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35088 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbcJ0RoZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 13:44:25 -0400
Received: by mail-pf0-f194.google.com with SMTP id s8so3196856pfj.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2016 10:44:25 -0700 (PDT)
Date: Thu, 27 Oct 2016 10:44:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        briannorris@google.com
Subject: Re: [PATCH v2 2/5] mwifiex: use spinlock for 'mwifiex_processing' in
 shutdown_drv
Message-ID: <20161027174422.GA509@dtor-ws> (sfid-20161027_194429_872289_95ADC7C6)
References: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
 <1477559563-18328-2-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1477559563-18328-2-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit,

On Thu, Oct 27, 2016 at 02:42:40PM +0530, Amitkumar Karwar wrote:
> This variable is guarded by spinlock at all other places. This patch
> takes care of missing spinlock usage in mwifiex_shutdown_drv().

Since in the previous discussion you stated that we inhibit interrupts
and flush the workqueue so that mwifiex_shutdown_drv() can't run
simultaneously with the main processing routine, why do we need this?

Instead please remove call to mwifiex_shutdown_drv() in the main routine
and "if (adapter->mwifiex_processing)" check here.

Thanks.

> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> v2: Same as v1
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
>  
>  	/* cancel current command */
>  	if (adapter->curr_cmd) {
> -- 
> 1.9.1
> 

-- 
Dmitry
