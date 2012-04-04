Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32550 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab2DDS51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 14:57:27 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath6kl-devel@qualcomm.com>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH 2/2] ath6kl: handle concurrent AP-STA channel switches
Date: Wed, 4 Apr 2012 11:56:56 -0700
Message-ID: <1333565817-18816-2-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120404_205731_252537_0C248216)
In-Reply-To: <1333565817-18816-1-git-send-email-c_tpeder@qca.qualcomm.com>
References: <1333565817-18816-1-git-send-email-c_tpeder@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If an ath6kl AP vif is beaconing on one channel, and a STA vif
associates on a different channel, a WMI_DISCONNECT event will be sent
to the AP vif. Make the AP vif follow the STA interface, and notify
userspace.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   14 +++++++
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    2 +
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +
 drivers/net/wireless/ath/ath6kl/main.c     |   55 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/wmi.h      |   12 ++++++
 5 files changed, 84 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 1272508..5d7eac7 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1015,6 +1015,19 @@ out:
 	vif->scan_req = NULL;
 }
 
+void ath6kl_cfg80211_ch_switch_notify(struct ath6kl_vif *vif, int channel,
+				      enum wmi_phy_mode mode)
+{
+	enum nl80211_channel_type type;
+
+	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "channel switch notify nw_type %d"
+		   "freq %d mode %d", vif->nw_type, channel, mode);
+
+	type = (mode == WMI_11G_HT20) ? NL80211_CHAN_HT20 : NL80211_CHAN_NO_HT;
+
+	cfg80211_ch_switch_notify(vif->ndev, channel, type, GFP_KERNEL);
+}
+
 static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 				   u8 key_index, bool pairwise,
 				   const u8 *mac_addr,
@@ -2643,6 +2656,7 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 			return res;
 	}
 
+	memcpy(&vif->profile, &p, sizeof(p));
 	res = ath6kl_wmi_ap_profile_commit(ar->wmi, vif->fw_vif_idx, &p);
 	if (res < 0)
 		return res;
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index c5def43..7fc7518 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -28,6 +28,8 @@ enum ath6kl_cfg_suspend_mode {
 struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 					enum nl80211_iftype type,
 					u8 fw_vif_idx, u8 nw_type);
+void ath6kl_cfg80211_ch_switch_notify(struct ath6kl_vif *vif, int channel,
+				      enum wmi_phy_mode mode);
 void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, bool aborted);
 
 void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 75b1d86..0b4078d 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -540,6 +540,7 @@ struct ath6kl_vif {
 	u8 assoc_bss_dtim_period;
 	struct net_device_stats net_stats;
 	struct target_stats target_stats;
+	struct wmi_connect_cmd profile;
 
 	struct list_head mc_filter;
 };
@@ -628,6 +629,7 @@ struct ath6kl {
 	u8 sta_list_index;
 	struct ath6kl_req_key ap_mode_bkey;
 	struct sk_buff_head mcastpsq;
+	u32 want_ch_switch;
 
 	/*
 	 * FIXME: protects access to mcastpsq but is actually useless as
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 7f3addd..58468e0 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -434,6 +434,13 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl_vif *vif, u16 channel)
 		break;
 	}
 
+	if (ar->want_ch_switch & (1 << vif->fw_vif_idx)) {
+		ar->want_ch_switch &= ~(1 << vif->fw_vif_idx);
+		/* we actually don't know the phymode, default to HT20 */
+		ath6kl_cfg80211_ch_switch_notify(vif, channel,
+						 WMI_11G_HT20);
+	}
+
 	ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx, NONE_BSS_FILTER, 0);
 	set_bit(CONNECTED, &vif->flags);
 	netif_carrier_on(vif->ndev);
@@ -582,6 +589,45 @@ void ath6kl_scan_complete_evt(struct ath6kl_vif *vif, int status)
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "scan complete: %d\n", status);
 }
 
