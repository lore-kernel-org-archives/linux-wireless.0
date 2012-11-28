Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52264 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab2K1JnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:21 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so5186649wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:21 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 13/20] wlcore: use link count for single-STA-PSM optimization
Date: Wed, 28 Nov 2012 11:42:42 +0200
Message-Id: <1354095769-8724-14-git-send-email-arik@wizery.com> (sfid-20121128_104331_091223_08DF72F3)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only allow a PSM STA to congest FW memory when it is the single active
link. Being a single STA doesn't imply a single link - there might be
other links on other roles.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c    |    4 ++++
 drivers/net/wireless/ti/wlcore/main.c   |   12 +++++++-----
 drivers/net/wireless/ti/wlcore/tx.c     |   10 +++++-----
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +++
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 1fbee0d..28a3027 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -328,6 +328,8 @@ int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 			wl->fw_status_2->counters.tx_lnk_free_pkts[link];
 	wl->links[link].wlvif = wlvif;
 	*hlid = link;
+
+	wl->active_link_count++;
 	return 0;
 }
 
@@ -357,6 +359,8 @@ void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 	wl->links[*hlid].wlvif = NULL;
 
 	*hlid = WL12XX_INVALID_LINK_ID;
+	wl->active_link_count--;
+	WARN_ON(wl->active_link_count < 0);
 }
 
 static u8 wlcore_get_native_channel_type(u8 nl_channel_type)
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 37575d7..b0d0d6d 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -349,10 +349,10 @@ static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl,
 					struct wl12xx_vif *wlvif,
 					u8 hlid, u8 tx_pkts)
 {
-	bool fw_ps, single_sta;
+	bool fw_ps, single_link;
 
 	fw_ps = test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
-	single_sta = (wl->active_sta_count == 1);
+	single_link = (wl->active_link_count == 1);
 
 	/*
 	 * Wake up from high level PS if the STA is asleep with too little
@@ -363,10 +363,10 @@ static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl,
 
 	/*
 	 * Start high-level PS if the STA is asleep with enough blocks in FW.
-	 * Make an exception if this is the only connected station. In this
-	 * case FW-memory congestion is not a problem.
+	 * Make an exception if this is the only connected link. In this
+	 * case FW-memory congestion is less of a problem.
 	 */
-	else if (!single_sta && fw_ps && tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
+	else if (!single_link && fw_ps && tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
 		wl12xx_ps_link_start(wl, wlvif, hlid, true);
 }
 
@@ -1914,6 +1914,7 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
 	memset(wl->roc_map, 0, sizeof(wl->roc_map));
 	memset(wl->session_ids, 0, sizeof(wl->session_ids));
 	wl->active_sta_count = 0;
+	wl->active_link_count = 0;
 
 	/* The system link is always allocated */
 	wl->links[WL12XX_SYSTEM_HLID].allocated_pkts = 0;
@@ -5758,6 +5759,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	wl->platform_quirks = 0;
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
 	wl->active_sta_count = 0;
+	wl->active_link_count = 0;
 	wl->fwlog_size = 0;
 	init_waitqueue_head(&wl->fwlog_waitq);
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 3a56a87..d799fc9 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -104,7 +104,7 @@ static void wl1271_tx_regulate_link(struct wl1271 *wl,
 				    struct wl12xx_vif *wlvif,
 				    u8 hlid)
 {
-	bool fw_ps, single_sta;
+	bool fw_ps, single_link;
 	u8 tx_pkts;
 
 	if (WARN_ON(!test_bit(hlid, wlvif->links_map)))
@@ -112,15 +112,15 @@ static void wl1271_tx_regulate_link(struct wl1271 *wl,
 
 	fw_ps = test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 	tx_pkts = wl->links[hlid].allocated_pkts;
-	single_sta = (wl->active_sta_count == 1);
+	single_link = (wl->active_link_count == 1);
 
 	/*
 	 * if in FW PS and there is enough data in FW we can put the link
 	 * into high-level PS and clean out its TX queues.
-	 * Make an exception if this is the only connected station. In this
-	 * case FW-memory congestion is not a problem.
+	 * Make an exception if this is the only connected link. In this
+	 * case FW-memory congestion is less of a problem.
 	 */
-	if (!single_sta && fw_ps && tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
+	if (!single_link && fw_ps && tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
 		wl12xx_ps_link_start(wl, wlvif, hlid, true);
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index cf0290a..81c14ce 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -376,6 +376,9 @@ struct wl1271 {
 	 */
 	struct wl1271_link links[WL12XX_MAX_LINKS];
 
+	/* number of currently active links */
+	int active_link_count;
+
 	/* Fast/slow links bitmap according to FW */
 	u32 fw_fast_lnk_map;
 
-- 
1.7.9.5

