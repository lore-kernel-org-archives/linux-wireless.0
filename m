Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46542 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYIURgt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 13:36:49 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Date: Sun, 21 Sep 2008 19:36:00 +0200
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	reinette.chatre@intel.com, jgarzik@pobox.com,
	linville@tuxdriver.com, davem@davemloft.net
References: <20080921172316.GA6306@2ka.mipt.ru>
In-Reply-To: <20080921172316.GA6306@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809211936.00414.mb@bu3sch.de> (sfid-20080921_193654_426660_E511CA09)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 21 September 2008 19:23:17 Evgeniy Polyakov wrote:
> Hi.
> 
> Following bug exists in the ipw2100 driver/firmware for years and Intel
> folks never responded to zillions bugzilla entries and forum notices in
> the internet with some patch or firmware update (although did request
> dmesg and debug info, and received them).
> 
> ipw2100: Fatal interrupt. Scheduling firmware restart.
> 
> I believe it is a firmware bug because after driver is unloaded and
> loaded back again wireless adapter usually starts working (for small
> amount of time though). My conspiracy feeling can suggest, that it may
> be kind of a force to buy a new one, or trivial error in the firmware,
> when it writes to the same place in the flash and essentially given cell
> became dead or whatever else.
> 
> Intel folks, please fix this problem, I see no other way to force you to do
> this than to mark ipw2100 driver as broken, since that is what it is.

You are pretty funny, actually. :)

I think the bug should be fixed, but what makes _you_ think you can _force_
anybody to do so?

> Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> 
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index 9931b5a..c24fc6a 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -125,7 +125,7 @@ config PCMCIA_RAYCS
>  
>  config IPW2100
>  	tristate "Intel PRO/Wireless 2100 Network Connection"
> -	depends on PCI && WLAN_80211
> +	depends on PCI && WLAN_80211 && BROKEN
>  	select WIRELESS_EXT
>  	select FW_LOADER
>  	select IEEE80211
> 



-- 
Greetings Michael.
