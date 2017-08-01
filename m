Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37643 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdHAJKN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:10:13 -0400
Received: by mail-pg0-f66.google.com with SMTP id 83so1713450pgb.4
        for <linux-wireless@vger.kernel.org>; Tue, 01 Aug 2017 02:10:12 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [PATCH 3/8] rsi: add support for legacy power save
Date: Tue,  1 Aug 2017 14:35:47 +0530
Message-Id: <1501578352-10795-4-git-send-email-amitkarwar@gmail.com> (sfid-20170801_111017_711015_B148FF7B)
In-Reply-To: <1501578352-10795-1-git-send-email-amitkarwar@gmail.com>
References: <1501578352-10795-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

This patch adds support for legacy power save. Necessary
configuration frames are downloaded to firmware when power save
is enabled/disabled

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/Makefile           |   1 +
 drivers/net/wireless/rsi/rsi_91x_hal.c      |   7 ++
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  23 +++++
 drivers/net/wireless/rsi/rsi_91x_main.c     |   2 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  58 ++++++++++-
 drivers/net/wireless/rsi/rsi_91x_ps.c       | 149 ++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_main.h         |   9 +-
 drivers/net/wireless/rsi/rsi_mgmt.h         |  21 ++++
 drivers/net/wireless/rsi/rsi_ps.h           |  78 +++++++++++++++
 9 files changed, 345 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_ps.c
 create mode 100644 drivers/net/wireless/rsi/rsi_ps.h

diff --git a/drivers/net/wireless/rsi/Makefile b/drivers/net/wireless/rsi/Makefile
index a475c81..ebb8996 100644
--- a/drivers/net/wireless/rsi/Makefile
+++ b/drivers/net/wireless/rsi/Makefile
@@ -3,6 +3,7 @@ rsi_91x-y			+= rsi_91x_core.o
 rsi_91x-y			+= rsi_91x_mac80211.o
 rsi_91x-y			+= rsi_91x_mgmt.o
 rsi_91x-y			+= rsi_91x_hal.o
+rsi_91x-y			+= rsi_91x_ps.o
 rsi_91x-$(CONFIG_RSI_DEBUGFS)	+= rsi_91x_debugfs.o
 
 rsi_usb-y			+= rsi_91x_usb.o rsi_91x_usb_ops.o
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index b0a7a15..4addcc0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -111,6 +111,8 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 /* This function prepares descriptor for given data packet */
 static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 {
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_vif *vif;
 	struct ieee80211_hdr *wh = NULL;
 	struct ieee80211_tx_info *info;
 	struct skb_info *tx_params;
@@ -148,6 +150,7 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 	xtend_desc = (struct xtended_desc *)&skb->data[FRAME_DESC_SZ];
 	wh = (struct ieee80211_hdr *)&skb->data[header_size];
 	seq_num = (le16_to_cpu(wh->seq_ctrl) >> 4);
+	vif = adapter->vifs[0];
 
 	data_desc->xtend_desc_size = header_size - FRAME_DESC_SZ;
 
@@ -156,6 +159,10 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 		data_desc->mac_flags |= cpu_to_le16(RSI_QOS_ENABLE);
 	}
 
