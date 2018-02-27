Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:32988 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753629AbeB0OiH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 09:38:07 -0500
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, marcel@holtmann.org
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-bluetooth@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v9 4/8] rsi: add coex support
Date: Tue, 27 Feb 2018 19:56:14 +0530
Message-Id: <1519741578-12640-5-git-send-email-amitkarwar@gmail.com> (sfid-20180227_153815_088332_C6CFA15E)
In-Reply-To: <1519741578-12640-1-git-send-email-amitkarwar@gmail.com>
References: <1519741578-12640-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

With BT support, driver has to handle two streams of data
(i.e. wlan and BT). Actual coex implementation is in firmware.
Coex module just schedule the packets to firmware by taking them
from the corresponding paths.

Structures for module and protocol operations are introduced for
this purpose. Protocol operations structure is global structure
which can be shared among different modules. Move initialization
of coex and operating mode values to rsi_91x_init().

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
v8 and v9: Resolved error reported by 'kbuild test robot' by guarding
           code with CONFIG_RSI_COEX flag
v7: Use mutex instead of semaphore (Kalle)
v6: Rename semaphore tx_bus_lock to tx_bus_sema. Modified coex
    scheduling loop to avoid while(1) (Kalle)
v5: Same as earlier versions

---
 drivers/net/wireless/rsi/Kconfig        |   9 ++
 drivers/net/wireless/rsi/Makefile       |   1 +
 drivers/net/wireless/rsi/rsi_91x_coex.c | 177 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_hal.c  |  17 +--
 drivers/net/wireless/rsi/rsi_91x_main.c |  38 ++++++-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c |   2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c |   1 +
 drivers/net/wireless/rsi/rsi_91x_usb.c  |   2 +
 drivers/net/wireless/rsi/rsi_coex.h     |  37 +++++++
 drivers/net/wireless/rsi/rsi_main.h     |   6 ++
 drivers/net/wireless/rsi/rsi_mgmt.h     |   3 +
 include/net/rsi_91x.h                   |  20 ++++
 12 files changed, 303 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_coex.c
 create mode 100644 drivers/net/wireless/rsi/rsi_coex.h

diff --git a/drivers/net/wireless/rsi/Kconfig b/drivers/net/wireless/rsi/Kconfig
index 7c5e4ca..e6135ee 100644
--- a/drivers/net/wireless/rsi/Kconfig
+++ b/drivers/net/wireless/rsi/Kconfig
@@ -42,4 +42,13 @@ config RSI_USB
 	  This option enables the USB bus support in rsi drivers.
 	  Select M (recommended), if you have a RSI 1x1 wireless module.
 
+config RSI_COEX
+	bool "Redpine Signals WLAN BT Coexistence support"
+	depends on BT_HCIRSI && RSI_91X
+	default y
+	---help---
+	  This option enables the WLAN BT coex support in rsi drivers.
+	  Select M (recommended), if you have want to use this feature
+	  and you have RS9113 module.
+
 endif # WLAN_VENDOR_RSI
diff --git a/drivers/net/wireless/rsi/Makefile b/drivers/net/wireless/rsi/Makefile
index 47c4590..ff87121a 100644
--- a/drivers/net/wireless/rsi/Makefile
+++ b/drivers/net/wireless/rsi/Makefile
@@ -5,6 +5,7 @@ rsi_91x-y			+= rsi_91x_mac80211.o
 rsi_91x-y			+= rsi_91x_mgmt.o
 rsi_91x-y			+= rsi_91x_hal.o
 rsi_91x-y			+= rsi_91x_ps.o
+rsi_91x-$(CONFIG_RSI_COEX)	+= rsi_91x_coex.o
 rsi_91x-$(CONFIG_RSI_DEBUGFS)	+= rsi_91x_debugfs.o
 
 rsi_usb-y			+= rsi_91x_usb.o rsi_91x_usb_ops.o
