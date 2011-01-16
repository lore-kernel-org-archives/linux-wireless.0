Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36091 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1APFmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 00:42:37 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so4134866wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jan 2011 21:42:36 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 08/10] wl12xx: AP mode - fix bug in cleanup of wl1271_op_sta_add()
Date: Sun, 16 Jan 2011 07:42:12 +0200
Message-Id: <1295156534-4178-9-git-send-email-arik@wizery.com>
In-Reply-To: <1295156534-4178-1-git-send-email-arik@wizery.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove an active hlid when chip wakeup fails. In addition rename the
involved functions.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 77c8974..d600cff 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2611,7 +2611,7 @@ static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
 	return 0;
 }
 
-static int wl1271_allocate_hlid(struct wl1271 *wl,
+static int wl1271_allocate_sta(struct wl1271 *wl,
 			     struct ieee80211_sta *sta,
 			     u8 *hlid)
 {
@@ -2632,10 +2632,13 @@ static int wl1271_allocate_hlid(struct wl1271 *wl,
 	return 0;
 }
 
-static void wl1271_free_hlid(struct wl1271 *wl, u8 hlid)
+static void wl1271_free_sta(struct wl1271 *wl, u8 hlid)
 {
 	int id = hlid - WL1271_AP_STA_HLID_START;
 
+	if (WARN_ON(!test_bit(id, wl->ap_hlid_map)))
+		return;
+
 	__clear_bit(id, wl->ap_hlid_map);
 	wl1271_tx_reset_link_queues(wl, hlid);
 }
@@ -2658,13 +2661,13 @@ static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 add sta %d", (int)sta->aid);
 
-	ret = wl1271_allocate_hlid(wl, sta, &hlid);
+	ret = wl1271_allocate_sta(wl, sta, &hlid);
 	if (ret < 0)
 		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl, false);
 	if (ret < 0)
-		goto out;
+		goto out_free_sta;
 
 	ret = wl1271_cmd_add_sta(wl, sta, hlid);
 	if (ret < 0)
@@ -2673,6 +2676,10 @@ static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
 
+out_free_sta:
+	if (ret < 0)
+		wl1271_free_sta(wl, hlid);
+
 out:
 	mutex_unlock(&wl->mutex);
 	return ret;
@@ -2709,7 +2716,7 @@ static int wl1271_op_sta_remove(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out_sleep;
 
-	wl1271_free_hlid(wl, wl_sta->hlid);
+	wl1271_free_sta(wl, wl_sta->hlid);
 
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
-- 
1.7.1