+static int ath6kl_commit_ch_switch(struct ath6kl_vif *vif, u16 channel)
+{
+
+	struct ath6kl *ar = vif->ar;
+
+	vif->next_chan = cpu_to_le16(channel);
+	vif->profile.ch = cpu_to_le16(channel);
+
+	switch (vif->nw_type) {
+	case AP_NETWORK:
+		return ath6kl_wmi_ap_profile_commit(ar->wmi, vif->fw_vif_idx,
+						    &vif->profile);
+	default:
+		ath6kl_err("won't switch channels nw_type=%d\n", vif->nw_type);
+		return -ENOTSUPP;
+	}
+}
+
+static void ath6kl_check_ch_switch(struct ath6kl *ar, u16 channel)
+{
+
+	struct ath6kl_vif *vif;
+	int res = 0;
+
+	if (!ar->want_ch_switch)
+		return;
+
+	spin_lock_bh(&ar->list_lock);
+	list_for_each_entry(vif, &ar->vif_list, list) {
+		if (ar->want_ch_switch & (1 << vif->fw_vif_idx))
+			res = ath6kl_commit_ch_switch(vif, channel);
+
+		if (res)
+			ath6kl_err("channel switch failed nw_type %d res %d\n",
+				   vif->nw_type, res);
+	}
+	spin_unlock_bh(&ar->list_lock);
+}
+
 void ath6kl_connect_event(struct ath6kl_vif *vif, u16 channel, u8 *bssid,
 			  u16 listen_int, u16 beacon_int,
 			  enum network_type net_type, u8 beacon_ie_len,
@@ -599,9 +645,11 @@ void ath6kl_connect_event(struct ath6kl_vif *vif, u16 channel, u8 *bssid,
 	memcpy(vif->bssid, bssid, sizeof(vif->bssid));
 	vif->bss_ch = channel;
 
-	if ((vif->nw_type == INFRA_NETWORK))
+	if ((vif->nw_type == INFRA_NETWORK)) {
 		ath6kl_wmi_listeninterval_cmd(ar->wmi, vif->fw_vif_idx,
 					      vif->listen_intvl_t, 0);
+		ath6kl_check_ch_switch(ar, channel);
+	}
 
 	netif_wake_queue(vif->ndev);
 
@@ -924,6 +972,11 @@ void ath6kl_disconnect_event(struct ath6kl_vif *vif, u8 reason, u8 *bssid,
 	struct ath6kl *ar = vif->ar;
 
 	if (vif->nw_type == AP_NETWORK) {
+		/* disconnect due to other STA vif switching channels */
+		if (reason == BSS_DISCONNECTED &&
+		    prot_reason_status == WMI_AP_REASON_STA_ROAM)
+			ar->want_ch_switch |= 1 << vif->fw_vif_idx;
+
 		if (!ath6kl_remove_sta(ar, bssid, prot_reason_status))
 			return;
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index b99e9bd..88a1603 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1145,6 +1145,7 @@ enum wmi_phy_mode {
 	WMI_11AG_MODE = 0x3,
 	WMI_11B_MODE = 0x4,
 	WMI_11GONLY_MODE = 0x5,
+	WMI_11G_HT20	= 0x6,
 };
 
 #define WMI_MAX_CHANNELS        32
@@ -1452,6 +1453,17 @@ enum wmi_disconnect_reason {
 	IBSS_MERGE = 0xe,
 };
 
+/* AP mode disconnect proto_reasons */
+enum ap_disconnect_reason {
+	WMI_AP_REASON_STA_LEFT		= 101,
+	WMI_AP_REASON_FROM_HOST		= 102,
+	WMI_AP_REASON_COMM_TIMEOUT	= 103,
+	WMI_AP_REASON_MAX_STA		= 104,
+	WMI_AP_REASON_ACL		= 105,
+	WMI_AP_REASON_STA_ROAM		= 106,
+	WMI_AP_REASON_DFS_CHANNEL	= 107,
+};
+
 #define ATH6KL_COUNTRY_RD_SHIFT        16
 
 struct ath6kl_wmi_regdomain {
-- 
1.7.4.1

