Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58219
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763583AbXHFMK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 08:10:58 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] bcm43xx-mac80211: Rescale link quality output
Date: Mon, 6 Aug 2007 14:10:54 +0200
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46b57c5f.7s2ojiPQUXY5R3Qv%Larry.Finger@lwfinger.net>
In-Reply-To: <46b57c5f.7s2ojiPQUXY5R3Qv%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708061410.54552.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 05 August 2007, Larry Finger wrote:
> The link quality output from wireless extensions is too small by the ratio
> of 100/BCM43xx_RX_MAX_SSI (60) for bcm43xx-mac80211. This patch puts the
> quantity on the proper scale.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_xmit.c
> ===================================================================
> --- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_xmit.c
> +++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_xmit.c
> @@ -537,7 +537,8 @@ void bcm43xx_rx(struct bcm43xx_wldev *de
>  					      (phystat0 & BCM43xx_RX_PHYST0_GAINCTL),
>  					      (phystat3 & BCM43xx_RX_PHYST3_TRSTATE));
>  	status.noise = dev->stats.link_noise;
> -	status.signal = jssi; /* this looks wrong, but is what mac80211 wants */
> +	/* the next line looks wrong, but is what mac80211 wants */
> +	status.signal = (jssi * 100) / BCM43xx_RX_MAX_SSI;
>  	if (phystat0 & BCM43xx_RX_PHYST0_OFDM)
>  		status.rate = bcm43xx_plcp_get_bitrate_ofdm(plcp);
>  	else
> 
> 

Queued into my patch series, thanks.
