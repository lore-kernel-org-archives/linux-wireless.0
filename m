Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:24429 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab0CZKyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:20 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 10/24] wl1271: Remove device MAC-address randomization
Date: Fri, 26 Mar 2010 12:53:19 +0200
Message-Id: <1269600813-32145-11-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch removes the MAC address randomization from the driver. This removes
a nasty Nokia-OUI dependency from the driver.

With this patch, unless an address is explicitly configured to the driver
by the user, only a zero address will be configured, and the driver will be
unable to start.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 8645030..4a2f1d7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -2143,7 +2143,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	struct platform_device *plat_dev = NULL;
 	struct wl1271 *wl;
 	int i, ret;
-	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
 
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1271_ops);
 	if (!hw) {
@@ -2195,13 +2194,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->state = WL1271_STATE_OFF;
 	mutex_init(&wl->mutex);
 
-	/*
-	 * FIXME: we should use a zero MAC address here, but for now we
-	 * generate a random Nokia address.
-	 */
-	memcpy(wl->mac_addr, nokia_oui, 3);
-	get_random_bytes(wl->mac_addr + 3, 3);
-
 	/* Apply default driver configuration. */
 	wl1271_conf_init(wl);
 
-- 
1.6.3.3

