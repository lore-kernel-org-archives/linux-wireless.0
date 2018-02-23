Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:41074 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbeBWOHE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 09:07:04 -0500
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, marcel@holtmann.org
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-bluetooth@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v8 6/8] rsi: handle BT traffic in driver
Date: Fri, 23 Feb 2018 19:24:56 +0530
Message-Id: <1519394098-24220-7-git-send-email-amitkarwar@gmail.com> (sfid-20180223_150711_004964_E824DA86)
In-Reply-To: <1519394098-24220-1-git-send-email-amitkarwar@gmail.com>
References: <1519394098-24220-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

BT frames are passed through coex and hal modules to BUS.
After firmware is loaded, based on the operating mode CARD
READY frame comes for each protocol. When BT card ready is
received, BT attach is called.
Protocol operations are exchanged between the modules
at initialization time.
Build flag CONFIG_RSI_COEX is introduced to enable coex support
if CONFIG_BT_RSIHCI is enabled. Coex operations are valid if
coex mode is greater than 1 only.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
v8: Same as v6, v7
v6: Removed CONFIG_BT_HCIRSI flag dependency on RSI_91x. Introduced
    CONFIG_RSI_COEX for coex code. (Kalle)
v5: Same as v3, v4
v3: bt_ops need not be present structure g_proto_ops. It is removed.
v2: WLAN module depends on BT module. Updated in Kconfig
---
 drivers/net/wireless/rsi/rsi_91x_coex.c     |  4 +-
 drivers/net/wireless/rsi/rsi_91x_core.c     | 20 +++++++---
 drivers/net/wireless/rsi/rsi_91x_hal.c      | 39 ++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_main.c     | 57 +++++++++++++++++++++++++++--
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  1 +
 drivers/net/wireless/rsi/rsi_common.h       |  1 +
 drivers/net/wireless/rsi/rsi_hal.h          | 10 +++++
 drivers/net/wireless/rsi/rsi_main.h         |  3 ++
 8 files changed, 126 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_coex.c b/drivers/net/wireless/rsi/rsi_91x_coex.c
index c07e839..d055099 100644
--- a/drivers/net/wireless/rsi/rsi_91x_coex.c
+++ b/drivers/net/wireless/rsi/rsi_91x_coex.c
@@ -43,8 +43,10 @@ static void rsi_coex_sched_tx_pkts(struct rsi_coex_ctrl_block *coex_cb)
 		coex_q = rsi_coex_determine_coex_q(coex_cb);
 		rsi_dbg(INFO_ZONE, "queue = %d\n", coex_q);
 
-		if (coex_q == RSI_COEX_Q_BT)
+		if (coex_q == RSI_COEX_Q_BT) {
 			skb = skb_dequeue(&coex_cb->coex_tx_qs[RSI_COEX_Q_BT]);
+			rsi_send_bt_pkt(coex_cb->priv, skb);
+		}
 	} while (coex_q != RSI_COEX_Q_INVALID);
 }
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index d0d2201..5dafd2e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -17,6 +17,7 @@
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
 #include "rsi_hal.h"
