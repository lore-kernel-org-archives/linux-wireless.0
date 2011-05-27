Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab1E0OwG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 10:52:06 -0400
Subject: Re: [PATCH] libertas: Set command sequence number later to ensure
 consistency
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Date: Fri, 27 May 2011 09:53:50 -0500
In-Reply-To: <20110526203108.ADEDB9D401C@zog.reactivated.net>
References: <20110526203108.ADEDB9D401C@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1306508032.22126.3.camel@dcbw.foobar.com> (sfid-20110527_165218_351919_CB8A3F1C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-26 at 21:31 +0100, Daniel Drake wrote:
> Before this patch, the command sequence number is being set before
> lbs_queue_cmd() adds the command to the queue. However, lbs_queue_cmd()
> sometimes forces commands to queue-jump (e.g. CMD_802_11_WAKEUP_CONFIRM).
> It currently does this without considering that sequence numbers might need
> adjusting to keep things running in order.
> 
> Fix this by setting the sequence number at a later stage, just before
> we're actually submitting the command to the hardware. Also fixes a
> possible race where seqnum was being modified outside of the driver
> lock.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/cmd.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> index 84566db..71c8f3f 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -994,6 +994,8 @@ static void lbs_submit_command(struct lbs_private *priv,
>  	cmd = cmdnode->cmdbuf;
>  
>  	spin_lock_irqsave(&priv->driver_lock, flags);
> +	priv->seqnum++;
> +	cmd->seqnum = cpu_to_le16(priv->seqnum);
>  	priv->cur_cmd = cmdnode;
>  	spin_unlock_irqrestore(&priv->driver_lock, flags);
>  
> @@ -1621,11 +1623,9 @@ struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv,
>  	/* Copy the incoming command to the buffer */
>  	memcpy(cmdnode->cmdbuf, in_cmd, in_cmd_size);
>  
> -	/* Set sequence number, clean result, move to buffer */
> -	priv->seqnum++;
> +	/* Set command, clean result, move to buffer */
>  	cmdnode->cmdbuf->command = cpu_to_le16(command);
>  	cmdnode->cmdbuf->size    = cpu_to_le16(in_cmd_size);
> -	cmdnode->cmdbuf->seqnum  = cpu_to_le16(priv->seqnum);
>  	cmdnode->cmdbuf->result  = 0;
>  
>  	lbs_deb_host("PREP_CMD: command 0x%04x\n", command);


