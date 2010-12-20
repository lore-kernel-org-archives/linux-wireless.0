Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:59748 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994Ab0LTT0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 14:26:47 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: remove struct mwifiex_drv_timer and associated
Date: Mon, 20 Dec 2010 11:26:47 -0800
Message-Id: <1292873207-9318-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1292873207-9318-1-git-send-email-bzhao@marvell.com>
References: <1292873207-9318-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The struct mwifiex_drv_timer and its allocations are unnecessary
as we can use struct timer_list directly. All stuff associated
with this structure also removed.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   53 ++++----------------------
 drivers/net/wireless/mwifiex/cmdevt.c        |   19 +--------
 drivers/net/wireless/mwifiex/init.c          |   10 +----
 drivers/net/wireless/mwifiex/main.c          |   44 ++-------------------
 drivers/net/wireless/mwifiex/main.h          |    8 +--
 drivers/net/wireless/mwifiex/sta_event.c     |    3 +-
 drivers/net/wireless/mwifiex/util.h          |   32 ---------------
 7 files changed, 20 insertions(+), 149 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 9d72135..8da7a29 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -185,16 +185,7 @@ mwifiex_11n_delete_rx_reorder_tbl_entry(struct mwifiex_private *priv,
 						  rx_reor_tbl_ptr->win_size)
 						 &(MAX_TID_VALUE - 1));
 
