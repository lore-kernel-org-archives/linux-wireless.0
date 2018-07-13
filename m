Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47098 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729667AbeGMMlL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jul 2018 08:41:11 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: use atomic bitops to represent adapter status variables
Date: Fri, 13 Jul 2018 17:56:35 +0530
Message-ID: <1531484795-5176-1-git-send-email-gbhat@marvell.com> (sfid-20180713_142648_045273_C5F20BC1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver is using boolean variables to maintain vairous status
information of adapter. These status variables are accessed by
multiple threads and there is a possibility of a race. To avoid
this, convert these variables to a set of bitops flags, to be
operated atomically.

Below variables of mwifiex_adapter are converted to bitop flags:
surprise_removed
is_cmd_timedout
is_suspended
is_hs_configured
hs_enabling

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c  |  3 ++-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c    | 34 +++++++++++++-----------
 drivers/net/wireless/marvell/mwifiex/debugfs.c   |  2 +-
 drivers/net/wireless/marvell/mwifiex/init.c      |  4 +--
 drivers/net/wireless/marvell/mwifiex/main.c      | 33 ++++++++++++-----------
 drivers/net/wireless/marvell/mwifiex/main.h      | 14 ++++++----
 drivers/net/wireless/marvell/mwifiex/pcie.c      | 12 ++++-----
 drivers/net/wireless/marvell/mwifiex/scan.c      |  3 ++-
 drivers/net/wireless/marvell/mwifiex/sdio.c      | 12 ++++-----
 drivers/net/wireless/marvell/mwifiex/sta_event.c |  3 ++-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c |  8 +++---
 drivers/net/wireless/marvell/mwifiex/sta_tx.c    |  2 +-
 drivers/net/wireless/marvell/mwifiex/usb.c       | 25 ++++++++---------
 drivers/net/wireless/marvell/mwifiex/util.c      |  6 +++--
 drivers/net/wireless/marvell/mwifiex/wmm.c       |  2 +-
 15 files changed, 91 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index c02e02c..adc8843 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2322,7 +2322,8 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 	if (priv->scan_block)
 		priv->scan_block = false;
 
-	if (adapter->surprise_removed || adapter->is_cmd_timedout) {
+	if (test_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags) ||
+	    test_bit(MWIFIEX_IS_CMD_TIMEDOUT, &adapter->work_flags)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: Ignore connection.\t"
 			    "Card removed or FW in bad state\n",
diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 9cfcdf6..60db2b9 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -372,7 +372,7 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 		adapter->ps_state = PS_STATE_SLEEP_CFM;
 
 	if (!le16_to_cpu(sleep_cfm_buf->resp_ctrl) &&
-	    (adapter->is_hs_configured &&
+	    (test_bit(MWIFIEX_IS_HS_CONFIGURED, &adapter->work_flags) &&
 	     !adapter->sleep_period.period)) {
 		adapter->pm_wakeup_card_req = true;
 		mwifiex_hs_activated_event(mwifiex_get_priv
@@ -564,25 +564,26 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 		return -1;
 	}
 
-	if (adapter->is_suspended) {
+	if (test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "PREP_CMD: device in suspended state\n");
 		return -1;
 	}
 
-	if (adapter->hs_enabling && cmd_no != HostCmd_CMD_802_11_HS_CFG_ENH) {
+	if (test_bit(MWIFIEX_IS_HS_ENABLING, &adapter->work_flags) &&
+	    cmd_no != HostCmd_CMD_802_11_HS_CFG_ENH) {
 		mwifiex_dbg(adapter, ERROR,
 			    "PREP_CMD: host entering sleep state\n");
 		return -1;
 	}
 
-	if (adapter->surprise_removed) {
+	if (test_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "PREP_CMD: card is removed\n");
 		return -1;
 	}
 
-	if (adapter->is_cmd_timedout) {
+	if (test_bit(MWIFIEX_IS_CMD_TIMEDOUT, &adapter->work_flags)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "PREP_CMD: FW is in bad state\n");
 		return -1;
@@ -789,7 +790,8 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 	if (priv && (host_cmd->command !=
 	     cpu_to_le16(HostCmd_CMD_802_11_HS_CFG_ENH))) {
 		if (adapter->hs_activated) {
-			adapter->is_hs_configured = false;
+			clear_bit(MWIFIEX_IS_HS_CONFIGURED,
+				  &adapter->work_flags);
 			mwifiex_hs_activated_event(priv, false);
 		}
 	}
@@ -825,7 +827,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		return -1;
 	}
 
-	adapter->is_cmd_timedout = 0;
+	clear_bit(MWIFIEX_IS_CMD_TIMEDOUT, &adapter->work_flags);
 
 	resp = (struct host_cmd_ds_command *) adapter->curr_cmd->resp_skb->data;
 	if (adapter->curr_cmd->cmd_flag & CMD_F_HOSTCMD) {
@@ -927,7 +929,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	struct mwifiex_adapter *adapter = from_timer(adapter, t, cmd_timer);
 	struct cmd_ctrl_node *cmd_node;
 
-	adapter->is_cmd_timedout = 1;
+	set_bit(MWIFIEX_IS_CMD_TIMEDOUT, &adapter->work_flags);
 	if (!adapter->curr_cmd) {
 		mwifiex_dbg(adapter, ERROR,
 			    "cmd: empty curr_cmd\n");
@@ -953,7 +955,8 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 		mwifiex_dbg(adapter, MSG,
 			    "is_cmd_timedout = %d\n",
-			    adapter->is_cmd_timedout);
+			    test_bit(MWIFIEX_IS_CMD_TIMEDOUT,
+				     &adapter->work_flags));
 		mwifiex_dbg(adapter, MSG,
 			    "num_tx_timeout = %d\n",
 			    adapter->dbg.num_tx_timeout);
@@ -1135,7 +1138,8 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 mwifiex_hs_activated_event(struct mwifiex_private *priv, u8 activated)
 {
 	if (activated) {
-		if (priv->adapter->is_hs_configured) {
+		if (test_bit(MWIFIEX_IS_HS_CONFIGURED,
+			     &priv->adapter->work_flags)) {
 			priv->adapter->hs_activated = true;
 			mwifiex_update_rxreor_flags(priv->adapter,
 						    RXREOR_FORCE_NO_DROP);
@@ -1186,11 +1190,11 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 			    phs_cfg->params.hs_config.gap);
 	}
 	if (conditions != HS_CFG_CANCEL) {
-		adapter->is_hs_configured = true;
+		set_bit(MWIFIEX_IS_HS_CONFIGURED, &adapter->work_flags);
 		if (adapter->iface_type == MWIFIEX_USB)
 			mwifiex_hs_activated_event(priv, true);
 	} else {
-		adapter->is_hs_configured = false;
+		clear_bit(MWIFIEX_IS_HS_CONFIGURED, &adapter->work_flags);
 		if (adapter->hs_activated)
 			mwifiex_hs_activated_event(priv, false);
 	}
@@ -1212,8 +1216,8 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 
 	adapter->if_ops.wakeup(adapter);
 	adapter->hs_activated = false;
-	adapter->is_hs_configured = false;
-	adapter->is_suspended = false;
+	clear_bit(MWIFIEX_IS_HS_CONFIGURED, &adapter->work_flags);
+	clear_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
 	mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
 						    MWIFIEX_BSS_ROLE_ANY),
 				   false);
@@ -1273,7 +1277,7 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 		return;
 	}
 	adapter->pm_wakeup_card_req = true;
-	if (adapter->is_hs_configured)
+	if (test_bit(MWIFIEX_IS_HS_CONFIGURED, &adapter->work_flags))
 		mwifiex_hs_activated_event(mwifiex_get_priv
 						(adapter, MWIFIEX_BSS_ROLE_ANY),
 					   true);
diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index 0745393..cce7025 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -813,7 +813,7 @@
 			      MWIFIEX_SYNC_CMD, &hscfg);
 
 	mwifiex_enable_hs(priv->adapter);
-	priv->adapter->hs_enabling = false;
+	clear_bit(MWIFIEX_IS_HS_ENABLING, &priv->adapter->work_flags);
 	ret = count;
 done:
 	kfree(buf);
diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index d239e92..4d2ff0a 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -233,7 +233,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->event_received = false;
 	adapter->data_received = false;
 
-	adapter->surprise_removed = false;
+	clear_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags);
 
 	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
 
@@ -270,7 +270,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 
 	adapter->curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
 
-	adapter->is_hs_configured = false;
+	clear_bit(MWIFIEX_IS_HS_CONFIGURED, &adapter->work_flags);
 	adapter->hs_cfg.conditions = cpu_to_le32(HS_CFG_COND_DEF);
 	adapter->hs_cfg.gpio = HS_CFG_GPIO_DEF;
 	adapter->hs_cfg.gap = HS_CFG_GAP_DEF;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 510f6b8..bcbacdb 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -404,7 +404,8 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 		    !skb_queue_empty(&adapter->tx_data_q)) {
 			mwifiex_process_tx_queue(adapter);
 			if (adapter->hs_activated) {
-				adapter->is_hs_configured = false;
+				clear_bit(MWIFIEX_IS_HS_CONFIGURED,
+					  &adapter->work_flags);
 				mwifiex_hs_activated_event
 					(mwifiex_get_priv
 					(adapter, MWIFIEX_BSS_ROLE_ANY),
@@ -420,7 +421,8 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 			(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA))) {
 			mwifiex_process_bypass_tx(adapter);
 			if (adapter->hs_activated) {
-				adapter->is_hs_configured = false;
+				clear_bit(MWIFIEX_IS_HS_CONFIGURED,
+					  &adapter->work_flags);
 				mwifiex_hs_activated_event
 					(mwifiex_get_priv
 					 (adapter, MWIFIEX_BSS_ROLE_ANY),
@@ -435,7 +437,8 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 			(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA))) {
 			mwifiex_wmm_process_tx(adapter);
 			if (adapter->hs_activated) {
-				adapter->is_hs_configured = false;
+				clear_bit(MWIFIEX_IS_HS_CONFIGURED,
+					  &adapter->work_flags);
 				mwifiex_hs_activated_event
 					(mwifiex_get_priv
 					 (adapter, MWIFIEX_BSS_ROLE_ANY),
@@ -647,7 +650,7 @@ static int _mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	if (adapter->if_ops.unregister_dev)
 		adapter->if_ops.unregister_dev(adapter);
 
-	adapter->surprise_removed = true;
+	set_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags);
 	mwifiex_terminate_workqueue(adapter);
 
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_READY) {
@@ -870,7 +873,7 @@ struct sk_buff *
 		    "data: %lu BSS(%d-%d): Data <= kernel\n",
 		    jiffies, priv->bss_type, priv->bss_num);
 
-	if (priv->adapter->surprise_removed) {
+	if (test_bit(MWIFIEX_SURPRISE_REMOVED, &priv->adapter->work_flags)) {
 		kfree_skb(skb);
 		priv->stats.tx_dropped++;
 		return 0;
@@ -1371,7 +1374,7 @@ static void mwifiex_rx_work_queue(struct work_struct *work)
 	struct mwifiex_adapter *adapter =
 		container_of(work, struct mwifiex_adapter, rx_work);
 
-	if (adapter->surprise_removed)
+	if (test_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags))
 		return;
 	mwifiex_process_rx(adapter);
 }
@@ -1387,7 +1390,7 @@ static void mwifiex_main_work_queue(struct work_struct *work)
 	struct mwifiex_adapter *adapter =
 		container_of(work, struct mwifiex_adapter, main_work);
 
-	if (adapter->surprise_removed)
+	if (test_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags))
 		return;
 	mwifiex_main_process(adapter);
 }
@@ -1404,7 +1407,7 @@ static void mwifiex_uninit_sw(struct mwifiex_adapter *adapter)
 	if (adapter->if_ops.disable_int)
 		adapter->if_ops.disable_int(adapter);
 
-	adapter->surprise_removed = true;
+	set_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags);
 	mwifiex_terminate_workqueue(adapter);
 	adapter->int_status = 0;
 
@@ -1492,11 +1495,11 @@ int mwifiex_shutdown_sw(struct mwifiex_adapter *adapter)
 		adapter->if_ops.up_dev(adapter);
 
 	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
-	adapter->surprise_removed = false;
+	clear_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags);
 	init_waitqueue_head(&adapter->init_wait_q);
-	adapter->is_suspended = false;
+	clear_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
 	adapter->hs_activated = false;
-	adapter->is_cmd_timedout = 0;
+	clear_bit(MWIFIEX_IS_CMD_TIMEDOUT, &adapter->work_flags);
 	init_waitqueue_head(&adapter->hs_activate_wait_q);
 	init_waitqueue_head(&adapter->cmd_wait_q.wait);
 	adapter->cmd_wait_q.status = 0;
@@ -1551,7 +1554,7 @@ int mwifiex_shutdown_sw(struct mwifiex_adapter *adapter)
 		adapter->if_ops.unregister_dev(adapter);
 
 err_kmalloc:
-	adapter->surprise_removed = true;
+	set_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags);
 	mwifiex_terminate_workqueue(adapter);
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_READY) {
 		mwifiex_dbg(adapter, ERROR,
@@ -1648,9 +1651,9 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
 	adapter->fw_done = fw_done;
 
 	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
-	adapter->surprise_removed = false;
+	clear_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags);
 	init_waitqueue_head(&adapter->init_wait_q);
-	adapter->is_suspended = false;
+	clear_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
 	adapter->hs_activated = false;
 	init_waitqueue_head(&adapter->hs_activate_wait_q);
 	init_waitqueue_head(&adapter->cmd_wait_q.wait);
@@ -1698,7 +1701,7 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
 	if (adapter->if_ops.unregister_dev)
 		adapter->if_ops.unregister_dev(adapter);
 err_registerdev:
-	adapter->surprise_removed = true;
+	set_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags);
 	mwifiex_terminate_workqueue(adapter);
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_READY) {
 		pr_debug("info: %s: shutdown mwifiex\n", __func__);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 69ac0a2..1f5d500 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -517,6 +517,14 @@ enum mwifiex_iface_work_flags {
 	MWIFIEX_IFACE_WORK_CARD_RESET,
 };
 
+enum mwifiex_adapter_work_flags {
+	MWIFIEX_SURPRISE_REMOVED,
+	MWIFIEX_IS_CMD_TIMEDOUT,
+	MWIFIEX_IS_SUSPENDED,
+	MWIFIEX_IS_HS_CONFIGURED,
+	MWIFIEX_IS_HS_ENABLING,
+};
+
 struct mwifiex_band_config {
 	u8 chan_band:2;
 	u8 chan_width:2;
@@ -875,7 +883,7 @@ struct mwifiex_adapter {
 	struct device *dev;
 	struct wiphy *wiphy;
 	u8 perm_addr[ETH_ALEN];
-	bool surprise_removed;
+	unsigned long work_flags;
 	u32 fw_release_number;
 	u8 intf_hdr_len;
 	u16 init_wait_q_woken;
@@ -929,7 +937,6 @@ struct mwifiex_adapter {
 	struct cmd_ctrl_node *curr_cmd;
 	/* spin lock for command */
 	spinlock_t mwifiex_cmd_lock;
-	u8 is_cmd_timedout;
 	u16 last_init_cmd;
 	struct timer_list cmd_timer;
 	struct list_head cmd_free_q;
@@ -979,13 +986,10 @@ struct mwifiex_adapter {
 	u16 pps_uapsd_mode;
 	u32 pm_wakeup_fw_try;
 	struct timer_list wakeup_timer;
-	u8 is_hs_configured;
 	struct mwifiex_hs_config_param hs_cfg;
 	u8 hs_activated;
 	u16 hs_activate_wait_q_woken;
 	wait_queue_head_t hs_activate_wait_q;
-	bool is_suspended;
-	bool hs_enabling;
 	u8 event_body[MAX_EVENT_SIZE];
 	u32 hw_dot_11n_dev_cap;
 	u8 hw_dev_mcs_support;
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 0c42b72..3fe81b2 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -170,7 +170,7 @@ static int mwifiex_pcie_suspend(struct device *dev)
 	if (!mwifiex_enable_hs(adapter)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "cmd: failed to suspend\n");
-		adapter->hs_enabling = false;
+		clear_bit(MWIFIEX_IS_HS_ENABLING, &adapter->work_flags);
 		mwifiex_disable_wake(adapter);
 		return -EFAULT;
 	}
@@ -178,8 +178,8 @@ static int mwifiex_pcie_suspend(struct device *dev)
 	flush_workqueue(adapter->workqueue);
 
 	/* Indicate device suspended */
-	adapter->is_suspended = true;
-	adapter->hs_enabling = false;
+	set_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
+	clear_bit(MWIFIEX_IS_HS_ENABLING, &adapter->work_flags);
 
 	return 0;
 }
@@ -207,13 +207,13 @@ static int mwifiex_pcie_resume(struct device *dev)
 
 	adapter = card->adapter;
 
-	if (!adapter->is_suspended) {
+	if (!test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
 		mwifiex_dbg(adapter, WARN,
 			    "Device already resumed\n");
 		return 0;
 	}
 
-	adapter->is_suspended = false;
+	clear_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
 
 	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
 			  MWIFIEX_ASYNC_CMD);
@@ -2430,7 +2430,7 @@ static irqreturn_t mwifiex_pcie_interrupt(int irq, void *context)
 	}
 	adapter = card->adapter;
 
-	if (adapter->surprise_removed)
+	if (test_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags))
 		goto exit;
 
 	if (card->msix_enable)
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 895b806..8e483b0 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1495,7 +1495,8 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 		return -EBUSY;
 	}
 
