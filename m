Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33185 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab0CRK1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:50 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 20/21] wl1271: Remove circular interlocking related to the inetaddr notifier chain
Date: Thu, 18 Mar 2010 12:26:45 +0200
Message-Id: <1268908006-16992-21-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Removing the wl1271 from the inet addr notifier chain sometimes causes the
registered handler to be called - causing locking problems if the removing
function is called from within the mutex.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 6f6d366..0bebc45 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1029,12 +1029,13 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	struct wl1271 *wl = hw->priv;
 	int i;
 
+	unregister_inetaddr_notifier(&wl1271_dev_notifier);
+
 	mutex_lock(&wl->mutex);
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
 
 	wl1271_info("down");
 
-	unregister_inetaddr_notifier(&wl1271_dev_notifier);
 	list_del(&wl->list);
 
 	WARN_ON(wl->state != WL1271_STATE_ON);
-- 
1.6.3.3

