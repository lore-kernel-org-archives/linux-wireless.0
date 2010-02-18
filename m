Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50751 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab0BRL2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:20 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 16/22] wl1271: Fix ad-hoc SSID update
Date: Thu, 18 Feb 2010 13:25:51 +0200
Message-Id: <1266492357-462-17-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If re-configuring the SSID while ad-hoc was already enabled, the beacon
template would be properly updated, but the SSID passed in the CMD_JOIN would
not - hence filtering etc would not work properly.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 459d9a0..fb1e6a8 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1,7 +1,7 @@
 /*
  * This file is part of wl1271
  *
- * Copyright (C) 2008-2009 Nokia Corporation
+ * Copyright (C) 2008-2010 Nokia Corporation
  *
  * Contact: Luciano Coelho <luciano.coelho@nokia.com>
  *
@@ -1604,6 +1604,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 {
 	enum wl1271_cmd_ps_mode mode;
 	struct wl1271 *wl = hw->priv;
+	bool do_join = false;
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 bss info changed");
@@ -1646,6 +1647,9 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			dev_kfree_skb(beacon);
 			if (ret < 0)
 				goto out_sleep;
+
+			/* Need to update the SSID (for filtering etc) */
+			do_join = true;
 		}
 	}
 
@@ -1664,12 +1668,8 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 				goto out_sleep;
 			}
 
-			ret = wl1271_cmd_join(wl);
-			if (ret < 0) {
-				wl1271_warning("cmd join failed %d", ret);
-				goto out_sleep;
-			}
-			set_bit(WL1271_FLAG_JOINED, &wl->flags);
+			/* Need to update the BSSID (for filtering etc) */
+			do_join = true;
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
@@ -1736,6 +1736,15 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
+	if (do_join) {
+		ret = wl1271_cmd_join(wl);
+		if (ret < 0) {
+			wl1271_warning("cmd join failed %d", ret);
+			goto out_sleep;
+		}
+		set_bit(WL1271_FLAG_JOINED, &wl->flags);
+	}
+
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
 
-- 
1.6.3.3

