Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40352 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab0GHOud (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 10:50:33 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 09/13] wl1271: Fix warning when disconnecting and ad-hoc network
Date: Thu,  8 Jul 2010 17:50:04 +0300
Message-Id: <1278600608-22411-10-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
References: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 366e415..d50c0a9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -938,7 +938,8 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	WARN_ON(wl->state != WL1271_STATE_ON);
 
 	/* enable dyn ps just in case (if left on due to fw crash etc) */
-	ieee80211_disable_dyn_ps(wl->vif, false);
+	if (wl->bss_type == BSS_TYPE_STA_BSS)
+		ieee80211_disable_dyn_ps(wl->vif, false);
 
 	if (test_and_clear_bit(WL1271_FLAG_SCANNING, &wl->flags)) {
 		mutex_unlock(&wl->mutex);
-- 
1.6.3.3

