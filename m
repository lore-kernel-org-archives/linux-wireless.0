Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933283AbYA2Nm0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 08:42:26 -0500
Subject: Re: [PATCH, take 2] libertas: trim overly long debug statement
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <200801290914.40188.hs4233@mail.mn-solutions.de>
References: <200801281725.13076.hs4233@mail.mn-solutions.de>
	 <1201538297.14441.3.camel@localhost.localdomain>
	 <200801290914.40188.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 08:33:43 -0500
Message-Id: <1201613623.32624.14.camel@localhost.localdomain> (sfid-20080129_134321_530097_E61A6B43)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-01-29 at 09:14 +0100, Holger Schurig wrote:
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
> 
> This time even checkpatch.pl clean. :-)
> 
> Index: wireless-2.6/drivers/net/wireless/libertas/cmd.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/cmd.c	2008-01-29 10:11:33.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/cmd.c	2008-01-29 10:11:59.000000000 +0100
> @@ -1182,9 +1182,9 @@ static void lbs_submit_command(struct lb
>  	    command == CMD_802_11_AUTHENTICATE)
>  		timeo = 10 * HZ;
>  
> -	lbs_deb_host("DNLD_CMD: command 0x%04x, seq %d, size %d, jiffies %lu\n",
> +	lbs_deb_cmd("DNLD_CMD: command 0x%04x, seq %d, size %d, jiffies %lu\n",
>  		     command, le16_to_cpu(cmd->seqnum), cmdsize, jiffies);
> -	lbs_deb_hex(LBS_DEB_HOST, "DNLD_CMD", (void *) cmdnode->cmdbuf, cmdsize);
> +	lbs_deb_hex(LBS_DEB_CMD, "DNLD_CMD", (void *) cmdnode->cmdbuf, cmdsize);
>  
>  	ret = priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) cmd, cmdsize);
>  
> @@ -1193,9 +1193,7 @@ static void lbs_submit_command(struct lb
>  		/* Let the timer kick in and retry, and potentially reset
>  		   the whole thing if the condition persists */
>  		timeo = HZ;
> -	} else
> -		lbs_deb_cmd("DNLD_CMD: sent command 0x%04x, jiffies %lu\n",
> -			    command, jiffies);
> +	}
>  
>  	/* Setup the timer after transmit command */
>  	mod_timer(&priv->command_timer, jiffies + timeo);
> @@ -1214,7 +1212,7 @@ static int lbs_cmd_mac_control(struct lb
>  	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_mac_control) + S_DS_GEN);
>  	mac->action = cpu_to_le16(priv->currentpacketfilter);
>  
> -	lbs_deb_cmd("MAC_CONTROL: action 0x%x, size %d\n",
> +	lbs_deb_cmd("MAC_CONTROL: action 0x%04x, size %d\n",
>  		    le16_to_cpu(mac->action), le16_to_cpu(cmd->size));
>  
>  	lbs_deb_leave(LBS_DEB_CMD);
> @@ -1766,9 +1764,9 @@ int lbs_execute_next_command(struct lbs_
>  	unsigned long flags;
>  	int ret = 0;
>  
> -	// Debug group is LBS_DEB_THREAD and not LBS_DEB_HOST, because the
> -	// only caller to us is lbs_thread() and we get even when a
> -	// data packet is received
> +	/* Debug group is LBS_DEB_THREAD and not LBS_DEB_HOST, because the
> +	 * only caller to us is lbs_thread() and we get even when a
> +	 * data packet is received */
>  	lbs_deb_enter(LBS_DEB_THREAD);
>  
>  	spin_lock_irqsave(&priv->driver_lock, flags);
> @@ -2068,15 +2066,8 @@ int lbs_cmd_copyback(struct lbs_private 
>  	struct cmd_header *buf = (void *)extra;
>  	uint16_t copy_len;
>  
> -	lbs_deb_enter(LBS_DEB_CMD);
> -
>  	copy_len = min(le16_to_cpu(buf->size), le16_to_cpu(resp->size));
> -	lbs_deb_cmd("Copying back %u bytes; command response was %u bytes, "
> -		    "copy back buffer was %u bytes\n", copy_len,
> -		    le16_to_cpu(resp->size), le16_to_cpu(buf->size));
>  	memcpy(buf, resp, copy_len);
> -
> -	lbs_deb_leave(LBS_DEB_CMD);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(lbs_cmd_copyback);
> Index: wireless-2.6/drivers/net/wireless/libertas/cmdresp.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/cmdresp.c	2008-01-29 10:11:33.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/cmdresp.c	2008-01-29 10:11:33.000000000 +0100
> @@ -509,9 +509,9 @@ int lbs_process_rx_command(struct lbs_pr
>  	respcmd = le16_to_cpu(resp->command);
>  	result = le16_to_cpu(resp->result);
>  
> -	lbs_deb_host("CMD_RESP: response 0x%04x, seq %d, size %d, jiffies %lu\n",
> +	lbs_deb_cmd("CMD_RESP: response 0x%04x, seq %d, size %d, jiffies %lu\n",
>  		     respcmd, le16_to_cpu(resp->seqnum), priv->upld_len, jiffies);
> -	lbs_deb_hex(LBS_DEB_HOST, "CMD_RESP", (void *) resp, priv->upld_len);
> +	lbs_deb_hex(LBS_DEB_CMD, "CMD_RESP", (void *) resp, priv->upld_len);
>  
>  	if (resp->seqnum != resp->seqnum) {
>  		lbs_pr_info("Received CMD_RESP with invalid sequence %d (expected %d)\n",

