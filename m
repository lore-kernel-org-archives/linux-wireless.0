Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47184 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754870AbeARRbj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 12:31:39 -0500
Subject: Re: [PATCH] [wireless-next] mt76: fix building without
 CONFIG_LEDS_CLASS
To: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20180118131524.817297-1-arnd@arndb.de>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <f5b35785-2c80-da12-607c-02c253c22f39@nbd.name> (sfid-20180118_183155_508893_197C7C9F)
Date: Thu, 18 Jan 2018 18:31:36 +0100
MIME-Version: 1.0
In-Reply-To: <20180118131524.817297-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-01-18 14:14, Arnd Bergmann wrote:
> When CONFIG_LEDS_CLASS is disabled, or it is a loadable module while
> mt76 is built-in, we run into a link error:
> 
> drivers/net/wireless/mediatek/mt76/mac80211.o: In function `mt76_register_device':
> mac80211.c:(.text+0xb78): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `devm_of_led_classdev_register'
> 
> We don't really need a hard dependency here as the driver can presumably
> work just fine without LEDs, so this follows the iwlwifi example and
> adds a separate Kconfig option for the LED support, this will be available
> whenever it will link, and otherwise the respective code gets left out from
> the driver object.
> 
> Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/mediatek/mt76/Kconfig       | 5 +++++
>  drivers/net/wireless/mediatek/mt76/mac80211.c    | 8 +++++---
>  drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 6 ++++--
>  3 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
> index fc05d79c80d0..9d12c1f5284e 100644
> --- a/drivers/net/wireless/mediatek/mt76/Kconfig
> +++ b/drivers/net/wireless/mediatek/mt76/Kconfig
> @@ -8,3 +8,8 @@ config MT76x2E
>  	depends on PCI
>  	---help---
>  	  This adds support for MT7612/MT7602/MT7662-based wireless PCIe devices.
> +
> +config MT76_LEDS
> +	bool "LED support for MT76"
> +	depends on MT76_CORE
> +	depends on LEDS_CLASS=y || MT76_CORE=LEDS_CLASS
I think this should have a 'default y'

- Felix
