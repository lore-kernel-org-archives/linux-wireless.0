Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:40589 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933533AbXCEPyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 10:54:19 -0500
Date: Mon, 5 Mar 2007 07:50:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: "Miles Lane" <miles.lane@gmail.com>,
	"Andrew Morton" <akpm@osdl.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org,
	"Michael Buesch" <mbuesch@freenet.de>
Subject: Re: 2.6.21-rc2-mm1 -- WARNING:  "pcmcia_access_configuration_register" [drivers/ssb/ssb.ko] undefined!
Message-Id: <20070305075053.82cff690.randy.dunlap@oracle.com>
In-Reply-To: <200703051111.30374.mb@bu3sch.de>
References: <a44ae5cd0703042021o434e42b1vea6fd90376824917@mail.gmail.com>
	<200703051111.30374.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 5 Mar 2007 11:11:29 +0100 Michael Buesch wrote:

> On Monday 05 March 2007 05:21, Miles Lane wrote:
> > WARNING: "pcmcia_access_configuration_register" [drivers/ssb/ssb.ko] undefined!
> > WARNING: "pccard_parse_tuple"
> > [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> > WARNING: "pcmcia_register_driver"
> > [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> > WARNING: "pccard_get_tuple_data"
> > [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> > WARNING: "pcmcia_request_configuration"
> > [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> > WARNING: "pcmcia_request_window"
> > [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> > WARNING: "pccard_get_first_tuple"
> > [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> > WARNING: "pcmcia_release_window"
> > [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> > WARNING: "pcmcia_map_mem_page"
> > [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> > WARNING: "pcmcia_unregister_driver"
> > [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> > WARNING: "pcmcia_disable_device"
> > [drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > 
> > #
> > # PCCARD (PCMCIA/CardBus) support
> > #
> > # CONFIG_PCCARD is not set
> > 
> > CONFIG_BCM43XX_MAC80211=m
> > CONFIG_BCM43XX_MAC80211_PCI=y
> > CONFIG_BCM43XX_MAC80211_PCMCIA=y
> 
> This SELECTs SSB_PCMCIAHOST and that DEPENDS ON
> PCMCIA. So dependencies don't seem to work through SELECT.

just confirming that last sentence:  SELECT does not enforce
any "upstream" dependencies.  (known "problem")

> I'll fix that in my tree, so it will pushed through linville to mm.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
