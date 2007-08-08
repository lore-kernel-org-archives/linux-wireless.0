Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33345 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667AbXHHW0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 18:26:44 -0400
Date: Wed, 8 Aug 2007 15:26:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: arm allmodconfig
Message-Id: <20070808152606.9ea3010f.akpm@linux-foundation.org>
In-Reply-To: <200708090013.06846.mb@bu3sch.de>
References: <20070808145705.756597b0.akpm@linux-foundation.org>
	<200708090013.06846.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 9 Aug 2007 00:13:06 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> On Wednesday 08 August 2007 23:57:05 Andrew Morton wrote:
> > drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c:4038: error: implicit declaration of function `ssb_pcihost_register'
> > drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c:4055: error: implicit declaration of function `ssb_pcihost_unregister'
> 
> I have no idea how this is possible.

tee hee

> 	select SSB_PCIHOST
> 	select SSB_DRIVER_PCICORE

You used select.  Anything is possible with select.

You can do the below without an arm toolchain:

setenv arch ARM
make mrproper
make allmodconfig
akpm:/usr/src/25> grep BCM .config 
CONFIG_BT_HCIBCM203X=m
CONFIG_BCM43XX=m
CONFIG_BCM43XX_DEBUG=y
CONFIG_BCM43XX_DMA=y
CONFIG_BCM43XX_PIO=y
CONFIG_BCM43XX_DMA_AND_PIO_MODE=y
# CONFIG_BCM43XX_DMA_MODE is not set
# CONFIG_BCM43XX_PIO_MODE is not set
CONFIG_BCM43XX_MAC80211=m
CONFIG_BCM43XX_MAC80211_PCI=y
CONFIG_BCM43XX_MAC80211_PCMCIA=y
CONFIG_BCM43XX_MAC80211_DEBUG=y
CONFIG_BCM43XX_MAC80211_DMA=y
CONFIG_BCM43XX_MAC80211_PIO=y
CONFIG_BCM43XX_MAC80211_DMA_AND_PIO_MODE=y
# CONFIG_BCM43XX_MAC80211_DMA_MODE is not set
# CONFIG_BCM43XX_MAC80211_PIO_MODE is not set
CONFIG_DVB_BCM3510=m
akpm:/usr/src/25> grep SSB .config
akpm:/usr/src/25> 

> So what is going on? CONFIG_BCM43XX_MAC80211_PCI must be enabled.
> Otherwise the func call would be ifdef'ed out. So but if
> it is enabled, it would SELECT SSB_PCIHOST. Which would enable
> the declaration and definition of ssb_pcihost_register().
> What am I missing?

Just stop using select.   It's busted.
