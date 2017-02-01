Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:36088 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdBAUtV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 15:49:21 -0500
Received: by mail-ot0-f193.google.com with SMTP id 36so46716649otx.3
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2017 12:49:21 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 11/11 V2] rtlwifi: Add work queue for c2h cmd.
Date: Wed,  1 Feb 2017 14:48:13 -0600
Message-Id: <20170120212716.29887-12-Larry.Finger@lwfinger.net> (sfid-20170201_215000_499917_63E90402)
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

btcoex needs to sleep, thus it must run in thread context.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - Potential infinite loop is fixed.
---
 drivers/net/wireless/realtek/rtlwifi/base.c        | 92 ++++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/base.h        |  3 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    | 15 +++-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.h    |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.c    |  1 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    | 18 ++++-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.h    |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |  1 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    | 18 ++++-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    |  3 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |  1 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h        | 14 ++++
 12 files changed, 159 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 01cf0a9..3fb0542 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -475,6 +475,8 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
 			  (void *)rtl_swlps_rfon_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.fwevt_wq,
 			  (void *)rtl_fwevt_wq_callback);
+	INIT_DELAYED_WORK(&rtlpriv->works.c2hcmd_wq,
+			  (void *)rtl_c2hcmd_wq_callback);
 
 }
 
@@ -489,6 +491,7 @@ void rtl_deinit_deferred_work(struct ieee80211_hw *hw)
 	cancel_delayed_work(&rtlpriv->works.ps_work);
 	cancel_delayed_work(&rtlpriv->works.ps_rfon_wq);
 	cancel_delayed_work(&rtlpriv->works.fwevt_wq);
+	cancel_delayed_work(&rtlpriv->works.c2hcmd_wq);
 }
 EXPORT_SYMBOL_GPL(rtl_deinit_deferred_work);
 
@@ -556,6 +559,7 @@ int rtl_init_core(struct ieee80211_hw *hw)
 	spin_lock_init(&rtlpriv->locks.rf_lock);
 	spin_lock_init(&rtlpriv->locks.waitq_lock);
 	spin_lock_init(&rtlpriv->locks.entry_list_lock);
+	spin_lock_init(&rtlpriv->locks.c2hcmd_lock);
 	spin_lock_init(&rtlpriv->locks.cck_and_rw_pagea_lock);
 	spin_lock_init(&rtlpriv->locks.check_sendpkt_lock);
 	spin_lock_init(&rtlpriv->locks.fw_ps_lock);
@@ -563,6 +567,7 @@ int rtl_init_core(struct ieee80211_hw *hw)
 	spin_lock_init(&rtlpriv->locks.iqk_lock);
 	/* <5> init list */
 	INIT_LIST_HEAD(&rtlpriv->entry_list);
+	INIT_LIST_HEAD(&rtlpriv->c2hcmd_list);
 
 	rtlmac->link_state = MAC80211_NOLINK;
 
@@ -575,6 +580,7 @@ EXPORT_SYMBOL_GPL(rtl_init_core);
 
 void rtl_deinit_core(struct ieee80211_hw *hw)
 {
+	rtl_c2hcmd_launcher(hw, 0);
 }
 EXPORT_SYMBOL_GPL(rtl_deinit_core);
 
@@ -1729,6 +1735,93 @@ void rtl_fwevt_wq_callback(void *data)
 
 	rtlpriv->cfg->ops->c2h_command_handle(hw);
 }
