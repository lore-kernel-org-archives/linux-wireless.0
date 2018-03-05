Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36992 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbeCEOsw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 09:48:52 -0500
Received: by mail-pg0-f66.google.com with SMTP id y26so6900136pgv.4
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2018 06:48:51 -0800 (PST)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 01/10] rsi: add support for hardware scan offload
Date: Mon,  5 Mar 2018 20:06:51 +0530
Message-Id: <1520260620-4694-2-git-send-email-amitkarwar@gmail.com> (sfid-20180305_154903_893202_03F7B868)
In-Reply-To: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

With the current approach of scanning, roaming delays
are observed. Firmware has support for back ground scanning.
To get this advantage, mac80211 hardware scan is implemented.
In this method, foreground scan is performed in driver and
back ground scan is configured to firmware.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c      |   3 +
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  84 +++++++++
 drivers/net/wireless/rsi/rsi_91x_main.c     |  12 ++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 273 +++++++++++++++++++++++++++-
 drivers/net/wireless/rsi/rsi_main.h         |  36 ++++
 drivers/net/wireless/rsi/rsi_mgmt.h         |  44 +++++
 6 files changed, 451 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index de608ae..20c2f6b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -99,6 +99,9 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 	mgmt_desc->frame_type = TX_DOT11_MGMT;
 	mgmt_desc->header_len = MIN_802_11_HDR_LEN;
 	mgmt_desc->xtend_desc_size = header_size - FRAME_DESC_SZ;
+
+	if (ieee80211_is_probe_req(wh->frame_control) && common->fgscan_in_prog)
+		mgmt_desc->frame_info = cpu_to_le16(RSI_INSERT_SEQ_IN_FW);
 	mgmt_desc->frame_info |= cpu_to_le16(RATE_INFO_ENABLE);
 	if (is_broadcast_ether_addr(wh->addr1))
 		mgmt_desc->frame_info |= cpu_to_le16(RSI_BROADCAST_PKT);
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 32f5cb4..4957690 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -229,6 +229,79 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 	/* sbands->ht_cap.mcs.rx_highest = 0x82; */
 }
 
