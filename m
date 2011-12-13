Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7667 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1LMVcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 16:32:43 -0500
From: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Cc: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>,
	Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
Subject: [PATCH] ath6kl: support for P2P mgmt operations on station interface
Date: Tue, 13 Dec 2011 13:32:12 -0800
Message-ID: <1323811932-5724-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com> (sfid-20111213_223248_389397_8C292DDD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables support for doing P2P management operations like device
discovery on top of a station interface. After group formation, the station
interface will become a P2P GO/client interface as the case may be.

This feature requires modifications to a couple of existing WMI structures and
therefore new command ids and structures have been defined in order to be
compatible with older firmware versions and other chips. The exception here is
the wmi_connect_cmd. Adding a new field to the end of the structure will not
cause any issues with previous firmware versions since firmware only checks for
minimum length of the command. The other structures are of variable length,
hence it was not possible to add new fields to the end. 

The new command ids have to be added to the end of enum wmi_cmd_id, so it has
updated to match the firmware. 

The driver will support both the 'old' and the 'new' commands for a while by
checking the firmware capabilities. 

Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>

---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   60 +++++++++++--
 drivers/net/wireless/ath/ath6kl/core.h     |    7 ++
 drivers/net/wireless/ath/ath6kl/wmi.c      |  113 ++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/wmi.h      |  127 +++++++++++++++++++++++++++-
 4 files changed, 297 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0279bcc..6c59a21 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -415,6 +415,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
 	int status;
+	u8 nw_subtype = (ar->p2p) ? SUBTYPE_P2PDEV : SUBTYPE_NONE;
 
 	ath6kl_cfg80211_sscan_disable(vif);
 
@@ -557,6 +558,9 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
 	vif->nw_type = vif->next_mode;
 
+	if (vif->wdev.iftype == NL80211_IFTYPE_P2P_CLIENT)
+		nw_subtype = SUBTYPE_P2PCLIENT;
+
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 		   "%s: connect called with authmode %d dot11 auth %d"
 		   " PW crypto %d PW crypto len %d GRP crypto %d"
@@ -574,7 +578,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 					vif->grp_crypto, vif->grp_crypto_len,
 					vif->ssid_len, vif->ssid,
 					vif->req_bssid, vif->ch_hint,
-					ar->connect_ctrl_flags);
+					ar->connect_ctrl_flags, nw_subtype);
 
 	up(&ar->sem);
 
@@ -916,9 +920,25 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	if (test_bit(CONNECTED, &vif->flags))
 		force_fg_scan = 1;
 
-	ret = ath6kl_wmi_startscan_cmd(ar->wmi, vif->fw_vif_idx, WMI_LONG_SCAN,
-				       force_fg_scan, false, 0, 0, n_channels,
-				       channels);
+	if (test_bit(ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX,
+		    ar->fw_capabilities)) {
+		/*
+		 * If capable of doing P2P mgmt operations using
+		 * station interface, send additional information like
+		 * supported rates to advertise and xmit rates for
+		 * probe requests
+		 */
+		ret = ath6kl_wmi_beginscan_cmd(ar->wmi, vif->fw_vif_idx,
+						WMI_LONG_SCAN, force_fg_scan,
+						false, 0, 0, n_channels,
+						channels, request->no_cck,
+						request->rates);
+	} else {
+		ret = ath6kl_wmi_startscan_cmd(ar->wmi, vif->fw_vif_idx,
+						WMI_LONG_SCAN, force_fg_scan,
+						false, 0, 0, n_channels,
+						channels);
+	}
 	if (ret)
 		ath6kl_err("wmi_startscan_cmd failed\n");
 	else
@@ -1487,7 +1507,7 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 					vif->grp_crypto, vif->grp_crypto_len,
 					vif->ssid_len, vif->ssid,
 					vif->req_bssid, vif->ch_hint,
-					ar->connect_ctrl_flags);
+					ar->connect_ctrl_flags, SUBTYPE_NONE);
 	set_bit(CONNECT_PEND, &vif->flags);
 
 	return 0;
@@ -2194,6 +2214,16 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	p.dot11_auth_mode = vif->dot11_auth_mode;
 	p.ch = cpu_to_le16(vif->next_chan);
 
