Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:45422 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2KULSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 06:18:22 -0500
Cc: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v8 2/4] wireless: allow Atheros card to not depend on ath.ko
Date: Wed, 21 Nov 2012 13:18:11 +0200
Message-ID: <8206721.qz6ygglX4j@lx-vladimir> (sfid-20121121_121826_291599_29ACD6C4)
In-Reply-To: <1352978222-13866-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1352978222-13866-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

As was discussed, I prepared this patch that address Kconfig issue for the
Atheros wifi cards.

Any opinions on this?

This patch is not depending on anything, it may be applied on
linux-wireless tree as is.

Thanks, Vladimir

On Thursday, November 15, 2012 01:17:00 PM Vladimir Kondratiev wrote:
> There are 2 different things:
> - sub-menu for "Atheros Wireless cards" family
> - module ath.ko with common Atheros code
> 
> Until now, they both used to depend on the same Kconfig variable ATH_COMMON.
> Thus, being "Atheros card" and "depending on ath.ko" was the same.
> 
> To allow module to belong to the
> "Atheros Wireless cards" family but not use ath.ko,
> 2 conditions above need to be separated.
> 
> So, this patch introduce new Kconfig variable ATH_CARDS for belonging
> to the "Atheros Wireless Cards" family; while ATH_COMMON becomes hidden
> variable to express dependency on common Atheros code in ath.ko. Modules
> that depend on this common code now express it by setting ATH_COMMON.
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/Kconfig          |    7 +++++--
>  drivers/net/wireless/ath/ar5523/Kconfig   |    1 +
>  drivers/net/wireless/ath/ath5k/Kconfig    |    1 +
>  drivers/net/wireless/ath/ath6kl/Kconfig   |    1 +
>  drivers/net/wireless/ath/ath9k/Kconfig    |    1 +
>  drivers/net/wireless/ath/carl9170/Kconfig |    1 +
>  6 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/Kconfig
> b/drivers/net/wireless/ath/Kconfig index c25dcf1..1a67a4f 100644
> --- a/drivers/net/wireless/ath/Kconfig
> +++ b/drivers/net/wireless/ath/Kconfig
> @@ -1,4 +1,7 @@
> -menuconfig ATH_COMMON
> +config ATH_COMMON
> +	tristate
> +
> +menuconfig ATH_CARDS
>  	tristate "Atheros Wireless Cards"
>  	depends on CFG80211 && (!UML || BROKEN)
>  	---help---
> @@ -14,7 +17,7 @@ menuconfig ATH_COMMON
> 
>  	  http://wireless.kernel.org/en/users/Drivers/Atheros
> 
> -if ATH_COMMON
> +if ATH_CARDS
> 
>  config ATH_DEBUG
>  	bool "Atheros wireless debugging"
> diff --git a/drivers/net/wireless/ath/ar5523/Kconfig
> b/drivers/net/wireless/ath/ar5523/Kconfig index 11d99ee..0d320cc 100644
> --- a/drivers/net/wireless/ath/ar5523/Kconfig
> +++ b/drivers/net/wireless/ath/ar5523/Kconfig
> @@ -1,6 +1,7 @@
>  config AR5523
>         tristate "Atheros AR5523 wireless driver support"
>         depends on MAC80211 && USB
> +       select ATH_COMMON
>         select FW_LOADER
>         ---help---
>           This module add support for AR5523 based USB dongles such as
> D-Link diff --git a/drivers/net/wireless/ath/ath5k/Kconfig
> b/drivers/net/wireless/ath/ath5k/Kconfig index 338c5c4..c9f81a3 100644
> --- a/drivers/net/wireless/ath/ath5k/Kconfig
> +++ b/drivers/net/wireless/ath/ath5k/Kconfig
> @@ -1,6 +1,7 @@
>  config ATH5K
>  	tristate "Atheros 5xxx wireless cards support"
>  	depends on (PCI || ATHEROS_AR231X) && MAC80211
> +	select ATH_COMMON
>  	select MAC80211_LEDS
>  	select LEDS_CLASS
>  	select NEW_LEDS
> diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig
> b/drivers/net/wireless/ath/ath6kl/Kconfig index d755a5e..2a61989 100644
> --- a/drivers/net/wireless/ath/ath6kl/Kconfig
> +++ b/drivers/net/wireless/ath/ath6kl/Kconfig
> @@ -1,5 +1,6 @@
>  config ATH6KL
>  	tristate "Atheros mobile chipsets support"
> +	select ATH_COMMON
> 
>  config ATH6KL_SDIO
>  	tristate "Atheros ath6kl SDIO support"
> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig
> b/drivers/net/wireless/ath/ath9k/Kconfig index c7aa664..5fc15bf 100644
> --- a/drivers/net/wireless/ath/ath9k/Kconfig
> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
> @@ -17,6 +17,7 @@ config ATH9K_BTCOEX_SUPPORT
>  config ATH9K
>  	tristate "Atheros 802.11n wireless cards support"
>  	depends on MAC80211
> +	select ATH_COMMON
>  	select ATH9K_HW
>  	select MAC80211_LEDS
>  	select LEDS_CLASS
> diff --git a/drivers/net/wireless/ath/carl9170/Kconfig
> b/drivers/net/wireless/ath/carl9170/Kconfig index 267d5dc..13a2045 100644
> --- a/drivers/net/wireless/ath/carl9170/Kconfig
> +++ b/drivers/net/wireless/ath/carl9170/Kconfig
> @@ -1,6 +1,7 @@
>  config CARL9170
>  	tristate "Linux Community AR9170 802.11n USB support"
>  	depends on USB && MAC80211 && EXPERIMENTAL
> +	select ATH_COMMON
>  	select FW_LOADER
>  	select CRC32
>  	help
