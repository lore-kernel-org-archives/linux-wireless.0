Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:44397 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab0L2B7D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 20:59:03 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: remove un-needed functions
Date: Tue, 28 Dec 2010 17:59:22 -0800
Message-Id: <1293587963-26616-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kiran Divekar <dkiran@marvell.com>

There are a few dummy functions that are useless.
This patch removes them.

Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   26 -----------------------
 drivers/net/wireless/mwifiex/join.c          |    8 ++++--
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   14 ------------
 drivers/net/wireless/mwifiex/sta_event.c     |   29 +++++++------------------
 drivers/net/wireless/mwifiex/wmm.c           |   26 -----------------------
 drivers/net/wireless/mwifiex/wmm.h           |    2 -
 6 files changed, 13 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 8da7a29..dcfcb99 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -97,21 +97,6 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 }
 
 /*
- * This function dumps the complete Rx reorder table.
- */
-static void
-mwifiex_11n_display_tbl_ptr(struct mwifiex_adapter *adapter,
-			    struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr)
-{
-	ENTER();
-
-	DBG_HEXDUMP(MDAT_D, "Reorder ptr", rx_reor_tbl_ptr->rx_reorder_ptr,
-		    rx_reor_tbl_ptr->win_size);
-
-	LEAVE();
-}
-
-/*
  * This function dispatches all packets in the Rx reorder table until
  * a hole is found.
  *
@@ -264,9 +249,6 @@ mwifiex_flush_data(unsigned long context)
 		(struct reorder_tmr_cnxt *) context;
 	int start_win;
 
-	mwifiex_11n_display_tbl_ptr(reorder_cnxt->priv->adapter,
-				    reorder_cnxt->ptr);
-
 	start_win = mwifiex_11n_find_last_seq_num(reorder_cnxt->ptr);
 	if (start_win >= 0) {
 		PRINTM(MINFO, "Flush data %d\n", start_win);
@@ -275,9 +257,6 @@ mwifiex_flush_data(unsigned long context)
 				((reorder_cnxt->ptr->start_win +
 				  start_win + 1) & (MAX_TID_VALUE - 1)));
 	}
-
-	mwifiex_11n_display_tbl_ptr(reorder_cnxt->priv->adapter,
-				    reorder_cnxt->ptr);
 }
 
 /*
@@ -508,7 +487,6 @@ mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
 	int start_win, end_win, win_size;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_adapter *adapter = priv->adapter;
 	u16 pkt_index = 0;
 
 	ENTER();
@@ -609,15 +587,11 @@ mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 			rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index] = payload;
 		}
 
-		mwifiex_11n_display_tbl_ptr(adapter, rx_reor_tbl_ptr);
-
 		/*
 		 * Dispatch all packets sequentially from start_win until a
 		 * hole is found and adjust the start_win appropriately
 		 */
 		ret = mwifiex_11n_scan_and_dispatch(priv, rx_reor_tbl_ptr);
-
-		mwifiex_11n_display_tbl_ptr(adapter, rx_reor_tbl_ptr);
 	}
 
 	LEAVE();
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 9504107..2bdecdb 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -773,14 +773,16 @@ mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	if (priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled)
 		priv->wpa_is_gtk_set = false;
 
