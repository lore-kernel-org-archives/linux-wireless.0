Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:33164 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab0DIIIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 04:08:35 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Subject: [PATCH 3/5] wl1271: Fix mac80211 RTS threshold requests during WL1271_STATE_OFF
Date: Fri,  9 Apr 2010 11:07:28 +0300
Message-Id: <1270800450-8167-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1270800450-8167-1-git-send-email-luciano.coelho@nokia.com>
References: <1270800450-8167-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>

mac80211 sends RTS threshold configuration request even if the wl1271 interface
state is WL1271_STATE_OFF. This leads to failures during pm tests.

This patch leaves the configuration function, if the interface is
going down.

Signed-off-by: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 2eb7b99..4adc516 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1582,10 +1582,13 @@ out:
 static int wl1271_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
 	struct wl1271 *wl = hw->priv;
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&wl->mutex);
 
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
 	ret = wl1271_ps_elp_wakeup(wl, false);
 	if (ret < 0)
 		goto out;
-- 
1.6.3.3

