Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42074 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab0KRLdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 06:33:09 -0500
Received: by mail-fx0-f46.google.com with SMTP id 6so1460042fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 03:33:08 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 17/18] wl1271: Read MAC address from NVS file on HW startup
Date: Thu, 18 Nov 2010 13:32:30 +0200
Message-Id: <1290079951-16793-18-git-send-email-arik@wizery.com>
In-Reply-To: <1290079951-16793-1-git-send-email-arik@wizery.com>
References: <1290079951-16793-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Try to read the MAC address from the on-disk NVS file.
A non-zero MAC address is required to add an AP interface.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 708b699..e5fbbb6 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2987,6 +2987,18 @@ int wl1271_register_hw(struct wl1271 *wl)
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

