Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:34997 "HELO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753446Ab2DSDPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 23:15:45 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: add support for Marvell USB8797 chipset
Date: Wed, 18 Apr 2012 20:08:28 -0700
Message-Id: <1334804908-10171-1-git-send-email-bzhao@marvell.com> (sfid-20120419_051558_328223_757AEE81)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This patch supports Avastar 88W8797 chipset with USB interface.

The corresponding firmware image file is located at:
"mrvl/usb8797_uapsta.bin"

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |   36 +-
 drivers/net/wireless/mwifiex/Kconfig    |   11 +
 drivers/net/wireless/mwifiex/Makefile   |    3 +
 drivers/net/wireless/mwifiex/cmdevt.c   |   63 ++-
 drivers/net/wireless/mwifiex/decl.h     |    1 +
 drivers/net/wireless/mwifiex/fw.h       |    5 +
 drivers/net/wireless/mwifiex/init.c     |   64 ++-
 drivers/net/wireless/mwifiex/main.c     |   26 +-
 drivers/net/wireless/mwifiex/main.h     |   20 +-
 drivers/net/wireless/mwifiex/sta_cmd.c  |    2 +-
 drivers/net/wireless/mwifiex/sta_rx.c   |   15 +-
 drivers/net/wireless/mwifiex/sta_tx.c   |   12 +-
 drivers/net/wireless/mwifiex/txrx.c     |   21 +-
 drivers/net/wireless/mwifiex/usb.c      | 1052 +++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/usb.h      |   99 +++
 drivers/net/wireless/mwifiex/util.c     |   22 +
 drivers/net/wireless/mwifiex/wmm.c      |   18 +-
 17 files changed, 1399 insertions(+), 71 deletions(-)
 create mode 100644 drivers/net/wireless/mwifiex/usb.c
 create mode 100644 drivers/net/wireless/mwifiex/usb.h

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 9eefb2a..ab84eb9 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -233,21 +233,27 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 
 	skb_push(skb_aggr, headroom);
 
-	/*
-	 * Padding per MSDU will affect the length of next
-	 * packet and hence the exact length of next packet
-	 * is uncertain here.
-	 *
-	 * Also, aggregation of transmission buffer, while
-	 * downloading the data to the card, wont gain much
-	 * on the AMSDU packets as the AMSDU packets utilizes
-	 * the transmission buffer space to the maximum
-	 * (adapter->tx_buf_size).
-	 */
-	tx_param.next_pkt_len = 0;
-
-	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
-					   skb_aggr, &tx_param);
+	if (adapter->iface_type == MWIFIEX_USB) {
+		adapter->data_sent = true;
+		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_USB_EP_DATA,
+						   skb_aggr, NULL);
+	} else {
+		/*
+		 * Padding per MSDU will affect the length of next
+		 * packet and hence the exact length of next packet
+		 * is uncertain here.
+		 *
+		 * Also, aggregation of transmission buffer, while
+		 * downloading the data to the card, wont gain much
+		 * on the AMSDU packets as the AMSDU packets utilizes
+		 * the transmission buffer space to the maximum
+		 * (adapter->tx_buf_size).
+		 */
+		tx_param.next_pkt_len = 0;
+
+		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
+						   skb_aggr, &tx_param);
+	}
 	switch (ret) {
 	case -EBUSY:
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
diff --git a/drivers/net/wireless/mwifiex/Kconfig b/drivers/net/wireless/mwifiex/Kconfig
index 2a078ce..7f91cc6 100644
--- a/drivers/net/wireless/mwifiex/Kconfig
+++ b/drivers/net/wireless/mwifiex/Kconfig
@@ -30,3 +30,14 @@ config MWIFIEX_PCIE
 
 	  If you choose to build it as a module, it will be called
 	  mwifiex_pcie.
+
+config MWIFIEX_USB
+	tristate "Marvell WiFi-Ex Driver for USB8797"
+	depends on MWIFIEX && USB
+	select FW_LOADER
+	---help---
+	  This adds support for wireless adapters based on Marvell
+	  Avastar 88W8797 chipset with USB interface.
+
+	  If you choose to build it as a module, it will be called
+	  mwifiex_usb.
diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
index b0257ad..5c1a46b 100644
--- a/drivers/net/wireless/mwifiex/Makefile
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -42,3 +42,6 @@ obj-$(CONFIG_MWIFIEX_SDIO) += mwifiex_sdio.o
 
 mwifiex_pcie-y += pcie.o
 obj-$(CONFIG_MWIFIEX_PCIE) += mwifiex_pcie.o
+
+mwifiex_usb-y += usb.o
+obj-$(CONFIG_MWIFIEX_USB) += mwifiex_usb.o
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 07f6e00..1710bef 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -139,6 +139,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	uint16_t cmd_size;
 	struct timeval tstamp;
 	unsigned long flags;
+	__le32 tmp;
 
 	if (!adapter || !cmd_node)
 		return -1;
@@ -178,15 +179,28 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 		le16_to_cpu(*(__le16 *) ((u8 *) host_cmd + S_DS_GEN)), cmd_size,
 		le16_to_cpu(host_cmd->seq_num));
 
-	skb_push(cmd_node->cmd_skb, INTF_HEADER_LEN);
-
-	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_CMD,
-					   cmd_node->cmd_skb, NULL);
-
-	skb_pull(cmd_node->cmd_skb, INTF_HEADER_LEN);
+	if (adapter->iface_type == MWIFIEX_USB) {
+		tmp = cpu_to_le32(MWIFIEX_USB_TYPE_CMD);
+		skb_push(cmd_node->cmd_skb, MWIFIEX_TYPE_LEN);
+		memcpy(cmd_node->cmd_skb->data, &tmp, MWIFIEX_TYPE_LEN);
+		adapter->cmd_sent = true;
+		ret = adapter->if_ops.host_to_card(adapter,
+						   MWIFIEX_USB_EP_CMD_EVENT,
+						   cmd_node->cmd_skb, NULL);
+		skb_pull(cmd_node->cmd_skb, MWIFIEX_TYPE_LEN);
+		if (ret == -EBUSY)
+			cmd_node->cmd_skb = NULL;
+	} else {
+		skb_push(cmd_node->cmd_skb, INTF_HEADER_LEN);
+		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_CMD,
+						   cmd_node->cmd_skb, NULL);
+		skb_pull(cmd_node->cmd_skb, INTF_HEADER_LEN);
+	}
 
 	if (ret == -1) {
 		dev_err(adapter->dev, "DNLD_CMD: host to card failed\n");
+		if (adapter->iface_type == MWIFIEX_USB)
+			adapter->cmd_sent = false;
 		if (cmd_node->wait_q_enabled)
 			adapter->cmd_wait_q.status = -1;
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
@@ -232,6 +246,9 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 	struct mwifiex_opt_sleep_confirm *sleep_cfm_buf =
 				(struct mwifiex_opt_sleep_confirm *)
 						adapter->sleep_cfm->data;
+	struct sk_buff *sleep_cfm_tmp;
+	__le32 tmp;
+
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
 	sleep_cfm_buf->seq_num =
@@ -240,10 +257,28 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 					 priv->bss_type)));
 	adapter->seq_num++;
 
-	skb_push(adapter->sleep_cfm, INTF_HEADER_LEN);
-	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_CMD,
-					   adapter->sleep_cfm, NULL);
-	skb_pull(adapter->sleep_cfm, INTF_HEADER_LEN);
+	if (adapter->iface_type == MWIFIEX_USB) {
+		sleep_cfm_tmp =
+			dev_alloc_skb(sizeof(struct mwifiex_opt_sleep_confirm)
+				      + MWIFIEX_TYPE_LEN);
+		skb_put(sleep_cfm_tmp, sizeof(struct mwifiex_opt_sleep_confirm)
+			+ MWIFIEX_TYPE_LEN);
+		tmp = cpu_to_le32(MWIFIEX_USB_TYPE_CMD);
+		memcpy(sleep_cfm_tmp->data, &tmp, MWIFIEX_TYPE_LEN);
+		memcpy(sleep_cfm_tmp->data + MWIFIEX_TYPE_LEN,
+		       adapter->sleep_cfm->data,
+		       sizeof(struct mwifiex_opt_sleep_confirm));
+		ret = adapter->if_ops.host_to_card(adapter,
+						   MWIFIEX_USB_EP_CMD_EVENT,
+						   sleep_cfm_tmp, NULL);
+		if (ret != -EBUSY)
+			dev_kfree_skb_any(sleep_cfm_tmp);
+	} else {
+		skb_push(adapter->sleep_cfm, INTF_HEADER_LEN);
+		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_CMD,
+						   adapter->sleep_cfm, NULL);
+		skb_pull(adapter->sleep_cfm, INTF_HEADER_LEN);
+	}
 
 	if (ret == -1) {
 		dev_err(adapter->dev, "SLEEP_CFM: failed\n");
@@ -343,7 +378,12 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 		}
 		if (!cmd_array[i].resp_skb)
 			continue;
