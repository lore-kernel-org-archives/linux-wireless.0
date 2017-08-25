Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0057.outbound.protection.outlook.com ([104.47.37.57]:63780
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754421AbdHYCbH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:31:07 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 21/27] qtnfmac: extend "IE set" TLV to include frame type info
Date: Thu, 24 Aug 2017 19:30:18 -0700
Message-Id: <20170825023024.10565-22-igor.mitsyanko.os@quantenna.com> (sfid-20170825_044308_560543_A8148E67)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Specifying frame type for "IE set" TLV will allow to use several
TLVs in a single message.
Modify users accordingly.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 25 +++++++---
 drivers/net/wireless/quantenna/qtnfmac/event.c    | 58 +++++++++++++----------
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 27 +++++++++++
 3 files changed, 80 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 79a3e75..cc37114 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -147,6 +147,21 @@ static struct sk_buff *qtnf_cmd_alloc_new_cmdskb(u8 macid, u8 vifid, u16 cmd_no,
 	return cmd_skb;
 }
 
+static void qtnf_cmd_tlv_ie_set_add(struct sk_buff *cmd_skb, u8 frame_type,
+				    const u8 *buf, size_t len)
+{
+	struct qlink_tlv_ie_set *tlv;
+
+	tlv = (struct qlink_tlv_ie_set *)skb_put(cmd_skb, sizeof(*tlv) + len);
+	tlv->hdr.type = cpu_to_le16(QTN_TLV_ID_IE_SET);
+	tlv->hdr.len = cpu_to_le16(len + sizeof(*tlv) - sizeof(tlv->hdr));
+	tlv->type = frame_type;
+	tlv->flags = 0;
+
+	if (len && buf)
+		memcpy(tlv->ie_data, buf, len);
+}
+
 int qtnf_cmd_send_start_ap(struct qtnf_vif *vif)
 {
 	struct sk_buff *cmd_skb;
@@ -2026,9 +2041,8 @@ int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 	}
 
 	if (scan_req->ie_len != 0)
-		qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_IE_SET,
-					 scan_req->ie,
-					 scan_req->ie_len);
+		qtnf_cmd_tlv_ie_set_add(cmd_skb, QLINK_IE_SET_PROBE_REQ,
+					scan_req->ie, scan_req->ie_len);
 
 	if (scan_req->n_channels) {
 		n_channels = scan_req->n_channels;
@@ -2152,9 +2166,8 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 				 sme->ssid_len);
 
 	if (sme->ie_len != 0)
-		qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_IE_SET,
-					 sme->ie,
-					 sme->ie_len);
+		qtnf_cmd_tlv_ie_set_add(cmd_skb, QLINK_IE_SET_ASSOC_REQ,
+					sme->ie, sme->ie_len);
 
 	qtnf_bus_lock(vif->mac->bus);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index b2f6410..c2452dc 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -65,34 +65,39 @@ qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 	sinfo.assoc_req_ies_len = 0;
 
 	payload_len = len - sizeof(*sta_assoc);
-	tlv = (struct qlink_tlv_hdr *)sta_assoc->ies;
+	tlv = (const struct qlink_tlv_hdr *)sta_assoc->ies;
 
