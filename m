Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51212 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab2KZQGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 11:06:08 -0500
Received: by mail-wg0-f42.google.com with SMTP id dr1so2144136wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 08:06:07 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 06/11] wlcore: use sta_state-based ROCs for AP mode
Date: Mon, 26 Nov 2012 18:05:45 +0200
Message-Id: <1353945950-3899-7-git-send-email-arik@wizery.com> (sfid-20121126_170615_386922_D74737B1)
In-Reply-To: <1353945950-3899-1-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Try an opportunistic ROC when a STA is first added and stop the ROC when
the STA is removed or successfully authenticated. This would ensure we
don't miss auth/assoc/EAPOL packets during connection

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c     |   45 +++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    4 +++
 2 files changed, 49 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index f628297c..45008fa 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4486,6 +4486,45 @@ static int wl12xx_sta_remove(struct wl1271 *wl,
 	return ret;
 }
 
+static void wlcore_roc_if_possible(struct wl1271 *wl,
+				   struct wl12xx_vif *wlvif)
+{
+	if (find_first_bit(wl->roc_map,
+			   WL12XX_MAX_ROLES) < WL12XX_MAX_ROLES)
+		return;
+
+	if (WARN_ON(wlvif->role_id == WL12XX_INVALID_ROLE_ID))
+		return;
+
+	wl12xx_roc(wl, wlvif, wlvif->role_id, wlvif->band, wlvif->channel);
+}
+
+static void wlcore_update_inconn_sta(struct wl1271 *wl,
+				     struct wl12xx_vif *wlvif,
+				     struct wl1271_station *wl_sta,
+				     bool in_connection)
+{
+	if (in_connection) {
+		if (WARN_ON(wl_sta->in_connection))
+			return;
+		wl_sta->in_connection = true;
+		if (!wlvif->inconn_count++)
+			wlcore_roc_if_possible(wl, wlvif);
+	} else {
+		if (!wl_sta->in_connection)
+			return;
+
+		wl_sta->in_connection = false;
+		wlvif->inconn_count--;
+		if (WARN_ON(wlvif->inconn_count < 0))
+			return;
+
+		if (!wlvif->inconn_count)
+			if (test_bit(wlvif->role_id, wl->roc_map))
+				wl12xx_croc(wl, wlvif->role_id);
+	}
+}
+
 static int wl12xx_update_sta_state(struct wl1271 *wl,
 				   struct wl12xx_vif *wlvif,
 				   struct ieee80211_sta *sta,
@@ -4508,6 +4547,8 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 		ret = wl12xx_sta_add(wl, wlvif, sta);
 		if (ret)
 			return ret;
+
+		wlcore_update_inconn_sta(wl, wlvif, wl_sta, true);
 	}
 
 	/* Remove station (AP mode) */
@@ -4516,6 +4557,8 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 	    new_state == IEEE80211_STA_NOTEXIST) {
 		/* must not fail */
 		wl12xx_sta_remove(wl, wlvif, sta);
+
+		wlcore_update_inconn_sta(wl, wlvif, wl_sta, false);
 	}
 
 	/* Authorize station (AP mode) */
@@ -4529,6 +4572,8 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 						     hlid);
 		if (ret)
 			return ret;
+
+		wlcore_update_inconn_sta(wl, wlvif, wl_sta, false);
 	}
 
 	/* Authorize station */
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index e3a77aa..5a92cb2 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -315,6 +315,7 @@ struct wl12xx_rx_filter {
 
 struct wl1271_station {
 	u8 hlid;
+	bool in_connection;
 };
 
 struct wl12xx_vif {
@@ -425,6 +426,9 @@ struct wl12xx_vif {
 	struct delayed_work channel_switch_work;
 	struct delayed_work connection_loss_work;
 
+	/* number of in connection stations */
+	int inconn_count;
+
 	/*
 	 * This struct must be last!
 	 * data that has to be saved acrossed reconfigs (e.g. recovery)
-- 
1.7.9.5

