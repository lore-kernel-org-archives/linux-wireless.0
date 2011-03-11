Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:58078 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab1CKAWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 19:22:45 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/4] mwifiex: remove unnecessory external function declarations
Date: Thu, 10 Mar 2011 16:25:46 -0800
Message-Id: <1299803149-25996-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

'make namespacecheck' found the following
Externally defined symbols with no external references

  drivers/net/wireless/mwifiex/11n.o
    mwifiex_11n_get_tx_ba_stream_status
    mwifiex_11n_update_addba_request
  drivers/net/wireless/mwifiex/cfp.o
    adhoc_rates_a
    adhoc_rates_b
    adhoc_rates_bg
    adhoc_rates_g
  drivers/net/wireless/mwifiex/cmdevt.o
    mwifiex_host_sleep_wakeup_event
  drivers/net/wireless/mwifiex/init.o
    mwifiex_delete_bss_prio_tbl
    mwifiex_init_adapter
  drivers/net/wireless/mwifiex/main.o
    mwifiex_main_work_queue
  drivers/net/wireless/mwifiex/scan.o
    mwifiex_restore_curr_bcn
    mwifiex_scan_specific_ssid
  drivers/net/wireless/mwifiex/sdio.o
    mwifiex_alloc_sdio_mpa_buffers
    mwifiex_host_to_card_mp_aggr
  drivers/net/wireless/mwifiex/sta_cmd.o
    mwifiex_cmd_802_11d_domain_info
  drivers/net/wireless/mwifiex/sta_cmdresp.o
    mwifiex_ret_802_11d_domain_info
  drivers/net/wireless/mwifiex/sta_ioctl.o
    mwifiex_bss_ioctl_ibss_channel
    mwifiex_bss_ioctl_mac_address
    mwifiex_bss_ioctl_multicast_list
    mwifiex_bss_ioctl_start
    mwifiex_bss_ioctl_stop
    mwifiex_get_info_signal
    mwifiex_get_info_stats
    mwifiex_get_info_ver_ext
    mwifiex_misc_ioctl_gen_ie
    mwifiex_pm_ioctl_deep_sleep
    mwifiex_pm_ioctl_hs_cfg
    mwifiex_pm_ioctl_ps_mode
    mwifiex_pm_ioctl_sleep_pd
    mwifiex_power_ioctl_set_power
    mwifiex_radio_ioctl_ant_cfg
    mwifiex_rate_ioctl_cfg
    mwifiex_reg_mem_ioctl_read_eeprom
    mwifiex_reg_mem_ioctl_reg_rw
    mwifiex_sec_ioctl_encrypt_key
    mwifiex_sec_ioctl_esupp_mode
    mwifiex_set_auth_mode
    mwifiex_set_encrypt_mode
  drivers/net/wireless/mwifiex/wmm.o
    mwifiex_wmm_allocate_ralist_node

This patch makes those functions static and remove their
definitions from .h files if necessory. Also move some
of these functions around to avoid static forward
declarations.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c         |   92 ++--
 drivers/net/wireless/mwifiex/11n.h         |    7 -
 drivers/net/wireless/mwifiex/cfp.c         |   16 +-
 drivers/net/wireless/mwifiex/cmdevt.c      |   16 -
 drivers/net/wireless/mwifiex/fw.h          |    4 -
 drivers/net/wireless/mwifiex/init.c        |  104 ++--
 drivers/net/wireless/mwifiex/main.c        |    3 +-
 drivers/net/wireless/mwifiex/main.h        |   83 ---
 drivers/net/wireless/mwifiex/scan.c        |  251 ++++----
 drivers/net/wireless/mwifiex/sdio.c        |  160 +++---
 drivers/net/wireless/mwifiex/sdio.h        |    8 -
 drivers/net/wireless/mwifiex/sta_cmd.c     |    6 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    4 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c   |  883 ++++++++++++++--------------
 drivers/net/wireless/mwifiex/wmm.c         |   71 ++--
 drivers/net/wireless/mwifiex/wmm.h         |    5 -
 16 files changed, 794 insertions(+), 919 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index b2850fc..1fa3f8e 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -97,6 +97,29 @@ int mwifiex_11n_ioctl_ht_tx_cfg(struct mwifiex_adapter *adapter,
 }
 
 /*
+ * This function resends add BA requests to all peers in
+ * the Tx BA stream table.
+ */
+static void mwifiex_11n_update_addba_request(struct mwifiex_private *priv)
+{
+
+	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+	if (list_empty(&priv->tx_ba_stream_tbl_ptr)) {
+		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
+		return;
+	}
+	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list)
+		mwifiex_send_addba(priv, tx_ba_tsr_tbl->tid, tx_ba_tsr_tbl->ra);
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
+
+	mwifiex_main_process(priv->adapter);
+	return;
+}
+
+/*
  * IOCTL request handler to set/get add BA parameters.
  *
  * The following parameters are supported -
@@ -428,6 +451,29 @@ mwifiex_show_dev_mcs_support(struct mwifiex_adapter *adapter, u8 support)
 }
 
 /*
+ * This function returns the pointer to an entry in BA Stream
+ * table which matches the requested BA status.
+ */
+static struct mwifiex_tx_ba_stream_tbl *
+mwifiex_11n_get_tx_ba_stream_status(struct mwifiex_private *priv,
+				  enum mwifiex_ba_status ba_status)
+{
+	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
+		if (tx_ba_tsr_tbl->ba_status == ba_status) {
+			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
+					       flags);
+			return tx_ba_tsr_tbl;
+		}
+	}
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
+	return NULL;
+}
+
+/*
  * This function handles the command response of delete a block
  * ack request.
  *
@@ -893,29 +939,6 @@ void mwifiex_11n_delete_all_tx_ba_stream_tbl(struct mwifiex_private *priv)
 
 /*
  * This function returns the pointer to an entry in BA Stream
- * table which matches the requested BA status.
- */
-struct mwifiex_tx_ba_stream_tbl *
-mwifiex_11n_get_tx_ba_stream_status(struct mwifiex_private *priv,
-				  enum mwifiex_ba_status ba_status)
-{
-	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
-	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
-		if (tx_ba_tsr_tbl->ba_status == ba_status) {
-			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
-					       flags);
-			return tx_ba_tsr_tbl;
-		}
-	}
-	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
-	return NULL;
-}
-
-/*
- * This function returns the pointer to an entry in BA Stream
  * table which matches the given RA/TID pair.
  */
 struct mwifiex_tx_ba_stream_tbl *
@@ -1051,29 +1074,6 @@ void mwifiex_11n_delete_ba_stream(struct mwifiex_private *priv, u8 *del_ba)
 }
 
 /*
- * This function resends add BA requests to all peers in
- * the Tx BA stream table.
- */
-void mwifiex_11n_update_addba_request(struct mwifiex_private *priv)
-{
-
-	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
-	if (list_empty(&priv->tx_ba_stream_tbl_ptr)) {
-		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
-		return;
-	}
-	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list)
-		mwifiex_send_addba(priv, tx_ba_tsr_tbl->tid, tx_ba_tsr_tbl->ra);
-	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
-
-	mwifiex_main_process(priv->adapter);
-	return;
-}
-
-/*
  * This function retrieves the Rx reordering table.
  */
 int mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 6918881..d70bd6d 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -71,12 +71,6 @@ void mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 					     struct mwifiex_tx_ba_stream_tbl
 					     *tx_tbl);
 void mwifiex_11n_delete_all_tx_ba_stream_tbl(struct mwifiex_private *priv);
-struct mwifiex_tx_ba_stream_tbl *mwifiex_11n_get_tx_ba_stream_status(struct
-					mwifiex_private
-					*priv,
-					enum
-					mwifiex_ba_status
-					ba_status);
 struct mwifiex_tx_ba_stream_tbl *mwifiex_11n_get_tx_ba_stream_tbl(struct
 							     mwifiex_private
 							     *priv, int tid,
@@ -88,7 +82,6 @@ int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac);
 int mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 		       int initiator);
 void mwifiex_11n_delete_ba_stream(struct mwifiex_private *priv, u8 *del_ba);
-void mwifiex_11n_update_addba_request(struct mwifiex_private *priv);
 int mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
 			      struct mwifiex_ds_rx_reorder_tbl *buf);
 int mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 5093764..64b3c1c 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -38,17 +38,17 @@
 /* 100mW */
 #define MWIFIEX_TX_PWR_EMEA_DEFAULT    20
 
-u8 adhoc_rates_b[B_SUPPORTED_RATES] = { 0x82, 0x84, 0x8b, 0x96, 0 };
+static u8 adhoc_rates_b[B_SUPPORTED_RATES] = { 0x82, 0x84, 0x8b, 0x96, 0 };
 
-u8 adhoc_rates_g[G_SUPPORTED_RATES] = { 0x8c, 0x12, 0x98, 0x24,
-					 0xb0, 0x48, 0x60, 0x6c, 0 };
+static u8 adhoc_rates_g[G_SUPPORTED_RATES] = { 0x8c, 0x12, 0x98, 0x24,
+					       0xb0, 0x48, 0x60, 0x6c, 0 };
 
-u8 adhoc_rates_bg[BG_SUPPORTED_RATES] = { 0x82, 0x84, 0x8b, 0x96,
-					0x0c, 0x12, 0x18, 0x24, 0x30, 0x48,
-					0x60, 0x6c, 0 };
+static u8 adhoc_rates_bg[BG_SUPPORTED_RATES] = { 0x82, 0x84, 0x8b, 0x96,
+						 0x0c, 0x12, 0x18, 0x24,
+						 0x30, 0x48, 0x60, 0x6c, 0 };
 
