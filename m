Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:60777 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZLRQ4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 11:56:10 -0500
Date: Fri, 18 Dec 2009 08:55:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-wireless@vger.kernel.org,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [PATCH] ps3_gelic_wireless: Fix build failure due to missing
 WEXT_PRIV
Message-Id: <20091218085547.fb8bdaf5.randy.dunlap@oracle.com>
In-Reply-To: <1261115574.2173.18.camel@pasglop>
References: <1261115574.2173.18.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 18 Dec 2009 16:52:54 +1100 Benjamin Herrenschmidt wrote:

> The option to support the old style PSK interface in the PS3
> GELIC wireless drivers requires CONFIG_WEXT_PRIV to be set
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> Please send to Linus asap (or I can put it in powerpc.git) as it's
> breaking one of my test build configs :-)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index e58a653..c0ecc77 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -2358,6 +2358,7 @@ config GELIC_WIRELESS
>  config GELIC_WIRELESS_OLD_PSK_INTERFACE
>         bool "PS3 Wireless private PSK interface (OBSOLETE)"
>         depends on GELIC_WIRELESS
> +       select WEXT_PRIV
>         help
>            This option retains the obsolete private interface to pass
>            the PSK from user space programs to the driver.  The PSK

Probably also needs
	depends on WLAN
to prevent build failures.

---
~Randy
