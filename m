Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45541 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab3CLNpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:47 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 11/13] wlcore: AP-mode - recover security seq num for stations
Date: Tue, 12 Mar 2013 15:44:22 +0200
Message-ID: <1363095864-24422-12-git-send-email-coelho@ti.com> (sfid-20130312_151303_842615_18207944)
In-Reply-To: <1363095864-24422-1-git-send-email-coelho@ti.com>
References: <1363095864-24422-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Save the sequence number of the broadcast AP link in the wlvif. For each
connected station, save the sequence number in the drv_priv part of
ieee80211_sta. Use the saved numbers on recovery/resume, with the
obligatory increment on recovery.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c      |    8 +++++++-
 drivers/net/wireless/ti/wlcore/main.c     |   28 ++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    9 +++++++++
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 56d248a..c9e0607 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -366,7 +366,9 @@ void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 	wl1271_tx_reset_link_queues(wl, *hlid);
 	wl->links[*hlid].wlvif = NULL;
 
-	if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
+	if (wlvif->bss_type == BSS_TYPE_STA_BSS ||
+	    (wlvif->bss_type == BSS_TYPE_AP_BSS &&
+	     *hlid == wlvif->ap.bcast_hlid)) {
 		/*
 		 * save the total freed packets in the wlvif, in case this is
 		 * recovery or suspend
@@ -635,6 +637,10 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if (ret < 0)
 		goto out_free_global;
 
+	/* use the previous security seq, if this is a recovery/resume */
+	wl->links[wlvif->ap.bcast_hlid].total_freed_pkts =
+						wlvif->total_freed_pkts;
+
 	cmd->role_id = wlvif->role_id;
 	cmd->ap.aging_period = cpu_to_le16(wl->conf.tx.ap_aging_period);
 	cmd->ap.bss_index = WL1271_AP_BSS_INDEX;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 4da5584..43865d1 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4505,6 +4505,9 @@ static int wl1271_allocate_sta(struct wl1271 *wl,
 		return -EBUSY;
 	}
 
+	/* use the previous security seq, if this is a recovery/resume */
+	wl->links[wl_sta->hlid].total_freed_pkts = wl_sta->total_freed_pkts;
+
 	set_bit(wl_sta->hlid, wlvif->ap.sta_hlid_map);
 	memcpy(wl->links[wl_sta->hlid].addr, sta->addr, ETH_ALEN);
 	wl->active_sta_count++;
@@ -4513,12 +4516,37 @@ static int wl1271_allocate_sta(struct wl1271 *wl,
 
 void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid)
 {
+	struct wl1271_station *wl_sta;
+	struct ieee80211_sta *sta;
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
+
 	if (!test_bit(hlid, wlvif->ap.sta_hlid_map))
 		return;
 
 	clear_bit(hlid, wlvif->ap.sta_hlid_map);
 	__clear_bit(hlid, &wl->ap_ps_map);
 	__clear_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
+
+	/*
+	 * save the last used PN in the private part of iee80211_sta,
+	 * in case of recovery/suspend
+	 */
+	rcu_read_lock();
+	sta = ieee80211_find_sta(vif, wl->links[hlid].addr);
+	if (sta) {
+		wl_sta = (void *)sta->drv_priv;
+		wl_sta->total_freed_pkts = wl->links[hlid].total_freed_pkts;
+
+		/*
+		 * increment the initial seq number on recovery to account for
+		 * transmitted packets that we haven't yet got in the FW status
+		 */
+		if (test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags))
+			wl_sta->total_freed_pkts +=
+					WL1271_TX_SQN_POST_RECOVERY_PADDING;
+	}
+	rcu_read_unlock();
+
 	wl12xx_free_link(wl, wlvif, &hlid);
 	wl->active_sta_count--;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 1ae26ff..ea3c2bb 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -325,6 +325,13 @@ struct wl12xx_rx_filter {
 struct wl1271_station {
 	u8 hlid;
 	bool in_connection;
+
+	/*
+	 * total freed FW packets on the link to the STA - used for tracking the
+	 * AES/TKIP PN across recoveries. Re-initialized each time from the
+	 * wl1271_station structure.
+	 */
+	u64 total_freed_pkts;
 };
 
 struct wl12xx_vif {
@@ -460,6 +467,8 @@ struct wl12xx_vif {
 		/*
 		 * total freed FW packets on the link - used for storing the AES/TKIP
 		 * PN during recovery, as this structure is not zeroed out.
+		 * For STA this holds the PN of the link to the AP.
+		 * For AP this holds the PN of the broadcast link.
 		 */
 		u64 total_freed_pkts;
 	};
-- 
1.7.10.4

