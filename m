Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59835
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbXCEKM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 05:12:29 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Miles Lane" <miles.lane@gmail.com>
Subject: Re: 2.6.21-rc2-mm1 -- WARNING: "pcmcia_access_configuration_register" [drivers/ssb/ssb.ko] undefined!
Date: Mon, 5 Mar 2007 11:11:29 +0100
Cc: "Andrew Morton" <akpm@osdl.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org,
	"Michael Buesch" <mbuesch@freenet.de>
References: <a44ae5cd0703042021o434e42b1vea6fd90376824917@mail.gmail.com>
In-Reply-To: <a44ae5cd0703042021o434e42b1vea6fd90376824917@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703051111.30374.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 05 March 2007 05:21, Miles Lane wrote:
> WARNING: "pcmcia_access_configuration_register" [drivers/ssb/ssb.ko] undefined!
> WARNING: "pccard_parse_tuple"
> [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> WARNING: "pcmcia_register_driver"
> [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> WARNING: "pccard_get_tuple_data"
> [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> WARNING: "pcmcia_request_configuration"
> [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> WARNING: "pcmcia_request_window"
> [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> WARNING: "pccard_get_first_tuple"
> [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> WARNING: "pcmcia_release_window"
> [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> WARNING: "pcmcia_map_mem_page"
> [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> WARNING: "pcmcia_unregister_driver"
> [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> WARNING: "pcmcia_disable_device"
> [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> make[1]: *** [__modpost] Error 1
> 
> #
> # PCCARD (PCMCIA/CardBus) support
> #
> # CONFIG_PCCARD is not set
> 
> CONFIG_BCM43XX_MAC80211=m
> CONFIG_BCM43XX_MAC80211_PCI=y
> CONFIG_BCM43XX_MAC80211_PCMCIA=y

This SELECTs SSB_PCMCIAHOST and that DEPENDS ON
PCMCIA. So dependencies don't seem to work through SELECT.
I'll fix that in my tree, so it will pushed through linville to mm.

-- 
Greetings Michael.
