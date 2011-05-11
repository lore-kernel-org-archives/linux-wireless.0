Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40764 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab1EKQCl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 12:02:41 -0400
Received: by wya21 with SMTP id 21so497053wya.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 09:02:39 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/7] wl12xx: add initial wowlan support
Date: Wed, 11 May 2011 11:54:21 +0300
Message-Id: <1305104068-32240-1-git-send-email-eliad@wizery.com> (sfid-20110511_180253_306772_6B4A6EFB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add initial support for Wake-On-Wireless.

Currently, we support only the ANY trigger, which basically means
the device stays awake while the host is being suspended, and will
wake up the host by any irq it will trigger (but since the wl12xx
fw offloads a lot of its work, it will probably wake up the host
because of rx frame/beacon loss)

Note that this patchset needs some additional omap/mmc patches in 
order to support the MMC_PM_KEEP_POWER flag and wake-irq correctly
(however, if the MMC_PM_KEEP_POWER flag is not being supported we 
don't advertise support for wowlan triggers, so this patchset alone
shouldn't harm).

Eliad Peller (7):
  wl12xx_sdio: set interrupt as wake_up interrupt
  wl12xx: declare suspend/resume callbacks (for wowlan)
  wl12xx_sdio: set MMC_PM_KEEP_POWER flag on suspend
  wl12xx: prevent scheduling while suspending (WoW enabled)
  wl12xx_sdio: declare support for NL80211_WOW_TRIGGER_ANYTHING trigger
  wl12xx: add ps completion event
  wl12xx: enter/exit psm on wowlan suspend/resume

 drivers/net/wireless/wl12xx/event.c  |    7 ++
 drivers/net/wireless/wl12xx/main.c   |  146 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/sdio.c   |   66 +++++++++++++++
 drivers/net/wireless/wl12xx/wl12xx.h |    9 ++
 4 files changed, 228 insertions(+), 0 deletions(-)