-u8 adhoc_rates_a[A_SUPPORTED_RATES] = { 0x8c, 0x12, 0x98, 0x24,
-					0xb0, 0x48, 0x60, 0x6c, 0 };
+static u8 adhoc_rates_a[A_SUPPORTED_RATES] = { 0x8c, 0x12, 0x98, 0x24,
+					       0xb0, 0x48, 0x60, 0x6c, 0 };
 u8 supported_rates_a[A_SUPPORTED_RATES] = { 0x0c, 0x12, 0x18, 0x24,
 					0xb0, 0x48, 0x60, 0x6c, 0 };
 static u16 mwifiex_data_rates[MWIFIEX_SUPPORTED_RATES_EXT] = { 0x02, 0x04,
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index e5e7329..cd82cc5 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1074,22 +1074,6 @@ mwifiex_hs_activated_event(struct mwifiex_private *priv, u8 activated)
 }
 
 /*
- * This function sends a Host Sleep wakeup event to applications.
- *
- * This event is generated by the driver, with a blank event body.
- */
-void
-mwifiex_host_sleep_wakeup_event(struct mwifiex_private *priv)
-{
-	if (priv->adapter->is_hs_configured)
-		/* simulate HSCFG_CANCEL command */
-		mwifiex_cancel_hs(priv, MWIFIEX_NO_WAIT);
-	else
-		dev_dbg(priv->adapter->dev, "event: %s: HS not configured\n",
-						__func__);
-}
-
-/*
  * This function handles the command response of a Host Sleep configuration
  * command.
  *
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 68e48b4..14796b0 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -65,10 +65,6 @@ extern u8 supported_rates_g[G_SUPPORTED_RATES];
 extern u8 supported_rates_bg[BG_SUPPORTED_RATES];
 extern u8 supported_rates_a[A_SUPPORTED_RATES];
 extern u8 supported_rates_n[N_SUPPORTED_RATES];
-extern u8 adhoc_rates_g[G_SUPPORTED_RATES];
-extern u8 adhoc_rates_b[B_SUPPORTED_RATES];
-extern u8 adhoc_rates_bg[BG_SUPPORTED_RATES];
-extern u8 adhoc_rates_a[A_SUPPORTED_RATES];
 
 #define HostCmd_WEP_KEY_INDEX_MASK              0x3fff
 
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index c4fe89d..e96ca48 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -204,8 +204,7 @@ static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
  * This also initializes the WMM related parameters in the driver private
  * structures.
  */
-void
-mwifiex_init_adapter(struct mwifiex_adapter *adapter)
+static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 {
 	struct mwifiex_opt_sleep_confirm_buffer *sleep_cfm_buf = NULL;
 
@@ -507,6 +506,56 @@ int mwifiex_init_fw(struct mwifiex_adapter *adapter)
 }
 
 /*
+ * This function deletes the BSS priority tables.
+ *
+ * The function traverses through all the allocated BSS priority nodes
+ * in every BSS priority table and frees them.
+ */
+static void mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
+{
+	int i;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_bss_prio_node *bssprio_node = NULL, *tmp_node = NULL,
+								**cur = NULL;
+	struct list_head *head;
+	spinlock_t *lock;
+	unsigned long flags;
+
+	for (i = 0; i < adapter->priv_num; ++i) {
+		head = &adapter->bss_prio_tbl[i].bss_prio_head;
+		cur = &adapter->bss_prio_tbl[i].bss_prio_cur;
+		lock = &adapter->bss_prio_tbl[i].bss_prio_lock;
+		dev_dbg(adapter->dev, "info: delete BSS priority table,"
+				" index = %d, i = %d, head = %p, cur = %p\n",
+			      priv->bss_index, i, head, *cur);
+		if (*cur) {
+			spin_lock_irqsave(lock, flags);
+			if (list_empty(head)) {
+				spin_unlock_irqrestore(lock, flags);
+				continue;
+			}
+			bssprio_node = list_first_entry(head,
+					struct mwifiex_bss_prio_node, list);
+			spin_unlock_irqrestore(lock, flags);
+
+			list_for_each_entry_safe(bssprio_node, tmp_node, head,
+						 list) {
+				if (bssprio_node->priv == priv) {
+					dev_dbg(adapter->dev, "info: Delete "
+						"node %p, next = %p\n",
+						bssprio_node, tmp_node);
+					spin_lock_irqsave(lock, flags);
+					list_del(&bssprio_node->list);
+					spin_unlock_irqrestore(lock, flags);
+					kfree(bssprio_node);
+				}
+			}
+			*cur = (struct mwifiex_bss_prio_node *)head;
+		}
+	}
+}
+
+/*
  * This function is used to shutdown the driver.
  *
  * The following operations are performed sequentially -
@@ -619,54 +668,3 @@ done:
 	adapter->if_ops.enable_int(adapter);
 	return ret;
 }
-
-/*
- * This function deletes the BSS priority tables.
- *
- * The function traverses through all the allocated BSS priority nodes
- * in every BSS priority table and frees them.
- */
-void
-mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
-{
-	int i;
-	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_bss_prio_node *bssprio_node = NULL, *tmp_node = NULL,
-								**cur = NULL;
-	struct list_head *head;
-	spinlock_t *lock;
-	unsigned long flags;
-
-	for (i = 0; i < adapter->priv_num; ++i) {
-		head = &adapter->bss_prio_tbl[i].bss_prio_head;
-		cur = &adapter->bss_prio_tbl[i].bss_prio_cur;
-		lock = &adapter->bss_prio_tbl[i].bss_prio_lock;
-		dev_dbg(adapter->dev, "info: delete BSS priority table,"
-				" index = %d, i = %d, head = %p, cur = %p\n",
-			      priv->bss_index, i, head, *cur);
-		if (*cur) {
-			spin_lock_irqsave(lock, flags);
-			if (list_empty(head)) {
-				spin_unlock_irqrestore(lock, flags);
-				continue;
-			}
-			bssprio_node = list_first_entry(head,
-					struct mwifiex_bss_prio_node, list);
-			spin_unlock_irqrestore(lock, flags);
-
-			list_for_each_entry_safe(bssprio_node, tmp_node, head,
-						 list) {
-				if (bssprio_node->priv == priv) {
-					dev_dbg(adapter->dev, "info: Delete "
-						"node %p, next = %p\n",
-						bssprio_node, tmp_node);
-					spin_lock_irqsave(lock, flags);
-					list_del(&bssprio_node->list);
-					spin_unlock_irqrestore(lock, flags);
-					kfree(bssprio_node);
-				}
-			}
-			*cur = (struct mwifiex_bss_prio_node *)head;
-		}
-	}
-}
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 0fc2203..b5d06c1 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -984,8 +984,7 @@ mwifiex_bss_index_to_priv(struct mwifiex_adapter *adapter, u8 bss_index)
  * It handles the main process, which in turn handles the complete
  * driver operations.
  */
-void
-mwifiex_main_work_queue(struct work_struct *work)
+static void mwifiex_main_work_queue(struct work_struct *work)
 {
 	struct mwifiex_adapter *adapter =
 		container_of(work, struct mwifiex_adapter, main_work);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index b74a9e6..df28e76 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -643,9 +643,6 @@ int mwifiex_recv_complete(struct mwifiex_adapter *,
 
 int mwifiex_recv_packet(struct mwifiex_adapter *, struct sk_buff *skb);
 
-void mwifiex_init_adapter(struct mwifiex_adapter *adapter);
-void mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv);
-
 int mwifiex_process_event(struct mwifiex_adapter *adapter);
 
 int mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
@@ -709,7 +706,6 @@ void mwifiex_hs_activated_event(struct mwifiex_private *priv,
 					u8 activated);
 int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp);
-void mwifiex_host_sleep_wakeup_event(struct mwifiex_private *priv);
 int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 			      struct sk_buff *skb);
 int mwifiex_sta_prepare_cmd(struct mwifiex_private *, uint16_t cmd_no,
@@ -726,10 +722,6 @@ int mwifiex_scan_networks(struct mwifiex_private *priv, void *wait_queue,
 			  u16 action,
 			  const struct mwifiex_user_scan_cfg
 			  *user_scan_in, struct mwifiex_scan_resp *);
-int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
-			       void *wait, u16 action,
-			       struct mwifiex_802_11_ssid *ssid,
-			       struct mwifiex_scan_resp *scan_resp);
 int mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
 			    struct host_cmd_ds_command *cmd,
 			    void *data_buf);
@@ -777,11 +769,6 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 int mwifiex_cmd_802_11_bg_scan_query(struct mwifiex_private *priv,
 				     struct host_cmd_ds_command *cmd,
 				     void *data_buf);
-int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
-				    struct host_cmd_ds_command *cmd,
-				    u16 cmd_action);
-int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
-				    struct host_cmd_ds_command *resp);
 struct mwifiex_chan_freq_power *
 			mwifiex_get_cfp_by_band_and_channel_from_cfg80211(
 						struct mwifiex_private *priv,
@@ -805,7 +792,6 @@ int mwifiex_get_rate_index(struct mwifiex_adapter *adapter,
 			   u16 *rateBitmap, int size);
 extern u16 region_code_index[MWIFIEX_MAX_REGION_CODE];
 void mwifiex_save_curr_bcn(struct mwifiex_private *priv);
-void mwifiex_restore_curr_bcn(struct mwifiex_private *priv);
 void mwifiex_free_curr_bcn(struct mwifiex_private *priv);
 int mwifiex_cmd_get_hw_spec(struct mwifiex_private *priv,
 			    struct host_cmd_ds_command *cmd);
@@ -947,9 +933,6 @@ int mwifiex_get_scan_table(struct mwifiex_private *priv,
 			   struct mwifiex_scan_resp *scanresp);
 int mwifiex_get_auth_mode(struct mwifiex_private *priv,
 			  u8 wait_option, u32 *auth_mode);
-int mwifiex_set_encrypt_mode(struct mwifiex_private *priv,
-			     u8 wait_option,
-			     u32 encrypt_mode);
 int mwifiex_get_encrypt_mode(struct mwifiex_private *priv,
 			     u8 wait_option,
 			     u32 *encrypt_mode);
@@ -1055,92 +1038,28 @@ int mwifiex_set_passphrase(struct mwifiex_private *priv, int action,
 int mwifiex_get_esupp_mode(struct mwifiex_private *priv,
 			   struct mwifiex_ds_esupp_mode *esupp_mode);
 
-int mwifiex_bss_ioctl_start(struct mwifiex_private *,
-			    struct mwifiex_wait_queue *,
-			    struct mwifiex_ssid_bssid *);
-int mwifiex_bss_ioctl_stop(struct mwifiex_private *,
-			   struct mwifiex_wait_queue *, u8 *);
 int mwifiex_bss_ioctl_mode(struct mwifiex_private *,
 			   struct mwifiex_wait_queue *,
 			   u16 action, int *mode);
 int mwifiex_bss_ioctl_channel(struct mwifiex_private *,
 			      u16 action,
 			      struct mwifiex_chan_freq_power *cfp);
-int mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *,
-				     struct mwifiex_wait_queue *,
-				     u16 action,
-				     struct mwifiex_multicast_list *);
-int mwifiex_bss_ioctl_mac_address(struct mwifiex_private *,
-				  struct mwifiex_wait_queue *,
-				  u8 action, u8 *mac);
 int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *,
 			       struct mwifiex_wait_queue *,
 			       struct mwifiex_ssid_bssid *);
