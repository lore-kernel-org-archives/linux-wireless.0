Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35259 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933564Ab1JYOF4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:05:56 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 15/31] ath6kl: Move few more vif specific information to struct ath6kl_vif
Date: Tue, 25 Oct 2011 19:34:10 +0530
Message-ID: <1319551466-29070-16-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160606_247896_B5ACE72D)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   25 +++++++++++++------------
 drivers/net/wireless/ath/ath6kl/core.h     |   13 ++++++-------
 drivers/net/wireless/ath/ath6kl/main.c     |    8 ++++----
 drivers/net/wireless/ath/ath6kl/wmi.c      |    6 +++---
 4 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index acc5c86..fa206be 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -362,7 +362,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	if (test_bit(CONNECTED, &vif->flags) &&
 	    vif->ssid_len == sme->ssid_len &&
 	    !memcmp(vif->ssid, sme->ssid, vif->ssid_len)) {
-		ar->reconnect_flag = true;
+		vif->reconnect_flag = true;
 		status = ath6kl_wmi_reconnect_cmd(ar->wmi, vif->req_bssid,
 						  vif->ch_hint);
 
@@ -454,7 +454,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		   vif->prwise_crypto_len, vif->grp_crypto,
 		   vif->grp_crypto_len, vif->ch_hint);
 
-	ar->reconnect_flag = 0;
+	vif->reconnect_flag = 0;
 	status = ath6kl_wmi_connect_cmd(ar->wmi, vif->nw_type,
 					vif->dot11_auth_mode, vif->auth_mode,
 					vif->prwise_crypto,
@@ -566,7 +566,7 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 	 * Store Beacon interval here; DTIM period will be available only once
 	 * a Beacon frame from the AP is seen.
 	 */
-	ar->assoc_bss_beacon_int = beacon_intvl;
+	vif->assoc_bss_beacon_int = beacon_intvl;
 	clear_bit(DTIM_PERIOD_AVAIL, &vif->flags);
 
 	if (nw_type & ADHOC_NETWORK) {
@@ -638,7 +638,7 @@ static int ath6kl_cfg80211_disconnect(struct wiphy *wiphy,
 		return -ERESTARTSYS;
 	}
 
-	ar->reconnect_flag = 0;
+	vif->reconnect_flag = 0;
 	ath6kl_disconnect(ar);
 	memset(vif->ssid, 0, sizeof(vif->ssid));
 	vif->ssid_len = 0;
@@ -1489,8 +1489,8 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 	    vif->nw_type == INFRA_NETWORK) {
 		sinfo->filled |= STATION_INFO_BSS_PARAM;
 		sinfo->bss_param.flags = 0;
-		sinfo->bss_param.dtim_period = ar->assoc_bss_dtim_period;
-		sinfo->bss_param.beacon_interval = ar->assoc_bss_beacon_int;
+		sinfo->bss_param.dtim_period = vif->assoc_bss_dtim_period;
+		sinfo->bss_param.beacon_interval = vif->assoc_bss_beacon_int;
 	}
 
 	return 0;
@@ -1545,13 +1545,14 @@ static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
 			      enum nl80211_channel_type channel_type)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 
 	if (!ath6kl_cfg80211_ready(ar))
 		return -EIO;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: center_freq=%u hw_value=%u\n",
 		   __func__, chan->center_freq, chan->hw_value);
-	ar->next_chan = chan->center_freq;
+	vif->next_chan = chan->center_freq;
 
 	return 0;
 }
@@ -1731,7 +1732,7 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	p.ssid_len = vif->ssid_len;
 	memcpy(p.ssid, vif->ssid, vif->ssid_len);
 	p.dot11_auth_mode = vif->dot11_auth_mode;
-	p.ch = cpu_to_le16(ar->next_chan);
+	p.ch = cpu_to_le16(vif->next_chan);
 
 	res = ath6kl_wmi_ap_profile_commit(ar->wmi, &p);
 	if (res < 0)
@@ -1876,13 +1877,13 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 						 chan->center_freq);
 	}
 
-	id = ar->send_action_id++;
+	id = vif->send_action_id++;
 	if (id == 0) {
 		/*
 		 * 0 is a reserved value in the WMI command and shall not be
 		 * used for the command.
 		 */
-		id = ar->send_action_id++;
+		id = vif->send_action_id++;
 	}
 
 	*cookie = id;