+static int rsi_mac80211_hw_scan_start(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_scan_request *hw_req)
+{
+	struct cfg80211_scan_request *scan_req = &hw_req->req;
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+	struct ieee80211_bss_conf *bss = &vif->bss_conf;
+
+	rsi_dbg(INFO_ZONE, "***** Hardware scan start *****\n");
+
+	if (common->fsm_state != FSM_MAC_INIT_DONE)
+		return -ENODEV;
+
+	if ((common->wow_flags & RSI_WOW_ENABLED) ||
+	    scan_req->n_channels == 0)
+		return -EINVAL;
+
+	/* Scan already in progress. So return */
+	if (common->bgscan_en || common->fgscan_in_prog)
+		return -EBUSY;
+
+	mutex_lock(&common->mutex);
+
+	common->hwscan = scan_req;
+	common->scan_vif = vif;
+	if (!bss->assoc) {
+		common->cancel_hwscan = false;
+		queue_work(common->scan_workqueue, &common->scan_work);
+	} else {
+		if (!rsi_send_bgscan_params(common, RSI_START_BGSCAN)) {
+			if (!rsi_send_bgscan_probe_req(common)) {
+				rsi_dbg(INFO_ZONE,
+					"Background scan started...\n");
+				common->bgscan_en = true;
+			}
+		}
+	}
+
+	mutex_unlock(&common->mutex);
+
+	return 0;
+}
+
+static void rsi_mac80211_cancel_hw_scan(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+	struct cfg80211_scan_info info;
+
+	rsi_dbg(INFO_ZONE, "***** Hardware scan stop *****\n");
+
+	mutex_lock(&common->mutex);
+
+	if (common->fgscan_in_prog) {
+		common->cancel_hwscan = true;
+		rsi_wait_event(&common->cancel_hw_scan_event,
+			       EVENT_WAIT_FOREVER);
+		rsi_reset_event(&common->cancel_hw_scan_event);
+	}
+	if (common->bgscan_en) {
+		if (!rsi_send_bgscan_params(common, RSI_STOP_BGSCAN))
+			common->bgscan_en = 0;
+		info.aborted = false;
+		ieee80211_scan_completed(adapter->hw, &info);
+		rsi_dbg(INFO_ZONE, "Back ground scan cancelled\b");
+	}
+	common->hwscan = NULL;
+	common->scan_vif = NULL;
+	mutex_unlock(&common->mutex);
+}
+
 /**
  * rsi_mac80211_detach() - This function is used to de-initialize the
  *			   Mac80211 stack.
@@ -239,12 +312,18 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 void rsi_mac80211_detach(struct rsi_hw *adapter)
 {
 	struct ieee80211_hw *hw = adapter->hw;
+	struct rsi_common *common = adapter->priv;
 	enum nl80211_band band;
 
+	if (common->fgscan_in_prog)
+		common->cancel_hwscan = true;
+	flush_workqueue(common->scan_workqueue);
 	if (hw) {
 		ieee80211_stop_queues(hw);
 		ieee80211_unregister_hw(hw);
 		ieee80211_free_hw(hw);
+		adapter->hw = NULL;
+		adapter->sc_nvifs = 0;
 	}
 
 	for (band = 0; band < NUM_NL80211_BANDS; band++) {
@@ -1894,6 +1973,8 @@ static const struct ieee80211_ops mac80211_ops = {
 	.suspend = rsi_mac80211_suspend,
 	.resume  = rsi_mac80211_resume,
 #endif
+	.hw_scan = rsi_mac80211_hw_scan_start,
+	.cancel_hw_scan = rsi_mac80211_cancel_hw_scan,
 };
 
 /**
@@ -1972,6 +2053,9 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	common->max_stations = wiphy->max_ap_assoc_sta;
 	rsi_dbg(ERR_ZONE, "Max Stations Allowed = %d\n", common->max_stations);
 	hw->sta_data_size = sizeof(struct rsi_sta);
+
+	wiphy->max_scan_ssids = RSI_MAX_SCAN_SSIDS;
+	wiphy->max_scan_ie_len = RSI_MAX_SCAN_IE_LEN;
 	wiphy->flags = WIPHY_FLAG_REPORTS_OBSS;
 	wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
 	wiphy->features |= NL80211_FEATURE_INACTIVITY_TIMER;
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 1485a0c..bf05242 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -324,6 +324,14 @@ struct rsi_hw *rsi_91x_init(u16 oper_mode)
 	mutex_init(&common->rx_lock);
 	mutex_init(&common->tx_bus_mutex);
 
+	rsi_init_event(&common->chan_set_event);
+	rsi_init_event(&common->probe_cfm_event);
+	rsi_init_event(&common->chan_change_event);
+	rsi_init_event(&common->cancel_hw_scan_event);
+	common->scan_workqueue =
+		create_singlethread_workqueue("rsi_scan_worker");
+	INIT_WORK(&common->scan_work, rsi_fgscan_start);
+
 	if (rsi_create_kthread(common,
 			       &common->tx_thread,
 			       rsi_tx_scheduler_thread,
@@ -333,6 +341,7 @@ struct rsi_hw *rsi_91x_init(u16 oper_mode)
 	}
 
 	rsi_default_ps_params(adapter);
+	init_bgscan_params(common);
 	spin_lock_init(&adapter->ps_lock);
 	timer_setup(&common->roc_timer, rsi_roc_timeout, 0);
 	init_completion(&common->wlan_init_completion);
@@ -396,6 +405,9 @@ void rsi_91x_deinit(struct rsi_hw *adapter)
 
 	rsi_dbg(INFO_ZONE, "%s: Performing deinit os ops\n", __func__);
 
+	flush_workqueue(common->scan_workqueue);
+	destroy_workqueue(common->scan_workqueue);
+
 	rsi_kill_thread(&common->tx_thread);
 
 	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index c21fca7..0bcf841 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/etherdevice.h>
+#include <linux/timer.h>
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
 #include "rsi_ps.h"
@@ -236,6 +237,18 @@ static void rsi_set_default_parameters(struct rsi_common *common)
 	common->dtim_cnt = RSI_DTIM_COUNT;
 }
 
+void init_bgscan_params(struct rsi_common *common)
+{
+	memset((u8 *)&common->bgscan, 0, sizeof(struct rsi_bgscan_params));
+	common->bgscan.bgscan_threshold = RSI_DEF_BGSCAN_THRLD;
+	common->bgscan.roam_threshold = RSI_DEF_ROAM_THRLD;
+	common->bgscan.bgscan_periodicity = RSI_BGSCAN_PERIODICITY;
+	common->bgscan.num_bgscan_channels = 0;
+	common->bgscan.two_probe = 1;
+	common->bgscan.active_scan_duration = RSI_ACTIVE_SCAN_TIME;
+	common->bgscan.passive_scan_duration = RSI_PASSIVE_SCAN_TIME;
+}
+
 /**
  * rsi_set_contention_vals() - This function sets the contention values for the
  *			       backoff procedure.
@@ -1193,6 +1206,7 @@ static int rsi_send_auto_rate_request(struct rsi_common *common,
 			__func__);
 		return -ENOMEM;
 	}
+	memset(skb->data, 0, frame_len);
 
 	selected_rates = kzalloc(2 * RSI_TBL_SZ, GFP_KERNEL);
 	if (!selected_rates) {
@@ -1633,6 +1647,240 @@ int rsi_send_wowlan_request(struct rsi_common *common, u16 flags,
 }
 #endif
 
+static void channel_change_event(struct timer_list *t)
+{
+	struct rsi_common *common = from_timer(common, t, scan_timer);
+
+	rsi_set_event(&common->chan_change_event);
+	del_timer(&common->scan_timer);
+}
+
+static int init_channel_timer(struct rsi_common *common, u32 timeout)
+{
+	timer_setup(&common->scan_timer, channel_change_event, 0);
+	rsi_reset_event(&common->chan_change_event);
+	common->scan_timer.expires = msecs_to_jiffies(timeout) + jiffies;
+	add_timer(&common->scan_timer);
+
+	return 0;
+}
+
+int rsi_prepare_probe_request(struct rsi_common *common,
+			      struct cfg80211_scan_request *scan_req,
+			      u8 n_ssid, u8 channel, u8 *pbreq, u16 *pbreq_len)
+{
+	struct ieee80211_vif *vif = common->scan_vif;
+	struct cfg80211_ssid *ssid_info;
+	struct ieee80211_hdr *hdr = NULL;
+	u8 *pos;
+
+	if (common->priv->sc_nvifs <= 0)
+		return -ENODEV;
+	if (!scan_req)
+		return -EINVAL;
+	ssid_info = &scan_req->ssids[n_ssid];
+	if (!ssid_info)
+		return -EINVAL;
+
+	hdr = (struct ieee80211_hdr *)pbreq;
+	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					 IEEE80211_STYPE_PROBE_REQ);
+	hdr->duration_id = 0x0;
+	memset(hdr->addr1, 0xff, ETH_ALEN);
+	memset(hdr->addr3, 0xff, ETH_ALEN);
+	ether_addr_copy(hdr->addr2, vif->addr);
+	hdr->seq_ctrl = 0x00;
+	pos = (u8 *)hdr + MIN_802_11_HDR_LEN;
+
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = ssid_info->ssid_len;
+	if (ssid_info->ssid_len)
+		memcpy(pos, ssid_info->ssid, ssid_info->ssid_len);
+	pos += ssid_info->ssid_len;
+
+	if (scan_req->ie_len)
+		memcpy(pos, scan_req->ie, scan_req->ie_len);
+	pos += scan_req->ie_len;
+	*pbreq_len = pos - pbreq;
+
+	return 0;
+}
+
+int rsi_send_probe_request(struct rsi_common *common,
+			   struct cfg80211_scan_request *scan_req,
+			   u8 n_ssid, u8 channel)
+{
+	struct cfg80211_ssid *ssid_info = &scan_req->ssids[n_ssid];
+	struct sk_buff *skb = NULL;
+	u16 len;
+	u8 ssid_ie_len;
+
+	ssid_ie_len = ssid_info->ssid_len + 2;
+	len = MIN_802_11_HDR_LEN + scan_req->ie_len + ssid_ie_len;
+
+	skb = dev_alloc_skb(len + MAX_DWORD_ALIGN_BYTES);
+	if (!skb)
+		return -ENOMEM;
+	skb_reserve(skb, MAX_DWORD_ALIGN_BYTES);
+	memset(skb->data, 0, len);
+	if (rsi_prepare_probe_request(common, scan_req, n_ssid, channel,
+				      skb->data, &len)) {
+		rsi_dbg(ERR_ZONE, "Failed to prepare probe request\n");
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
+	skb_put(skb, len);
+	rsi_core_xmit(common, skb);
+
+	return 0;
+}
+
+void rsi_fgscan_start(struct work_struct *work)
+{
+	struct rsi_common *common =
+		container_of(work, struct rsi_common, scan_work);
+	struct cfg80211_scan_request *scan_req = common->hwscan;
+	struct ieee80211_channel *cur_chan = NULL;
+	struct cfg80211_scan_info info;
+	u8 i, j;
+
+	if (!scan_req || common->fgscan_in_prog)
+		return;
+
+	common->fgscan_in_prog = true;
+	rsi_dbg(INFO_ZONE, "Foreground scan started...\n");
+
+	info.aborted = false;
+	for (i = 0; i < scan_req->n_channels ; i++) {
+		if (common->iface_down || common->cancel_hwscan) {
+			info.aborted = true;
+			break;
+		}
+
+		cur_chan = scan_req->channels[i];
+		if (cur_chan->flags & IEEE80211_CHAN_DISABLED)
+			continue;
+
+		rsi_dbg(INFO_ZONE, "Scanning chan: %d\n", cur_chan->hw_value);
+
+		rsi_reset_event(&common->chan_set_event);
+		rsi_band_check(common, cur_chan);
+		if (rsi_set_channel(common, cur_chan)) {
+			rsi_dbg(ERR_ZONE, "Failed to set the channel\n");
+			info.aborted = true;
+			break;
+		}
+		rsi_wait_event(&common->chan_set_event,
+			       msecs_to_jiffies(RSI_CHAN_SET_TIME));
+		rsi_reset_event(&common->chan_set_event);
+
+		init_channel_timer(common, RSI_CHAN_DWELL_TIME);
+		for (j = 0; j < scan_req->n_ssids; j++) {
+			rsi_send_probe_request(common, scan_req, j,
+					       cur_chan->hw_value);
+			rsi_reset_event(&common->probe_cfm_event);
+			rsi_wait_event(&common->probe_cfm_event,
+				       msecs_to_jiffies(RSI_PROBE_CFM_TIME));
+			rsi_reset_event(&common->probe_cfm_event);
+		}
+		rsi_wait_event(&common->chan_change_event, EVENT_WAIT_FOREVER);
+		rsi_reset_event(&common->chan_change_event);
+	}
+
+	del_timer(&common->scan_timer);
+	common->fgscan_in_prog = false;
+	ieee80211_scan_completed(common->priv->hw, &info);
+	rsi_dbg(INFO_ZONE, "Foreground scan completed\n");
+	rsi_set_event(&common->cancel_hw_scan_event);
+}
+
+int rsi_send_bgscan_params(struct rsi_common *common, int enable)
+{
+	struct rsi_bgscan_params *params = &common->bgscan;
+	struct cfg80211_scan_request *scan_req = common->hwscan;
+	struct rsi_bgscan_config *bgscan;
+	struct sk_buff *skb;
+	u16 frame_len = sizeof(*bgscan);
+	u8 i;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending bgscan params frame\n", __func__);
+
+	skb = dev_alloc_skb(frame_len);
+	if (!skb)
+		return -ENOMEM;
+	memset(skb->data, 0, frame_len);
+
+	bgscan = (struct rsi_bgscan_config *)skb->data;
+	rsi_set_len_qno(&bgscan->desc_dword0.len_qno,
+			(frame_len - FRAME_DESC_SZ), RSI_WIFI_MGMT_Q);
+	bgscan->desc_dword0.frame_type = BG_SCAN_PARAMS;
+	bgscan->bgscan_threshold = cpu_to_le16(params->bgscan_threshold);
+	bgscan->roam_threshold = cpu_to_le16(params->roam_threshold);
+	if (enable)
+		bgscan->bgscan_periodicity =
+			cpu_to_le16(params->bgscan_periodicity);
+	bgscan->active_scan_duration =
+			cpu_to_le16(params->active_scan_duration);
+	bgscan->passive_scan_duration =
+			cpu_to_le16(params->passive_scan_duration);
+	bgscan->two_probe = params->two_probe;
+
+	bgscan->num_bgscan_channels = scan_req->n_channels;
+	for (i = 0; i < bgscan->num_bgscan_channels; i++)
+		bgscan->channels2scan[i] =
+			cpu_to_le16(scan_req->channels[i]->hw_value);
+
+	skb_put(skb, frame_len);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/* This function sends the probe request to be used by firmware in
+ * background scan
+ */
+int rsi_send_bgscan_probe_req(struct rsi_common *common)
+{
+	struct cfg80211_scan_request *scan_req = common->hwscan;
+	struct rsi_bgscan_probe *bgscan;
+	struct sk_buff *skb;
+	u16 frame_len = sizeof(*bgscan);
+	u16 len = MAX_BGSCAN_PROBE_REQ_LEN;
+	u16 pbreq_len = 0;
+
+	rsi_dbg(MGMT_TX_ZONE,
+		"%s: Sending bgscan probe req frame\n", __func__);
+
+	skb = dev_alloc_skb(frame_len + len);
+	if (!skb)
+		return -ENOMEM;
+	memset(skb->data, 0, frame_len + len);
+
+	bgscan = (struct rsi_bgscan_probe *)skb->data;
+	bgscan->desc_dword0.frame_type = BG_SCAN_PROBE_REQ;
+	bgscan->flags = cpu_to_le16(HOST_BG_SCAN_TRIG);
+	if (common->band == NL80211_BAND_5GHZ) {
+		bgscan->mgmt_rate = cpu_to_le16(RSI_RATE_6);
+		bgscan->def_chan = cpu_to_le16(40);
+	} else {
+		bgscan->mgmt_rate = cpu_to_le16(RSI_RATE_1);
+		bgscan->def_chan = cpu_to_le16(11);
+	}
+	bgscan->channel_scan_time = cpu_to_le16(RSI_CHANNEL_SCAN_TIME);
+
+	/* Append dot11 probe request */
+	rsi_prepare_probe_request(common, scan_req, 0, 0,
+				  &skb->data[frame_len],
+				  &pbreq_len);
+	bgscan->probe_req_length = cpu_to_le16(pbreq_len);
+
+	rsi_set_len_qno(&bgscan->desc_dword0.len_qno,
+			(frame_len - FRAME_DESC_SZ + pbreq_len),
+			RSI_WIFI_MGMT_Q);
+	skb_put(skb, frame_len + pbreq_len);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
 /**
  * rsi_handle_ta_confirm_type() - This function handles the confirm frames.
  * @common: Pointer to the driver private structure.
@@ -1776,15 +2024,37 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 			return 0;
 		}
 		break;
+
+	case SCAN_REQUEST:
+		rsi_dbg(INFO_ZONE, "Set channel confirm\n");
+		rsi_set_event(&common->chan_set_event);
+		break;
+
 	case WAKEUP_SLEEP_REQUEST:
 		rsi_dbg(INFO_ZONE, "Wakeup/Sleep confirmation.\n");
 		return rsi_handle_ps_confirm(adapter, msg);
+
+	case BG_SCAN_PROBE_REQ:
+		rsi_dbg(INFO_ZONE, "BG scan complete event\n");
+		if (common->bgscan_en) {
+			struct cfg80211_scan_info info;
+
+			if (!rsi_send_bgscan_params(common, RSI_STOP_BGSCAN))
+				common->bgscan_en = 0;
+			info.aborted = false;
+			ieee80211_scan_completed(adapter->hw, &info);
+			rsi_set_event(&common->cancel_hw_scan_event);
+		}
+		rsi_dbg(INFO_ZONE, "Background scan completed\n");
+		break;
+
 	default:
 		rsi_dbg(INFO_ZONE, "%s: Invalid TA confirm pkt received\n",
 			__func__);
 		break;
 	}
 	return 0;
+
 out:
 	rsi_dbg(ERR_ZONE, "%s: Unable to send pkt/Invalid frame received\n",
 		__func__);
@@ -1852,8 +2122,9 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 	case TX_STATUS_IND:
 		if (msg[15] == PROBEREQ_CONFIRM) {
 			common->mgmt_q_block = false;
-			rsi_dbg(FSM_ZONE, "%s: Probe confirm received\n",
+			rsi_dbg(INFO_ZONE, "%s: Mgmt queue unblocked\n",
 				__func__);
+			rsi_set_event(&common->probe_cfm_event);
 		}
 		break;
 	case BEACON_EVENT_IND:
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index ef4fa32..3dd08f5 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -164,6 +164,28 @@ struct transmit_q_stats {
 	u32 total_tx_pkt_freed[NUM_EDCA_QUEUES + 2];
 };
 
+#define MAX_BGSCAN_CHANNELS_DUAL_BAND	38
+#define MAX_BGSCAN_PROBE_REQ_LEN	0x05DC
+#define BG_PROBE_REQ_LEN_CHECK		0x78
+#define RSI_BGSCAN_START		0x1
+#define RSI_BGSCAN_STOP			0x0
+#define RSI_DEF_BGSCAN_THRLD		0x0
+#define RSI_DEF_ROAM_THRLD		0xa
+#define RSI_BGSCAN_PERIODICITY		0x1e
+#define RSI_ACTIVE_SCAN_TIME		0x14
+#define RSI_PASSIVE_SCAN_TIME		0x46
+#define MAX_BGSCAN_CHANNELS_2GHZ	0xe
+#define RSI_CHANNEL_SCAN_TIME		20
+struct rsi_bgscan_params {
+	u16 bgscan_threshold;
+	u16 roam_threshold;
+	u16 bgscan_periodicity;
+	u8 num_bgscan_channels;
+	u8 two_probe;
+	u16 active_scan_duration;
+	u16 passive_scan_duration;
+};
+
 struct vif_priv {
 	bool is_ht;
 	bool sgi;
@@ -294,6 +316,20 @@ struct rsi_common {
 	struct ieee80211_vif *roc_vif;
 
 	void *bt_adapter;
+
+	struct ieee80211_vif *scan_vif;
+	struct cfg80211_scan_request *hwscan;
+	struct rsi_bgscan_params bgscan;
+	struct workqueue_struct *scan_workqueue;
+	struct work_struct scan_work;
+	struct rsi_event chan_set_event;
+	struct rsi_event probe_cfm_event;
+	struct rsi_event chan_change_event;
+	struct rsi_event cancel_hw_scan_event;
+	struct timer_list scan_timer;
+	bool fgscan_in_prog;
+	bool bgscan_en;
+	bool cancel_hwscan;
 };
 
 struct eepromrw_info {
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index cf6567a..b7f63c9 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -221,6 +221,12 @@
 #define RSI_WOW_DISCONNECT		BIT(5)
 #endif
 
+#define RSI_MAX_SCAN_SSIDS		16
+#define RSI_MAX_SCAN_IE_LEN		256
+#define RSI_CHAN_DWELL_TIME		300
+#define RSI_CHAN_SET_TIME		50
+#define RSI_PROBE_CFM_TIME		50
+
 enum opmode {
 	RSI_OPMODE_UNSUPPORTED = -1,
 	RSI_OPMODE_AP = 0,
@@ -610,6 +616,34 @@ struct rsi_wowlan_req {
 	u16 host_sleep_status;
 } __packed;
 
+#define RSI_START_BGSCAN		1
+#define RSI_STOP_BGSCAN			0
+#define HOST_BG_SCAN_TRIG		BIT(4)
+struct rsi_bgscan_config {
+	struct rsi_cmd_desc_dword0 desc_dword0;
+	__le64 reserved;
+	__le32 reserved1;
+	__le16 bgscan_threshold;
+	__le16 roam_threshold;
+	__le16 bgscan_periodicity;
+	u8 num_bgscan_channels;
+	u8 two_probe;
+	__le16 active_scan_duration;
+	__le16 passive_scan_duration;
+	__le16 channels2scan[MAX_BGSCAN_CHANNELS_DUAL_BAND];
+} __packed;
+
+struct rsi_bgscan_probe {
+	struct rsi_cmd_desc_dword0 desc_dword0;
+	__le64 reserved;
+	__le32 reserved1;
+	__le16 mgmt_rate;
+	__le16 flags;
+	__le16 def_chan;
+	__le16 channel_scan_time;
+	__le16 probe_req_length;
+} __packed;
+
 static inline u32 rsi_get_queueno(u8 *addr, u16 offset)
 {
 	return (le16_to_cpu(*(__le16 *)&addr[offset]) & 0x7000) >> 12;
@@ -677,4 +711,14 @@ int rsi_send_wowlan_request(struct rsi_common *common, u16 flags,
 #endif
 int rsi_send_ps_request(struct rsi_hw *adapter, bool enable,
 			struct ieee80211_vif *vif);
+int rsi_prepare_probe_request(struct rsi_common *common,
+			      struct cfg80211_scan_request *scan_req,
+			      u8 n_ssid, u8 channel, u8 *pbreq, u16 *pbreq_len);
+int rsi_send_probe_request(struct rsi_common *common,
+			   struct cfg80211_scan_request *scan_req, u8 n_ssid,
+			   u8 channel);
+void rsi_fgscan_start(struct work_struct *data);
+void init_bgscan_params(struct rsi_common *common);
+int rsi_send_bgscan_params(struct rsi_common *common, int enable);
+int rsi_send_bgscan_probe_req(struct rsi_common *common);
 #endif
-- 
2.7.4
