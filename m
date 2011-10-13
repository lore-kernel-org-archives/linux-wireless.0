Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:46281 "HELO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752239Ab1JMDbx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 23:31:53 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix make namespacecheck warnings
Date: Wed, 12 Oct 2011 20:29:33 -0700
Message-Id: <1318476573-10247-1-git-send-email-bzhao@marvell.com> (sfid-20111013_053156_773393_7276FDA6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This patch takes care of warnings found by running
'make namespacecheck':

1. Remove dead code.
2. Reorder function definitions to avoid forward declarations.
3. Remove unnecessary function/structure declarations and mark
   them as static.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfp.c       |   10 +++---
 drivers/net/wireless/mwifiex/fw.h        |    6 ---
 drivers/net/wireless/mwifiex/init.c      |   56 +++++++++++++++---------------
 drivers/net/wireless/mwifiex/main.h      |    8 ----
 drivers/net/wireless/mwifiex/scan.c      |   50 +++++++++++++-------------
 drivers/net/wireless/mwifiex/sta_ioctl.c |    4 +-
 drivers/net/wireless/mwifiex/txrx.c      |   40 ---------------------
 7 files changed, 60 insertions(+), 114 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index d0cada5..f2e6de0 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -48,7 +48,7 @@ static u8 adhoc_rates_bg[BG_SUPPORTED_RATES] = { 0x82, 0x84, 0x8b, 0x96,
 
 static u8 adhoc_rates_a[A_SUPPORTED_RATES] = { 0x8c, 0x12, 0x98, 0x24,
 					       0xb0, 0x48, 0x60, 0x6c, 0 };
-u8 supported_rates_a[A_SUPPORTED_RATES] = { 0x0c, 0x12, 0x18, 0x24,
+static u8 supported_rates_a[A_SUPPORTED_RATES] = { 0x0c, 0x12, 0x18, 0x24,
 					0xb0, 0x48, 0x60, 0x6c, 0 };
 static u16 mwifiex_data_rates[MWIFIEX_SUPPORTED_RATES_EXT] = { 0x02, 0x04,
 					0x0B, 0x16, 0x00, 0x0C, 0x12, 0x18,
@@ -57,19 +57,19 @@ static u16 mwifiex_data_rates[MWIFIEX_SUPPORTED_RATES_EXT] = { 0x02, 0x04,
 					0x75, 0x82, 0x0C, 0x1B, 0x36, 0x51,
 					0x6C, 0xA2, 0xD8, 0xF3, 0x10E, 0x00 };
 
-u8 supported_rates_b[B_SUPPORTED_RATES] = { 0x02, 0x04, 0x0b, 0x16, 0 };
+static u8 supported_rates_b[B_SUPPORTED_RATES] = { 0x02, 0x04, 0x0b, 0x16, 0 };
 
-u8 supported_rates_g[G_SUPPORTED_RATES] = { 0x0c, 0x12, 0x18, 0x24,
+static u8 supported_rates_g[G_SUPPORTED_RATES] = { 0x0c, 0x12, 0x18, 0x24,
 					0x30, 0x48, 0x60, 0x6c, 0 };
 
-u8 supported_rates_bg[BG_SUPPORTED_RATES] = { 0x02, 0x04, 0x0b, 0x0c,
+static u8 supported_rates_bg[BG_SUPPORTED_RATES] = { 0x02, 0x04, 0x0b, 0x0c,
 					0x12, 0x16, 0x18, 0x24, 0x30, 0x48,
 					0x60, 0x6c, 0 };
 
 u16 region_code_index[MWIFIEX_MAX_REGION_CODE] = { 0x10, 0x20, 0x30,
 						0x32, 0x40, 0x41, 0xff };
 
-u8 supported_rates_n[N_SUPPORTED_RATES] = { 0x02, 0x04, 0 };
+static u8 supported_rates_n[N_SUPPORTED_RATES] = { 0x02, 0x04, 0 };
 
 /*
  * This function maps an index in supported rates table into
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 71c61b7..0cc5d73 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -57,12 +57,6 @@ struct tx_packet_hdr {
 #define GET_FW_DEFAULT_BANDS(adapter)  \
 	((adapter->fw_cap_info >> 8) & ALL_802_11_BANDS)
 
-extern u8 supported_rates_b[B_SUPPORTED_RATES];
-extern u8 supported_rates_g[G_SUPPORTED_RATES];
-extern u8 supported_rates_bg[BG_SUPPORTED_RATES];
-extern u8 supported_rates_a[A_SUPPORTED_RATES];
-extern u8 supported_rates_n[N_SUPPORTED_RATES];
-
 #define HostCmd_WEP_KEY_INDEX_MASK              0x3fff
 
 #define KEY_INFO_ENABLED        0x01
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 0ce72fc..d792b3f 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -283,6 +283,34 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 }
 
 /*
+ *  This function releases the lock variables and frees the locks and
+ *  associated locks.
+ */
+static void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
+{
+	struct mwifiex_private *priv;
+	s32 i, j;
+
+	/* Free lists */
+	list_del(&adapter->cmd_free_q);
+	list_del(&adapter->cmd_pending_q);
+	list_del(&adapter->scan_pending_q);
+
+	for (i = 0; i < adapter->priv_num; i++)
+		list_del(&adapter->bss_prio_tbl[i].bss_prio_head);
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (adapter->priv[i]) {
+			priv = adapter->priv[i];
+			for (j = 0; j < MAX_NUM_TID; ++j)
+				list_del(&priv->wmm.tid_tbl_ptr[j].ra_list);
+			list_del(&priv->tx_ba_stream_tbl_ptr);
+			list_del(&priv->rx_reorder_tbl_ptr);
+		}
+	}
+}
+
+/*
  * This function frees the adapter structure.
  *
  * The freeing operation is done recursively, by canceling all
@@ -376,34 +404,6 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 }
 
 /*
- *  This function releases the lock variables and frees the locks and
- *  associated locks.
- */
-void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
-{
-	struct mwifiex_private *priv;
-	s32 i, j;
-
-	/* Free lists */
-	list_del(&adapter->cmd_free_q);
-	list_del(&adapter->cmd_pending_q);
-	list_del(&adapter->scan_pending_q);
-
-	for (i = 0; i < adapter->priv_num; i++)
-		list_del(&adapter->bss_prio_tbl[i].bss_prio_head);
-
-	for (i = 0; i < adapter->priv_num; i++) {
-		if (adapter->priv[i]) {
-			priv = adapter->priv[i];
-			for (j = 0; j < MAX_NUM_TID; ++j)
-				list_del(&priv->wmm.tid_tbl_ptr[j].ra_list);
-			list_del(&priv->tx_ba_stream_tbl_ptr);
-			list_del(&priv->rx_reorder_tbl_ptr);
-		}
-	}
-}
-
-/*
  * This function initializes the firmware.
  *
  * The following operations are performed sequentially -
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 7db20db..30f138b 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -658,7 +658,6 @@ struct mwifiex_adapter {
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
-void mwifiex_free_lock_list(struct mwifiex_adapter *adapter);
 
 int mwifiex_init_fw(struct mwifiex_adapter *adapter);
 
@@ -709,8 +708,6 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags);
 int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 				struct sk_buff *skb, int status);
-int mwifiex_recv_packet_complete(struct mwifiex_adapter *,
-				 struct sk_buff *skb, int status);
 void mwifiex_clean_txrx(struct mwifiex_private *priv);
 u8 mwifiex_check_last_packet_indication(struct mwifiex_private *priv);
 void mwifiex_check_ps_cond(struct mwifiex_adapter *adapter);
@@ -740,8 +737,6 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *,
 int mwifiex_process_sta_event(struct mwifiex_private *);
 void *mwifiex_process_sta_txpd(struct mwifiex_private *, struct sk_buff *skb);
 int mwifiex_sta_init_cmd(struct mwifiex_private *, u8 first_sta);
-int mwifiex_scan_networks(struct mwifiex_private *priv,
-			  const struct mwifiex_user_scan_cfg *user_scan_in);
 int mwifiex_cmd_802_11_scan(struct host_cmd_ds_command *cmd,
 			    struct mwifiex_scan_cmd_config *scan_cfg);
 void mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
@@ -901,9 +896,6 @@ int mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
 int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter);
 int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 		      struct mwifiex_802_11_ssid *req_ssid);
-int mwifiex_set_hs_params(struct mwifiex_private *priv,
-			      u16 action, int cmd_type,
-			      struct mwifiex_ds_hs_cfg *hscfg);
 int mwifiex_cancel_hs(struct mwifiex_private *priv, int cmd_type);
 int mwifiex_enable_hs(struct mwifiex_adapter *adapter);
 int mwifiex_disable_auto_ds(struct mwifiex_private *priv);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 5456dcb..dae8dbb 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -172,29 +172,6 @@ mwifiex_ssid_cmp(struct mwifiex_802_11_ssid *ssid1,
 }
 
 /*
- * Sends IOCTL request to start a scan with user configurations.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- *
- * Upon completion, it also generates a wireless event to notify
- * applications.
- */
-int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
-				struct mwifiex_user_scan_cfg *scan_req)
-{
-	int status;
-
-	priv->adapter->scan_wait_q_woken = false;
-
-	status = mwifiex_scan_networks(priv, scan_req);
-	if (!status)
-		status = mwifiex_wait_queue_complete(priv->adapter);
-
-	return status;
-}
-
-/*
  * This function checks if wapi is enabled in driver and scanned network is
  * compatible with it.
  */
@@ -1316,8 +1293,8 @@ mwifiex_radio_type_to_band(u8 radio_type)
  * order to send the appropriate scan commands to firmware to populate or
  * update the internal driver scan table.
  */
-int mwifiex_scan_networks(struct mwifiex_private *priv,
-			  const struct mwifiex_user_scan_cfg *user_scan_in)
+static int mwifiex_scan_networks(struct mwifiex_private *priv,
+		const struct mwifiex_user_scan_cfg *user_scan_in)
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -1399,6 +1376,29 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 }
 
 /*
+ * Sends IOCTL request to start a scan with user configurations.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ *
+ * Upon completion, it also generates a wireless event to notify
+ * applications.
+ */
+int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
+				struct mwifiex_user_scan_cfg *scan_req)
+{
+	int status;
+
+	priv->adapter->scan_wait_q_woken = false;
+
+	status = mwifiex_scan_networks(priv, scan_req);
+	if (!status)
+		status = mwifiex_wait_queue_complete(priv->adapter);
+
+	return status;
+}
+
+/*
  * This function prepares a scan command to be sent to the firmware.
  *
  * This uses the scan command configuration sent to the command processing
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index d39bb72..ea4a29b 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -293,8 +293,8 @@ done:
  * This function prepares the correct firmware command and
  * issues it.
  */
-int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
-			  int cmd_type, struct mwifiex_ds_hs_cfg *hs_cfg)
+static int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
+				 int cmd_type, struct mwifiex_ds_hs_cfg *hs_cfg)
 
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 4c3421e..a206f41 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -161,43 +161,3 @@ done:
 	return 0;
 }
 
-/*
- * Packet receive completion callback handler.
- *
- * This function calls another completion callback handler which
- * updates the statistics, and optionally updates the parent buffer
- * use count before freeing the received packet.
- */
-int mwifiex_recv_packet_complete(struct mwifiex_adapter *adapter,
-				 struct sk_buff *skb, int status)
-{
-	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
-	struct mwifiex_rxinfo *rx_info_parent;
-	struct mwifiex_private *priv;
-	struct sk_buff *skb_parent;
-	unsigned long flags;
-
-	priv = adapter->priv[rx_info->bss_index];
-
-	if (priv && (status == -1))
-		priv->stats.rx_dropped++;
-
-	if (rx_info->parent) {
-		skb_parent = rx_info->parent;
-		rx_info_parent = MWIFIEX_SKB_RXCB(skb_parent);
-
-		spin_lock_irqsave(&priv->rx_pkt_lock, flags);
-		--rx_info_parent->use_count;
-
-		if (!rx_info_parent->use_count) {
-			spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
-			dev_kfree_skb_any(skb_parent);
-		} else {
-			spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
-		}
-	} else {
-		dev_kfree_skb_any(skb);
-	}
-
-	return 0;
-}
-- 
1.7.0.2

