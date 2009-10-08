Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:61711 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759763AbZJHS6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 14:58:48 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 20/20] wl1271: Mask unneeded events from firmware to conserve power
Date: Thu,  8 Oct 2009 21:56:36 +0300
Message-Id: <1255028196-6565-21-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
References: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Currently several events are enabled from the firmware for which there
is no handling. This wakes up the host unnecessarily. Mask those
unneeded events.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 7640313..140e943 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -390,8 +390,9 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	/* enable gpio interrupts */
 	wl1271_boot_enable_interrupts(wl);
 
-	/* unmask all mbox events  */
-	wl->event_mask = 0xffffffff;
+	/* unmask required mbox events  */
+	wl->event_mask = BSS_LOSE_EVENT_ID |
+		SCAN_COMPLETE_EVENT_ID;
 
 	ret = wl1271_event_unmask(wl);
 	if (ret < 0) {
-- 
1.5.6.5

