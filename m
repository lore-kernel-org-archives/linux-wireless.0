Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4283 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab1H3S7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 14:59:17 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 01/22] ath6kl: Add functionality for starting AP mode
Date: Tue, 30 Aug 2011 21:57:50 +0300
Message-ID: <1314730691-12089-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20110830_205920_846925_8B2273A7)
In-Reply-To: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use cfg80211 add/del_beacon callbacks for starting/stopping AP mode and
set_beacon to update AP configuration (mainly, to update Beacon and
Probe Response IEs).

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  179 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +
 drivers/net/wireless/ath/ath6kl/wmi.c      |   45 +++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |   20 +++
 4 files changed, 246 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 9128aa3..4752a76 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1435,6 +1435,181 @@ static int ar6k_cfg80211_suspend(struct wiphy *wiphy,
 }
 #endif
 
+static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
+			      struct ieee80211_channel *chan,
+			      enum nl80211_channel_type channel_type)
+{
+	struct ath6kl *ar = ath6kl_priv(dev);
+
+	if (!ath6kl_cfg80211_ready(ar))
+		return -EIO;
+
+	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: center_freq=%u hw_value=%u\n",
+		   __func__, chan->center_freq, chan->hw_value);
+	ar->next_chan = chan->center_freq;
+
+	return 0;
+}
+
+static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
+			    struct beacon_parameters *info, bool add)
+{
+	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ieee80211_mgmt *mgmt;
+	u8 *ies;
+	int ies_len;
+	struct wmi_connect_cmd p;
+	int res;
+	int i;
+
+	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: add=%d\n", __func__, add);
+
+	if (!ath6kl_cfg80211_ready(ar))
+		return -EIO;
+
+	if (ar->next_mode != AP_NETWORK)
+		return -EOPNOTSUPP;
+
+	if (info->beacon_ies) {
+		res = ath6kl_wmi_set_appie_cmd(ar->wmi, WMI_FRAME_BEACON,
+					       info->beacon_ies,
+					       info->beacon_ies_len);
+		if (res)
+			return res;
+	}
+	if (info->proberesp_ies) {
+		res = ath6kl_wmi_set_appie_cmd(ar->wmi, WMI_FRAME_PROBE_RESP,
+					       info->proberesp_ies,
+					       info->proberesp_ies_len);
+		if (res)
+			return res;
+	}
+	if (info->assocresp_ies) {
+		res = ath6kl_wmi_set_appie_cmd(ar->wmi, WMI_FRAME_ASSOC_RESP,
+					       info->assocresp_ies,
+					       info->assocresp_ies_len);
+		if (res)
+			return res;
+	}
+
+	if (!add)
+		return 0;
+
+	/* TODO:
+	 * info->interval
+	 * info->dtim_period
+	 */
+
+	if (info->head == NULL)
+		return -EINVAL;
+	mgmt = (struct ieee80211_mgmt *) info->head;
+	ies = mgmt->u.beacon.variable;
+	if (ies > info->head + info->head_len)
+		return -EINVAL;
+	ies_len = info->head + info->head_len - ies;
+
+	if (info->ssid == NULL)
+		return -EINVAL;
+	memcpy(ar->ssid, info->ssid, info->ssid_len);
+	ar->ssid_len = info->ssid_len;
+	if (info->hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE)
+		return -EOPNOTSUPP; /* TODO */
+
+	ar->dot11_auth_mode = OPEN_AUTH;
+
+	memset(&p, 0, sizeof(p));
+
+	for (i = 0; i < info->crypto.n_akm_suites; i++) {
+		switch (info->crypto.akm_suites[i]) {
+		case WLAN_AKM_SUITE_8021X:
+			if (info->crypto.wpa_versions & NL80211_WPA_VERSION_1)
+				p.auth_mode |= WPA_AUTH;
+			if (info->crypto.wpa_versions & NL80211_WPA_VERSION_2)
+				p.auth_mode |= WPA2_AUTH;
+			break;
+		case WLAN_AKM_SUITE_PSK:
+			if (info->crypto.wpa_versions & NL80211_WPA_VERSION_1)
+				p.auth_mode |= WPA_PSK_AUTH;
+			if (info->crypto.wpa_versions & NL80211_WPA_VERSION_2)
+				p.auth_mode |= WPA2_PSK_AUTH;
+			break;
+		}
+	}
+	if (p.auth_mode == 0)
+		p.auth_mode = NONE_AUTH;
+	ar->auth_mode = p.auth_mode;
+
+	for (i = 0; i < info->crypto.n_ciphers_pairwise; i++) {
+		switch (info->crypto.ciphers_pairwise[i]) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+			p.prwise_crypto_type |= WEP_CRYPT;
+			break;
+		case WLAN_CIPHER_SUITE_TKIP:
+			p.prwise_crypto_type |= TKIP_CRYPT;
+			break;
+		case WLAN_CIPHER_SUITE_CCMP:
+			p.prwise_crypto_type |= AES_CRYPT;
+			break;
+		}
+	}
+	if (p.prwise_crypto_type == 0)
+		p.prwise_crypto_type = NONE_CRYPT;
+
+	switch (info->crypto.cipher_group) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		p.grp_crypto_type = WEP_CRYPT;
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		p.grp_crypto_type = TKIP_CRYPT;
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		p.grp_crypto_type = AES_CRYPT;
+		break;
+	default:
+		p.grp_crypto_type = NONE_CRYPT;
+		break;
+	}
+
+	p.nw_type = AP_NETWORK;
+	ar->nw_type = ar->next_mode;
+
+	p.ssid_len = ar->ssid_len;
+	memcpy(p.ssid, ar->ssid, ar->ssid_len);
+	p.dot11_auth_mode = ar->dot11_auth_mode;
+	p.ch = cpu_to_le16(ar->next_chan);
+
+	return ath6kl_wmi_ap_profile_commit(ar->wmi, &p);
+}
+
+static int ath6kl_add_beacon(struct wiphy *wiphy, struct net_device *dev,
+			     struct beacon_parameters *info)
+{
+	return ath6kl_ap_beacon(wiphy, dev, info, true);
+}
+
+static int ath6kl_set_beacon(struct wiphy *wiphy, struct net_device *dev,
+			     struct beacon_parameters *info)
+{
+	return ath6kl_ap_beacon(wiphy, dev, info, false);
+}
+
+static int ath6kl_del_beacon(struct wiphy *wiphy, struct net_device *dev)
+{
+	struct ath6kl *ar = ath6kl_priv(dev);
+
+	if (ar->nw_type != AP_NETWORK)
+		return -EOPNOTSUPP;
+	if (!test_bit(CONNECTED, &ar->flag))
+		return -ENOTCONN;
+
+	ath6kl_wmi_disconnect_cmd(ar->wmi);
+	clear_bit(CONNECTED, &ar->flag);
+
+	return 0;
+}
+
 static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.change_virtual_intf = ath6kl_cfg80211_change_iface,
 	.scan = ath6kl_cfg80211_scan,
