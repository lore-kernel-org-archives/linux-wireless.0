Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:42046 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757885Ab1ELUKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 16:10:39 -0400
Received: by mail-ey0-f172.google.com with SMTP id 13so840760eye.17
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 13:10:37 -0700 (PDT)
Subject: Re: [PATCH 6/7] wl12xx: add ps completion event
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1305104068-32240-7-git-send-email-eliad@wizery.com>
References: <1305104068-32240-1-git-send-email-eliad@wizery.com>
	 <1305104068-32240-7-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 23:10:34 +0300
Message-ID: <1305231034.12586.1038.camel@cumari> (sfid-20110512_221042_399733_07EF6CF6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-11 at 11:54 +0300, Eliad Peller wrote:
> Signal when psm was entered successfully, if the completion
> variable is being set.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/event.c  |    7 +++++++
>  drivers/net/wireless/wl12xx/wl12xx.h |    1 +
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
> index ae69330..21e52ed 100644
> --- a/drivers/net/wireless/wl12xx/event.c
> +++ b/drivers/net/wireless/wl12xx/event.c
> @@ -135,6 +135,13 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
>  
>  		/* enable beacon early termination */
>  		ret = wl1271_acx_bet_enable(wl, true);
> +		if (ret < 0)
> +			break;
> +
> +		if (wl->ps_compl) {
> +			complete(wl->ps_compl);
> +			wl->ps_compl = NULL;
> +		}
>  		break;
>  	default:
>  		break;
> diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
> index daf941d..cf08a9d 100644
> --- a/drivers/net/wireless/wl12xx/wl12xx.h
> +++ b/drivers/net/wireless/wl12xx/wl12xx.h
> @@ -512,6 +512,7 @@ struct wl1271 {
>  	unsigned int rx_filter;
>  
>  	struct completion *elp_compl;
> +	struct completion *ps_compl;
>  	struct delayed_work elp_work;
>  	struct delayed_work pspoll_work;
>  

This patch doesn't make sense by itself, without the next one.  Can you
squash them?

-- 
Cheers,
Luca.

