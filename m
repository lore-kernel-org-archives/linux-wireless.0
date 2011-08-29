Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48572 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1H2M3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 08:29:23 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 12/20] ath6kl: Report received Probe Request frames to cfg80211
Date: Mon, 29 Aug 2011 15:23:53 +0300
Message-ID: <1314620641-24257-13-git-send-email-jouni@qca.qualcomm.com> (sfid-20110829_142926_353902_DD9A8712)
In-Reply-To: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
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
index e78d332..d5f487f 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1733,6 +1733,24 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
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
@@ -1763,6 +1781,7 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
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
index aa7440d..376e576 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -470,6 +470,13 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar)
 		       "(%d) - assuming P2P not supported\n", ret);
 	}
 
+	/* Enable Probe Request reporting for P2P */
+	ret = ath6kl_wmi_probe_report_req_cmd(ar->wmi, true);
+	if (ret) {
+		printk(KERN_DEBUG "ath6l: Failed to enable Probe Request "
+		       "reporting (%d)\n", ret);
+	}
+
 	return status;
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 87e4d65..8db53c7 100644
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
@@ -3047,7 +3059,7 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
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

