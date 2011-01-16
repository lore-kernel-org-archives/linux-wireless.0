Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36091 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1APFmm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 00:42:42 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so4134866wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jan 2011 21:42:41 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 10/10] wl12xx: AP-mode - management of links in PS-mode
Date: Sun, 16 Jan 2011 07:42:14 +0200
Message-Id: <1295156534-4178-11-git-send-email-arik@wizery.com>
In-Reply-To: <1295156534-4178-1-git-send-email-arik@wizery.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the PS mode of each link according to a bitmap polled from
fw_status. Manually notify mac80211 about PS mode changes in connected
stations.

mac80211 will only be notified about PS start when the station is in PS
and there is a small number of TX blocks from this link ready in HW.
This is required for waking up the remote station since the TIM is
updated entirely by FW.

When a station enters mac80211-PS-mode, we drop all the skbs in the
low-level TX queues belonging to this sta with STAT_TX_FILTERED
to keep our queues clean.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   73 ++++++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/ps.c     |   80 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/ps.h     |    2 +
 drivers/net/wireless/wl12xx/tx.c     |   24 ++++++++++-
 drivers/net/wireless/wl12xx/wl12xx.h |   19 ++++++++
 5 files changed, 186 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index a83d26d..d362a30 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -518,6 +518,57 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	return ret;
 }
 
+static void wl1271_irq_ps_regulate_link(struct wl1271 *wl, u8 hlid, u8 tx_blks)
+{
+	bool fw_ps;
+
+	/* only regulate station links */
+	if (hlid < WL1271_AP_STA_HLID_START)
+		return;
+
+	fw_ps = test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
+
+	/*
+	 * Wake up from high level PS if the STA is asleep with too little
+	 * blocks in FW or if the STA is awake.
+	 */
+	if (!fw_ps || tx_blks < WL1271_PS_STA_MAX_BLOCKS)
+		wl1271_ps_link_end(wl, hlid);
+
+	/* Start high-level PS if the STA is asleep with enough blocks in FW */
+	else if (fw_ps && tx_blks >= WL1271_PS_STA_MAX_BLOCKS)
+		wl1271_ps_link_start(wl, hlid, true);
+}
+
+static void wl1271_irq_update_links_status(struct wl1271 *wl,
+				       struct wl1271_fw_status *status)
+{
+	u32 cur_fw_ps_map;
+	u8 hlid;
+
+	cur_fw_ps_map = le32_to_cpu(status->link_ps_bitmap);
+	if (wl->ap_fw_ps_map != cur_fw_ps_map) {
+		wl1271_debug(DEBUG_PSM,
+			     "link ps prev 0x%x cur 0x%x changed 0x%x",
+			     wl->ap_fw_ps_map, cur_fw_ps_map,
+			     wl->ap_fw_ps_map ^ cur_fw_ps_map);
+
+		wl->ap_fw_ps_map = cur_fw_ps_map;
+	}
+
+	for (hlid = WL1271_AP_STA_HLID_START; hlid < AP_MAX_LINKS; hlid++) {
+		u8 cnt = status->tx_lnk_free_blks[hlid] -
+			wl->links[hlid].prev_freed_blks;
+
+		wl->links[hlid].prev_freed_blks =
+			status->tx_lnk_free_blks[hlid];
+		wl->links[hlid].allocated_blks -= cnt;
+
+		wl1271_irq_ps_regulate_link(wl, hlid,
+					    wl->links[hlid].allocated_blks);
+	}
+}
+
 static void wl1271_fw_status(struct wl1271 *wl,
 			     struct wl1271_fw_status *status)
 {
@@ -549,16 +600,9 @@ static void wl1271_fw_status(struct wl1271 *wl,
 	if (total)
 		clear_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 
-	if (wl->bss_type == BSS_TYPE_AP_BSS) {
-		for (i = 0; i < AP_MAX_LINKS; i++) {
-			u8 cnt = status->tx_lnk_free_blks[i] -
-				wl->links[i].prev_freed_blks;
-
-			wl->links[i].prev_freed_blks =
-				status->tx_lnk_free_blks[i];
-			wl->links[i].allocated_blks -= cnt;
-		}
-	}
+	/* for AP update num of allocated TX blocks per link and ps status */
+	if (wl->bss_type == BSS_TYPE_AP_BSS)
+		wl1271_irq_update_links_status(wl, status);
 
 	/* update the host-chipset time offset */
 	getnstimeofday(&ts);
@@ -1239,6 +1283,8 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 	wl->filters = 0;
 	wl1271_free_ap_keys(wl);
 	memset(wl->ap_hlid_map, 0, sizeof(wl->ap_hlid_map));
+	wl->ap_fw_ps_map = 0;
+	wl->ap_ps_map = 0;
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wl->tx_blocks_freed[i] = 0;
@@ -2636,10 +2682,10 @@ static int wl1271_allocate_sta(struct wl1271 *wl,
 	}
 
 	wl_sta = (struct wl1271_station *)sta->drv_priv;
-
 	__set_bit(id, wl->ap_hlid_map);
 	wl_sta->hlid = WL1271_AP_STA_HLID_START + id;
 	*hlid = wl_sta->hlid;
+	memcpy(wl->links[wl_sta->hlid].addr, sta->addr, ETH_ALEN);
 	return 0;
 }
 
@@ -2651,7 +2697,10 @@ static void wl1271_free_sta(struct wl1271 *wl, u8 hlid)
 		return;
 
 	__clear_bit(id, wl->ap_hlid_map);
+	memset(wl->links[hlid].addr, 0, ETH_ALEN);
 	wl1271_tx_reset_link_queues(wl, hlid);
+	__clear_bit(hlid, &wl->ap_ps_map);
+	__clear_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 }
 
 static int wl1271_op_sta_add(struct ieee80211_hw *hw,
@@ -3275,6 +3324,8 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->set_bss_type = MAX_BSS_TYPE;
 	wl->fw_bss_type = MAX_BSS_TYPE;
 	wl->last_tx_hlid = 0;
+	wl->ap_ps_map = 0;
+	wl->ap_fw_ps_map = 0;
 
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index 92397ad..eb80192 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -24,6 +24,7 @@
 #include "reg.h"
 #include "ps.h"
 #include "io.h"
+#include "tx.h"
 
 #define WL1271_WAKEUP_TIMEOUT 500
 
@@ -174,3 +175,82 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
 
 	return ret;
 }
