Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38822 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab1EKPpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 11:45:31 -0400
Received: by wwa36 with SMTP id 36so755279wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 08:45:30 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/7] wl12xx_sdio: declare support for NL80211_WOW_TRIGGER_ANYTHING trigger
Date: Wed, 11 May 2011 11:54:26 +0300
Message-Id: <1305104068-32240-6-git-send-email-eliad@wizery.com> (sfid-20110511_174548_110928_3968AFD3)
In-Reply-To: <1305104068-32240-1-git-send-email-eliad@wizery.com>
References: <1305104068-32240-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since wowlan requires the ability to stay awake while the host
is suspended, declare support for NL80211_WOW_TRIGGER_ANYTHING
if the MMC_PM_KEEP_POWER capability is being supported.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index bf2a6ad..dacd00c 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -234,6 +234,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	const struct wl12xx_platform_data *wlan_data;
 	struct wl1271 *wl;
 	unsigned long irqflags;
+	mmc_pm_flag_t mmcflags;
 	int ret;
 
 	/* We are only able to handle the wlan function */
@@ -285,6 +286,13 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 
 	disable_irq(wl->irq);
 
+	/* if sdio can keep power while host is suspended, enable wow */
+	mmcflags = sdio_get_host_pm_caps(func);
+	wl1271_debug(DEBUG_SDIO, "sdio PM caps = 0x%x", mmcflags);
+
+	if (mmcflags & MMC_PM_KEEP_POWER)
+		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_ANY;
+
 	ret = wl1271_init_ieee80211(wl);
 	if (ret)
 		goto out_irq;
-- 
1.7.0.4

