Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39086 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933629AbcBYTxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 14:53:52 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v4] ath10k: set MAC timestamp in management Rx frame
Date: Thu, 25 Feb 2016 11:52:22 -0800
Message-ID: <6ff82bf8d1c80928c491b39d6be21611da50b64f.1456429663.git.poh@qca.qualcomm.com> (sfid-20160225_205355_199611_08E74E5B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check and set Rx MAC timestamp when firmware indicates it.
Firmware adds it in Rx beacon frame only at this moment.
Driver and mac80211 may utilize it to detect such clockdrift
or beacon collision and use the result for beacon collision
avoidance.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---

v2:
	- fix kbuild test robot warning, left shift count >= width of type,
	at __le32_to_cpu(arg.ext_info.rx_mac_timestamp_u32) << 32
v3:
	- correct ext_info to start 4-byte aligned
	- make struct wmi_mgmt_rx_ext_info 4-byte aligned to comply FW's intention
v4:
	- fix endianness warnings, restricted __le32 degrades to integer

 drivers/net/wireless/ath/ath10k/wmi.c | 15 +++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h |  8 ++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 1ce6742..fdf149b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2167,6 +2167,7 @@ static int ath10k_wmi_op_pull_mgmt_rx_ev(struct ath10k *ar, struct sk_buff *skb,
 	struct wmi_mgmt_rx_event_v1 *ev_v1;
 	struct wmi_mgmt_rx_event_v2 *ev_v2;
 	struct wmi_mgmt_rx_hdr_v1 *ev_hdr;
+	struct wmi_mgmt_rx_ext_info *ext_info;
 	size_t pull_len;
 	u32 msdu_len;
 
@@ -2195,6 +2196,13 @@ static int ath10k_wmi_op_pull_mgmt_rx_ev(struct ath10k *ar, struct sk_buff *skb,
 	if (skb->len < msdu_len)
 		return -EPROTO;
 
+	if (le32_to_cpu(arg->status) & WMI_RX_STATUS_EXT_INFO) {
+		ext_info = (struct wmi_mgmt_rx_ext_info *)
+			   (skb->data +
+			   round_up(le32_to_cpu(arg->buf_len), sizeof(u32)));
+		memcpy(&arg->ext_info, ext_info,
+		       sizeof(struct wmi_mgmt_rx_ext_info));
+	}
 	/* the WMI buffer might've ended up being padded to 4 bytes due to HTC
 	 * trailer with credit update. Trim the excess garbage.
 	 */
@@ -2281,6 +2289,13 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	if (rx_status & WMI_RX_STATUS_ERR_MIC)
 		status->flag |= RX_FLAG_MMIC_ERROR;
 
+	if (rx_status & WMI_RX_STATUS_EXT_INFO) {
+		status->mactime =
+			__le32_to_cpu(arg.ext_info.rx_mac_timestamp_l32) |
+			(u64)__le32_to_cpu(arg.ext_info.rx_mac_timestamp_u32)
+			<< 32;
+		status->flag |= RX_FLAG_MACTIME_END;
+	}
 	/* Hardware can Rx CCK rates on 5GHz. In that case phy_mode is set to
 	 * MODE_11B. This means phy_mode is not a reliable source for the band
 	 * of mgmt rx.
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 4d3cbc4..f209d51 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3037,11 +3037,18 @@ struct wmi_10_4_mgmt_rx_event {
 	u8 buf[0];
 } __packed;
 
+struct wmi_mgmt_rx_ext_info {
+	__le32 rx_mac_timestamp_l32;
+	__le32 rx_mac_timestamp_u32;
+} __packed __aligned(4);
+
 #define WMI_RX_STATUS_OK			0x00
 #define WMI_RX_STATUS_ERR_CRC			0x01
 #define WMI_RX_STATUS_ERR_DECRYPT		0x08
 #define WMI_RX_STATUS_ERR_MIC			0x10
 #define WMI_RX_STATUS_ERR_KEY_CACHE_MISS	0x20
+/* Extension data at the end of mgmt frame */
+#define WMI_RX_STATUS_EXT_INFO		0x40
 
 #define PHY_ERROR_GEN_SPECTRAL_SCAN		0x26
 #define PHY_ERROR_GEN_FALSE_RADAR_EXT		0x24
@@ -6116,6 +6123,7 @@ struct wmi_mgmt_rx_ev_arg {
 	__le32 phy_mode;
 	__le32 buf_len;
 	__le32 status; /* %WMI_RX_STATUS_ */
+	struct wmi_mgmt_rx_ext_info ext_info;
 };
 
 struct wmi_ch_info_ev_arg {
-- 
1.9.1

