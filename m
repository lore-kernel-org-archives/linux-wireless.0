Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbZJPQ32 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 12:29:28 -0400
Subject: Re: [PATCH] libertas: remove unused
 lbs_cmd_802_11_inactivity_timeout()
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200910161734.22840.hs4233@mail.mn-solutions.de>
References: <200910161734.22840.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 16 Oct 2009 09:29:31 -0700
Message-Id: <1255710571.14241.30.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-10-16 at 17:34 +0200, Holger Schurig wrote:
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

We were going to use this at one point, but we haven't yet, so we can
add it back when we do.

Acked-by: Dan Williams <dcbw@redhat.com>

> --- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
> +++ linux-wl/drivers/net/wireless/libertas/cmd.c
> @@ -273,33 +273,6 @@
>  	return 0;
>  }
>  
> -int lbs_cmd_802_11_inactivity_timeout(struct lbs_private *priv,
> -				      uint16_t cmd_action, uint16_t *timeout)
> -{
> -	struct cmd_ds_802_11_inactivity_timeout cmd;
> -	int ret;
> -
> -	lbs_deb_enter(LBS_DEB_CMD);
> -
> -	cmd.hdr.command = cpu_to_le16(CMD_802_11_INACTIVITY_TIMEOUT);
> -	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
> -
> -	cmd.action = cpu_to_le16(cmd_action);
> -
> -	if (cmd_action == CMD_ACT_SET)
> -		cmd.timeout = cpu_to_le16(*timeout);
> -	else
> -		cmd.timeout = 0;
> -
> -	ret = lbs_cmd_with_response(priv, CMD_802_11_INACTIVITY_TIMEOUT, &cmd);
> -
> -	if (!ret)
> -		*timeout = le16_to_cpu(cmd.timeout);
> -
> -	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
> -	return 0;
> -}
> -
>  int lbs_cmd_802_11_sleep_params(struct lbs_private *priv, uint16_t cmd_action,
>  				struct sleep_params *sp)
>  {
> --- linux-wl.orig/drivers/net/wireless/libertas/cmd.h
> +++ linux-wl/drivers/net/wireless/libertas/cmd.h
> @@ -135,9 +135,6 @@
>  int lbs_cmd_802_11_rate_adapt_rateset(struct lbs_private *priv,
>  				      uint16_t cmd_action);
>  
> -int lbs_cmd_802_11_inactivity_timeout(struct lbs_private *priv,
> -				      uint16_t cmd_action, uint16_t *timeout);
> -
>  int lbs_cmd_802_11_set_wep(struct lbs_private *priv, uint16_t cmd_action,
>  			   struct assoc_request *assoc);
>  
> --- linux-wl.orig/drivers/net/wireless/libertas/host.h
> +++ linux-wl/drivers/net/wireless/libertas/host.h
> @@ -621,16 +621,6 @@
>  	__le16 reserved;
>  } __attribute__ ((packed));
>  
> -struct cmd_ds_802_11_inactivity_timeout {
> -	struct cmd_header hdr;
> -
> -	/* ACT_GET/ACT_SET */
> -	__le16 action;
> -
> -	/* Inactivity timeout in msec */
> -	__le16 timeout;
> -} __attribute__ ((packed));
> -
>  struct cmd_ds_802_11_rf_channel {
>  	struct cmd_header hdr;
>  
> 

