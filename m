Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44026 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab1BLVZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 16:25:26 -0500
Received: by wyb28 with SMTP id 28so3613197wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 Feb 2011 13:25:24 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] wl12xx: avoid blocking while holding rcu lock on bss info change
Date: Sat, 12 Feb 2011 23:24:20 +0200
Message-Id: <1297545860-26313-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some blocking functions were called while holding the rcu lock for
accessing STA information. This can lead to a deadlock.

Save the required info beforehand and release the rcu without
blocking.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 61dea73..40b1bf1 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2218,6 +2218,8 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 	u32 sta_rate_set = 0;
 	int ret;
 	struct ieee80211_sta *sta;
+	bool sta_exists = false;
+	struct ieee80211_sta_ht_cap sta_ht_cap;
 
 	if (is_ibss) {
 		ret = wl1271_bss_beacon_info_changed(wl, vif, bss_conf,
@@ -2289,16 +2291,20 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		if (sta->ht_cap.ht_supported)
 			sta_rate_set |=
 			    (sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET);
+		sta_ht_cap = sta->ht_cap;
+		sta_exists = true;
+	}
+	rcu_read_unlock();
 
+	if (sta_exists) {
 		/* handle new association with HT and HT information change */
 		if ((changed & BSS_CHANGED_HT) &&
 		    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
-			ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap,
+			ret = wl1271_acx_set_ht_capabilities(wl, &sta_ht_cap,
 							     true);
 			if (ret < 0) {
 				wl1271_warning("Set ht cap true failed %d",
 					       ret);
-				rcu_read_unlock();
 				goto out;
 			}
 			ret = wl1271_acx_set_ht_information(wl,
@@ -2306,23 +2312,20 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			if (ret < 0) {
 				wl1271_warning("Set ht information failed %d",
 					       ret);
-				rcu_read_unlock();
 				goto out;
 			}
 		}
 		/* handle new association without HT and disassociation */
 		else if (changed & BSS_CHANGED_ASSOC) {
-			ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap,
+			ret = wl1271_acx_set_ht_capabilities(wl, &sta_ht_cap,
 							     false);
 			if (ret < 0) {
 				wl1271_warning("Set ht cap false failed %d",
 					       ret);
-				rcu_read_unlock();
 				goto out;
 			}
 		}
 	}
-	rcu_read_unlock();
 
 	if ((changed & BSS_CHANGED_ASSOC)) {
 		if (bss_conf->assoc) {
-- 
1.7.1

