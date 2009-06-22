Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43402 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbZFVOsB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 10:48:01 -0400
Subject: Re: [PATCH] libertas: fix card cleanup order in SDIO driver
From: Dan Williams <dcbw@redhat.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <1245291319-26118-1-git-send-email-andrey@cozybit.com>
References: <1245291319-26118-1-git-send-email-andrey@cozybit.com>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 10:48:02 -0400
Message-Id: <1245682082.4338.25.camel@dhcp-100-3-98.bos.redhat.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-06-17 at 19:15 -0700, Andrey Yurovsky wrote:
> The SDIO driver sets the surpriseremoved flag before calling
> lbs_remove_card.  With IEEE PS enabled, lbs_remove_card must issue a
> command to exit IEEE PS mode, however with that flag set the command
> path is blocked and the card is never taken out of IEEE PS mode.  This
> step is required to ensure that the driver can be reloaded.  This patch
> moves the setting of surpriseremoved after lbs_remove_card is called.
> 
> Tested with V9 firmware by ensuring that IEEE PS is disabled when the
> driver is removed.  Reloading the driver is not fully tested due to a
> separate issue with module reload in the SDIO driver, however this
> patch at least leaves the card in a better state when we bring the
> driver down.
> 
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_sdio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> index 8cdb88c..d48ed62 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c
> @@ -1096,11 +1096,11 @@ static void if_sdio_remove(struct sdio_func *func)
>  			lbs_pr_alert("CMD_FUNC_SHUTDOWN cmd failed\n");
>  	}
>  
> -	card->priv->surpriseremoved = 1;
>  
>  	lbs_deb_sdio("call remove card\n");
>  	lbs_stop_card(card->priv);
>  	lbs_remove_card(card->priv);
> +	card->priv->surpriseremoved = 1;
>  
>  	flush_workqueue(card->workqueue);
>  	destroy_workqueue(card->workqueue);