-	if (priv->wmm_enabled)
+	if (priv->wmm_enabled) {
 		/* Don't re-enable carrier until we get the WMM_GET_STATUS
 		   event */
 		enable_data = false;
-	else
+	} else {
 		/* Since WMM is not enabled, setup the queues with the
 		   defaults */
-		mwifiex_wmm_setup_queues(priv);
+		mwifiex_wmm_setup_queue_priorities(priv, NULL);
+		mwifiex_wmm_setup_ac_downgrade(priv);
+	}
 
 	if (enable_data)
 		PRINTM(MINFO, "Post association, re-enabling data flow\n");
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index c1b646e..aba9778 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -189,19 +189,6 @@ mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 }
 
 /*
- * This function handles the command response of MAC control
- */
-static enum mwifiex_status
-mwifiex_ret_mac_control(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *resp,
-			struct mwifiex_ioctl_req *ioctl_buf)
-{
-	ENTER();
-	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
-}
-
-/*
  * This function handles the command response of set/get SNMP
  * MIB parameters.
  *
@@ -1408,7 +1395,6 @@ mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 		ret = mwifiex_ret_get_hw_spec(priv, resp, ioctl_buf);
 		break;
 	case HostCmd_CMD_MAC_CONTROL:
-		ret = mwifiex_ret_mac_control(priv, resp, ioctl_buf);
 		break;
 	case HostCmd_CMD_802_11_MAC_ADDRESS:
 		ret = mwifiex_ret_802_11_mac_address(priv, resp, ioctl_buf);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 4cd4169..0c127f4 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -129,22 +129,6 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 }
 
 /*
- * This function handles link lost, deauthenticated and disassociated
- * events.
- *
- * If media status was connected, it resets the connection state.
- */
-static void
-mwifiex_handle_disconnect_event(struct mwifiex_private *priv)
-{
-	ENTER();
-	if (priv->media_connected)
-		mwifiex_reset_connect_state(priv);
-
-	LEAVE();
-}
-
-/*
  * This function sends the OBSS scan parameters to the application.
  *
  * The scan parameters are copied into a new event body and the event
@@ -256,19 +240,22 @@ mwifiex_process_sta_event(struct mwifiex_private *priv)
 	case EVENT_DEAUTHENTICATED:
 		PRINTM(MEVENT, "EVENT: Deauthenticated\n");
 		adapter->dbg.num_event_deauth++;
-		mwifiex_handle_disconnect_event(priv);
+		if (priv->media_connected)
+			mwifiex_reset_connect_state(priv);
 		break;
 
 	case EVENT_DISASSOCIATED:
 		PRINTM(MEVENT, "EVENT: Disassociated\n");
 		adapter->dbg.num_event_disassoc++;
-		mwifiex_handle_disconnect_event(priv);
+		if (priv->media_connected)
+			mwifiex_reset_connect_state(priv);
 		break;
 
 	case EVENT_LINK_LOST:
 		PRINTM(MEVENT, "EVENT: Link lost\n");
 		adapter->dbg.num_event_link_lost++;
-		mwifiex_handle_disconnect_event(priv);
+		if (priv->media_connected)
+			mwifiex_reset_connect_state(priv);
 		break;
 
 	case EVENT_PS_SLEEP:
@@ -369,8 +356,8 @@ mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_WMM_STATUS_CHANGE:
 		PRINTM(MEVENT, "EVENT: WMM status changed\n");
-		ret = (enum mwifiex_status)
-			mwifiex_cmd_wmm_status_change(priv);
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_WMM_GET_STATUS,
+				0, 0, NULL, NULL);
 		break;
 
 	case EVENT_RSSI_LOW:
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 4cdaaa4..cdb0e58 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -506,32 +506,6 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function sets up the queue priorities and downgrades any queues
- * as required by the WMM information.
- *
- * This also sets up default values if WMM is not active for this association.
- */
-void
-mwifiex_wmm_setup_queues(struct mwifiex_private *priv)
-{
-	ENTER();
-	mwifiex_wmm_setup_queue_priorities(priv, NULL);
-	mwifiex_wmm_setup_ac_downgrade(priv);
-	LEAVE();
-}
-
-/*
- * This function sends a command to firmware to retrieve the current WMM
- * status.
- */
-int
-mwifiex_cmd_wmm_status_change(struct mwifiex_private *priv)
-{
-	return mwifiex_prepare_cmd(priv, HostCmd_CMD_WMM_GET_STATUS, 0, 0, NULL,
-				   NULL);
-}
-
-/*
  * This function checks if WMM Tx queue is empty.
  */
 int
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index cd6d5cf..88f4480 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -89,7 +89,6 @@ void mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 void mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv);
 void mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra);
 
-int mwifiex_cmd_wmm_status_change(struct mwifiex_private *priv);
 int mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter);
 void mwifiex_wmm_cleanup_queues(struct mwifiex_private *priv);
 void mwifiex_wmm_process_tx(struct mwifiex_adapter *adapter);
@@ -100,7 +99,6 @@ u8 mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
 					     const struct mwifiex_buffer
 					     *mbuf);
 void mwifiex_wmm_init(struct mwifiex_adapter *adapter);
-extern void mwifiex_wmm_setup_queues(struct mwifiex_private *priv);
 void mwifiex_wmm_default_queue_priorities(struct mwifiex_private *priv);
 
 extern u32 mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
-- 
1.7.0.2

