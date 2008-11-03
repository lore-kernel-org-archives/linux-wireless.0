Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:16741 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbYKCVcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 16:32:54 -0500
Date: Mon, 3 Nov 2008 13:32:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: print_ssid undefined (linux-next 20081103)
Message-Id: <20081103133218.c2b8ce5d.randy.dunlap@oracle.com> (sfid-20081103_223300_716825_3D38C23E)
In-Reply-To: <20081103201206.GB6378@tesla>
References: <20081103114222.b257f711.randy.dunlap@oracle.com>
	<20081103201206.GB6378@tesla>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 3 Nov 2008 12:12:06 -0800 Luis R. Rodriguez wrote:

> On Mon, Nov 03, 2008 at 11:42:22AM -0800, Randy Dunlap wrote:
> > Hi,
> > 
> > I'm seeing a few instances of
> > 
> > ERROR: "print_ssid" [drivers/net/wireless/ipw2100.ko] undefined!
> > 
> > with ipw2100 & ipw2200 in today's linux-next (20081103).
> > 
> > These configs have
> > # CONFIG_WIRELESS is not set
> > CONFIG_WIRELESS_EXT=y
> > 
> > In looking into this more, I see that the wireless drivers can be enabled
> > & built even when CONFIG_WIRELESS=n.  Is this the expected behavior?
> > Seems a bit odd.
> 
> Try this.
> 
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index 42afaed..6f85bec 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -125,7 +125,7 @@ config PCMCIA_RAYCS
>  
>  config IPW2100
>  	tristate "Intel PRO/Wireless 2100 Network Connection"
> -	depends on PCI && WLAN_80211
> +	depends on PCI && WLAN_80211 && LIB80211
>  	select WIRELESS_EXT
>  	select FW_LOADER
>  	select IEEE80211
> @@ -183,7 +183,7 @@ config IPW2100_DEBUG
>  
>  config IPW2200
>  	tristate "Intel PRO/Wireless 2200BG and 2915ABG Network Connection"
> -	depends on PCI && WLAN_80211
> +	depends on PCI && WLAN_80211 && LIB80211
>  	select WIRELESS_EXT
>  	select FW_LOADER
>  	select IEEE80211
> --

> make ARCH=i386 O=X32 oldconfig
  GEN     /local/linsrc/linux-next-20081103/X32/Makefile
scripts/kconfig/conf -o arch/x86/Kconfig
net/ieee80211/Kconfig:3:error: found recursive dependency: IEEE80211 -> LIB80211 -> IPW2100 -> IEEE80211
make[2]: *** [oldconfig] Error 1

---
~Randy
