Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:52043 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753705Ab1EMMO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 08:14:57 -0400
Received: by mail-ew0-f54.google.com with SMTP id 1so1604758ewy.27
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 05:14:55 -0700 (PDT)
Subject: Re: [PATCH v2 0/6] wl12xx: add initial wowlan support
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1305277033-6662-1-git-send-email-eliad@wizery.com>
References: <1305277033-6662-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 15:14:52 +0300
Message-ID: <1305288892.12586.1107.camel@cumari> (sfid-20110513_141502_569579_689AC7B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 11:57 +0300, Eliad Peller wrote:
> Add initial support for Wake-On-Wireless.
> 
> Currently, we support only the ANY trigger, which basically means
> the device stays awake while the host is being suspended, and will
> wake up the host by any irq it will trigger (but since the wl12xx
> fw offloads a lot of its work, it will probably wake up the host
> because of rx frame/beacon loss)
> 
> Note that this patchset needs some additional omap/mmc patches in 
> order to support the MMC_PM_KEEP_POWER flag and wake-irq correctly
> (however, if the MMC_PM_KEEP_POWER flag is not being supported we 
> don't advertise support for wowlan triggers, so this patchset alone
> shouldn't harm).
> 
> Changes from v1:
> * reflow wl1271_hardirq (return immediately)
> * squash one patch 
> * define WL1271_PS_COMPLETE_TIMEOUT
> 
> Eliad Peller (6):
>   wl12xx_sdio: set interrupt as wake_up interrupt
>   wl12xx: declare suspend/resume callbacks (for wowlan)
>   wl12xx_sdio: set MMC_PM_KEEP_POWER flag on suspend
>   wl12xx: prevent scheduling while suspending (WoW enabled)
>   wl12xx_sdio: declare support for NL80211_WOW_TRIGGER_ANYTHING trigger
>   wl12xx: enter/exit psm on wowlan suspend/resume
> 
>  drivers/net/wireless/wl12xx/event.c  |    7 ++
>  drivers/net/wireless/wl12xx/main.c   |  146 ++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/wl12xx/ps.h     |    2 +
>  drivers/net/wireless/wl12xx/sdio.c   |   64 +++++++++++++++-
>  drivers/net/wireless/wl12xx/wl12xx.h |    9 ++
>  5 files changed, 227 insertions(+), 1 deletions(-)

Applied the series.  Thank you!

-- 
Cheers,
Luca.

