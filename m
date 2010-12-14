Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:37131 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab0LNDDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 22:03:33 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove timer wrapper functions
Date: Mon, 13 Dec 2010 19:03:32 -0800
Message-Id: <1292295812-18930-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kiran Divekar <dkiran@marvell.com>

All the timer wrapper functions are removed and replaced
by internal timer calls.

Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   53 ++++++++++++++----
 drivers/net/wireless/mwifiex/cmdevt.c        |   11 +++-
 drivers/net/wireless/mwifiex/init.c          |    4 +-
 drivers/net/wireless/mwifiex/main.c          |   45 +++++++++++++---
 drivers/net/wireless/mwifiex/main.h          |   11 +---
 drivers/net/wireless/mwifiex/util.c          |   73 --------------------------
 drivers/net/wireless/mwifiex/util.h          |   50 ------------------
 7 files changed, 90 insertions(+), 157 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index c7b9d2d..8fdb1fb 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -184,10 +184,14 @@ mwifiex_11n_delete_rx_reorder_tbl_entry(struct mwifiex_private *priv,
 						 &(MAX_TID_VALUE - 1));
 
 	if (rx_reor_tbl_ptr->timer_context.timer) {
-		if (rx_reor_tbl_ptr->timer_context.timer_is_set)
-			mwifiex_stop_timer(rx_reor_tbl_ptr->timer_context.
-					   timer);
-		mwifiex_free_timer(rx_reor_tbl_ptr->timer_context.timer);
+		if (rx_reor_tbl_ptr->timer_context.timer_is_set) {
+			del_timer(&rx_reor_tbl_ptr->timer_context.timer->tl);
+			rx_reor_tbl_ptr->timer_context.timer->timer_is_canceled
+					= true;
+			rx_reor_tbl_ptr->timer_context.timer->time_period = 0;
+		}
+
+		kfree(rx_reor_tbl_ptr->timer_context.timer);
 	}
 
 	PRINTM(MDAT_D, "Delete rx_reor_tbl_ptr: %p\n", rx_reor_tbl_ptr);
@@ -359,9 +363,25 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 		new_node->timer_context.priv = priv;
 		new_node->timer_context.timer_is_set = false;
 
-		mwifiex_init_timer(&new_node->timer_context.timer,
-				   mwifiex_flush_data,
-				   &new_node->timer_context);
+		new_node->timer_context.timer =
+			kmalloc(sizeof(struct mwifiex_drv_timer), GFP_KERNEL);
+		if (!new_node->timer_context.timer) {
+			LEAVE();
+			return;
+		}
+		init_timer(&new_node->timer_context.timer->tl);
+		new_node->timer_context.timer->tl.function =
+				mwifiex_timer_handler;
+		new_node->timer_context.timer->tl.data = (unsigned long)
+				new_node->timer_context.timer;
+
+		new_node->timer_context.timer->timer_function =
+				mwifiex_flush_data;
+		new_node->timer_context.timer->function_context =
+				&new_node->timer_context;
+		new_node->timer_context.timer->timer_is_canceled = true;
+		new_node->timer_context.timer->time_period = 0;
+		new_node->timer_context.timer->timer_is_periodic = false;
 
 		for (i = 0; i < win_size; ++i)
 			new_node->rx_reorder_ptr[i] = NULL;
@@ -534,11 +554,20 @@ mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 		start_win = rx_reor_tbl_ptr->start_win;
 		win_size = rx_reor_tbl_ptr->win_size;
 		end_win = ((start_win + win_size) - 1) & (MAX_TID_VALUE - 1);