-		dev_kfree_skb_any(cmd_array[i].resp_skb);
+
+		if (adapter->iface_type == MWIFIEX_USB)
+			adapter->if_ops.cmdrsp_complete(adapter,
+							cmd_array[i].resp_skb);
+		else
+			dev_kfree_skb_any(cmd_array[i].resp_skb);
 	}
 	/* Release struct cmd_ctrl_node */
 	if (adapter->cmd_pool) {
@@ -1083,6 +1123,7 @@ mwifiex_process_hs_config(struct mwifiex_adapter *adapter)
 						    MWIFIEX_BSS_ROLE_ANY),
 				   false);
 }
+EXPORT_SYMBOL_GPL(mwifiex_process_hs_config);
 
 /*
  * This function handles the command response of a sleep confirm command.
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index be5fd16..d04aba4 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -53,6 +53,7 @@
 #define MWIFIEX_RATE_BITMAP_MCS127 159
 
 #define MWIFIEX_RX_DATA_BUF_SIZE     (4 * 1024)
+#define MWIFIEX_RX_CMD_BUF_SIZE	     (2 * 1024)
 
 #define MWIFIEX_RTS_MIN_VALUE              (0)
 #define MWIFIEX_RTS_MAX_VALUE              (2347)
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 6b15449..2a2caba 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -81,6 +81,11 @@ enum KEY_TYPE_ID {
 #define FIRMWARE_READY_SDIO				0xfedc
 #define FIRMWARE_READY_PCIE				0xfedcba00
 
+enum mwifiex_usb_ep {
+	MWIFIEX_USB_EP_CMD_EVENT = 1,
+	MWIFIEX_USB_EP_DATA = 2,
+};
+
 enum MWIFIEX_802_11_PRIVACY_FILTER {
 	MWIFIEX_802_11_PRIV_FILTER_ACCEPT_ALL,
 	MWIFIEX_802_11_PRIV_FILTER_8021X_WEP
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 0d55c5b..d440c3e 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -188,10 +188,10 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 
 	adapter->cmd_sent = false;
 
-	if (adapter->iface_type == MWIFIEX_PCIE)
-		adapter->data_sent = false;
-	else
+	if (adapter->iface_type == MWIFIEX_SDIO)
 		adapter->data_sent = true;
+	else
+		adapter->data_sent = false;
 
 	adapter->cmd_resp_received = false;
 	adapter->event_received = false;
@@ -379,7 +379,8 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 
 	dev_dbg(adapter->dev, "info: free scan table\n");
 
-	adapter->if_ops.cleanup_if(adapter);
+	if (adapter->if_ops.cleanup_if)
+		adapter->if_ops.cleanup_if(adapter);
 
 	if (adapter->sleep_cfm)
 		dev_kfree_skb_any(adapter->sleep_cfm);
@@ -419,6 +420,8 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 	spin_lock_init(&adapter->cmd_pending_q_lock);
 	spin_lock_init(&adapter->scan_pending_q_lock);
 
+	skb_queue_head_init(&adapter->usb_rx_data_q);
+
 	for (i = 0; i < adapter->priv_num; ++i) {
 		INIT_LIST_HEAD(&adapter->bss_prio_tbl[i].bss_prio_head);
 		adapter->bss_prio_tbl[i].bss_prio_cur = NULL;
@@ -574,6 +577,7 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 	struct mwifiex_private *priv;
 	s32 i;
 	unsigned long flags;
+	struct sk_buff *skb;
 
 	/* mwifiex already shutdown */
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY)
@@ -601,6 +605,18 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 
 	spin_lock_irqsave(&adapter->mwifiex_lock, flags);
 
+	if (adapter->if_ops.data_complete) {
+		while ((skb = skb_dequeue(&adapter->usb_rx_data_q))) {
+			struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
+
+			priv = adapter->priv[rx_info->bss_num];
+			if (priv)
+				priv->stats.rx_dropped++;
+
+			adapter->if_ops.data_complete(adapter, skb);
+		}
+	}
+
 	/* Free adapter structure */
 	mwifiex_free_adapter(adapter);
 
@@ -630,24 +646,28 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 	int ret;
 	u32 poll_num = 1;
 
-	adapter->winner = 0;
+	if (adapter->if_ops.check_fw_status) {
+		adapter->winner = 0;
 
-	/* Check if firmware is already running */
-	ret = adapter->if_ops.check_fw_status(adapter, poll_num);
-	if (!ret) {
-		dev_notice(adapter->dev,
-			   "WLAN FW already running! Skip FW download\n");
-		goto done;
-	}
-	poll_num = MAX_FIRMWARE_POLL_TRIES;
-
-	/* Check if we are the winner for downloading FW */
-	if (!adapter->winner) {
-		dev_notice(adapter->dev,
-			   "Other intf already running! Skip FW download\n");
-		poll_num = MAX_MULTI_INTERFACE_POLL_TRIES;
-		goto poll_fw;
+		/* check if firmware is already running */
+		ret = adapter->if_ops.check_fw_status(adapter, poll_num);
+		if (!ret) {
+			dev_notice(adapter->dev,
+				   "WLAN FW already running! Skip FW dnld\n");
+			goto done;
+		}
+
+		poll_num = MAX_FIRMWARE_POLL_TRIES;
+
+		/* check if we are the winner for downloading FW */
+		if (!adapter->winner) {
+			dev_notice(adapter->dev,
+				   "FW already running! Skip FW dnld\n");
+			poll_num = MAX_MULTI_INTERFACE_POLL_TRIES;
+			goto poll_fw;
+		}
 	}
+
 	if (pmfw) {
 		/* Download firmware with helper */
 		ret = adapter->if_ops.prog_fw(adapter, pmfw);
@@ -666,6 +686,8 @@ poll_fw:
 	}
 done:
 	/* re-enable host interrupt for mwifiex after fw dnld is successful */
-	adapter->if_ops.enable_int(adapter);
+	if (adapter->if_ops.enable_int)
+		adapter->if_ops.enable_int(adapter);
+
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 245b732..be0f0e5 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -58,8 +58,9 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 	memmove(&adapter->if_ops, if_ops, sizeof(struct mwifiex_if_ops));
 
 	/* card specific initialization has been deferred until now .. */
-	if (adapter->if_ops.init_if(adapter))
-		goto error;
+	if (adapter->if_ops.init_if)
+		if (adapter->if_ops.init_if(adapter))
+			goto error;
 
 	adapter->priv_num = 0;
 
@@ -140,6 +141,7 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 {
 	int ret = 0;
 	unsigned long flags;
+	struct sk_buff *skb;
 
 	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 
@@ -161,7 +163,8 @@ process_start:
 		if (adapter->int_status) {
 			if (adapter->hs_activated)
 				mwifiex_process_hs_config(adapter);
-			adapter->if_ops.process_int_status(adapter);
+			if (adapter->if_ops.process_int_status)
+				adapter->if_ops.process_int_status(adapter);
 		}
 
 		/* Need to wake up the card ? */
@@ -174,6 +177,7 @@ process_start:
 			adapter->if_ops.wakeup(adapter);
 			continue;
 		}
+
 		if (IS_CARD_RX_RCVD(adapter)) {
 			adapter->pm_wakeup_fw_try = false;
 			if (adapter->ps_state == PS_STATE_SLEEP)
@@ -194,6 +198,11 @@ process_start:
 			}
 		}
 
