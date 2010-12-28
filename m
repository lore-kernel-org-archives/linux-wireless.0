Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53087 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab0L1Rhm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 12:37:42 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so4306524eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 09:37:42 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 17/18] wl1271: Read MAC address from NVS file on HW startup
Date: Tue, 28 Dec 2010 19:36:47 +0200
Message-Id: <1293557808-27068-18-git-send-email-arik@wizery.com>
In-Reply-To: <1293557808-27068-1-git-send-email-arik@wizery.com>
References: <1293557808-27068-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Try to read the MAC address from the on-disk NVS file.
A non-zero MAC address is required to add an AP interface.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 0751589..ed06aee 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3064,6 +3064,18 @@ int wl1271_register_hw(struct wl1271 *wl)
 	if (wl->mac80211_registered)
 		return 0;
 
+	ret = wl1271_fetch_nvs(wl);
+	if (ret == 0) {
+		u8 *nvs_ptr = (u8 *)wl->nvs->nvs;
+
+		wl->mac_addr[0] = nvs_ptr[11];
+		wl->mac_addr[1] = nvs_ptr[10];
+		wl->mac_addr[2] = nvs_ptr[6];
+		wl->mac_addr[3] = nvs_ptr[5];
+		wl->mac_addr[4] = nvs_ptr[4];
+		wl->mac_addr[5] = nvs_ptr[3];
+	}
+
 	SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
 
 	ret = ieee80211_register_hw(wl->hw);
-- 
1.7.1