-		if (rx_reor_tbl_ptr->timer_context.timer_is_set)
-			mwifiex_stop_timer(rx_reor_tbl_ptr->timer_context.
-					   timer);
-		mwifiex_start_timer(rx_reor_tbl_ptr->timer_context.timer,
-				    false, MIN_FLUSH_TIMER_MS * win_size);
+		if (rx_reor_tbl_ptr->timer_context.timer_is_set) {
+			del_timer(&rx_reor_tbl_ptr->timer_context.timer->tl);
+			rx_reor_tbl_ptr->timer_context.timer->timer_is_canceled
+					= true;
+			rx_reor_tbl_ptr->timer_context.timer->time_period = 0;
+		}
+		rx_reor_tbl_ptr->timer_context.timer->timer_is_periodic
+					= false;
+		rx_reor_tbl_ptr->timer_context.timer->time_period
+					= MIN_FLUSH_TIMER_MS * win_size;
+		mod_timer(&rx_reor_tbl_ptr->timer_context.timer->tl, jiffies
+			+ (MIN_FLUSH_TIMER_MS * win_size * HZ) / 1000);
+		rx_reor_tbl_ptr->timer_context.timer->timer_is_canceled
+					= false;
 		rx_reor_tbl_ptr->timer_context.timer_is_set = true;
 
 		PRINTM(MDAT_D, "TID %d, TA %02x:%02x:%02x:%02x:%02x:%02x\n",
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 509eab0..873de93 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -311,8 +311,11 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	cmd_code &= HostCmd_CMD_ID_MASK;
 
 	/* Setup the timer after transmit command */
-	mwifiex_start_timer(adapter->mwifiex_cmd_timer, false,
-			    MWIFIEX_TIMER_10S);
+	adapter->mwifiex_cmd_timer->timer_is_periodic = false;
+	adapter->mwifiex_cmd_timer->time_period = MWIFIEX_TIMER_10S;
+	mod_timer(&adapter->mwifiex_cmd_timer->tl,
+		jiffies + (MWIFIEX_TIMER_10S * HZ) / 1000);
+	adapter->mwifiex_cmd_timer->timer_is_canceled = false;
 
 	adapter->cmd_timer_is_set = true;
 
@@ -900,7 +903,9 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	/* Now we got response from FW, cancel the command timer */
 	if (adapter->cmd_timer_is_set) {
 		/* Cancel command timeout timer */
-		mwifiex_stop_timer(adapter->mwifiex_cmd_timer);
+		del_timer(&adapter->mwifiex_cmd_timer->tl);
+		adapter->mwifiex_cmd_timer->timer_is_canceled = true;
+		adapter->mwifiex_cmd_timer->time_period = 0;
 		/* Cancel command timeout timer */
 		adapter->cmd_timer_is_set = false;
 	}
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index d0a2556..51ce799 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -360,7 +360,9 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 
 	if (adapter->cmd_timer_is_set) {
 		/* Cancel command timeout timer */
-		mwifiex_stop_timer(adapter->mwifiex_cmd_timer);
+		del_timer(&adapter->mwifiex_cmd_timer->tl);
+		adapter->mwifiex_cmd_timer->timer_is_canceled = true;
+		adapter->mwifiex_cmd_timer->time_period = 0;
 		adapter->cmd_timer_is_set = false;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 00e5eab..686567e 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -149,12 +149,22 @@ mwifiex_register(void *card,
 	}
 
 	/* Initialize timers */
-	if (mwifiex_init_timer(&adapter->mwifiex_cmd_timer,
-			       mwifiex_cmd_timeout_func, adapter)
-	    != MWIFIEX_STATUS_SUCCESS) {
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto error;
+	adapter->mwifiex_cmd_timer =
+		kmalloc(sizeof(struct mwifiex_drv_timer), GFP_KERNEL);
+	if (!adapter->mwifiex_cmd_timer) {
+		LEAVE();
+		return MWIFIEX_STATUS_FAILURE;
 	}
+	init_timer(&adapter->mwifiex_cmd_timer->tl);
+	adapter->mwifiex_cmd_timer->tl.function = mwifiex_timer_handler;
+	adapter->mwifiex_cmd_timer->tl.data =
+			(unsigned long) adapter->mwifiex_cmd_timer;
+
+	adapter->mwifiex_cmd_timer->timer_function = mwifiex_cmd_timeout_func;
+	adapter->mwifiex_cmd_timer->function_context = adapter;
+	adapter->mwifiex_cmd_timer->timer_is_canceled = true;
+	adapter->mwifiex_cmd_timer->time_period = 0;
+	adapter->mwifiex_cmd_timer->timer_is_periodic = false;
 
 	/* Return pointer of struct mwifiex_adapter */
 	*padapter = adapter;
@@ -164,8 +174,17 @@ error:
 	PRINTM(MINFO, "Leave mwifiex_register with error\n");
 
 	/* Free timers */
-	if (adapter->mwifiex_cmd_timer)
-		mwifiex_free_timer(adapter->mwifiex_cmd_timer);
+	if (adapter->mwifiex_cmd_timer) {
+		if (!adapter->mwifiex_cmd_timer->timer_is_canceled
+			&& adapter->mwifiex_cmd_timer->time_period) {
+			PRINTM(MWARN, "mwifiex free timer w/o stop timer!\n");
+			del_timer(&adapter->mwifiex_cmd_timer->tl);
+			adapter->mwifiex_cmd_timer->timer_is_canceled = true;
+			adapter->mwifiex_cmd_timer->time_period = 0;
+		}
+		kfree(adapter->mwifiex_cmd_timer);
+	}
+
 	/* Free lock variables */
 	wlan_free_lock_list(adapter);
 	for (i = 0; i < MWIFIEX_MAX_BSS_NUM; i++)
@@ -197,8 +216,16 @@ mwifiex_unregister(struct mwifiex_adapter *adapter)
 	ENTER();
 
 	/* Free timers */
-	if (adapter->mwifiex_cmd_timer)
-		mwifiex_free_timer(adapter->mwifiex_cmd_timer);
+	if (adapter->mwifiex_cmd_timer) {
+		if (!adapter->mwifiex_cmd_timer->timer_is_canceled
+			&& adapter->mwifiex_cmd_timer->time_period) {
+			PRINTM(MWARN, "mwifiex free timer w/o stop timer!\n");
+			del_timer(&adapter->mwifiex_cmd_timer->tl);
+			adapter->mwifiex_cmd_timer->timer_is_canceled = true;
+			adapter->mwifiex_cmd_timer->time_period = 0;
+		}
+		kfree(adapter->mwifiex_cmd_timer);
+	}
 
 	/* Free lock variables */
 	wlan_free_lock_list(adapter);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 620616a..010a68a 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -482,7 +482,7 @@ struct mwifiex_tx_ba_stream_tbl {
 struct mwifiex_rx_reorder_tbl;
 
 struct reorder_tmr_cnxt {
-	void *timer;
+	struct mwifiex_drv_timer *timer;
 	u8 timer_is_set;
 	struct mwifiex_rx_reorder_tbl *ptr;
 	struct mwifiex_private *priv;
@@ -592,7 +592,7 @@ struct mwifiex_adapter {
 	void *mwifiex_cmd_lock;
 	u32 num_cmd_timeout;
 	u16 last_init_cmd;
-	void *mwifiex_cmd_timer;
+	struct mwifiex_drv_timer *mwifiex_cmd_timer;
 	u8 cmd_timer_is_set;
 	struct mwifiex_list_head cmd_free_q;
 	struct mwifiex_list_head cmd_pending_q;
@@ -704,13 +704,6 @@ enum mwifiex_status mwifiex_prepare_cmd(struct mwifiex_private *priv,
 
 void mwifiex_cmd_timeout_func(void *FunctionContext);
 
-enum mwifiex_status mwifiex_init_timer(void **timer,
-				       void (*callback) (void *context),
-				       void *context);
-enum mwifiex_status mwifiex_free_timer(void *timer);
-enum mwifiex_status mwifiex_start_timer(void *timer, u8 periodic,
-					u32 msec);
-enum mwifiex_status mwifiex_stop_timer(void *timer);
 enum mwifiex_status mwifiex_misc_ioctl_host_cmd(struct mwifiex_adapter
 						*adapter,
 						struct mwifiex_ioctl_req
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index e442efc..73fe3c4 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -268,79 +268,6 @@ mwifiex_util_dequeue_list(struct mwifiex_list_head *head, u8 lock_required)
 }
 
 /*
- * This function initializes a driver timer.
- */
-enum mwifiex_status
-mwifiex_init_timer(void **timer,
-		   void (*callback) (void *pcontext), void *pcontext)
-{
-	struct mwifiex_drv_timer *drv_timer = NULL;
-
-	drv_timer = (struct mwifiex_drv_timer *)
-		kmalloc(sizeof(struct mwifiex_drv_timer), GFP_KERNEL);
-	if (!drv_timer) {
-		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
-	}
-	mwifiex_initialize_timer(drv_timer, callback, pcontext);
-	*timer = (void *) drv_timer;
-
-	return MWIFIEX_STATUS_SUCCESS;
-}
-
-/*
- * This function frees a driver timer.
- */
-enum mwifiex_status
-mwifiex_free_timer(void *timer)
-{
-	struct mwifiex_drv_timer *drv_timer =
-		(struct mwifiex_drv_timer *) timer;
-
-	if (drv_timer) {
-		if (!drv_timer->timer_is_canceled && drv_timer->time_period) {
-			PRINTM(MWARN, "mwifiex try to free timer without stop"
-					" timer!\n");
-			mwifiex_cancel_timer(drv_timer);
-		}
-		kfree(drv_timer);
-	}
-
-	return MWIFIEX_STATUS_SUCCESS;
-}
-
-/*
- * This function starts a driver timer.
- */
-enum mwifiex_status
-mwifiex_start_timer(void *timer, u8 periodic, u32 msec)
-{
-	if (!timer)
-		return MWIFIEX_STATUS_FAILURE;
-
-	((struct mwifiex_drv_timer *) timer)->timer_is_periodic = periodic;
-	mwifiex_mod_timer((struct mwifiex_drv_timer *) timer, msec);
-
-	return MWIFIEX_STATUS_SUCCESS;
-}
-
-/*
- * This function stops a driver timer.
- */
-enum mwifiex_status
-mwifiex_stop_timer(void *timer)
-{
-
-	if (!timer) {
-		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
-	}
-	mwifiex_cancel_timer((struct mwifiex_drv_timer *) timer);
-
-	return MWIFIEX_STATUS_SUCCESS;
-}
-
-/*
  * IOCTL request handler to send a host command to firmware.
  *
  * This function prepares the correct firmware command and
diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
index f9c0e1c..aaae399 100644
--- a/drivers/net/wireless/mwifiex/util.h
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -193,54 +193,4 @@ mwifiex_timer_handler(unsigned long fcontext)
 	}
 }
 
-/*
- * This function initializes a timer.
- *
- * By default the timer is disabled with time period set to 0, and
- * periodic set to off.
- */
-static inline void
-mwifiex_initialize_timer(struct mwifiex_drv_timer *timer,
-			 void (*timer_function) (void *context),
-			 void *function_context)
-{
-	init_timer(&timer->tl);
-	timer->tl.function = mwifiex_timer_handler;
-	timer->tl.data = (unsigned long) timer;
-
-	timer->timer_function = timer_function;
-	timer->function_context = function_context;
-	timer->timer_is_canceled = true;
-	timer->time_period = 0;
-	timer->timer_is_periodic = false;
-}
-
-/*
- * This function modifies a timer.
- *
- * The time period value is set and the timer is started.
- */
-static inline void
-mwifiex_mod_timer(struct mwifiex_drv_timer *timer, u32 millisecond)
-{
-	timer->time_period = millisecond;
-	mod_timer(&timer->tl, jiffies + (millisecond * HZ) / 1000);
-	timer->timer_is_canceled = false;
-}
-
-/*
- * This function cancels a timer.
- *
- * The time period value is reset and the timer is cancelled.
- */
-static inline void
-mwifiex_cancel_timer(struct mwifiex_drv_timer *timer)
-{
-	del_timer(&timer->tl);
-	timer->timer_is_canceled = true;
-	timer->time_period = 0;
-}
-
-
-
 #endif /* !_MWIFIEX_UTIL_H_ */
-- 
1.7.0.2

