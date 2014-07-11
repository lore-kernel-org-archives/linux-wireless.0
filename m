Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37211 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaGKAB4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:01:56 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so5254282wib.5
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:01:52 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/14] wlcore: save seq num only between recoveries
Date: Fri, 11 Jul 2014 03:01:26 +0300
Message-Id: <1405036899-27396-2-git-send-email-eliad@wizery.com> (sfid-20140711_020159_095184_7D763AA2)
In-Reply-To: <1405036899-27396-1-git-send-email-eliad@wizery.com>
References: <1405036899-27396-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We want seq num (freed_pkts) to be initialized
on each new connection, but keep persistent
between recoveries/suspends.

Save the freed_pkts in the private block of the
sta struct (we already do a similar thing for
AP's stations).

However, keep the old wlvif->total_freed_pkts
in order to avoid too intrusive change.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c      |  5 +-
 drivers/net/wireless/ti/wlcore/main.c     | 77 +++++++++++++++++++++++--------
 drivers/net/wireless/ti/wlcore/wlcore_i.h | 17 ++++---
 3 files changed, 68 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index e269c0a..d298ead 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -372,9 +372,8 @@ void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 	wl1271_tx_reset_link_queues(wl, *hlid);
 	wl->links[*hlid].wlvif = NULL;
 
-	if (wlvif->bss_type == BSS_TYPE_STA_BSS ||
-	    (wlvif->bss_type == BSS_TYPE_AP_BSS &&
-	     *hlid == wlvif->ap.bcast_hlid)) {
+	if (wlvif->bss_type == BSS_TYPE_AP_BSS &&
+	    *hlid == wlvif->ap.bcast_hlid) {
 		/*
 		 * save the total freed packets in the wlvif, in case this is
 		 * recovery or suspend
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 48f8386..2996cef 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -898,6 +898,41 @@ out:
 	wlcore_set_partition(wl, &old_part);
 }
 
+static void wlcore_save_freed_pkts(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				   u8 hlid, struct ieee80211_sta *sta)
+{
+	struct wl1271_station *wl_sta;
+
+	wl_sta = (void *)sta->drv_priv;
+	wl_sta->total_freed_pkts = wl->links[hlid].total_freed_pkts;
+
+	/*
+	 * increment the initial seq number on recovery to account for
+	 * transmitted packets that we haven't yet got in the FW status
+	 */
+	if (test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags))
+		wl_sta->total_freed_pkts +=
+				WL1271_TX_SQN_POST_RECOVERY_PADDING;
+}
+
+static void wlcore_save_freed_pkts_addr(struct wl1271 *wl,
+					struct wl12xx_vif *wlvif,
+					u8 hlid, const u8 *addr)
+{
+	struct ieee80211_sta *sta;
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
+
+	if (WARN_ON(hlid == WL12XX_INVALID_LINK_ID ||
+		    is_zero_ether_addr(addr)))
+		return;
+
+	rcu_read_lock();
+	sta = ieee80211_find_sta(vif, addr);
+	if (sta)
+		wlcore_save_freed_pkts(wl, wlvif, hlid, sta);
+	rcu_read_unlock();
+}
+
 static void wlcore_print_recovery(struct wl1271 *wl)
 {
 	u32 pc = 0;
@@ -961,6 +996,13 @@ static void wl1271_recovery_work(struct work_struct *work)
 		wlvif = list_first_entry(&wl->wlvif_list,
 				       struct wl12xx_vif, list);
 		vif = wl12xx_wlvif_to_vif(wlvif);
+
+		if (wlvif->bss_type == BSS_TYPE_STA_BSS &&
+		    test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) {
+			wlcore_save_freed_pkts_addr(wl, wlvif, wlvif->sta.hlid,
+						    vif->bss_conf.bssid);
+		}
+
 		__wl1271_op_remove_interface(wl, vif, false);
 	}
 
@@ -4703,10 +4745,6 @@ static int wl1271_allocate_sta(struct wl1271 *wl,
 
 void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid)
 {
-	struct wl1271_station *wl_sta;
-	struct ieee80211_sta *sta;
-	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
-
 	if (!test_bit(hlid, wlvif->ap.sta_hlid_map))
 		return;
 
@@ -4718,21 +4756,7 @@ void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid)
 	 * save the last used PN in the private part of iee80211_sta,
 	 * in case of recovery/suspend
 	 */
-	rcu_read_lock();
-	sta = ieee80211_find_sta(vif, wl->links[hlid].addr);
-	if (sta) {
-		wl_sta = (void *)sta->drv_priv;
-		wl_sta->total_freed_pkts = wl->links[hlid].total_freed_pkts;
-
-		/*
-		 * increment the initial seq number on recovery to account for
-		 * transmitted packets that we haven't yet got in the FW status
-		 */
-		if (test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags))
-			wl_sta->total_freed_pkts +=
-					WL1271_TX_SQN_POST_RECOVERY_PADDING;
-	}
-	rcu_read_unlock();
+	wlcore_save_freed_pkts_addr(wl, wlvif, hlid, wl->links[hlid].addr);
 
 	wl12xx_free_link(wl, wlvif, &hlid);
 	wl->active_sta_count--;
@@ -4915,6 +4939,21 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 		clear_bit(WLVIF_FLAG_STA_STATE_SENT, &wlvif->flags);
 	}
 
+	/* save seq number on disassoc (suspend) */
+	if (is_sta &&
+	    old_state == IEEE80211_STA_ASSOC &&
+	    new_state == IEEE80211_STA_AUTH) {
+		wlcore_save_freed_pkts(wl, wlvif, wlvif->sta.hlid, sta);
+		wlvif->total_freed_pkts = 0;
+	}
+
+	/* restore seq number on assoc (resume) */
+	if (is_sta &&
+	    old_state == IEEE80211_STA_AUTH &&
+	    new_state == IEEE80211_STA_ASSOC) {
+		wlvif->total_freed_pkts = wl_sta->total_freed_pkts;
+	}
+
 	/* clear ROCs on failure or authorization */
 	if (is_sta &&
 	    (new_state == IEEE80211_STA_AUTHORIZED ||
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index c2c34a8..986da43 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -324,6 +324,7 @@ struct wl1271_station {
 	 * total freed FW packets on the link to the STA - used for tracking the
 	 * AES/TKIP PN across recoveries. Re-initialized each time from the
 	 * wl1271_station structure.
+	 * Used in both AP and STA mode.
 	 */
 	u64 total_freed_pkts;
 };
@@ -460,21 +461,19 @@ struct wl12xx_vif {
 	struct delayed_work pending_auth_complete_work;
 
 	/*
+	 * total freed FW packets on the link.
+	 * For STA this holds the PN of the link to the AP.
+	 * For AP this holds the PN of the broadcast link.
+	 */
+	u64 total_freed_pkts;
+
+	/*
 	 * This struct must be last!
 	 * data that has to be saved acrossed reconfigs (e.g. recovery)
 	 * should be declared in this struct.
 	 */
 	struct {
 		u8 persistent[0];
-
-		/*
-		 * total freed FW packets on the link - used for
-		 * storing the AES/TKIP PN during recovery, as this
-		 * structure is not zeroed out.
-		 * For STA this holds the PN of the link to the AP.
-		 * For AP this holds the PN of the broadcast link.
-		 */
-		u64 total_freed_pkts;
 	};
 };
 
-- 
1.8.5.1.109.g3d252a9

