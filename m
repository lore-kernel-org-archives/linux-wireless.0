Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:37499 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755540Ab2FWGmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:05 -0400
Received: by lbbgj3 with SMTP id gj3so4911504lbb.11
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:42:02 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 07/18] wlcore: Propagate errors from wl1271_write
Date: Sat, 23 Jun 2012 09:41:18 +0300
Message-Id: <1340433689-24320-8-git-send-email-coelho@ti.com> (sfid-20120623_085131_027930_A6B8274E)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Propagate errors from wl1271_write and request for recovery when
appropriate.
Also rename prefixes of wlcore functions which their prototypes had to
be changed.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   23 ++++++++++++++++++-----
 drivers/net/wireless/ti/wl18xx/main.c   |   19 ++++++++++++-------
 drivers/net/wireless/ti/wlcore/boot.c   |   17 +++++++++++------
 drivers/net/wireless/ti/wlcore/cmd.c    |   12 +++++++++---
 drivers/net/wireless/ti/wlcore/event.c  |    5 ++++-
 drivers/net/wireless/ti/wlcore/hw_ops.h |    6 ++++--
 drivers/net/wireless/ti/wlcore/io.h     |   12 ++++++------
 drivers/net/wireless/ti/wlcore/main.c   |   13 ++++++++++---
 drivers/net/wireless/ti/wlcore/rx.c     |    4 +++-
 drivers/net/wireless/ti/wlcore/tx.c     |   29 +++++++++++++++++++++--------
 drivers/net/wireless/ti/wlcore/tx.h     |    2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h |    6 +++---
 12 files changed, 102 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 916cee7..257745f 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -598,8 +598,10 @@ static const int wl12xx_rtable[REG_TABLE_LEN] = {
 #define WL128X_FW_NAME_SINGLE	"ti-connectivity/wl128x-fw-4-sr.bin"
 #define WL128X_PLT_FW_NAME	"ti-connectivity/wl128x-fw-4-plt.bin"
 
-static void wl127x_prepare_read(struct wl1271 *wl, u32 rx_desc, u32 len)
+static int wl127x_prepare_read(struct wl1271 *wl, u32 rx_desc, u32 len)
 {
+	int ret;
+
 	if (wl->chip.id != CHIP_ID_1283_PG20) {
 		struct wl1271_acx_mem_map *wl_mem_map = wl->target_mem_map;
 		struct wl127x_rx_mem_pool_addr rx_mem_addr;
@@ -616,9 +618,13 @@ static void wl127x_prepare_read(struct wl1271 *wl, u32 rx_desc, u32 len)
 
 		rx_mem_addr.addr_extra = rx_mem_addr.addr + 4;
 
-		wl1271_write(wl, WL1271_SLV_REG_DATA,
-			     &rx_mem_addr, sizeof(rx_mem_addr), false);
+		ret = wlcore_write(wl, WL1271_SLV_REG_DATA, &rx_mem_addr,
+				   sizeof(rx_mem_addr), false);
+		if (ret < 0)
+			return ret;
 	}
+
+	return 0;
 }
 
 static int wl12xx_identify_chip(struct wl1271 *wl)
@@ -1073,11 +1079,18 @@ out:
 	return ret;
 }
 
-static void wl12xx_trigger_cmd(struct wl1271 *wl, int cmd_box_addr,
+static int wl12xx_trigger_cmd(struct wl1271 *wl, int cmd_box_addr,
 			       void *buf, size_t len)
 {
-	wl1271_write(wl, cmd_box_addr, buf, len, false);
+	int ret;
+
+	ret = wlcore_write(wl, cmd_box_addr, buf, len, false);
+	if (ret < 0)
+		return ret;
+
 	wlcore_write_reg(wl, REG_INTERRUPT_TRIG, WL12XX_INTR_TRIG_CMD);
+
+	return ret;
 }
 
 static void wl12xx_ack_event(struct wl1271 *wl)
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 271ff81..974a6ff 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -720,10 +720,11 @@ static void wl18xx_pre_upload(struct wl1271 *wl)
 	tmp = wl1271_read32(wl, WL18XX_SCR_PAD2);
 }
 
