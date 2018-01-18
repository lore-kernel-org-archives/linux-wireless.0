Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38030 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756162AbeARNX3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 08:23:29 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] [wireless-next] mt76: fix building without CONFIG_LEDS_CLASS
References: <20180118131524.817297-1-arnd@arndb.de>
Date: Thu, 18 Jan 2018 15:23:23 +0200
In-Reply-To: <20180118131524.817297-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Thu, 18 Jan 2018 14:14:11 +0100")
Message-ID: <87bmhrb8s4.fsf@kamboji.qca.qualcomm.com> (sfid-20180118_142409_833551_E2F4D10A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

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

I'm planning to queue this for 4.16.

-- 
Kalle Valo