+	if (vif->wdev.iftype == NL80211_IFTYPE_P2P_GO) {
+		p.nw_subtype = SUBTYPE_P2PGO;
+	} else {
+		/*
+		 * Due to firmware limitation, it is not possible to
+		 * do P2P mgmt operations in AP mode
+		 */
+		p.nw_subtype = SUBTYPE_NONE;
+	}
+
 	res = ath6kl_wmi_ap_profile_commit(ar->wmi, vif->fw_vif_idx, &p);
 	if (res < 0)
 		return res;
@@ -2359,9 +2389,23 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	*cookie = id;
-	return ath6kl_wmi_send_action_cmd(ar->wmi, vif->fw_vif_idx, id,
-					  chan->center_freq, wait,
-					  buf, len);
+
+	if (test_bit(ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX,
+		    ar->fw_capabilities)) {
+		/*
+		 * If capable of doing P2P mgmt operations using
+		 * station interface, send additional information like
+		 * supported rates to advertise and xmit rates for
+		 * probe requests
+		 */
+		return ath6kl_wmi_send_mgmt_cmd(ar->wmi, vif->fw_vif_idx, id,
+						chan->center_freq, wait,
+						buf, len, no_cck);
+	} else {
+		return ath6kl_wmi_send_action_cmd(ar->wmi, vif->fw_vif_idx, id,
+						  chan->center_freq, wait,
+						  buf, len);
+	}
 }
 
 static void ath6kl_mgmt_frame_register(struct wiphy *wiphy,
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 8bc1907..541a6d3 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -78,6 +78,13 @@ enum ath6kl_fw_capability {
 	ATH6KL_FW_CAPABILITY_HOST_P2P = 0,
 	ATH6KL_FW_CAPABILITY_SCHED_SCAN = 1,
 
+	/*
+	 * Firmware is capable of supporting P2P mgmt operations on a
+	 * station interface. After group formation, the station
+	 * interface will become a P2P client/GO interface as the case may be
+	 */
+	ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX,
+
 	/* this needs to be last */
 	ATH6KL_FW_CAPABILITY_MAX,
 };
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 75e0f5e..f6f2aa2 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1704,7 +1704,8 @@ int ath6kl_wmi_connect_cmd(struct wmi *wmi, u8 if_idx,
 			   u8 pairwise_crypto_len,
 			   enum crypto_type group_crypto,
 			   u8 group_crypto_len, int ssid_len, u8 *ssid,
-			   u8 *bssid, u16 channel, u32 ctrl_flags)
+			   u8 *bssid, u16 channel, u32 ctrl_flags,
+			   u8 nw_subtype)
 {
 	struct sk_buff *skb;
 	struct wmi_connect_cmd *cc;
@@ -1744,6 +1745,7 @@ int ath6kl_wmi_connect_cmd(struct wmi *wmi, u8 if_idx,
 	cc->grp_crypto_len = group_crypto_len;
 	cc->ch = cpu_to_le16(channel);
 	cc->ctrl_flags = cpu_to_le32(ctrl_flags);
+	cc->nw_subtype = nw_subtype;
 
 	if (bssid != NULL)
 		memcpy(cc->bssid, bssid, ETH_ALEN);
@@ -1796,6 +1798,72 @@ int ath6kl_wmi_disconnect_cmd(struct wmi *wmi, u8 if_idx)
 	return ret;
 }
 
+int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
+			     enum wmi_scan_type scan_type,
+			     u32 force_fgscan, u32 is_legacy,
+			     u32 home_dwell_time, u32 force_scan_interval,
+			     s8 num_chan, u16 *ch_list, u32 no_cck, u32 *rates)
+{
+	struct sk_buff *skb;
+	struct wmi_begin_scan_cmd *sc;
+	s8 size;
+	int i, band, ret;
+	struct ath6kl *ar = wmi->parent_dev;
+	int num_rates;
+
+	size = sizeof(struct wmi_begin_scan_cmd);
+
+	if ((scan_type != WMI_LONG_SCAN) && (scan_type != WMI_SHORT_SCAN))
+		return -EINVAL;
+
+	if (num_chan > WMI_MAX_CHANNELS)
+		return -EINVAL;
+
+	if (num_chan)
+		size += sizeof(u16) * (num_chan - 1);
+
+	skb = ath6kl_wmi_get_new_buf(size);
+	if (!skb)
+		return -ENOMEM;
+
+	sc = (struct wmi_begin_scan_cmd *) skb->data;
+	sc->scan_type = scan_type;
+	sc->force_fg_scan = cpu_to_le32(force_fgscan);
+	sc->is_legacy = cpu_to_le32(is_legacy);
+	sc->home_dwell_time = cpu_to_le32(home_dwell_time);
+	sc->force_scan_intvl = cpu_to_le32(force_scan_interval);
+	sc->no_cck = cpu_to_le32(no_cck);
+	sc->num_ch = num_chan;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		struct ieee80211_supported_band *sband =
+		    ar->wiphy->bands[band];
+		u32 ratemask = rates[band];
+		u8 *supp_rates = sc->supp_rates[band].rates;
+		num_rates = 0;
+
+		for (i = 0; i < sband->n_bitrates; i++) {
+			if ((BIT(i) & ratemask) == 0)
+				continue; /* skip rate */
+			supp_rates[num_rates++] =
+			    (u8) (sband->bitrates[i].bitrate / 5);
+		}
+		sc->supp_rates[band].nrates = num_rates;
+	}
+
+	for (i = 0; i < num_chan; i++)
+		sc->ch_list[i] = cpu_to_le16(ch_list[i]);
+
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_BEGIN_SCAN_CMDID,
+				  NO_SYNC_WMIFLAG);
+
+	return ret;
+}
+
+/* ath6kl_wmi_start_scan_cmd is to be deprecated. Use
+ * ath6kl_wmi_begin_scan_cmd instead. The new function supports P2P
+ * mgmt operations using station interface.
+ */
 int ath6kl_wmi_startscan_cmd(struct wmi *wmi, u8 if_idx,
 			     enum wmi_scan_type scan_type,
 			     u32 force_fgscan, u32 is_legacy,
@@ -3006,6 +3074,10 @@ int ath6kl_wmi_remain_on_chnl_cmd(struct wmi *wmi, u8 if_idx, u32 freq, u32 dur)
 				   NO_SYNC_WMIFLAG);
 }
 
