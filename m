Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:60179 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757516AbXG1X6h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2007 19:58:37 -0400
Message-ID: <46ABD821.6060709@lwfinger.net>
Date: Sat, 28 Jul 2007 18:58:25 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
Subject: Re: bcm43xx-mac80211: a fix for the shared interrupt problem
References: <46aab9a4.pmEWFfaWaaFDLvZd%Larry.Finger@lwfinger.net> <200707281848.02554.mb@bu3sch.de> <46ABACC1.1020107@lwfinger.net> <200707290103.50077.mb@bu3sch.de>
In-Reply-To: <200707290103.50077.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> Ok, seems like we are missing some dummy reads to drain
> this IRQ. I'll look at this tomorrow.
> Thanks for tracking this down.

As we shouldn't get any interrupts until STAT_STARTED is reached, I wondered why interrupts were 
enabled so early. As far as I can tell, none of the steps from where interrupts are enabled to where 
STAT_STARTED is set depend on having them enabled; therefore, I tried a patch that delayed the 
enabling of interrupts until after we had reached STAT_STARTED. It works for all my systems.

I'm beginning to think that the shared interrupts have nothing to do with the problem, but it is 
more likely caused by peculiarities in the PCMCIA bridge in my ancient laptop.

Larry

Index: wireless-mb/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
===================================================================
--- wireless-mb.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
+++ wireless-mb/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
@@ -3014,13 +3014,13 @@ static int bcm43xx_wireless_core_start(s
  		       dev->dev->irq);
  		goto out;
  	}
-	bcm43xx_interrupt_enable(dev, dev->irq_savedstate);
  	bcm43xx_mac_enable(dev);

  	bcm43xx_periodic_tasks_setup(dev);

  	ieee80211_start_queues(dev->wl->hw);
  	bcm43xx_set_status(dev, BCM43xx_STAT_STARTED);
+	bcm43xx_interrupt_enable(dev, dev->irq_savedstate);
  	bcmdbg(dev->wl, "Wireless interface started\n");
  out:
  	return err;