diff --git a/drivers/net/wireless/rsi/rsi_91x_coex.c b/drivers/net/wireless/rsi/rsi_91x_coex.c
new file mode 100644
index 0000000..c07e839
--- /dev/null
+++ b/drivers/net/wireless/rsi/rsi_91x_coex.c
@@ -0,0 +1,177 @@
+/**
+ * Copyright (c) 2018 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "rsi_main.h"
+#include "rsi_coex.h"
+#include "rsi_mgmt.h"
+#include "rsi_hal.h"
+
+static enum rsi_coex_queues rsi_coex_determine_coex_q
+			(struct rsi_coex_ctrl_block *coex_cb)
+{
+	enum rsi_coex_queues q_num = RSI_COEX_Q_INVALID;
+
+	if (skb_queue_len(&coex_cb->coex_tx_qs[RSI_COEX_Q_COMMON]) > 0)
+		q_num = RSI_COEX_Q_COMMON;
+	if (skb_queue_len(&coex_cb->coex_tx_qs[RSI_COEX_Q_BT]) > 0)
+		q_num = RSI_COEX_Q_BT;
+	if (skb_queue_len(&coex_cb->coex_tx_qs[RSI_COEX_Q_WLAN]) > 0)
+		q_num = RSI_COEX_Q_WLAN;
+
+	return q_num;
+}
+
+static void rsi_coex_sched_tx_pkts(struct rsi_coex_ctrl_block *coex_cb)
+{
+	enum rsi_coex_queues coex_q = RSI_COEX_Q_INVALID;
+	struct sk_buff *skb;
+
+	do {
+		coex_q = rsi_coex_determine_coex_q(coex_cb);
+		rsi_dbg(INFO_ZONE, "queue = %d\n", coex_q);
+
+		if (coex_q == RSI_COEX_Q_BT)
+			skb = skb_dequeue(&coex_cb->coex_tx_qs[RSI_COEX_Q_BT]);
+	} while (coex_q != RSI_COEX_Q_INVALID);
+}
+
+static void rsi_coex_scheduler_thread(struct rsi_common *common)
+{
+	struct rsi_coex_ctrl_block *coex_cb =
+		(struct rsi_coex_ctrl_block *)common->coex_cb;
+	u32 timeout = EVENT_WAIT_FOREVER;
+
+	do {
+		rsi_wait_event(&coex_cb->coex_tx_thread.event, timeout);
+		rsi_reset_event(&coex_cb->coex_tx_thread.event);
+
+		rsi_coex_sched_tx_pkts(coex_cb);
+	} while (atomic_read(&coex_cb->coex_tx_thread.thread_done) == 0);
+
+	complete_and_exit(&coex_cb->coex_tx_thread.completion, 0);
+}
+
+int rsi_coex_recv_pkt(struct rsi_common *common, u8 *msg)
+{
+	u8 msg_type = msg[RSI_RX_DESC_MSG_TYPE_OFFSET];
+
+	switch (msg_type) {
+	case COMMON_CARD_READY_IND:
+		rsi_dbg(INFO_ZONE, "common card ready received\n");
+		rsi_handle_card_ready(common, msg);
+		break;
+	case SLEEP_NOTIFY_IND:
+		rsi_dbg(INFO_ZONE, "sleep notify received\n");
+		rsi_mgmt_pkt_recv(common, msg);
+		break;
+	}
+
+	return 0;
+}
+
+static inline int rsi_map_coex_q(u8 hal_queue)
+{
+	switch (hal_queue) {
+	case RSI_COEX_Q:
+		return RSI_COEX_Q_COMMON;
+	case RSI_WLAN_Q:
+		return RSI_COEX_Q_WLAN;
+	case RSI_BT_Q:
+		return RSI_COEX_Q_BT;
+	}
+	return RSI_COEX_Q_INVALID;
+}
+
+int rsi_coex_send_pkt(void *priv, struct sk_buff *skb, u8 hal_queue)
+{
+	struct rsi_common *common = (struct rsi_common *)priv;
+	struct rsi_coex_ctrl_block *coex_cb =
+		(struct rsi_coex_ctrl_block *)common->coex_cb;
+	struct skb_info *tx_params = NULL;
+	enum rsi_coex_queues coex_q;
+	int status;
+
+	coex_q = rsi_map_coex_q(hal_queue);
+	if (coex_q == RSI_COEX_Q_INVALID) {
+		rsi_dbg(ERR_ZONE, "Invalid coex queue\n");
+		return -EINVAL;
+	}
+	if (coex_q != RSI_COEX_Q_COMMON &&
+	    coex_q != RSI_COEX_Q_WLAN) {
+		skb_queue_tail(&coex_cb->coex_tx_qs[coex_q], skb);
+		rsi_set_event(&coex_cb->coex_tx_thread.event);
+		return 0;
+	}
+	if (common->iface_down) {
+		tx_params =
+			(struct skb_info *)&IEEE80211_SKB_CB(skb)->driver_data;
+
+		if (!(tx_params->flags & INTERNAL_MGMT_PKT)) {
+			rsi_indicate_tx_status(common->priv, skb, -EINVAL);
+			return 0;
+		}
+	}
+
+	/* Send packet to hal */
+	if (skb->priority == MGMT_SOFT_Q)
+		status = rsi_send_mgmt_pkt(common, skb);
+	else
+		status = rsi_send_data_pkt(common, skb);
+
+	return status;
+}
+
+int rsi_coex_attach(struct rsi_common *common)
+{
+	struct rsi_coex_ctrl_block *coex_cb;
+	int cnt;
+
+	coex_cb = kzalloc(sizeof(*coex_cb), GFP_KERNEL);
+	if (!coex_cb)
+		return -ENOMEM;
+
+	common->coex_cb = (void *)coex_cb;
+	coex_cb->priv = common;
+
+	/* Initialize co-ex queues */
+	for (cnt = 0; cnt < NUM_COEX_TX_QUEUES; cnt++)
+		skb_queue_head_init(&coex_cb->coex_tx_qs[cnt]);
+	rsi_init_event(&coex_cb->coex_tx_thread.event);
+
+	/* Initialize co-ex thread */
+	if (rsi_create_kthread(common,
+			       &coex_cb->coex_tx_thread,
+			       rsi_coex_scheduler_thread,
+			       "Coex-Tx-Thread")) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to init tx thrd\n", __func__);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+void rsi_coex_detach(struct rsi_common *common)
+{
+	struct rsi_coex_ctrl_block *coex_cb =
+		(struct rsi_coex_ctrl_block *)common->coex_cb;
+	int cnt;
+
+	rsi_kill_thread(&coex_cb->coex_tx_thread);
+
+	for (cnt = 0; cnt < NUM_COEX_TX_QUEUES; cnt++)
+		skb_queue_purge(&coex_cb->coex_tx_qs[cnt]);
+
+	kfree(coex_cb);
+}
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 1176de6..151d228 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -31,8 +31,15 @@ int rsi_send_pkt_to_bus(struct rsi_common *common, struct sk_buff *skb)
 	struct rsi_hw *adapter = common->priv;
 	int status;
 
+	if (common->coex_mode > 1)
+		mutex_lock(&common->tx_bus_mutex);
+
 	status = adapter->host_intf_ops->write_pkt(common->priv,
 						   skb->data, skb->len);
+
+	if (common->coex_mode > 1)
+		mutex_unlock(&common->tx_bus_mutex);
+
 	return status;
 }
 
