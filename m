Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35809
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXFVJdH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 05:33:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: kill antenna select ioctls
Date: Fri, 22 Jun 2007 11:32:29 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1182499821.21939.62.camel@johannes.berg>
In-Reply-To: <1182499821.21939.62.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200706221132.30211.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 22 June 2007 10:10:20 Johannes Berg wrote:
> Not used anywhere.

It's used in bcm43xx.
Though, I'm not sure anybody in userspace actually calls this strange ioctl.


> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> ---
>  net/mac80211/hostapd_ioctl.h   |    2 --
>  net/mac80211/ieee80211_ioctl.c |   20 --------------------
>  2 files changed, 22 deletions(-)
> 
> --- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-06-22 10:08:24.558632620 +0200
> +++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-06-22 10:08:56.158632620 +0200
> @@ -31,8 +31,6 @@ enum {
>  	PRISM2_PARAM_HOST_ENCRYPT = 17,
>  	PRISM2_PARAM_HOST_DECRYPT = 18,
>  	PRISM2_PARAM_IEEE_802_1X = 23,
> -	PRISM2_PARAM_ANTSEL_TX = 24,
> -	PRISM2_PARAM_ANTSEL_RX = 25,
>  
>  	/* Instant802 additions */
>  	PRISM2_PARAM_CTS_PROTECT_ERP_FRAMES = 1001,
> --- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-06-22 10:08:59.318632620 +0200
> +++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-06-22 10:09:10.418632620 +0200
> @@ -2167,18 +2167,6 @@ static int ieee80211_ioctl_prism2_param(
>  			sdata->ieee802_1x = value;
>  		break;
>  
> -	case PRISM2_PARAM_ANTSEL_TX:
> -		local->hw.conf.antenna_sel_tx = value;
> -		if (ieee80211_hw_config(local))
> -			ret = -EINVAL;
> -		break;
> -
> -	case PRISM2_PARAM_ANTSEL_RX:
> -		local->hw.conf.antenna_sel_rx = value;
> -		if (ieee80211_hw_config(local))
> -			ret = -EINVAL;
> -		break;
> -
>  	case PRISM2_PARAM_CTS_PROTECT_ERP_FRAMES:
>  		local->cts_protect_erp_frames = value;
>  		break;
> @@ -2377,14 +2365,6 @@ static int ieee80211_ioctl_get_prism2_pa
>  		*param = sdata->ieee802_1x;
>  		break;
>  
> -	case PRISM2_PARAM_ANTSEL_TX:
> -		*param = local->hw.conf.antenna_sel_tx;
> -		break;
> -
> -	case PRISM2_PARAM_ANTSEL_RX:
> -		*param = local->hw.conf.antenna_sel_rx;
> -		break;
> -
>  	case PRISM2_PARAM_CTS_PROTECT_ERP_FRAMES:
>  		*param = local->cts_protect_erp_frames;
>  		break;
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



-- 
Greetings Michael.