-int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *,
-				   struct mwifiex_wait_queue *,
-				   u16 action, u16 *chan);
 int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *,
 				 u16 action,
 				 struct mwifiex_ds_band_cfg *);
-int mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *,
-				struct mwifiex_wait_queue *,
-				u16 action, u32 *);
 int mwifiex_snmp_mib_ioctl(struct mwifiex_private *,
 			   struct mwifiex_wait_queue *,
 			   u32 cmd_oid, u16 action, u32 *value);
-int mwifiex_get_info_stats(struct mwifiex_private *,
-			   struct mwifiex_wait_queue *,
-			   struct mwifiex_ds_get_stats *);
-int mwifiex_get_info_signal(struct mwifiex_private *,
-			    struct mwifiex_wait_queue *,
-			    struct mwifiex_ds_get_signal *);
-int mwifiex_get_info_ver_ext(struct mwifiex_private *,
-			     struct mwifiex_wait_queue *,
-			     struct mwifiex_ver_ext *);
 int mwifiex_get_bss_info(struct mwifiex_private *,
 			 struct mwifiex_bss_info *);
-int mwifiex_set_auth_mode(struct mwifiex_private *, u32);
-int mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *,
-				 struct mwifiex_wait_queue *,
-				 struct mwifiex_ds_esupp_mode *);
-int mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *,
-				  struct mwifiex_wait_queue *,
-				  struct mwifiex_ds_encrypt_key *,
-				  u16 action);
 int mwifiex_sec_ioctl_passphrase(struct mwifiex_private *,
 				 struct mwifiex_wait_queue *,
 				 struct mwifiex_ds_passphrase *,
 				 u16 action);
 
-int mwifiex_rate_ioctl_cfg(struct mwifiex_private *,
-			   struct mwifiex_wait_queue *,
-			   struct mwifiex_rate_cfg *);
-int mwifiex_power_ioctl_set_power(struct mwifiex_private *,
-				  struct mwifiex_wait_queue *,
-				  struct mwifiex_power_cfg *);
-int mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *,
-			     struct mwifiex_wait_queue *,
-			     u32 *, u16 action);
-int mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *, struct
-			    mwifiex_wait_queue *, u16 action,
-			    struct mwifiex_ds_hs_cfg *);
-int mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *,
-				struct mwifiex_wait_queue *,
-				struct mwifiex_ds_auto_ds *, u16);
-int mwifiex_pm_ioctl_sleep_pd(struct mwifiex_private *,
-			      struct mwifiex_wait_queue *,
-			      u32 *, u16);
-int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *,
-				 struct mwifiex_wait_queue *,
-				 struct mwifiex_ds_reg_rw *,
-				 u16 action);
-int mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_private *,
-				      struct mwifiex_wait_queue *,
-				      struct mwifiex_ds_read_eeprom *);
-int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *,
-			      struct mwifiex_ds_misc_gen_ie *,
-			      u16 action);
-
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
 void mwifiex_debugfs_remove(void);
@@ -1148,6 +1067,4 @@ void mwifiex_debugfs_remove(void);
 void mwifiex_dev_debugfs_init(struct mwifiex_private *priv);
 void mwifiex_dev_debugfs_remove(struct mwifiex_private *priv);
 #endif
-
-void mwifiex_main_work_queue(struct work_struct *work);
 #endif /* !_MWIFIEX_MAIN_H_ */
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index f5e1ab4..42bf9e0 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -265,58 +265,6 @@ int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 }
 
 /*
- * Sends IOCTL request to start a scan.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- *
- * Scan command can be issued for both normal scan and specific SSID
- * scan, depending upon whether an SSID is provided or not.
- */
-int mwifiex_request_scan(struct mwifiex_private *priv, u8 wait_option,
-			 struct mwifiex_802_11_ssid *req_ssid)
-{
-	int ret = 0;
-	struct mwifiex_wait_queue *wait = NULL;
-	int status = 0;
-
-	if (down_interruptible(&priv->async_sem)) {
-		dev_err(priv->adapter->dev, "%s: acquire semaphore\n",
-						__func__);
-		return -1;
-	}
-	priv->scan_pending_on_block = true;
-
-	/* Allocate wait request buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		ret = -1;
-		goto done;
-	}
-
-	if (req_ssid && req_ssid->ssid_len != 0)
-		/* Specific SSID scan */
-		status = mwifiex_scan_specific_ssid(priv, wait,
-						    HostCmd_ACT_GEN_SET,
-						    req_ssid, NULL);
-	else
-		/* Normal scan */
-		status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_SET,
-					       NULL, NULL);
-	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-	if (status == -1)
-		ret = -1;
-done:
-	if ((wait) && (status != -EINPROGRESS))
-		kfree(wait);
-	if (ret == -1) {
-		priv->scan_pending_on_block = false;
-		up(&priv->async_sem);
-	}
-	return ret;
-}
-
-/*
  * This function checks if ewpa is enabled in driver and scanned network is
  * compatible with it.
  */
@@ -2048,6 +1996,75 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 }
 
 /*
+ * This function restores a beacon buffer of the current BSS descriptor.
+ */
+static void mwifiex_restore_curr_bcn(struct mwifiex_private *priv)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_bssdescriptor *curr_bss =
+		&priv->curr_bss_params.bss_descriptor;
+	unsigned long flags;
+
+	if (priv->curr_bcn_buf &&
+	    ((adapter->bcn_buf_end + priv->curr_bcn_size) <
+	     (adapter->bcn_buf + sizeof(adapter->bcn_buf)))) {
+		spin_lock_irqsave(&priv->curr_bcn_buf_lock, flags);
+
+		/* restore the current beacon buffer */
+		memcpy(adapter->bcn_buf_end, priv->curr_bcn_buf,
+		       priv->curr_bcn_size);
+		curr_bss->beacon_buf = adapter->bcn_buf_end;
+		curr_bss->beacon_buf_size = priv->curr_bcn_size;
+		adapter->bcn_buf_end += priv->curr_bcn_size;
+
+		/* adjust the pointers in the current BSS descriptor */
+		if (curr_bss->bcn_wpa_ie)
+			curr_bss->bcn_wpa_ie =
+				(struct ieee_types_vendor_specific *)
+				(curr_bss->beacon_buf +
+				 curr_bss->wpa_offset);
+
+		if (curr_bss->bcn_rsn_ie)
+			curr_bss->bcn_rsn_ie = (struct ieee_types_generic *)
+				(curr_bss->beacon_buf +
+				 curr_bss->rsn_offset);
+
+		if (curr_bss->bcn_ht_cap)
+			curr_bss->bcn_ht_cap = (struct ieee80211_ht_cap *)
+				(curr_bss->beacon_buf +
+				 curr_bss->ht_cap_offset);
+
+		if (curr_bss->bcn_ht_info)
+			curr_bss->bcn_ht_info = (struct ieee80211_ht_info *)
+				(curr_bss->beacon_buf +
+				 curr_bss->ht_info_offset);
+
+		if (curr_bss->bcn_bss_co_2040)
+			curr_bss->bcn_bss_co_2040 =
+				(u8 *) (curr_bss->beacon_buf +
+				 curr_bss->bss_co_2040_offset);
+
+		if (curr_bss->bcn_ext_cap)
+			curr_bss->bcn_ext_cap = (u8 *) (curr_bss->beacon_buf +
+				 curr_bss->ext_cap_offset);
+
+		if (curr_bss->bcn_obss_scan)
+			curr_bss->bcn_obss_scan =
+				(struct ieee_types_obss_scan_param *)
+				(curr_bss->beacon_buf +
+				 curr_bss->overlap_bss_offset);
+
+		spin_unlock_irqrestore(&priv->curr_bcn_buf_lock, flags);
+
+		dev_dbg(adapter->dev, "info: current beacon restored %d\n",
+		       priv->curr_bcn_size);
+	} else {
+		dev_warn(adapter->dev,
+			"curr_bcn_buf not saved or bcn_buf has no space\n");
+	}
+}
+
+/*
  * This function post processes the scan table after a new scan command has
  * completed.
  *
@@ -2957,10 +2974,10 @@ int mwifiex_find_best_network(struct mwifiex_private *priv,
  * This function sends a scan command for all available channels to the
  * firmware, filtered on a specific SSID.
  */
-int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
-			       void *wait_buf, u16 action,
-			       struct mwifiex_802_11_ssid *req_ssid,
-			       struct mwifiex_scan_resp *scan_resp)
+static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
+				      void *wait_buf, u16 action,
+				      struct mwifiex_802_11_ssid *req_ssid,
+				      struct mwifiex_scan_resp *scan_resp)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret = 0;
@@ -3011,6 +3028,58 @@ int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 }
 
 /*
+ * Sends IOCTL request to start a scan.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ *
+ * Scan command can be issued for both normal scan and specific SSID
+ * scan, depending upon whether an SSID is provided or not.
+ */
+int mwifiex_request_scan(struct mwifiex_private *priv, u8 wait_option,
+			 struct mwifiex_802_11_ssid *req_ssid)
+{
+	int ret = 0;
+	struct mwifiex_wait_queue *wait = NULL;
+	int status = 0;
+
+	if (down_interruptible(&priv->async_sem)) {
+		dev_err(priv->adapter->dev, "%s: acquire semaphore\n",
+						__func__);
+		return -1;
+	}
+	priv->scan_pending_on_block = true;
+
+	/* Allocate wait request buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
+		ret = -1;
+		goto done;
+	}
+
+	if (req_ssid && req_ssid->ssid_len != 0)
+		/* Specific SSID scan */
+		status = mwifiex_scan_specific_ssid(priv, wait,
+						    HostCmd_ACT_GEN_SET,
+						    req_ssid, NULL);
+	else
+		/* Normal scan */
+		status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_SET,
+					       NULL, NULL);
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
+	if (status == -1)
+		ret = -1;
+done:
+	if ((wait) && (status != -EINPROGRESS))
+		kfree(wait);
+	if (ret == -1) {
+		priv->scan_pending_on_block = false;
+		up(&priv->async_sem);
+	}
+	return ret;
+}
+
+/*
  * This function appends the vendor specific IE TLV to a buffer.
  */
 int
