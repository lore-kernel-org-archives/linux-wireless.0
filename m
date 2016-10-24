Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34031 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754106AbcJXXHR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 19:07:17 -0400
Received: by mail-pf0-f178.google.com with SMTP id r16so106527935pfg.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 16:07:17 -0700 (PDT)
Date: Mon, 24 Oct 2016 16:07:14 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 1/2] mwifiex: fix corner case power save issue
Message-ID: <20161024230711.GA5323@localhost> (sfid-20161025_010721_737919_F53C19AC)
References: <1477062948-8558-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1477062948-8558-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Oct 21, 2016 at 08:45:47PM +0530, Amitkumar Karwar wrote:
> We may get SLEEP event from firmware even if TXDone for last Tx packet
> is still pending. In this case, we may end up accessing PCIe memory for
> handling TXDone after power save handshake is completed. This causes
> kernel crash with external abort.
> 
> We will delay sending SLEEP confirm to firmware in
> this case to resolve the problem.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> index 5347728..f582f61 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> @@ -1118,7 +1118,7 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
>  void
>  mwifiex_check_ps_cond(struct mwifiex_adapter *adapter)
>  {
> -	if (!adapter->cmd_sent &&
> +	if (!adapter->cmd_sent && !adapter->data_sent &&
>  	    !adapter->curr_cmd && !IS_CARD_RX_RCVD(adapter))
>  		mwifiex_dnld_sleep_confirm_cmd(adapter);
>  	else

Looks good to me, and tests out on my systems:

Tested-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