@@ -1894,7 +1895,7 @@ static void ath6kl_mgmt_frame_register(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       u16 frame_type, bool reg)
 {
-	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: frame_type=0x%x reg=%d\n",
 		   __func__, frame_type, reg);
@@ -1904,7 +1905,7 @@ static void ath6kl_mgmt_frame_register(struct wiphy *wiphy,
 		 * we cannot send WMI_PROBE_REQ_REPORT_CMD here. Instead, we
 		 * hardcode target to report Probe Request frames all the time.
 		 */
-		ar->probe_req_report = reg;
+		vif->probe_req_report = reg;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index e949a3b..ba780eb 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -419,6 +419,12 @@ struct ath6kl_vif {
 	struct timer_list disconnect_timer;
 	struct cfg80211_scan_request *scan_req;
 	enum sme_state sme_state;
+	int reconnect_flag;
+	u32 send_action_id;
+	bool probe_req_report;
+	u16 next_chan;
+	u16 assoc_bss_beacon_int;
+	u8 assoc_bss_dtim_period;
 };
 
 /* Flag info */
@@ -503,7 +509,6 @@ struct ath6kl {
 	struct ath6kl_mbox_info mbox_info;
 
 	struct ath6kl_cookie cookie_mem[MAX_COOKIE_NUM];
-	int reconnect_flag;
 	unsigned long flag;
 
 	u8 *fw_board;
@@ -524,13 +529,7 @@ struct ath6kl {
 
 	struct dentry *debugfs_phy;
 
-	u32 send_action_id;
-	bool probe_req_report;
-	u16 next_chan;
-
 	bool p2p;
-	u16 assoc_bss_beacon_int;
-	u8 assoc_bss_dtim_period;
 
 #ifdef CONFIG_ATH6KL_DEBUG
 	struct {
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 204901d..b91ac7e 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1074,7 +1074,7 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 	spin_unlock_bh(&ar->lock);
 
 	aggr_reset_state(vif->aggr_cntxt);
-	ar->reconnect_flag = 0;
+	vif->reconnect_flag = 0;
 
 	if ((vif->nw_type == ADHOC_NETWORK) && ar->ibss_ps_enable) {
 		memset(ar->node_map, 0, sizeof(ar->node_map));
@@ -1414,7 +1414,7 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 		if (((reason == ASSOC_FAILED) &&
 		    (prot_reason_status == 0x11)) ||
 		    ((reason == ASSOC_FAILED) && (prot_reason_status == 0x0)
-		     && (ar->reconnect_flag == 1))) {
+		     && (vif->reconnect_flag == 1))) {
 			set_bit(CONNECTED, &vif->flags);
 			return;
 		}
@@ -1426,8 +1426,8 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 	netif_carrier_off(ar->net_dev);
 	spin_unlock_bh(&ar->lock);
 
-	if ((reason != CSERV_DISCONNECT) || (ar->reconnect_flag != 1))
-		ar->reconnect_flag = 0;
+	if ((reason != CSERV_DISCONNECT) || (vif->reconnect_flag != 1))
+		vif->reconnect_flag = 0;
 
 	if (reason != CSERV_DISCONNECT)
 		ar->user_key_ctrl = 0;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 2f4e8b5..8e7e7b5 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -520,9 +520,9 @@ static int ath6kl_wmi_rx_probe_req_event_rx(struct wmi *wmi, u8 *datap, int len)
 	}
 	ath6kl_dbg(ATH6KL_DBG_WMI, "rx_probe_req: len=%u freq=%u "
 		   "probe_req_report=%d\n",
-		   dlen, freq, ar->probe_req_report);
+		   dlen, freq, vif->probe_req_report);
 
-	if (ar->probe_req_report || vif->nw_type == AP_NETWORK)
+	if (vif->probe_req_report || vif->nw_type == AP_NETWORK)
 		cfg80211_rx_mgmt(ar->net_dev, freq, ev->data, dlen, GFP_ATOMIC);
 
 	return 0;
@@ -993,7 +993,7 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 		tim = cfg80211_find_ie(WLAN_EID_TIM, buf + 8 + 2 + 2,
 				       len - 8 - 2 - 2);
 		if (tim && tim[1] >= 2) {
-			ar->assoc_bss_dtim_period = tim[3];
+			vif->assoc_bss_dtim_period = tim[3];
 			set_bit(DTIM_PERIOD_AVAIL, &vif->flags);
 		}
 	}
-- 
1.7.0.4

