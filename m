Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:58876 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036Ab2FZUDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 16:03:19 -0400
Received: by lbon10 with SMTP id n10so670349lbo.13
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 13:03:12 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, Eyal Shapira <eyal@wizery.com>
Subject: [PATCH 3/5] wlcore: fix broken TX due to wrong queuing of recovery
Date: Tue, 26 Jun 2012 23:02:58 +0300
Message-Id: <1340740980-22284-4-git-send-email-coelho@ti.com> (sfid-20120626_220326_690978_0550EC12)
In-Reply-To: <1340740980-22284-1-git-send-email-coelho@ti.com>
References: <1340740980-22284-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

commit 14bba17b "wl12xx: Propagate errors from wl1271_raw_write32"
breaks down TX in certain scenarios. wl1271_irq_locked() propagates
errors from wl1271_tx_work_locked however it may return -EBUSY
when the FW queues are full which is a legitimate case and not a
a real error. In this case a recovery is triggered by wl1271_irq
and this keeps repeating itself so TX is completely broken.
Fix it by avoiding propagating return values as errors even if they
aren't. Only bus (SDIO or SPI) ops failures would be progagated
as only these should trigger recovery.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/tx.c |   35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index b5211be..6a28aee 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -352,8 +352,10 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	bool is_dummy;
 	bool is_gem = false;
 
-	if (!skb)
+	if (!skb) {
+		wl1271_error("discarding null skb");
 		return -EINVAL;
+	}
 
 	info = IEEE80211_SKB_CB(skb);
 
@@ -662,6 +664,16 @@ void wl12xx_rearm_rx_streaming(struct wl1271 *wl, unsigned long *active_hlids)
 	}
 }
 
+/*
+ * Returns failure values only in case of failed bus ops within this function.
+ * wl1271_prepare_tx_frame retvals won't be returned in order to avoid
+ * triggering recovery by higher layers when not necessary.
+ * In case a FW command fails within wl1271_prepare_tx_frame fails a recovery
+ * will be queued in wl1271_cmd_send. -EAGAIN/-EBUSY from prepare_tx_frame
+ * can occur and are legitimate so don't propagate. -EINVAL will emit a WARNING
+ * within prepare_tx_frame code but there's nothing we should do about those
+ * as well.
+ */
 int wlcore_tx_work_locked(struct wl1271 *wl)
 {
 	struct wl12xx_vif *wlvif;
@@ -671,9 +683,10 @@ int wlcore_tx_work_locked(struct wl1271 *wl)
 	bool sent_packets = false;
 	unsigned long active_hlids[BITS_TO_LONGS(WL12XX_MAX_LINKS)] = {0};
 	int ret = 0;
+	int bus_ret = 0;
 
 	if (unlikely(wl->state == WL1271_STATE_OFF))
-		return -EIO;
+		return 0;
 
 	while ((skb = wl1271_skb_dequeue(wl))) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -694,9 +707,9 @@ int wlcore_tx_work_locked(struct wl1271 *wl)
 
 			buf_offset = wlcore_hw_pre_pkt_send(wl, buf_offset,
 							    last_len);
-			ret = wlcore_write_data(wl, REG_SLV_MEM_DATA,
-						wl->aggr_buf, buf_offset, true);
-			if (ret < 0)
+			bus_ret = wlcore_write_data(wl, REG_SLV_MEM_DATA,
+					     wl->aggr_buf, buf_offset, true);
+			if (bus_ret < 0)
 				goto out;
 
 			sent_packets = true;
@@ -734,9 +747,9 @@ int wlcore_tx_work_locked(struct wl1271 *wl)
 out_ack:
 	if (buf_offset) {
 		buf_offset = wlcore_hw_pre_pkt_send(wl, buf_offset, last_len);
-		ret = wlcore_write_data(wl, REG_SLV_MEM_DATA, wl->aggr_buf,
-					buf_offset, true);
-		if (ret < 0)
+		bus_ret = wlcore_write_data(wl, REG_SLV_MEM_DATA, wl->aggr_buf,
+					     buf_offset, true);
+		if (bus_ret < 0)
 			goto out;
 
 		sent_packets = true;
@@ -747,9 +760,9 @@ out_ack:
 		 * required for older hardware revisions
 		 */
 		if (wl->quirks & WLCORE_QUIRK_END_OF_TRANSACTION) {
-			ret = wlcore_write32(wl, WL12XX_HOST_WR_ACCESS,
+			bus_ret = wlcore_write32(wl, WL12XX_HOST_WR_ACCESS,
 					     wl->tx_packets_count);
-			if (ret < 0)
+			if (bus_ret < 0)
 				goto out;
 		}
 
@@ -758,7 +771,7 @@ out_ack:
 	wl12xx_rearm_rx_streaming(wl, active_hlids);
 
 out:
-	return ret;
+	return bus_ret;
 }
 
 void wl1271_tx_work(struct work_struct *work)
-- 
1.7.10

