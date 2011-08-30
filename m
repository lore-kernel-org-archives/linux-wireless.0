Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7151 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab1H3TDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 15:03:08 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 12/22] ath6kl: Report received Probe Request frames to cfg80211
Date: Tue, 30 Aug 2011 21:58:01 +0300
Message-ID: <1314730691-12089-13-git-send-email-jouni@qca.qualcomm.com> (sfid-20110830_210312_566508_57024BB9)
In-Reply-To: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   19 +++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    1 +
 drivers/net/wireless/ath/ath6kl/init.c     |    7 +++++++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   20 ++++++++++++++++----
 4 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 78b1788..6033959 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1740,6 +1740,24 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 					  buf, len);
 }
 
+static void ath6kl_mgmt_frame_register(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       u16 frame_type, bool reg)
+{
+	struct ath6kl *ar = ath6kl_priv(dev);
+
+	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: frame_type=0x%x reg=%d\n",
+		   __func__, frame_type, reg);
+	if (frame_type == IEEE80211_STYPE_PROBE_REQ) {
+		/*
+		 * Note: This notification callback is not allowed to sleep, so
+		 * we cannot send WMI_PROBE_REQ_REPORT_CMD here. Instead, we
+		 * hardcode target to report Probe Request frames all the time.
+		 */
+		ar->probe_req_report = reg;
+	}
+}
+
 static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.change_virtual_intf = ath6kl_cfg80211_change_iface,
 	.scan = ath6kl_cfg80211_scan,
@@ -1770,6 +1788,7 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.remain_on_channel = ath6kl_remain_on_channel,
 	.cancel_remain_on_channel = ath6kl_cancel_remain_on_channel,
 	.mgmt_tx = ath6kl_mgmt_tx,
+	.mgmt_frame_register = ath6kl_mgmt_frame_register,
 };
 
 struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 3872edb..99cabd2 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -457,6 +457,7 @@ struct ath6kl {
 	struct dentry *debugfs_phy;
 
 	u32 send_action_id;
+	bool probe_req_report;
 	u16 next_chan;
 };
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 48c82e9..3b99ae2 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -471,6 +471,13 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar)
 			   ret);
 	}
 
+	/* Enable Probe Request reporting for P2P */
+	ret = ath6kl_wmi_probe_report_req_cmd(ar->wmi, true);
+	if (ret) {
+		ath6kl_dbg(ATH6KL_DBG_TRC, "failed to enable Probe Request "
+			   "reporting (%d)\n", ret);
+	}
+
 	return status;
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index bbe3e8d..9b2a182 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -499,18 +499,30 @@ static int ath6kl_wmi_tx_status_event_rx(u8 *datap, int len)
 	return 0;
 }
 
-static int ath6kl_wmi_rx_probe_req_event_rx(u8 *datap, int len)
+static int ath6kl_wmi_rx_probe_req_event_rx(struct wmi *wmi, u8 *datap, int len)
 {
 	struct wmi_p2p_rx_probe_req_event *ev;
+	u32 freq;
 	u16 dlen;
+	struct ath6kl *ar = wmi->parent_dev;
 
 	if (len < sizeof(*ev))
 		return -EINVAL;
 
 	ev = (struct wmi_p2p_rx_probe_req_event *) datap;
+	freq = le32_to_cpu(ev->freq);
 	dlen = le16_to_cpu(ev->len);
-	ath6kl_dbg(ATH6KL_DBG_WMI, "rx_probe_req: len=%u\n",
-		   dlen);
+	if (datap + len < ev->data + dlen) {
+		ath6kl_err("invalid wmi_p2p_rx_probe_req_event: "
+			   "len=%d dlen=%u\n", len, dlen);
+		return -EINVAL;
+	}
+	ath6kl_dbg(ATH6KL_DBG_WMI, "rx_probe_req: len=%u freq=%u "
+		   "probe_req_report=%d\n",
+		   dlen, freq, ar->probe_req_report);
+
+	if (ar->probe_req_report || ar->nw_type == AP_NETWORK)
+		cfg80211_rx_mgmt(ar->net_dev, freq, ev->data, dlen, GFP_ATOMIC);
 
 	return 0;
 }
@@ -3045,7 +3057,7 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_RX_PROBE_REQ_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_RX_PROBE_REQ_EVENTID\n");
-		ret = ath6kl_wmi_rx_probe_req_event_rx(datap, len);
+		ret = ath6kl_wmi_rx_probe_req_event_rx(wmi, datap, len);
 		break;
 	case WMI_P2P_CAPABILITIES_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_P2P_CAPABILITIES_EVENTID\n");
-- 
1.7.4.1