@@ -3094,76 +3163,6 @@ mwifiex_save_curr_bcn(struct mwifiex_private *priv)
 }
 
 /*
- * This function restores a beacon buffer of the current BSS descriptor.
- */
-void
-mwifiex_restore_curr_bcn(struct mwifiex_private *priv)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_bssdescriptor *curr_bss =
-		&priv->curr_bss_params.bss_descriptor;
-	unsigned long flags;
-
-	if (priv->curr_bcn_buf &&
-	    ((adapter->bcn_buf_end + priv->curr_bcn_size) <
-	     (adapter->bcn_buf + sizeof(adapter->bcn_buf)))) {
-		spin_lock_irqsave(&priv->curr_bcn_buf_lock, flags);
-
-		/* restore the current beacon buffer */
-		memcpy(adapter->bcn_buf_end, priv->curr_bcn_buf,
-		       priv->curr_bcn_size);
-		curr_bss->beacon_buf = adapter->bcn_buf_end;
-		curr_bss->beacon_buf_size = priv->curr_bcn_size;
-		adapter->bcn_buf_end += priv->curr_bcn_size;
-
-		/* adjust the pointers in the current BSS descriptor */
-		if (curr_bss->bcn_wpa_ie)
-			curr_bss->bcn_wpa_ie =
-				(struct ieee_types_vendor_specific *)
-				(curr_bss->beacon_buf +
-				 curr_bss->wpa_offset);
-
-		if (curr_bss->bcn_rsn_ie)
-			curr_bss->bcn_rsn_ie = (struct ieee_types_generic *)
-				(curr_bss->beacon_buf +
-				 curr_bss->rsn_offset);
-
-		if (curr_bss->bcn_ht_cap)
-			curr_bss->bcn_ht_cap = (struct ieee80211_ht_cap *)
-				(curr_bss->beacon_buf +
-				 curr_bss->ht_cap_offset);
-
-		if (curr_bss->bcn_ht_info)
-			curr_bss->bcn_ht_info = (struct ieee80211_ht_info *)
-				(curr_bss->beacon_buf +
-				 curr_bss->ht_info_offset);
-
-		if (curr_bss->bcn_bss_co_2040)
-			curr_bss->bcn_bss_co_2040 =
-				(u8 *) (curr_bss->beacon_buf +
-				 curr_bss->bss_co_2040_offset);
-
-		if (curr_bss->bcn_ext_cap)
-			curr_bss->bcn_ext_cap = (u8 *) (curr_bss->beacon_buf +
-				 curr_bss->ext_cap_offset);
-
-		if (curr_bss->bcn_obss_scan)
-			curr_bss->bcn_obss_scan =
-				(struct ieee_types_obss_scan_param *)
-				(curr_bss->beacon_buf +
-				 curr_bss->overlap_bss_offset);
-
-		spin_unlock_irqrestore(&priv->curr_bcn_buf_lock, flags);
-
-		dev_dbg(adapter->dev, "info: current beacon restored %d\n",
-		       priv->curr_bcn_size);
-	} else {
-		dev_warn(adapter->dev,
-			"curr_bcn_buf not saved or bcn_buf has no space\n");
-	}
-}
-
-/*
  * This function frees the current BSS descriptor beacon buffer.
  */
 void
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 1f32560..a358713 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1250,82 +1250,6 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function downloads data from driver to card.
- *
- * Both commands and data packets are transferred to the card by this
- * function.
- *
- * This function adds the SDIO specific header to the front of the buffer
- * before transferring. The header contains the length of the packet and
- * the type. The firmware handles the packets based upon this set type.
- */
-static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
-				     u8 type, u8 *payload, u32 pkt_len,
-				     struct mwifiex_tx_param *tx_param)
-{
-	struct sdio_mmc_card *card = adapter->card;
-	int ret = 0;
-	u32 buf_block_len;
-	u32 blk_size;
-	u8 port = CTRL_PORT;
-
-	/* Allocate buffer and copy payload */
-	blk_size = MWIFIEX_SDIO_BLOCK_SIZE;
-	buf_block_len = (pkt_len + blk_size - 1) / blk_size;
-	*(u16 *) &payload[0] = (u16) pkt_len;
-	*(u16 *) &payload[2] = type;
-
-	/*
-	 * This is SDIO specific header
-	 *  u16 length,
-	 *  u16 type (MWIFIEX_TYPE_DATA = 0, MWIFIEX_TYPE_CMD = 1,
-	 *  MWIFIEX_TYPE_EVENT = 3)
-	 */
-	if (type == MWIFIEX_TYPE_DATA) {
-		ret = mwifiex_get_wr_port_data(adapter, &port);
-		if (ret) {
-			dev_err(adapter->dev, "%s: no wr_port available\n",
-						__func__);
-			return ret;
-		}
-	} else {
-		adapter->cmd_sent = true;
-		/* Type must be MWIFIEX_TYPE_CMD */
-
-		if (pkt_len <= INTF_HEADER_LEN ||
-		    pkt_len > MWIFIEX_UPLD_SIZE)
-			dev_err(adapter->dev, "%s: payload=%p, nb=%d\n",
-					__func__, payload, pkt_len);
-	}
-
-	/* Transfer data to card */
-	pkt_len = buf_block_len * blk_size;
-
-	if (tx_param)
-		ret = mwifiex_host_to_card_mp_aggr(adapter, payload, pkt_len,
-				port, tx_param->next_pkt_len);
-	else
-		ret = mwifiex_host_to_card_mp_aggr(adapter, payload, pkt_len,
-				port, 0);
-
-	if (ret) {
-		if (type == MWIFIEX_TYPE_CMD)
-			adapter->cmd_sent = false;
-		if (type == MWIFIEX_TYPE_DATA)
-			adapter->data_sent = false;
-	} else {
-		if (type == MWIFIEX_TYPE_DATA) {
-			if (!(card->mp_wr_bitmap & (1 << card->curr_wr_port)))
-				adapter->data_sent = true;
-			else
-				adapter->data_sent = false;
-		}
-	}
-
-	return ret;
-}
-
-/*
  * This function aggregates transmission buffers in driver and downloads
  * the aggregated packet to card.
  *
@@ -1339,9 +1263,9 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
  * stops, otherwise it will just aggregate the packet in aggregation buffer
  * and return.
  */
-int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
-				 u8 *payload, u32 pkt_len, u8 port,
-				 u32 next_pkt_len)
+static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
+					u8 *payload, u32 pkt_len, u8 port,
+					u32 next_pkt_len)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	int ret = 0;
@@ -1452,9 +1376,85 @@ tx_curr_single:
 }
 
 /*
+ * This function downloads data from driver to card.
+ *
+ * Both commands and data packets are transferred to the card by this
+ * function.
+ *
+ * This function adds the SDIO specific header to the front of the buffer
+ * before transferring. The header contains the length of the packet and
+ * the type. The firmware handles the packets based upon this set type.
+ */
+static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
+				     u8 type, u8 *payload, u32 pkt_len,
+				     struct mwifiex_tx_param *tx_param)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int ret = 0;
+	u32 buf_block_len;
+	u32 blk_size;
+	u8 port = CTRL_PORT;
+
+	/* Allocate buffer and copy payload */
+	blk_size = MWIFIEX_SDIO_BLOCK_SIZE;
+	buf_block_len = (pkt_len + blk_size - 1) / blk_size;
+	*(u16 *) &payload[0] = (u16) pkt_len;
+	*(u16 *) &payload[2] = type;
+
+	/*
+	 * This is SDIO specific header
+	 *  u16 length,
+	 *  u16 type (MWIFIEX_TYPE_DATA = 0, MWIFIEX_TYPE_CMD = 1,
+	 *  MWIFIEX_TYPE_EVENT = 3)
+	 */
+	if (type == MWIFIEX_TYPE_DATA) {
+		ret = mwifiex_get_wr_port_data(adapter, &port);
+		if (ret) {
+			dev_err(adapter->dev, "%s: no wr_port available\n",
+						__func__);
+			return ret;
+		}
+	} else {
+		adapter->cmd_sent = true;
+		/* Type must be MWIFIEX_TYPE_CMD */
+
+		if (pkt_len <= INTF_HEADER_LEN ||
+		    pkt_len > MWIFIEX_UPLD_SIZE)
+			dev_err(adapter->dev, "%s: payload=%p, nb=%d\n",
+					__func__, payload, pkt_len);
+	}
+
+	/* Transfer data to card */
+	pkt_len = buf_block_len * blk_size;
+
+	if (tx_param)
+		ret = mwifiex_host_to_card_mp_aggr(adapter, payload, pkt_len,
+				port, tx_param->next_pkt_len);
+	else
+		ret = mwifiex_host_to_card_mp_aggr(adapter, payload, pkt_len,
+				port, 0);
+
+	if (ret) {
+		if (type == MWIFIEX_TYPE_CMD)
+			adapter->cmd_sent = false;
+		if (type == MWIFIEX_TYPE_DATA)
+			adapter->data_sent = false;
+	} else {
+		if (type == MWIFIEX_TYPE_DATA) {
+			if (!(card->mp_wr_bitmap & (1 << card->curr_wr_port)))
+				adapter->data_sent = true;
+			else
+				adapter->data_sent = false;
+		}
+	}
+
+	return ret;
+}
+
+/*
  * This function allocates the MPA Tx and Rx buffers.
  */
-int mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
+static int mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
 				   u32 mpa_tx_buf_size, u32 mpa_rx_buf_size)
 {
 	struct sdio_mmc_card *card = adapter->card;
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index a5fffa3..8201270 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -278,17 +278,9 @@ struct mwifiex_sdio_mpa_rx {
 	u32 pkt_aggr_limit;
 };
 
-int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
-				 u8 *payload, u32 pkt_len,
-				 u8 port, u32 next_pkt_len);
-
 int mwifiex_bus_register(void);
 void mwifiex_bus_unregister(void);
 