@@ -1457,6 +1632,10 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 #ifdef CONFIG_PM
 	.suspend = ar6k_cfg80211_suspend,
 #endif
+	.set_channel = ath6kl_set_channel,
+	.add_beacon = ath6kl_add_beacon,
+	.set_beacon = ath6kl_set_beacon,
+	.del_beacon = ath6kl_del_beacon,
 };
 
 struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c5537b3..00d0add 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -468,6 +468,8 @@ struct ath6kl {
 
 	struct ath6kl_node_table scan_table;
 	struct dentry *debugfs_phy;
+
+	u16 next_chan;
 };
 
 static inline void *ath6kl_priv(struct net_device *dev)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index d116d0e..0114a71 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1399,6 +1399,8 @@ int ath6kl_wmi_cmd_send(struct wmi *wmi, struct sk_buff *skb,
 	enum htc_endpoint_id ep_id = wmi->ep_id;
 	int ret;
 
+	ath6kl_dbg(ATH6KL_DBG_WMI, "%s: cmd_id=%d\n", __func__, cmd_id);
+
 	if (WARN_ON(skb == NULL))
 		return -EINVAL;
 
@@ -2392,6 +2394,29 @@ static int ath6kl_wmi_delba_req_event_rx(struct wmi *wmi, u8 *datap, int len)
 }
 
 /*  AP mode functions */
