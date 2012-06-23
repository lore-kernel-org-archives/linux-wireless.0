Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:57992 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754845Ab2FWGmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:04 -0400
Received: by lbbgj3 with SMTP id gj3so6580558lbb.39
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:42:00 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 06/18] wlcore: Propagate errors from wl1271_read
Date: Sat, 23 Jun 2012 09:41:17 +0300
Message-Id: <1340433689-24320-7-git-send-email-coelho@ti.com> (sfid-20120623_084211_544989_54C996F2)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Propagate errors from wl1271_read and request for recovery when
appropriate.
Also rename prefixes of wlcore functions which their prototypes had to
be changed.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    6 +++---
 drivers/net/wireless/ti/wlcore/boot.c   |    4 +++-
 drivers/net/wireless/ti/wlcore/cmd.c    |   20 +++++++++++++++-----
 drivers/net/wireless/ti/wlcore/event.c  |    6 ++++--
 drivers/net/wireless/ti/wlcore/hw_ops.h |    6 ++++--
 drivers/net/wireless/ti/wlcore/io.h     |   10 +++++-----
 drivers/net/wireless/ti/wlcore/main.c   |   24 ++++++++++++++++++++----
 drivers/net/wireless/ti/wlcore/rx.c     |   13 ++++++++++---
 drivers/net/wireless/ti/wlcore/rx.h     |    2 +-
 drivers/net/wireless/ti/wlcore/tx.c     |   15 +++++++++++----
 drivers/net/wireless/ti/wlcore/tx.h     |    2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h |    2 +-
 12 files changed, 78 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 0d2fdca..916cee7 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1162,13 +1162,13 @@ static u32 wl12xx_get_rx_packet_len(struct wl1271 *wl, void *rx_data,
 	return data_len - sizeof(*desc) - desc->pad_len;
 }
 
-static void wl12xx_tx_delayed_compl(struct wl1271 *wl)
+static int wl12xx_tx_delayed_compl(struct wl1271 *wl)
 {
 	if (wl->fw_status_1->tx_results_counter ==
 	    (wl->tx_results_count & 0xff))
-		return;
+		return 0;
 
-	wl1271_tx_complete(wl);
+	return wlcore_tx_complete(wl);
 }
 
 static int wl12xx_hw_init(struct wl1271 *wl)
diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 0fda500..d7abc50 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -87,7 +87,9 @@ static int wlcore_boot_static_data(struct wl1271 *wl)
 		goto out;
 	}
 
-	wl1271_read(wl, wl->cmd_box_addr, static_data, len, false);
+	ret = wlcore_read(wl, wl->cmd_box_addr, static_data, len, false);
+	if (ret < 0)
+		goto out_free;
 
 	ret = wlcore_boot_parse_fw_ver(wl, static_data);
 	if (ret < 0)
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 885364c..69f27d1 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -95,7 +95,10 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 	/* read back the status code of the command */
 	if (res_len == 0)
 		res_len = sizeof(struct wl1271_cmd_header);
-	wl1271_read(wl, wl->cmd_box_addr, cmd, res_len, false);
+
+	ret = wlcore_read(wl, wl->cmd_box_addr, cmd, res_len, false);
+	if (ret < 0)
+		goto fail;
 
 	status = le16_to_cpu(cmd->status);
 	if (status != CMD_STATUS_SUCCESS) {
@@ -141,11 +144,18 @@ static int wl1271_cmd_wait_for_event_or_timeout(struct wl1271 *wl, u32 mask)
 		msleep(1);
 
 		/* read from both event fields */
-		wl1271_read(wl, wl->mbox_ptr[0], events_vector,
-			    sizeof(*events_vector), false);
+		ret = wlcore_read(wl, wl->mbox_ptr[0], events_vector,
+				  sizeof(*events_vector), false);
+		if (ret < 0)
+			goto out;
+
 		event = *events_vector & mask;
-		wl1271_read(wl, wl->mbox_ptr[1], events_vector,
-			    sizeof(*events_vector), false);
+
+		ret = wlcore_read(wl, wl->mbox_ptr[1], events_vector,
+				  sizeof(*events_vector), false);
+		if (ret < 0)
+			goto out;
+
 		event |= *events_vector & mask;
 	} while (!event);
 
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index c976f04..858ac33 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -301,8 +301,10 @@ int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num)
 		return -EINVAL;
 
 	/* first we read the mbox descriptor */
