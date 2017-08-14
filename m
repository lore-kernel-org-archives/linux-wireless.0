Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35525 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753089AbdHNMTN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 08:19:13 -0400
Received: by mail-pg0-f66.google.com with SMTP id l64so10435351pge.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Aug 2017 05:19:13 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH 2/3] mwifiex: device dump support for usb interface
Date: Mon, 14 Aug 2017 12:19:02 +0000
Message-Id: <1502713143-24373-2-git-send-email-huxinming820@gmail.com> (sfid-20170814_141916_487912_DD365EDC)
In-Reply-To: <1502713143-24373-1-git-send-email-huxinming820@gmail.com>
References: <1502713143-24373-1-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Firmware dump on usb interface is different with current
sdio/pcie chipset, which is based on register operation.

When firmware hang on usb interface, context dump will be
upload to host using 0x73 firmware debug event.

This patch store dump data from debug event and send to
userspace using device coredump API.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/fw.h        |  1 +
 drivers/net/wireless/marvell/mwifiex/init.c      |  3 ++
 drivers/net/wireless/marvell/mwifiex/main.h      |  2 ++
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 39 ++++++++++++++++++++++++
 4 files changed, 45 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 9e75522..610a3ea 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -568,6 +568,7 @@ enum mwifiex_channel_flags {
 #define EVENT_BG_SCAN_STOPPED           0x00000065
 #define EVENT_REMAIN_ON_CHAN_EXPIRED    0x0000005f
 #define EVENT_MULTI_CHAN_INFO           0x0000006a
+#define EVENT_FW_DUMP_INFO		0x00000073
 #define EVENT_TX_STATUS_REPORT		0x00000074
 #define EVENT_BT_COEX_WLAN_PARA_CHANGE	0X00000076
 
diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index e11919d..389d725 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -315,6 +315,8 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->active_scan_triggered = false;
 	setup_timer(&adapter->wakeup_timer, wakeup_timer_fn,
 		    (unsigned long)adapter);
+	setup_timer(&adapter->devdump_timer, mwifiex_upload_device_dump,
+		    (unsigned long)adapter);
 }
 
 /*
@@ -397,6 +399,7 @@ static void mwifiex_invalidate_lists(struct mwifiex_adapter *adapter)
 mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 {
 	del_timer(&adapter->wakeup_timer);
+	del_timer_sync(&adapter->devdump_timer);
 	mwifiex_cancel_all_pending_cmd(adapter);
 	wake_up_interruptible(&adapter->cmd_wait_q.wait);
 	wake_up_interruptible(&adapter->hs_activate_wait_q);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index e308b8a..6b00294 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1038,6 +1038,7 @@ struct mwifiex_adapter {
 	/* Device dump data/length */
 	char *devdump_data;
 	int devdump_len;
+	struct timer_list devdump_timer;
 };
 
 void mwifiex_process_tx_queue(struct mwifiex_adapter *adapter);
@@ -1680,6 +1681,7 @@ void mwifiex_process_multi_chan_event(struct mwifiex_private *priv,
 void mwifiex_multi_chan_resync(struct mwifiex_adapter *adapter);
 int mwifiex_set_mac_address(struct mwifiex_private *priv,
 			    struct net_device *dev);
+void mwifiex_devdump_tmo_func(unsigned long function_context);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 839df8a..bcf2fa2 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -586,6 +586,40 @@ void mwifiex_bt_coex_wlan_param_update_event(struct mwifiex_private *priv,
 		adapter->coex_rx_win_size);
 }
 
+static void
+mwifiex_fw_dump_info_event(struct mwifiex_private *priv,
+			   struct sk_buff *event_skb)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	if (adapter->iface_type != MWIFIEX_USB) {
+		mwifiex_dbg(adapter, MSG,
+			    "event is not on usb interface, ignore it\n");
+		return;
+	}
+
+	if (!adapter->devdump_data) {
+		/* When receive the first event, allocate device dump
+		 * buffer, dump driver info.
+		 */
+		adapter->devdump_data = vzalloc(MWIFIEX_FW_DUMP_SIZE);
+		if (!adapter->devdump_data) {
+			mwifiex_dbg(adapter, ERROR,
+				    "vzalloc devdump data failure!\n");
+			return;
+		}
+
+		mwifiex_drv_info_dump(adapter);
+	}
+
+	memmove(adapter->devdump_data + adapter->devdump_len,
+		adapter->event_body, event_skb->len - MWIFIEX_EVENT_HEADER_LEN);
+	adapter->devdump_len += (event_skb->len - MWIFIEX_EVENT_HEADER_LEN);
+	/* If no proceeded event arrive in 10s, upload device dump data*/
+	mod_timer(&adapter->devdump_timer,
+		  jiffies + msecs_to_jiffies(MWIFIEX_TIMER_10S));
+}
+
 /*
  * This function handles events generated by firmware.
  *
@@ -638,6 +672,7 @@ void mwifiex_bt_coex_wlan_param_update_event(struct mwifiex_private *priv,
  *      - EVENT_DELBA
  *      - EVENT_BA_STREAM_TIEMOUT
  *      - EVENT_AMSDU_AGGR_CTRL
+ *      - EVENT_FW_DUMP_INFO
  */
 int mwifiex_process_sta_event(struct mwifiex_private *priv)
 {
@@ -1009,6 +1044,10 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 					    adapter->event_skb->len -
 					    sizeof(eventcause));
 		break;
+	case EVENT_FW_DUMP_INFO:
+		mwifiex_dbg(adapter, EVENT, "event: firmware debug info\n");
+		mwifiex_fw_dump_info_event(priv, adapter->event_skb);
+		break;
 	/* Debugging event; not used, but let's not print an ERROR for it. */
 	case EVENT_UNKNOWN_DEBUG:
 		mwifiex_dbg(adapter, EVENT, "event: debug\n");
-- 
1.9.1