+		/* Check Rx data for USB */
+		if (adapter->iface_type == MWIFIEX_USB)
+			while ((skb = skb_dequeue(&adapter->usb_rx_data_q)))
+				mwifiex_handle_rx_packet(adapter, skb);
+
 		/* Check for Cmd Resp */
 		if (adapter->cmd_resp_received) {
 			adapter->cmd_resp_received = false;
@@ -317,7 +326,10 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	fw.fw_buf = (u8 *) adapter->firmware->data;
 	fw.fw_len = adapter->firmware->size;
 
-	ret = mwifiex_dnld_fw(adapter, &fw);
+	if (adapter->if_ops.dnld_fw)
+		ret = adapter->if_ops.dnld_fw(adapter, &fw);
+	else
+		ret = mwifiex_dnld_fw(adapter, &fw);
 	if (ret == -1)
 		goto done;
 
@@ -731,7 +743,8 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 
 err_init_fw:
 	pr_debug("info: %s: unregister device\n", __func__);
-	adapter->if_ops.unregister_dev(adapter);
+	if (adapter->if_ops.unregister_dev)
+		adapter->if_ops.unregister_dev(adapter);
 err_registerdev:
 	adapter->surprise_removed = true;
 	mwifiex_terminate_workqueue(adapter);
@@ -836,7 +849,8 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 
 	/* Unregister device */
 	dev_dbg(adapter->dev, "info: unregister device\n");
-	adapter->if_ops.unregister_dev(adapter);
+	if (adapter->if_ops.unregister_dev)
+		adapter->if_ops.unregister_dev(adapter);
 	/* Free adapter structure */
 	dev_dbg(adapter->dev, "info: free adapter\n");
 	mwifiex_free_adapter(adapter);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index a4000f9..324ad39 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -92,9 +92,16 @@ enum {
 #define MWIFIEX_OUI_NOT_PRESENT			0
 #define MWIFIEX_OUI_PRESENT				1
 
+/*
+ * Do not check for data_received for USB, as data_received
+ * is handled in mwifiex_usb_recv for USB
+ */
 #define IS_CARD_RX_RCVD(adapter) (adapter->cmd_resp_received || \
-					adapter->event_received || \
-					adapter->data_received)
+				adapter->event_received || \
+				((adapter->iface_type != MWIFIEX_USB) && \
+				adapter->data_received) || \
+				((adapter->iface_type == MWIFIEX_USB) && \
+				!skb_queue_empty(&adapter->usb_rx_data_q)))
 
 #define MWIFIEX_TYPE_CMD				1
 #define MWIFIEX_TYPE_DATA				0
