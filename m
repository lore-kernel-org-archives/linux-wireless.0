Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9034 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab2GKTXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 15:23:15 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath6kl-devel@qualcomm.com>, <kvalo@qca.qualcomm.com>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH] ath6kl: support TX error rate notification
Date: Wed, 11 Jul 2012 12:23:09 -0700
Message-ID: <1342034589-3979-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120711_212339_872098_28F42F09)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath6kl firmware can monitor a connection and report when a certain
TX failure threshold is crossed. Support this configuration and event
reporting on compatible firmwares.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   19 +++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    3 ++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   46 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |   35 +++++++++++++++++++++
 4 files changed, 103 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index ca54154..ddcfc95 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3326,6 +3326,24 @@ static int ath6kl_cfg80211_set_bitrate(struct wiphy *wiphy,
 					   mask);
 }
 
+static int ath6kl_cfg80211_set_txe_config(struct wiphy *wiphy,
+					  struct net_device *dev,
+					  u32 rate, u32 pkts, u32 intvl)
+{
+	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
+
+	if (vif->nw_type != INFRA_NETWORK ||
+	    !test_bit(ATH6KL_FW_CAPABILITY_TX_ERR_NOTIFY, ar->fw_capabilities))
+		return -EOPNOTSUPP;
+
+	if (vif->sme_state != SME_CONNECTED)
+		return -ENOTCONN;
+
+	return ath6kl_wmi_set_txe_notify(ar->wmi, vif->fw_vif_idx,
+					 rate, pkts, intvl);
+}
+
 static const struct ieee80211_txrx_stypes
 ath6kl_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	[NL80211_IFTYPE_STATION] = {
@@ -3392,6 +3410,7 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.sched_scan_start = ath6kl_cfg80211_sscan_start,
 	.sched_scan_stop = ath6kl_cfg80211_sscan_stop,
 	.set_bitrate_mask = ath6kl_cfg80211_set_bitrate,
+	.set_cqm_txe_config = ath6kl_cfg80211_set_txe_config,
 };
 
 void ath6kl_cfg80211_stop(struct ath6kl_vif *vif)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c655438..fb81380 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -121,6 +121,9 @@ enum ath6kl_fw_capability {
 	/* FW sets mac_addr[4] ^= 0x80 for newly created interfaces */
 	ATH6KL_FW_CAPABILITY_CUSTOM_MAC_ADDR,
 
+	/* Firmware supports TX error rate notification */
+	ATH6KL_FW_CAPABILITY_TX_ERR_NOTIFY,
+
 	/* this needs to be last */
 	ATH6KL_FW_CAPABILITY_MAX,
 };
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 3629e86..2fa1bef 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1531,6 +1531,49 @@ static int ath6kl_wmi_cac_event_rx(struct wmi *wmi, u8 *datap, int len,
 	return 0;
 }
 