-	if (rx_reor_tbl_ptr->timer_context.timer) {
-		if (rx_reor_tbl_ptr->timer_context.timer_is_set) {
-			del_timer(&rx_reor_tbl_ptr->timer_context.timer->tl);
-			rx_reor_tbl_ptr->timer_context.timer->timer_is_canceled
-					= true;
-			rx_reor_tbl_ptr->timer_context.timer->time_period = 0;
-		}
-
-		kfree(rx_reor_tbl_ptr->timer_context.timer);
-	}
+	del_timer(&rx_reor_tbl_ptr->timer_context.timer);
 
 	PRINTM(MDAT_D, "Delete rx_reor_tbl_ptr: %p\n", rx_reor_tbl_ptr);
 	mwifiex_util_unlink_list(&priv->rx_reorder_tbl_ptr,
@@ -267,13 +258,12 @@ mwifiex_11n_find_last_seq_num(struct mwifiex_rx_reorder_tbl *rx_reorder_tbl_ptr)
  * them and then dumps the Rx reordering table.
  */
 static void
-mwifiex_flush_data(void *context)
+mwifiex_flush_data(unsigned long context)
 {
 	struct reorder_tmr_cnxt *reorder_cnxt =
 		(struct reorder_tmr_cnxt *) context;
 	int start_win;
 
-	reorder_cnxt->timer_is_set = false;
 	mwifiex_11n_display_tbl_ptr(reorder_cnxt->priv->adapter,
 				    reorder_cnxt->ptr);
 
@@ -363,27 +353,12 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 		PRINTM(MDAT_D, "Create ReorderPtr: %p\n", new_node);
 		new_node->timer_context.ptr = new_node;
 		new_node->timer_context.priv = priv;
-		new_node->timer_context.timer_is_set = false;
-
-		new_node->timer_context.timer =
-			kmalloc(sizeof(struct mwifiex_drv_timer), GFP_KERNEL);
-		if (!new_node->timer_context.timer) {
-			LEAVE();
-			return;
-		}
-		init_timer(&new_node->timer_context.timer->tl);
-		new_node->timer_context.timer->tl.function =
-				mwifiex_timer_handler;
-		new_node->timer_context.timer->tl.data = (unsigned long)
-				new_node->timer_context.timer;
 
-		new_node->timer_context.timer->timer_function =
+		init_timer(&new_node->timer_context.timer);
+		new_node->timer_context.timer.function =
 				mwifiex_flush_data;
-		new_node->timer_context.timer->function_context =
-				&new_node->timer_context;
-		new_node->timer_context.timer->timer_is_canceled = true;
-		new_node->timer_context.timer->time_period = 0;
-		new_node->timer_context.timer->timer_is_periodic = false;
+		new_node->timer_context.timer.data =
+				(unsigned long) &new_node->timer_context;
 
 		for (i = 0; i < win_size; ++i)
 			new_node->rx_reorder_ptr[i] = NULL;
@@ -556,21 +531,9 @@ mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 		start_win = rx_reor_tbl_ptr->start_win;
 		win_size = rx_reor_tbl_ptr->win_size;
 		end_win = ((start_win + win_size) - 1) & (MAX_TID_VALUE - 1);
-		if (rx_reor_tbl_ptr->timer_context.timer_is_set) {
-			del_timer(&rx_reor_tbl_ptr->timer_context.timer->tl);
-			rx_reor_tbl_ptr->timer_context.timer->timer_is_canceled
-					= true;
-			rx_reor_tbl_ptr->timer_context.timer->time_period = 0;
-		}
-		rx_reor_tbl_ptr->timer_context.timer->timer_is_periodic
-					= false;
-		rx_reor_tbl_ptr->timer_context.timer->time_period
-					= MIN_FLUSH_TIMER_MS * win_size;
-		mod_timer(&rx_reor_tbl_ptr->timer_context.timer->tl, jiffies
+		del_timer(&rx_reor_tbl_ptr->timer_context.timer);
+		mod_timer(&rx_reor_tbl_ptr->timer_context.timer, jiffies
 			+ (MIN_FLUSH_TIMER_MS * win_size * HZ) / 1000);
-		rx_reor_tbl_ptr->timer_context.timer->timer_is_canceled
-					= false;
-		rx_reor_tbl_ptr->timer_context.timer_is_set = true;
 
 		PRINTM(MDAT_D, "TID %d, TA %02x:%02x:%02x:%02x:%02x:%02x\n",
 		       tid, ta[0], ta[1], ta[2], ta[3], ta[4], ta[5]);
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index cfdf206..1f70cef 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -312,13 +312,8 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	cmd_code &= HostCmd_CMD_ID_MASK;
 
 	/* Setup the timer after transmit command */
-	adapter->mwifiex_cmd_timer->timer_is_periodic = false;
-	adapter->mwifiex_cmd_timer->time_period = MWIFIEX_TIMER_10S;
-	mod_timer(&adapter->mwifiex_cmd_timer->tl,
+	mod_timer(&adapter->cmd_timer,
 		jiffies + (MWIFIEX_TIMER_10S * HZ) / 1000);
-	adapter->mwifiex_cmd_timer->timer_is_canceled = false;
-
-	adapter->cmd_timer_is_set = true;
 
 	ret = MWIFIEX_STATUS_SUCCESS;
 
@@ -905,14 +900,7 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	ENTER();
 
 	/* Now we got response from FW, cancel the command timer */
-	if (adapter->cmd_timer_is_set) {
-		/* Cancel command timeout timer */
-		del_timer(&adapter->mwifiex_cmd_timer->tl);
-		adapter->mwifiex_cmd_timer->timer_is_canceled = true;
-		adapter->mwifiex_cmd_timer->time_period = 0;
-		/* Cancel command timeout timer */
-		adapter->cmd_timer_is_set = false;
-	}
+	del_timer(&adapter->cmd_timer);
 
 	if (!adapter->curr_cmd || !adapter->curr_cmd->resp_buf) {
 		resp = (struct host_cmd_ds_command *) adapter->upld_buf;
@@ -1044,7 +1032,7 @@ done:
  * It will re-send the same command again.
  */
 void
-mwifiex_cmd_timeout_func(void *function_context)
+mwifiex_cmd_timeout_func(unsigned long function_context)
 {
 	struct mwifiex_adapter *adapter =
 		(struct mwifiex_adapter *) function_context;
@@ -1055,7 +1043,6 @@ mwifiex_cmd_timeout_func(void *function_context)
 
 	ENTER();
 
-	adapter->cmd_timer_is_set = false;
 	adapter->num_cmd_timeout++;
 	adapter->dbg.num_cmd_timeout++;
 	if (!adapter->curr_cmd) {
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index b7fdd18..7b0b10c 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -231,8 +231,6 @@ mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->event_received = false;
 	adapter->data_received = false;
 
-	adapter->cmd_timer_is_set = false;
-
 	adapter->surprise_removed = false;
 
 	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
@@ -358,13 +356,7 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 	PRINTM(MINFO, "Free Command buffer\n");
 	mwifiex_free_cmd_buffer(adapter);
 
-	if (adapter->cmd_timer_is_set) {
-		/* Cancel command timeout timer */
-		del_timer(&adapter->mwifiex_cmd_timer->tl);
-		adapter->mwifiex_cmd_timer->timer_is_canceled = true;
-		adapter->mwifiex_cmd_timer->time_period = 0;
-		adapter->cmd_timer_is_set = false;
-	}
+	del_timer(&adapter->cmd_timer);
 
 	PRINTM(MINFO, "Free ScanTable\n");
 	kfree(adapter->scan_table);
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 4e1ac6f..6f03f95 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -148,23 +148,9 @@ mwifiex_register(void *card,
 		goto error;
 	}
 
-	/* Initialize timers */
-	adapter->mwifiex_cmd_timer =
-		kmalloc(sizeof(struct mwifiex_drv_timer), GFP_KERNEL);
-	if (!adapter->mwifiex_cmd_timer) {
-		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
-	}
-	init_timer(&adapter->mwifiex_cmd_timer->tl);
-	adapter->mwifiex_cmd_timer->tl.function = mwifiex_timer_handler;
-	adapter->mwifiex_cmd_timer->tl.data =
-			(unsigned long) adapter->mwifiex_cmd_timer;
-
-	adapter->mwifiex_cmd_timer->timer_function = mwifiex_cmd_timeout_func;
-	adapter->mwifiex_cmd_timer->function_context = adapter;
-	adapter->mwifiex_cmd_timer->timer_is_canceled = true;
-	adapter->mwifiex_cmd_timer->time_period = 0;
-	adapter->mwifiex_cmd_timer->timer_is_periodic = false;
+	init_timer(&adapter->cmd_timer);
+	adapter->cmd_timer.function = mwifiex_cmd_timeout_func;
+	adapter->cmd_timer.data = (unsigned long) adapter;
 
 	/* Return pointer of struct mwifiex_adapter */
 	*padapter = adapter;
@@ -173,18 +159,6 @@ mwifiex_register(void *card,
 error:
 	PRINTM(MINFO, "Leave mwifiex_register with error\n");
 
-	/* Free timers */
-	if (adapter->mwifiex_cmd_timer) {
-		if (!adapter->mwifiex_cmd_timer->timer_is_canceled
-			&& adapter->mwifiex_cmd_timer->time_period) {
-			PRINTM(MWARN, "mwifiex free timer w/o stop timer!\n");
-			del_timer(&adapter->mwifiex_cmd_timer->tl);
-			adapter->mwifiex_cmd_timer->timer_is_canceled = true;
-			adapter->mwifiex_cmd_timer->time_period = 0;
-		}
-		kfree(adapter->mwifiex_cmd_timer);
-	}
-
 	/* Free lock variables */
 	wlan_free_lock_list(adapter);
 	for (i = 0; i < MWIFIEX_MAX_BSS_NUM; i++)
@@ -215,17 +189,7 @@ mwifiex_unregister(struct mwifiex_adapter *adapter)
 
 	ENTER();
 
-	/* Free timers */
-	if (adapter->mwifiex_cmd_timer) {
-		if (!adapter->mwifiex_cmd_timer->timer_is_canceled
-			&& adapter->mwifiex_cmd_timer->time_period) {
-			PRINTM(MWARN, "mwifiex free timer w/o stop timer!\n");
-			del_timer(&adapter->mwifiex_cmd_timer->tl);
-			adapter->mwifiex_cmd_timer->timer_is_canceled = true;
-			adapter->mwifiex_cmd_timer->time_period = 0;
-		}
-		kfree(adapter->mwifiex_cmd_timer);
-	}
+	del_timer(&adapter->cmd_timer);
 
 	/* Free lock variables */
 	wlan_free_lock_list(adapter);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index f43372f..8e9fb0b 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -462,8 +462,7 @@ struct mwifiex_tx_ba_stream_tbl {
 struct mwifiex_rx_reorder_tbl;
 
 struct reorder_tmr_cnxt {
-	struct mwifiex_drv_timer *timer;
-	u8 timer_is_set;
+	struct timer_list timer;
 	struct mwifiex_rx_reorder_tbl *ptr;
 	struct mwifiex_private *priv;
 };
@@ -576,8 +575,7 @@ struct mwifiex_adapter {
 	spinlock_t mwifiex_cmd_lock;
 	u32 num_cmd_timeout;
 	u16 last_init_cmd;
-	struct mwifiex_drv_timer *mwifiex_cmd_timer;
-	u8 cmd_timer_is_set;
+	struct timer_list cmd_timer;
 	struct mwifiex_list_head cmd_free_q;
 	struct mwifiex_list_head cmd_pending_q;
 	struct mwifiex_list_head scan_pending_q;
@@ -686,7 +684,7 @@ enum mwifiex_status mwifiex_prepare_cmd(struct mwifiex_private *priv,
 					u32 cmd_oid,
 					void *ioctl_buf, void *data_buf);
 
-void mwifiex_cmd_timeout_func(void *FunctionContext);
+void mwifiex_cmd_timeout_func(unsigned long function_context);
 
 enum mwifiex_status mwifiex_misc_ioctl_host_cmd(struct mwifiex_adapter
 						*adapter,
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index f4384d5..4cd4169 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -119,8 +119,7 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 	adapter->tx_lock_flag = false;
 	adapter->pps_uapsd_mode = false;
 
-	if (adapter->num_cmd_timeout && adapter->curr_cmd &&
-	    !adapter->cmd_timer_is_set) {
+	if (adapter->num_cmd_timeout && adapter->curr_cmd) {
 		LEAVE();
 		return;
 	}
diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
index 9996398..12ba9f9 100644
--- a/drivers/net/wireless/mwifiex/util.h
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -149,36 +149,4 @@ mwifiex_util_free_list_head(struct mwifiex_list_head *head)
 	head->next = NULL;
 	head->prev = head->next;
 }
-
-struct mwifiex_drv_timer {
-	struct timer_list tl;
-	void (*timer_function) (void *context);
-	void *function_context;
-	u32 time_period;
-	u32 timer_is_periodic;
-	u32 timer_is_canceled;
-};
-
-/*
- * Timer handler.
- *
- * This function calls the timer callback function and reassigns the
- * timer if it is periodic.
- */
-static inline void
-mwifiex_timer_handler(unsigned long fcontext)
-{
-	struct mwifiex_drv_timer *timer = (struct mwifiex_drv_timer *) fcontext;
-
-	timer->timer_function(timer->function_context);
-
-	if (timer->timer_is_periodic) {
-		mod_timer(&timer->tl,
-			  jiffies + ((timer->time_period * HZ) / 1000));
-	} else {
-		timer->timer_is_canceled = true;
-		timer->time_period = 0;
-	}
-}
-
 #endif /* !_MWIFIEX_UTIL_H_ */
-- 
1.7.0.2

