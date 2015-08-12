Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62512 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbbHLJ51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 05:57:27 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: handle 10.4 firmware phyerr event
Date: Wed, 12 Aug 2015 15:26:36 +0530
Message-ID: <1439373396-10828-2-git-send-email-rmani@qti.qualcomm.com> (sfid-20150812_115729_438453_D113DC3D)
In-Reply-To: <1439373396-10828-1-git-send-email-rmani@qti.qualcomm.com>
References: <1439373396-10828-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Header format of 10.4 firmware phyerr event is not alligned
with pre 10.4 firmware. Introduce new wmi handlers to parse
10.4 firmware specific phyerror event header.

With changes covered in this patch, radar detection works on
qca99x0 hw 2.0 which uses 10.4 firmware.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 61 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h | 20 ++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 37dfa34..153fd17 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3527,6 +3527,26 @@ static int ath10k_wmi_op_pull_phyerr_ev_hdr(struct ath10k *ar,
 	return 0;
 }
 
+static int ath10k_wmi_10_4_op_pull_phyerr_ev_hdr(struct ath10k *ar,
+						 struct sk_buff *skb,
+						 struct wmi_phyerr_hdr_arg *arg)
+{
+	struct wmi_10_4_phyerr_event *ev = (void *)skb->data;
+
+	if (skb->len < sizeof(*ev))
+		return -EPROTO;
+
+	/* 10.4 firmware always reports only one phyerr */
+	arg->num_phyerrs = 1;
+
+	arg->tsf_l32 = __le32_to_cpu(ev->tsf_l32);
+	arg->tsf_u32 = __le32_to_cpu(ev->tsf_u32);
+	arg->buf_len = skb->len;
+	arg->phyerrs = skb->data;
+
+	return 0;
+}
+
 int ath10k_wmi_op_pull_phyerr_ev(struct ath10k *ar,
 				 const void *phyerr_buf,
 				 int left_len,
@@ -3571,6 +3591,42 @@ int ath10k_wmi_op_pull_phyerr_ev(struct ath10k *ar,
 	return 0;
 }
 
+int ath10k_wmi_10_4_op_pull_phyerr_ev(struct ath10k *ar,
+				      const void *phyerr_buf,
+				      int left_len,
+				      struct wmi_phyerr_ev_arg *arg)
+{
+	const struct wmi_10_4_phyerr_event *phyerr = phyerr_buf;
+	int i;
+
+	if (left_len < sizeof(*phyerr)) {
+		ath10k_warn(ar, "wrong phyerr event head len %d (need: >=%d)\n",
+			    left_len, sizeof(*phyerr));
+		return -EINVAL;
+	}
+
+	arg->tsf_timestamp = __le32_to_cpu(phyerr->tsf_timestamp);
+	arg->freq1 = __le16_to_cpu(phyerr->freq1);
+	arg->freq2 = __le16_to_cpu(phyerr->freq2);
+	arg->rssi_combined = phyerr->rssi_combined;
+	arg->chan_width_mhz = phyerr->chan_width_mhz;
+	arg->buf_len = __le32_to_cpu(phyerr->buf_len);
+	arg->buf = phyerr->buf;
+	arg->hdr_len = sizeof(*phyerr);
+
+	for (i = 0; i < 4; i++)
+		arg->nf_chains[i] = __le16_to_cpu(phyerr->nf_chains[i]);
+
+	if (phyerr->phy_err_mask[0] & PHY_ERROR_10_4_SPECTRAL_SCAN_MASK)
+		arg->phy_err_code = PHY_ERROR_SPECTRAL_SCAN;
+	else if (phyerr->phy_err_mask[0] & PHY_ERROR_10_4_RADAR_MASK)
+		arg->phy_err_code = PHY_ERROR_RADAR;
+	else
+		arg->phy_err_code = PHY_ERROR_UNKNOWN;
+
+	return 0;
+}
+
 void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_phyerr_hdr_arg hdr_arg = {};
@@ -4528,6 +4584,9 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_10_4_CHAN_INFO_EVENTID:
 		ath10k_wmi_event_chan_info(ar, skb);
 		break;
+	case WMI_10_4_PHYERR_EVENTID:
+		ath10k_wmi_event_phyerr(ar, skb);
+		break;
 	case WMI_10_4_READY_EVENTID:
 		ath10k_wmi_event_ready(ar, skb);
 		break;
@@ -6491,6 +6550,8 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.pull_vdev_start = ath10k_wmi_op_pull_vdev_start_ev,
 	.pull_peer_kick = ath10k_wmi_op_pull_peer_kick_ev,
 	.pull_swba = ath10k_wmi_10_4_op_pull_swba_ev,
+	.pull_phyerr_hdr = ath10k_wmi_10_4_op_pull_phyerr_ev_hdr,
+	.pull_phyerr = ath10k_wmi_10_4_op_pull_phyerr_ev,
 	.pull_svc_rdy = ath10k_wmi_main_op_pull_svc_rdy_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 0ed3cfe..c5d10db 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2977,6 +2977,9 @@ struct wmi_10_4_mgmt_rx_event {
 #define PHY_ERROR_GEN_FALSE_RADAR_EXT		0x24
 #define PHY_ERROR_GEN_RADAR			0x05
 
+#define PHY_ERROR_10_4_RADAR_MASK               0x4
+#define PHY_ERROR_10_4_SPECTRAL_SCAN_MASK       0x4000000
+
 enum phy_err_type {
 	PHY_ERROR_UNKNOWN,
 	PHY_ERROR_SPECTRAL_SCAN,
@@ -3005,6 +3008,23 @@ struct wmi_phyerr_event {
 	struct wmi_phyerr phyerrs[0];
 } __packed;
 
+struct wmi_10_4_phyerr_event {
+	__le32 tsf_l32;
+	__le32 tsf_u32;
+	__le16 freq1;
+	__le16 freq2;
+	u8 rssi_combined;
+	u8 chan_width_mhz;
+	u8 phy_err_code;
+	u8 rsvd0;
+	__le32 rssi_chains[4];
+	__le16 nf_chains[4];
+	__le32 phy_err_mask[2];
+	__le32 tsf_timestamp;
+	__le32 buf_len;
+	u8 buf[0];
+} __packed;
+
 #define PHYERR_TLV_SIG				0xBB
 #define PHYERR_TLV_TAG_SEARCH_FFT_REPORT	0xFB
 #define PHYERR_TLV_TAG_RADAR_PULSE_SUMMARY	0xF8
-- 
1.8.1.2

