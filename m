Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab0FWXYh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 19:24:37 -0400
Subject: Re: [PATCH 2/3] libertas: unmangle capability value
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, dkiran@marvell.com,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1277303846-17257-2-git-send-email-linville@tuxdriver.com>
References: <1277281556.3642.6.camel@jlt3.sipsolutions.net>
	 <1277303846-17257-2-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Jun 2010 16:24:49 -0700
Message-ID: <1277335489.25126.30.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-23 at 10:37 -0400, John W. Linville wrote:
> Address fall-out from patch converting libertas to use cfg80211...
> 
> +drivers/net/wireless/libertas/cfg.c:1844:13: warning: incorrect type in assignment (different base types)
> +drivers/net/wireless/libertas/cfg.c:1844:13:    expected unsigned short [unsigned] [usertype] capability
> +drivers/net/wireless/libertas/cfg.c:1844:13:    got restricted __le16 [usertype] <noident>
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/cfg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
> index 23c1dc6..f36cc97 100644
> --- a/drivers/net/wireless/libertas/cfg.c
> +++ b/drivers/net/wireless/libertas/cfg.c
> @@ -1841,7 +1841,7 @@ static int lbs_ibss_start_new(struct lbs_private *priv,
>  	if (MRVL_FW_MAJOR_REV(priv->fwrelease) <= 8)
>  		cmd.probedelay = cpu_to_le16(CMD_SCAN_PROBE_DELAY_TIME);
>  	/* TODO: mix in WLAN_CAPABILITY_PRIVACY */
> -	capability = cpu_to_le16(WLAN_CAPABILITY_IBSS);
> +	capability = WLAN_CAPABILITY_IBSS;
>  	cmd.capability = cpu_to_le16(capability);
>  	lbs_add_rates(cmd.rates);
>  


