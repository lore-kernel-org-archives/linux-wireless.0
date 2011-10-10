Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53588 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1JJIMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:12:37 -0400
Received: by bkbzt4 with SMTP id zt4so8169287bkb.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:12:36 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/29] wl12xx: move last_tx_hlid into wlvif
Date: Mon, 10 Oct 2011 10:12:50 +0200
Message-Id: <1318234397-21081-3-git-send-email-eliad@wizery.com> (sfid-20111010_101240_899417_F61EC1FD)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move last_tx_hlid into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    1 -
 drivers/net/wireless/wl12xx/main.c    |    1 -
 drivers/net/wireless/wl12xx/tx.c      |   10 +++++-----
 drivers/net/wireless/wl12xx/wl12xx.h  |    6 +++---
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index f0398d0..bbc8004 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -355,7 +355,6 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_INT(sg_enabled);
 	DRIVER_STATE_PRINT_INT(enable_11a);
 	DRIVER_STATE_PRINT_INT(noise);
-	DRIVER_STATE_PRINT_INT(last_tx_hlid);
 	DRIVER_STATE_PRINT_HEX(ap_fw_ps_map);
 	DRIVER_STATE_PRINT_LHEX(ap_ps_map);
 	DRIVER_STATE_PRINT_HEX(quirks);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 3667acf..0606b0d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4901,7 +4901,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->flags = 0;
 	wl->sg_enabled = true;
 	wl->hw_pg_ver = -1;
-	wl->last_tx_hlid = 0;
 	wl->ap_ps_map = 0;
 	wl->ap_fw_ps_map = 0;
 	wl->quirks = 0;
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 1b3d8e3..951ff03 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -570,7 +570,7 @@ static struct sk_buff *wl1271_ap_skb_dequeue(struct wl1271 *wl,
 	struct sk_buff_head *queue;
 
 	/* start from the link after the last one */
-	start_hlid = (wl->last_tx_hlid + 1) % WL12XX_MAX_LINKS;
+	start_hlid = (wlvif->last_tx_hlid + 1) % WL12XX_MAX_LINKS;
 
 	/* dequeue according to AC, round robin on each link */
 	for (i = 0; i < WL12XX_MAX_LINKS; i++) {
@@ -591,12 +591,12 @@ static struct sk_buff *wl1271_ap_skb_dequeue(struct wl1271 *wl,
 
 	if (skb) {
 		int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
-		wl->last_tx_hlid = h;
+		wlvif->last_tx_hlid = h;
 		spin_lock_irqsave(&wl->wl_lock, flags);
 		wl->tx_queue_count[q]--;
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
 	} else {
-		wl->last_tx_hlid = 0;
+		wlvif->last_tx_hlid = 0;
 	}
 
 	return skb;
@@ -641,7 +641,7 @@ static void wl1271_skb_queue_head(struct wl1271 *wl, struct ieee80211_vif *vif,
 		skb_queue_head(&wl->links[hlid].tx_queue[q], skb);
 
 		/* make sure we dequeue the same packet next time */
-		wl->last_tx_hlid = (hlid + WL12XX_MAX_LINKS - 1) %
+		wlvif->last_tx_hlid = (hlid + WL12XX_MAX_LINKS - 1) %
 				   WL12XX_MAX_LINKS;
 	} else {
 		skb_queue_head(&wl->tx_queue[q], skb);
@@ -924,7 +924,7 @@ void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 			wl->links[i].prev_freed_pkts = 0;
 		}
 
-		wl->last_tx_hlid = 0;
+		wlvif->last_tx_hlid = 0;
 	} else {
 		for (i = 0; i < NUM_TX_QUEUES; i++) {
 			while ((skb = skb_dequeue(&wl->tx_queue[i]))) {
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 074de4e..b350f0b 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -542,9 +542,6 @@ struct wl1271 {
 	 */
 	struct wl1271_link links[WL12XX_MAX_LINKS];
 
-	/* the hlid of the link where the last transmitted skb came from */
-	int last_tx_hlid;
-
 	/* AP-mode - a bitmap of links currently in PS mode according to FW */
 	u32 ap_fw_ps_map;
 
@@ -596,6 +593,9 @@ struct wl12xx_vif {
 		} ap;
 	};
 
+	/* the hlid of the last transmitted skb */
+	int last_tx_hlid;
+
 	unsigned long links_map[BITS_TO_LONGS(WL12XX_MAX_LINKS)];
 
 	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
-- 
1.7.6.401.g6a319

