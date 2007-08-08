Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57322
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbXHHWik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 18:38:40 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: arm allmodconfig
Date: Thu, 9 Aug 2007 00:38:05 +0200
Cc: linux-wireless@vger.kernel.org
References: <20070808145705.756597b0.akpm@linux-foundation.org> <200708090013.06846.mb@bu3sch.de> <20070808152606.9ea3010f.akpm@linux-foundation.org>
In-Reply-To: <20070808152606.9ea3010f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708090038.05320.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 09 August 2007 00:26:06 Andrew Morton wrote:
> On Thu, 9 Aug 2007 00:13:06 +0200
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > On Wednesday 08 August 2007 23:57:05 Andrew Morton wrote:
> > > drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c:4038: error: implicit declaration of function `ssb_pcihost_register'
> > > drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c:4055: error: implicit declaration of function `ssb_pcihost_unregister'
> > 
> > I have no idea how this is possible.
> 
> tee hee
> 
> > 	select SSB_PCIHOST
> > 	select SSB_DRIVER_PCICORE
> 
> You used select.  Anything is possible with select.
> 
> You can do the below without an arm toolchain:
> 
> setenv arch ARM
> make mrproper
> make allmodconfig
> akpm:/usr/src/25> grep BCM .config 
> CONFIG_BT_HCIBCM203X=m
> CONFIG_BCM43XX=m
> CONFIG_BCM43XX_DEBUG=y
> CONFIG_BCM43XX_DMA=y
> CONFIG_BCM43XX_PIO=y
> CONFIG_BCM43XX_DMA_AND_PIO_MODE=y
> # CONFIG_BCM43XX_DMA_MODE is not set
> # CONFIG_BCM43XX_PIO_MODE is not set
> CONFIG_BCM43XX_MAC80211=m
> CONFIG_BCM43XX_MAC80211_PCI=y
> CONFIG_BCM43XX_MAC80211_PCMCIA=y
> CONFIG_BCM43XX_MAC80211_DEBUG=y
> CONFIG_BCM43XX_MAC80211_DMA=y
> CONFIG_BCM43XX_MAC80211_PIO=y
> CONFIG_BCM43XX_MAC80211_DMA_AND_PIO_MODE=y
> # CONFIG_BCM43XX_MAC80211_DMA_MODE is not set
> # CONFIG_BCM43XX_MAC80211_PIO_MODE is not set
> CONFIG_DVB_BCM3510=m
> akpm:/usr/src/25> grep SSB .config
> akpm:/usr/src/25> 
> 
> > So what is going on? CONFIG_BCM43XX_MAC80211_PCI must be enabled.
> > Otherwise the func call would be ifdef'ed out. So but if
> > it is enabled, it would SELECT SSB_PCIHOST. Which would enable
> > the declaration and definition of ssb_pcihost_register().
> > What am I missing?
> 
> Just stop using select.   It's busted.

Ok, I have no problem with that. BUT my users and other people
in the kernel community do certainly have. Nobody will find
the bcm43xx option anymore, if we depend on SSB.
I mean, people do even seriously complain about the filenames
of the firmware and so on.
So adding a dep on SSB would generate about 3 to 4
bugreports each day, I'd say from experience.

So, once you suggested that menuconfig should be changed to
show options "greyed out" when deps are not met. Are there
any patches available? Any starting point?

-- 
Greetings Michael.
