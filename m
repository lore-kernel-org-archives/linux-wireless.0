Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14431 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbaB0OV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:21:29 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 01/16] wil6210: Tx management frame
Date: Thu, 27 Feb 2014 16:20:40 +0200
Message-ID: <1393510855-17566-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_152141_415349_9B322A99)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement management frame passing. In order to receive frame on the other
side, remain_on_channel() should be implemented as well

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 72 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h  |  1 +
 drivers/net/wireless/ath/wil6210/wmi.c      | 32 +++++++++++++
 3 files changed, 105 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 5b34076..204c7c8 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -352,6 +352,40 @@ static int wil_cfg80211_disconnect(struct wiphy *wiphy,
 	return rc;
 }
 
+static int wil_cfg80211_mgmt_tx(struct wiphy *wiphy,
+				struct wireless_dev *wdev,
+				struct cfg80211_mgmt_tx_params *params,
+				u64 *cookie)
+{
+	const u8 *buf = params->buf;
+	size_t len = params->len;
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	int rc;
+	struct ieee80211_mgmt *mgmt_frame = (void *)buf;
+	struct wmi_sw_tx_req_cmd *cmd;
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_sw_tx_complete_event evt;
+	} __packed evt;
+
+	cmd = kmalloc(sizeof(*cmd) + len, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	memcpy(cmd->dst_mac, mgmt_frame->da, WMI_MAC_LEN);
+	cmd->len = cpu_to_le16(len);
+	memcpy(cmd->payload, buf, len);
+
+	rc = wmi_call(wil, WMI_SW_TX_REQ_CMDID, cmd, sizeof(*cmd) + len,
+		      WMI_SW_TX_COMPLETE_EVENTID, &evt, sizeof(evt), 2000);
+	if (rc == 0)
+		rc = evt.evt.status;
+
+	kfree(cmd);
+
+	return rc;
+}
+
 static int wil_cfg80211_set_channel(struct wiphy *wiphy,
 				    struct cfg80211_chan_def *chandef)
 {
@@ -402,6 +436,41 @@ static int wil_cfg80211_set_default_key(struct wiphy *wiphy,
 	return 0;
 }
 
+static int wil_remain_on_channel(struct wiphy *wiphy,
+				 struct wireless_dev *wdev,
+				 struct ieee80211_channel *chan,
+				 unsigned int duration,
+				 u64 *cookie)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	int rc;
+
+	/* TODO: handle duration */
+	wil_info(wil, "%s(%d, %d ms)\n", __func__, chan->center_freq, duration);
+
+	rc = wmi_set_channel(wil, chan->hw_value);
+	if (rc)
+		return rc;
+
+	rc = wmi_rxon(wil, true);
+
+	return rc;
+}
+
+static int wil_cancel_remain_on_channel(struct wiphy *wiphy,
+					struct wireless_dev *wdev,
+					u64 cookie)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	int rc;
+
+	wil_info(wil, "%s()\n", __func__);
+
+	rc = wmi_rxon(wil, false);
+
+	return rc;
+}
+
 static int wil_fix_bcon(struct wil6210_priv *wil,
 			struct cfg80211_beacon_data *bcon)
 {
@@ -510,6 +579,9 @@ static struct cfg80211_ops wil_cfg80211_ops = {
 	.disconnect = wil_cfg80211_disconnect,
 	.change_virtual_intf = wil_cfg80211_change_iface,
 	.get_station = wil_cfg80211_get_station,
+	.remain_on_channel = wil_remain_on_channel,
+	.cancel_remain_on_channel = wil_cancel_remain_on_channel,
+	.mgmt_tx = wil_cfg80211_mgmt_tx,
 	.set_monitor_channel = wil_cfg80211_set_channel,
 	.add_key = wil_cfg80211_add_key,
 	.del_key = wil_cfg80211_del_key,
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 1f91eaf..0d7fba4 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -357,6 +357,7 @@ int wmi_echo(struct wil6210_priv *wil);
 int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie);
 int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring);
 int wmi_p2p_cfg(struct wil6210_priv *wil, int channel);
+int wmi_rxon(struct wil6210_priv *wil, bool on);
 int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_m, u32 *t_r);
 
 int wil6210_init_irq(struct wil6210_priv *wil, int irq);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 063963e..d65da55 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -893,6 +893,38 @@ int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie)
 	return rc;
 }
 
+/**
+ * wmi_rxon - turn radio on/off
+ * @on:		turn on if true, off otherwise
+ *
+ * Only switch radio. Channel should be set separately.
+ * No timeout for rxon - radio turned on forever unless some other call
+ * turns it off
+ */
+int wmi_rxon(struct wil6210_priv *wil, bool on)
+{
+	int rc;
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_listen_started_event evt;
+	} __packed reply;
+
+	wil_info(wil, "%s(%s)\n", __func__, on ? "on" : "off");
+
+	if (on) {
+		rc = wmi_call(wil, WMI_START_LISTEN_CMDID, NULL, 0,
+			      WMI_LISTEN_STARTED_EVENTID,
+			      &reply, sizeof(reply), 100);
+		if ((rc == 0) && (reply.evt.status != WMI_FW_STATUS_SUCCESS))
+			rc = -EINVAL;
+	} else {
+		rc = wmi_call(wil, WMI_DISCOVERY_STOP_CMDID, NULL, 0,
+			      WMI_DISCOVERY_STOPPED_EVENTID, NULL, 0, 20);
+	}
+
+	return rc;
+}
+
 int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring)
 {
 	struct wireless_dev *wdev = wil->wdev;
-- 
1.8.3.2

