Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab0LIQTK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 11:19:10 -0500
Subject: Re: [PATCH] libertas: fix potential NULL-pointer dereference
From: Dan Williams <dcbw@redhat.com>
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 09 Dec 2010 10:18:52 -0600
In-Reply-To: <1291883916.1924.0.camel@sven>
References: <1291883916.1924.0.camel@sven>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1291911533.11613.0.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-09 at 09:38 +0100, Sven Neumann wrote:
> The code wants to check if there's a channel and it is not disabled,
> but it used to check if channel is not NULL and accessed the channel
> struct if this check failed.
> 
> Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/cfg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
> index 373930a..113f4f2 100644
> --- a/drivers/net/wireless/libertas/cfg.c
> +++ b/drivers/net/wireless/libertas/cfg.c
> @@ -619,7 +619,7 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
>  				     print_ssid(ssid_buf, ssid, ssid_len),
>  				     LBS_SCAN_RSSI_TO_MBM(rssi)/100);
>  
> -			if (channel ||
> +			if (channel &&
>  			    !(channel->flags & IEEE80211_CHAN_DISABLED))
>  				cfg80211_inform_bss(wiphy, channel,
>  					bssid, le64_to_cpu(*(__le64 *)tsfdesc),


