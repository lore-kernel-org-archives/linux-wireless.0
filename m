Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1JJIMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:12:49 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1109073eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:12:48 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/29] wl12xx: configure sleep_policy according to active roles
Date: Mon, 10 Oct 2011 10:12:56 +0200
Message-Id: <1318234397-21081-9-git-send-email-eliad@wizery.com> (sfid-20111010_101252_082166_8E6A89CF)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If there is an active AP role, stay always on.
Otherwise, allow chip to enter elp.

(Note that this is a global configuration, so if the
device is already configured according to our policy,
we don't have to configure it again)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/init.c |   39 ++++++++++++++++++++++++-----------
 1 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 80e89e3..e596f5c 100644
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
@@ -573,13 +563,38 @@ static int wl12xx_init_ap_role(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 {
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct wl12xx_vif *iter, *wlvif = wl12xx_vif_to_data(vif);
 	struct conf_tx_ac_category *conf_ac;
 	struct conf_tx_tid *conf_tid;
 	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
-
+	u8 sta_roles_cnt = 0, ap_roles_cnt = 0;
 	int ret, i;
 
+	wl12xx_for_each_wlvif(wl, iter) {
+		if (iter->bss_type == BSS_TYPE_AP_BSS)
+			ap_roles_cnt++;
+		else
+			sta_roles_cnt++;
+	}
+
+	/*
+	 * consider all existing roles before configuring psm.
+	 * TODO: reconfigure on interface removal.
+	 */
+	if (!ap_roles_cnt) {
+		if (is_ap) {
+			/* Configure for power always on */
+			ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
+			if (ret < 0)
+				return ret;
+		} else if (!sta_roles_cnt) {
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
-- 
1.7.6.401.g6a319

