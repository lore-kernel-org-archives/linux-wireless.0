Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10720 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab2GRCkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 22:40:05 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	"Thomas Pedersen" <c_tpeder@qca.qualcomm.com>
Subject: [PATCH v3] ath6kl: support TX error rate notification
Date: Tue, 17 Jul 2012 19:39:55 -0700
Message-ID: <1342579195-18521-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120718_044010_258914_265CE137)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath6kl firmware can monitor a connection and report when a certain
TX failure threshold is crossed. Support this configuration and event
reporting on compatible firmwares.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
v2:
	endianness & formatting (Kalle)
v3:
	report configured interval

Kalle,

Please cherry-pick "84f10708f73254878246772cead70a2eb6a123f2" from w-t HEAD to
support this.

Thanks,
Thomas

 drivers/net/wireless/ath/ath6kl/cfg80211.c |   22 +++++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    4 ++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   47 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |   35 ++++++++++++++++++++
 4 files changed, 108 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index ca54154..adca02e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3326,6 +3326,27 @@ static int ath6kl_cfg80211_set_bitrate(struct wiphy *wiphy,
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
+	/* save this since the firmware won't report the interval */
+	vif->txe_intvl = intvl;
+
+	return ath6kl_wmi_set_txe_notify(ar->wmi, vif->fw_vif_idx,
+					 rate, pkts, intvl);
+}
+
 static const struct ieee80211_txrx_stypes
 ath6kl_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	[NL80211_IFTYPE_STATION] = {
@@ -3392,6 +3413,7 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.sched_scan_start = ath6kl_cfg80211_sscan_start,
 	.sched_scan_stop = ath6kl_cfg80211_sscan_stop,
 	.set_bitrate_mask = ath6kl_cfg80211_set_bitrate,
+	.set_cqm_txe_config = ath6kl_cfg80211_set_txe_config,
 };
 
 void ath6kl_cfg80211_stop(struct ath6kl_vif *vif)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c655438..48f1b6d 100644
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
@@ -586,6 +589,7 @@ struct ath6kl_vif {
 	u16 assoc_bss_beacon_int;
 	u16 listen_intvl_t;
 	u16 bmiss_time_t;
+	u32 txe_intvl;
 	u16 bg_scan_period;
 	u8 assoc_bss_dtim_period;
 	struct net_device_stats net_stats;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 3629e86..2b66d95 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1531,6 +1531,50 @@ static int ath6kl_wmi_cac_event_rx(struct wmi *wmi, u8 *datap, int len,
 	return 0;
 }
 
+static int ath6kl_wmi_txe_notify_event_rx(struct wmi *wmi, u8 *datap, int len,
+					  struct ath6kl_vif *vif)
+{
+	struct wmi_txe_notify_event *ev;
+	u32 rate, pkts;
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
+
+	ath6kl_dbg(ATH6KL_DBG_WMI, "TXE notify event: peer %pM rate %d% pkts %d intvl %ds\n",
+		   vif->bssid, rate, pkts, vif->txe_intvl);
+
+	cfg80211_cqm_txe_notify(vif->ndev, vif->bssid, pkts,
+				rate, vif->txe_intvl, GFP_KERNEL);
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
+	cmd->rate = cpu_to_le32(rate);
+	cmd->pkts = cpu_to_le32(pkts);
+	cmd->intvl = cpu_to_le32(intvl);
+
+	return ath6kl_wmi_cmd_send(wmi, idx, skb, WMI_SET_TXE_NOTIFY_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
 int ath6kl_wmi_set_rssi_filter_cmd(struct wmi *wmi, u8 if_idx, s8 rssi)
 {
 	struct sk_buff *skb;
@@ -3768,6 +3812,9 @@ static int ath6kl_wmi_proc_events_vif(struct wmi *wmi, u16 if_idx, u16 cmd_id,
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
index b5deaff..8e8846f 100644
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
+	WMI_SET_TXE_NOTIFY_CMDID,
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
 
+/* WMI_SET_TXE_NOTIFY_CMDID */
+struct wmi_txe_notify_cmd {
+	__le32 rate;
+	__le32 pkts;
+	__le32 intvl;
+} __packed;
+
+/* WMI_TXE_NOTIFY_EVENTID */
+struct wmi_txe_notify_event {
+	__le32 rate;
+	__le32 pkts;
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

