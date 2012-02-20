Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29844 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab2BTNik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 08:38:40 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 2/2] ath6kl: Set optimal listen intvl,bmiss,scan params while going to wow suspend
Date: Mon, 20 Feb 2012 19:08:08 +0530
Message-ID: <1329745088-23800-2-git-send-email-rmani@qca.qualcomm.com> (sfid-20120220_143850_394126_B1154A9E)
In-Reply-To: <1329745088-23800-1-git-send-email-rmani@qca.qualcomm.com>
References: <1329745088-23800-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

* In order to save the target power in WOW suspend state,
  configure the best optimal values for the below parameters,
     - listen interval.
     - beacon miss interval.
     - scan parameters.

  Default values for above attributes are reverted in
  wow resume operation.

* The default listen interval is set before the host issue
  connect request.

* New function is added to configure beacon miss count.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   55 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/core.h     |    4 ++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   20 ++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |    8 ++++
 4 files changed, 86 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6e02a2b..4bd7e78 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -569,6 +569,19 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		   vif->grp_crypto_len, vif->ch_hint);
 
 	vif->reconnect_flag = 0;
+
+	if (vif->nw_type == INFRA_NETWORK) {
+		status = ath6kl_wmi_listeninterval_cmd(ar->wmi, vif->fw_vif_idx,
+				max(vif->listen_intvl_t,
+				    (u16)ATH6KL_MAX_WOW_LISTEN_INTVAL),
+				0);
+		if (status) {
+			ath6kl_err("couldn't set listen intervel\n");
+			up(&ar->sem);
+			return status;
+		}
+	}
+
 	status = ath6kl_wmi_connect_cmd(ar->wmi, vif->fw_vif_idx, vif->nw_type,
 					vif->dot11_auth_mode, vif->auth_mode,
 					vif->prwise_crypto,
@@ -1905,7 +1918,7 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	struct ath6kl_vif *vif;
 	int ret, left;
 	u32 filter = 0;
-	u16 i;
+	u16 i, bmiss_time;
 	u8 index = 0;
 	__be32 ips[MAX_IP_ADDRS];
 
@@ -1942,6 +1955,28 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	if (ret)
 		return ret;
 
+	if (vif->nw_type != AP_NETWORK) {
+		ret = ath6kl_wmi_listeninterval_cmd(ar->wmi, vif->fw_vif_idx,
+				ATH6KL_MAX_WOW_LISTEN_INTVAL, 0);
+		if (ret)
+			return ret;
+
+		/* Set listen interval x 15 times as bmiss time */
+		bmiss_time = ATH6KL_MAX_WOW_LISTEN_INTVAL * 15;
+		if (bmiss_time > ATH6KL_MAX_BMISS_TIME)
+			bmiss_time = ATH6KL_MAX_BMISS_TIME;
+
+		ret = ath6kl_wmi_bmisstime_cmd(ar->wmi, vif->fw_vif_idx,
+				bmiss_time, 0);
+		if (ret)
+			return ret;
+
+		ret = ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx,
+				0xFFFF, 0, 0xFFFF, 0, 0, 0, 0, 0, 0, 0);
+		if (ret)
+			return ret;
+	}
+
 	ar->state = ATH6KL_STATE_SUSPENDING;
 
 	/* Setup own IP addr for ARP agent. */
@@ -2033,6 +2068,23 @@ static int ath6kl_wow_resume(struct ath6kl *ar)
 		return ret;
 	}
 
+	if (vif->nw_type != AP_NETWORK) {
+		ret = ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx,
+				0, 0, 0, 0, 0, 0, 3, 0, 0, 0);
+		if (ret)
+			return ret;
+
+		ret = ath6kl_wmi_listeninterval_cmd(ar->wmi, vif->fw_vif_idx,
+				vif->listen_intvl_t, 0);
+		if (ret)
+			return ret;
+
+		ret = ath6kl_wmi_bmisstime_cmd(ar->wmi, vif->fw_vif_idx,
+				vif->bmiss_time_t, 0);
+		if (ret)
+			return ret;
+	}
+
 	ar->state = ATH6KL_STATE_ON;
 
 	/* Wake up netdev queue if it's stopped in ath6kl_data_tx() */
