Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38225 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757717Ab3FFDtL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 23:49:11 -0400
Message-ID: <51B006AE.6080309@candelatech.com> (sfid-20130606_054918_698764_63A3CED0)
Date: Wed, 05 Jun 2013 20:49:02 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ath9k: Use minstrel rate control by default
References: <1370488216-11626-1-git-send-email-sujith@msujith.org>
In-Reply-To: <1370488216-11626-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2013 08:10 PM, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> The ath9k rate control algorithm has various architectural
> issues that make it a poor fit in scenarios like congested
> environments etc.
>
> An example: https://bugzilla.redhat.com/show_bug.cgi?id=927191
>
> Change the default to minstrel which is more robust in such cases.
> The ath9k RC code is left in the driver for now, maybe it can
> be removed altogether later on.
>
> Cc: stable@vger.kernel.org
> Cc: Jouni Malinen <jouni@qca.qualcomm.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath9k/Kconfig  | 7 ++++---
>   drivers/net/wireless/ath/ath9k/Makefile | 2 +-
>   drivers/net/wireless/ath/ath9k/init.c   | 2 +-
>   drivers/net/wireless/ath/ath9k/rc.h     | 2 +-
>   4 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
> index 3b07851..7526580 100644
> --- a/drivers/net/wireless/ath/ath9k/Kconfig
> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
> @@ -84,13 +84,14 @@ config ATH9K_DFS_CERTIFIED
>   	  developed. At this point enabling this option won't do anything
>   	  except increase code size.
>
> -config ATH9K_RATE_CONTROL
> +config ATH9K_LEGACY_RATE_CONTROL
>   	bool "Atheros ath9k rate control"
>   	depends on ATH9K
> -	default y
> +	default n
>   	---help---
>   	  Say Y, if you want to use the ath9k specific rate control
> -	  module instead of minstrel_ht.
> +	  module instead of minstrel_ht. Be warned that there are various
> +	  issues with the ath9k RC and minstrel is a more robust algorithm.
>
>   config ATH9K_HTC
>          tristate "Atheros HTC based wireless cards support"
> diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
> index 2ad8f94..75ee9e7 100644
> --- a/drivers/net/wireless/ath/ath9k/Makefile
> +++ b/drivers/net/wireless/ath/ath9k/Makefile
> @@ -8,7 +8,7 @@ ath9k-y +=	beacon.o \
>   		antenna.o
>
>   ath9k-$(CONFIG_ATH9K_BTCOEX_SUPPORT) += mci.o
> -ath9k-$(CONFIG_ATH9K_RATE_CONTROL) += rc.o
> +ath9k-$(CONFIG_ATH9K_LEGACY_RATE_CONTROL) += rc.o
>   ath9k-$(CONFIG_ATH9K_PCI) += pci.o
>   ath9k-$(CONFIG_ATH9K_AHB) += ahb.o
>   ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index db81acc..b8a3a0e 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -830,7 +830,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>   	sc->ant_rx = hw->wiphy->available_antennas_rx;
>   	sc->ant_tx = hw->wiphy->available_antennas_tx;
>
> -#ifdef CONFIG_ATH9K_RATE_CONTROL
> +#ifdef CONFIG_ATH9K_LEGACY_RATE_CONTROL
>   	hw->rate_control_algorithm = "ath9k_rate_control";
>   #endif

If you will just delete that code above, then you can compile in both ath9k and minstrel rate
controls and select at run-time by twiddling the mac80211 rate control module option.

Last I tested there were still advantages to ath9k rate control in our environment,
(including when running through an attenuator and over-the-air),
so I think it should be left in to keep minstrel honest if nothing else.

Thanks,
Ben

>
> diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
> index 267dbfc..b9a8738 100644
> --- a/drivers/net/wireless/ath/ath9k/rc.h
> +++ b/drivers/net/wireless/ath/ath9k/rc.h
> @@ -231,7 +231,7 @@ static inline void ath_debug_stat_retries(struct ath_rate_priv *rc, int rix,
>   }
>   #endif
>
> -#ifdef CONFIG_ATH9K_RATE_CONTROL
> +#ifdef CONFIG_ATH9K_LEGACY_RATE_CONTROL
>   int ath_rate_control_register(void);
>   void ath_rate_control_unregister(void);
>   #else
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

