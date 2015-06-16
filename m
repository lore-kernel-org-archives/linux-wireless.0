Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:23462 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbbFPFy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:54:27 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 2/8] ath10k: handle 10.4 firmware wmi swba event
Date: Tue, 16 Jun 2015 11:23:09 +0530
Message-ID: <1434433995-8451-3-git-send-email-rmani@qti.qualcomm.com> (sfid-20150616_075432_468990_6E8FEBD0)
In-Reply-To: <1434433995-8451-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434433995-8451-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.4 firmware swba event payload has space to accommodate upto
512 client traffic indication info & one p2p noa descriptor.
It's is not matching with exiting swba event format defined for
non 10.4 firmware. Non 10.4 firmware swba event format is designed
to support only upto only 128 client and four p2p notice of absence
descriptor.

following changes are done in this patch to enable ath10k to handle
10.4 firmware swba event,

 - link generic ath10k_wmi_event_host_swba() to handle 10.4 swba
   event in 10.4 wmi rx handler.

 - add 10.4 specific swba event structure wmi_10_4_host_swba_event.

 - new function ath10k_wmi_10_4_op_pull_swba_ev() to parse
   10.4 swba event.

 - increase tim_bitmap[] size in ath10k_vif to 64 to hold 512 station
   power save state.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  4 +--
 drivers/net/wireless/ath/ath10k/wmi.c  | 61 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h  | 41 +++++++++++++++++++++++
 3 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7c2ffb3..7721548 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -360,8 +360,8 @@ struct ath10k_vif {
 			u32 uapsd;
 		} sta;
 		struct {
-			/* 127 stations; wmi limit */
-			u8 tim_bitmap[16];
+			/* 512 stations */
+			u8 tim_bitmap[64];
 			u8 tim_len;
 			u32 ssid_len;
 			u8 ssid[IEEE80211_MAX_SSID_LEN];
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 793d7c21..bbcc943 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2944,6 +2944,63 @@ static int ath10k_wmi_op_pull_swba_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
+static int ath10k_wmi_10_4_op_pull_swba_ev(struct ath10k *ar,
+					   struct sk_buff *skb,
+					   struct wmi_swba_ev_arg *arg)
+{
+	struct wmi_10_4_host_swba_event *ev = (void *)skb->data;
+	u32 map, tim_len;
+	size_t i;
+
+	if (skb->len < sizeof(*ev))
+		return -EPROTO;
+
+	skb_pull(skb, sizeof(*ev));
+	arg->vdev_map = ev->vdev_map;
+
+	for (i = 0, map = __le32_to_cpu(ev->vdev_map); map; map >>= 1) {
+		if (!(map & BIT(0)))
+			continue;
+
+		/* If this happens there were some changes in firmware and
+		 * ath10k should update the max size of tim_info array.
+		 */
+		if (WARN_ON_ONCE(i == ARRAY_SIZE(arg->tim_info)))
+			break;
+
+		if (__le32_to_cpu(ev->bcn_info[i].tim_info.tim_len) >
+		      sizeof(ev->bcn_info[i].tim_info.tim_bitmap)) {
+			ath10k_warn(ar, "refusing to parse invalid swba structure\n");
+			return -EPROTO;
+		}
+
+		tim_len = __le32_to_cpu(ev->bcn_info[i].tim_info.tim_len);
+		if (tim_len) {
+			/* Exclude 4 byte guard length */
+			tim_len -= 4;
+			arg->tim_info[i].tim_len = __cpu_to_le32(tim_len);
+		} else {
+			arg->tim_info[i].tim_len = 0;
+		}
+
+		arg->tim_info[i].tim_mcast = ev->bcn_info[i].tim_info.tim_mcast;
+		arg->tim_info[i].tim_bitmap =
+				ev->bcn_info[i].tim_info.tim_bitmap;
+		arg->tim_info[i].tim_changed =
+				ev->bcn_info[i].tim_info.tim_changed;
+		arg->tim_info[i].tim_num_ps_pending =
+				ev->bcn_info[i].tim_info.tim_num_ps_pending;
+
+		/* 10.4 firmware doesn't have p2p support. notice of absence
+		 * info can be ignored for now.
+		 */
+
+		i++;
+	}
+
+	return 0;
+}
+
 void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_swba_ev_arg arg = {};
@@ -4278,6 +4335,9 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_10_4_READY_EVENTID:
 		ath10k_wmi_event_ready(ar, skb);
 		break;
+	case WMI_10_4_HOST_SWBA_EVENTID:
+		ath10k_wmi_event_host_swba(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
@@ -6209,6 +6269,7 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.rx = ath10k_wmi_10_4_op_rx,
 	.map_svc = wmi_10_4_svc_map,
 	.pull_mgmt_rx = ath10k_wmi_10_4_op_pull_mgmt_rx_ev,
+	.pull_swba = ath10k_wmi_10_4_op_pull_swba_ev,
 	.pull_svc_rdy = ath10k_wmi_main_op_pull_svc_rdy_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
 	.gen_init = ath10k_wmi_10_4_op_gen_init,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index e63f68c..df66581 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5132,6 +5132,47 @@ struct wmi_host_swba_event {
 	struct wmi_bcn_info bcn_info[0];
 } __packed;
 
+/* 16 words = 512 client + 1 word = for guard */
+#define WMI_10_4_TIM_BITMAP_ARRAY_SIZE 17
+
+struct wmi_10_4_tim_info {
+	__le32 tim_len;
+	__le32 tim_mcast;
+	__le32 tim_bitmap[WMI_10_4_TIM_BITMAP_ARRAY_SIZE];
+	__le32 tim_changed;
+	__le32 tim_num_ps_pending;
+} __packed;
+
+#define WMI_10_4_P2P_MAX_NOA_DESCRIPTORS 1
+
+struct wmi_10_4_p2p_noa_info {
+	/* Bit 0 - Flag to indicate an update in NOA schedule
+	 * Bits 7-1 - Reserved
+	 */
+	u8 changed;
+	/* NOA index */
+	u8 index;
+	/* Bit 0 - Opp PS state of the AP
+	 * Bits 1-7 - Ctwindow in TUs
+	 */
+	u8 ctwindow_oppps;
+	/* Number of NOA descriptors */
+	u8 num_descriptors;
+
+	struct wmi_p2p_noa_descriptor
+		noa_descriptors[WMI_10_4_P2P_MAX_NOA_DESCRIPTORS];
+} __packed;
+
+struct wmi_10_4_bcn_info {
+	struct wmi_10_4_tim_info tim_info;
+	struct wmi_10_4_p2p_noa_info p2p_noa_info;
+} __packed;
+
+struct wmi_10_4_host_swba_event {
+	__le32 vdev_map;
+	struct wmi_10_4_bcn_info bcn_info[0];
+} __packed;
+
 #define WMI_MAX_AP_VDEV 16
 
 struct wmi_tbtt_offset_event {
-- 
1.8.1.2

