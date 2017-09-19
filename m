Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:7035 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751587AbdISDOG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 23:14:06 -0400
From: <yintang@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [TDLS PATCH V3 3/5] ath10k: Enable TDLS peer inactivity detection
Date: Tue, 19 Sep 2017 11:15:11 +0800
Message-ID: <1505790913-28377-4-git-send-email-yintang@qti.qualcomm.com> (sfid-20170919_051440_333764_A41BB127)
In-Reply-To: <1505790913-28377-1-git-send-email-yintang@qti.qualcomm.com>
References: <TDLS for ath10k patchset v3>
 <1505790913-28377-1-git-send-email-yintang@qti.qualcomm.com>
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