-int mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *,
-				   u32 mpa_tx_buf_size,
-				   u32 mpa_rx_buf_size);
-
 struct sdio_mmc_card {
 	struct sdio_func *func;
 	struct mwifiex_adapter *adapter;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 2e7e2e7..9827651 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -854,9 +854,9 @@ static int mwifiex_cmd_802_11_supplicant_profile(
  *      - Setting domain information fields (for SET only)
  *      - Ensuring correct endian-ness
  */
-int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
-				    struct host_cmd_ds_command *cmd,
-				    u16 cmd_action)
+static int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
+					   struct host_cmd_ds_command *cmd,
+					   u16 cmd_action)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11d_domain_info *domain_info =
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 8c967cc..8e2c5bc 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -802,8 +802,8 @@ static int mwifiex_ret_802_11_supplicant_profile(struct mwifiex_private *priv,
 /*
  * This function handles the command response of get 11d domain information.
  */
-int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
-				    struct host_cmd_ds_command *resp)
+static int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
+					   struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_802_11d_domain_info_rsp *domain_info =
 		&resp->params.domain_info_resp;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index a0442e2..a570e8a 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -181,6 +181,32 @@ int mwifiex_request_ioctl(struct mwifiex_private *priv,
 EXPORT_SYMBOL_GPL(mwifiex_request_ioctl);
 
 /*
+ * IOCTL request handler to set/get MAC address.
+ *
+ * This function prepares the correct firmware command and
+ * issues it to get the extended version information.
+ */
+static int mwifiex_bss_ioctl_mac_address(struct mwifiex_private *priv,
+					 struct mwifiex_wait_queue *wait,
+					 u8 action, u8 *mac)
+{
+	int ret = 0;
+
+	if ((action == HostCmd_ACT_GEN_GET) && mac) {
+		memcpy(mac, priv->curr_addr, ETH_ALEN);
+		return 0;
+	}
+
+	/* Send request to firmware */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_MAC_ADDRESS,
+				  action, 0, wait, mac);
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
  * Sends IOCTL request to set MAC address.
  *
  * This function allocates the IOCTL request buffer, fills it
@@ -212,6 +238,79 @@ int mwifiex_request_set_mac_address(struct mwifiex_private *priv)
 }
 
 /*
+ * IOCTL request handler to set multicast list.
+ *
+ * This function prepares the correct firmware command and
+ * issues it to set the multicast list.
+ *
+ * This function can be used to enable promiscuous mode, or enable all
+ * multicast packets, or to enable selective multicast.
+ */
+static int
+mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
+				 struct mwifiex_wait_queue *wait,
+				 u16 action,
+				 struct mwifiex_multicast_list *mcast_list)
+{
+	int ret = 0;
+	u16 old_pkt_filter;
+
+	old_pkt_filter = priv->curr_pkt_filter;
+	if (action == HostCmd_ACT_GEN_GET)
+		return -1;
+
+	if (mcast_list->mode == MWIFIEX_PROMISC_MODE) {
+		dev_dbg(priv->adapter->dev, "info: Enable Promiscuous mode\n");
+		priv->curr_pkt_filter |= HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
+		priv->curr_pkt_filter &=
+			~HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
+	} else {
+		/* Multicast */
+		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
+		if (mcast_list->mode == MWIFIEX_MULTICAST_MODE) {
+			dev_dbg(priv->adapter->dev,
+				"info: Enabling All Multicast!\n");
+			priv->curr_pkt_filter |=
+				HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
+		} else {
+			priv->curr_pkt_filter &=
+				~HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
+			if (mcast_list->num_multicast_addr) {
+				dev_dbg(priv->adapter->dev,
+					"info: Set multicast list=%d\n",
+				       mcast_list->num_multicast_addr);
+				/* Set multicast addresses to firmware */
+				if (old_pkt_filter == priv->curr_pkt_filter) {
+					/* Send request to firmware */
+					ret = mwifiex_prepare_cmd(priv,
+						HostCmd_CMD_MAC_MULTICAST_ADR,
+						action, 0, wait, mcast_list);
+					if (!ret)
+						ret = -EINPROGRESS;
+				} else {
+					/* Send request to firmware */
+					ret = mwifiex_prepare_cmd(priv,
+						HostCmd_CMD_MAC_MULTICAST_ADR,
+						action, 0, NULL,
+						mcast_list);
+				}
+			}
+		}
+	}
+	dev_dbg(priv->adapter->dev,
+		"info: old_pkt_filter=%#x, curr_pkt_filter=%#x\n",
+	       old_pkt_filter, priv->curr_pkt_filter);
+	if (old_pkt_filter != priv->curr_pkt_filter) {
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL, action,
+					  0, wait, &priv->curr_pkt_filter);
+		if (!ret)
+			ret = -EINPROGRESS;
+	}
+
+	return ret;
+}
+
+/*
  * Sends IOCTL request to set multicast list.
  *
  * This function allocates the IOCTL request buffer, fills it
@@ -254,6 +353,15 @@ mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 }
 
 /*
+ * IOCTL request handler to disconnect from a BSS/IBSS.
+ */
+static int mwifiex_bss_ioctl_stop(struct mwifiex_private *priv,
+				  struct mwifiex_wait_queue *wait, u8 *mac)
+{
+	return mwifiex_deauthenticate(priv, wait, mac);
+}
+
+/*
  * Sends IOCTL request to disconnect from a BSS.
  *
  * This function allocates the IOCTL request buffer, fills it
@@ -279,6 +387,102 @@ int mwifiex_disconnect(struct mwifiex_private *priv, u8 wait_option, u8 *mac)
 EXPORT_SYMBOL_GPL(mwifiex_disconnect);
 
 /*
+ * IOCTL request handler to join a BSS/IBSS.
+ *
+ * In Ad-Hoc mode, the IBSS is created if not found in scan list.
+ * In both Ad-Hoc and infra mode, an deauthentication is performed
+ * first.
+ */
+static int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
+				   struct mwifiex_wait_queue *wait,
+				   struct mwifiex_ssid_bssid *ssid_bssid)
+{
+	int ret = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	s32 i = -1;
+
+	priv->scan_block = false;
+	if (!ssid_bssid)
+		return -1;
+
+	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) {
+		/* Infra mode */
+		ret = mwifiex_deauthenticate(priv, NULL, NULL);
+		if (ret)
+			return ret;
+
+		/* Search for the requested SSID in the scan table */
+		if (ssid_bssid->ssid.ssid_len)
+			i = mwifiex_find_ssid_in_list(priv, &ssid_bssid->ssid,
+						NULL, MWIFIEX_BSS_MODE_INFRA);
+		else
+			i = mwifiex_find_bssid_in_list(priv,
+						(u8 *) &ssid_bssid->bssid,
+						MWIFIEX_BSS_MODE_INFRA);
+		if (i < 0)
+			return -1;
+
+		dev_dbg(adapter->dev,
+			"info: SSID found in scan list ... associating...\n");
+
+		/* Clear any past association response stored for
+		 * application retrieval */
+		priv->assoc_rsp_size = 0;
+		ret = mwifiex_associate(priv, wait, &adapter->scan_table[i]);
+		if (ret)
+			return ret;
+	} else {
+		/* Adhoc mode */
+		/* If the requested SSID matches current SSID, return */
+		if (ssid_bssid->ssid.ssid_len &&
+		    (!mwifiex_ssid_cmp
+		     (&priv->curr_bss_params.bss_descriptor.ssid,
+		      &ssid_bssid->ssid)))
+			return 0;
+
+		/* Exit Adhoc mode first */
+		dev_dbg(adapter->dev, "info: Sending Adhoc Stop\n");
+		ret = mwifiex_deauthenticate(priv, NULL, NULL);
+		if (ret)
+			return ret;
+
+		priv->adhoc_is_link_sensed = false;
+
+		/* Search for the requested network in the scan table */
+		if (ssid_bssid->ssid.ssid_len)
+			i = mwifiex_find_ssid_in_list(priv,
+						      &ssid_bssid->ssid, NULL,
+						      MWIFIEX_BSS_MODE_IBSS);
+		else
+			i = mwifiex_find_bssid_in_list(priv,
+						       (u8 *)&ssid_bssid->bssid,
+						       MWIFIEX_BSS_MODE_IBSS);
+
+		if (i >= 0) {
+			dev_dbg(adapter->dev, "info: network found in scan"
+							" list. Joining...\n");
+			ret = mwifiex_adhoc_join(priv, wait,
+						 &adapter->scan_table[i]);
+			if (ret)
+				return ret;
+		} else {	/* i >= 0 */
+			dev_dbg(adapter->dev, "info: Network not found in "
+				"the list, creating adhoc with ssid = %s\n",
+			       ssid_bssid->ssid.ssid);
+			ret = mwifiex_adhoc_start(priv, wait,
+						  &ssid_bssid->ssid);
+			if (ret)
+				return ret;
+		}
+	}
+
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
  * Sends IOCTL request to connect with a BSS.
  *
  * This function allocates the IOCTL request buffer, fills it
@@ -312,41 +516,80 @@ int mwifiex_bss_start(struct mwifiex_private *priv, u8 wait_option,
 }
 
 /*
- * Sends IOCTL request to get the data rate.
+ * IOCTL request handler to set host sleep configuration.
  *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
+ * This function prepares the correct firmware command and
+ * issues it.
  */