-	wl1271_read(wl, wl->mbox_ptr[mbox_num], wl->mbox,
-		    sizeof(*wl->mbox), false);
+	ret = wlcore_read(wl, wl->mbox_ptr[mbox_num], wl->mbox,
+			  sizeof(*wl->mbox), false);
+	if (ret < 0)
+		return ret;
 
 	/* process the descriptor */
 	ret = wl1271_event_process(wl);
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 9e7787b..f44d586 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -81,10 +81,12 @@ wlcore_hw_get_rx_packet_len(struct wl1271 *wl, void *rx_data, u32 data_len)
 	return wl->ops->get_rx_packet_len(wl, rx_data, data_len);
 }
 
-static inline void wlcore_hw_tx_delayed_compl(struct wl1271 *wl)
+static inline int wlcore_hw_tx_delayed_compl(struct wl1271 *wl)
 {
 	if (wl->ops->tx_delayed_compl)
-		wl->ops->tx_delayed_compl(wl);
+		return wl->ops->tx_delayed_compl(wl);
+
+	return 0;
 }
 
 static inline void wlcore_hw_tx_immediate_compl(struct wl1271 *wl)
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 2713ce1..d114bb4 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -92,14 +92,14 @@ static inline void wl1271_raw_write32(struct wl1271 *wl, int addr, u32 val)
 			     sizeof(wl->buffer_32), false);
 }
 
-static inline void wl1271_read(struct wl1271 *wl, int addr, void *buf,
-			       size_t len, bool fixed)
+static inline int wlcore_read(struct wl1271 *wl, int addr, void *buf,
+			      size_t len, bool fixed)
 {
 	int physical;
 
 	physical = wlcore_translate_addr(wl, addr);
 
-	wlcore_raw_read(wl, physical, buf, len, fixed);
+	return wlcore_raw_read(wl, physical, buf, len, fixed);
 }
 
 static inline void wl1271_write(struct wl1271 *wl, int addr, void *buf,
@@ -118,10 +118,10 @@ static inline void wlcore_write_data(struct wl1271 *wl, int reg, void *buf,
 	wl1271_write(wl, wl->rtable[reg], buf, len, fixed);
 }
 
-static inline void wlcore_read_data(struct wl1271 *wl, int reg, void *buf,
+static inline int wlcore_read_data(struct wl1271 *wl, int reg, void *buf,
 				    size_t len, bool fixed)
 {
-	wl1271_read(wl, wl->rtable[reg], buf, len, fixed);
+	return wlcore_read(wl, wl->rtable[reg], buf, len, fixed);
 }
 
 static inline void wl1271_read_hwaddr(struct wl1271 *wl, int hwaddr,
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 085cd17..deb22f8 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -572,7 +572,11 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 		if (likely(intr & WL1271_ACX_INTR_DATA)) {
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_DATA");
 
-			wl12xx_rx(wl, wl->fw_status_1);
+			ret = wlcore_rx(wl, wl->fw_status_1);
+			if (ret < 0) {
+				wl12xx_queue_recovery_work(wl);
+				goto out;
+			}
 
 			/* Check if any tx blocks were freed */
 			spin_lock_irqsave(&wl->wl_lock, flags);
@@ -589,7 +593,11 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 			}
 
 			/* check for tx results */
-			wlcore_hw_tx_delayed_compl(wl);
+			ret = wlcore_hw_tx_delayed_compl(wl);
+			if (ret < 0) {
+				wl12xx_queue_recovery_work(wl);
+				goto out;
+			}
 
 			/* Make sure the deferred queues don't get too long */
 			defer_count = skb_queue_len(&wl->deferred_tx_queue) +
@@ -600,12 +608,20 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 
 		if (intr & WL1271_ACX_INTR_EVENT_A) {
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_EVENT_A");
-			wl1271_event_handle(wl, 0);
+			ret = wl1271_event_handle(wl, 0);
+			if (ret < 0) {
+				wl12xx_queue_recovery_work(wl);
+				goto out;
+			}
 		}
 
 		if (intr & WL1271_ACX_INTR_EVENT_B) {
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_EVENT_B");
-			wl1271_event_handle(wl, 1);
+			ret = wl1271_event_handle(wl, 1);
+			if (ret < 0) {
+				wl12xx_queue_recovery_work(wl);
+				goto out;
+			}
 		}
 
 		if (intr & WL1271_ACX_INTR_INIT_COMPLETE)
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index a1db4e0..59d0956 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -200,7 +200,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	return is_data;
 }
 
-void wl12xx_rx(struct wl1271 *wl, struct wl_fw_status_1 *status)
+int wlcore_rx(struct wl1271 *wl, struct wl_fw_status_1 *status)
 {
 	unsigned long active_hlids[BITS_TO_LONGS(WL12XX_MAX_LINKS)] = {0};
 	u32 buf_size;
@@ -211,6 +211,7 @@ void wl12xx_rx(struct wl1271 *wl, struct wl_fw_status_1 *status)
 	u32 pkt_offset, des;
 	u8 hlid;
 	enum wl_rx_buf_align rx_align;
+	int ret = 0;
 
 	while (drv_rx_counter != fw_rx_counter) {
 		buf_size = 0;
@@ -235,8 +236,11 @@ void wl12xx_rx(struct wl1271 *wl, struct wl_fw_status_1 *status)
 		/* Read all available packets at once */
 		des = le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]);
 		wlcore_hw_prepare_read(wl, des, buf_size);
-		wlcore_read_data(wl, REG_SLV_MEM_DATA, wl->aggr_buf,
-				 buf_size, true);
+
+		ret = wlcore_read_data(wl, REG_SLV_MEM_DATA, wl->aggr_buf,
+				       buf_size, true);
+		if (ret < 0)
+			goto out;
 
 		/* Split data into separate packets */
 		pkt_offset = 0;
@@ -278,6 +282,9 @@ void wl12xx_rx(struct wl1271 *wl, struct wl_fw_status_1 *status)
 			       wl->rx_counter);
 
 	wl12xx_rearm_rx_streaming(wl, active_hlids);
+
+out:
+	return ret;
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/ti/wlcore/rx.h b/drivers/net/wireless/ti/wlcore/rx.h
index 4324a42..79f7839 100644
--- a/drivers/net/wireless/ti/wlcore/rx.h
+++ b/drivers/net/wireless/ti/wlcore/rx.h
@@ -143,7 +143,7 @@ struct wl1271_rx_descriptor {
 	u8  reserved;
 } __packed;
 
-void wl12xx_rx(struct wl1271 *wl, struct wl_fw_status_1 *status);
+int wlcore_rx(struct wl1271 *wl, struct wl_fw_status_1 *status);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
 int wl1271_rx_filter_enable(struct wl1271 *wl,
 			    int index, bool enable,
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 8ee82b9..fc890cb 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -881,16 +881,20 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 }
 
 /* Called upon reception of a TX complete interrupt */
-void wl1271_tx_complete(struct wl1271 *wl)
+int wlcore_tx_complete(struct wl1271 *wl)
 {
 	struct wl1271_acx_mem_map *memmap =
 		(struct wl1271_acx_mem_map *)wl->target_mem_map;
 	u32 count, fw_counter;
 	u32 i;
+	int ret;
 
 	/* read the tx results from the chipset */
-	wl1271_read(wl, le32_to_cpu(memmap->tx_result),
-		    wl->tx_res_if, sizeof(*wl->tx_res_if), false);
+	ret = wlcore_read(wl, le32_to_cpu(memmap->tx_result),
+			  wl->tx_res_if, sizeof(*wl->tx_res_if), false);
+	if (ret < 0)
+		goto out;
+
 	fw_counter = le32_to_cpu(wl->tx_res_if->tx_result_fw_counter);
 
 	/* write host counter to chipset (to ack) */
@@ -916,8 +920,11 @@ void wl1271_tx_complete(struct wl1271 *wl)
 
 		wl->tx_results_count++;
 	}
+
+out:
+	return ret;
 }