+#include "rsi_coex.h"
 
 /**
  * rsi_determine_min_weight_queue() - This function determines the queue with
@@ -301,14 +302,23 @@ void rsi_core_qos_processor(struct rsi_common *common)
 			mutex_unlock(&common->tx_lock);
 			break;
 		}
-
-		if (q_num == MGMT_SOFT_Q) {
-			status = rsi_send_mgmt_pkt(common, skb);
-		} else if (q_num == MGMT_BEACON_Q) {
+		if (q_num == MGMT_BEACON_Q) {
 			status = rsi_send_pkt_to_bus(common, skb);
 			dev_kfree_skb(skb);
 		} else {
-			status = rsi_send_data_pkt(common, skb);
+#ifdef CONFIG_RSI_COEX
+			if (common->coex_mode > 1) {
+				status = rsi_coex_send_pkt(common, skb,
+							   RSI_WLAN_Q);
+			} else {
+#endif
+				if (q_num == MGMT_SOFT_Q)
+					status = rsi_send_mgmt_pkt(common, skb);
+				else
+					status = rsi_send_data_pkt(common, skb);
+#ifdef CONFIG_RSI_COEX
+			}
+#endif
 		}
 
 		if (status) {
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 151d228..de608ae 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/firmware.h>
+#include <net/bluetooth/bluetooth.h>
 #include "rsi_mgmt.h"
 #include "rsi_hal.h"
 #include "rsi_sdio.h"
@@ -24,6 +25,7 @@
 static struct ta_metadata metadata_flash_content[] = {
 	{"flash_content", 0x00010000},
 	{"rsi/rs9113_wlan_qspi.rps", 0x00010000},
+	{"rsi/rs9113_wlan_bt_dual_mode.rps", 0x00010000},
 };
 
 int rsi_send_pkt_to_bus(struct rsi_common *common, struct sk_buff *skb)
@@ -357,6 +359,43 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 	return status;
 }
 
+int rsi_send_bt_pkt(struct rsi_common *common, struct sk_buff *skb)
+{
+	int status = -EINVAL;
+	u8 header_size = 0;
+	struct rsi_bt_desc *bt_desc;
+	u8 queueno = ((skb->data[1] >> 4) & 0xf);
+
+	if (queueno == RSI_BT_MGMT_Q) {
+		status = rsi_send_pkt_to_bus(common, skb);
+		if (status)
+			rsi_dbg(ERR_ZONE, "%s: Failed to write bt mgmt pkt\n",
+				__func__);
+		goto out;
+	}
+	header_size = FRAME_DESC_SZ;
+	if (header_size > skb_headroom(skb)) {
+		rsi_dbg(ERR_ZONE, "%s: Not enough headroom\n", __func__);
+		status = -ENOSPC;
+		goto out;
+	}
+	skb_push(skb, header_size);
+	memset(skb->data, 0, header_size);
+	bt_desc = (struct rsi_bt_desc *)skb->data;
+
+	rsi_set_len_qno(&bt_desc->len_qno, (skb->len - FRAME_DESC_SZ),
+			RSI_BT_DATA_Q);
+	bt_desc->bt_pkt_type = cpu_to_le16(bt_cb(skb)->pkt_type);
+
+	status = rsi_send_pkt_to_bus(common, skb);
+	if (status)
+		rsi_dbg(ERR_ZONE, "%s: Failed to write bt pkt\n", __func__);
+
+out:
+	dev_kfree_skb(skb);
+	return status;
+}
+
 int rsi_prepare_beacon(struct rsi_common *common, struct sk_buff *skb)
 {
 	struct rsi_hw *adapter = (struct rsi_hw *)common->priv;
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index fe08ebc..b3e7d75 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -18,6 +18,7 @@
 
 #include <linux/module.h>
 #include <linux/firmware.h>
+#include <net/rsi_91x.h>
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
 #include "rsi_coex.h"
@@ -35,6 +36,14 @@ u32 rsi_zone_enabled = /* INFO_ZONE |
 			0;
 EXPORT_SYMBOL_GPL(rsi_zone_enabled);
 
+#ifdef CONFIG_RSI_COEX
+static struct rsi_proto_ops g_proto_ops = {
+	.coex_send_pkt = rsi_coex_send_pkt,
+	.get_host_intf = rsi_get_host_intf,
+	.set_bt_context = rsi_set_bt_context,
+};
+#endif
+
 /**
  * rsi_dbg() - This function outputs informational messages.
  * @zone: Zone of interest for output message.
@@ -144,6 +153,9 @@ int rsi_read_pkt(struct rsi_common *common, u8 *rx_pkt, s32 rcv_pkt_len)
 	u32 index, length = 0, queueno = 0;
 	u16 actual_length = 0, offset;
 	struct sk_buff *skb = NULL;
+#ifdef CONFIG_RSI_COEX
+	u8 bt_pkt_type;
+#endif
 
 	index = 0;
 	do {
@@ -161,9 +173,11 @@ int rsi_read_pkt(struct rsi_common *common, u8 *rx_pkt, s32 rcv_pkt_len)
 
 		switch (queueno) {
 		case RSI_COEX_Q:
+#ifdef CONFIG_RSI_COEX
 			if (common->coex_mode > 1)
 				rsi_coex_recv_pkt(common, frame_desc + offset);
 			else
+#endif
 				rsi_mgmt_pkt_recv(common,
 						  (frame_desc + offset));
 			break;
@@ -183,6 +197,25 @@ int rsi_read_pkt(struct rsi_common *common, u8 *rx_pkt, s32 rcv_pkt_len)
 			rsi_mgmt_pkt_recv(common, (frame_desc + offset));
 			break;
 
+#ifdef CONFIG_RSI_COEX
+		case RSI_BT_MGMT_Q:
+		case RSI_BT_DATA_Q:
+#define BT_RX_PKT_TYPE_OFST	14
+#define BT_CARD_READY_IND	0x89
+			bt_pkt_type = frame_desc[offset + BT_RX_PKT_TYPE_OFST];
+			if (bt_pkt_type == BT_CARD_READY_IND) {
+				rsi_dbg(INFO_ZONE, "BT Card ready recvd\n");
+				if (rsi_bt_ops.attach(common, &g_proto_ops))
+					rsi_dbg(ERR_ZONE,
+						"Failed to attach BT module\n");
+			} else {
+				if (common->bt_adapter)
+					rsi_bt_ops.recv_pkt(common->bt_adapter,
+							frame_desc + offset);
+			}
+			break;
+#endif
+
 		default:
 			rsi_dbg(ERR_ZONE, "%s: pkt from invalid queue: %d\n",
 				__func__,   queueno);
@@ -223,6 +256,7 @@ static void rsi_tx_scheduler_thread(struct rsi_common *common)
 	complete_and_exit(&common->tx_thread.completion, 0);
 }
 
+#ifdef CONFIG_RSI_COEX
 enum rsi_host_intf rsi_get_host_intf(void *priv)
 {
 	struct rsi_common *common = (struct rsi_common *)priv;
@@ -230,6 +264,14 @@ enum rsi_host_intf rsi_get_host_intf(void *priv)
 	return common->priv->rsi_host_intf;
 }
 
+void rsi_set_bt_context(void *priv, void *bt_context)
+{
+	struct rsi_common *common = (struct rsi_common *)priv;
+
+	common->bt_adapter = bt_context;
+}
+#endif
+
 /**
  * rsi_91x_init() - This function initializes os interface operations.
  * @void: Void.
@@ -283,12 +325,14 @@ struct rsi_hw *rsi_91x_init(void)
 	common->coex_mode = RSI_DEV_COEX_MODE_WIFI_ALONE;
 	common->oper_mode = RSI_DEV_OPMODE_WIFI_ALONE;
 	adapter->device_model = RSI_DEV_9113;
+#ifdef CONFIG_RSI_COEX
 	if (common->coex_mode > 1) {
 		if (rsi_coex_attach(common)) {
 			rsi_dbg(ERR_ZONE, "Failed to init coex module\n");
 			goto err;
 		}
 	}
+#endif
 
 	return adapter;
 
@@ -317,10 +361,17 @@ void rsi_91x_deinit(struct rsi_hw *adapter)
 	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
 		skb_queue_purge(&common->tx_queue[ii]);
 
-	common->init_done = false;
-
-	if (common->coex_mode > 1)
+#ifdef CONFIG_RSI_COEX
+	if (common->coex_mode > 1) {
+		if (common->bt_adapter) {
+			rsi_bt_ops.detach(common->bt_adapter);
+			common->bt_adapter = NULL;
+		}
 		rsi_coex_detach(common);
+	}
+#endif
+
+	common->init_done = false;
 
 	kfree(common);
 	kfree(adapter->rsi_dev);
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 9fbc0ef..169c981 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/firmware.h>
+#include <net/rsi_91x.h>
 #include "rsi_sdio.h"
 #include "rsi_common.h"
 
diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index 1d8af41..4616585 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -62,6 +62,7 @@ static inline int rsi_create_kthread(struct rsi_common *common,
 				     u8 *name)
 {
 	init_completion(&thread->completion);
+	atomic_set(&thread->thread_done, 0);
 	thread->task = kthread_run(func_ptr, common, "%s", name);
 	if (IS_ERR(thread->task))
 		return (int)PTR_ERR(thread->task);
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index a09d36b..e712223 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -145,8 +145,18 @@ struct rsi_data_desc {
 	u8 sta_id;
 } __packed;
 
+struct rsi_bt_desc {
+	__le16 len_qno;
+	__le16 reserved1;
+	__le32 reserved2;
+	__le32 reserved3;
+	__le16 reserved4;
+	__le16 bt_pkt_type;
+} __packed;
+
 int rsi_hal_device_init(struct rsi_hw *adapter);
 int rsi_prepare_beacon(struct rsi_common *common, struct sk_buff *skb);
 int rsi_send_pkt_to_bus(struct rsi_common *common, struct sk_buff *skb);
+int rsi_send_bt_pkt(struct rsi_common *common, struct sk_buff *skb);
 
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 99a00a3..47af0cb 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -291,6 +291,8 @@ struct rsi_common {
 	bool p2p_enabled;
 	struct timer_list roc_timer;
 	struct ieee80211_vif *roc_vif;
+
+	void *bt_adapter;
 };
 
 struct eepromrw_info {
@@ -364,5 +366,6 @@ struct rsi_host_intf_ops {
 };
 
 enum rsi_host_intf rsi_get_host_intf(void *priv);
+void rsi_set_bt_context(void *priv, void *bt_context);
 
 #endif
-- 
2.7.4