-int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
-			      struct mwifiex_rate_cfg *rate)
+static int
+mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
+			struct mwifiex_wait_queue *wait,
+			u16 action, struct mwifiex_ds_hs_cfg *hs_cfg)
 {
-	int ret = 0;
-	struct mwifiex_wait_queue *wait = NULL;
-	u8 wait_option = MWIFIEX_IOCTL_WAIT;
-
-	/* Allocate wait buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
-	memset(rate, 0, sizeof(struct mwifiex_rate_cfg));
-	rate->action = HostCmd_ACT_GEN_GET;
-	rate->rate_type = MWIFIEX_RATE_VALUE;
-	ret = mwifiex_rate_ioctl_cfg(priv, wait, rate);
+	struct mwifiex_adapter *adapter = priv->adapter;
+	int status = 0;
+	u32 prev_cond = 0;
 
-	ret = mwifiex_request_ioctl(priv, wait, ret, wait_option);
-	if (!ret) {
-		if (rate && rate->is_rate_auto)
-			rate->rate = mwifiex_index_to_data_rate(priv->adapter,
-					priv->tx_rate, priv->tx_htinfo);
-		else if (rate)
-			rate->rate = priv->data_rate;
-	} else {
-		ret = -1;
+	switch (action) {
+	case HostCmd_ACT_GEN_SET:
+		if (adapter->pps_uapsd_mode) {
+			dev_dbg(adapter->dev, "info: Host Sleep IOCTL"
+				" is blocked in UAPSD/PPS mode\n");
+			status = -1;
+			break;
+		}
+		if (hs_cfg->is_invoke_hostcmd) {
+			if (hs_cfg->conditions == HOST_SLEEP_CFG_CANCEL) {
+				if (!adapter->is_hs_configured)
+					/* Already cancelled */
+					break;
+				/* Save previous condition */
+				prev_cond = le32_to_cpu(adapter->hs_cfg
+							.conditions);
+				adapter->hs_cfg.conditions =
+						cpu_to_le32(hs_cfg->conditions);
+			} else if (hs_cfg->conditions) {
+				adapter->hs_cfg.conditions =
+						cpu_to_le32(hs_cfg->conditions);
+				adapter->hs_cfg.gpio = (u8)hs_cfg->gpio;
+				if (hs_cfg->gap)
+					adapter->hs_cfg.gap = (u8)hs_cfg->gap;
+			} else if (adapter->hs_cfg.conditions ==
+						cpu_to_le32(
+						HOST_SLEEP_CFG_CANCEL)) {
+				/* Return failure if no parameters for HS
+				   enable */
+				status = -1;
+				break;
+			}
+			status = mwifiex_prepare_cmd(priv,
+					HostCmd_CMD_802_11_HS_CFG_ENH,
+					HostCmd_ACT_GEN_SET,
+					0, wait, &adapter->hs_cfg);
+			if (!status)
+				status = -EINPROGRESS;
+			if (hs_cfg->conditions == HOST_SLEEP_CFG_CANCEL)
+				/* Restore previous condition */
+				adapter->hs_cfg.conditions =
+						cpu_to_le32(prev_cond);
+		} else {
+			adapter->hs_cfg.conditions =
+				cpu_to_le32(hs_cfg->conditions);
+			adapter->hs_cfg.gpio = (u8)hs_cfg->gpio;
+			adapter->hs_cfg.gap = (u8)hs_cfg->gap;
+		}
+		break;
+	case HostCmd_ACT_GEN_GET:
+		hs_cfg->conditions = le32_to_cpu(adapter->hs_cfg.conditions);
+		hs_cfg->gpio = adapter->hs_cfg.gpio;
+		hs_cfg->gap = adapter->hs_cfg.gap;
+		break;
+	default:
+		status = -1;
+		break;
 	}
 
-	kfree(wait);
-	return ret;
+	return status;
 }
 
 /*
@@ -445,9 +688,9 @@ EXPORT_SYMBOL_GPL(mwifiex_enable_hs);
  *
  * This only works in the connected mode.
  */
-int mwifiex_get_info_signal(struct mwifiex_private *priv,
-			    struct mwifiex_wait_queue *wait,
-			    struct mwifiex_ds_get_signal *signal)
+static int mwifiex_get_info_signal(struct mwifiex_private *priv,
+				   struct mwifiex_wait_queue *wait,
+				   struct mwifiex_ds_get_signal *signal)
 {
 	int ret = 0;
 
@@ -479,7 +722,7 @@ int mwifiex_get_info_signal(struct mwifiex_private *priv,
  * This function prepares the correct firmware command and
  * issues it to get the statistics (RSSI) information.
  */
-int mwifiex_get_info_stats(struct mwifiex_private *priv,
+static int mwifiex_get_info_stats(struct mwifiex_private *priv,
 			   struct mwifiex_wait_queue *wait,
 			   struct mwifiex_ds_get_stats *log)
 {
@@ -580,9 +823,9 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
  * This function prepares the correct firmware command and
  * issues it to get the extended version information.
  */
-int mwifiex_get_info_ver_ext(struct mwifiex_private *priv,
-			     struct mwifiex_wait_queue *wait,
-			     struct mwifiex_ver_ext *ver_ext)
+static int mwifiex_get_info_ver_ext(struct mwifiex_private *priv,
+				    struct mwifiex_wait_queue *wait,
+				    struct mwifiex_ver_ext *ver_ext)
 {
 	int ret = 0;
 
@@ -713,9 +956,9 @@ int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
  * issues it. In addition, it performs validity checking on
  * user input data.
  */
-int mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *priv,
-				struct mwifiex_wait_queue *wait,
-				u16 action, u32 *antenna)
+static int mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *priv,
+				       struct mwifiex_wait_queue *wait,
+				       u16 action, u32 *antenna)
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -747,104 +990,6 @@ int mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *priv,
 }
 
 /*
- * IOCTL request handler to set/get MAC address.
- *
- * This function prepares the correct firmware command and
- * issues it to get the extended version information.
- */
-int mwifiex_bss_ioctl_mac_address(struct mwifiex_private *priv,
-				  struct mwifiex_wait_queue *wait,
-				  u8 action, u8 *mac)
-{
-	int ret = 0;
-
-	if ((action == HostCmd_ACT_GEN_GET) && mac) {
-		memcpy(mac, priv->curr_addr, ETH_ALEN);
-		return 0;
-	}
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_MAC_ADDRESS,
-				  action, 0, wait, mac);
-	if (!ret)
-		ret = -EINPROGRESS;
-
-	return ret;
-}
-
-/*
- * IOCTL request handler to set multicast list.
- *
- * This function prepares the correct firmware command and
- * issues it to set the multicast list.
- *
- * This function can be used to enable promiscuous mode, or enable all
- * multicast packets, or to enable selective multicast.
- */
-int mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
-				     struct mwifiex_wait_queue *wait,
-				     u16 action,
-				     struct mwifiex_multicast_list *mcast_list)
-{
-	int ret = 0;
-	u16 old_pkt_filter;
-
-	old_pkt_filter = priv->curr_pkt_filter;
-	if (action == HostCmd_ACT_GEN_GET)
-		return -1;
-
-	if (mcast_list->mode == MWIFIEX_PROMISC_MODE) {
-		dev_dbg(priv->adapter->dev, "info: Enable Promiscuous mode\n");
-		priv->curr_pkt_filter |= HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
-		priv->curr_pkt_filter &=
-			~HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
-	} else {
-		/* Multicast */
-		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
-		if (mcast_list->mode == MWIFIEX_MULTICAST_MODE) {
-			dev_dbg(priv->adapter->dev,
-				"info: Enabling All Multicast!\n");
-			priv->curr_pkt_filter |=
-				HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
-		} else {
-			priv->curr_pkt_filter &=
-				~HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
-			if (mcast_list->num_multicast_addr) {
-				dev_dbg(priv->adapter->dev,
-					"info: Set multicast list=%d\n",
-				       mcast_list->num_multicast_addr);
-				/* Set multicast addresses to firmware */
-				if (old_pkt_filter == priv->curr_pkt_filter) {
-					/* Send request to firmware */
-					ret = mwifiex_prepare_cmd(priv,
-						HostCmd_CMD_MAC_MULTICAST_ADR,
-						action, 0, wait, mcast_list);
-					if (!ret)
-						ret = -EINPROGRESS;
-				} else {
-					/* Send request to firmware */
-					ret = mwifiex_prepare_cmd(priv,
-						HostCmd_CMD_MAC_MULTICAST_ADR,
-						action, 0, NULL,
-						mcast_list);
-				}
-			}
-		}
-	}
-	dev_dbg(priv->adapter->dev,
-		"info: old_pkt_filter=%#x, curr_pkt_filter=%#x\n",
-	       old_pkt_filter, priv->curr_pkt_filter);
-	if (old_pkt_filter != priv->curr_pkt_filter) {
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL, action,
-					  0, wait, &priv->curr_pkt_filter);
-		if (!ret)
-			ret = -EINPROGRESS;
-	}
-
-	return ret;
-}
-
-/*
  * IOCTL request handler to set/get active channel.
  *
  * This function performs validity checking on channel/frequency
@@ -962,120 +1107,14 @@ int mwifiex_bss_ioctl_mode(struct mwifiex_private *priv,
 }
 
 /*
- * IOCTL request handler to join a BSS/IBSS.
- *
- * In Ad-Hoc mode, the IBSS is created if not found in scan list.
- * In both Ad-Hoc and infra mode, an deauthentication is performed
- * first.
- */
-int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
-			    struct mwifiex_wait_queue *wait,
-			    struct mwifiex_ssid_bssid *ssid_bssid)
-{
-	int ret = 0;
-	struct mwifiex_adapter *adapter = priv->adapter;
-	s32 i = -1;
-
-	priv->scan_block = false;
-	if (!ssid_bssid)
-		return -1;
-
-	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) {
-		/* Infra mode */
-		ret = mwifiex_deauthenticate(priv, NULL, NULL);
-		if (ret)
-			return ret;
-
-		/* Search for the requested SSID in the scan table */
-		if (ssid_bssid->ssid.ssid_len)
-			i = mwifiex_find_ssid_in_list(priv, &ssid_bssid->ssid,
-						NULL, MWIFIEX_BSS_MODE_INFRA);
-		else
-			i = mwifiex_find_bssid_in_list(priv,
-						(u8 *) &ssid_bssid->bssid,
-						MWIFIEX_BSS_MODE_INFRA);
-		if (i < 0)
-			return -1;
-
-		dev_dbg(adapter->dev,
-			"info: SSID found in scan list ... associating...\n");
-
-		/* Clear any past association response stored for
-		 * application retrieval */
-		priv->assoc_rsp_size = 0;
-		ret = mwifiex_associate(priv, wait, &adapter->scan_table[i]);
-		if (ret)
-			return ret;
-	} else {
-		/* Adhoc mode */
-		/* If the requested SSID matches current SSID, return */
-		if (ssid_bssid->ssid.ssid_len &&
-		    (!mwifiex_ssid_cmp
-		     (&priv->curr_bss_params.bss_descriptor.ssid,
-		      &ssid_bssid->ssid)))
-			return 0;
-
-		/* Exit Adhoc mode first */
-		dev_dbg(adapter->dev, "info: Sending Adhoc Stop\n");
-		ret = mwifiex_deauthenticate(priv, NULL, NULL);
-		if (ret)
-			return ret;
-
-		priv->adhoc_is_link_sensed = false;
-
-		/* Search for the requested network in the scan table */
-		if (ssid_bssid->ssid.ssid_len)
-			i = mwifiex_find_ssid_in_list(priv,
-						      &ssid_bssid->ssid, NULL,
-						      MWIFIEX_BSS_MODE_IBSS);
-		else
-			i = mwifiex_find_bssid_in_list(priv,
-						       (u8 *)&ssid_bssid->bssid,
-						       MWIFIEX_BSS_MODE_IBSS);
-
-		if (i >= 0) {
-			dev_dbg(adapter->dev, "info: network found in scan"
-							" list. Joining...\n");
-			ret = mwifiex_adhoc_join(priv, wait,
-						 &adapter->scan_table[i]);
-			if (ret)
-				return ret;
-		} else {	/* i >= 0 */
-			dev_dbg(adapter->dev, "info: Network not found in "
-				"the list, creating adhoc with ssid = %s\n",
-			       ssid_bssid->ssid.ssid);
-			ret = mwifiex_adhoc_start(priv, wait,
-						  &ssid_bssid->ssid);
-			if (ret)
-				return ret;
-		}
-	}
-
-	if (!ret)
-		ret = -EINPROGRESS;
-
-	return ret;
-}
-
-/*
- * IOCTL request handler to disconnect from a BSS/IBSS.
- */
-int mwifiex_bss_ioctl_stop(struct mwifiex_private *priv,
-			   struct mwifiex_wait_queue *wait,
-			   u8 *mac)
-{
-	return mwifiex_deauthenticate(priv, wait, mac);
-}
-
-/*
  * IOCTL request handler to set/get Ad-Hoc channel.
  *
  * This function prepares the correct firmware command and
  * issues it to set or get the ad-hoc channel.
  */