@@ -2944,6 +2996,7 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	vif->fw_vif_idx = fw_vif_idx;
 	vif->nw_type = vif->next_mode = nw_type;
 	vif->listen_intvl_t = ATH6KL_DEFAULT_LISTEN_INTVAL;
+	vif->bmiss_time_t = ATH6KL_DEFAULT_BMISS_TIME;
 
 	memcpy(ndev->dev_addr, ar->mac_addr, ETH_ALEN);
 	if (fw_vif_idx != 0)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 78f53c0..b7a1042 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -183,6 +183,9 @@ struct ath6kl_fw_ie {
 #define MBOX_YIELD_LIMIT 99
 
 #define ATH6KL_DEFAULT_LISTEN_INTVAL	100 /* in TUs */
+#define ATH6KL_DEFAULT_BMISS_TIME	1500
+#define ATH6KL_MAX_WOW_LISTEN_INTVAL	300 /* in TUs */
+#define ATH6KL_MAX_BMISS_TIME		5000
 
 /* configuration lags */
 /*
@@ -496,6 +499,7 @@ struct ath6kl_vif {
 	u16 next_chan;
 	u16 assoc_bss_beacon_int;
 	u16 listen_intvl_t;
+	u16 bmiss_time_t;
 	u8 assoc_bss_dtim_period;
 	struct net_device_stats net_stats;
 	struct target_stats target_stats;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index bbbe0a7..0fddf52 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2027,6 +2027,26 @@ int ath6kl_wmi_listeninterval_cmd(struct wmi *wmi, u8 if_idx,
 	return ret;
 }
 
+int ath6kl_wmi_bmisstime_cmd(struct wmi *wmi, u8 if_idx,
+			     u16 bmiss_time, u16 num_beacons)
+{
+	struct sk_buff *skb;
+	struct wmi_bmiss_time_cmd *cmd;
+	int ret;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_bmiss_time_cmd *) skb->data;
+	cmd->bmiss_time = cpu_to_le16(bmiss_time);
+	cmd->num_beacons = cpu_to_le16(num_beacons);
+
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_BMISS_TIME_CMDID,
+				  NO_SYNC_WMIFLAG);
+	return ret;
+}
+
 int ath6kl_wmi_powermode_cmd(struct wmi *wmi, u8 if_idx, u8 pwr_mode)
 {
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index e7d031b..7b27660 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -998,6 +998,12 @@ struct wmi_listen_int_cmd {
 	__le16 num_beacons;
 } __packed;
 
+/* WMI_SET_BMISS_TIME_CMDID */
+struct wmi_bmiss_time_cmd {
+	__le16 bmiss_time;
+	__le16 num_beacons;
+};
+
 /* WMI_SET_POWER_MODE_CMDID */
 enum wmi_power_mode {
 	REC_POWER = 0x01,
@@ -2414,6 +2420,8 @@ int ath6kl_wmi_probedssid_cmd(struct wmi *wmi, u8 if_idx, u8 index, u8 flag,
 int ath6kl_wmi_listeninterval_cmd(struct wmi *wmi, u8 if_idx,
 				  u16 listen_interval,
 				  u16 listen_beacons);
+int ath6kl_wmi_bmisstime_cmd(struct wmi *wmi, u8 if_idx,
+			     u16 bmiss_time, u16 num_beacons);
 int ath6kl_wmi_powermode_cmd(struct wmi *wmi, u8 if_idx, u8 pwr_mode);
 int ath6kl_wmi_pmparams_cmd(struct wmi *wmi, u8 if_idx, u16 idle_period,
 			    u16 ps_poll_num, u16 dtim_policy,
-- 
1.7.1