@@ -296,8 +303,7 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	if (status)
 		goto err;
 
-	status = adapter->host_intf_ops->write_pkt(common->priv, skb->data,
-						   skb->len);
+	status = rsi_send_pkt_to_bus(common, skb);
 	if (status)
 		rsi_dbg(ERR_ZONE, "%s: Failed to write pkt\n", __func__);
 
@@ -342,8 +348,7 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 		goto err;
 
 	rsi_prepare_mgmt_desc(common, skb);
-	status = adapter->host_intf_ops->write_pkt(common->priv,
-						   (u8 *)skb->data, skb->len);
+	status = rsi_send_pkt_to_bus(common, skb);
 	if (status)
 		rsi_dbg(ERR_ZONE, "%s: Failed to write the packet\n", __func__);
 
@@ -926,10 +931,6 @@ int rsi_hal_device_init(struct rsi_hw *adapter)
 {
 	struct rsi_common *common = adapter->priv;
 
-	common->coex_mode = RSI_DEV_COEX_MODE_WIFI_ALONE;
-	common->oper_mode = RSI_DEV_OPMODE_WIFI_ALONE;
-	adapter->device_model = RSI_DEV_9113;
-
 	switch (adapter->device_model) {
 	case RSI_DEV_9113:
 		if (rsi_load_firmware(adapter)) {
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 0413af8..641c388 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -20,6 +20,7 @@
 #include <linux/firmware.h>
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
+#include "rsi_coex.h"
 #include "rsi_hal.h"
 
 u32 rsi_zone_enabled = /* INFO_ZONE |
@@ -160,8 +161,15 @@ int rsi_read_pkt(struct rsi_common *common, u8 *rx_pkt, s32 rcv_pkt_len)
 
 		switch (queueno) {
 		case RSI_COEX_Q:
-			rsi_mgmt_pkt_recv(common, (frame_desc + offset));
+#ifdef CONFIG_RSI_COEX
+			if (common->coex_mode > 1)
+				rsi_coex_recv_pkt(common, frame_desc + offset);
+			else
+#endif
+				rsi_mgmt_pkt_recv(common,
+						  (frame_desc + offset));
 			break;
+
 		case RSI_WIFI_DATA_Q:
 			skb = rsi_prepare_skb(common,
 					      (frame_desc + offset),
@@ -217,6 +225,15 @@ static void rsi_tx_scheduler_thread(struct rsi_common *common)
 	complete_and_exit(&common->tx_thread.completion, 0);
 }
 
+#ifdef CONFIG_RSI_COEX
+enum rsi_host_intf rsi_get_host_intf(void *priv)
+{
+	struct rsi_common *common = (struct rsi_common *)priv;
+
+	return common->priv->rsi_host_intf;
+}
+#endif
+
 /**
  * rsi_91x_init() - This function initializes os interface operations.
  * @void: Void.
@@ -251,6 +268,7 @@ struct rsi_hw *rsi_91x_init(void)
 	mutex_init(&common->mutex);
 	mutex_init(&common->tx_lock);
 	mutex_init(&common->rx_lock);
+	mutex_init(&common->tx_bus_mutex);
 
 	if (rsi_create_kthread(common,
 			       &common->tx_thread,
@@ -265,6 +283,19 @@ struct rsi_hw *rsi_91x_init(void)
 	timer_setup(&common->roc_timer, rsi_roc_timeout, 0);
 	init_completion(&common->wlan_init_completion);
 	common->init_done = true;
+
+	common->coex_mode = RSI_DEV_COEX_MODE_WIFI_ALONE;
+	common->oper_mode = RSI_DEV_OPMODE_WIFI_ALONE;
+	adapter->device_model = RSI_DEV_9113;
+#ifdef CONFIG_RSI_COEX
+	if (common->coex_mode > 1) {
+		if (rsi_coex_attach(common)) {
+			rsi_dbg(ERR_ZONE, "Failed to init coex module\n");
+			goto err;
+		}
+	}
+#endif
+
 	return adapter;
 
 err:
@@ -294,6 +325,11 @@ void rsi_91x_deinit(struct rsi_hw *adapter)
 
 	common->init_done = false;
 
+#ifdef CONFIG_RSI_COEX
+	if (common->coex_mode > 1)
+		rsi_coex_detach(common);
+#endif
+
 	kfree(common);
 	kfree(adapter->rsi_dev);
 	kfree(adapter);
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 46c9d54..c21fca7 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1791,7 +1791,7 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 	return -EINVAL;
 }
 
-static int rsi_handle_card_ready(struct rsi_common *common, u8 *msg)
+int rsi_handle_card_ready(struct rsi_common *common, u8 *msg)
 {
 	switch (common->fsm_state) {
 	case FSM_CARD_NOT_READY:
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index b0cf411..ba38c6d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include "rsi_sdio.h"
 #include "rsi_common.h"
+#include "rsi_coex.h"
 #include "rsi_hal.h"
 
 /**
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 9ab86fb..b33a05f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -16,8 +16,10 @@
  */
 
 #include <linux/module.h>
+#include <net/rsi_91x.h>
 #include "rsi_usb.h"
 #include "rsi_hal.h"
+#include "rsi_coex.h"
 
 /**
  * rsi_usb_card_write() - This function writes to the USB Card.
diff --git a/drivers/net/wireless/rsi/rsi_coex.h b/drivers/net/wireless/rsi/rsi_coex.h
new file mode 100644
index 0000000..0fdc67f
--- /dev/null
+++ b/drivers/net/wireless/rsi/rsi_coex.h
@@ -0,0 +1,37 @@
+/**
+ * Copyright (c) 2018 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __RSI_COEX_H__
+#define __RSI_COEX_H__
+
+#include "rsi_common.h"
+
+#ifdef CONFIG_RSI_COEX
+#define COMMON_CARD_READY_IND           0
+#define NUM_COEX_TX_QUEUES              5
+
+struct rsi_coex_ctrl_block {
+	struct rsi_common *priv;
+	struct sk_buff_head coex_tx_qs[NUM_COEX_TX_QUEUES];
+	struct rsi_thread coex_tx_thread;
+};
+
+int rsi_coex_attach(struct rsi_common *common);
+void rsi_coex_detach(struct rsi_common *common);
+int rsi_coex_send_pkt(void *priv, struct sk_buff *skb, u8 proto_type);
+int rsi_coex_recv_pkt(struct rsi_common *common, u8 *msg);
+#endif
+#endif
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index b0f4e2c..99a00a3 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -206,6 +206,7 @@ struct rsi_common {
 	struct rsi_hw *priv;
 	struct vif_priv vif_info[RSI_MAX_VIFS];
 
+	void *coex_cb;
 	bool mgmt_q_block;
 	struct version_info lmac_ver;
 
@@ -270,6 +271,8 @@ struct rsi_common {
 	u8 obm_ant_sel_val;
 	int tx_power;
 	u8 ant_in_use;
+	/* Mutex used for writing packet to bus */
+	struct mutex tx_bus_mutex;
 	bool hibernate_resume;
 	bool reinit_hw;
 	u8 wow_flags;
@@ -359,4 +362,7 @@ struct rsi_host_intf_ops {
 				      u8 *fw);
 	int (*reinit_device)(struct rsi_hw *adapter);
 };
+
+enum rsi_host_intf rsi_get_host_intf(void *priv);
+
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 389094a..cf6567a 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -57,12 +57,14 @@
 #define WOW_PATTERN_SIZE 256
 
 /* Receive Frame Types */
+#define RSI_RX_DESC_MSG_TYPE_OFFSET	2
 #define TA_CONFIRM_TYPE                 0x01
 #define RX_DOT11_MGMT                   0x02
 #define TX_STATUS_IND                   0x04
 #define BEACON_EVENT_IND		0x08
 #define PROBEREQ_CONFIRM                2
 #define CARD_READY_IND                  0x00
+#define SLEEP_NOTIFY_IND                0x06
 
 #define RSI_DELETE_PEER                 0x0
 #define RSI_ADD_PEER                    0x1
@@ -638,6 +640,7 @@ static inline void rsi_set_len_qno(__le16 *addr, u16 len, u8 qno)
 	*addr = cpu_to_le16(len | ((qno & 7) << 12));
 }
 
+int rsi_handle_card_ready(struct rsi_common *common, u8 *msg);
 int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg);
 int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode,
 			     u8 *mac_addr, u8 vap_id, u8 vap_status);