-int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
-				   struct mwifiex_wait_queue *wait,
-				   u16 action, u16 *channel)
+static int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
+					  struct mwifiex_wait_queue *wait,
+					  u16 action, u16 *channel)
 {
 	int ret = 0;
 
@@ -1495,9 +1534,9 @@ static int mwifiex_rate_ioctl_set_rate_index(struct mwifiex_private *priv,
  * This function can be used to set/get either the rate value or the
  * rate index.
  */
-int mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
-			   struct mwifiex_wait_queue *wait,
-			   struct mwifiex_rate_cfg *rate_cfg)
+static int mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
+				  struct mwifiex_wait_queue *wait,
+				  struct mwifiex_rate_cfg *rate_cfg)
 {
 	int status = 0;
 
@@ -1523,6 +1562,44 @@ int mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
 }
 
 /*
+ * Sends IOCTL request to get the data rate.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
+			      struct mwifiex_rate_cfg *rate)
+{
+	int ret = 0;
+	struct mwifiex_wait_queue *wait = NULL;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
+
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	memset(rate, 0, sizeof(struct mwifiex_rate_cfg));
+	rate->action = HostCmd_ACT_GEN_GET;
+	rate->rate_type = MWIFIEX_RATE_VALUE;
+	ret = mwifiex_rate_ioctl_cfg(priv, wait, rate);
+
+	ret = mwifiex_request_ioctl(priv, wait, ret, wait_option);
+	if (!ret) {
+		if (rate && rate->is_rate_auto)
+			rate->rate = mwifiex_index_to_data_rate(priv->adapter,
+					priv->tx_rate, priv->tx_htinfo);
+		else if (rate)
+			rate->rate = priv->data_rate;
+	} else {
+		ret = -1;
+	}
+
+	kfree(wait);
+	return ret;
+}
+
+/*
  * IOCTL request handler to set tx power configuration.
  *
  * This function prepares the correct firmware command and
@@ -1534,9 +1611,9 @@ int mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
  *      - Modulation class HTBW20
  *      - Modulation class HTBW40
  */
-int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
-				  struct mwifiex_wait_queue *wait,
-				  struct mwifiex_power_cfg *power_cfg)
+static int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
+					 struct mwifiex_wait_queue *wait,
+					 struct mwifiex_power_cfg *power_cfg)
 {
 	int ret = 0;
 	struct host_cmd_ds_txpwr_cfg *txp_cfg = NULL;
@@ -1624,9 +1701,9 @@ int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
  * This function prepares the correct firmware command and
  * issues it.
  */
-int mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
-			     struct mwifiex_wait_queue *wait,
-			     u32 *ps_mode, u16 action)
+static int mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
+				    struct mwifiex_wait_queue *wait,
+				    u32 *ps_mode, u16 action)
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -1656,91 +1733,16 @@ int mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
 }
 
 /*
- * IOCTL request handler to set host sleep configuration.
- *
- * This function prepares the correct firmware command and
- * issues it.
- */
-int mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
-			    struct mwifiex_wait_queue *wait,
-			    u16 action, struct mwifiex_ds_hs_cfg *hs_cfg)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	int status = 0;
-	u32 prev_cond = 0;
-
-	switch (action) {
-	case HostCmd_ACT_GEN_SET:
-		if (adapter->pps_uapsd_mode) {
-			dev_dbg(adapter->dev, "info: Host Sleep IOCTL"
-				" is blocked in UAPSD/PPS mode\n");
-			status = -1;
-			break;
-		}
-		if (hs_cfg->is_invoke_hostcmd) {
-			if (hs_cfg->conditions == HOST_SLEEP_CFG_CANCEL) {
-				if (!adapter->is_hs_configured)
-					/* Already cancelled */
-					break;
-				/* Save previous condition */
-				prev_cond = le32_to_cpu(adapter->hs_cfg
-							.conditions);
-				adapter->hs_cfg.conditions =
-						cpu_to_le32(hs_cfg->conditions);
-			} else if (hs_cfg->conditions) {
-				adapter->hs_cfg.conditions =
-						cpu_to_le32(hs_cfg->conditions);
-				adapter->hs_cfg.gpio = (u8)hs_cfg->gpio;
-				if (hs_cfg->gap)
-					adapter->hs_cfg.gap = (u8)hs_cfg->gap;
-			} else if (adapter->hs_cfg.conditions ==
-						cpu_to_le32(
-						HOST_SLEEP_CFG_CANCEL)) {
-				/* Return failure if no parameters for HS
-				   enable */
-				status = -1;
-				break;
-			}
-			status = mwifiex_prepare_cmd(priv,
-					HostCmd_CMD_802_11_HS_CFG_ENH,
-					HostCmd_ACT_GEN_SET,
-					0, wait, &adapter->hs_cfg);
-			if (!status)
-				status = -EINPROGRESS;
-			if (hs_cfg->conditions == HOST_SLEEP_CFG_CANCEL)
-				/* Restore previous condition */
-				adapter->hs_cfg.conditions =
-						cpu_to_le32(prev_cond);
-		} else {
-			adapter->hs_cfg.conditions =
-				cpu_to_le32(hs_cfg->conditions);
-			adapter->hs_cfg.gpio = (u8)hs_cfg->gpio;
-			adapter->hs_cfg.gap = (u8)hs_cfg->gap;
-		}
-		break;
-	case HostCmd_ACT_GEN_GET:
-		hs_cfg->conditions = le32_to_cpu(adapter->hs_cfg.conditions);
-		hs_cfg->gpio = adapter->hs_cfg.gpio;
-		hs_cfg->gap = adapter->hs_cfg.gap;
-		break;
-	default:
-		status = -1;
-		break;
-	}
-
-	return status;
-}
-
-/*
  * IOCTL request handler to set/get auto deep sleep mode.
  *
  * This function prepares the correct firmware command and
  * issues it.
  */
-int mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *priv,
-				struct mwifiex_wait_queue *wait,
-				struct mwifiex_ds_auto_ds *auto_deep_sleep,
-				u16 action)
+static int
+mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *priv,
+			    struct mwifiex_wait_queue *wait,
+			    struct mwifiex_ds_auto_ds *auto_deep_sleep,
+			    u16 action)
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -1794,9 +1796,9 @@ int mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *priv,
  * This function prepares the correct firmware command and
  * issues it.
  */
-int mwifiex_pm_ioctl_sleep_pd(struct mwifiex_private *priv,
-			      struct mwifiex_wait_queue *wait,
-			      u32 *sleep_period, u16 action)
+static int mwifiex_pm_ioctl_sleep_pd(struct mwifiex_private *priv,
+				     struct mwifiex_wait_queue *wait,
+				     u32 *sleep_period, u16 action)
 {
 	int ret = 0;
 
@@ -1909,7 +1911,7 @@ static int mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_adapter *adapter,
 /*
  * IOCTL request handler to set/get authentication mode.
  */
-int mwifiex_set_auth_mode(struct mwifiex_private *priv, u32 auth_mode)
+static int mwifiex_set_auth_mode(struct mwifiex_private *priv, u32 auth_mode)
 {
 	int ret = 0;
 
@@ -2149,10 +2151,11 @@ static int mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
  * This is a generic key handling function which supports WEP, WPA
  * and WAPI.
  */
-int mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *priv,
-				  struct mwifiex_wait_queue *wait,
-				  struct mwifiex_ds_encrypt_key *encrypt_key,
-				  u16 action)
+static int
+mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *priv,
+			      struct mwifiex_wait_queue *wait,
+			      struct mwifiex_ds_encrypt_key *encrypt_key,
+			      u16 action)
 {
 	int status = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -2233,9 +2236,10 @@ int mwifiex_sec_ioctl_passphrase(struct mwifiex_private *priv,
  * This function prepares corresponding firmware command and
  * issues it.
  */
-int mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *priv,
-				 struct mwifiex_wait_queue *wait,
-				 struct mwifiex_ds_esupp_mode *esupp_mode)
+static int
+mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *priv,
+			     struct mwifiex_wait_queue *wait,
+			     struct mwifiex_ds_esupp_mode *esupp_mode)
 {
 	int ret = 0;
 
@@ -2637,31 +2641,6 @@ mwifiex_set_tx_power(struct mwifiex_private *priv, int type, int dbm)
 }
 
 /*
- * Sends IOCTL request to set a generic IE.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len)
-{
-	struct mwifiex_ds_misc_gen_ie gen_ie;
-	int status = 0;
-
-	if (ie_len > IW_CUSTOM_MAX)
-		return -EFAULT;
-
-	gen_ie.type = MWIFIEX_IE_TYPE_GEN_IE;
-	gen_ie.len = ie_len;
-	memcpy(gen_ie.ie_data, ie, ie_len);
-	status = mwifiex_misc_ioctl_gen_ie(priv, &gen_ie, HostCmd_ACT_GEN_SET);
-	if (status)
-		return -EFAULT;
-
-	return 0;
-}
-
-/*
  * Sends IOCTL request to get scan table.
  *
  * This function allocates the IOCTL request buffer, fills it
@@ -2738,8 +2717,8 @@ int mwifiex_get_signal_info(struct mwifiex_private *priv, u8 wait_option,
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-int mwifiex_set_encrypt_mode(struct mwifiex_private *priv,
-			     u8 wait_option, u32 encrypt_mode)
+static int mwifiex_set_encrypt_mode(struct mwifiex_private *priv,
+				    u8 wait_option, u32 encrypt_mode)
 {
 	priv->sec_info.encryption_mode = encrypt_mode;
 	return 0;
@@ -2994,6 +2973,56 @@ mwifiex_get_stats_info(struct mwifiex_private *priv,
 }
 
 /*
+ * IOCTL request handler to read/write register.
+ *
+ * This function prepares the correct firmware command and
+ * issues it.
+ *
+ * Access to the following registers are supported -
+ *      - MAC
+ *      - BBP
+ *      - RF
+ *      - PMIC
+ *      - CAU
+ */
+static int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
+					struct mwifiex_wait_queue *wait,
+					struct mwifiex_ds_reg_rw *reg_rw,
+					u16 action)
+{
+	int ret = 0;
+	u16 cmd_no;
+
+	switch (le32_to_cpu(reg_rw->type)) {
+	case MWIFIEX_REG_MAC:
+		cmd_no = HostCmd_CMD_MAC_REG_ACCESS;
+		break;
+	case MWIFIEX_REG_BBP:
+		cmd_no = HostCmd_CMD_BBP_REG_ACCESS;
+		break;
+	case MWIFIEX_REG_RF:
+		cmd_no = HostCmd_CMD_RF_REG_ACCESS;
+		break;
+	case MWIFIEX_REG_PMIC:
+		cmd_no = HostCmd_CMD_PMIC_REG_ACCESS;
+		break;
+	case MWIFIEX_REG_CAU:
+		cmd_no = HostCmd_CMD_CAU_REG_ACCESS;
+		break;
+	default:
+		return -1;
+	}
+
+	/* Send request to firmware */
+	ret = mwifiex_prepare_cmd(priv, cmd_no, action, 0, wait, reg_rw);
+
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
  * Sends IOCTL request to write to a register.
  *
  * This function allocates the IOCTL request buffer, fills it
@@ -3060,6 +3089,29 @@ done:
 }
 
 /*
+ * IOCTL request handler to read EEPROM.
+ *
+ * This function prepares the correct firmware command and
+ * issues it.
+ */
+static int
+mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_private *priv,
+				  struct mwifiex_wait_queue *wait,
+				  struct mwifiex_ds_read_eeprom *rd_eeprom)
+{
+	int ret = 0;
+
+	/* Send request to firmware */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_EEPROM_ACCESS,
+				  HostCmd_ACT_GEN_GET, 0, wait, rd_eeprom);
+
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
  * Sends IOCTL request to read from EEPROM.
  *
  * This function allocates the IOCTL request buffer, fills it
