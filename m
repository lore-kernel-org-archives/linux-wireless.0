Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45319 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489Ab1CAUhD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 15:37:03 -0500
Received: by mail-ww0-f44.google.com with SMTP id 22so4952627wwb.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 12:37:02 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC 9/9] wl12xx_sdio: declare support for NL80211_WOW_TRIGGER_ANYTHING trigger
Date: Tue,  1 Mar 2011 22:36:44 +0200
Message-Id: <1299011804-13899-10-git-send-email-eliad@wizery.com>
In-Reply-To: <1299011804-13899-1-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Finally, declare support for NL80211_WOW_TRIGGER_ANYTHING.

Since this feature requires the ability to stay awake while the host
is suspended, the support should be declared per-interface (sdio
will support it if it supports the MMC_PM_KEEP_POWER capability)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index f5d4b21..0a5b05d 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -237,6 +237,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	struct ieee80211_hw *hw;
 	const struct wl12xx_platform_data *wlan_data;
 	struct wl1271 *wl;
+	mmc_pm_flag_t flags;
 	int ret;
 
 	/* We are only able to handle the wlan function */
@@ -278,6 +279,14 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 
 	disable_irq(wl->irq);
 
+	/* if sdio can keep power while host is suspended, enable wow */
+	flags = sdio_get_host_pm_caps(func);
+	wl1271_debug(DEBUG_SDIO, "sdio PM caps = 0x%x", flags);
+
+	if (flags & MMC_PM_KEEP_POWER)
+		hw->wiphy->supported_wow_triggers =
+					NL80211_WOW_TRIGGER_ANYTHING;
+
 	ret = wl1271_init_ieee80211(wl);
 	if (ret)
 		goto out_irq;
-- 
1.7.0.4

