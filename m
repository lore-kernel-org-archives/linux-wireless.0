Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757644AbYC0VZb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 17:25:31 -0400
Subject: Re: [PATCH] libertas: convert sleep/wake config direct commands
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803261322.11647.hs4233@mail.mn-solutions.de>
References: <200803261322.11647.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 17:24:16 -0400
Message-Id: <1206653056.21106.12.camel@localhost.localdomain> (sfid-20080327_212533_384320_93F8E257)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-26 at 13:22 +0100, Holger Schurig wrote:
> Confirm sleep event: they come very regularly, eventually several times per
> second. Therefore we want to send the config command as fast as possible.
> The old code pre-set the command in priv->lbs_ps_confirm_sleep. However, the
> byte sequence to be sent to the hardware is the same for all interfaces. So
> this patch make this an extern structure, initialized at module load time.
> 
> Config wake event: normal conversion to a direct command. However, I don't know
> how to trigger a "HOST AWAKE" event from the firmware, so this part is
> untested.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-testing/drivers/net/wireless/libertas/dev.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/dev.h	2008-03-26 09:48:57.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/dev.h	2008-03-26 10:34:15.000000000 +0100
> @@ -267,9 +267,6 @@ struct lbs_private {
>  	char ps_supported;
>  	u8 needtowakeup;
>  
> -	struct PS_CMD_ConfirmSleep lbs_ps_confirm_sleep;
> -	struct cmd_header lbs_ps_confirm_wake;
> -
>  	struct assoc_request * pending_assoc_req;
>  	struct assoc_request * in_progress_assoc_req;
>  
> @@ -326,6 +323,8 @@ struct lbs_private {
>  	u8 fw_ready;
>  };
>  
> +extern struct cmd_confirm_sleep confirm_sleep;
> +
>  /** Association request
>   *
>   * Encapsulates all the options that describe a specific assocation request
> Index: wireless-testing/drivers/net/wireless/libertas/cmdresp.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c	2008-03-26 09:50:36.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c	2008-03-26 10:43:03.000000000 +0100
> @@ -548,21 +548,20 @@ done:
>  
>  static int lbs_send_confirmwake(struct lbs_private *priv)
>  {
> -	struct cmd_header *cmd = &priv->lbs_ps_confirm_wake;
> +	struct cmd_header cmd;
>  	int ret = 0;
>  
>  	lbs_deb_enter(LBS_DEB_HOST);
>  
> -	cmd->command = cpu_to_le16(CMD_802_11_WAKEUP_CONFIRM);
> -	cmd->size = cpu_to_le16(sizeof(*cmd));
> -	cmd->seqnum = cpu_to_le16(++priv->seqnum);
> -	cmd->result = 0;
> -
> -	lbs_deb_host("SEND_WAKEC_CMD: before download\n");
> +	cmd.command = cpu_to_le16(CMD_802_11_WAKEUP_CONFIRM);
> +	cmd.size = cpu_to_le16(sizeof(cmd));
> +	cmd.seqnum = cpu_to_le16(++priv->seqnum);
> +	cmd.result = 0;
>  
> -	lbs_deb_hex(LBS_DEB_HOST, "wake confirm command", (void *)cmd, sizeof(*cmd));
> +	lbs_deb_hex(LBS_DEB_HOST, "wake confirm", (u8 *) &cmd,
> +		sizeof(cmd));
>  
> -	ret = priv->hw_host_to_card(priv, MVMS_CMD, (void *)cmd, sizeof(*cmd));
> +	ret = priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) &cmd, sizeof(cmd));
>  	if (ret)
>  		lbs_pr_alert("SEND_WAKEC_CMD: Host to Card failed for Confirm Wake\n");
>  
> Index: wireless-testing/drivers/net/wireless/libertas/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-03-26 09:54:52.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-03-26 10:31:56.000000000 +0100
> @@ -37,6 +37,11 @@ EXPORT_SYMBOL_GPL(lbs_debug);
>  module_param_named(libertas_debug, lbs_debug, int, 0644);
>  
> 
> +/* This global structure is used to send the confirm_sleep command as
> + * fast as possible down to the firmware. */
> +struct cmd_confirm_sleep confirm_sleep;
> +
> +
>  #define LBS_TX_PWR_DEFAULT		20	/*100mW */
>  #define LBS_TX_PWR_US_DEFAULT		20	/*100mW */
>  #define LBS_TX_PWR_JP_DEFAULT		16	/*50mW */
> @@ -1013,14 +1018,6 @@ static int lbs_init_adapter(struct lbs_p
>  			      &priv->network_free_list);
>  	}
>  
> -	priv->lbs_ps_confirm_sleep.seqnum = cpu_to_le16(++priv->seqnum);
> -	priv->lbs_ps_confirm_sleep.command =
> -	    cpu_to_le16(CMD_802_11_PS_MODE);
> -	priv->lbs_ps_confirm_sleep.size =
> -	    cpu_to_le16(sizeof(struct PS_CMD_ConfirmSleep));
> -	priv->lbs_ps_confirm_sleep.action =
> -	    cpu_to_le16(CMD_SUBCMD_SLEEP_CONFIRMED);
> -
>  	memset(priv->current_addr, 0xff, ETH_ALEN);
>  
>  	priv->connect_status = LBS_DISCONNECTED;
> @@ -1462,6 +1459,10 @@ EXPORT_SYMBOL_GPL(lbs_interrupt);
>  static int __init lbs_init_module(void)
>  {
>  	lbs_deb_enter(LBS_DEB_MAIN);
> +	memset(&confirm_sleep, 0, sizeof(confirm_sleep));
> +	confirm_sleep.hdr.command = cpu_to_le16(CMD_802_11_PS_MODE);
> +	confirm_sleep.hdr.size = cpu_to_le16(sizeof(confirm_sleep));
> +	confirm_sleep.action = cpu_to_le16(CMD_SUBCMD_SLEEP_CONFIRMED);
>  	lbs_debugfs_init();
>  	lbs_deb_leave(LBS_DEB_MAIN);
>  	return 0;
> Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-26 09:55:48.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-26 10:38:09.000000000 +0100
> @@ -1802,38 +1802,27 @@ void lbs_send_iwevcustom_event(struct lb
>  	lbs_deb_leave(LBS_DEB_WEXT);
>  }
>  
> -static int sendconfirmsleep(struct lbs_private *priv, u8 *cmdptr, u16 size)
> +static void lbs_send_confirmsleep(struct lbs_private *priv)
>  {
>  	unsigned long flags;
> -	int ret = 0;
> +	int ret;
>  
>  	lbs_deb_enter(LBS_DEB_HOST);
> -	lbs_deb_hex(LBS_DEB_HOST, "sleep confirm command", cmdptr, size);
> -
> -	ret = priv->hw_host_to_card(priv, MVMS_CMD, cmdptr, size);
> +	lbs_deb_hex(LBS_DEB_HOST, "sleep confirm", (u8 *) &confirm_sleep,
> +		sizeof(confirm_sleep));
>  
> -	spin_lock_irqsave(&priv->driver_lock, flags);
> -	if (priv->intcounter || priv->currenttxskb)
> -		lbs_deb_host("SEND_SLEEPC_CMD: intcounter %d, currenttxskb %p\n",
> -		       priv->intcounter, priv->currenttxskb);
> -	spin_unlock_irqrestore(&priv->driver_lock, flags);
> +	ret = priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) &confirm_sleep,
> +		sizeof(confirm_sleep));
>  
>  	if (ret) {
> -		lbs_pr_alert(
> -		       "SEND_SLEEPC_CMD: Host to Card failed for Confirm Sleep\n");
> +		lbs_pr_alert("confirm_sleep failed\n");
>  	} else {
>  		spin_lock_irqsave(&priv->driver_lock, flags);
> -		if (!priv->intcounter) {
> +		if (!priv->intcounter)
>  			priv->psstate = PS_STATE_SLEEP;
> -		} else {
> -			lbs_deb_host("SEND_SLEEPC_CMD: after sent, intcounter %d\n",
> -			       priv->intcounter);
> -		}
>  		spin_unlock_irqrestore(&priv->driver_lock, flags);
>  	}
> -
> -	lbs_deb_leave_args(LBS_DEB_HOST, "ret %d", ret);
> -	return ret;
> +	lbs_deb_leave(LBS_DEB_HOST);
>  }
>  
>  void lbs_ps_sleep(struct lbs_private *priv, int wait_option)
> @@ -1906,8 +1895,7 @@ void lbs_ps_confirm_sleep(struct lbs_pri
>  
>  	if (allowed) {
>  		lbs_deb_host("sending lbs_ps_confirm_sleep\n");
> -		sendconfirmsleep(priv, (u8 *) & priv->lbs_ps_confirm_sleep,
> -				 sizeof(struct PS_CMD_ConfirmSleep));
> +		lbs_send_confirmsleep(priv);
>  	} else {
>  		lbs_deb_host("sleep confirm has been delayed\n");
>  	}
> Index: wireless-testing/drivers/net/wireless/libertas/hostcmd.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/hostcmd.h	2008-03-26 10:02:54.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/hostcmd.h	2008-03-26 10:05:20.000000000 +0100
> @@ -480,14 +480,11 @@ struct cmd_ds_802_11_ps_mode {
>  	__le16 locallisteninterval;
>  };
>  
> -struct PS_CMD_ConfirmSleep {
> -	__le16 command;
> -	__le16 size;
> -	__le16 seqnum;
> -	__le16 result;
> +struct cmd_confirm_sleep {
> +	struct cmd_header hdr;
>  
>  	__le16 action;
> -	__le16 reserved1;
> +	__le16 nullpktinterval;
>  	__le16 multipledtim;
>  	__le16 reserved;
>  	__le16 locallisteninterval;

