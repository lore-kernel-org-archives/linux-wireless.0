Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20063 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2EKXOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 19:14:54 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH] ath6kl: enable enhanced bmiss detection
Date: Fri, 11 May 2012 16:14:49 -0700
Message-ID: <1336778089-11473-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120512_011459_519968_2CD176A3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable enhanced bmiss detection if the firmware supports it. This
feature is only enabled on some firmwares since it comes with a power
cost.

Also add a few missing command ids to keep the enums straight.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   25 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    2 ++
 drivers/net/wireless/ath/ath6kl/core.h     |    3 +++
 drivers/net/wireless/ath/ath6kl/init.c     |    2 ++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   19 +++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |   11 +++++++++++
 6 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b869a35..e4507db 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -575,6 +575,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	vif->nw_type = vif->next_mode;
+	ath6kl_sta_bmiss_enhance(vif, true);
 
 	if (vif->wdev.iftype == NL80211_IFTYPE_P2P_CLIENT)
 		nw_subtype = SUBTYPE_P2PCLIENT;
@@ -1512,6 +1513,8 @@ static int ath6kl_cfg80211_change_iface(struct wiphy *wiphy,
 		}
 	}
 
+	ath6kl_sta_bmiss_enhance(vif, false);
+
 set_iface_type:
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
@@ -2614,6 +2617,28 @@ static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+void ath6kl_sta_bmiss_enhance(struct ath6kl_vif *vif, bool enable)
+{
+	int err;
+
+	if (WARN_ON(!test_bit(WMI_READY, &vif->ar->flag)))
+		return;
+
+	if (vif->nw_type == INFRA_NETWORK &&
+	    test_bit(ATH6KL_FW_CAPABILITY_BMISS_ENHANCE,
+		     vif->ar->fw_capabilities)) {
+		ath6kl_dbg(ATH6KL_DBG_TRC, enable ? "enable fw bmiss enhance\n"
+						  : "");
+		err = ath6kl_wmi_sta_bmiss_enhance_cmd(vif->ar->wmi,
+						       vif->fw_vif_idx, enable);
+		if (err)
+			ath6kl_dbg(ATH6KL_DBG_TRC,
+				   "failed to %s enhanced bmiss detection: %d\n",
+				   enable ? "set" : "disable",
+				   err);
+	}
+}
+
 static int ath6kl_get_rsn_capab(struct cfg80211_beacon_data *beacon,
 				u8 *rsn_capab)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index 5ea8cbb..6110876 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -62,5 +62,7 @@ void ath6kl_cfg80211_cleanup(struct ath6kl *ar);
 
 struct ath6kl *ath6kl_cfg80211_create(void);
 void ath6kl_cfg80211_destroy(struct ath6kl *ar);
+/* TODO: remove this once ath6kl_vif_cleanup() is moved to cfg80211.c */
+void ath6kl_sta_bmiss_enhance(struct ath6kl_vif *vif, bool enable);
 
 #endif /* ATH6KL_CFG80211_H */
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 4d9c6f1..cb79378 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -100,6 +100,9 @@ enum ath6kl_fw_capability {
 	/* Firmware has support to override rsn cap of rsn ie */
 	ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE,
 
+	/* Firmware supports enhanced bmiss detection */
+	ATH6KL_FW_CAPABILITY_BMISS_ENHANCE,
+
 	/* this needs to be last */
 	ATH6KL_FW_CAPABILITY_MAX,
 };
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 7eb0515..e2b5891 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1659,6 +1659,8 @@ void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready)
 		cfg80211_scan_done(vif->scan_req, true);
 		vif->scan_req = NULL;
 	}
+
+	ath6kl_sta_bmiss_enhance(vif, false);
 }
 
 void ath6kl_stop_txrx(struct ath6kl *ar)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index ee8ec23..09a9e0c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2997,6 +2997,25 @@ int ath6kl_wmi_add_del_mcast_filter_cmd(struct wmi *wmi, u8 if_idx,
 	return ret;
 }
 
+int ath6kl_wmi_sta_bmiss_enhance_cmd(struct wmi *wmi, u8 if_idx, bool enhance)
+{
+	struct sk_buff *skb;
+	struct wmi_sta_bmiss_enhance_cmd *cmd;
+	int ret;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_sta_bmiss_enhance_cmd *) skb->data;
+	cmd->enable = enhance ? 1 : 0;
+
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb,
+				  WMI_STA_BMISS_ENHANCE_CMDID,
+				  NO_SYNC_WMIFLAG);
+	return ret;
+}
+
 s32 ath6kl_wmi_get_rate(s8 rate_index)
 {
 	if (rate_index == RATE_AUTO)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 9076bec..014f3dd 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -624,6 +624,10 @@ enum wmi_cmd_id {
 	WMI_SEND_MGMT_CMDID,
 	WMI_BEGIN_SCAN_CMDID,
 
+	WMI_SET_BLACK_LIST,
+	WMI_SET_MCASTRATE,
+
+	WMI_STA_BMISS_ENHANCE_CMDID,
 };
 
 enum wmi_mgmt_frame_type {
@@ -1017,6 +1021,11 @@ struct wmi_bmiss_time_cmd {
 	__le16 num_beacons;
 };
 
+/* WMI_STA_ENHANCE_BMISS_CMDID */
+struct wmi_sta_bmiss_enhance_cmd {
+	u8 enable;
+} __packed;
+
 /* WMI_SET_POWER_MODE_CMDID */
 enum wmi_power_mode {
 	REC_POWER = 0x01,
@@ -2547,6 +2556,8 @@ int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode);
 int ath6kl_wmi_mcast_filter_cmd(struct wmi *wmi, u8 if_idx, bool mc_all_on);
 int ath6kl_wmi_add_del_mcast_filter_cmd(struct wmi *wmi, u8 if_idx,
 					u8 *filter, bool add_filter);
+int ath6kl_wmi_sta_bmiss_enhance_cmd(struct wmi *wmi, u8 if_idx, bool enable);
+
 /* AP mode uAPSD */
 int ath6kl_wmi_ap_set_apsd(struct wmi *wmi, u8 if_idx, u8 enable);
 
-- 
1.7.4.1