+
+void rtl_c2hcmd_enqueue(struct ieee80211_hw *hw, u8 tag, u8 len, u8 *val)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	unsigned long flags;
+	struct rtl_c2hcmd *c2hcmd;
+
+	c2hcmd = kmalloc(sizeof(*c2hcmd), GFP_KERNEL);
+
+	if (!c2hcmd)
+		goto label_err;
+
+	c2hcmd->val = kmalloc(len, GFP_KERNEL);
+
+	if (!c2hcmd->val)
+		goto label_err2;
+
+	/* fill data */
+	c2hcmd->tag = tag;
+	c2hcmd->len = len;
+	memcpy(c2hcmd->val, val, len);
+
+	/* enqueue */
+	spin_lock_irqsave(&rtlpriv->locks.c2hcmd_lock, flags);
+
+	list_add_tail(&c2hcmd->list, &rtlpriv->c2hcmd_list);
+
+	spin_unlock_irqrestore(&rtlpriv->locks.c2hcmd_lock, flags);
+
+	/* wake up wq */
+	queue_delayed_work(rtlpriv->works.rtl_wq, &rtlpriv->works.c2hcmd_wq, 0);
+
+	return;
+
+label_err2:
+	kfree(c2hcmd);
+
+label_err:
+	RT_TRACE(rtlpriv, COMP_CMD, DBG_WARNING,
+		 "C2H cmd enqueue fail.\n");
+}
+EXPORT_SYMBOL(rtl_c2hcmd_enqueue);
+
+void rtl_c2hcmd_launcher(struct ieee80211_hw *hw, int exec)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	unsigned long flags;
+	struct rtl_c2hcmd *c2hcmd;
+	int i;
+
+	for (i = 0; i < 200; i++) {
+		/* dequeue a task */
+		spin_lock_irqsave(&rtlpriv->locks.c2hcmd_lock, flags);
+
+		c2hcmd = list_first_entry_or_null(&rtlpriv->c2hcmd_list,
+						  struct rtl_c2hcmd, list);
+
+		if (c2hcmd)
+			list_del(&c2hcmd->list);
+
+		spin_unlock_irqrestore(&rtlpriv->locks.c2hcmd_lock, flags);
+
+		/* do it */
+		if (!c2hcmd)
+			break;
+
+		if (rtlpriv->cfg->ops->c2h_content_parsing && exec)
+			rtlpriv->cfg->ops->c2h_content_parsing(hw,
+					c2hcmd->tag, c2hcmd->len, c2hcmd->val);
+
+		/* free */
+		kfree(c2hcmd->val);
+
+		kfree(c2hcmd);
+	}
+}
+
+void rtl_c2hcmd_wq_callback(void *data)
+{
+	struct rtl_works *rtlworks = container_of_dwork_rtl(data,
+							    struct rtl_works,
+							    c2hcmd_wq);
+	struct ieee80211_hw *hw = rtlworks->hw;
+
+	rtl_c2hcmd_launcher(hw, 1);
+}
+
 void rtl_easy_concurrent_retrytimer_callback(unsigned long data)
 {
 	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
diff --git a/drivers/net/wireless/realtek/rtlwifi/base.h b/drivers/net/wireless/realtek/rtlwifi/base.h
index 6c770aec..02ff0c5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.h
+++ b/drivers/net/wireless/realtek/rtlwifi/base.h
@@ -136,6 +136,9 @@ int rtl_rx_agg_stop(struct ieee80211_hw *hw,
 		    struct ieee80211_sta *sta, u16 tid);
 void rtl_watchdog_wq_callback(void *data);
 void rtl_fwevt_wq_callback(void *data);
+void rtl_c2hcmd_wq_callback(void *data);
+void rtl_c2hcmd_launcher(struct ieee80211_hw *hw, int exec);
+void rtl_c2hcmd_enqueue(struct ieee80211_hw *hw, u8 tag, u8 len, u8 *val);
 
 void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 		      struct ieee80211_tx_info *info,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 9d7a16c..9fec345 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -764,8 +764,8 @@ static void _rtl92ee_c2h_ra_report_handler(struct ieee80211_hw *hw,
 	rtl92ee_dm_dynamic_arfb_select(hw, rate, collision_state);
 }
 
-static void _rtl92ee_c2h_content_parsing(struct ieee80211_hw *hw, u8 c2h_cmd_id,
-					 u8 c2h_cmd_len, u8 *tmp_buf)
+void rtl92ee_c2h_content_parsing(struct ieee80211_hw *hw, u8 c2h_cmd_id,
+				 u8 c2h_cmd_len, u8 *tmp_buf)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
@@ -820,5 +820,14 @@ void rtl92ee_c2h_packet_handler(struct ieee80211_hw *hw, u8 *buffer, u8 len)
 	RT_PRINT_DATA(rtlpriv, COMP_FW, DBG_TRACE,
 		      "[C2H packet], Content Hex:\n", tmp_buf, c2h_cmd_len);
 
-	_rtl92ee_c2h_content_parsing(hw, c2h_cmd_id, c2h_cmd_len, tmp_buf);
+	switch (c2h_cmd_id) {
+	case C2H_8192E_BT_INFO:
+	case C2H_8192E_BT_MP:
+		rtl_c2hcmd_enqueue(hw, c2h_cmd_id, c2h_cmd_len, tmp_buf);
+		break;
+	default:
+		rtl92ee_c2h_content_parsing(hw, c2h_cmd_id, c2h_cmd_len,
+					    tmp_buf);
+		break;
+	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.h
index 069da1e..72da3f9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.h
@@ -185,5 +185,6 @@ void rtl92ee_set_fw_media_status_rpt_cmd(struct ieee80211_hw *hw, u8 mstatus);
 void rtl92ee_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished);
 void rtl92ee_set_p2p_ps_offload_cmd(struct ieee80211_hw *hw, u8 p2p_ps_state);
 void rtl92ee_c2h_packet_handler(struct ieee80211_hw *hw, u8 *buffer, u8 len);
-
+void rtl92ee_c2h_content_parsing(struct ieee80211_hw *hw, u8 c2h_cmd_id,
+				 u8 c2h_cmd_len, u8 *tmp_buf);
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
index 554f2dc..48820bc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
@@ -248,6 +248,7 @@ static struct rtl_hal_ops rtl8192ee_hal_ops = {
 	.fill_h2c_cmd = rtl92ee_fill_h2c_cmd,
 	.get_btc_status = rtl92ee_get_btc_status,
 	.rx_command_packet = rtl92ee_rx_command_packet,
+	.c2h_content_parsing = rtl92ee_c2h_content_parsing,
 };
 
 static struct rtl_mod_params rtl92ee_mod_params = {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
index fbf3961..c7ee9ba 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
@@ -585,9 +585,9 @@ void rtl8723be_set_p2p_ps_offload_cmd(struct ieee80211_hw *hw,
 			       (u8 *)p2p_ps_offload);
 }
 
-static void _rtl8723be_c2h_content_parsing(struct ieee80211_hw *hw,
-					   u8 c2h_cmd_id,
-					   u8 c2h_cmd_len, u8 *tmp_buf)
+void rtl8723be_c2h_content_parsing(struct ieee80211_hw *hw,
+				   u8 c2h_cmd_id,
+				   u8 c2h_cmd_len, u8 *tmp_buf)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
@@ -635,5 +635,15 @@ void rtl8723be_c2h_packet_handler(struct ieee80211_hw *hw, u8 *buffer, u8 len)
 	RT_PRINT_DATA(rtlpriv, COMP_FW, DBG_TRACE,
 		      "[C2H packet], Content Hex:\n", tmp_buf, c2h_cmd_len);
 
-	_rtl8723be_c2h_content_parsing(hw, c2h_cmd_id, c2h_cmd_len, tmp_buf);
+	switch (c2h_cmd_id) {
+	case C2H_8723B_BT_INFO:
+	case C2H_8723B_BT_MP:
+		rtl_c2hcmd_enqueue(hw, c2h_cmd_id, c2h_cmd_len, tmp_buf);
+		break;
+
+	default:
+		rtl8723be_c2h_content_parsing(hw, c2h_cmd_id, c2h_cmd_len,
+					      tmp_buf);
+		break;
+	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.h
index 0674296..c652fa1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.h
@@ -148,5 +148,6 @@ void rtl8723be_set_fw_media_status_rpt_cmd(struct ieee80211_hw *hw, u8 mstatus);
 void rtl8723be_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished);
 void rtl8723be_set_p2p_ps_offload_cmd(struct ieee80211_hw *hw, u8 p2p_ps_state);
 void rtl8723be_c2h_packet_handler(struct ieee80211_hw *hw, u8 *buffer, u8 len);
-
+void rtl8723be_c2h_content_parsing(struct ieee80211_hw *hw, u8 c2h_cmd_id,
+				   u8 c2h_cmd_len, u8 *tmp_buf);
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
index e571b87..92dbfa8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
@@ -260,6 +260,7 @@ static struct rtl_hal_ops rtl8723be_hal_ops = {
 	.get_btc_status = rtl8723be_get_btc_status,
 	.rx_command_packet = rtl8723be_rx_command_packet,
 	.is_fw_header = is_fw_header,
+	.c2h_content_parsing = rtl8723be_c2h_content_parsing,
 };
 
 static struct rtl_mod_params rtl8723be_mod_params = {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index 328c64d..a504dfa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -1740,9 +1740,9 @@ static void rtl8821ae_c2h_ra_report_handler(struct ieee80211_hw *hw,
 	rtl8821ae_dm_update_init_rate(hw, rate);
 }
 
-static void _rtl8821ae_c2h_content_parsing(struct ieee80211_hw *hw,
-					   u8 c2h_cmd_id, u8 c2h_cmd_len,
-					   u8 *tmp_buf)
+void rtl8821ae_c2h_content_parsing(struct ieee80211_hw *hw,
+				   u8 c2h_cmd_id, u8 c2h_cmd_len,
+				   u8 *tmp_buf)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
@@ -1784,5 +1784,15 @@ void rtl8821ae_c2h_packet_handler(struct ieee80211_hw *hw, u8 *buffer,
 
 	RT_PRINT_DATA(rtlpriv, COMP_FW, DBG_LOUD,
 		      "[C2H packet], Content Hex:\n", tmp_buf, c2h_cmd_len);
-	_rtl8821ae_c2h_content_parsing(hw, c2h_cmd_id, c2h_cmd_len, tmp_buf);
+
+	switch (c2h_cmd_id) {
+	case C2H_8812_BT_INFO:
+		rtl_c2hcmd_enqueue(hw, c2h_cmd_id, c2h_cmd_len, tmp_buf);
+		break;
+
+	default:
+		rtl8821ae_c2h_content_parsing(hw, c2h_cmd_id, c2h_cmd_len,
+					      tmp_buf);
+		break;
+	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h
index 8f5b4aa..90a98ed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h
@@ -329,4 +329,7 @@ void rtl8821ae_set_fw_disconnect_decision_ctrl_cmd(struct ieee80211_hw *hw,
 void rtl8821ae_set_fw_global_info_cmd(struct ieee80211_hw *hw);
 void rtl8821ae_c2h_packet_handler(struct ieee80211_hw *hw,
 				  u8 *buffer, u8 length);
+void rtl8821ae_c2h_content_parsing(struct ieee80211_hw *hw,
+				   u8 c2h_cmd_id, u8 c2h_cmd_len,
+				   u8 *tmp_buf);
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index cd2a53b7..77cf3b2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -297,6 +297,7 @@ static struct rtl_hal_ops rtl8821ae_hal_ops = {
 	.fill_h2c_cmd = rtl8821ae_fill_h2c_cmd,
 	.get_btc_status = rtl8821ae_get_btc_status,
 	.rx_command_packet = rtl8821ae_rx_command_packet,
+	.c2h_content_parsing = rtl8821ae_c2h_content_parsing,
 	.add_wowlan_pattern = rtl8821ae_add_wowlan_pattern,
 };
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 4dad962..e6be564 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2202,6 +2202,8 @@ struct rtl_hal_ops {
 				   struct rtl_wow_pattern *rtl_pattern,
 				   u8 index);
 	u16 (*get_available_desc)(struct ieee80211_hw *hw, u8 q_idx);
+	void (*c2h_content_parsing)(struct ieee80211_hw *hw, u8 tag, u8 len,
+				    u8 *val);
 };
 
 struct rtl_intf_ops {
@@ -2317,6 +2319,7 @@ struct rtl_locks {
 	spinlock_t waitq_lock;
 	spinlock_t entry_list_lock;
 	spinlock_t usb_lock;
+	spinlock_t c2hcmd_lock;
 
 	/*FW clock change */
 	spinlock_t fw_ps_lock;
@@ -2346,6 +2349,7 @@ struct rtl_works {
 	struct workqueue_struct *rtl_wq;
 	struct delayed_work watchdog_wq;
 	struct delayed_work ips_nic_off_wq;
+	struct delayed_work c2hcmd_wq;
 
 	/* For SW LPS */
 	struct delayed_work ps_work;
@@ -2553,6 +2557,13 @@ struct proxim {
 	u8  (*proxim_get_var)(struct ieee80211_hw *hw, u8 type);
 };
 
+struct rtl_c2hcmd {
+	struct list_head list;
+	u8 tag;
+	u8 len;
+	u8 *val;
+};
+
 struct rtl_priv {
 	struct ieee80211_hw *hw;
 	struct completion firmware_loading_complete;
@@ -2585,6 +2596,9 @@ struct rtl_priv {
 	/* sta entry list for ap adhoc or mesh */
 	struct list_head entry_list;
 
+	/* c2hcmd list for kthread level access */
+	struct list_head c2hcmd_list;
+
 	int max_fw_size;
 
 	/*
-- 
2.10.2