-static void wl18xx_set_mac_and_phy(struct wl1271 *wl)
+static int wl18xx_set_mac_and_phy(struct wl1271 *wl)
 {
 	struct wl18xx_priv *priv = wl->priv;
 	size_t len;
+	int ret;
 
 	/* the parameters struct is smaller for PG1 */
 	if (wl->chip.id == CHIP_ID_185x_PG10)
@@ -732,8 +733,10 @@ static void wl18xx_set_mac_and_phy(struct wl1271 *wl)
 		len = sizeof(struct wl18xx_mac_and_phy_params);
 
 	wlcore_set_partition(wl, &wl->ptable[PART_PHY_INIT]);
-	wl1271_write(wl, WL18XX_PHY_INIT_MEM_ADDR, (u8 *)&priv->conf.phy, len,
-		     false);
+	ret = wlcore_write(wl, WL18XX_PHY_INIT_MEM_ADDR, (u8 *)&priv->conf.phy,
+			   len, false);
+
+	return ret;
 }
 
 static void wl18xx_enable_interrupts(struct wl1271 *wl)
@@ -769,7 +772,9 @@ static int wl18xx_boot(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
-	wl18xx_set_mac_and_phy(wl);
+	ret = wl18xx_set_mac_and_phy(wl);
+	if (ret < 0)
+		goto out;
 
 	ret = wlcore_boot_run_firmware(wl);
 	if (ret < 0)
@@ -781,7 +786,7 @@ out:
 	return ret;
 }
 
-static void wl18xx_trigger_cmd(struct wl1271 *wl, int cmd_box_addr,
+static int wl18xx_trigger_cmd(struct wl1271 *wl, int cmd_box_addr,
 			       void *buf, size_t len)
 {
 	struct wl18xx_priv *priv = wl->priv;
@@ -789,8 +794,8 @@ static void wl18xx_trigger_cmd(struct wl1271 *wl, int cmd_box_addr,
 	memcpy(priv->cmd_buf, buf, len);
 	memset(priv->cmd_buf + len, 0, WL18XX_CMD_MAX_SIZE - len);
 
-	wl1271_write(wl, cmd_box_addr, priv->cmd_buf, WL18XX_CMD_MAX_SIZE,
-		     false);
+	return wlcore_write(wl, cmd_box_addr, priv->cmd_buf,
+			    WL18XX_CMD_MAX_SIZE, false);
 }
 
 static void wl18xx_ack_event(struct wl1271 *wl)
diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index d7abc50..ee7a401 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -111,6 +111,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 	struct wlcore_partition_set partition;
 	int addr, chunk_num, partition_limit;
 	u8 *p, *chunk;
+	int ret;
 
 	/* whal_FwCtrl_LoadFwImageSm() */
 
@@ -155,7 +156,9 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 		memcpy(chunk, p, CHUNK_SIZE);
 		wl1271_debug(DEBUG_BOOT, "uploading fw chunk 0x%p to 0x%x",
 			     p, addr);
-		wl1271_write(wl, addr, chunk, CHUNK_SIZE, false);
+		ret = wlcore_write(wl, addr, chunk, CHUNK_SIZE, false);
+		if (ret < 0)
+			goto out;
 
 		chunk_num++;
 	}
@@ -166,10 +169,11 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 	memcpy(chunk, p, fw_data_len % CHUNK_SIZE);
 	wl1271_debug(DEBUG_BOOT, "uploading fw last chunk (%zd B) 0x%p to 0x%x",
 		     fw_data_len % CHUNK_SIZE, p, addr);
-	wl1271_write(wl, addr, chunk, fw_data_len % CHUNK_SIZE, false);
+	ret = wlcore_write(wl, addr, chunk, fw_data_len % CHUNK_SIZE, false);
 
+out:
 	kfree(chunk);
-	return 0;
+	return ret;
 }
 
 int wlcore_boot_upload_firmware(struct wl1271 *wl)