@@ -110,6 +117,11 @@ enum {
 
 #define MWIFIEX_EVENT_HEADER_LEN           4
 
+#define MWIFIEX_TYPE_LEN			4
+#define MWIFIEX_USB_TYPE_CMD			0xF00DFACE
+#define MWIFIEX_USB_TYPE_DATA			0xBEADC0DE
+#define MWIFIEX_USB_TYPE_EVENT			0xBEEFFACE
+
 struct mwifiex_dbg {
 	u32 num_cmd_host_to_card_failure;
 	u32 num_cmd_sleep_cfm_host_to_card_failure;
@@ -162,6 +174,7 @@ enum MWIFIEX_PS_STATE {
 enum mwifiex_iface_type {
 	MWIFIEX_SDIO,
 	MWIFIEX_PCIE,
+	MWIFIEX_USB
 };
 
 struct mwifiex_add_ba_param {
@@ -546,6 +559,8 @@ struct mwifiex_if_ops {
 	void (*cleanup_mpa_buf) (struct mwifiex_adapter *);
 	int (*cmdrsp_complete) (struct mwifiex_adapter *, struct sk_buff *);
 	int (*event_complete) (struct mwifiex_adapter *, struct sk_buff *);
+	int (*data_complete) (struct mwifiex_adapter *, struct sk_buff *);
+	int (*dnld_fw) (struct mwifiex_adapter *, struct mwifiex_fw_image *);
 };
 
 struct mwifiex_adapter {
@@ -608,6 +623,7 @@ struct mwifiex_adapter {
 	struct list_head scan_pending_q;
 	/* spin lock for scan_pending_q */
 	spinlock_t scan_pending_q_lock;
+	struct sk_buff_head usb_rx_data_q;
 	u32 scan_processing;
 	u16 region_code;
 	struct mwifiex_802_11d_domain_reg domain_reg;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 1f71105..87ed2a1 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1293,7 +1293,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	if (ret)
 		return -1;
 
-	if (first_sta) {
+	if (first_sta && (priv->adapter->iface_type != MWIFIEX_USB)) {
 		/* Enable auto deep sleep */
 		auto_ds.auto_ds = DEEP_SLEEP_ON;
 		auto_ds.idle_time = DEEP_SLEEP_IDLE_TIME;
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 750b695..02ce3b7 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -145,7 +145,12 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 			" rx_pkt_offset=%d, rx_pkt_length=%d\n", skb->len,
 		       local_rx_pd->rx_pkt_offset, local_rx_pd->rx_pkt_length);
 		priv->stats.rx_dropped++;
-		dev_kfree_skb_any(skb);
+
+		if (adapter->if_ops.data_complete)
+			adapter->if_ops.data_complete(adapter, skb);
+		else
+			dev_kfree_skb_any(skb);
+
 		return ret;
 	}
 
@@ -196,8 +201,12 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 					     (u8) local_rx_pd->rx_pkt_type,
 					     skb);
 
-	if (ret || (rx_pkt_type == PKT_TYPE_BAR))
-		dev_kfree_skb_any(skb);
+	if (ret || (rx_pkt_type == PKT_TYPE_BAR)) {
+		if (adapter->if_ops.data_complete)
+			adapter->if_ops.data_complete(adapter, skb);
+		else
+			dev_kfree_skb_any(skb);
+	}
 
 	if (ret)
 		priv->stats.rx_dropped++;
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 7af534f..0a046d3 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -149,10 +149,14 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	local_tx_pd->bss_num = priv->bss_num;
 	local_tx_pd->bss_type = priv->bss_type;
 
-	skb_push(skb, INTF_HEADER_LEN);
-
-	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
-					   skb, NULL);
+	if (adapter->iface_type == MWIFIEX_USB) {
+		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_USB_EP_DATA,
+						   skb, NULL);
+	} else {
+		skb_push(skb, INTF_HEADER_LEN);
+		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
+						   skb, NULL);
+	}
 	switch (ret) {
 	case -EBUSY:
 		adapter->data_sent = true;
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index d2af8cb..e2faec4 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -77,12 +77,23 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
 			local_tx_pd =
 				(struct txpd *) (head_ptr + INTF_HEADER_LEN);
-
-		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
-						   skb, tx_param);
+		if (adapter->iface_type == MWIFIEX_USB) {
+			adapter->data_sent = true;
+			skb_pull(skb, INTF_HEADER_LEN);
+			ret = adapter->if_ops.host_to_card(adapter,
+							   MWIFIEX_USB_EP_DATA,
+							   skb, NULL);
+		} else {
+			ret = adapter->if_ops.host_to_card(adapter,
+							   MWIFIEX_TYPE_DATA,
+							   skb, tx_param);
+		}
 	}
 
 	switch (ret) {
+	case -ENOSR:
+		dev_err(adapter->dev, "data: -ENOSR is returned\n");
+		break;
 	case -EBUSY:
 		if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
 		    (adapter->pps_uapsd_mode) && (adapter->tx_lock_flag)) {
@@ -135,6 +146,9 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 	if (!priv)
 		goto done;
 
+	if (adapter->iface_type == MWIFIEX_USB)
+		adapter->data_sent = false;
+
 	mwifiex_set_trans_start(priv->netdev);
 	if (!status) {
 		priv->stats.tx_packets++;
@@ -162,4 +176,5 @@ done:
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mwifiex_write_data_complete);
 
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
new file mode 100644
index 0000000..49ebf20
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -0,0 +1,1052 @@
+/*
+ * Marvell Wireless LAN device driver: USB specific handling
+ *
+ * Copyright (C) 2012, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "main.h"
+#include "usb.h"
+
+#define USB_VERSION	"1.0"
+
+static const char usbdriver_name[] = "usb8797";
+
+static u8 user_rmmod;
+static struct mwifiex_if_ops usb_ops;
+static struct semaphore add_remove_card_sem;
+
+static struct usb_device_id mwifiex_usb_table[] = {
+	{USB_DEVICE(USB8797_VID, USB8797_PID_1)},
+	{USB_DEVICE_AND_INTERFACE_INFO(USB8797_VID, USB8797_PID_2,
+				       USB_CLASS_VENDOR_SPEC,
+				       USB_SUBCLASS_VENDOR_SPEC, 0xff)},
+	{ }	/* Terminating entry */
+};
+
+MODULE_DEVICE_TABLE(usb, mwifiex_usb_table);
+
+static int mwifiex_usb_submit_rx_urb(struct urb_context *ctx, int size);
+
+/* This function handles received packet. Necessary action is taken based on
+ * cmd/event/data.
+ */
+static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
+			    struct sk_buff *skb, u8 ep)
+{
+	struct device *dev = adapter->dev;
+	u32 recv_type;
+	__le32 tmp;
+
+	if (adapter->hs_activated)
+		mwifiex_process_hs_config(adapter);
+
+	if (skb->len < INTF_HEADER_LEN) {
+		dev_err(dev, "%s: invalid skb->len\n", __func__);
+		return -1;
+	}
+
+	switch (ep) {
+	case MWIFIEX_USB_EP_CMD_EVENT:
+		dev_dbg(dev, "%s: EP_CMD_EVENT\n", __func__);
+		skb_copy_from_linear_data(skb, &tmp, INTF_HEADER_LEN);
+		recv_type = le32_to_cpu(tmp);
+		skb_pull(skb, INTF_HEADER_LEN);
+
+		switch (recv_type) {
+		case MWIFIEX_USB_TYPE_CMD:
+			if (skb->len > MWIFIEX_SIZE_OF_CMD_BUFFER) {
+				dev_err(dev, "CMD: skb->len too large\n");
+				return -1;
+			} else if (!adapter->curr_cmd) {
+				dev_dbg(dev, "CMD: no curr_cmd\n");
+				if (adapter->ps_state == PS_STATE_SLEEP_CFM) {
+					mwifiex_process_sleep_confirm_resp(
+							adapter, skb->data,
+							skb->len);
+					return 0;
+				}
+				return -1;
+			}
+
+			adapter->curr_cmd->resp_skb = skb;
+			adapter->cmd_resp_received = true;
+			break;
+		case MWIFIEX_USB_TYPE_EVENT:
+			if (skb->len < sizeof(u32)) {
+				dev_err(dev, "EVENT: skb->len too small\n");
+				return -1;
+			}
+			skb_copy_from_linear_data(skb, &tmp, sizeof(u32));
+			adapter->event_cause = le32_to_cpu(tmp);
+			skb_pull(skb, sizeof(u32));
+			dev_dbg(dev, "event_cause %#x\n", adapter->event_cause);
+
+			if (skb->len > MAX_EVENT_SIZE) {
+				dev_err(dev, "EVENT: event body too large\n");
+				return -1;
+			}
+
+			skb_copy_from_linear_data(skb, adapter->event_body,
+						  skb->len);
+			adapter->event_received = true;
+			adapter->event_skb = skb;
+			break;
+		default:
+			dev_err(dev, "unknown recv_type %#x\n", recv_type);
+			return -1;
+		}
+		break;
+	case MWIFIEX_USB_EP_DATA:
+		dev_dbg(dev, "%s: EP_DATA\n", __func__);
+		if (skb->len > MWIFIEX_RX_DATA_BUF_SIZE) {
+			dev_err(dev, "DATA: skb->len too large\n");
+			return -1;
+		}
+		skb_queue_tail(&adapter->usb_rx_data_q, skb);
+		adapter->data_received = true;
+		break;
+	default:
+		dev_err(dev, "%s: unknown endport %#x\n", __func__, ep);
+		return -1;
+	}
+
+	return -EINPROGRESS;
+}
+
+static void mwifiex_usb_rx_complete(struct urb *urb)
+{
+	struct urb_context *context = (struct urb_context *)urb->context;
+	struct mwifiex_adapter *adapter = context->adapter;
+	struct sk_buff *skb = context->skb;
+	struct usb_card_rec *card;
+	int recv_length = urb->actual_length;
+	int size, status;
+
+	if (!adapter || !adapter->card) {
+		pr_err("mwifiex adapter or card structure is not valid\n");
+		return;
+	}
+
+	card = (struct usb_card_rec *)adapter->card;
+	if (card->rx_cmd_ep == context->ep)
+		atomic_dec(&card->rx_cmd_urb_pending);
+	else
+		atomic_dec(&card->rx_data_urb_pending);
+
+	if (recv_length) {
+		if (urb->status || (adapter->surprise_removed)) {
+			dev_err(adapter->dev,
+				"URB status is failed: %d\n", urb->status);
+			/* Do not free skb in case of command ep */
+			if (card->rx_cmd_ep != context->ep)
+				dev_kfree_skb_any(skb);
+			goto setup_for_next;
+		}
+		if (skb->len > recv_length)
+			skb_trim(skb, recv_length);
+		else
+			skb_put(skb, recv_length - skb->len);
+
+		atomic_inc(&adapter->rx_pending);
+		status = mwifiex_usb_recv(adapter, skb, context->ep);
+
+		dev_dbg(adapter->dev, "info: recv_length=%d, status=%d\n",
+			recv_length, status);
+		if (status == -EINPROGRESS) {
+			queue_work(adapter->workqueue, &adapter->main_work);
+
+			/* urb for data_ep is re-submitted now;
+			 * urb for cmd_ep will be re-submitted in callback
+			 * mwifiex_usb_recv_complete
+			 */
+			if (card->rx_cmd_ep == context->ep)
+				return;
+		} else {
+			atomic_dec(&adapter->rx_pending);
+			if (status == -1)
+				dev_err(adapter->dev,
+					"received data processing failed!\n");
+
+			/* Do not free skb in case of command ep */
+			if (card->rx_cmd_ep != context->ep)
+				dev_kfree_skb_any(skb);
+		}
+	} else if (urb->status) {
+		if (!adapter->is_suspended) {
+			dev_warn(adapter->dev,
+				 "Card is removed: %d\n", urb->status);
+			adapter->surprise_removed = true;
+		}
+		dev_kfree_skb_any(skb);
+		return;
+	} else {
+		/* Do not free skb in case of command ep */
+		if (card->rx_cmd_ep != context->ep)
+			dev_kfree_skb_any(skb);
+
+		/* fall through setup_for_next */
+	}
+
+setup_for_next:
+	if (card->rx_cmd_ep == context->ep)
+		size = MWIFIEX_RX_CMD_BUF_SIZE;
+	else
+		size = MWIFIEX_RX_DATA_BUF_SIZE;
+
+	mwifiex_usb_submit_rx_urb(context, size);
+
+	return;
+}
+
+static void mwifiex_usb_tx_complete(struct urb *urb)
+{
+	struct urb_context *context = (struct urb_context *)(urb->context);
+	struct mwifiex_adapter *adapter = context->adapter;
+	struct usb_card_rec *card = adapter->card;
+
+	dev_dbg(adapter->dev, "%s: status: %d\n", __func__, urb->status);
+
+	if (context->ep == card->tx_cmd_ep) {
+		dev_dbg(adapter->dev, "%s: CMD\n", __func__);
+		atomic_dec(&card->tx_cmd_urb_pending);
+		adapter->cmd_sent = false;
+	} else {
+		dev_dbg(adapter->dev, "%s: DATA\n", __func__);
+		atomic_dec(&card->tx_data_urb_pending);
+		mwifiex_write_data_complete(adapter, context->skb,
+					    urb->status ? -1 : 0);
+	}
+
+	queue_work(adapter->workqueue, &adapter->main_work);
+
+	return;
+}
+
+static int mwifiex_usb_submit_rx_urb(struct urb_context *ctx, int size)
+{
+	struct mwifiex_adapter *adapter = ctx->adapter;
+	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
+
+	if (card->rx_cmd_ep != ctx->ep) {
+		ctx->skb = dev_alloc_skb(size);
+		if (!ctx->skb) {
+			dev_err(adapter->dev,
+				"%s: dev_alloc_skb failed\n", __func__);
+			return -ENOMEM;
+		}
+	}
+
+	usb_fill_bulk_urb(ctx->urb, card->udev,
+			  usb_rcvbulkpipe(card->udev, ctx->ep), ctx->skb->data,
+			  size, mwifiex_usb_rx_complete, (void *)ctx);
+
+	if (card->rx_cmd_ep == ctx->ep)
+		atomic_inc(&card->rx_cmd_urb_pending);
+	else
+		atomic_inc(&card->rx_data_urb_pending);
+
+	if (usb_submit_urb(ctx->urb, GFP_ATOMIC)) {
+		dev_err(adapter->dev, "usb_submit_urb failed\n");
+		dev_kfree_skb_any(ctx->skb);
+		ctx->skb = NULL;
+
+		if (card->rx_cmd_ep == ctx->ep)
+			atomic_dec(&card->rx_cmd_urb_pending);
+		else
+			atomic_dec(&card->rx_data_urb_pending);
+
+		return -1;
+	}
+
+	return 0;
+}
+
+static void mwifiex_usb_free(struct usb_card_rec *card)
+{
+	int i;
+
+	if (atomic_read(&card->rx_cmd_urb_pending) && card->rx_cmd.urb)
+		usb_kill_urb(card->rx_cmd.urb);
+
+	usb_free_urb(card->rx_cmd.urb);
+	card->rx_cmd.urb = NULL;
+
+	if (atomic_read(&card->rx_data_urb_pending))
+		for (i = 0; i < MWIFIEX_RX_DATA_URB; i++)
+			if (card->rx_data_list[i].urb)
+				usb_kill_urb(card->rx_data_list[i].urb);
+
+	for (i = 0; i < MWIFIEX_RX_DATA_URB; i++) {
+		usb_free_urb(card->rx_data_list[i].urb);
+		card->rx_data_list[i].urb = NULL;
+	}
+
+	for (i = 0; i < MWIFIEX_TX_DATA_URB; i++) {
+		usb_free_urb(card->tx_data_list[i].urb);
+		card->tx_data_list[i].urb = NULL;
+	}
+
+	usb_free_urb(card->tx_cmd.urb);
+	card->tx_cmd.urb = NULL;
+
+	return;
+}
+
+/* This function probes an mwifiex device and registers it. It allocates
+ * the card structure, initiates the device registration and initialization
+ * procedure by adding a logical interface.
+ */
+static int mwifiex_usb_probe(struct usb_interface *intf,
+			     const struct usb_device_id *id)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct usb_host_interface *iface_desc = intf->cur_altsetting;
+	struct usb_endpoint_descriptor *epd;
+	int ret, i;
+	struct usb_card_rec *card;
+	u16 id_vendor, id_product, bcd_device, bcd_usb;
+
+	card = kzalloc(sizeof(struct usb_card_rec), GFP_KERNEL);
+	if (!card)
+		return -ENOMEM;
+
+	id_vendor = le16_to_cpu(udev->descriptor.idVendor);
+	id_product = le16_to_cpu(udev->descriptor.idProduct);
+	bcd_device = le16_to_cpu(udev->descriptor.bcdDevice);
+	bcd_usb = le16_to_cpu(udev->descriptor.bcdUSB);
+	pr_debug("info: VID/PID = %X/%X, Boot2 version = %X\n",
+		 id_vendor, id_product, bcd_device);
+
+	/* PID_1 is used for firmware downloading only */
+	if (id_product == USB8797_PID_1)
+		card->usb_boot_state = USB8797_FW_DNLD;
+	else
+		card->usb_boot_state = USB8797_FW_READY;
+
+	card->udev = udev;
+	card->intf = intf;
+
+	pr_debug("info: bcdUSB=%#x Device Class=%#x SubClass=%#x Protocl=%#x\n",
+		 udev->descriptor.bcdUSB, udev->descriptor.bDeviceClass,
+		 udev->descriptor.bDeviceSubClass,
+		 udev->descriptor.bDeviceProtocol);
+
+	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
+		epd = &iface_desc->endpoint[i].desc;
+		if (usb_endpoint_dir_in(epd) &&
+		    usb_endpoint_num(epd) == MWIFIEX_USB_EP_CMD_EVENT &&
+		    usb_endpoint_xfer_bulk(epd)) {
+			pr_debug("info: bulk IN: max pkt size: %d, addr: %d\n",
+				 le16_to_cpu(epd->wMaxPacketSize),
+				 epd->bEndpointAddress);
+			card->rx_cmd_ep = usb_endpoint_num(epd);
+			atomic_set(&card->rx_cmd_urb_pending, 0);
+		}
+		if (usb_endpoint_dir_in(epd) &&
+		    usb_endpoint_num(epd) == MWIFIEX_USB_EP_DATA &&
+		    usb_endpoint_xfer_bulk(epd)) {
+			pr_debug("info: bulk IN: max pkt size: %d, addr: %d\n",
+				 le16_to_cpu(epd->wMaxPacketSize),
+				 epd->bEndpointAddress);
+			card->rx_data_ep = usb_endpoint_num(epd);
+			atomic_set(&card->rx_data_urb_pending, 0);
+		}
+		if (usb_endpoint_dir_out(epd) &&
+		    usb_endpoint_num(epd) == MWIFIEX_USB_EP_DATA &&
+		    usb_endpoint_xfer_bulk(epd)) {
+			pr_debug("info: bulk OUT: max pkt size: %d, addr: %d\n",
+				 le16_to_cpu(epd->wMaxPacketSize),
+				 epd->bEndpointAddress);
+			card->tx_data_ep = usb_endpoint_num(epd);
+			atomic_set(&card->tx_data_urb_pending, 0);
+		}
+		if (usb_endpoint_dir_out(epd) &&
+		    usb_endpoint_num(epd) == MWIFIEX_USB_EP_CMD_EVENT &&
+		    usb_endpoint_xfer_bulk(epd)) {
+			pr_debug("info: bulk OUT: max pkt size: %d, addr: %d\n",
+				 le16_to_cpu(epd->wMaxPacketSize),
+				 epd->bEndpointAddress);
+			card->tx_cmd_ep = usb_endpoint_num(epd);
+			atomic_set(&card->tx_cmd_urb_pending, 0);
+			card->bulk_out_maxpktsize =
+					le16_to_cpu(epd->wMaxPacketSize);
+		}
+	}
+
+	usb_set_intfdata(intf, card);
+
+	ret = mwifiex_add_card(card, &add_remove_card_sem, &usb_ops,
+			       MWIFIEX_USB);
+	if (ret) {
+		pr_err("%s: mwifiex_add_card failed: %d\n", __func__, ret);
+		usb_reset_device(udev);
+		kfree(card);
+		return ret;
+	}
+
+	usb_get_dev(udev);
+
+	return 0;
+}
+
+/* Kernel needs to suspend all functions separately. Therefore all
+ * registered functions must have drivers with suspend and resume
+ * methods. Failing that the kernel simply removes the whole card.
+ *
+ * If already not suspended, this function allocates and sends a
+ * 'host sleep activate' request to the firmware and turns off the traffic.
+ */
+static int mwifiex_usb_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct usb_card_rec *card = usb_get_intfdata(intf);
+	struct mwifiex_adapter *adapter;
+	int i;
+
+	if (!card || !card->adapter) {
+		pr_err("%s: card or card->adapter is NULL\n", __func__);
+		return 0;
+	}
+	adapter = card->adapter;
+
+	if (unlikely(adapter->is_suspended))
+		dev_warn(adapter->dev, "Device already suspended\n");
+
+	mwifiex_enable_hs(adapter);
+
+	/* 'is_suspended' flag indicates device is suspended.
+	 * It must be set here before the usb_kill_urb() calls. Reason
+	 * is in the complete handlers, urb->status(= -ENOENT) and
+	 * this flag is used in combination to distinguish between a
+	 * 'suspended' state and a 'disconnect' one.
+	 */
+	adapter->is_suspended = true;
+
+	for (i = 0; i < adapter->priv_num; i++)
+		netif_carrier_off(adapter->priv[i]->netdev);
+
+	if (atomic_read(&card->rx_cmd_urb_pending) && card->rx_cmd.urb)
+		usb_kill_urb(card->rx_cmd.urb);
+
+	if (atomic_read(&card->rx_data_urb_pending))
+		for (i = 0; i < MWIFIEX_RX_DATA_URB; i++)
+			if (card->rx_data_list[i].urb)
+				usb_kill_urb(card->rx_data_list[i].urb);
+
+	for (i = 0; i < MWIFIEX_TX_DATA_URB; i++)
+		if (card->tx_data_list[i].urb)
+			usb_kill_urb(card->tx_data_list[i].urb);
+
+	if (card->tx_cmd.urb)
+		usb_kill_urb(card->tx_cmd.urb);
+
+	return 0;
+}
+
+/* Kernel needs to suspend all functions separately. Therefore all
+ * registered functions must have drivers with suspend and resume
+ * methods. Failing that the kernel simply removes the whole card.
+ *
+ * If already not resumed, this function turns on the traffic and
+ * sends a 'host sleep cancel' request to the firmware.
+ */
+static int mwifiex_usb_resume(struct usb_interface *intf)
+{
+	struct usb_card_rec *card = usb_get_intfdata(intf);
+	struct mwifiex_adapter *adapter;
+	int i;
+
+	if (!card || !card->adapter) {
+		pr_err("%s: card or card->adapter is NULL\n", __func__);
+		return 0;
+	}
+	adapter = card->adapter;
+
+	if (unlikely(!adapter->is_suspended)) {
+		dev_warn(adapter->dev, "Device already resumed\n");
+		return 0;
+	}
+
+	/* Indicate device resumed. The netdev queue will be resumed only
+	 * after the urbs have been re-submitted
+	 */
+	adapter->is_suspended = false;
+
+	if (!atomic_read(&card->rx_data_urb_pending))
+		for (i = 0; i < MWIFIEX_RX_DATA_URB; i++)
+			mwifiex_usb_submit_rx_urb(&card->rx_data_list[i],
+						  MWIFIEX_RX_DATA_BUF_SIZE);
+
+	if (!atomic_read(&card->rx_cmd_urb_pending)) {
+		card->rx_cmd.skb = dev_alloc_skb(MWIFIEX_RX_CMD_BUF_SIZE);
+		if (card->rx_cmd.skb)
+			mwifiex_usb_submit_rx_urb(&card->rx_cmd,
+						  MWIFIEX_RX_CMD_BUF_SIZE);
+	}
+
+	for (i = 0; i < adapter->priv_num; i++)
+		if (adapter->priv[i]->media_connected)
+			netif_carrier_on(adapter->priv[i]->netdev);
+
+	/* Disable Host Sleep */
+	if (adapter->hs_activated)
+		mwifiex_cancel_hs(mwifiex_get_priv(adapter,
+						   MWIFIEX_BSS_ROLE_ANY),
+				  MWIFIEX_ASYNC_CMD);
+
+#ifdef CONFIG_PM
+	/* Resume handler may be called due to remote wakeup,
+	 * force to exit suspend anyway
+	 */
+	usb_disable_autosuspend(card->udev);
+#endif /* CONFIG_PM */
+
+	return 0;
+}
+
+static void mwifiex_usb_disconnect(struct usb_interface *intf)
+{
+	struct usb_card_rec *card = usb_get_intfdata(intf);
+	struct mwifiex_adapter *adapter;
+	int i;
+
+	if (!card || !card->adapter) {
+		pr_err("%s: card or card->adapter is NULL\n", __func__);
+		return;
+	}
+
+	adapter = card->adapter;
+	if (!adapter->priv_num)
+		return;
+
+	/* In case driver is removed when asynchronous FW downloading is
+	 * in progress
+	 */
+	wait_for_completion(&adapter->fw_load);
+
+	if (user_rmmod) {
+#ifdef CONFIG_PM
+		if (adapter->is_suspended)
+			mwifiex_usb_resume(intf);
+#endif
+		for (i = 0; i < adapter->priv_num; i++)
+			if ((GET_BSS_ROLE(adapter->priv[i]) ==
+			     MWIFIEX_BSS_ROLE_STA) &&
+			    adapter->priv[i]->media_connected)
+				mwifiex_deauthenticate(adapter->priv[i], NULL);
+
+		mwifiex_init_shutdown_fw(mwifiex_get_priv(adapter,
+							  MWIFIEX_BSS_ROLE_ANY),
+					 MWIFIEX_FUNC_SHUTDOWN);
+	}
+
+	mwifiex_usb_free(card);
+
+	dev_dbg(adapter->dev, "%s: removing card\n", __func__);
+	mwifiex_remove_card(adapter, &add_remove_card_sem);
+
+	usb_set_intfdata(intf, NULL);
+	usb_put_dev(interface_to_usbdev(intf));
+	kfree(card);
+
+	return;
+}
+
+static struct usb_driver mwifiex_usb_driver = {
+	.name = usbdriver_name,
+	.probe = mwifiex_usb_probe,
+	.disconnect = mwifiex_usb_disconnect,
+	.id_table = mwifiex_usb_table,
+	.suspend = mwifiex_usb_suspend,
+	.resume = mwifiex_usb_resume,
+	.supports_autosuspend = 1,
+};
+
+static int mwifiex_usb_tx_init(struct mwifiex_adapter *adapter)
+{
+	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
+	int i;
+
+	card->tx_cmd.adapter = adapter;
+	card->tx_cmd.ep = card->tx_cmd_ep;
+
+	card->tx_cmd.urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!card->tx_cmd.urb) {
+		dev_err(adapter->dev, "tx_cmd.urb allocation failed\n");
+		return -ENOMEM;
+	}
+
+	card->tx_data_ix = 0;
+
+	for (i = 0; i < MWIFIEX_TX_DATA_URB; i++) {
+		card->tx_data_list[i].adapter = adapter;
+		card->tx_data_list[i].ep = card->tx_data_ep;
+
+		card->tx_data_list[i].urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (!card->tx_data_list[i].urb) {
+			dev_err(adapter->dev,
+				"tx_data_list[] urb allocation failed\n");
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+static int mwifiex_usb_rx_init(struct mwifiex_adapter *adapter)
+{
+	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
+	int i;
+
+	card->rx_cmd.adapter = adapter;
+	card->rx_cmd.ep = card->rx_cmd_ep;
+
+	card->rx_cmd.urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!card->rx_cmd.urb) {
+		dev_err(adapter->dev, "rx_cmd.urb allocation failed\n");
+		return -ENOMEM;
+	}
+
+	card->rx_cmd.skb = dev_alloc_skb(MWIFIEX_RX_CMD_BUF_SIZE);
+	if (!card->rx_cmd.skb) {
+		dev_err(adapter->dev, "rx_cmd.skb allocation failed\n");
+		return -ENOMEM;
+	}
+
+	if (mwifiex_usb_submit_rx_urb(&card->rx_cmd, MWIFIEX_RX_CMD_BUF_SIZE))
+		return -1;
+
+	for (i = 0; i < MWIFIEX_RX_DATA_URB; i++) {
+		card->rx_data_list[i].adapter = adapter;
+		card->rx_data_list[i].ep = card->rx_data_ep;
+
+		card->rx_data_list[i].urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (!card->rx_data_list[i].urb) {
+			dev_err(adapter->dev,
+				"rx_data_list[] urb allocation failed\n");
+			return -1;
+		}
+		if (mwifiex_usb_submit_rx_urb(&card->rx_data_list[i],
+					      MWIFIEX_RX_DATA_BUF_SIZE))
+			return -1;
+	}
+
+	return 0;
+}
+
+static int mwifiex_write_data_sync(struct mwifiex_adapter *adapter, u8 *pbuf,
+				   u32 *len, u8 ep, u32 timeout)
+{
+	struct usb_card_rec *card = adapter->card;
+	int actual_length, ret;
+
+	if (!(*len % card->bulk_out_maxpktsize))
+		(*len)++;
+
+	/* Send the data block */
+	ret = usb_bulk_msg(card->udev, usb_sndbulkpipe(card->udev, ep), pbuf,
+			   *len, &actual_length, timeout);
+	if (ret) {
+		dev_err(adapter->dev, "usb_bulk_msg for tx failed: %d\n", ret);
+		ret = -1;
+	}
+
+	*len = actual_length;
+
+	return ret;
+}
+
+static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter, u8 *pbuf,
+				  u32 *len, u8 ep, u32 timeout)
+{
+	struct usb_card_rec *card = adapter->card;
+	int actual_length, ret;
+
+	/* Receive the data response */
+	ret = usb_bulk_msg(card->udev, usb_rcvbulkpipe(card->udev, ep), pbuf,
+			   *len, &actual_length, timeout);
+	if (ret) {
+		dev_err(adapter->dev, "usb_bulk_msg for rx failed: %d\n", ret);
+		ret = -1;
+	}
+
+	*len = actual_length;
+
+	return ret;
+}
+
+/* This function write a command/data packet to card. */
+static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
+				    struct sk_buff *skb,
+				    struct mwifiex_tx_param *tx_param)
+{
+	struct usb_card_rec *card = adapter->card;
+	struct urb_context *context;
+	u8 *data = (u8 *)skb->data;
+	struct urb *tx_urb;
+
+	if (adapter->is_suspended) {
+		dev_err(adapter->dev,
+			"%s: not allowed while suspended\n", __func__);
+		return -1;
+	}
+
+	if (adapter->surprise_removed) {
+		dev_err(adapter->dev, "%s: device removed\n", __func__);
+		return -1;
+	}
+
+	if (ep == card->tx_data_ep &&
+	    atomic_read(&card->tx_data_urb_pending) >= MWIFIEX_TX_DATA_URB) {
+		return -EBUSY;
+	}
+
+	dev_dbg(adapter->dev, "%s: ep=%d\n", __func__, ep);
+
+	if (ep == card->tx_cmd_ep) {
+		context = &card->tx_cmd;
+	} else {
+		if (card->tx_data_ix >= MWIFIEX_TX_DATA_URB)
+			card->tx_data_ix = 0;
+		context = &card->tx_data_list[card->tx_data_ix++];
+	}
+
+	context->adapter = adapter;
+	context->ep = ep;
+	context->skb = skb;
+	tx_urb = context->urb;
+
+	usb_fill_bulk_urb(tx_urb, card->udev, usb_sndbulkpipe(card->udev, ep),
+			  data, skb->len, mwifiex_usb_tx_complete,
+			  (void *)context);
+
+	tx_urb->transfer_flags |= URB_ZERO_PACKET;
+
+	if (ep == card->tx_cmd_ep)
+		atomic_inc(&card->tx_cmd_urb_pending);
+	else
+		atomic_inc(&card->tx_data_urb_pending);
+
+	if (usb_submit_urb(tx_urb, GFP_ATOMIC)) {
+		dev_err(adapter->dev, "%s: usb_submit_urb failed\n", __func__);
+		if (ep == card->tx_cmd_ep) {
+			atomic_dec(&card->tx_cmd_urb_pending);
+		} else {
+			atomic_dec(&card->tx_data_urb_pending);
+			if (card->tx_data_ix)
+				card->tx_data_ix--;
+			else
+				card->tx_data_ix = MWIFIEX_TX_DATA_URB;
+		}
+
+		return -1;
+	} else {
+		if (ep == card->tx_data_ep &&
+		    atomic_read(&card->tx_data_urb_pending) ==
+							MWIFIEX_TX_DATA_URB)
+			return -ENOSR;
+	}
+
+	return -EINPROGRESS;
+}
+
+/* This function register usb device and initialize parameter. */
+static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
+{
+	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
+
+	card->adapter = adapter;
+	adapter->dev = &card->udev->dev;
+	strcpy(adapter->fw_name, USB8797_DEFAULT_FW_NAME);
+
+	return 0;
+}
+
+/* This function reads one block of firmware data. */
+static int mwifiex_get_fw_data(struct mwifiex_adapter *adapter,
+			       u32 offset, u32 len, u8 *buf)
+{
+	if (!buf || !len)
+		return -1;
+
+	if (offset + len > adapter->firmware->size)
+		return -1;
+
+	memcpy(buf, adapter->firmware->data + offset, len);
+
+	return 0;
+}
+
+static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
+				    struct mwifiex_fw_image *fw)
+{
+	int ret = 0;
+	u8 *firmware = fw->fw_buf, *recv_buff;
+	u32 retries = USB8797_FW_MAX_RETRY, dlen;
+	u32 fw_seqnum = 0, tlen = 0, dnld_cmd = 0;
+	struct fw_data *fwdata;
+	struct fw_sync_header sync_fw;
+	u8 check_winner = 1;
+
+	if (!firmware) {
+		dev_err(adapter->dev,
+			"No firmware image found! Terminating download\n");
+		ret = -1;
+		goto fw_exit;
+	}
+
+	/* Allocate memory for transmit */
+	fwdata = kzalloc(FW_DNLD_TX_BUF_SIZE, GFP_KERNEL);
+	if (!fwdata)
+		goto fw_exit;
+
+	/* Allocate memory for receive */
+	recv_buff = kzalloc(FW_DNLD_RX_BUF_SIZE, GFP_KERNEL);
+	if (!recv_buff)
+		goto cleanup;
+
+	do {
+		/* Send pseudo data to check winner status first */
+		if (check_winner) {
+			memset(&fwdata->fw_hdr, 0, sizeof(struct fw_header));
+			dlen = 0;
+		} else {
+			/* copy the header of the fw_data to get the length */
+			if (firmware)
+				memcpy(&fwdata->fw_hdr, &firmware[tlen],
+				       sizeof(struct fw_header));
+			else
+				mwifiex_get_fw_data(adapter, tlen,
+						    sizeof(struct fw_header),
+						    (u8 *)&fwdata->fw_hdr);
+
+			dlen = le32_to_cpu(fwdata->fw_hdr.data_len);
+			dnld_cmd = le32_to_cpu(fwdata->fw_hdr.dnld_cmd);
+			tlen += sizeof(struct fw_header);
+
+			if (firmware)
+				memcpy(fwdata->data, &firmware[tlen], dlen);
+			else
+				mwifiex_get_fw_data(adapter, tlen, dlen,
+						    (u8 *)fwdata->data);
+
+			fwdata->seq_num = cpu_to_le32(fw_seqnum);
+			tlen += dlen;
+		}
+
+		/* If the send/receive fails or CRC occurs then retry */
+		while (retries--) {
+			u8 *buf = (u8 *)fwdata;
+			u32 len = FW_DATA_XMIT_SIZE;
+
+			/* send the firmware block */
+			ret = mwifiex_write_data_sync(adapter, buf, &len,
+						MWIFIEX_USB_EP_CMD_EVENT,
+						MWIFIEX_USB_TIMEOUT);
+			if (ret) {
+				dev_err(adapter->dev,
+					"write_data_sync: failed: %d\n", ret);
+				continue;
+			}
+
+			buf = recv_buff;
+			len = FW_DNLD_RX_BUF_SIZE;
+
+			/* Receive the firmware block response */
+			ret = mwifiex_read_data_sync(adapter, buf, &len,
+						MWIFIEX_USB_EP_CMD_EVENT,
+						MWIFIEX_USB_TIMEOUT);
+			if (ret) {
+				dev_err(adapter->dev,
+					"read_data_sync: failed: %d\n", ret);
+				continue;
+			}
+
+			memcpy(&sync_fw, recv_buff,
+			       sizeof(struct fw_sync_header));
+
+			/* check 1st firmware block resp for highest bit set */
+			if (check_winner) {
+				if (le32_to_cpu(sync_fw.cmd) & 0x80000000) {
+					dev_warn(adapter->dev,
+						 "USB is not the winner %#x\n",
+						 sync_fw.cmd);
+
+					/* returning success */
+					ret = 0;
+					goto cleanup;
+				}
+
+				dev_dbg(adapter->dev,
+					"USB is the winner, start to download FW\n");
+
+				check_winner = 0;
+				break;
+			}
+
+			/* check the firmware block response for CRC errors */
+			if (sync_fw.cmd) {
+				dev_err(adapter->dev,
+					"FW received block with CRC %#x\n",
+					sync_fw.cmd);
+				ret = -1;
+				continue;
+			}
+
+			retries = USB8797_FW_MAX_RETRY;
+			break;
+		}
+		fw_seqnum++;
+	} while ((dnld_cmd != FW_HAS_LAST_BLOCK) && retries);
+
+cleanup:
+	dev_dbg(adapter->dev, "%s: %d bytes downloaded\n", __func__, tlen);
+
+	kfree(recv_buff);
+	kfree(fwdata);
+
+	if (retries)
+		ret = 0;
+fw_exit:
+	return ret;
+}
+
+static int mwifiex_usb_dnld_fw(struct mwifiex_adapter *adapter,
+			struct mwifiex_fw_image *fw)
+{
+	int ret;
+	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
+
+	if (card->usb_boot_state == USB8797_FW_DNLD) {
+		ret = mwifiex_prog_fw_w_helper(adapter, fw);
+		if (ret)
+			return -1;
+
+		/* Boot state changes after successful firmware download */
+		if (card->usb_boot_state == USB8797_FW_DNLD)
+			return -1;
+	}
+
+	ret = mwifiex_usb_rx_init(adapter);
+	if (!ret)
+		ret = mwifiex_usb_tx_init(adapter);
+
+	return ret;
+}
+
+static void mwifiex_submit_rx_urb(struct mwifiex_adapter *adapter, u8 ep)
+{
+	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
+
+	skb_push(card->rx_cmd.skb, INTF_HEADER_LEN);
+	if ((ep == card->rx_cmd_ep) &&
+	    (!atomic_read(&card->rx_cmd_urb_pending)))
+		mwifiex_usb_submit_rx_urb(&card->rx_cmd,
+					  MWIFIEX_RX_CMD_BUF_SIZE);
+
+	return;
+}
+
+static int mwifiex_usb_cmd_event_complete(struct mwifiex_adapter *adapter,
+				       struct sk_buff *skb)
+{
+	atomic_dec(&adapter->rx_pending);
+	mwifiex_submit_rx_urb(adapter, MWIFIEX_USB_EP_CMD_EVENT);
+
+	return 0;
+}
+
+static int mwifiex_usb_data_complete(struct mwifiex_adapter *adapter,
+				     struct sk_buff *skb)
+{
+	atomic_dec(&adapter->rx_pending);
+	dev_kfree_skb_any(skb);
+
+	return 0;
+}
+
+/* This function wakes up the card. */
+static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
+{
+	/* Simulation of HS_AWAKE event */
+	adapter->pm_wakeup_fw_try = false;
+	adapter->pm_wakeup_card_req = false;
+	adapter->ps_state = PS_STATE_AWAKE;
+
+	return 0;
+}
+
+static struct mwifiex_if_ops usb_ops = {
+	.register_dev =		mwifiex_register_dev,
+	.wakeup =		mwifiex_pm_wakeup_card,
+	.wakeup_complete =	mwifiex_pm_wakeup_card_complete,
+
+	/* USB specific */
+	.dnld_fw =		mwifiex_usb_dnld_fw,
+	.cmdrsp_complete =	mwifiex_usb_cmd_event_complete,
+	.event_complete =	mwifiex_usb_cmd_event_complete,
+	.data_complete =	mwifiex_usb_data_complete,
+	.host_to_card =		mwifiex_usb_host_to_card,
+};
+
+/* This function initializes the USB driver module.
+ *
+ * This initiates the semaphore and registers the device with
+ * USB bus.
+ */
+static int mwifiex_usb_init_module(void)
+{
+	int ret;
+
+	pr_debug("Marvell USB8797 Driver\n");
+
+	sema_init(&add_remove_card_sem, 1);
+
+	ret = usb_register(&mwifiex_usb_driver);
+	if (ret)
+		pr_err("Driver register failed!\n");
+	else
+		pr_debug("info: Driver registered successfully!\n");
+
+	return ret;
+}
+
+/* This function cleans up the USB driver.
+ *
+ * The following major steps are followed in .disconnect for cleanup:
+ *      - Resume the device if its suspended
+ *      - Disconnect the device if connected
+ *      - Shutdown the firmware
+ *      - Unregister the device from USB bus.
+ */
+static void mwifiex_usb_cleanup_module(void)
+{
+	if (!down_interruptible(&add_remove_card_sem))
+		up(&add_remove_card_sem);
+
+	/* set the flag as user is removing this module */
+	user_rmmod = 1;
+
+	usb_deregister(&mwifiex_usb_driver);
+}
+
+module_init(mwifiex_usb_init_module);
+module_exit(mwifiex_usb_cleanup_module);
+
+MODULE_AUTHOR("Marvell International Ltd.");
+MODULE_DESCRIPTION("Marvell WiFi-Ex USB Driver version" USB_VERSION);
+MODULE_VERSION(USB_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_FIRMWARE("mrvl/usb8797_uapsta.bin");
diff --git a/drivers/net/wireless/mwifiex/usb.h b/drivers/net/wireless/mwifiex/usb.h
new file mode 100644
index 0000000..98c4316
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/usb.h
@@ -0,0 +1,99 @@
+/*
+ * This file contains definitions for mwifiex USB interface driver.
+ *
+ * Copyright (C) 2012, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef _MWIFIEX_USB_H
+#define _MWIFIEX_USB_H
+
+#include <linux/usb.h>
+
+#define USB8797_VID		0x1286
+#define USB8797_PID_1		0x2043
+#define USB8797_PID_2		0x2044
+
+#define USB8797_FW_DNLD		1
+#define USB8797_FW_READY	2
+#define USB8797_FW_MAX_RETRY	3
+
+#define MWIFIEX_TX_DATA_URB	6
+#define MWIFIEX_RX_DATA_URB	6
+#define MWIFIEX_USB_TIMEOUT	100
+
+#define USB8797_DEFAULT_FW_NAME	"mrvl/usb8797_uapsta.bin"
+
+#define FW_DNLD_TX_BUF_SIZE	620
+#define FW_DNLD_RX_BUF_SIZE	2048
+#define FW_HAS_LAST_BLOCK	0x00000004
+
+#define FW_DATA_XMIT_SIZE \
+	(sizeof(struct fw_header) + dlen + sizeof(u32))
+
+struct urb_context {
+	struct mwifiex_adapter *adapter;
+	struct sk_buff *skb;
+	struct urb *urb;
+	u8 ep;
+};
+
+struct usb_card_rec {
+	struct mwifiex_adapter *adapter;
+	struct usb_device *udev;
+	struct usb_interface *intf;
+	u8 rx_cmd_ep;
+	struct urb_context rx_cmd;
+	atomic_t rx_cmd_urb_pending;
+	struct urb_context rx_data_list[MWIFIEX_RX_DATA_URB];
+	u8 usb_boot_state;
+	u8 rx_data_ep;
+	atomic_t rx_data_urb_pending;
+	u8 tx_data_ep;
+	u8 tx_cmd_ep;
+	atomic_t tx_data_urb_pending;
+	atomic_t tx_cmd_urb_pending;
+	int bulk_out_maxpktsize;
+	struct urb_context tx_cmd;
+	int tx_data_ix;
+	struct urb_context tx_data_list[MWIFIEX_TX_DATA_URB];
+};
+
+struct fw_header {
+	__le32 dnld_cmd;
+	__le32 base_addr;
+	__le32 data_len;
+	__le32 crc;
+};
+
+struct fw_sync_header {
+	__le32 cmd;
+	__le32 seq_num;
+};
+
+struct fw_data {
+	struct fw_header fw_hdr;
+	__le32 seq_num;
+	u8 data[1];
+};
+
+/* This function is called after the card has woken up. */
+static inline int
+mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
+{
+	return 0;
+}
+
+#endif /*_MWIFIEX_USB_H */
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 6b39997..2864c74 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -167,6 +167,28 @@ int mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	skb->dev = priv->netdev;
 	skb->protocol = eth_type_trans(skb, priv->netdev);
 	skb->ip_summed = CHECKSUM_NONE;
+
+	/* This is required only in case of 11n and USB as we alloc
+	 * a buffer of 4K only if its 11N (to be able to receive 4K
+	 * AMSDU packets). In case of SD we allocate buffers based
+	 * on the size of packet and hence this is not needed.
+	 *
+	 * Modifying the truesize here as our allocation for each
+	 * skb is 4K but we only receive 2K packets and this cause
+	 * the kernel to start dropping packets in case where
+	 * application has allocated buffer based on 2K size i.e.
+	 * if there a 64K packet received (in IP fragments and
+	 * application allocates 64K to receive this packet but
+	 * this packet would almost double up because we allocate
+	 * each 1.5K fragment in 4K and pass it up. As soon as the
+	 * 64K limit hits kernel will start to drop rest of the
+	 * fragments. Currently we fail the Filesndl-ht.scr script
+	 * for UDP, hence this fix
+	 */
+	if ((adapter->iface_type == MWIFIEX_USB) &&
+	    (skb->truesize > MWIFIEX_RX_DATA_BUF_SIZE))
+		skb->truesize += (skb->len - MWIFIEX_RX_DATA_BUF_SIZE);
+
 	priv->stats.rx_bytes += skb->len;
 	priv->stats.rx_packets++;
 	if (in_interrupt())
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 5a7316c..429a1de 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1120,11 +1120,19 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 	tx_info = MWIFIEX_SKB_TXCB(skb);
 
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
-	tx_param.next_pkt_len =
-		((skb_next) ? skb_next->len +
-		 sizeof(struct txpd) : 0);
-	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA, skb,
-					   &tx_param);
+
+	if (adapter->iface_type == MWIFIEX_USB) {
+		adapter->data_sent = true;
+		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_USB_EP_DATA,
+						   skb, NULL);
+	} else {
+		tx_param.next_pkt_len =
+			((skb_next) ? skb_next->len +
+			 sizeof(struct txpd) : 0);
+		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
+						   skb, &tx_param);
+	}
+
 	switch (ret) {
 	case -EBUSY:
 		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
-- 
1.7.0.2

