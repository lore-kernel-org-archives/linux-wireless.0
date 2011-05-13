Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41579 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab1EMI5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 04:57:21 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so2644123wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 01:57:20 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 5/6] wl12xx_sdio: declare support for NL80211_WOW_TRIGGER_ANYTHING trigger
Date: Fri, 13 May 2011 11:57:12 +0300
Message-Id: <1305277033-6662-6-git-send-email-eliad@wizery.com> (sfid-20110513_105726_164294_01A1AA35)
In-Reply-To: <1305277033-6662-1-git-send-email-eliad@wizery.com>
References: <1305277033-6662-1-git-send-email-eliad@wizery.com>
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
index 41183db..92d29a8 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -231,6 +231,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	const struct wl12xx_platform_data *wlan_data;
 	struct wl1271 *wl;
 	unsigned long irqflags;
+	mmc_pm_flag_t mmcflags;
 	int ret;
 
 	/* We are only able to handle the wlan function */
@@ -282,6 +283,13 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 
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

