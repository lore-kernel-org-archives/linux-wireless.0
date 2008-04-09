Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbYDIQUi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 12:20:38 -0400
Subject: Re: [PATCH] libertas: un-garbage various command structs
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200804091023.31707.hs4233@mail.mn-solutions.de>
References: <200804091023.31707.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 12:13:13 -0400
Message-Id: <1207757593.31194.4.camel@localhost.localdomain> (sfid-20080409_172042_480721_AD0B205D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-09 at 10:23 +0200, Holger Schurig wrote:
> Some command structs contain reserved or unused fields, which the driver
> send uninitialized down to the card.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-04-08 18:45:29.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-04-08 20:05:11.000000000 +0200
> @@ -296,6 +296,7 @@ int lbs_cmd_802_11_set_wep(struct lbs_pr
>  
>  	lbs_deb_enter(LBS_DEB_CMD);
>  
> +	memset(&cmd, 0, sizeof(cmd));
>  	cmd.hdr.command = cpu_to_le16(CMD_802_11_SET_WEP);
>  	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
>  
> @@ -359,7 +360,9 @@ int lbs_cmd_802_11_enable_rsn(struct lbs
>  	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
>  	cmd.action = cpu_to_le16(cmd_action);
>  
> -	if (cmd_action == CMD_ACT_SET) {
> +	if (cmd_action == CMD_ACT_GET)
> +		cmd.enable = 0;
> +	else {
>  		if (*enable)
>  			cmd.enable = cpu_to_le16(CMD_ENABLE_RSN);
>  		else
> @@ -811,6 +814,7 @@ int lbs_get_channel(struct lbs_private *
>  
>  	lbs_deb_enter(LBS_DEB_CMD);
>  
> +	memset(&cmd, 0, sizeof(cmd));
>  	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
>  	cmd.action = cpu_to_le16(CMD_OPT_802_11_RF_CHANNEL_GET);
>  
> @@ -858,6 +862,7 @@ int lbs_set_channel(struct lbs_private *
>  
>  	lbs_deb_enter(LBS_DEB_CMD);
>  
> +	memset(&cmd, 0, sizeof(cmd));
>  	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
>  	cmd.action = cpu_to_le16(CMD_OPT_802_11_RF_CHANNEL_SET);
>  	cmd.channel = cpu_to_le16(channel);

