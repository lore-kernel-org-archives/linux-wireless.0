Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37146 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754395AbdLFKFX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Dec 2017 05:05:23 -0500
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, marcel@holtmann.org
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: [v4 6/8] rsi: handle BT traffic in driver
Date: Wed,  6 Dec 2017 15:26:35 +0530
Message-Id: <1512554197-19664-7-git-send-email-amitkarwar@gmail.com> (sfid-20171206_110531_137610_6E4443A8)
In-Reply-To: <1512554197-19664-1-git-send-email-amitkarwar@gmail.com>
References: <1512554197-19664-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

BT frames are passed through coex and hal modules to BUS.
After firmware is loaded, based on the operating mode CARD
READY frame comes for each protocol. When BT card ready is
received, BT attach is called.
Protocol operations are exchanged between the modules
at initialization time.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
v3: bt_ops need not be present structure g_proto_ops. It is removed.
v2: WLAN module depends on BT module. Updated in Kconfig
---
 drivers/net/wireless/rsi/Kconfig            |  2 +-
 drivers/net/wireless/rsi/rsi_91x_coex.c     |  4 ++-
 drivers/net/wireless/rsi/rsi_91x_core.c     | 16 ++++++++----
 drivers/net/wireless/rsi/rsi_91x_hal.c      | 39 +++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_main.c     | 31 +++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  1 +
 drivers/net/wireless/rsi/rsi_common.h       |  1 +
 drivers/net/wireless/rsi/rsi_hal.h          | 10 ++++++++
 drivers/net/wireless/rsi/rsi_main.h         |  3 +++
 9 files changed, 100 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rsi/Kconfig b/drivers/net/wireless/rsi/Kconfig
index 7c5e4ca..ad72c80 100644
--- a/drivers/net/wireless/rsi/Kconfig
+++ b/drivers/net/wireless/rsi/Kconfig
@@ -13,7 +13,7 @@ if WLAN_VENDOR_RSI
 
 config RSI_91X
 	tristate "Redpine Signals Inc 91x WLAN driver support"
-	depends on MAC80211
+	depends on MAC80211 && BT_RSI
 	---help---
 	  This option enabes support for RSI 1x1 devices.
 	  Select M (recommended), if you have a RSI 1x1 wireless module.
diff --git a/drivers/net/wireless/rsi/rsi_91x_coex.c b/drivers/net/wireless/rsi/rsi_91x_coex.c
index 914a0c5..f502cf9 100644
--- a/drivers/net/wireless/rsi/rsi_91x_coex.c
+++ b/drivers/net/wireless/rsi/rsi_91x_coex.c
@@ -48,8 +48,10 @@ static void rsi_coex_sched_tx_pkts(struct rsi_coex_ctrl_block *coex_cb)
 			break;
 		}
 
-		if (coex_q == RSI_COEX_Q_BT)
+		if (coex_q == RSI_COEX_Q_BT) {
 			skb = skb_dequeue(&coex_cb->coex_tx_qs[RSI_COEX_Q_BT]);
+			rsi_send_bt_pkt(coex_cb->priv, skb);
+		}
 	}
 }
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index d0d2201..046ace8 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -17,6 +17,7 @@
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
 #include "rsi_hal.h"
+#include "rsi_coex.h"
 
 /**
  * rsi_determine_min_weight_queue() - This function determines the queue with
@@ -301,14 +302,19 @@ void rsi_core_qos_processor(struct rsi_common *common)
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
+			if (common->coex_mode > 1) {
+				status = rsi_coex_send_pkt(common, skb,
+							   RSI_WLAN_Q);
+			} else {
+				if (q_num == MGMT_SOFT_Q)
+					status = rsi_send_mgmt_pkt(common, skb);
+				else
+					status = rsi_send_data_pkt(common, skb);
+			}
 		}
 
 		if (status) {
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 8b30448..883dba1 100644
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
index 7dce533..375b725 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -18,6 +18,7 @@
 
 #include <linux/module.h>
 #include <linux/firmware.h>
+#include <linux/rsi_header.h>
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
 #include "rsi_coex.h"
@@ -35,6 +36,12 @@ u32 rsi_zone_enabled = /* INFO_ZONE |
 			0;
 EXPORT_SYMBOL_GPL(rsi_zone_enabled);
 
+static struct rsi_proto_ops g_proto_ops = {
+	.coex_send_pkt = rsi_coex_send_pkt,
+	.get_host_intf = rsi_get_host_intf,
+	.set_bt_context = rsi_set_bt_context,
+};
+
 /**
  * rsi_dbg() - This function outputs informational messages.
  * @zone: Zone of interest for output message.
@@ -144,6 +151,7 @@ int rsi_read_pkt(struct rsi_common *common, u8 *rx_pkt, s32 rcv_pkt_len)
 	u32 index, length = 0, queueno = 0;
 	u16 actual_length = 0, offset;
 	struct sk_buff *skb = NULL;
+	u8 bt_pkt_type;
 
 	index = 0;
 	do {
@@ -183,6 +191,22 @@ int rsi_read_pkt(struct rsi_common *common, u8 *rx_pkt, s32 rcv_pkt_len)
 			rsi_mgmt_pkt_recv(common, (frame_desc + offset));
 			break;
 
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
+				rsi_bt_ops.recv_pkt(common->bt_adapter,
+						    frame_desc + offset);
+			}
+			break;
+
 		default:
 			rsi_dbg(ERR_ZONE, "%s: pkt from invalid queue: %d\n",
 				__func__,   queueno);
@@ -230,6 +254,13 @@ enum rsi_host_intf rsi_get_host_intf(void *priv)
 	return common->priv->rsi_host_intf;
 }
 
+void rsi_set_bt_context(void *priv, void *bt_context)
+{
+	struct rsi_common *common = (struct rsi_common *)priv;
+
+	common->bt_adapter = bt_context;
+}
+
 /**
  * rsi_91x_init() - This function initializes os interface operations.
  * @void: Void.
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 9fbc0ef..26abe51 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/firmware.h>
+#include <linux/rsi_header.h>
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
index e1c1dc8..69a604e 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -290,6 +290,8 @@ struct rsi_common {
 	bool p2p_enabled;
 	struct timer_list roc_timer;
 	struct ieee80211_vif *roc_vif;
+
+	void *bt_adapter;
 };
 
 struct eepromrw_info {
@@ -363,5 +365,6 @@ struct rsi_host_intf_ops {
 };
 
 enum rsi_host_intf rsi_get_host_intf(void *priv);
+void rsi_set_bt_context(void *priv, void *bt_context);
 
 #endif
-- 
2.7.4
