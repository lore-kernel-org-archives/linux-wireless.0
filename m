Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58641 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab1HYJn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 05:43:28 -0400
Received: by wwf5 with SMTP id 5so2171854wwf.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 02:43:27 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 4/6] wl12xx: don't regulate links when a single STA is connected
Date: Thu, 25 Aug 2011 12:43:15 +0300
Message-Id: <1314265397-19873-4-git-send-email-arik@wizery.com> (sfid-20110825_114332_070610_7158612F)
In-Reply-To: <1314265397-19873-1-git-send-email-arik@wizery.com>
References: <1314265397-19873-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating as AP track the number of connected stations. When a
single STA is connected don't regulate the PS status of the link.
Since this is the only STA connected, there's no point holding space in
FW for other links. This will speed up communications with a single
connected STA in PSM.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   15 ++++++++++++---
 drivers/net/wireless/wl12xx/tx.c     |    7 +++++--
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +++
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 82f4408..0778567 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -757,13 +757,14 @@ static int wl1271_plt_init(struct wl1271 *wl)
 
 static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl, u8 hlid, u8 tx_pkts)
 {
-	bool fw_ps;
+	bool fw_ps, single_sta;
 
 	/* only regulate station links */
 	if (hlid < WL1271_AP_STA_HLID_START)
 		return;
 
 	fw_ps = test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
+	single_sta = (wl->active_sta_count == 1);
 
 	/*
 	 * Wake up from high level PS if the STA is asleep with too little
@@ -772,8 +773,12 @@ static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl, u8 hlid, u8 tx_pkts)
 	if (!fw_ps || tx_pkts < WL1271_PS_STA_MAX_PACKETS)
 		wl1271_ps_link_end(wl, hlid);
 
-	/* Start high-level PS if the STA is asleep with enough blocks in FW */
-	else if (fw_ps && tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
+	/*
+	 * Start high-level PS if the STA is asleep with enough blocks in FW.
+	 * Make an exception if this is the only connected station. In this
+	 * case FW-memory congestion is not a problem.
+	 */
+	else if (!single_sta && fw_ps && tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
 		wl1271_ps_link_start(wl, hlid, true);
 }
 
@@ -2074,6 +2079,7 @@ deinit:
 	memset(wl->roles_map, 0, sizeof(wl->roles_map));
 	memset(wl->links_map, 0, sizeof(wl->links_map));
 	memset(wl->roc_map, 0, sizeof(wl->roc_map));
+	wl->active_sta_count = 0;
 
 	/* The system link is always allocated */
 	__set_bit(WL12XX_SYSTEM_HLID, wl->links_map);
@@ -3713,6 +3719,7 @@ static int wl1271_allocate_sta(struct wl1271 *wl,
 	wl_sta->hlid = WL1271_AP_STA_HLID_START + id;
 	*hlid = wl_sta->hlid;
 	memcpy(wl->links[wl_sta->hlid].addr, sta->addr, ETH_ALEN);
+	wl->active_sta_count++;
 	return 0;
 }
 
@@ -3729,6 +3736,7 @@ static void wl1271_free_sta(struct wl1271 *wl, u8 hlid)
 	wl1271_tx_reset_link_queues(wl, hlid);
 	__clear_bit(hlid, &wl->ap_ps_map);
 	__clear_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
+	wl->active_sta_count--;
 }
 
 static int wl1271_op_sta_add(struct ieee80211_hw *hw,
@@ -4607,6 +4615,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->session_counter = 0;
 	wl->ap_bcast_hlid = WL12XX_INVALID_LINK_ID;
 	wl->ap_global_hlid = WL12XX_INVALID_LINK_ID;
+	wl->active_sta_count = 0;
 	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
 		    (unsigned long) wl);
 	wl->fwlog_size = 0;
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 572c6e6..09c1083 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -126,7 +126,7 @@ static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
 
 static void wl1271_tx_regulate_link(struct wl1271 *wl, u8 hlid)
 {
-	bool fw_ps;
+	bool fw_ps, single_sta;
 	u8 tx_pkts;
 
 	/* only regulate station links */
@@ -140,12 +140,15 @@ static void wl1271_tx_regulate_link(struct wl1271 *wl, u8 hlid)
 
 	fw_ps = test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 	tx_pkts = wl->links[hlid].allocated_pkts;
+	single_sta = (wl->active_sta_count == 1);
 
 	/*
 	 * if in FW PS and there is enough data in FW we can put the link
 	 * into high-level PS and clean out its TX queues.
+	 * Make an exception if this is the only connected station. In this
+	 * case FW-memory congestion is not a problem.
 	 */
-	if (fw_ps && tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
+	if (!single_sta && fw_ps && tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
 		wl1271_ps_link_start(wl, hlid, true);
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 27961e2..b454b81 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -623,6 +623,9 @@ struct wl1271 {
 
 	/* number of currently active RX BA sessions */
 	int ba_rx_session_count;
+
+	/* AP-mode - number of currently connected stations */
+	int active_sta_count;
 };
 
 struct wl1271_station {
-- 
1.7.4.1