@@ -212,6 +216,7 @@ int wlcore_boot_upload_nvs(struct wl1271 *wl)
 	int i;
 	u32 dest_addr, val;
 	u8 *nvs_ptr, *nvs_aligned;
+	int ret;
 
 	if (wl->nvs == NULL) {
 		wl1271_error("NVS file is needed during boot");
@@ -343,11 +348,11 @@ int wlcore_boot_upload_nvs(struct wl1271 *wl)
 		return -ENOMEM;
 
 	/* And finally we upload the NVS tables */
-	wlcore_write_data(wl, REG_CMD_MBOX_ADDRESS,
-			  nvs_aligned, nvs_len, false);
+	ret = wlcore_write_data(wl, REG_CMD_MBOX_ADDRESS, nvs_aligned, nvs_len,
+				false);
 
 	kfree(nvs_aligned);
-	return 0;
+	return ret;
 
 out_badnvs:
 	wl1271_error("nvs data is malformed");
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 69f27d1..658dccb 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -65,13 +65,17 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 	WARN_ON(len % 4 != 0);
 	WARN_ON(test_bit(WL1271_FLAG_IN_ELP, &wl->flags));
 
-	wl1271_write(wl, wl->cmd_box_addr, buf, len, false);
+	ret = wlcore_write(wl, wl->cmd_box_addr, buf, len, false);
+	if (ret < 0)
+		goto fail;
 
 	/*
 	 * TODO: we just need this because one bit is in a different
 	 * place.  Is there any better way?
 	 */
-	wl->ops->trigger_cmd(wl, wl->cmd_box_addr, buf, len);
+	ret = wl->ops->trigger_cmd(wl, wl->cmd_box_addr, buf, len);
+	if (ret < 0)
+		goto fail;
 
 	timeout = jiffies + msecs_to_jiffies(WL1271_COMMAND_TIMEOUT);
 
@@ -1764,7 +1768,9 @@ int wl12xx_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		return -EINVAL;
 
 	/* flush all pending packets */
-	wl1271_tx_work_locked(wl);
+	ret = wlcore_tx_work_locked(wl);
+	if (ret < 0)
+		goto out;
 
 	if (test_bit(wlvif->dev_role_id, wl->roc_map)) {
 		ret = wl12xx_croc(wl, wlvif->dev_role_id);
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 858ac33..123d26d 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -105,6 +105,7 @@ static int wl1271_event_process(struct wl1271 *wl)
 	u32 vector;
 	bool disconnect_sta = false;
 	unsigned long sta_bitmap = 0;
+	int ret;
 
 	wl1271_event_mbox_dump(mbox);
 
@@ -228,7 +229,9 @@ static int wl1271_event_process(struct wl1271 *wl)
 
 	if ((vector & DUMMY_PACKET_EVENT_ID)) {
 		wl1271_debug(DEBUG_EVENT, "DUMMY_PACKET_ID_EVENT_ID");
-		wl1271_tx_dummy_packet(wl);
+		ret = wl1271_tx_dummy_packet(wl);
+		if (ret < 0)
+			return ret;
 	}
 
 	/*
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index f44d586..2673d78 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -65,11 +65,13 @@ wlcore_hw_get_rx_buf_align(struct wl1271 *wl, u32 rx_desc)
 	return wl->ops->get_rx_buf_align(wl, rx_desc);
 }
 
-static inline void
+static inline int
 wlcore_hw_prepare_read(struct wl1271 *wl, u32 rx_desc, u32 len)
 {
 	if (wl->ops->prepare_read)
-		wl->ops->prepare_read(wl, rx_desc, len);
+		return wl->ops->prepare_read(wl, rx_desc, len);
+
+	return 0;
 }
 
 static inline u32
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index d114bb4..2cbf762 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -102,20 +102,20 @@ static inline int wlcore_read(struct wl1271 *wl, int addr, void *buf,
 	return wlcore_raw_read(wl, physical, buf, len, fixed);
 }
 
-static inline void wl1271_write(struct wl1271 *wl, int addr, void *buf,
-				size_t len, bool fixed)
+static inline int wlcore_write(struct wl1271 *wl, int addr, void *buf,
+			       size_t len, bool fixed)
 {
 	int physical;
 
 	physical = wlcore_translate_addr(wl, addr);
 
-	wlcore_raw_write(wl, physical, buf, len, fixed);
+	return wlcore_raw_write(wl, physical, buf, len, fixed);
 }
 
-static inline void wlcore_write_data(struct wl1271 *wl, int reg, void *buf,
-				     size_t len, bool fixed)
+static inline int wlcore_write_data(struct wl1271 *wl, int reg, void *buf,
+				    size_t len, bool fixed)
 {
-	wl1271_write(wl, wl->rtable[reg], buf, len, fixed);
+	return wlcore_write(wl, wl->rtable[reg], buf, len, fixed);
 }
 
 static inline int wlcore_read_data(struct wl1271 *wl, int reg, void *buf,
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index deb22f8..0461d4e 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -587,7 +587,11 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 				 * In order to avoid starvation of the TX path,
 				 * call the work function directly.
 				 */
-				wl1271_tx_work_locked(wl);
+				ret = wlcore_tx_work_locked(wl);
+				if (ret < 0) {
+					wl12xx_queue_recovery_work(wl);
+					goto out;
+				}
 			} else {
 				spin_unlock_irqrestore(&wl->wl_lock, flags);
 			}
@@ -1211,7 +1215,7 @@ int wl1271_tx_dummy_packet(struct wl1271 *wl)
 
 	/* The FW is low on RX memory blocks, so send the dummy packet asap */
 	if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags))
