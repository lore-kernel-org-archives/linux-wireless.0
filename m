Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63134 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1FGJuU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 05:50:20 -0400
Received: by wwa36 with SMTP id 36so4731860wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jun 2011 02:50:19 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: use freezable workqueue for netstack_work
Date: Tue,  7 Jun 2011 12:50:46 +0300
Message-Id: <1307440246-22062-1-git-send-email-eliad@wizery.com> (sfid-20110607_115025_479683_BDDFCCAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When resuming (after wowlan), we want the rx packets (which is
usually the wake-up packet itself) to be passed to mac80211 only
after the resume notifier was completed, and mac80211 is up and
running (otherwise, the packets will be dropped).

By enqueueing the netstack_work to a freezable workqueue, we can
guarantee the rx processing to occur only after mac80211 was resumed.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   12 +++++++++++-
 drivers/net/wireless/wl12xx/rx.c     |    2 +-
 drivers/net/wireless/wl12xx/tx.c     |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9ee2411..1e2f76b 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4112,6 +4112,12 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	INIT_WORK(&wl->rx_streaming_disable_work,
 		  wl1271_rx_streaming_disable_work);
 
+	wl->freezable_wq = create_freezable_workqueue("wl12xx_wq");
+	if (!wl->freezable_wq) {
+		ret = -ENOMEM;
+		goto err_hw;
+	}
+
 	wl->channel = WL1271_DEFAULT_CHANNEL;
 	wl->beacon_int = WL1271_DEFAULT_BEACON_INT;
 	wl->default_key = 0;
@@ -4156,7 +4162,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->aggr_buf = (u8 *)__get_free_pages(GFP_KERNEL, order);
 	if (!wl->aggr_buf) {
 		ret = -ENOMEM;
-		goto err_hw;
+		goto err_wq;
 	}
 
 	wl->dummy_packet = wl12xx_alloc_dummy_packet(wl);
@@ -4201,6 +4207,9 @@ err_dummy_packet:
 err_aggr:
 	free_pages((unsigned long)wl->aggr_buf, order);
 
+err_wq:
+	destroy_workqueue(wl->freezable_wq);
+
 err_hw:
 	wl1271_debugfs_exit(wl);
 	kfree(plat_dev);
@@ -4231,6 +4240,7 @@ int wl1271_free_hw(struct wl1271 *wl)
 
 	kfree(wl->fw_status);
 	kfree(wl->tx_res_if);
+	destroy_workqueue(wl->freezable_wq);
 
 	ieee80211_free_hw(wl->hw);
 
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index db230a5..9357695 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -150,7 +150,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 	skb_trim(skb, skb->len - desc->pad_len);
 
 	skb_queue_tail(&wl->deferred_rx_queue, skb);
-	ieee80211_queue_work(wl->hw, &wl->netstack_work);
+	queue_work(wl->freezable_wq, &wl->netstack_work);
 
 	return is_data;
 }
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index b2635c7..200590c 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -727,7 +727,7 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 
 	/* return the packet to the stack */
 	skb_queue_tail(&wl->deferred_tx_queue, skb);
-	ieee80211_queue_work(wl->hw, &wl->netstack_work);
+	queue_work(wl->freezable_wq, &wl->netstack_work);
 	wl1271_free_tx_id(wl, result->id);
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 06785db..8d6d039 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -445,6 +445,7 @@ struct wl1271 {
 	struct sk_buff_head deferred_tx_queue;
 
 	struct work_struct tx_work;
+	struct workqueue_struct *freezable_wq;
 
 	/* Pending TX frames */
 	unsigned long tx_frames_map[BITS_TO_LONGS(ACX_TX_DESCRIPTORS)];
-- 
1.7.0.4

