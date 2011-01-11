Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:42751 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246Ab1AKSHJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 13:07:09 -0500
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p0BI78cj030459
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 12:07:09 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep34.itg.ti.com (8.13.7/8.13.7) with ESMTP id p0BI782e021520
	for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 12:07:08 -0600 (CST)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p0BI784t023603
	for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 12:07:08 -0600 (CST)
From: <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: jonathanc@ti.com
Subject: [PATCH] wl12xx: lock the RCU when accessing sta via ieee80211_find_sta()
Date: Tue, 11 Jan 2011 20:07:21 +0200
Message-ID: <1294769241-3118-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

We were calling ieee80211_find_sta() and the sta returned by it
without locking the RCU, which is required by mac80211.

Fix this and reorganize slightly the area of the code where the sta is
used.

Reported-by: Jonathan DE CESCO <jonathanc@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |   60 +++++++++++++++++++----------------
 1 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 862ec9c..67732ea 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2219,7 +2219,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 	bool do_join = false, set_assoc = false;
 	bool is_ibss = (wl->bss_type == BSS_TYPE_IBSS);
 	int ret;
-	struct ieee80211_sta *sta = ieee80211_find_sta(vif, bss_conf->bssid);
+	struct ieee80211_sta *sta;
 
 	if (is_ibss) {
 		ret = wl1271_bss_beacon_info_changed(wl, vif, bss_conf,
@@ -2376,36 +2376,42 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 	if (ret < 0)
 		goto out;
 
-	/*
-	 * Takes care of: New association with HT enable,
-	 *                HT information change in beacon.
-	 */
-	if (sta &&
-	    (changed & BSS_CHANGED_HT) &&
-	    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
-		ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap, true);
-		if (ret < 0) {
-			wl1271_warning("Set ht cap true failed %d", ret);
-			goto out;
-		}
+	rcu_read_lock();
+	sta = ieee80211_find_sta(vif, bss_conf->bssid);
+	if (sta)  {
+		/* handle new association with HT and HT information change */
+		if ((changed & BSS_CHANGED_HT) &&
+		    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
+			ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap,
+							     true);
+			if (ret < 0) {
+				wl1271_warning("Set ht cap true failed %d",
+					       ret);
+				rcu_read_unlock();
+				goto out;
+			}
 			ret = wl1271_acx_set_ht_information(wl,
-				bss_conf->ht_operation_mode);
-		if (ret < 0) {
-			wl1271_warning("Set ht information failed %d", ret);
-			goto out;
+						bss_conf->ht_operation_mode);
+			if (ret < 0) {
+				wl1271_warning("Set ht information failed %d",
+					       ret);
+				rcu_read_unlock();
+				goto out;
+			}
 		}
-	}
-	/*
-	 * Takes care of: New association without HT,
-	 *                Disassociation.
-	 */
-	else if (sta && (changed & BSS_CHANGED_ASSOC)) {
-		ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap, false);
-		if (ret < 0) {
-			wl1271_warning("Set ht cap false failed %d", ret);
-			goto out;
+		/* handle new association without HT and disassociation */
+		else if (changed & BSS_CHANGED_ASSOC) {
+			ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap,
+							     false);
+			if (ret < 0) {
+				wl1271_warning("Set ht cap false failed %d",
+					       ret);
+				rcu_read_unlock();
+				goto out;
+			}
 		}
 	}
+	rcu_read_unlock();
 
 	if (changed & BSS_CHANGED_ARP_FILTER) {
 		__be32 addr = bss_conf->arp_addr_list[0];
-- 
1.7.1

