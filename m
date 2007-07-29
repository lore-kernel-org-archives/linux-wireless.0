Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59521
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676AbXG2IyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2007 04:54:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: bcm43xx-mac80211: a fix for the shared interrupt problem
Date: Sun, 29 Jul 2007 10:54:12 +0200
Cc: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
References: <46aab9a4.pmEWFfaWaaFDLvZd%Larry.Finger@lwfinger.net> <200707290103.50077.mb@bu3sch.de> <46ABD821.6060709@lwfinger.net>
In-Reply-To: <46ABD821.6060709@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707291054.12853.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 29 July 2007 01:58, Larry Finger wrote:
> Michael Buesch wrote:
> > 
> > Ok, seems like we are missing some dummy reads to drain
> > this IRQ. I'll look at this tomorrow.
> > Thanks for tracking this down.
> 
> As we shouldn't get any interrupts until STAT_STARTED is reached, I wondered why interrupts were 
> enabled so early. As far as I can tell, none of the steps from where interrupts are enabled to where 
> STAT_STARTED is set depend on having them enabled; therefore, I tried a patch that delayed the 
> enabling of interrupts until after we had reached STAT_STARTED. It works for all my systems.
> 
> I'm beginning to think that the shared interrupts have nothing to do with the problem, but it is 
> more likely caused by peculiarities in the PCMCIA bridge in my ancient laptop.
> 
> Larry
> 
> Index: wireless-mb/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
> ===================================================================
> --- wireless-mb.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
> +++ wireless-mb/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
> @@ -3014,13 +3014,13 @@ static int bcm43xx_wireless_core_start(s
>   		       dev->dev->irq);
>   		goto out;
>   	}
> -	bcm43xx_interrupt_enable(dev, dev->irq_savedstate);
>   	bcm43xx_mac_enable(dev);
> 
>   	bcm43xx_periodic_tasks_setup(dev);
> 
>   	ieee80211_start_queues(dev->wl->hw);
>   	bcm43xx_set_status(dev, BCM43xx_STAT_STARTED);
> +	bcm43xx_interrupt_enable(dev, dev->irq_savedstate);
>   	bcmdbg(dev->wl, "Wireless interface started\n");
>   out:
>   	return err;
> 

Yes, that seems to be the correct fix.
Thanks.
