Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:33153 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab0DIIIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 04:08:32 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Subject: [PATCH 2/5] wl1271: Fix mac80211 configuration requests during WL1271_STATE_OFF
Date: Fri,  9 Apr 2010 11:07:27 +0300
Message-Id: <1270800450-8167-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1270800450-8167-1-git-send-email-luciano.coelho@nokia.com>
References: <1270800450-8167-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>

mac80211 sends configuration requests even if the wl1271 interface
state is WL1271_STATE_OFF. This creates warnings from mac80211.

This patch leaves the configuration functions, if the interface is
going down.

Signed-off-by: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 4e97540..2eb7b99 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1223,6 +1223,9 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&wl->mutex);
 
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
 	ret = wl1271_ps_elp_wakeup(wl, false);
 	if (ret < 0)
 		goto out;
@@ -1324,8 +1327,12 @@ static u64 wl1271_op_prepare_multicast(struct ieee80211_hw *hw, int mc_count,
 				       struct dev_addr_list *mc_list)
 {
 	struct wl1271_filter_params *fp;
+	struct wl1271 *wl = hw->priv;
 	int i;
 
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		return 0;
+
 	fp = kzalloc(sizeof(*fp), GFP_ATOMIC);
 	if (!fp) {
 		wl1271_error("Out of memory setting filters.");
@@ -1372,15 +1379,16 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state == WL1271_STATE_OFF)
+	*total &= WL1271_SUPPORTED_FILTERS;
+	changed &= WL1271_SUPPORTED_FILTERS;
+
+	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl, false);
 	if (ret < 0)
 		goto out;
 
-	*total &= WL1271_SUPPORTED_FILTERS;
-	changed &= WL1271_SUPPORTED_FILTERS;
 
 	if (*total & FIF_ALLMULTI)
 		ret = wl1271_acx_group_address_tbl(wl, false, NULL, 0);
-- 
1.6.3.3