+/* ath6kl_wmi_send_action_cmd is to be deprecated. Use
+ * ath6kl_wmi_send_mgmt_cmd instead. The new function supports P2P
+ * mgmt operations using station interface.
+ */
 int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u8 if_idx, u32 id, u32 freq,
 			       u32 wait, const u8 *data, u16 data_len)
 {
@@ -3043,6 +3115,45 @@ int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u8 if_idx, u32 id, u32 freq,
 				   NO_SYNC_WMIFLAG);
 }
 
+int ath6kl_wmi_send_mgmt_cmd(struct wmi *wmi, u8 if_idx, u32 id, u32 freq,
+			       u32 wait, const u8 *data, u16 data_len,
+			       u32 no_cck)
+{
+	struct sk_buff *skb;
+	struct wmi_send_mgmt_cmd *p;
+	u8 *buf;
+
+	if (wait)
+		return -EINVAL; /* Offload for wait not supported */
+
+	buf = kmalloc(data_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*p) + data_len);
+	if (!skb) {
+		kfree(buf);
+		return -ENOMEM;
+	}
+
+	kfree(wmi->last_mgmt_tx_frame);
+	memcpy(buf, data, data_len);
+	wmi->last_mgmt_tx_frame = buf;
+	wmi->last_mgmt_tx_frame_len = data_len;
+
+	ath6kl_dbg(ATH6KL_DBG_WMI, "send_action_cmd: id=%u freq=%u wait=%u "
+		   "len=%u\n", id, freq, wait, data_len);
+	p = (struct wmi_send_mgmt_cmd *) skb->data;
+	p->id = cpu_to_le32(id);
+	p->freq = cpu_to_le32(freq);
+	p->wait = cpu_to_le32(wait);
+	p->no_cck = cpu_to_le32(no_cck);
+	p->len = cpu_to_le16(data_len);
+	memcpy(p->data, data, data_len);
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SEND_MGMT_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
 int ath6kl_wmi_send_probe_response_cmd(struct wmi *wmi, u8 if_idx, u32 freq,
 				       const u8 *dst, const u8 *data,
 				       u16 data_len)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 85dcdad..42ac311 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -329,6 +329,10 @@ enum wmi_cmd_id {
 	WMI_SYNCHRONIZE_CMDID,
 	WMI_CREATE_PSTREAM_CMDID,
 	WMI_DELETE_PSTREAM_CMDID,
+	/* WMI_START_SCAN_CMDID is to be deprecated. Use
+	 * WMI_BEGIN_SCAN_CMDID instead. The new cmd supports P2P mgmt
+	 * operations using station interface.
+	 */
 	WMI_START_SCAN_CMDID,
 	WMI_SET_SCAN_PARAMS_CMDID,
 	WMI_SET_BSS_FILTER_CMDID,
@@ -542,12 +546,61 @@ enum wmi_cmd_id {
 	WMI_GTK_OFFLOAD_OP_CMDID,
 	WMI_REMAIN_ON_CHNL_CMDID,
 	WMI_CANCEL_REMAIN_ON_CHNL_CMDID,
+	/* WMI_SEND_ACTION_CMDID is to be deprecated. Use
+	 * WMI_SEND_MGMT_CMDID instead. The new cmd supports P2P mgmt
+	 * operations using station interface.
+	 */
 	WMI_SEND_ACTION_CMDID,
 	WMI_PROBE_REQ_REPORT_CMDID,
 	WMI_DISABLE_11B_RATES_CMDID,
 	WMI_SEND_PROBE_RESPONSE_CMDID,
 	WMI_GET_P2P_INFO_CMDID,
 	WMI_AP_JOIN_BSS_CMDID,
+
+	WMI_SMPS_ENABLE_CMDID,
+	WMI_SMPS_CONFIG_CMDID,
+	WMI_SET_RATECTRL_PARM_CMDID,
+	/*  LPL specific commands*/
+	WMI_LPL_FORCE_ENABLE_CMDID,
+	WMI_LPL_SET_POLICY_CMDID,
+	WMI_LPL_GET_POLICY_CMDID,
+	WMI_LPL_GET_HWSTATE_CMDID,
+	WMI_LPL_SET_PARAMS_CMDID,
+	WMI_LPL_GET_PARAMS_CMDID,
+
+	WMI_SET_BUNDLE_PARAM_CMDID,
+
+	/*GreenTx specific commands*/
+
+	WMI_GREENTX_PARAMS_CMDID,
+
+	WMI_RTT_MEASREQ_CMDID,
+	WMI_RTT_CAPREQ_CMDID,
+	WMI_RTT_STATUSREQ_CMDID,
+
+	/* WPS Commands */
+	WMI_WPS_START_CMDID,
+	WMI_GET_WPS_STATUS_CMDID,
+
+	/* More P2P commands */
+	WMI_SET_NOA_CMDID,
+	WMI_GET_NOA_CMDID,
+	WMI_SET_OPPPS_CMDID,
+	WMI_GET_OPPPS_CMDID,
+	WMI_ADD_PORT_CMDID,
+	WMI_DEL_PORT_CMDID,
+
+	/* 802.11w cmd */
+	WMI_SET_RSN_CAP_CMDID,
+	WMI_GET_RSN_CAP_CMDID,
+	WMI_SET_IGTK_CMDID,
+
+	WMI_RX_FILTER_COALESCE_FILTER_OP_CMDID,
+	WMI_RX_FILTER_SET_FRAME_TEST_LIST_CMDID,
+
+	WMI_SEND_MGMT_CMDID,
+	WMI_BEGIN_SCAN_CMDID,
+
 };
 
 enum wmi_mgmt_frame_type {
@@ -567,6 +620,14 @@ enum network_type {
 	AP_NETWORK = 0x10,
 };
 
+enum network_subtype {
+	SUBTYPE_NONE,
+	SUBTYPE_BT,
+	SUBTYPE_P2PDEV,
+	SUBTYPE_P2PCLIENT,
+	SUBTYPE_P2PGO,
+};
+
 enum dot11_auth_mode {
 	OPEN_AUTH = 0x01,
 	SHARED_AUTH = 0x02,
@@ -639,6 +700,7 @@ struct wmi_connect_cmd {
 	__le16 ch;
 	u8 bssid[ETH_ALEN];
 	__le32 ctrl_flags;
+	u8 nw_subtype;
 } __packed;
 
 /* WMI_RECONNECT_CMDID */
@@ -726,6 +788,43 @@ enum wmi_scan_type {
 	WMI_SHORT_SCAN = 1,
 };
 
+struct wmi_supp_rates {
+	u8 nrates;
+	u8 rates[ATH6KL_RATE_MAXSIZE];
+};
+
+struct wmi_begin_scan_cmd {
+	__le32 force_fg_scan;
+
+	/* for legacy cisco AP compatibility */
+	__le32 is_legacy;
+
+	/* max duration in the home channel(msec) */
+	__le32 home_dwell_time;
+
+	/* time interval between scans (msec) */
+	__le32 force_scan_intvl;
+
+	/* no CCK rates */
+	__le32 no_cck;
+
+	/* enum wmi_scan_type */
+	u8 scan_type;
+
+	/* Supported rates to advertise in the probe request frames */
+	struct wmi_supp_rates supp_rates[IEEE80211_NUM_BANDS];
+
+	/* how many channels follow */
+	u8 num_ch;
+
+	/* channels in Mhz */
+	__le16 ch_list[1];
+} __packed;
+
+/* wmi_start_scan_cmd is to be deprecated. Use
+ * wmi_begin_scan_cmd instead. The new structure supports P2P mgmt
+ * operations using station interface.
+ */
 struct wmi_start_scan_cmd {
 	__le32 force_fg_scan;
 
@@ -2036,6 +2135,10 @@ struct wmi_remain_on_chnl_cmd {
 	__le32 duration;
 } __packed;
 
+/* wmi_send_action_cmd is to be deprecated. Use
+ * wmi_send_mgmt_cmd instead. The new structure supports P2P mgmt
+ * operations using station interface.
+ */
 struct wmi_send_action_cmd {
 	__le32 id;
 	__le32 freq;
@@ -2044,6 +2147,15 @@ struct wmi_send_action_cmd {
 	u8 data[0];
 } __packed;
 
+struct wmi_send_mgmt_cmd {
+	__le32 id;
+	__le32 freq;
+	__le32 wait;
+	__le32 no_cck;
+	__le16 len;
+	u8 data[0];
+} __packed;
+
 struct wmi_tx_status_event {
 	__le32 id;
 	u8 ack_status;
@@ -2232,7 +2344,8 @@ int ath6kl_wmi_connect_cmd(struct wmi *wmi, u8 if_idx,
 			   u8 pairwise_crypto_len,
 			   enum crypto_type group_crypto,
 			   u8 group_crypto_len, int ssid_len, u8 *ssid,
-			   u8 *bssid, u16 channel, u32 ctrl_flags);
+			   u8 *bssid, u16 channel, u32 ctrl_flags,
+			   u8 nw_subtype);
 
 int ath6kl_wmi_reconnect_cmd(struct wmi *wmi, u8 if_idx, u8 *bssid,
 			     u16 channel);
@@ -2242,6 +2355,14 @@ int ath6kl_wmi_startscan_cmd(struct wmi *wmi, u8 if_idx,
 			     u32 force_fgscan, u32 is_legacy,
 			     u32 home_dwell_time, u32 force_scan_interval,
 			     s8 num_chan, u16 *ch_list);
+
+int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
+			     enum wmi_scan_type scan_type,
+			     u32 force_fgscan, u32 is_legacy,
+			     u32 home_dwell_time, u32 force_scan_interval,
+			     s8 num_chan, u16 *ch_list, u32 no_cck,
+			     u32 *rates);
+
 int ath6kl_wmi_scanparams_cmd(struct wmi *wmi, u8 if_idx, u16 fg_start_sec,
 			      u16 fg_end_sec, u16 bg_sec,
 			      u16 minact_chdw_msec, u16 maxact_chdw_msec,
@@ -2336,6 +2457,10 @@ int ath6kl_wmi_remain_on_chnl_cmd(struct wmi *wmi, u8 if_idx, u32 freq,
 int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u8 if_idx, u32 id, u32 freq,
 			       u32 wait, const u8 *data, u16 data_len);
 
+int ath6kl_wmi_send_mgmt_cmd(struct wmi *wmi, u8 if_idx, u32 id, u32 freq,
+			       u32 wait, const u8 *data, u16 data_len,
+			       u32 no_cck);
+
 int ath6kl_wmi_send_probe_response_cmd(struct wmi *wmi, u8 if_idx, u32 freq,
 				       const u8 *dst, const u8 *data,
 				       u16 data_len);
-- 
1.7.0.4