-		wl1271_tx_work_locked(wl);
+		return wlcore_tx_work_locked(wl);
 
 	/*
 	 * If the FW TX is busy, TX work will be scheduled by the threaded
@@ -2513,7 +2517,10 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	     (wlvif->channel != channel) ||
 	     (wlvif->channel_type != conf->channel_type))) {
 		/* send all pending packets */
-		wl1271_tx_work_locked(wl);
+		ret = wlcore_tx_work_locked(wl);
+		if (ret < 0)
+			return ret;
+
 		wlvif->band = conf->channel->band;
 		wlvif->channel = channel;
 		wlvif->channel_type = conf->channel_type;
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 59d0956..be24b30 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -235,7 +235,9 @@ int wlcore_rx(struct wl1271 *wl, struct wl_fw_status_1 *status)
 
 		/* Read all available packets at once */
 		des = le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]);
-		wlcore_hw_prepare_read(wl, des, buf_size);
+		ret = wlcore_hw_prepare_read(wl, des, buf_size);
+		if (ret < 0)
+			goto out;
 
 		ret = wlcore_read_data(wl, REG_SLV_MEM_DATA, wl->aggr_buf,
 				       buf_size, true);
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index fc890cb..90bddf5 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -662,7 +662,7 @@ void wl12xx_rearm_rx_streaming(struct wl1271 *wl, unsigned long *active_hlids)
 	}
 }
 
