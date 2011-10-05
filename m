Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35975 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934324Ab1JEJ4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:31 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so1405752eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:30 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 28/29] wl12xx: move ap_hlid_map into wlvif.ap
Date: Wed,  5 Oct 2011 11:56:05 +0200
Message-Id: <1317808566-18857-29-git-send-email-eliad@wizery.com> (sfid-20111005_115639_844045_CC512EE7)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add wlvif->links_map bitmap to represent all the links
allocated for this vif.

AP vif also has a sta_hlid_map bitmap, which represents
the links stations connected to it (sta_hlid_bitmap is
a subset of wlvif->links_map, which itself is a subset
of the global wl->links_map)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c     |   34 ++++++------
 drivers/net/wireless/wl12xx/cmd.h     |    3 +
 drivers/net/wireless/wl12xx/debugfs.c |    1 -
 drivers/net/wireless/wl12xx/event.c   |   15 +++---
 drivers/net/wireless/wl12xx/event.h   |    3 -
 drivers/net/wireless/wl12xx/main.c    |   92 ++++++++++++++-------------------
 drivers/net/wireless/wl12xx/tx.c      |   35 ++++++------
 drivers/net/wireless/wl12xx/tx.h      |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h  |   24 +++------
 9 files changed, 92 insertions(+), 117 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 911f720..9f1c749 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -434,23 +434,25 @@ out:
 	return ret;
 }
 
-static int wl12xx_allocate_link(struct wl1271 *wl, u8 *hlid)
+int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 {
 	u8 link = find_first_zero_bit(wl->links_map, WL12XX_MAX_LINKS);
 	if (link >= WL12XX_MAX_LINKS)
 		return -EBUSY;
 
 	__set_bit(link, wl->links_map);
+	__set_bit(link, wlvif->links_map);
 	*hlid = link;
 	return 0;
 }
 
-static void wl12xx_free_link(struct wl1271 *wl, u8 *hlid)
+void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 {
 	if (*hlid == WL12XX_INVALID_LINK_ID)
 		return;
 
 	__clear_bit(*hlid, wl->links_map);
+	__clear_bit(*hlid, wlvif->links_map);
 	*hlid = WL12XX_INVALID_LINK_ID;
 }
 
@@ -484,7 +486,7 @@ int wl12xx_cmd_role_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->channel = wl->channel;
 
 	if (wlvif->dev_hlid == WL12XX_INVALID_LINK_ID) {
-		ret = wl12xx_allocate_link(wl, &wlvif->dev_hlid);
+		ret = wl12xx_allocate_link(wl, wlvif, &wlvif->dev_hlid);
 		if (ret)
 			goto out_free;
 	}
@@ -504,7 +506,7 @@ int wl12xx_cmd_role_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 err_hlid:
 	/* clear links on error */
-	wl12xx_free_link(wl, &wlvif->dev_hlid);
+	wl12xx_free_link(wl, wlvif, &wlvif->dev_hlid);
 
 out_free:
 	kfree(cmd);
@@ -545,7 +547,7 @@ int wl12xx_cmd_role_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		goto out_free;
 	}
 
-	wl12xx_free_link(wl, &wlvif->dev_hlid);
+	wl12xx_free_link(wl, wlvif, &wlvif->dev_hlid);
 
 out_free:
 	kfree(cmd);
@@ -581,7 +583,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->sta.local_rates = cpu_to_le32(wlvif->rate_set);
 
 	if (wlvif->sta.hlid == WL12XX_INVALID_LINK_ID) {
-		ret = wl12xx_allocate_link(wl, &wlvif->sta.hlid);
+		ret = wl12xx_allocate_link(wl, wlvif, &wlvif->sta.hlid);
 		if (ret)
 			goto out_free;
 	}
@@ -604,7 +606,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 err_hlid:
 	/* clear links on error. */
-	wl12xx_free_link(wl, &wlvif->sta.hlid);
+	wl12xx_free_link(wl, wlvif, &wlvif->sta.hlid);
 
 out_free:
 	kfree(cmd);
@@ -640,7 +642,7 @@ int wl12xx_cmd_role_stop_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		goto out_free;
 	}
 
-	wl12xx_free_link(wl, &wlvif->sta.hlid);
+	wl12xx_free_link(wl, wlvif, &wlvif->sta.hlid);
 
 out_free:
 	kfree(cmd);
