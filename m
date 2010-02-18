Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50744 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab0BRL2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:18 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/22] wl1271: Fix random MAC address setting
Date: Thu, 18 Feb 2010 13:25:46 +0200
Message-Id: <1266492357-462-12-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If reverting to a random MAC address, the driver would not update it to the
NVS file, and hence the firmware frame filtering would not work properly.

So update the randomized MAC address to the NVS image.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index e698dec..c7f5191 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -562,6 +562,14 @@ static int wl1271_update_mac_addr(struct wl1271 *wl)
 		static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
 		memcpy(wl->mac_addr, nokia_oui, 3);
 		get_random_bytes(wl->mac_addr + 3, 3);
+
+		/* update this address to the NVS */
+		nvs_ptr[11] = wl->mac_addr[0];
+		nvs_ptr[10] = wl->mac_addr[1];
+		nvs_ptr[6] = wl->mac_addr[2];
+		nvs_ptr[5] = wl->mac_addr[3];
+		nvs_ptr[4] = wl->mac_addr[4];
+		nvs_ptr[3] = wl->mac_addr[5];
 	}
 
 	SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
-- 
1.6.3.3