+	if ((vif->type == NL80211_IFTYPE_STATION) &&
+	    (adapter->ps_state == PS_ENABLED))
+		wh->frame_control |= cpu_to_le16(RSI_SET_PS_ENABLE);
+
 	if ((!(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) &&
 	    (common->secinfo.security_enable)) {
 		if (rsi_is_cipher_wep(common))
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 193f922..38f4e59 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -18,6 +18,7 @@
 #include "rsi_debugfs.h"
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
+#include "rsi_ps.h"
 
 static const struct ieee80211_channel rsi_2ghz_channels[] = {
 	{ .band = NL80211_BAND_2GHZ, .center_freq = 2412,
@@ -467,6 +468,8 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
+	struct ieee80211_vif *vif = adapter->vifs[0];
+	struct ieee80211_conf *conf = &hw->conf;
 	int status = -EOPNOTSUPP;
 
 	mutex_lock(&common->mutex);
@@ -480,6 +483,19 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 		status = rsi_config_power(hw);
 	}
 
+	/* Power save parameters */
+	if ((changed & IEEE80211_CONF_CHANGE_PS) &&
+	    (vif->type == NL80211_IFTYPE_STATION)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&adapter->ps_lock, flags);
+		if (conf->flags & IEEE80211_CONF_PS)
+			rsi_enable_ps(adapter);
+		else
+			rsi_disable_ps(adapter);
+		spin_unlock_irqrestore(&adapter->ps_lock, flags);
+	}
+
 	mutex_unlock(&common->mutex);
 
 	return status;
@@ -522,6 +538,8 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
+	struct ieee80211_bss_conf *bss = &vif->bss_conf;
+	struct ieee80211_conf *conf = &hw->conf;
 	u16 rx_filter_word = 0;
 
 	mutex_lock(&common->mutex);
@@ -540,6 +558,9 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 				      bss_conf->bssid,
 				      bss_conf->qos,
 				      bss_conf->aid);
+		/* Update DTIM period and listen interval */
+		adapter->ps_info.dtim_interval_duration = bss->dtim_period;
+		adapter->ps_info.listen_interval = conf->listen_interval;
 	}
 
 	if (changed & BSS_CHANGED_CQM) {
@@ -1283,6 +1304,8 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	ieee80211_hw_set(hw, SIGNAL_DBM);
 	ieee80211_hw_set(hw, HAS_RATE_CONTROL);
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
+	ieee80211_hw_set(hw, SUPPORTS_PS);
+	ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
 
 	hw->queues = MAX_HW_QUEUES;
 	hw->extra_tx_headroom = RSI_NEEDED_HEADROOM;
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index bb0febb..3e1e808 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -231,6 +231,8 @@ struct rsi_hw *rsi_91x_init(void)
 		goto err;
 	}
 
+	rsi_default_ps_params(adapter);
+	spin_lock_init(&adapter->ps_lock);
 	common->init_done = true;
 	return adapter;
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 653e83d..1758d84 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -17,6 +17,7 @@
 #include <linux/etherdevice.h>
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
+#include "rsi_ps.h"
 
 static struct bootup_params boot_params_20 = {
 	.magic_number = cpu_to_le16(0x5aa5),
@@ -1395,6 +1396,59 @@ int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word)
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
 
