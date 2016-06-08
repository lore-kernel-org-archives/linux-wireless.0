Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34000 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbcFHPJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 11:09:49 -0400
From: Prasun Maiti <prasunmaiti87@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Prasun Maiti <prasunmaii87@gmail.com>
Subject: [PATCH] Add .set_antenna callback in ath6kl driver to fix wireless core warns
Date: Wed,  8 Jun 2016 20:39:40 +0530
Message-Id: <1465398580-21262-1-git-send-email-prasunmaiti87@gmail.com> (sfid-20160608_171012_874423_B4068500)
In-Reply-To: <87wplzkbd9.fsf@kamboji.qca.qualcomm.com>
References: <87wplzkbd9.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since add more warnings for inconsistent ops in cfg80211, the wireless
core warns if a driver implements a cfg80211 callback but doesn't
implements the inverse operation. The ath6kl driver implements a cfg80211
.get_antenna operation handler but doesn't have the inverse .set_antenna
callback. So, it makes warning.

To remove this warning, add .set_antenna callback in ath6kl driver and
also send a cmd to firmware with it's values.

Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 24 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.c      | 18 ++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |  6 ++++++
 3 files changed, 48 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 4e11ba0..0d51228 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3231,6 +3231,29 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 					wait, buf, len, no_cck);
 }
 
+static int ath6kl_set_antenna(struct wiphy *wiphy,
+				u32 tx_ant, u32 rx_ant)
+{
+	struct ath6kl *ar = wiphy_priv(wiphy);
+	struct ath6kl_vif *vif = NULL;
+
+	vif = ath6kl_vif_first(ar);
+	if (!vif)
+		return -EIO;
+
+	if (!ath6kl_cfg80211_ready(vif))
+		return -EIO;
+
+	if (!tx_ant || !rx_ant)
+		return -EINVAL;
+
+	ar->hw.tx_ant = tx_ant;
+	ar->hw.rx_ant = rx_ant;
+
+	return ath6kl_wmi_set_antenna(ar->wmi, vif->fw_vif_idx,
+			tx_ant, rx_ant);
+}
+
 static int ath6kl_get_antenna(struct wiphy *wiphy,
 			      u32 *tx_ant, u32 *rx_ant)
 {
@@ -3456,6 +3479,7 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.cancel_remain_on_channel = ath6kl_cancel_remain_on_channel,
 	.mgmt_tx = ath6kl_mgmt_tx,
 	.mgmt_frame_register = ath6kl_mgmt_frame_register,
+	.set_antenna = ath6kl_set_antenna,
 	.get_antenna = ath6kl_get_antenna,
 	.sched_scan_start = ath6kl_cfg80211_sscan_start,
 	.sched_scan_stop = ath6kl_cfg80211_sscan_stop,
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 631c3a0..3a7b5e9 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1605,6 +1605,24 @@ static int ath6kl_wmi_txe_notify_event_rx(struct wmi *wmi, u8 *datap, int len,
 	return 0;
 }
 
+int ath6kl_wmi_set_antenna(struct wmi *wmi, u8 idx,
+			      u32 tx_ant, u32 rx_ant)
+{
+	struct sk_buff *skb;
+	struct wmi_set_antenna_cmd *cmd;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_set_antenna_cmd *) skb->data;
+	cmd->tx_ant = cpu_to_le32(tx_ant);
+	cmd->rx_ant = cpu_to_le32(rx_ant);
+
+	return ath6kl_wmi_cmd_send(wmi, idx, skb, WMI_SET_ANTENNA_CMDID,
+			NO_SYNC_WMIFLAG);
+}
+
 int ath6kl_wmi_set_txe_notify(struct wmi *wmi, u8 idx,
 			      u32 rate, u32 pkts, u32 intvl)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 3af464a..f2e65b3 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -642,6 +642,7 @@ enum wmi_cmd_id {
 	WMI_SET_RECOVERY_TEST_PARAMETER_CMDID, /*0xf094*/
 
 	WMI_ENABLE_SCHED_SCAN_CMDID,
+	WMI_SET_ANTENNA_CMDID,
 };
 
 enum wmi_mgmt_frame_type {
@@ -2312,6 +2313,11 @@ struct wmi_ap_set_apsd_cmd {
 	u8 enable;
 } __packed;
 
+struct wmi_set_antenna_cmd {
+	__le32 tx_ant;
+	__le32 rx_ant;
+} __packed;
+
 enum wmi_ap_apsd_buffered_traffic_flags {
 	WMI_AP_APSD_NO_DELIVERY_FRAMES =  0x1,
 };
-- 
1.9.1