+
+int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, struct wmi_connect_cmd *p)
+{
+	struct sk_buff *skb;
+	struct wmi_connect_cmd *cm;
+	int res;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cm));
+	if (!skb)
+		return -ENOMEM;
+
+	cm = (struct wmi_connect_cmd *) skb->data;
+	memcpy(cm, p, sizeof(*cm));
+
+	res = ath6kl_wmi_cmd_send(wmip, skb, WMI_AP_CONFIG_COMMIT_CMDID,
+				  NO_SYNC_WMIFLAG);
+	ath6kl_dbg(ATH6KL_DBG_WMI, "%s: nw_type=%u auth_mode=%u ch=%u "
+		   "ctrl_flags=0x%x-> res=%d\n",
+		   __func__, p->nw_type, p->auth_mode, le16_to_cpu(p->ch),
+		   le32_to_cpu(p->ctrl_flags), res);
+	return res;
+}
+
 static int ath6kl_wmi_pspoll_event_rx(struct wmi *wmi, u8 *datap, int len)
 {
 	struct wmi_pspoll_event *ev;
@@ -2456,6 +2481,26 @@ int ath6kl_wmi_set_rx_frame_format_cmd(struct wmi *wmi, u8 rx_meta_ver,
 	return ret;
 }
 
+int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 mgmt_frm_type, const u8 *ie,
+			     u8 ie_len)
+{
+	struct sk_buff *skb;
+	struct wmi_set_appie_cmd *p;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*p) + ie_len);
+	if (!skb)
+		return -ENOMEM;
+
+	ath6kl_dbg(ATH6KL_DBG_WMI, "set_appie_cmd: mgmt_frm_type=%u "
+		   "ie_len=%u\n", mgmt_frm_type, ie_len);
+	p = (struct wmi_set_appie_cmd *) skb->data;
+	p->mgmt_frm_type = mgmt_frm_type;
+	p->ie_len = ie_len;
+	memcpy(p->ie_info, ie, ie_len);
+	return ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_APPIE_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
 static int ath6kl_wmi_control_rx_xtnd(struct wmi *wmi, struct sk_buff *skb)
 {
 	struct wmix_cmd_hdr *cmd;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 8fa5d6e..6bdfd4a 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -503,6 +503,15 @@ enum wmi_cmd_id {
 	WMI_SET_EXCESS_TX_RETRY_THRES_CMDID,
 };
 
+enum wmi_mgmt_frame_type {
+	WMI_FRAME_BEACON = 0,
+	WMI_FRAME_PROBE_REQ,
+	WMI_FRAME_PROBE_RESP,
+	WMI_FRAME_ASSOC_REQ,
+	WMI_FRAME_ASSOC_RESP,
+	WMI_NUM_MGMT_FRAME
+};
+
 /* WMI_CONNECT_CMDID  */
 enum network_type {
 	INFRA_NETWORK = 0x01,
@@ -1642,6 +1651,12 @@ struct wmi_get_keepalive_cmd {
 	u8 keep_alive_intvl;
 } __packed;
 
+struct wmi_set_appie_cmd {
+	u8 mgmt_frm_type; /* enum wmi_mgmt_frame_type */
+	u8 ie_len;
+	u8 ie_info[0];
+} __packed;
+
 /* Notify the WSC registration status to the target */
 #define WSC_REG_ACTIVE     1
 #define WSC_REG_INACTIVE   0
@@ -2006,11 +2021,16 @@ struct bss *ath6kl_wmi_find_ssid_node(struct wmi *wmi, u8 *ssid,
 void ath6kl_wmi_node_return(struct wmi *wmi, struct bss *bss);
 
 /* AP mode */
+int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, struct wmi_connect_cmd *p);
+
 int ath6kl_wmi_set_pvb_cmd(struct wmi *wmi, u16 aid, bool flag);
 
 int ath6kl_wmi_set_rx_frame_format_cmd(struct wmi *wmi, u8 rx_meta_version,
 				       bool rx_dot11_hdr, bool defrag_on_host);
 
+int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 mgmt_frm_type, const u8 *ie,
+			     u8 ie_len);
+
 void *ath6kl_wmi_init(struct ath6kl *devt);
 void ath6kl_wmi_shutdown(struct wmi *wmi);
 
-- 
1.7.4.1

