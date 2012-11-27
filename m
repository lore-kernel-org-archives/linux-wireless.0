Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42408 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981Ab2K0Gpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:40 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so4054043wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:39 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 18/20] wlcore: track FW-allocated packets per link
Date: Tue, 27 Nov 2012 08:44:59 +0200
Message-Id: <1353998701-18171-19-git-send-email-arik@wizery.com> (sfid-20121127_074553_104773_4B04C1D9)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move FW-allocation tracking code to the fw_status function and track
allocations made by all links. These will be incorporated in the
improved Tx scheduling algorithm.

Manually zero the system link counters on op_stop, as this link is not
allocated the normal way.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   29 +++++++++++++++++------------
 drivers/net/wireless/ti/wlcore/tx.c   |    4 +---
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d858deb..c557678 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -374,9 +374,8 @@ static void wl12xx_irq_update_links_status(struct wl1271 *wl,
 					   struct wl12xx_vif *wlvif,
 					   struct wl_fw_status_2 *status)
 {
-	struct wl1271_link *lnk;
 	u32 cur_fw_ps_map;
-	u8 hlid, cnt;
+	u8 hlid;
 
 	/* TODO: also use link_fast_bitmap here */
 
@@ -390,17 +389,9 @@ static void wl12xx_irq_update_links_status(struct wl1271 *wl,
 		wl->ap_fw_ps_map = cur_fw_ps_map;
 	}
 
-	for_each_set_bit(hlid, wlvif->ap.sta_hlid_map, WL12XX_MAX_LINKS) {
-		lnk = &wl->links[hlid];
-		cnt = status->counters.tx_lnk_free_pkts[hlid] -
-			lnk->prev_freed_pkts;
-
-		lnk->prev_freed_pkts = status->counters.tx_lnk_free_pkts[hlid];
-		lnk->allocated_pkts -= cnt;
-
+	for_each_set_bit(hlid, wlvif->ap.sta_hlid_map, WL12XX_MAX_LINKS)
 		wl12xx_irq_ps_regulate_link(wl, wlvif, hlid,
-					    lnk->allocated_pkts);
-	}
+					    wl->links[hlid].allocated_pkts);
 }
 
 static int wlcore_fw_status(struct wl1271 *wl,
@@ -414,6 +405,7 @@ static int wlcore_fw_status(struct wl1271 *wl,
 	int i;
 	size_t status_len;
 	int ret;
+	struct wl1271_link *lnk;
 
 	status_len = WLCORE_FW_STATUS_1_LEN(wl->num_rx_desc) +
 		sizeof(*status_2) + wl->fw_status_priv_len;
@@ -439,6 +431,17 @@ static int wlcore_fw_status(struct wl1271 *wl,
 		wl->tx_pkts_freed[i] = status_2->counters.tx_released_pkts[i];
 	}
 
+
+	for_each_set_bit(i, wl->links_map, WL12XX_MAX_LINKS) {
+		lnk = &wl->links[i];
+		/* prevent wrap-around in freed-packets counter */
+		lnk->allocated_pkts -=
+			(status_2->counters.tx_lnk_free_pkts[i] -
+			 lnk->prev_freed_pkts) & 0xff;
+
+		lnk->prev_freed_pkts = status_2->counters.tx_lnk_free_pkts[i];
+	}
+
 	/* prevent wrap-around in total blocks counter */
 	if (likely(wl->tx_blocks_freed <=
 		   le32_to_cpu(status_2->total_released_blks)))
@@ -1901,6 +1904,8 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
 	wl->active_sta_count = 0;
 
 	/* The system link is always allocated */
+	wl->links[WL12XX_SYSTEM_HLID].allocated_pkts = 0;
+	wl->links[WL12XX_SYSTEM_HLID].prev_freed_pkts = 0;
 	__set_bit(WL12XX_SYSTEM_HLID, wl->links_map);
 
 	/*
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index a5fa54d..5ce6248 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -224,9 +224,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		wl->tx_allocated_pkts[ac]++;
 
-		if (!wl12xx_is_dummy_packet(wl, skb) && wlvif &&
-		    wlvif->bss_type == BSS_TYPE_AP_BSS &&
-		    test_bit(hlid, wlvif->ap.sta_hlid_map))
+		if (test_bit(hlid, wl->links_map))
 			wl->links[hlid].allocated_pkts++;
 
 		ret = 0;
-- 
1.7.9.5

