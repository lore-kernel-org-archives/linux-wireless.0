Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50150 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZFCX4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 19:56:11 -0400
Subject: Re: [PATCH] cfg80211: fix Kconfig for users of cfg80211
From: Samuel Ortiz <samuel@sortiz.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, yi.zhu@intel.com
In-Reply-To: <1244046631.4862.34.camel@johannes.local>
References: <1244046631.4862.34.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 01:58:09 +0200
Message-Id: <1244073490.2723.3.camel@sortiz-mobl>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes

On Wed, 2009-06-03 at 18:30 +0200, Johannes Berg wrote:
> * iwm doesn't depend on cfg80211 or wireless extensions
This one will conflict with a patch Yi sent a week ago.
Dave Miller applied it to his net-next-2.6 tree, commit
d0fc1d5e3fe869f8a32a2bc1dd02d8383a057164.
See also:
http://marc.info/?l=linux-wireless&m=124331653022408&w=2

Cheers,
Samuel.


>  * rndis wlan selects cfg80211 - needs to depend
>  * mac80211 selects cfg80211 - needs to depend
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  drivers/net/wireless/Kconfig              |    2 +-
>  drivers/net/wireless/iwmc3200wifi/Kconfig |    2 ++
>  net/mac80211/Kconfig                      |    5 ++++-
>  3 files changed, 7 insertions(+), 2 deletions(-)
> 
> --- wireless-testing.orig/net/mac80211/Kconfig	2009-06-03 18:20:06.000000000 +0200
> +++ wireless-testing/net/mac80211/Kconfig	2009-06-03 18:24:58.000000000 +0200
> @@ -1,16 +1,19 @@
>  config MAC80211
>  	tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
> +	depends on CFG80211
>  	select CRYPTO
>  	select CRYPTO_ECB
>  	select CRYPTO_ARC4
>  	select CRYPTO_AES
>  	select CRC32
>  	select WIRELESS_EXT
> -	select CFG80211
>  	---help---
>  	  This option enables the hardware independent IEEE 802.11
>  	  networking stack.
>  
> +comment "CFG80211 needs to be enabled for MAC80211"
> +	depends on CFG80211=n
> +
>  config MAC80211_DEFAULT_PS
>  	bool "enable powersave by default"
>  	depends on MAC80211
> --- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/Kconfig	2009-06-03 18:25:55.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwmc3200wifi/Kconfig	2009-06-03 18:26:29.000000000 +0200
> @@ -1,6 +1,8 @@
>  config IWM
>  	tristate "Intel Wireless Multicomm 3200 WiFi driver"
>  	depends on MMC && WLAN_80211 && EXPERIMENTAL
> +	depends on CFG80211
> +	select WIRELESS_EXT
>  	select LIB80211
>  	select FW_LOADER
>  
> --- wireless-testing.orig/drivers/net/wireless/Kconfig	2009-06-03 18:26:37.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/Kconfig	2009-06-03 18:26:46.000000000 +0200
> @@ -333,11 +333,11 @@ config USB_ZD1201
>  config USB_NET_RNDIS_WLAN
>  	tristate "Wireless RNDIS USB support"
>  	depends on USB && WLAN_80211 && EXPERIMENTAL
> +	depends on CFG80211
>  	select USB_USBNET
>  	select USB_NET_CDCETHER
>  	select USB_NET_RNDIS_HOST
>  	select WIRELESS_EXT
> -	select CFG80211
>  	---help---
>  	  This is a driver for wireless RNDIS devices.
>  	  These are USB based adapters found in devices such as:
> 
> 

