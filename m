Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46313 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab1HYJnb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 05:43:31 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so1509667wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 02:43:30 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 6/6] wl12xx: AP mode - clean BA and queue state in tx_reset
Date: Thu, 25 Aug 2011 12:43:17 +0300
Message-Id: <1314265397-19873-6-git-send-email-arik@wizery.com> (sfid-20110825_114335_732273_81EE8731)
In-Reply-To: <1314265397-19873-1-git-send-email-arik@wizery.com>
References: <1314265397-19873-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reset the BA state of all connected stations and explicitly clear the
Tx queues. The latter is needed for clearing dummy packets from
tx_queue_count.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    7 +++++--
 drivers/net/wireless/wl12xx/tx.c   |    7 ++++++-
 drivers/net/wireless/wl12xx/tx.h   |    3 +++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 0778567..7027a7e 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3723,11 +3723,14 @@ static int wl1271_allocate_sta(struct wl1271 *wl,
 	return 0;
 }
 
-static void wl1271_free_sta(struct wl1271 *wl, u8 hlid)
+void wl1271_free_sta(struct wl1271 *wl, u8 hlid)
 {
 	int id = hlid - WL1271_AP_STA_HLID_START;
 
-	if (WARN_ON(!test_bit(id, wl->ap_hlid_map)))
+	if (hlid < WL1271_AP_STA_HLID_START)
+		return;
+
+	if (!test_bit(id, wl->ap_hlid_map))
 		return;
 
 	clear_bit(id, wl->ap_hlid_map);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 09c1083..a28c33d 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -893,6 +893,7 @@ void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 	/* TX failure */
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
 		for (i = 0; i < AP_MAX_LINKS; i++) {
+			wl1271_free_sta(wl, i);
 			wl1271_tx_reset_link_queues(wl, i);
 			wl->links[i].allocated_pkts = 0;
 			wl->links[i].prev_freed_pkts = 0;
@@ -912,10 +913,14 @@ void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 					ieee80211_tx_status_ni(wl->hw, skb);
 				}
 			}
-			wl->tx_queue_count[i] = 0;
 		}
+
+		wl->ba_rx_bitmap = 0;
 	}
 
+	for (i = 0; i < NUM_TX_QUEUES; i++)
+		wl->tx_queue_count[i] = 0;
+
 	wl->stopped_queues_map = 0;
 
 	/*
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 1515f4a..b29775b 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -215,4 +215,7 @@ void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid);
 void wl1271_handle_tx_low_watermark(struct wl1271 *wl);
 bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb);
 
+/* from main.c */
+void wl1271_free_sta(struct wl1271 *wl, u8 hlid);
+
 #endif
-- 
1.7.4.1