+/* This function sends power save request to firmware */
+int rsi_send_ps_request(struct rsi_hw *adapter, bool enable)
+{
+	struct rsi_common *common = adapter->priv;
+	struct ieee80211_bss_conf *bss = &adapter->vifs[0]->bss_conf;
+	struct rsi_request_ps *ps;
+	struct rsi_ps_info *ps_info;
+	struct sk_buff *skb;
+	int frame_len = sizeof(*ps);
+
+	skb = dev_alloc_skb(frame_len);
+	if (!skb)
+		return -ENOMEM;
+	memset(skb->data, 0, frame_len);
+
+	ps = (struct rsi_request_ps *)skb->data;
+	ps_info = &adapter->ps_info;
+
+	rsi_set_len_qno(&ps->desc.desc_dword0.len_qno,
+			(frame_len - FRAME_DESC_SZ), RSI_WIFI_MGMT_Q);
+	ps->desc.desc_dword0.frame_type = WAKEUP_SLEEP_REQUEST;
+	if (enable) {
+		ps->ps_sleep.enable = RSI_PS_ENABLE;
+		ps->desc.desc_dword3.token = cpu_to_le16(RSI_SLEEP_REQUEST);
+	} else {
+		ps->ps_sleep.enable = RSI_PS_DISABLE;
+		ps->desc.desc_dword0.len_qno |= cpu_to_le16(RSI_PS_DISABLE_IND);
+		ps->desc.desc_dword3.token = cpu_to_le16(RSI_WAKEUP_REQUEST);
+	}
+	ps->ps_sleep.sleep_type = ps_info->sleep_type;
+	ps->ps_sleep.num_bcns_per_lis_int =
+		cpu_to_le16(ps_info->num_bcns_per_lis_int);
+	ps->ps_sleep.sleep_duration =
+		cpu_to_le32(ps_info->deep_sleep_wakeup_period);
+
+	if (bss->assoc)
+		ps->ps_sleep.connected_sleep = RSI_CONNECTED_SLEEP;
+	else
+		ps->ps_sleep.connected_sleep = RSI_DEEP_SLEEP;
+
+	ps->ps_listen_interval = cpu_to_le32(ps_info->listen_interval);
+	ps->ps_dtim_interval_duration =
+		cpu_to_le32(ps_info->dtim_interval_duration);
+
+	if (ps_info->listen_interval > ps_info->dtim_interval_duration)
+		ps->ps_listen_interval = cpu_to_le32(RSI_PS_DISABLE);
+
+	ps->ps_num_dtim_intervals = cpu_to_le16(ps_info->num_dtims_per_sleep);
+	skb_put(skb, frame_len);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
 /**
  * rsi_set_antenna() - This fuction send antenna configuration request
  *		       to device
@@ -1568,7 +1622,9 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 			return 0;
 		}
 		break;
-
+	case WAKEUP_SLEEP_REQUEST:
+		rsi_dbg(INFO_ZONE, "Wakeup/Sleep confirmation.\n");
+		return rsi_handle_ps_confirm(adapter, msg);
 	default:
 		rsi_dbg(INFO_ZONE, "%s: Invalid TA confirm pkt received\n",
 			__func__);
diff --git a/drivers/net/wireless/rsi/rsi_91x_ps.c b/drivers/net/wireless/rsi/rsi_91x_ps.c
new file mode 100644
index 0000000..5762363
--- /dev/null
+++ b/drivers/net/wireless/rsi/rsi_91x_ps.c
@@ -0,0 +1,149 @@
+/*
+ * Copyright (c) 2017 Redpine Signals Inc. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *
+ *	1. Redistributions of source code must retain the above copyright
+ *	   notice, this list of conditions and the following disclaimer.
+ *
+ *	2. Redistributions in binary form must reproduce the above copyright
+ *	   notice, this list of conditions and the following disclaimer in the
+ *	   documentation and/or other materials provided with the distribution.
+ *
+ *	3. Neither the name of the copyright holder nor the names of its
+ *	   contributors may be used to endorse or promote products derived from
+ *	   this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION). HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/if.h>
+#include <linux/version.h>
+#include "rsi_debugfs.h"
+#include "rsi_mgmt.h"
+#include "rsi_common.h"
+#include "rsi_ps.h"
+
+/* This function returns the ps state in string format */
+char *str_psstate(enum ps_state state)
+{
+	switch (state) {
+	case PS_NONE:
+		return "PS_NONE";
+	case PS_DISABLE_REQ_SENT:
+		return "PS_DISABLE_REQ_SENT";
+	case PS_ENABLE_REQ_SENT:
+		return "PS_ENABLE_REQ_SENT";
+	case PS_ENABLED:
+		return "PS_ENABLED";
+	default:
+		return "INVALID_STATE";
+	}
+	return "INVALID_STATE";
+}
+
+/* This function modifies PS state to a new state */
+static inline void rsi_modify_ps_state(struct rsi_hw *adapter,
+				       enum ps_state nstate)
+{
+	rsi_dbg(INFO_ZONE, "PS state changed %s => %s\n",
+		str_psstate(adapter->ps_state),
+		str_psstate(nstate));
+
+	adapter->ps_state = nstate;
+}
+
+/* This function Initalises ps_info structure with default parameters */
+void rsi_default_ps_params(struct rsi_hw *adapter)
+{
+	struct rsi_ps_info *ps_info = &adapter->ps_info;
+
+	ps_info->enabled = true;
+	ps_info->sleep_type = RSI_SLEEP_TYPE_LP;
+	ps_info->tx_threshold = 0;
+	ps_info->rx_threshold = 0;
+	ps_info->tx_hysterisis = 0;
+	ps_info->rx_hysterisis = 0;
+	ps_info->monitor_interval = 0;
+	ps_info->listen_interval = RSI_DEF_LISTEN_INTERVAL;
+	ps_info->num_bcns_per_lis_int = 0;
+	ps_info->dtim_interval_duration = 0;
+	ps_info->num_dtims_per_sleep = 0;
+	ps_info->deep_sleep_wakeup_period = RSI_DEF_DS_WAKEUP_PERIOD;
+}
+
+/* This function is used to enable power save */
+void rsi_enable_ps(struct rsi_hw *adapter)
+{
+	if (adapter->ps_state != PS_NONE) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Cannot accept enable PS in %s state\n",
+			__func__, str_psstate(adapter->ps_state));
+		return;
+	}
+
+	if (rsi_send_ps_request(adapter, true)) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Failed to send PS request to device\n",
+			__func__);
+		return;
+	}
+
+	rsi_modify_ps_state(adapter, PS_ENABLE_REQ_SENT);
+}
+
+/* This function is used to disable power save */
+void rsi_disable_ps(struct rsi_hw *adapter)
+{
+	if (adapter->ps_state != PS_ENABLED) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Cannot accept disable PS in %s state\n",
+			__func__, str_psstate(adapter->ps_state));
+		return;
+	}
+
+	if (rsi_send_ps_request(adapter, false)) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Failed to send PS request to device\n",
+			__func__);
+		return;
+	}
+
+	rsi_modify_ps_state(adapter, PS_DISABLE_REQ_SENT);
+}
+
+/* This function Processes powersave confirmation */
+int rsi_handle_ps_confirm(struct rsi_hw *adapter, u8 *msg)
+{
+	u16 cfm_type = get_unaligned_le16(msg + PS_CONFIRM_INDEX);
+
+	switch (cfm_type) {
+	case RSI_SLEEP_REQUEST:
+		if (adapter->ps_state == PS_ENABLE_REQ_SENT)
+			rsi_modify_ps_state(adapter, PS_ENABLED);
+		break;
+	case RSI_WAKEUP_REQUEST:
+		if (adapter->ps_state == PS_DISABLE_REQ_SENT)
+			rsi_modify_ps_state(adapter, PS_NONE);
+		break;
+	default:
+		rsi_dbg(ERR_ZONE,
+			"Invalid PS confirm type %x in state %s\n",
+			cfm_type, str_psstate(adapter->ps_state));
+		return -1;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 6a8e8e7..9aada0b 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -21,6 +21,10 @@
 #include <linux/skbuff.h>
 #include <net/mac80211.h>
 
+struct rsi_hw;
+
+#include "rsi_ps.h"
+
 #define ERR_ZONE                        BIT(0)  /* For Error Msgs             */
 #define INFO_ZONE                       BIT(1)  /* For General Status Msgs    */
 #define INIT_ZONE                       BIT(2)  /* For Driver Init Seq Msgs   */
@@ -177,8 +181,6 @@ enum rsi_dfs_regions {
 	RSI_REGION_WORLD
 };
 
-struct rsi_hw;
-
 struct rsi_common {
 	struct rsi_hw *priv;
 	struct vif_priv vif_info[RSI_MAX_VIFS];
@@ -282,6 +284,9 @@ struct rsi_hw {
 
 	enum host_intf rsi_host_intf;
 	u16 block_size;
+	enum ps_state ps_state;
+	struct rsi_ps_info ps_info;
+	spinlock_t ps_lock; /*To protect power save config*/
 	u32 usb_buffer_status_reg;
 #ifdef CONFIG_RSI_DEBUGFS
 	struct rsi_debugfs *dfsentry;
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 1060edc..c5d114d 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -69,6 +69,7 @@
 #define RSI_QOS_ENABLE			BIT(12)
 #define RSI_REKEY_PURPOSE		BIT(13)
 #define RSI_ENCRYPT_PKT			BIT(15)
+#define RSI_SET_PS_ENABLE		BIT(12)
 
 #define RSI_CMDDESC_40MHZ		BIT(4)
 #define RSI_CMDDESC_UPPER_20_ENABLE	BIT(5)
@@ -172,6 +173,14 @@
 #define RSI_BEACON_INTERVAL		200
 #define RSI_DTIM_COUNT			2
 
+#define RSI_PS_DISABLE_IND		BIT(15)
+#define RSI_PS_ENABLE			1
+#define RSI_PS_DISABLE			0
+#define RSI_DEEP_SLEEP			1
+#define RSI_CONNECTED_SLEEP		2
+#define RSI_SLEEP_REQUEST		1
+#define RSI_WAKEUP_REQUEST		2
+
 enum opmode {
 	STA_OPMODE = 1,
 	AP_OPMODE = 2
@@ -519,6 +528,18 @@ struct rsi_eeprom_read_frame {
 	__le16 reserved3;
 } __packed;
 
+struct rsi_request_ps {
+	struct rsi_cmd_desc desc;
+	struct ps_sleep_params ps_sleep;
+	u8 ps_mimic_support;
+	u8 ps_uapsd_acs;
+	u8 ps_uapsd_wakeup_period;
+	u8 reserved;
+	__le32 ps_listen_interval;
+	__le32 ps_dtim_interval_duration;
+	__le16 ps_num_dtim_intervals;
+} __packed;
+
 static inline u32 rsi_get_queueno(u8 *addr, u16 offset)
 {
 	return (le16_to_cpu(*(__le16 *)&addr[offset]) & 0x7000) >> 12;
diff --git a/drivers/net/wireless/rsi/rsi_ps.h b/drivers/net/wireless/rsi/rsi_ps.h
new file mode 100644
index 0000000..c576c8c
--- /dev/null
+++ b/drivers/net/wireless/rsi/rsi_ps.h
@@ -0,0 +1,78 @@
+/*
+ * Copyright (c) 2017 Redpine Signals Inc. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *
+ *	1. Redistributions of source code must retain the above copyright
+ *	   notice, this list of conditions and the following disclaimer.
+ *
+ *	2. Redistributions in binary form must reproduce the above copyright
+ *	   notice, this list of conditions and the following disclaimer in the
+ *	   documentation and/or other materials provided with the distribution.
+ *
+ *	3. Neither the name of the copyright holder nor the names of its
+ *	   contributors may be used to endorse or promote products derived from
+ *	   this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION). HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __RSI_PS_H__
+#define __RSI_PS_H__
+
+#define PS_CONFIRM_INDEX	12
+#define RSI_DEF_DS_WAKEUP_PERIOD	200
+#define RSI_DEF_LISTEN_INTERVAL		200
+#define RSI_SLEEP_TYPE_LP		1
+
+enum ps_state {
+	PS_NONE = 0,
+	PS_ENABLE_REQ_SENT = 1,
+	PS_DISABLE_REQ_SENT = 2,
+	PS_ENABLED = 3
+};
+
+struct ps_sleep_params {
+	u8 enable;
+	u8 sleep_type;
+	u8 connected_sleep;
+	u8 reserved1;
+	__le16 num_bcns_per_lis_int;
+	__le16 wakeup_type;
+	__le32 sleep_duration;
+} __packed;
+
+struct rsi_ps_info {
+	u8 enabled;
+	u8 sleep_type;
+	u8 tx_threshold;
+	u8 rx_threshold;
+	u8 tx_hysterisis;
+	u8 rx_hysterisis;
+	u16 monitor_interval;
+	u32 listen_interval;
+	u16 num_bcns_per_lis_int;
+	u32 dtim_interval_duration;
+	u16 num_dtims_per_sleep;
+	u32 deep_sleep_wakeup_period;
+} __packed;
+
+char *str_psstate(enum ps_state state);
+void rsi_enable_ps(struct rsi_hw *adapter);
+void rsi_disable_ps(struct rsi_hw *adapter);
+int rsi_handle_ps_confirm(struct rsi_hw *adapter, u8 *msg);
+void rsi_default_ps_params(struct rsi_hw *hw);
+int rsi_send_ps_request(struct rsi_hw *adapter, bool enable);
+void rsi_conf_uapsd(struct rsi_hw *adapter);
+#endif
-- 
2.7.4