-EXPORT_SYMBOL(wl1271_tx_complete);
+EXPORT_SYMBOL(wlcore_tx_complete);
 
 void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid)
 {
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index fa4be1b..1054094 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -235,7 +235,7 @@ static inline int wl1271_tx_total_queue_count(struct wl1271 *wl)
 
 void wl1271_tx_work(struct work_struct *work);
 void wl1271_tx_work_locked(struct wl1271 *wl);
-void wl1271_tx_complete(struct wl1271 *wl);
+int wlcore_tx_complete(struct wl1271 *wl);
 void wl12xx_tx_reset_wlvif(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 void wl12xx_tx_reset(struct wl1271 *wl);
 void wl1271_tx_flush(struct wl1271 *wl);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 205d8ad..fd37307 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -56,7 +56,7 @@ struct wlcore_ops {
 	void (*prepare_read)(struct wl1271 *wl, u32 rx_desc, u32 len);
 	u32 (*get_rx_packet_len)(struct wl1271 *wl, void *rx_data,
 				 u32 data_len);
-	void (*tx_delayed_compl)(struct wl1271 *wl);
+	int (*tx_delayed_compl)(struct wl1271 *wl);
 	void (*tx_immediate_compl)(struct wl1271 *wl);
 	int (*hw_init)(struct wl1271 *wl);
 	int (*init_vif)(struct wl1271 *wl, struct wl12xx_vif *wlvif);
-- 
1.7.10

