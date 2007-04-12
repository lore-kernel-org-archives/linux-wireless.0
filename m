Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247AbXDKX5b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 19:57:31 -0400
Subject: Re: [PATCH] bcm43xx: Hide if bcm43xx-mac80211 is builtin
From: Dan Williams <dcbw@redhat.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <200704111901.06403.flamingice@sourmilk.net>
References: <200704111901.06403.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Wed, 11 Apr 2007 20:01:10 -0400
Message-Id: <1176336070.1298.17.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-04-11 at 19:01 -0400, Michael Wu wrote:
> bcm43xx: Hide if bcm43xx-mac80211 is builtin
> 
> From: Michael Wu <flamingice@sourmilk.net>
> 
> This prevents users from compiling bcm43xx (softmac) and bcm43xx-mac80211
> into the kernel at the same time. In the case that it is attempted, make
> bcm43xx (softmac) not build.

What kernel version is this targetted at?  Have the mac80211 bits
reached feature parity with the softmac bits?  I'm still hearing quite a
few reports of mac80211 being flaky WRT WEXT implementation and
compatibility.  I don't necessarily object, I just want to make sure
that when this patch hits released kernels, that the mac80211 port is in
the same or better shape than the softmac one.

Dan


> Signed-off-by: Michael Wu <flamingice@sourmilk.net>
> ---
> 
>  drivers/net/wireless/bcm43xx/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/bcm43xx/Kconfig b/drivers/net/wireless/bcm43xx/Kconfig
> index ce397e4..f69510d 100644
> --- a/drivers/net/wireless/bcm43xx/Kconfig
> +++ b/drivers/net/wireless/bcm43xx/Kconfig
> @@ -1,6 +1,7 @@
>  config BCM43XX
>  	tristate "Broadcom BCM43xx wireless support"
>  	depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211 && EXPERIMENTAL
> +	depends on BCM43XX_MAC80211 != 'y'
>  	select WIRELESS_EXT
>  	select FW_LOADER
>  	select HW_RANDOM

