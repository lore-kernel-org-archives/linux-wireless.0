Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33470 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934618AbdAKPhw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 10:37:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] mac80211: recalculate min channel width on VHT opmode changes
Date: Wed, 11 Jan 2017 16:37:48 +0100
Message-Id: <20170111153748.797-3-johannes@sipsolutions.net> (sfid-20170111_163802_738633_7BD49374)
In-Reply-To: <20170111153748.797-1-johannes@sipsolutions.net>
References: <20170111153748.797-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When an associated station changes its VHT operating mode this
can/will affect the bandwidth it's using, and consequently we
must recalculate the minimum bandwidth we need to use. Failure
to do so can lead to one of two scenarios:
 1) we use a too high bandwidth, this is benign
 2) we use a too narrow bandwidth, causing rate control and
    actual PHY configuration to be out of sync, which can in
    turn cause problems/crashes

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 21 +++++++++++++++++++++
 net/mac80211/rx.c    |  9 +--------
 net/mac80211/vht.c   |  4 +++-
 3 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 41497b670e2b..d37ae7dc114b 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -6,6 +6,7 @@
  * Copyright (c) 2006 Jiri Benc <jbenc@suse.cz>
  * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright (c) 2016        Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1295,6 +1296,26 @@ static void ieee80211_iface_work(struct work_struct *work)
 		} else if (ieee80211_is_action(mgmt->frame_control) &&
 			   mgmt->u.action.category == WLAN_CATEGORY_VHT) {
 			switch (mgmt->u.action.u.vht_group_notif.action_code) {
+			case WLAN_VHT_ACTION_OPMODE_NOTIF: {
+				struct ieee80211_rx_status *status;
+				enum nl80211_band band;
+				u8 opmode;
+
+				status = IEEE80211_SKB_RXCB(skb);
+				band = status->band;
+				opmode = mgmt->u.action.u.vht_opmode_notif.operating_mode;
+
+				mutex_lock(&local->sta_mtx);
+				sta = sta_info_get_bss(sdata, mgmt->sa);
+
+				if (sta)
+					ieee80211_vht_handle_opmode(sdata, sta,
+								    opmode,
+								    band);
+
+				mutex_unlock(&local->sta_mtx);
+				break;
+			}
 			case WLAN_VHT_ACTION_GROUPID_MGMT:
 				ieee80211_process_mu_groups(sdata, mgmt);
 				break;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c87e61358b77..3090dd4342f6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2881,17 +2881,10 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 
 		switch (mgmt->u.action.u.vht_opmode_notif.action_code) {
 		case WLAN_VHT_ACTION_OPMODE_NOTIF: {
-			u8 opmode;
-
 			/* verify opmode is present */
 			if (len < IEEE80211_MIN_ACTION_SIZE + 2)
 				goto invalid;
-
-			opmode = mgmt->u.action.u.vht_opmode_notif.operating_mode;
-
-			ieee80211_vht_handle_opmode(rx->sdata, rx->sta,
-						    opmode, status->band);
-			goto handled;
+			goto queue;
 		}
 		case WLAN_VHT_ACTION_GROUPID_MGMT: {
 			if (len < IEEE80211_MIN_ACTION_SIZE + 25)
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 6832bf6ab69f..43e45bb660bc 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -527,8 +527,10 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 
 	u32 changed = __ieee80211_vht_handle_opmode(sdata, sta, opmode, band);
 
-	if (changed > 0)
+	if (changed > 0) {
+		ieee80211_recalc_min_chandef(sdata);
 		rate_control_rate_update(local, sband, sta, changed);
+	}
 }
 
 void ieee80211_get_vht_mask_from_cap(__le16 vht_cap,
-- 
2.9.3