@@ -670,11 +672,11 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		goto out;
 	}
 
-	ret = wl12xx_allocate_link(wl, &wlvif->ap.global_hlid);
+	ret = wl12xx_allocate_link(wl, wlvif, &wlvif->ap.global_hlid);
 	if (ret < 0)
 		goto out_free;
 
-	ret = wl12xx_allocate_link(wl, &wlvif->ap.bcast_hlid);
+	ret = wl12xx_allocate_link(wl, wlvif, &wlvif->ap.bcast_hlid);
 	if (ret < 0)
 		goto out_free_global;
 
@@ -724,10 +726,10 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	goto out_free;
 
 out_free_bcast:
-	wl12xx_free_link(wl, &wlvif->ap.bcast_hlid);
+	wl12xx_free_link(wl, wlvif, &wlvif->ap.bcast_hlid);
 
 out_free_global:
-	wl12xx_free_link(wl, &wlvif->ap.global_hlid);
+	wl12xx_free_link(wl, wlvif, &wlvif->ap.global_hlid);
 
 out_free:
 	kfree(cmd);
@@ -757,8 +759,8 @@ int wl12xx_cmd_role_stop_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		goto out_free;
 	}
 
-	wl12xx_free_link(wl, &wlvif->ap.bcast_hlid);
-	wl12xx_free_link(wl, &wlvif->ap.global_hlid);
+	wl12xx_free_link(wl, wlvif, &wlvif->ap.bcast_hlid);
+	wl12xx_free_link(wl, wlvif, &wlvif->ap.global_hlid);
 
 out_free:
 	kfree(cmd);
@@ -796,7 +798,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->sta.local_rates = cpu_to_le32(wlvif->rate_set);
 
 	if (wlvif->sta.hlid == WL12XX_INVALID_LINK_ID) {
-		ret = wl12xx_allocate_link(wl, &wlvif->sta.hlid);
+		ret = wl12xx_allocate_link(wl, wlvif, &wlvif->sta.hlid);
 		if (ret)
 			goto out_free;
 	}
@@ -821,7 +823,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 err_hlid:
 	/* clear links on error. */
-	wl12xx_free_link(wl, &wlvif->sta.hlid);
+	wl12xx_free_link(wl, wlvif, &wlvif->sta.hlid);
 
 out_free:
 	kfree(cmd);
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index d1a88c4..b42a4c4 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -86,6 +86,9 @@ int wl12xx_cmd_remove_peer(struct wl1271 *wl, u8 hlid);
 int wl12xx_cmd_config_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_start_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_stop_fwlog(struct wl1271 *wl);