-	if (adapter->surprise_removed || adapter->is_cmd_timedout) {
+	if (test_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags) ||
+	    test_bit(MWIFIEX_IS_CMD_TIMEDOUT, &adapter->work_flags)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "Ignore scan. Card removed or firmware in bad state\n");
 		return -EFAULT;
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index dfdcbc4..d49fbd5 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -181,13 +181,13 @@ static int mwifiex_sdio_resume(struct device *dev)
 
 	adapter = card->adapter;
 
-	if (!adapter->is_suspended) {
+	if (test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
 		mwifiex_dbg(adapter, WARN,
 			    "device already resumed\n");
 		return 0;
 	}
 
-	adapter->is_suspended = false;
+	clear_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
 
 	/* Disable Host Sleep */
 	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
@@ -260,7 +260,7 @@ static int mwifiex_sdio_resume(struct device *dev)
 				MWIFIEX_SDIO_BLOCK_SIZE) : pkt_len;
 	u32 ioport = (port & MWIFIEX_SDIO_IO_PORT_MASK);
 
-	if (adapter->is_suspended) {
+	if (test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: not allowed while suspended\n", __func__);
 		return -1;
@@ -450,7 +450,7 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	if (!mwifiex_enable_hs(adapter)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "cmd: failed to suspend\n");
-		adapter->hs_enabling = false;
+		clear_bit(MWIFIEX_IS_HS_ENABLING, &adapter->work_flags);
 		mwifiex_disable_wake(adapter);
 		return -EFAULT;
 	}
@@ -460,8 +460,8 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
 
 	/* Indicate device suspended */
-	adapter->is_suspended = true;
-	adapter->hs_enabling = false;
+	set_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
+	clear_bit(MWIFIEX_IS_HS_ENABLING, &adapter->work_flags);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 03a6492..a327fc5 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -224,7 +224,8 @@ void mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code,
 	adapter->tx_lock_flag = false;
 	adapter->pps_uapsd_mode = false;
 
-	if (adapter->is_cmd_timedout && adapter->curr_cmd)
+	if (test_bit(MWIFIEX_IS_CMD_TIMEDOUT, &adapter->work_flags) &&
+	    adapter->curr_cmd)
 		return;
 	priv->media_connected = false;
 	mwifiex_dbg(adapter, MSG,
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 5414b75..b454b5f 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -419,7 +419,8 @@ int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
 		}
 		if (hs_cfg->is_invoke_hostcmd) {
 			if (hs_cfg->conditions == HS_CFG_CANCEL) {
-				if (!adapter->is_hs_configured)
+				if (!test_bit(MWIFIEX_IS_HS_CONFIGURED,
+					      &adapter->work_flags))
 					/* Already cancelled */
 					break;
 				/* Save previous condition */
@@ -535,7 +536,7 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 	memset(&hscfg, 0, sizeof(hscfg));
 	hscfg.is_invoke_hostcmd = true;
 
-	adapter->hs_enabling = true;
+	set_bit(MWIFIEX_IS_HS_ENABLING, &adapter->work_flags);
 	mwifiex_cancel_all_pending_cmd(adapter);
 
 	if (mwifiex_set_hs_params(mwifiex_get_priv(adapter,
@@ -601,7 +602,8 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 	else
 		info->wep_status = false;
 
-	info->is_hs_configured = adapter->is_hs_configured;
+	info->is_hs_configured = test_bit(MWIFIEX_IS_HS_CONFIGURED,
+					  &adapter->work_flags);
 	info->is_deep_sleep = adapter->is_deep_sleep;
 
 	return 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_tx.c b/drivers/net/wireless/marvell/mwifiex/sta_tx.c
index 620f865..37c24b9 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_tx.c
@@ -143,7 +143,7 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	int ret;
 	struct mwifiex_txinfo *tx_info = NULL;
 
-	if (adapter->surprise_removed)
+	if (test_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags))
 		return -1;
 
 	if (!priv->media_connected)
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 6e3cf98..532b5cb 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -181,7 +181,8 @@ static void mwifiex_usb_rx_complete(struct urb *urb)
 		atomic_dec(&card->rx_data_urb_pending);
 
 	if (recv_length) {
-		if (urb->status || (adapter->surprise_removed)) {
+		if (urb->status ||
+		    test_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags)) {
 			mwifiex_dbg(adapter, ERROR,
 				    "URB status is failed: %d\n", urb->status);
 			/* Do not free skb in case of command ep */
@@ -218,10 +219,10 @@ static void mwifiex_usb_rx_complete(struct urb *urb)
 				dev_kfree_skb_any(skb);
 		}
 	} else if (urb->status) {
-		if (!adapter->is_suspended) {
+		if (!test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
 			mwifiex_dbg(adapter, FATAL,
 				    "Card is removed: %d\n", urb->status);
-			adapter->surprise_removed = true;
+			set_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags);
 		}
 		dev_kfree_skb_any(skb);
 		return;
@@ -529,7 +530,7 @@ static int mwifiex_usb_suspend(struct usb_interface *intf, pm_message_t message)
 		return 0;
 	}
 
-	if (unlikely(adapter->is_suspended))
+	if (unlikely(test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)))
 		mwifiex_dbg(adapter, WARN,
 			    "Device already suspended\n");
 
@@ -537,19 +538,19 @@ static int mwifiex_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	if (!mwifiex_enable_hs(adapter)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "cmd: failed to suspend\n");
-		adapter->hs_enabling = false;
+		clear_bit(MWIFIEX_IS_HS_ENABLING, &adapter->work_flags);
 		return -EFAULT;
 	}
 
 
-	/* 'is_suspended' flag indicates device is suspended.
+	/* 'MWIFIEX_IS_SUSPENDED' bit indicates device is suspended.
 	 * It must be set here before the usb_kill_urb() calls. Reason
 	 * is in the complete handlers, urb->status(= -ENOENT) and
 	 * this flag is used in combination to distinguish between a
 	 * 'suspended' state and a 'disconnect' one.
 	 */
-	adapter->is_suspended = true;
-	adapter->hs_enabling = false;
+	set_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
+	clear_bit(MWIFIEX_IS_HS_ENABLING, &adapter->work_flags);
 
 	if (atomic_read(&card->rx_cmd_urb_pending) && card->rx_cmd.urb)
 		usb_kill_urb(card->rx_cmd.urb);
@@ -593,7 +594,7 @@ static int mwifiex_usb_resume(struct usb_interface *intf)
 	}
 	adapter = card->adapter;
 
-	if (unlikely(!adapter->is_suspended)) {
+	if (unlikely(!test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags))) {
 		mwifiex_dbg(adapter, WARN,
 			    "Device already resumed\n");
 		return 0;
@@ -602,7 +603,7 @@ static int mwifiex_usb_resume(struct usb_interface *intf)
 	/* Indicate device resumed. The netdev queue will be resumed only
 	 * after the urbs have been re-submitted
 	 */
-	adapter->is_suspended = false;
+	clear_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
 
 	if (!atomic_read(&card->rx_data_urb_pending))
 		for (i = 0; i < MWIFIEX_RX_DATA_URB; i++)
@@ -1163,13 +1164,13 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 	unsigned long flags;
 	int idx, ret;
 
-	if (adapter->is_suspended) {
+	if (test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: not allowed while suspended\n", __func__);
 		return -1;
 	}
 
-	if (adapter->surprise_removed) {
+	if (test_bit(MWIFIEX_SURPRISE_REMOVED, &adapter->work_flags)) {
 		mwifiex_dbg(adapter, ERROR, "%s: device removed\n", __func__);
 		return -1;
 	}
diff --git a/drivers/net/wireless/marvell/mwifiex/util.c b/drivers/net/wireless/marvell/mwifiex/util.c
index 6dd2128..f9b7153 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.c
+++ b/drivers/net/wireless/marvell/mwifiex/util.c
@@ -197,9 +197,11 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 		info->is_deep_sleep = adapter->is_deep_sleep;
 		info->pm_wakeup_card_req = adapter->pm_wakeup_card_req;
 		info->pm_wakeup_fw_try = adapter->pm_wakeup_fw_try;
-		info->is_hs_configured = adapter->is_hs_configured;
+		info->is_hs_configured = test_bit(MWIFIEX_IS_HS_CONFIGURED,
+						  &adapter->work_flags);
 		info->hs_activated = adapter->hs_activated;
-		info->is_cmd_timedout = adapter->is_cmd_timedout;
+		info->is_cmd_timedout = test_bit(MWIFIEX_IS_CMD_TIMEDOUT,
+						 &adapter->work_flags);
 		info->num_cmd_host_to_card_failure
 				= adapter->dbg.num_cmd_host_to_card_failure;
 		info->num_cmd_sleep_cfm_host_to_card_failure
diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.c b/drivers/net/wireless/marvell/mwifiex/wmm.c
index 936a0a8..407b993 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -599,7 +599,7 @@ static int mwifiex_free_ack_frame(int id, void *p, void *data)
 	memcpy(tos_to_tid, ac_to_tid, sizeof(tos_to_tid));
 
 	if (priv->adapter->if_ops.clean_pcie_ring &&
-	    !priv->adapter->surprise_removed)
+	    !test_bit(MWIFIEX_SURPRISE_REMOVED, &priv->adapter->work_flags))
 		priv->adapter->if_ops.clean_pcie_ring(priv->adapter);
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 
-- 
1.9.1
