Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35425 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754611AbcJXRom (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 13:44:42 -0400
Received: by mail-pf0-f180.google.com with SMTP id s8so102645137pfj.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 10:43:58 -0700 (PDT)
Date: Mon, 24 Oct 2016 10:43:55 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        dmitry.torokhov@gmail.com, briannorris@google.com
Subject: Re: [PATCH 1/5] mwifiex: remove redundant condition in main process
Message-ID: <20161024174354.GA968@localhost> (sfid-20161024_194506_742827_5768677A)
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 24, 2016 at 07:51:28PM +0530, Amitkumar Karwar wrote:
> This condition while calling mwifiex_check_ps_cond() is redundant.
> The function internally already takes care of it.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Unless you're intentionally *not* logging the "Delay Sleep Confirm" in
some cases, this looks good:

Reviewed-by: Brian Norris <briannorris@chromium.org>

> ---
>  drivers/net/wireless/marvell/mwifiex/main.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
> index 2478ccd..3b31ea2 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -355,10 +355,8 @@ process_start:
>  
>  		/* Check if we need to confirm Sleep Request
>  		   received previously */
> -		if (adapter->ps_state == PS_STATE_PRE_SLEEP) {
> -			if (!adapter->cmd_sent && !adapter->curr_cmd)
> -				mwifiex_check_ps_cond(adapter);
> -		}
> +		if (adapter->ps_state == PS_STATE_PRE_SLEEP)
> +			mwifiex_check_ps_cond(adapter);
>  
>  		/* * The ps_state may have been changed during processing of
>  		 * Sleep Request event.
> -- 
> 1.9.1
> 
