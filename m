Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:48628 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859AbZLRWJw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 17:09:52 -0500
Subject: Re: [PATCH v2] ps3_gelic_wireless: Fix build failure due to
 missing WEXT_PRIV
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Hamish Guthrie <Hamish.Guthrie@sonycom.com>
In-Reply-To: <4B2BC8E6.9090007@am.sony.com>
References: <1261115574.2173.18.camel@pasglop>
	 <20091218085547.fb8bdaf5.randy.dunlap@oracle.com>
	 <4B2BC8E6.9090007@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Dec 2009 09:09:36 +1100
Message-ID: <1261174176.2173.67.camel@pasglop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-12-18 at 10:24 -0800, Geoff Levand wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> The option to support the old style PSK interface in the PS3
> GELIC wireless drivers requires CONFIG_WEXT_PRIV to be set
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
> ---
> v2: Added 'depends on WLAN'.
> 
> Please send to Linus asap (or I can put it in powerpc.git) as it's
> breaking one of my test build configs :-)
> 
> Just as a note, I asked Hamish to work to remove this option.
> No distros use it anymore, so we don't need it.

Geoff, the depends on WLAN should be on config GELIC_WIRELESS

Cheers,
Ben.

> -Geoff
> ---
>  drivers/net/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -2357,7 +2357,9 @@ config GELIC_WIRELESS
>  
>  config GELIC_WIRELESS_OLD_PSK_INTERFACE
>         bool "PS3 Wireless private PSK interface (OBSOLETE)"
> +       depends on WLAN
>         depends on GELIC_WIRELESS
> +       select WEXT_PRIV
>         help
>            This option retains the obsolete private interface to pass
>            the PSK from user space programs to the driver.  The PSK


