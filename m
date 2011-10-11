Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48516 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1JKJzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 05:55:53 -0400
Received: by ggnv2 with SMTP id v2so5474018ggn.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 02:55:52 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 08/29] wl12xx: configure sleep_policy according to active roles
Date: Tue, 11 Oct 2011 11:49:15 +0200
Message-Id: <1318326555-13905-1-git-send-email-eliad@wizery.com> (sfid-20111011_115556_235583_EA2C49FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If there is an active AP role, stay always on.
Otherwise, allow chip to enter elp.

(Note that this is a global configuration, so if the
device is already configured according to our policy,
we don't have to configure it again)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: use ap_count/sta_count instead of iterating

 drivers/net/wireless/wl12xx/init.c   |   29 ++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/main.c   |   10 ++++++++++
 drivers/net/wireless/wl12xx/wl12xx.h |    2 ++
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 80e89e3..4af7e2f 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -343,11 +343,6 @@ static int wl1271_sta_hw_init(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if (ret < 0)
 		return ret;
 
-	/* Configure for ELP power saving */
-	ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
-	if (ret < 0)
-		return ret;
-
 	ret = wl1271_acx_sta_rate_policies(wl, wlvif);
 	if (ret < 0)
 		return ret;
@@ -382,11 +377,6 @@ static int wl1271_ap_hw_init(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret;
 
-	/* Configure for power always on */
-	ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
-	if (ret < 0)
-		return ret;
-
 	ret = wl1271_init_ap_rates(wl, wlvif);
 	if (ret < 0)
 		return ret;
@@ -577,9 +567,26 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 	struct conf_tx_ac_category *conf_ac;
 	struct conf_tx_tid *conf_tid;
 	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
-
 	int ret, i;
 
+	/*
+	 * consider all existing roles before configuring psm.
+	 * TODO: reconfigure on interface removal.
+	 */
+	if (!wl->ap_count) {
+		if (is_ap) {
+			/* Configure for power always on */
+			ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
+			if (ret < 0)
+				return ret;
+		} else if (!wl->sta_count) {
+			/* Configure for ELP power saving */
+			ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
 	/* Mode specific init */
 	if (is_ap) {
 		ret = wl1271_ap_hw_init(wl, wlvif);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 0623f5d..b52deac 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2117,6 +2117,11 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	wl->vif = vif;
 	list_add(&wlvif->list, &wl->wlvif_list);
 	set_bit(WL1271_FLAG_IF_INITIALIZED, &wl->flags);
+
+	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
+		wl->ap_count++;
+	else
+		wl->sta_count++;
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -2188,6 +2193,11 @@ deinit:
 	wlvif->role_id = WL12XX_INVALID_ROLE_ID;
 	wlvif->dev_role_id = WL12XX_INVALID_ROLE_ID;
 
+	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
+		wl->ap_count--;
+	else
+		wl->sta_count--;
+
 	mutex_unlock(&wl->mutex);
 	cancel_delayed_work_sync(&wlvif->pspoll_work);
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 55561c5..fd78f8c 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -395,6 +395,8 @@ struct wl1271 {
 	unsigned long roc_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
 
 	struct list_head wlvif_list;
+	u8 sta_count;
+	u8 ap_count;
 
 	struct wl1271_acx_mem_map *target_mem_map;
 
-- 
1.7.6.401.g6a319