+
+static void wl1271_ps_filter_frames(struct wl1271 *wl, u8 hlid)
+{
+	int i, filtered = 0;
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
+	unsigned long flags;
+
+	/* filter all frames currently the low level queus for this hlid */
+	for (i = 0; i < NUM_TX_QUEUES; i++) {
+		while ((skb = skb_dequeue(&wl->links[hlid].tx_queue[i]))) {
+			info = IEEE80211_SKB_CB(skb);
+			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
+			info->status.rates[0].idx = -1;
+			ieee80211_tx_status(wl->hw, skb);
+			filtered++;
+		}
+	}
+
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	wl->tx_queue_count -= filtered;
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+	wl1271_handle_tx_low_watermark(wl);
+}
+
+void wl1271_ps_link_start(struct wl1271 *wl, u8 hlid, bool clean_queues)
+{
+	struct ieee80211_sta *sta;
+
+	if (test_bit(hlid, &wl->ap_ps_map))
+		return;
+
+	wl1271_debug(DEBUG_PSM, "start mac80211 PSM on hlid %d blks %d "
+		     "clean_queues %d", hlid, wl->links[hlid].allocated_blks,
+		     clean_queues);
+
+	rcu_read_lock();
+	sta = ieee80211_find_sta(wl->vif, wl->links[hlid].addr);
+	if (!sta) {
+		wl1271_error("could not find sta %pM for starting ps",
+			     wl->links[hlid].addr);
+		rcu_read_unlock();
+		return;
+	}
+
+	ieee80211_start_ps(sta);
+	rcu_read_unlock();
+
+	/* do we want to filter all frames from this link's queues? */
+	if (clean_queues)
+		wl1271_ps_filter_frames(wl, hlid);
+
+	__set_bit(hlid, &wl->ap_ps_map);
+}
+
+void wl1271_ps_link_end(struct wl1271 *wl, u8 hlid)
+{
+	struct ieee80211_sta *sta;
+
+	if (!test_bit(hlid, &wl->ap_ps_map))
+		return;
+
+	wl1271_debug(DEBUG_PSM, "end mac80211 PSM on hlid %d", hlid);
+
+	__clear_bit(hlid, &wl->ap_ps_map);
+
+	rcu_read_lock();
+	sta = ieee80211_find_sta(wl->vif, wl->links[hlid].addr);
+	if (!sta) {
+		wl1271_error("could not find sta %pM for ending ps",
+			     wl->links[hlid].addr);
+		goto end;
+	}
+
+	ieee80211_end_ps(sta);
+end:
+	rcu_read_unlock();
+}
diff --git a/drivers/net/wireless/wl12xx/ps.h b/drivers/net/wireless/wl12xx/ps.h
index 8415060..fc1f4c1 100644
--- a/drivers/net/wireless/wl12xx/ps.h
+++ b/drivers/net/wireless/wl12xx/ps.h
@@ -32,5 +32,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
 void wl1271_ps_elp_sleep(struct wl1271 *wl);
 int wl1271_ps_elp_wakeup(struct wl1271 *wl, bool chip_awake);
 void wl1271_elp_work(struct work_struct *work);
