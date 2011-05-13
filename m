Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41579 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab1EMI5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 04:57:12 -0400
Received: by wwa36 with SMTP id 36so2644123wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 01:57:11 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 0/6] wl12xx: add initial wowlan support
Date: Fri, 13 May 2011 11:57:07 +0300
Message-Id: <1305277033-6662-1-git-send-email-eliad@wizery.com> (sfid-20110513_105716_166074_122C7F99)
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

Changes from v1:
* reflow wl1271_hardirq (return immediately)
* squash one patch 
* define WL1271_PS_COMPLETE_TIMEOUT

Eliad Peller (6):
  wl12xx_sdio: set interrupt as wake_up interrupt
  wl12xx: declare suspend/resume callbacks (for wowlan)
  wl12xx_sdio: set MMC_PM_KEEP_POWER flag on suspend
  wl12xx: prevent scheduling while suspending (WoW enabled)
  wl12xx_sdio: declare support for NL80211_WOW_TRIGGER_ANYTHING trigger
  wl12xx: enter/exit psm on wowlan suspend/resume

 drivers/net/wireless/wl12xx/event.c  |    7 ++
 drivers/net/wireless/wl12xx/main.c   |  146 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/ps.h     |    2 +
 drivers/net/wireless/wl12xx/sdio.c   |   64 +++++++++++++++-
 drivers/net/wireless/wl12xx/wl12xx.h |    9 ++
 5 files changed, 227 insertions(+), 1 deletions(-)

