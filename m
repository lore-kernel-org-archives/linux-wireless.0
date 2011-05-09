Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab1EISSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 14:18:18 -0400
Subject: Re: [PATCH] libertas: fix cmdpendingq locking
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org, pgf@laptop.org
Date: Mon, 09 May 2011 13:20:06 -0500
In-Reply-To: <20110509094042.39C2E9D401C@zog.reactivated.net>
References: <20110509094042.39C2E9D401C@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1304965208.5005.14.camel@dcbw.foobar.com> (sfid-20110509_201821_764834_9F576E94)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-09 at 10:40 +0100, Daniel Drake wrote:
> From: Paul Fox <pgf@laptop.org>
> 
> We occasionally see list corruption using libertas.
> 
> While we haven't been able to diagnose this precisely, we have spotted
> a possible cause: cmdpendingq is generally modified with driver_lock
> held. However, there are a couple of points where this is not the case.
> 
> Fix up those operations to execute under the lock, it seems like
> the correct thing to do and will hopefully improve the situation.
> 
> Signed-off-by: Paul Fox <pgf@laptop.org>
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Dan Williams <dcbw@redhat.com>

Also a candidate for stable@?

> ---
>  drivers/net/wireless/libertas/cmd.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> index 7e8a658..f3ac624 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -1339,8 +1339,8 @@ int lbs_execute_next_command(struct lbs_private *priv)
>  				    cpu_to_le16(PS_MODE_ACTION_EXIT_PS)) {
>  					lbs_deb_host(
>  					       "EXEC_NEXT_CMD: ignore ENTER_PS cmd\n");
> -					list_del(&cmdnode->list);
>  					spin_lock_irqsave(&priv->driver_lock, flags);
> +					list_del(&cmdnode->list);
>  					lbs_complete_command(priv, cmdnode, 0);
>  					spin_unlock_irqrestore(&priv->driver_lock, flags);
>  
> @@ -1352,8 +1352,8 @@ int lbs_execute_next_command(struct lbs_private *priv)
>  				    (priv->psstate == PS_STATE_PRE_SLEEP)) {
>  					lbs_deb_host(
>  					       "EXEC_NEXT_CMD: ignore EXIT_PS cmd in sleep\n");
> -					list_del(&cmdnode->list);
>  					spin_lock_irqsave(&priv->driver_lock, flags);
> +					list_del(&cmdnode->list);
>  					lbs_complete_command(priv, cmdnode, 0);
>  					spin_unlock_irqrestore(&priv->driver_lock, flags);
>  					priv->needtowakeup = 1;
> @@ -1366,7 +1366,9 @@ int lbs_execute_next_command(struct lbs_private *priv)
>  				       "EXEC_NEXT_CMD: sending EXIT_PS\n");
>  			}
>  		}
> +		spin_lock_irqsave(&priv->driver_lock, flags);
>  		list_del(&cmdnode->list);
> +		spin_unlock_irqrestore(&priv->driver_lock, flags);
>  		lbs_deb_host("EXEC_NEXT_CMD: sending command 0x%04x\n",
>  			    le16_to_cpu(cmd->command));
>  		lbs_submit_command(priv, cmdnode);