+static int ath6kl_wmi_txe_notify_event_rx(struct wmi *wmi, u8 *datap, int len,
+					  struct ath6kl_vif *vif)
+{
+	struct wmi_txe_notify_event *ev;
+	u32 rate;
+	u32 pkts;
+
+	if (len < sizeof(*ev))
+		return -EINVAL;
+
+	if (vif->sme_state != SME_CONNECTED)
+		return -ENOTCONN;
+
+	ev = (struct wmi_txe_notify_event *) datap;
+	rate = le32_to_cpu(ev->rate);
+	pkts = le32_to_cpu(ev->pkts);
+	ath6kl_dbg(ATH6KL_DBG_WMI, "TXE notify event: peer %pM rate %d pkts %d\n",
+		   vif->bssid, rate, pkts);
+
+	cfg80211_cqm_txe_notify(vif->ndev, vif->bssid, pkts, rate, GFP_KERNEL);
+
+	return 0;
+}
+
+int ath6kl_wmi_set_txe_notify(struct wmi *wmi, u8 idx,
+			      u32 rate, u32 pkts, u32 intvl)
+{
+	struct sk_buff *skb;
+	struct wmi_txe_notify_cmd *cmd;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_txe_notify_cmd *) skb->data;
+	cmd->rate = rate;
+	cmd->pkts = pkts;
+	cmd->intvl = intvl;
+
+	return ath6kl_wmi_cmd_send(wmi, idx, skb, WMI_SET_TXE_NOTIFY_CMD,
+				   NO_SYNC_WMIFLAG);
+}
+
 int ath6kl_wmi_set_rssi_filter_cmd(struct wmi *wmi, u8 if_idx, s8 rssi)
 {
 	struct sk_buff *skb;
@@ -3768,6 +3811,9 @@ static int ath6kl_wmi_proc_events_vif(struct wmi *wmi, u16 if_idx, u16 cmd_id,
 	case WMI_RX_ACTION_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_RX_ACTION_EVENTID\n");
 		return ath6kl_wmi_rx_action_event_rx(wmi, datap, len, vif);
+	case WMI_TXE_NOTIFY_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_TXE_NOTIFY_EVENTID\n");
+		return ath6kl_wmi_txe_notify_event_rx(wmi, datap, len, vif);
 	default:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "unknown cmd id 0x%x\n", cmd_id);
 		return -EINVAL;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index b5deaff..c81b9d6 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -632,6 +632,12 @@ enum wmi_cmd_id {
 	WMI_SET_REGDOMAIN_CMDID,
 
 	WMI_SET_RSSI_FILTER_CMDID,
+
+	WMI_SET_KEEP_ALIVE_EXT,
+
+	WMI_VOICE_DETECTION_ENABLE_CMDID,
+
+	WMI_SET_TXE_NOTIFY_CMD,
 };
 
 enum wmi_mgmt_frame_type {
@@ -1464,6 +1470,20 @@ enum wmi_event_id {
 	WMI_P2P_CAPABILITIES_EVENTID,
 	WMI_RX_ACTION_EVENTID,
 	WMI_P2P_INFO_EVENTID,
+
+	/* WPS Events */
+	WMI_WPS_GET_STATUS_EVENTID,
+	WMI_WPS_PROFILE_EVENTID,
+
+	/* more P2P events */
+	WMI_NOA_INFO_EVENTID,
+	WMI_OPPPS_INFO_EVENTID,
+	WMI_PORT_STATUS_EVENTID,
+
+	/* 802.11w */
+	WMI_GET_RSN_CAP_EVENTID,
+
+	WMI_TXE_NOTIFY_EVENTID,
 };
 
 struct wmi_ready_event_2 {
@@ -2096,6 +2116,19 @@ struct wmi_del_wow_pattern_cmd {
 	__le16 filter_id;
 } __packed;
 
+/* WMI_SET_TXE_NOTIFY_CMD */
+struct wmi_txe_notify_cmd {
+	u32 rate;
+	u32 pkts;
+	u32 intvl;
+} __packed;
+
+/* WMI_TXE_NOTIFY_EVENTID */
+struct wmi_txe_notify_event {
+	u32 rate;
+	u32 pkts;
+} __packed;
+
 /* WMI_SET_AKMP_PARAMS_CMD */
 
 struct wmi_pmkid {
@@ -2610,6 +2643,8 @@ int ath6kl_wmi_mcast_filter_cmd(struct wmi *wmi, u8 if_idx, bool mc_all_on);
 int ath6kl_wmi_add_del_mcast_filter_cmd(struct wmi *wmi, u8 if_idx,
 					u8 *filter, bool add_filter);
 int ath6kl_wmi_sta_bmiss_enhance_cmd(struct wmi *wmi, u8 if_idx, bool enable);
+int ath6kl_wmi_set_txe_notify(struct wmi *wmi, u8 idx,
+			      u32 rate, u32 pkts, u32 intvl);
 
 /* AP mode uAPSD */
 int ath6kl_wmi_ap_set_apsd(struct wmi *wmi, u8 if_idx, u8 enable);
-- 
1.7.4.1

