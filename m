Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29787 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755672AbdJJHxs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 03:53:48 -0400
From: <yintang@qti.qualcomm.com>
To: <ath10k-ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/5] ath10k: Enable TDLS peer inactivity detection
Date: Tue, 10 Oct 2017 15:55:23 +0800
Message-ID: <1507622125-8841-5-git-send-email-yintang@qti.qualcomm.com> (sfid-20171010_095351_993430_6AC6E7C3)
In-Reply-To: <1507622125-8841-1-git-send-email-yintang@qti.qualcomm.com>
References: <TDLS for ath10k patch V4>
 <1507622125-8841-1-git-send-email-yintang@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yingying Tang <yintang@qti.qualcomm.com>

Enable TDLS peer inactivity detetion feature.
QCA6174 firmware(version: WLAN.RM.4.4) support TDLS link inactivity detecting.
Set related parameters in TDLS WMI command to enable this feature.

Signed-off-by: Yingying Tang <yintang@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   52 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |   23 +++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |    1 +
 3 files changed, 76 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index f60b46e..63bb2c4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -412,6 +412,49 @@ static int ath10k_wmi_tlv_event_tx_pause(struct ath10k *ar,
 	return 0;
 }
 
+void ath10k_wmi_event_tdls_peer(struct ath10k *ar, struct sk_buff *skb)
+{
+	struct ieee80211_sta *station;
+	const struct wmi_tlv_tdls_peer_event *ev;
+	const void **tb;
+	struct ath10k_vif *arvif;
+
+	tb = ath10k_wmi_tlv_parse_alloc(ar, skb->data, skb->len, GFP_ATOMIC);
+	if (IS_ERR(tb)) {
+		ath10k_warn(ar, "tdls peer failed to parse tlv");
+		return;
+	}
+	ev = tb[WMI_TLV_TAG_STRUCT_TDLS_PEER_EVENT];
+	if (!ev) {
+		kfree(tb);
+		ath10k_warn(ar, "tdls peer NULL event");
+		return;
+	}
+
+	switch (ev->peer_reason) {
+	case WMI_TDLS_TEARDOWN_REASON_TX:
+	case WMI_TDLS_TEARDOWN_REASON_RSSI:
+	case WMI_TDLS_TEARDOWN_REASON_PTR_TIMEOUT:
+		station = ieee80211_find_sta_by_ifaddr(ar->hw,
+						       ev->peer_macaddr.addr,
+						       NULL);
+		if (!station) {
+			ath10k_warn(ar, "did not find station from tdls peer event");
+			kfree(tb);
+			return;
+		}
+		arvif = ath10k_get_arvif(ar, ev->vdev_id);
+		ieee80211_tdls_oper_request(
+					arvif->vif, station->addr,
+					NL80211_TDLS_TEARDOWN,
+					WLAN_REASON_TDLS_TEARDOWN_UNREACHABLE,
+					GFP_ATOMIC
+					);
+		break;
+	}
+	kfree(tb);
+}
+
 /***********/
 /* TLV ops */
 /***********/
@@ -552,6 +595,9 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_TLV_TX_PAUSE_EVENTID:
 		ath10k_wmi_tlv_event_tx_pause(ar, skb);
 		break;
+	case WMI_TLV_TDLS_PEER_EVENTID:
+		ath10k_wmi_event_tdls_peer(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
@@ -2750,6 +2796,12 @@ static void *ath10k_wmi_tlv_put_wmm(void *ptr,
 	if (test_bit(WMI_SERVICE_TDLS_UAPSD_BUFFER_STA, ar->wmi.svc_map))
 		options |=  WMI_TLV_TDLS_BUFFER_STA_EN;
 
+	/* WMI_TDLS_ENABLE_ACTIVE_EXTERNAL_CONTROL means firm will handle TDLS
+	 * link inactivity detecting logic.
+	 */
+	if (state == WMI_TDLS_ENABLE_ACTIVE)
+		state = WMI_TDLS_ENABLE_ACTIVE_EXTERNAL_CONTROL;
+
 	len = sizeof(*tlv) + sizeof(*cmd);
 	skb = ath10k_wmi_alloc_skb(ar, len);
 	if (!skb)
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 22cf011..00d68c5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1641,6 +1641,29 @@ struct wmi_tlv_tx_pause_ev {
 	__le32 tid_map;
 } __packed;
 
+struct wmi_tlv_tdls_peer_event {
+	struct wmi_mac_addr    peer_macaddr;
+	__le32 peer_status;
+	__le32 peer_reason;
+	__le32 vdev_id;
+} __packed;
+
+enum wmi_tdls_peer_reason {
+	WMI_TDLS_TEARDOWN_REASON_TX,
+	WMI_TDLS_TEARDOWN_REASON_RSSI,
+	WMI_TDLS_TEARDOWN_REASON_SCAN,
+	WMI_TDLS_DISCONNECTED_REASON_PEER_DELETE,
+	WMI_TDLS_TEARDOWN_REASON_PTR_TIMEOUT,
+	WMI_TDLS_TEARDOWN_REASON_BAD_PTR,
+	WMI_TDLS_TEARDOWN_REASON_NO_RESPONSE,
+	WMI_TDLS_ENTER_BUF_STA,
+	WMI_TDLS_EXIT_BUF_STA,
+	WMI_TDLS_ENTER_BT_BUSY_MODE,
+	WMI_TDLS_EXIT_BT_BUSY_MODE,
+	WMI_TDLS_SCAN_STARTED_EVENT,
+	WMI_TDLS_SCAN_COMPLETED_EVENT,
+};
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 7a3606d..74a6c78 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6720,6 +6720,7 @@ enum wmi_tdls_state {
 	WMI_TDLS_DISABLE,
 	WMI_TDLS_ENABLE_PASSIVE,
 	WMI_TDLS_ENABLE_ACTIVE,
+	WMI_TDLS_ENABLE_ACTIVE_EXTERNAL_CONTROL,
 };
 
 enum wmi_tdls_peer_state {
-- 
1.7.9.5