+int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			 u8 *hlid);
+void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid);
 
 enum wl1271_commands {
 	CMD_INTERROGATE     = 1,    /*use this to read information elements*/
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index ee42a43..f0398d0 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -355,7 +355,6 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_INT(sg_enabled);
 	DRIVER_STATE_PRINT_INT(enable_11a);
 	DRIVER_STATE_PRINT_INT(noise);
-	DRIVER_STATE_PRINT_LHEX(ap_hlid_map[0]);
 	DRIVER_STATE_PRINT_INT(last_tx_hlid);
 	DRIVER_STATE_PRINT_HEX(ap_fw_ps_map);
 	DRIVER_STATE_PRINT_LHEX(ap_ps_map);
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index c941533..20d04a1f 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -189,11 +189,12 @@ static void wl1271_stop_ba_event(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		ieee80211_stop_rx_ba_session(wl->vif, wlvif->sta.ba_rx_bitmap,
 					     wl->vif->bss_conf.bssid);
 	} else {
-		int i;
+		u8 hlid;
 		struct wl1271_link *lnk;
-		for (i = WL1271_AP_STA_HLID_START; i < AP_MAX_LINKS; i++) {
-			lnk = &wl->links[i];
-			if (!wl1271_is_active_sta(wl, i) || !lnk->ba_bitmap)
+		for_each_set_bit(hlid, wlvif->ap.sta_hlid_map,
+				 WL12XX_MAX_LINKS) {
+			lnk = &wl->links[hlid];
+			if (!lnk->ba_bitmap)
 				continue;
 
 			ieee80211_stop_rx_ba_session(wl->vif,
@@ -340,10 +341,8 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		const u8 *addr;
 		int h;
 
-		for (h = find_first_bit(&sta_bitmap, AP_MAX_LINKS);
-		     h < AP_MAX_LINKS;
-		     h = find_next_bit(&sta_bitmap, AP_MAX_LINKS, h+1)) {
-			if (!wl1271_is_active_sta(wl, h))
+		for_each_set_bit(h, &sta_bitmap, WL12XX_MAX_LINKS) {
+			if (!test_bit(h, wlvif->ap.sta_hlid_map))
 				continue;
 
 			addr = wl->links[h].addr;
diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/wl12xx/event.h
index 49c1a0e..1d878ba 100644
--- a/drivers/net/wireless/wl12xx/event.h
+++ b/drivers/net/wireless/wl12xx/event.h
@@ -132,7 +132,4 @@ void wl1271_event_mbox_config(struct wl1271 *wl);
 int wl1271_event_handle(struct wl1271 *wl, u8 mbox);
 void wl1271_pspoll_work(struct work_struct *work);
 
-/* Functions from main.c */
-bool wl1271_is_active_sta(struct wl1271 *wl, u8 hlid);
-
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index a45c4bb..6deb507 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -778,10 +778,6 @@ static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl, u8 hlid, u8 tx_pkts)
 {
 	bool fw_ps, single_sta;
 
-	/* only regulate station links */
-	if (hlid < WL1271_AP_STA_HLID_START)
-		return;
-
 	fw_ps = test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 	single_sta = (wl->active_sta_count == 1);
 
@@ -801,21 +797,11 @@ static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl, u8 hlid, u8 tx_pkts)
 		wl1271_ps_link_start(wl, hlid, true);
 }
 
-bool wl1271_is_active_sta(struct wl1271 *wl, u8 hlid)
-{
-	int id;
-
-	/* global/broadcast "stations" are always active */
-	if (hlid < WL1271_AP_STA_HLID_START)
-		return true;
-
-	id = hlid - WL1271_AP_STA_HLID_START;
-	return test_bit(id, wl->ap_hlid_map);
-}
-
 static void wl12xx_irq_update_links_status(struct wl1271 *wl,
+					   struct wl12xx_vif *wlvif,
 					   struct wl12xx_fw_status *status)
 {
+	struct wl1271_link *lnk;
 	u32 cur_fw_ps_map;
 	u8 hlid, cnt;
 
@@ -831,19 +817,14 @@ static void wl12xx_irq_update_links_status(struct wl1271 *wl,
 		wl->ap_fw_ps_map = cur_fw_ps_map;
 	}
 
-	for (hlid = WL1271_AP_STA_HLID_START; hlid < AP_MAX_LINKS; hlid++) {
-		if (!wl1271_is_active_sta(wl, hlid))
-			continue;
-
-		cnt = status->tx_lnk_free_pkts[hlid] -
-		      wl->links[hlid].prev_freed_pkts;
+	for_each_set_bit(hlid, wlvif->ap.sta_hlid_map, WL12XX_MAX_LINKS) {
+		lnk = &wl->links[hlid];
+		cnt = status->tx_lnk_free_pkts[hlid] - lnk->prev_freed_pkts;
 
-		wl->links[hlid].prev_freed_pkts =
-			status->tx_lnk_free_pkts[hlid];
-		wl->links[hlid].allocated_pkts -= cnt;
+		lnk->prev_freed_pkts = status->tx_lnk_free_pkts[hlid];
+		lnk->allocated_pkts -= cnt;
 
-		wl12xx_irq_ps_regulate_link(wl, hlid,
-					    wl->links[hlid].allocated_pkts);
+		wl12xx_irq_ps_regulate_link(wl, hlid, lnk->allocated_pkts);
 	}
 }
 
@@ -907,7 +888,7 @@ static void wl12xx_fw_status(struct wl1271 *wl,
 
 	/* for AP update num of allocated TX blocks per link and ps status */
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
-		wl12xx_irq_update_links_status(wl, status);
+		wl12xx_irq_update_links_status(wl, wlvif, status);
 
 	/* update the host-chipset time offset */
 	getnstimeofday(&ts);
@@ -1505,7 +1486,7 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	/* queue the packet */
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
-		if (!wl1271_is_active_sta(wl, hlid)) {
+		if (!test_bit(hlid, wlvif->links_map)) {
 			wl1271_debug(DEBUG_TX, "DROP skb hlid %d q %d",
 				     hlid, q);
 			dev_kfree_skb(skb);
@@ -2152,7 +2133,7 @@ deinit:
 	wl->vif = NULL;
 	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
 	wl1271_free_ap_keys(wl);
-	memset(wl->ap_hlid_map, 0, sizeof(wl->ap_hlid_map));
+	memset(wlvif->ap.sta_hlid_map, 0, sizeof(wlvif->ap.sta_hlid_map));
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
 	wl->sched_scanning = false;
@@ -3940,43 +3921,44 @@ static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
 }
 
 static int wl1271_allocate_sta(struct wl1271 *wl,
-			     struct ieee80211_sta *sta,
-			     u8 *hlid)
+			     struct wl12xx_vif *wlvif,
+			     struct ieee80211_sta *sta)
 {
 	struct wl1271_station *wl_sta;
-	int id;
+	int ret;
 
-	id = find_first_zero_bit(wl->ap_hlid_map, AP_MAX_STATIONS);
-	if (id >= AP_MAX_STATIONS) {
+
+	if (wl->active_sta_count >= AP_MAX_STATIONS) {
 		wl1271_warning("could not allocate HLID - too much stations");
 		return -EBUSY;
 	}
 
 	wl_sta = (struct wl1271_station *)sta->drv_priv;
-	set_bit(id, wl->ap_hlid_map);
-	wl_sta->hlid = WL1271_AP_STA_HLID_START + id;
-	*hlid = wl_sta->hlid;
+	ret = wl12xx_allocate_link(wl, wlvif, &wl_sta->hlid);
+	if (ret < 0) {
+		wl1271_warning("could not allocate HLID - too many links");
+		return -EBUSY;
+	}
+
+	set_bit(wl_sta->hlid, wlvif->ap.sta_hlid_map);
 	memcpy(wl->links[wl_sta->hlid].addr, sta->addr, ETH_ALEN);
 	wl->active_sta_count++;
 	return 0;
 }
 
-void wl1271_free_sta(struct wl1271 *wl, u8 hlid)
+/* TODO: change wl1271_tx_reset(), so we can get sta as param */
+void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid)
 {
-	int id = hlid - WL1271_AP_STA_HLID_START;
-
-	if (hlid < WL1271_AP_STA_HLID_START)
+	if (!test_bit(hlid, wlvif->ap.sta_hlid_map))
 		return;
 
-	if (!test_bit(id, wl->ap_hlid_map))
-		return;
-
-	clear_bit(id, wl->ap_hlid_map);
+	clear_bit(hlid, wlvif->ap.sta_hlid_map);
 	memset(wl->links[hlid].addr, 0, ETH_ALEN);
 	wl->links[hlid].ba_bitmap = 0;
 	wl1271_tx_reset_link_queues(wl, hlid);
 	__clear_bit(hlid, &wl->ap_ps_map);
 	__clear_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
+	wl12xx_free_link(wl, wlvif, &hlid);
 	wl->active_sta_count--;
 }
 
@@ -3986,6 +3968,7 @@ static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 {
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct wl1271_station *wl_sta;
 	int ret = 0;
 	u8 hlid;
 
@@ -3999,10 +3982,13 @@ static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 add sta %d", (int)sta->aid);
 
-	ret = wl1271_allocate_sta(wl, sta, &hlid);
+	ret = wl1271_allocate_sta(wl, wlvif, sta);
 	if (ret < 0)
 		goto out;
 
+	wl_sta = (struct wl1271_station *)sta->drv_priv;
+	hlid = wl_sta->hlid;
+
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out_free_sta;
@@ -4024,7 +4010,7 @@ out_sleep:
 
 out_free_sta:
 	if (ret < 0)
-		wl1271_free_sta(wl, hlid);
+		wl1271_free_sta(wl, wlvif, hlid);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -4051,8 +4037,8 @@ static int wl1271_op_sta_remove(struct ieee80211_hw *hw,
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove sta %d", (int)sta->aid);
 
 	wl_sta = (struct wl1271_station *)sta->drv_priv;
-	id = wl_sta->hlid - WL1271_AP_STA_HLID_START;
-	if (WARN_ON(!test_bit(id, wl->ap_hlid_map)))
+	id = wl_sta->hlid;
+	if (WARN_ON(!test_bit(id, wlvif->ap.sta_hlid_map)))
 		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl);
@@ -4063,7 +4049,7 @@ static int wl1271_op_sta_remove(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out_sleep;
 
-	wl1271_free_sta(wl, wl_sta->hlid);
+	wl1271_free_sta(wl, wlvif, wl_sta->hlid);
 
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
@@ -4800,7 +4786,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	int i, j, ret;
 	unsigned int order;
 
-	BUILD_BUG_ON(AP_MAX_LINKS > WL12XX_MAX_LINKS);
+	BUILD_BUG_ON(AP_MAX_STATIONS > WL12XX_MAX_LINKS);
 
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1271_ops);
 	if (!hw) {
@@ -4828,7 +4814,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 		skb_queue_head_init(&wl->tx_queue[i]);
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
-		for (j = 0; j < AP_MAX_LINKS; j++)
+		for (j = 0; j < WL12XX_MAX_LINKS; j++)
 			skb_queue_head_init(&wl->links[j].tx_queue[i]);
 
 	skb_queue_head_init(&wl->deferred_rx_queue);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 6ce6163..1b3d8e3 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -125,18 +125,16 @@ static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
 		wl1271_acx_set_inconnection_sta(wl, hdr->addr1);
 }
 
-static void wl1271_tx_regulate_link(struct wl1271 *wl, u8 hlid)
+static void wl1271_tx_regulate_link(struct wl1271 *wl,
+				    struct wl12xx_vif *wlvif,
+				    u8 hlid)
 {
 	bool fw_ps, single_sta;
 	u8 tx_pkts;
 
-	/* only regulate station links */
-	if (hlid < WL1271_AP_STA_HLID_START)
+	if (WARN_ON(!test_bit(hlid, wlvif->links_map)))
 		return;
 
-	if (WARN_ON(!wl1271_is_active_sta(wl, hlid)))
-	    return;
-
 	fw_ps = test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 	tx_pkts = wl->links[hlid].allocated_pkts;
 	single_sta = (wl->active_sta_count == 1);
@@ -266,7 +264,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct ieee80211_vif *vif,
 		wl->tx_allocated_pkts[ac]++;
 
 		if (wlvif->bss_type == BSS_TYPE_AP_BSS &&
-		    hlid >= WL1271_AP_STA_HLID_START)
+		    test_bit(hlid, wlvif->ap.sta_hlid_map))
 			wl->links[hlid].allocated_pkts++;
 
 		ret = 0;
@@ -445,7 +443,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS && !is_dummy) {
 		wl1271_tx_ap_update_inconnection_sta(wl, skb);
-		wl1271_tx_regulate_link(wl, hlid);
+		wl1271_tx_regulate_link(wl, wlvif, hlid);
 	}
 
 	/*
@@ -563,7 +561,8 @@ out:
 	return skb;
 }
 
-static struct sk_buff *wl1271_ap_skb_dequeue(struct wl1271 *wl)
+static struct sk_buff *wl1271_ap_skb_dequeue(struct wl1271 *wl,
+					     struct wl12xx_vif *wlvif)
 {
 	struct sk_buff *skb = NULL;
 	unsigned long flags;
@@ -571,15 +570,14 @@ static struct sk_buff *wl1271_ap_skb_dequeue(struct wl1271 *wl)
 	struct sk_buff_head *queue;
 
 	/* start from the link after the last one */
-	start_hlid = (wl->last_tx_hlid + 1) % AP_MAX_LINKS;
+	start_hlid = (wl->last_tx_hlid + 1) % WL12XX_MAX_LINKS;
 
 	/* dequeue according to AC, round robin on each link */
-	for (i = 0; i < AP_MAX_LINKS; i++) {
-		h = (start_hlid + i) % AP_MAX_LINKS;
+	for (i = 0; i < WL12XX_MAX_LINKS; i++) {
+		h = (start_hlid + i) % WL12XX_MAX_LINKS;
 
 		/* only consider connected stations */
-		if (h >= WL1271_AP_STA_HLID_START &&
-		    !test_bit(h - WL1271_AP_STA_HLID_START, wl->ap_hlid_map))
+		if (!test_bit(h, wlvif->links_map))
 			continue;
 
 		queue = wl1271_select_queue(wl, wl->links[h].tx_queue);
@@ -611,7 +609,7 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl,
 	struct sk_buff *skb = NULL;
 
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
-		skb = wl1271_ap_skb_dequeue(wl);
+		skb = wl1271_ap_skb_dequeue(wl, wlvif);
 	else
 		skb = wl1271_sta_skb_dequeue(wl);
 
@@ -643,7 +641,8 @@ static void wl1271_skb_queue_head(struct wl1271 *wl, struct ieee80211_vif *vif,
 		skb_queue_head(&wl->links[hlid].tx_queue[q], skb);
 
 		/* make sure we dequeue the same packet next time */
-		wl->last_tx_hlid = (hlid + AP_MAX_LINKS - 1) % AP_MAX_LINKS;
+		wl->last_tx_hlid = (hlid + WL12XX_MAX_LINKS - 1) %
+				   WL12XX_MAX_LINKS;
 	} else {
 		skb_queue_head(&wl->tx_queue[q], skb);
 	}
@@ -918,8 +917,8 @@ void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 
 	/* TX failure */
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
-		for (i = 0; i < AP_MAX_LINKS; i++) {
-			wl1271_free_sta(wl, i);
+		for (i = 0; i < WL12XX_MAX_LINKS; i++) {
+			wl1271_free_sta(wl, wlvif, i);
 			wl1271_tx_reset_link_queues(wl, i);
 			wl->links[i].allocated_pkts = 0;
 			wl->links[i].prev_freed_pkts = 0;
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 0964c93..add4402 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -219,6 +219,6 @@ void wl1271_handle_tx_low_watermark(struct wl1271 *wl);
 bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb);
 
 /* from main.c */
-void wl1271_free_sta(struct wl1271 *wl, u8 hlid);
+void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index fb77c58..1b5320a 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -146,12 +146,6 @@ extern u32 wl12xx_debug_level;
 #define WL12XX_SYSTEM_HLID         0
 
 /*
- * TODO: we currently don't support multirole. remove
- * this constant from the code when we do.
- */
-#define WL1271_AP_STA_HLID_START   3
-
-/*
  * When in AP-mode, we allow (at least) this number of packets
  * to be transmitted to FW for a STA in PS-mode. Only when packets are
  * present in the FW buffers it will wake the sleeping STA. We want to put
@@ -236,13 +230,6 @@ struct wl1271_stats {
 
 #define AP_MAX_STATIONS            8
 
-/* Broadcast and Global links + system link + links to stations */
-/*
- * TODO: when WL1271_AP_STA_HLID_START is no longer constant, change all
- * the places that use this.
- */
-#define AP_MAX_LINKS               (AP_MAX_STATIONS + WL1271_AP_STA_HLID_START)
-
 /* FW status registers */
 struct wl12xx_fw_status {
 	__le32 intr;
@@ -536,9 +523,6 @@ struct wl1271 {
 	/* Most recently reported noise in dBm */
 	s8 noise;
 
-	/* map for HLIDs of associated stations - when operating in AP mode */
-	unsigned long ap_hlid_map[BITS_TO_LONGS(AP_MAX_STATIONS)];
-
 	/* recoreded keys for AP-mode - set here before AP startup */
 	struct wl1271_ap_key *recorded_ap_keys[MAX_NUM_KEYS];
 
@@ -558,7 +542,7 @@ struct wl1271 {
 	 * AP-mode - links indexed by HLID. The global and broadcast links
 	 * are always active.
 	 */
-	struct wl1271_link links[AP_MAX_LINKS];
+	struct wl1271_link links[WL12XX_MAX_LINKS];
 
 	/* the hlid of the link where the last transmitted skb came from */
 	int last_tx_hlid;
@@ -604,9 +588,15 @@ struct wl12xx_vif {
 		struct {
 			u8 global_hlid;
 			u8 bcast_hlid;
+
+			/* HLIDs bitmap of associated stations */
+			unsigned long sta_hlid_map[BITS_TO_LONGS(
+							WL12XX_MAX_LINKS)];
 		} ap;
 	};
 
+	unsigned long links_map[BITS_TO_LONGS(WL12XX_MAX_LINKS)];
+
 	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 ssid_len;
 
-- 
1.7.6.401.g6a319

