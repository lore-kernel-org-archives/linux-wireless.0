Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58212
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763502AbXHFMKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 08:10:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx-mac80211: Fix regression in interrupt handling
Date: Mon, 6 Aug 2007 14:10:40 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46b68ec8.nObKM6TauxkzJMGV%Larry.Finger@lwfinger.net>
In-Reply-To: <46b68ec8.nObKM6TauxkzJMGV%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708061410.40506.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 August 2007, Larry Finger wrote:
> Since commit 85a83d26697dd2203ac4e5f33022951f2c3e6e33, "bcm43xx-mac80211:
> Rewrite and simplify handling of the initialization status", some PCI
> adapters have problems due to interrupts happening before the device status
> reaches BCM43xx_STARTED. This patch delays the initial interrupt enable until
> after the device status is set.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> This patch fixes a regression since 2.6.23-rc1. Michael and I have discussed this
> and he has agreed that this is the proper fix.
> 
> Larry
> 
>  bcm43xx_main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
> ===================================================================
> --- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
> +++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
> @@ -3014,13 +3014,13 @@ static int bcm43xx_wireless_core_start(s
>  		       dev->dev->irq);
>  		goto out;
>  	}
> -	bcm43xx_interrupt_enable(dev, dev->irq_savedstate);
>  	bcm43xx_mac_enable(dev);
>  
>  	bcm43xx_periodic_tasks_setup(dev);
>  
>  	ieee80211_start_queues(dev->wl->hw);
>  	bcm43xx_set_status(dev, BCM43xx_STAT_STARTED);
> +	bcm43xx_interrupt_enable(dev, dev->irq_savedstate);
>  	bcmdbg(dev->wl, "Wireless interface started\n");
>  out:
>  	return err;

Queued into my patch series, thanks.
