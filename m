Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:33010 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab0DIIHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 04:07:52 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 1/5] wl1271: Fix memory leaks on driver initialization
Date: Fri,  9 Apr 2010 11:07:26 +0300
Message-Id: <1270800450-8167-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1270800450-8167-1-git-send-email-luciano.coelho@nokia.com>
References: <1270800450-8167-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch fixes some memory leaks occurring during driver init/de-init.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 5c32d8d..4e97540 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1093,6 +1093,14 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 		wl->tx_blocks_freed[i] = 0;
 
 	wl1271_debugfs_reset(wl);
+
+	kfree(wl->fw_status);
+	wl->fw_status = NULL;
+	kfree(wl->tx_res_if);
+	wl->tx_res_if = NULL;
+	kfree(wl->target_mem_map);
+	wl->target_mem_map = NULL;
+
 	mutex_unlock(&wl->mutex);
 }
 
@@ -2387,7 +2395,6 @@ int wl1271_free_hw(struct wl1271 *wl)
 
 	wl1271_debugfs_exit(wl);
 
-	kfree(wl->target_mem_map);
 	vfree(wl->fw);
 	wl->fw = NULL;
 	kfree(wl->nvs);
-- 
1.6.3.3