-	while (payload_len >= sizeof(struct qlink_tlv_hdr)) {
+	while (payload_len >= sizeof(*tlv)) {
 		tlv_type = le16_to_cpu(tlv->type);
 		tlv_value_len = le16_to_cpu(tlv->len);
 		tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
 
-		if (tlv_full_len > payload_len) {
-			pr_warn("VIF%u.%u: malformed TLV 0x%.2X; LEN: %u\n",
-				mac->macid, vif->vifid, tlv_type,
-				tlv_value_len);
+		if (tlv_full_len > payload_len)
 			return -EINVAL;
-		}
 
 		if (tlv_type == QTN_TLV_ID_IE_SET) {
-			sinfo.assoc_req_ies = tlv->val;
-			sinfo.assoc_req_ies_len = tlv_value_len;
+			const struct qlink_tlv_ie_set *ie_set;
+			unsigned int ie_len;
+
+			if (payload_len < sizeof(*ie_set))
+				return -EINVAL;
+
+			ie_set = (const struct qlink_tlv_ie_set *)tlv;
+			ie_len = tlv_value_len -
+				(sizeof(*ie_set) - sizeof(ie_set->hdr));
+
+			if (ie_set->type == QLINK_IE_SET_ASSOC_REQ && ie_len) {
+				sinfo.assoc_req_ies = ie_set->ie_data;
+				sinfo.assoc_req_ies_len = ie_len;
+			}
 		}
 
 		payload_len -= tlv_full_len;
 		tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
 	}
 
-	if (payload_len) {
-		pr_warn("VIF%u.%u: malformed TLV buf; bytes left: %zu\n",
-			mac->macid, vif->vifid, payload_len);
+	if (payload_len)
 		return -EINVAL;
-	}
 
 	cfg80211_new_sta(vif->netdev, sta_assoc->sta_addr, &sinfo,
 			 GFP_KERNEL);
@@ -289,27 +294,32 @@ qtnf_event_handle_scan_results(struct qtnf_vif *vif,
 		tlv_value_len = le16_to_cpu(tlv->len);
 		tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
 
-		if (tlv_full_len > payload_len) {
-			pr_warn("VIF%u.%u: malformed TLV 0x%.2X; LEN: %u\n",
-				vif->mac->macid, vif->vifid, tlv_type,
-				tlv_value_len);
+		if (tlv_full_len > payload_len)
 			return -EINVAL;
-		}
 
 		if (tlv_type == QTN_TLV_ID_IE_SET) {
-			ies = tlv->val;
-			ies_len = tlv_value_len;
+			const struct qlink_tlv_ie_set *ie_set;
+			unsigned int ie_len;
+
+			if (payload_len < sizeof(*ie_set))
+				return -EINVAL;
+
+			ie_set = (const struct qlink_tlv_ie_set *)tlv;
+			ie_len = tlv_value_len -
+				(sizeof(*ie_set) - sizeof(ie_set->hdr));
+
+			if (ie_len) {
+				ies = ie_set->ie_data;
+				ies_len = ie_len;
+			}
 		}
 
 		payload_len -= tlv_full_len;
 		tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
 	}
 
-	if (payload_len) {
-		pr_warn("VIF%u.%u: malformed TLV buf; bytes left: %zu\n",
-			vif->mac->macid, vif->vifid, payload_len);
+	if (payload_len)
 		return -EINVAL;
-	}
 
 	bss = cfg80211_inform_bss(wiphy, channel, frame_type,
 				  sr->bssid, get_unaligned_le64(&sr->tsf),
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index e4d3e7f..ecf493d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -1138,6 +1138,33 @@ struct qlink_tlv_chandef {
 	struct qlink_chandef chan;
 } __packed;
 
+enum qlink_ie_set_type {
+	QLINK_IE_SET_UNKNOWN,
+	QLINK_IE_SET_ASSOC_REQ,
+	QLINK_IE_SET_ASSOC_RESP,
+	QLINK_IE_SET_PROBE_REQ,
+	QLINK_IE_SET_SCAN,
+	QLINK_IE_SET_BEACON_HEAD,
+	QLINK_IE_SET_BEACON_TAIL,
+	QLINK_IE_SET_BEACON_IES,
+	QLINK_IE_SET_PROBE_RESP,
+	QLINK_IE_SET_PROBE_RESP_IES,
+};
+
+/**
+ * struct qlink_tlv_ie_set - data for QTN_TLV_ID_IE_SET
+ *
+ * @type: type of MGMT frame IEs belong to, one of &enum qlink_ie_set_type.
+ * @flags: for future use.
+ * @ie_data: IEs data.
+ */
+struct qlink_tlv_ie_set {
+	struct qlink_tlv_hdr hdr;
+	u8 type;
+	u8 flags;
+	u8 ie_data[0];
+} __packed;
+
 struct qlink_chan_stats {
 	__le32 chan_num;
 	__le32 cca_tx;
-- 
2.9.5