-void wl1271_tx_work_locked(struct wl1271 *wl)
+int wlcore_tx_work_locked(struct wl1271 *wl)
 {
 	struct wl12xx_vif *wlvif;
 	struct sk_buff *skb;
@@ -670,10 +670,10 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 	u32 buf_offset = 0, last_len = 0;
 	bool sent_packets = false;
 	unsigned long active_hlids[BITS_TO_LONGS(WL12XX_MAX_LINKS)] = {0};
-	int ret;
+	int ret = 0;
 
 	if (unlikely(wl->state == WL1271_STATE_OFF))
-		return;
+		return -EIO;
 
 	while ((skb = wl1271_skb_dequeue(wl))) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -694,8 +694,11 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 
 			buf_offset = wlcore_hw_pre_pkt_send(wl, buf_offset,
 							    last_len);
-			wlcore_write_data(wl, REG_SLV_MEM_DATA, wl->aggr_buf,
-					  buf_offset, true);
+			ret = wlcore_write_data(wl, REG_SLV_MEM_DATA,
+						wl->aggr_buf, buf_offset, true);
+			if (ret < 0)
+				goto out;
+
 			sent_packets = true;
 			buf_offset = 0;
 			continue;
@@ -731,8 +734,11 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 out_ack:
 	if (buf_offset) {
 		buf_offset = wlcore_hw_pre_pkt_send(wl, buf_offset, last_len);
-		wlcore_write_data(wl, REG_SLV_MEM_DATA, wl->aggr_buf,
-				  buf_offset, true);
+		ret = wlcore_write_data(wl, REG_SLV_MEM_DATA, wl->aggr_buf,
+					buf_offset, true);
+		if (ret < 0)
+			goto out;
+
 		sent_packets = true;
 	}
 	if (sent_packets) {
@@ -747,6 +753,9 @@ out_ack:
 		wl1271_handle_tx_low_watermark(wl);
 	}
 	wl12xx_rearm_rx_streaming(wl, active_hlids);
+
+out:
+	return ret;
 }
 
 void wl1271_tx_work(struct work_struct *work)
@@ -759,7 +768,11 @@ void wl1271_tx_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
-	wl1271_tx_work_locked(wl);
+	ret = wlcore_tx_work_locked(wl);
+	if (ret < 0) {
+		wl12xx_queue_recovery_work(wl);
+		goto out;
+	}
 
 	wl1271_ps_elp_sleep(wl);
 out:
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index 1054094..1e939b0 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -234,7 +234,7 @@ static inline int wl1271_tx_total_queue_count(struct wl1271 *wl)
 }
 
 void wl1271_tx_work(struct work_struct *work);
-void wl1271_tx_work_locked(struct wl1271 *wl);
+int wlcore_tx_work_locked(struct wl1271 *wl);
 int wlcore_tx_complete(struct wl1271 *wl);
 void wl12xx_tx_reset_wlvif(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 void wl12xx_tx_reset(struct wl1271 *wl);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index fd37307..5d51647 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -41,8 +41,8 @@ struct wlcore_ops {
 	int (*identify_fw)(struct wl1271 *wl);
 	int (*boot)(struct wl1271 *wl);
 	int (*plt_init)(struct wl1271 *wl);
-	void (*trigger_cmd)(struct wl1271 *wl, int cmd_box_addr,
-			    void *buf, size_t len);
+	int (*trigger_cmd)(struct wl1271 *wl, int cmd_box_addr,
+			   void *buf, size_t len);
 	void (*ack_event)(struct wl1271 *wl);
 	u32 (*calc_tx_blocks)(struct wl1271 *wl, u32 len, u32 spare_blks);
 	void (*set_tx_desc_blocks)(struct wl1271 *wl,
@@ -53,7 +53,7 @@ struct wlcore_ops {
 				     struct sk_buff *skb);
 	enum wl_rx_buf_align (*get_rx_buf_align)(struct wl1271 *wl,
 						 u32 rx_desc);
-	void (*prepare_read)(struct wl1271 *wl, u32 rx_desc, u32 len);
+	int (*prepare_read)(struct wl1271 *wl, u32 rx_desc, u32 len);
 	u32 (*get_rx_packet_len)(struct wl1271 *wl, void *rx_data,
 				 u32 data_len);
 	int (*tx_delayed_compl)(struct wl1271 *wl);
-- 
1.7.10