diff --git a/include/net/rsi_91x.h b/include/net/rsi_91x.h
index 16a447b..737ab4e 100644
--- a/include/net/rsi_91x.h
+++ b/include/net/rsi_91x.h
@@ -17,6 +17,8 @@
 #ifndef __RSI_HEADER_H__
 #define __RSI_HEADER_H__
 
+#include <linux/skbuff.h>
+
 /* HAL queue information */
 #define RSI_COEX_Q			0x0
 #define RSI_BT_Q			0x2
@@ -26,9 +28,27 @@
 #define RSI_BT_MGMT_Q			0x6
 #define RSI_BT_DATA_Q			0x7
 
+enum rsi_coex_queues {
+	RSI_COEX_Q_INVALID = -1,
+	RSI_COEX_Q_COMMON = 0,
+	RSI_COEX_Q_BT,
+	RSI_COEX_Q_WLAN
+};
+
 enum rsi_host_intf {
 	RSI_HOST_INTF_SDIO = 0,
 	RSI_HOST_INTF_USB
 };
 
+struct rsi_proto_ops {
+	int (*coex_send_pkt)(void *priv, struct sk_buff *skb, u8 hal_queue);
+	enum rsi_host_intf (*get_host_intf)(void *priv);
+	void (*set_bt_context)(void *priv, void *context);
+};
+
+struct rsi_mod_ops {
+	int (*attach)(void *priv, struct rsi_proto_ops *ops);
+	void (*detach)(void *priv);
+	int (*recv_pkt)(void *priv, u8 *msg);
+};
 #endif
-- 
2.7.4