@@ -3506,64 +3558,14 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 }
 
 /*
- * IOCTL request handler to read/write register.
- *
- * This function prepares the correct firmware command and
- * issues it.
- *
- * Access to the following registers are supported -
- *      - MAC
- *      - BBP
- *      - RF
- *      - PMIC
- *      - CAU
- */
-int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
-				 struct mwifiex_wait_queue *wait,
-				 struct mwifiex_ds_reg_rw *reg_rw,
-				 u16 action)
-{
-	int ret = 0;
-	u16 cmd_no;
-
-	switch (le32_to_cpu(reg_rw->type)) {
-	case MWIFIEX_REG_MAC:
-		cmd_no = HostCmd_CMD_MAC_REG_ACCESS;
-		break;
-	case MWIFIEX_REG_BBP:
-		cmd_no = HostCmd_CMD_BBP_REG_ACCESS;
-		break;
-	case MWIFIEX_REG_RF:
-		cmd_no = HostCmd_CMD_RF_REG_ACCESS;
-		break;
-	case MWIFIEX_REG_PMIC:
-		cmd_no = HostCmd_CMD_PMIC_REG_ACCESS;
-		break;
-	case MWIFIEX_REG_CAU:
-		cmd_no = HostCmd_CMD_CAU_REG_ACCESS;
-		break;
-	default:
-		return -1;
-	}
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, cmd_no, action, 0, wait, reg_rw);
-
-	if (!ret)
-		ret = -EINPROGRESS;
-
-	return ret;
-}
-
-/*
  * IOCTL request handler to set/get generic IE.
  *
  * In addition to various generic IEs, this function can also be
  * used to set the ARP filter.
  */
-int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
-			      struct mwifiex_ds_misc_gen_ie *gen_ie,
-			      u16 action)
+static int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
+				     struct mwifiex_ds_misc_gen_ie *gen_ie,
+				     u16 action)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 
@@ -3597,23 +3599,26 @@ int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
 }
 
 /*
- * IOCTL request handler to read EEPROM.
+ * Sends IOCTL request to set a generic IE.
  *
- * This function prepares the correct firmware command and
- * issues it.
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
  */
-int mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_private *priv,
-				      struct mwifiex_wait_queue *wait,
-				      struct mwifiex_ds_read_eeprom *rd_eeprom)
+int
+mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len)
 {
-	int ret = 0;
+	struct mwifiex_ds_misc_gen_ie gen_ie;
+	int status = 0;
 
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_EEPROM_ACCESS,
-				  HostCmd_ACT_GEN_GET, 0, wait, rd_eeprom);
+	if (ie_len > IW_CUSTOM_MAX)
+		return -EFAULT;
 
-	if (!ret)
-		ret = -EINPROGRESS;
+	gen_ie.type = MWIFIEX_IE_TYPE_GEN_IE;
+	gen_ie.len = ie_len;
+	memcpy(gen_ie.ie_data, ie, ie_len);
+	status = mwifiex_misc_ioctl_gen_ie(priv, &gen_ie, HostCmd_ACT_GEN_SET);
+	if (status)
+		return -EFAULT;
 
-	return ret;
+	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 7cda4f2..744e1bc 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -104,7 +104,7 @@ mwifiex_wmm_ac_debug_print(const struct ieee_types_wmm_ac_parameters *ac_param)
  *
  * The function also initializes the list with the provided RA.
  */
-struct mwifiex_ra_list_tbl *
+static struct mwifiex_ra_list_tbl *
 mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 {
 	struct mwifiex_ra_list_tbl *ra_list;
@@ -129,36 +129,6 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 }
 
 /*
- * This function cleans up the Tx and Rx queues.
- *
- * Cleanup includes -
- *      - All packets in RA lists
- *      - All entries in Rx reorder table
- *      - All entries in Tx BA stream table
- *      - MPA buffer (if required)
- *      - All RA lists
- */
-void
-mwifiex_clean_txrx(struct mwifiex_private *priv)
-{
-	unsigned long flags;
-
-	mwifiex_11n_cleanup_reorder_tbl(priv);
-	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
-
-	mwifiex_wmm_cleanup_queues(priv);
-	mwifiex_11n_delete_all_tx_ba_stream_tbl(priv);
-
-	if (priv->adapter->if_ops.cleanup_mpa_buf)
-		priv->adapter->if_ops.cleanup_mpa_buf(priv->adapter);
-
-	mwifiex_wmm_delete_all_ralist(priv);
-	memcpy(tos_to_tid, ac_to_tid, sizeof(tos_to_tid));
-
-	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
-}
-
-/*
  * This function allocates and adds a RA list for all TIDs
  * with the given RA.
  */
@@ -195,8 +165,7 @@ mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra)
 /*
  * This function sets the WMM queue priorities to their default values.
  */
-void
-mwifiex_wmm_default_queue_priorities(struct mwifiex_private *priv)
+static void mwifiex_wmm_default_queue_priorities(struct mwifiex_private *priv)
 {
 	/* Default queue priorities: VO->VI->BE->BK */
 	priv->wmm.queue_priority[0] = WMM_AC_VO;
@@ -494,8 +463,7 @@ mwifiex_wmm_del_pkts_in_ralist(struct mwifiex_private *priv,
 /*
  * This function deletes all packets in all RA lists.
  */
-void
-mwifiex_wmm_cleanup_queues(struct mwifiex_private *priv)
+static void mwifiex_wmm_cleanup_queues(struct mwifiex_private *priv)
 {
 	int i;
 
@@ -507,8 +475,7 @@ mwifiex_wmm_cleanup_queues(struct mwifiex_private *priv)
 /*
  * This function deletes all route addresses from all RA lists.
  */
-void
-mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv)
+static void mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv)
 {
 	struct mwifiex_ra_list_tbl *ra_list, *tmp_node;
 	int i;
@@ -529,6 +496,36 @@ mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv)
 }
 
 /*
+ * This function cleans up the Tx and Rx queues.
+ *
+ * Cleanup includes -
+ *      - All packets in RA lists
+ *      - All entries in Rx reorder table
+ *      - All entries in Tx BA stream table
+ *      - MPA buffer (if required)
+ *      - All RA lists
+ */
+void
+mwifiex_clean_txrx(struct mwifiex_private *priv)
+{
+	unsigned long flags;
+
+	mwifiex_11n_cleanup_reorder_tbl(priv);
+	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
+
+	mwifiex_wmm_cleanup_queues(priv);
+	mwifiex_11n_delete_all_tx_ba_stream_tbl(priv);
+
+	if (priv->adapter->if_ops.cleanup_mpa_buf)
+		priv->adapter->if_ops.cleanup_mpa_buf(priv->adapter);
+
+	mwifiex_wmm_delete_all_ralist(priv);
+	memcpy(tos_to_tid, ac_to_tid, sizeof(tos_to_tid));
+
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+}
+
+/*
  * This function retrieves a particular RA list node, matching with the
  * given TID and RA address.
  */
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index 3a45f0f..4de4e80 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -71,15 +71,11 @@ mwifiex_wmm_is_ra_list_empty(struct mwifiex_adapter *adapter,
 	return true;
 }
 
-struct mwifiex_ra_list_tbl *mwifiex_wmm_allocate_ralist_node(
-				struct mwifiex_adapter *adapter, u8 *ra);
 void mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 				 struct sk_buff *skb);
-void mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv);
 void mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra);
 
 int mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter);
-void mwifiex_wmm_cleanup_queues(struct mwifiex_private *priv);
 void mwifiex_wmm_process_tx(struct mwifiex_adapter *adapter);
 int mwifiex_is_ralist_valid(struct mwifiex_private *priv,
 			    struct mwifiex_ra_list_tbl *ra_list, int tid);
@@ -87,7 +83,6 @@ int mwifiex_is_ralist_valid(struct mwifiex_private *priv,
 u8 mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
 					     const struct sk_buff *skb);
 void mwifiex_wmm_init(struct mwifiex_adapter *adapter);
-void mwifiex_wmm_default_queue_priorities(struct mwifiex_private *priv);
 
 extern u32 mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
 						 u8 **assoc_buf,
-- 
1.7.0.2