+void wl1271_ps_link_start(struct wl1271 *wl, u8 hlid, bool clean_queues);
+void wl1271_ps_link_end(struct wl1271 *wl, u8 hlid);
 
 #endif /* __WL1271_PS_H__ */
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 128c274..e515b72 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -86,6 +86,26 @@ static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
 		wl1271_acx_set_inconnection_sta(wl, hdr->addr1);
 }
 
+static void wl1271_tx_regulate_link(struct wl1271 *wl, u8 hlid)
+{
+	bool fw_ps;
+	u8 tx_blks;
+
+	/* only regulate station links */
+	if (hlid < WL1271_AP_STA_HLID_START)
+		return;
+
+	fw_ps = test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
+	tx_blks = wl->links[hlid].allocated_blks;
+
+	/*
+	 * if in FW PS and there is enough data in FW we can put the link
+	 * into high-level PS and clean out its TX queues.
+	 */
+	if (fw_ps && tx_blks >= WL1271_PS_STA_MAX_BLOCKS)
+		wl1271_ps_link_start(wl, hlid, true);
+}
+
 u8 wl1271_tx_get_hlid(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *control = IEEE80211_SKB_CB(skb);
@@ -277,8 +297,10 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 	if (ret < 0)
 		return ret;
 
-	if (wl->bss_type == BSS_TYPE_AP_BSS)
+	if (wl->bss_type == BSS_TYPE_AP_BSS) {
 		wl1271_tx_ap_update_inconnection_sta(wl, skb);
+		wl1271_tx_regulate_link(wl, hlid);
+	}
 
 	wl1271_tx_fill_hdr(wl, skb, extra, info, hlid);
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 59d687b..7cb3d5b 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -146,6 +146,17 @@ extern u32 wl12xx_debug_level;
 #define WL1271_AP_BROADCAST_HLID   1
 #define WL1271_AP_STA_HLID_START   2
 
+/*
+ * When in AP-mode, we allow (at least) this number of mem-blocks
+ * to be transmitted to FW for a STA in PS-mode. Only when packets are
+ * present in the FW buffers it will wake the sleeping STA. We want to put
+ * enough packets for the driver to transmit all of its buffered data before
+ * the STA goes to sleep again. But we don't want to take too much mem-blocks
+ * as it might hurt the throughput of active STAs.
+ * The number of blocks (18) is enough for 2 large packets.
+ */
+#define WL1271_PS_STA_MAX_BLOCKS  (2 * 9)
+
 #define WL1271_AP_BSS_INDEX        0
 #define WL1271_AP_DEF_INACTIV_SEC  300
 #define WL1271_AP_DEF_BEACON_EXP   20
@@ -275,6 +286,8 @@ struct wl1271_link {
 	/* accounting for allocated / available TX blocks in FW */
 	u8 allocated_blks;
 	u8 prev_freed_blks;
+
+	u8 addr[ETH_ALEN];
 };
 
 struct wl1271 {
@@ -478,6 +491,12 @@ struct wl1271 {
 
 	/* the hlid of the link where the last transmitted skb came from */
 	int last_tx_hlid;
+
+	/* AP-mode - a bitmap of links currently in PS mode according to FW */
+	u32 ap_fw_ps_map;
+
+	/* AP-mode - a bitmap of links currently in PS mode in mac80211 */
+	unsigned long ap_ps_map;
 };
 
 struct wl1271_station {
-- 
1.7.1

