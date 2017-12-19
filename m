Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0052.outbound.protection.outlook.com ([104.47.42.52]:40224
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965745AbdLSL3e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 06:29:34 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH v2 08/10] qtnfmac: modify GET_STA_STATS cmd format for back/forward compatibility
Date: Tue, 19 Dec 2017 14:28:54 +0300
Message-Id: <20171219112856.22463-9-sergey.matyukevich.os@quantenna.com> (sfid-20171219_122952_473478_2EC95284)
In-Reply-To: <20171219112856.22463-1-sergey.matyukevich.os@quantenna.com>
References: <20171219112856.22463-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

A set of per-STA statistics can potentially change quite often.
To ensure backwards and forward compatibility,
modify GET_STA_STATS command format:
  - introduce two TLV types
  - first TLV is a variable-sized bitmap of statistics values
    that are filled by firmware
  - second TLV is a structure with statistics itself

Only values specified in first TLV are valid.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 217 +++++++++++----------
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     | 204 ++++++++++++-------
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    |  12 ++
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |   2 +
 4 files changed, 267 insertions(+), 168 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 839e86b99837..38b9c1078058 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -461,30 +461,8 @@ int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif, u8 frame_type,
 }
 
 static void
-qtnf_sta_info_parse_basic_counters(struct station_info *sinfo,
-		const struct qlink_sta_stat_basic_counters *counters)
-{
-	sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES) |
-			 BIT(NL80211_STA_INFO_TX_BYTES);
-	sinfo->rx_bytes = get_unaligned_le64(&counters->rx_bytes);
-	sinfo->tx_bytes = get_unaligned_le64(&counters->tx_bytes);
-
-	sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS) |
-			 BIT(NL80211_STA_INFO_TX_PACKETS) |
-			 BIT(NL80211_STA_INFO_BEACON_RX);
-	sinfo->rx_packets = get_unaligned_le32(&counters->rx_packets);
-	sinfo->tx_packets = get_unaligned_le32(&counters->tx_packets);
-	sinfo->rx_beacon = get_unaligned_le64(&counters->rx_beacons);
-
-	sinfo->filled |= BIT(NL80211_STA_INFO_RX_DROP_MISC) |
-			 BIT(NL80211_STA_INFO_TX_FAILED);
-	sinfo->rx_dropped_misc = get_unaligned_le32(&counters->rx_dropped);
-	sinfo->tx_failed = get_unaligned_le32(&counters->tx_failed);
-}
-
-static void
 qtnf_sta_info_parse_rate(struct rate_info *rate_dst,
-			 const struct  qlink_sta_info_rate *rate_src)
+			 const struct qlink_sta_info_rate *rate_src)
 {
 	rate_dst->legacy = get_unaligned_le16(&rate_src->rate) * 10;
 
@@ -493,22 +471,23 @@ qtnf_sta_info_parse_rate(struct rate_info *rate_dst,
 	rate_dst->flags = 0;
 
 	switch (rate_src->bw) {
-	case QLINK_STA_INFO_RATE_BW_5:
+	case QLINK_CHAN_WIDTH_5:
 		rate_dst->bw = RATE_INFO_BW_5;
 		break;
-	case QLINK_STA_INFO_RATE_BW_10:
+	case QLINK_CHAN_WIDTH_10:
 		rate_dst->bw = RATE_INFO_BW_10;
 		break;
-	case QLINK_STA_INFO_RATE_BW_20:
+	case QLINK_CHAN_WIDTH_20:
+	case QLINK_CHAN_WIDTH_20_NOHT:
 		rate_dst->bw = RATE_INFO_BW_20;
 		break;
-	case QLINK_STA_INFO_RATE_BW_40:
+	case QLINK_CHAN_WIDTH_40:
 		rate_dst->bw = RATE_INFO_BW_40;
 		break;
-	case QLINK_STA_INFO_RATE_BW_80:
+	case QLINK_CHAN_WIDTH_80:
 		rate_dst->bw = RATE_INFO_BW_80;
 		break;
-	case QLINK_STA_INFO_RATE_BW_160:
+	case QLINK_CHAN_WIDTH_160:
 		rate_dst->bw = RATE_INFO_BW_160;
 		break;
 	default:
@@ -578,87 +557,125 @@ qtnf_sta_info_parse_flags(struct nl80211_sta_flag_update *dst,
 }
 
 static void
-qtnf_sta_info_parse_generic_info(struct station_info *sinfo,
-				 const struct qlink_sta_info_generic *info)
+qtnf_cmd_sta_info_parse(struct station_info *sinfo,
+			const struct qlink_tlv_hdr *tlv,
+			size_t resp_size)
 {
-	sinfo->filled |= BIT(NL80211_STA_INFO_CONNECTED_TIME) |
-			 BIT(NL80211_STA_INFO_INACTIVE_TIME);
-	sinfo->connected_time = get_unaligned_le32(&info->connected_time);
-	sinfo->inactive_time = get_unaligned_le32(&info->inactive_time);
+	const struct qlink_sta_stats *stats = NULL;
+	const u8 *map = NULL;
+	unsigned int map_len = 0;
+	unsigned int stats_len = 0;
+	u16 tlv_len;
+
+#define qtnf_sta_stat_avail(stat_name, bitn)	\
+	(qtnf_utils_is_bit_set(map, bitn, map_len) && \
+	 (offsetofend(struct qlink_sta_stats, stat_name) <= stats_len))
+
+	while (resp_size >= sizeof(*tlv)) {
+		tlv_len = le16_to_cpu(tlv->len);
+
+		switch (le16_to_cpu(tlv->type)) {
+		case QTN_TLV_ID_STA_STATS_MAP:
+			map_len = tlv_len;
+			map = tlv->val;
+			break;
+		case QTN_TLV_ID_STA_STATS:
+			stats_len = tlv_len;
+			stats = (const struct qlink_sta_stats *)tlv->val;
+			break;
+		default:
+			break;
+		}
+
+		resp_size -= tlv_len + sizeof(*tlv);
+		tlv = (const struct qlink_tlv_hdr *)(tlv->val + tlv_len);
+	}
 
-	sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL) |
-			 BIT(NL80211_STA_INFO_SIGNAL_AVG);
-	sinfo->signal = info->rssi - 120;
-	sinfo->signal_avg = info->rssi_avg - QLINK_RSSI_OFFSET;
+	if (!map || !stats)
+		return;
+
+	if (qtnf_sta_stat_avail(inactive_time, QLINK_STA_INFO_INACTIVE_TIME)) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME);
+		sinfo->inactive_time = le32_to_cpu(stats->inactive_time);
+	}
 
-	if (info->rx_rate.rate) {
+	if (qtnf_sta_stat_avail(connected_time,
+				QLINK_STA_INFO_CONNECTED_TIME)) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_CONNECTED_TIME);
+		sinfo->connected_time = le32_to_cpu(stats->connected_time);
+	}
+
+	if (qtnf_sta_stat_avail(signal, QLINK_STA_INFO_SIGNAL)) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+		sinfo->signal = stats->signal - QLINK_RSSI_OFFSET;
+	}
+
+	if (qtnf_sta_stat_avail(signal_avg, QLINK_STA_INFO_SIGNAL_AVG)) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL_AVG);
+		sinfo->signal_avg = stats->signal_avg - QLINK_RSSI_OFFSET;
+	}
+
+	if (qtnf_sta_stat_avail(rxrate, QLINK_STA_INFO_RX_BITRATE)) {
 		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
-		qtnf_sta_info_parse_rate(&sinfo->rxrate, &info->rx_rate);
+		qtnf_sta_info_parse_rate(&sinfo->rxrate, &stats->rxrate);
 	}
 
-	if (info->tx_rate.rate) {
+	if (qtnf_sta_stat_avail(txrate, QLINK_STA_INFO_TX_BITRATE)) {
 		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
-		qtnf_sta_info_parse_rate(&sinfo->txrate, &info->tx_rate);
+		qtnf_sta_info_parse_rate(&sinfo->txrate, &stats->txrate);
 	}
 
-	sinfo->filled |= BIT(NL80211_STA_INFO_STA_FLAGS);
-	qtnf_sta_info_parse_flags(&sinfo->sta_flags, &info->state);
-}
+	if (qtnf_sta_stat_avail(sta_flags, QLINK_STA_INFO_STA_FLAGS)) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_STA_FLAGS);
+		qtnf_sta_info_parse_flags(&sinfo->sta_flags, &stats->sta_flags);
+	}
 
-static int qtnf_cmd_sta_info_parse(struct station_info *sinfo,
-				   const u8 *payload, size_t payload_size)
-{
-	const struct qlink_sta_stat_basic_counters *counters;
-	const struct qlink_sta_info_generic *sta_info;
-	u16 tlv_type;
-	u16 tlv_value_len;
-	size_t tlv_full_len;
-	const struct qlink_tlv_hdr *tlv;
+	if (qtnf_sta_stat_avail(rx_bytes, QLINK_STA_INFO_RX_BYTES)) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES);
+		sinfo->rx_bytes = le64_to_cpu(stats->rx_bytes);
+	}
 
-	sinfo->filled = 0;
+	if (qtnf_sta_stat_avail(tx_bytes, QLINK_STA_INFO_TX_BYTES)) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BYTES);
+		sinfo->tx_bytes = le64_to_cpu(stats->tx_bytes);
+	}
 
-	tlv = (const struct qlink_tlv_hdr *)payload;
-	while (payload_size >= sizeof(struct qlink_tlv_hdr)) {
-		tlv_type = le16_to_cpu(tlv->type);
-		tlv_value_len = le16_to_cpu(tlv->len);
-		tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
-		if (tlv_full_len > payload_size) {
-			pr_warn("malformed TLV 0x%.2X; LEN: %u\n",
-				tlv_type, tlv_value_len);
-			return -EINVAL;
-		}
-		switch (tlv_type) {
-		case QTN_TLV_ID_STA_BASIC_COUNTERS:
-			if (unlikely(tlv_value_len < sizeof(*counters))) {
-				pr_err("invalid TLV size %.4X: %u\n",
-				       tlv_type, tlv_value_len);
-				break;
-			}
+	if (qtnf_sta_stat_avail(rx_bytes, QLINK_STA_INFO_RX_BYTES64)) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES64);
+		sinfo->rx_bytes = le64_to_cpu(stats->rx_bytes);
+	}
 
-			counters = (void *)tlv->val;
-			qtnf_sta_info_parse_basic_counters(sinfo, counters);
-			break;
-		case QTN_TLV_ID_STA_GENERIC_INFO:
-			if (unlikely(tlv_value_len < sizeof(*sta_info)))
-				break;
+	if (qtnf_sta_stat_avail(tx_bytes, QLINK_STA_INFO_TX_BYTES64)) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BYTES64);
+		sinfo->tx_bytes = le64_to_cpu(stats->tx_bytes);
+	}
 
-			sta_info = (void *)tlv->val;
-			qtnf_sta_info_parse_generic_info(sinfo, sta_info);
-			break;
-		default:
-			pr_warn("unexpected TLV type: %.4X\n", tlv_type);
-			break;
-		}
-		payload_size -= tlv_full_len;
-		tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
+	if (qtnf_sta_stat_avail(rx_packets, QLINK_STA_INFO_RX_PACKETS)) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS);
+		sinfo->rx_packets = le32_to_cpu(stats->rx_packets);
 	}
 
-	if (payload_size) {
-		pr_warn("malformed TLV buf; bytes left: %zu\n", payload_size);
-		return -EINVAL;
+	if (qtnf_sta_stat_avail(tx_packets, QLINK_STA_INFO_TX_PACKETS)) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_PACKETS);
+		sinfo->tx_packets = le32_to_cpu(stats->tx_packets);
 	}
 
-	return 0;
+	if (qtnf_sta_stat_avail(rx_beacon, QLINK_STA_INFO_BEACON_RX)) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_BEACON_RX);
+		sinfo->rx_beacon = le64_to_cpu(stats->rx_beacon);
+	}
+
+	if (qtnf_sta_stat_avail(rx_dropped_misc, QLINK_STA_INFO_RX_DROP_MISC)) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_RX_DROP_MISC);
+		sinfo->rx_dropped_misc = le32_to_cpu(stats->rx_dropped_misc);
+	}
+
+	if (qtnf_sta_stat_avail(tx_failed, QLINK_STA_INFO_TX_FAILED)) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_FAILED);
+		sinfo->tx_failed = le32_to_cpu(stats->tx_failed);
+	}
+
+#undef qtnf_sta_stat_avail
 }
 
 int qtnf_cmd_get_sta_info(struct qtnf_vif *vif, const u8 *sta_mac,
@@ -715,7 +732,9 @@ int qtnf_cmd_get_sta_info(struct qtnf_vif *vif, const u8 *sta_mac,
 		goto out;
 	}
 
-	ret = qtnf_cmd_sta_info_parse(sinfo, resp->info, var_resp_len);
+	qtnf_cmd_sta_info_parse(sinfo,
+				(const struct qlink_tlv_hdr *)resp->info,
+				var_resp_len);
 
 out:
 	qtnf_bus_unlock(vif->mac->bus);
@@ -1992,21 +2011,17 @@ int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, const u8 *mac,
 
 	cmd = (struct qlink_cmd_change_sta *)cmd_skb->data;
 	ether_addr_copy(cmd->sta_addr, mac);
+	cmd->flag_update.mask =
+		cpu_to_le32(qtnf_encode_sta_flags(params->sta_flags_mask));
+	cmd->flag_update.value =
+		cpu_to_le32(qtnf_encode_sta_flags(params->sta_flags_set));
 
 	switch (vif->wdev.iftype) {
 	case NL80211_IFTYPE_AP:
 		cmd->if_type = cpu_to_le16(QLINK_IFTYPE_AP);
-		cmd->sta_flags_mask = cpu_to_le32(qtnf_encode_sta_flags(
-						  params->sta_flags_mask));
-		cmd->sta_flags_set = cpu_to_le32(qtnf_encode_sta_flags(
-						 params->sta_flags_set));
 		break;
 	case NL80211_IFTYPE_STATION:
 		cmd->if_type = cpu_to_le16(QLINK_IFTYPE_STATION);
-		cmd->sta_flags_mask = cpu_to_le32(qtnf_encode_sta_flags(
-						  params->sta_flags_mask));
-		cmd->sta_flags_set = cpu_to_le32(qtnf_encode_sta_flags(
-						 params->sta_flags_set));
 		break;
 	default:
 		pr_err("unsupported iftype %d\n", vif->wdev.iftype);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index f4d7d1603e3c..5d98000b0f5b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -19,7 +19,7 @@
 
 #include <linux/ieee80211.h>
 
-#define QLINK_PROTO_VER		8
+#define QLINK_PROTO_VER		9
 
 #define QLINK_MACID_RSVD		0xFF
 #define QLINK_VIFID_RSVD		0xFF
@@ -185,6 +185,17 @@ struct qlink_auth_encr {
 	u8 rsvd[2];
 } __packed;
 
+/**
+ * struct qlink_sta_info_state - station flags mask/value
+ *
+ * @mask: STA flags mask, bitmap of &enum qlink_sta_flags
+ * @value: STA flags values, bitmap of &enum qlink_sta_flags
+ */
+struct qlink_sta_info_state {
+	__le32 mask;
+	__le32 value;
+} __packed;
+
 /* QLINK Command messages related definitions
  */
 
@@ -402,16 +413,14 @@ struct qlink_cmd_set_def_mgmt_key {
 /**
  * struct qlink_cmd_change_sta - data for QLINK_CMD_CHANGE_STA command
  *
- * @sta_flags_mask: STA flags mask, bitmap of &enum qlink_sta_flags
- * @sta_flags_set: STA flags values, bitmap of &enum qlink_sta_flags
+ * @flag_update: STA flags to update
  * @if_type: Mode of interface operation, one of &enum qlink_iface_type
  * @vlanid: VLAN ID to assign to specific STA
  * @sta_addr: address of the STA for which parameters are set.
  */
 struct qlink_cmd_change_sta {
 	struct qlink_cmd chdr;
-	__le32 sta_flags_mask;
-	__le32 sta_flags_set;
+	struct qlink_sta_info_state flag_update;
 	__le16 if_type;
 	__le16 vlanid;
 	u8 sta_addr[ETH_ALEN];
@@ -755,17 +764,27 @@ struct qlink_resp_manage_intf {
 	struct qlink_intf_info intf_info;
 } __packed;
 
+enum qlink_sta_info_rate_flags {
+	QLINK_STA_INFO_RATE_FLAG_HT_MCS		= BIT(0),
+	QLINK_STA_INFO_RATE_FLAG_VHT_MCS	= BIT(1),
+	QLINK_STA_INFO_RATE_FLAG_SHORT_GI	= BIT(2),
+	QLINK_STA_INFO_RATE_FLAG_60G		= BIT(3),
+};
+
 /**
  * struct qlink_resp_get_sta_info - response for QLINK_CMD_GET_STA_INFO command
  *
  * Response data containing statistics for specified STA.
  *
+ * @filled: a bitmask of &enum qlink_sta_info, specifies which info in response
+ *	is valid.
  * @sta_addr: MAC address of STA the response carries statistic for.
- * @info: statistics for specified STA.
+ * @info: variable statistics for specified STA.
  */
 struct qlink_resp_get_sta_info {
 	struct qlink_resp rhdr;
 	u8 sta_addr[ETH_ALEN];
+	u8 rsvd[2];
 	u8 info[0];
 } __packed;
 
@@ -1003,6 +1022,15 @@ struct qlink_event_radar {
 /* QLINK TLVs (Type-Length Values) definitions
  */
 
+/**
+ * enum qlink_tlv_id - list of TLVs that Qlink messages can carry
+ *
+ * @QTN_TLV_ID_STA_STATS_MAP: a bitmap of &enum qlink_sta_info, used to
+ *	indicate which statistic carried in QTN_TLV_ID_STA_STATS is valid.
+ * @QTN_TLV_ID_STA_STATS: per-STA statistics as defined by
+ *	&struct qlink_sta_stats. Valid values are marked as such in a bitmap
+ *	carried by QTN_TLV_ID_STA_STATS_MAP.
+ */
 enum qlink_tlv_id {
 	QTN_TLV_ID_FRAG_THRESH		= 0x0201,
 	QTN_TLV_ID_RTS_THRESH		= 0x0202,
@@ -1011,12 +1039,12 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_REG_RULE		= 0x0207,
 	QTN_TLV_ID_CHANNEL		= 0x020F,
 	QTN_TLV_ID_CHANDEF		= 0x0210,
+	QTN_TLV_ID_STA_STATS_MAP	= 0x0211,
+	QTN_TLV_ID_STA_STATS		= 0x0212,
 	QTN_TLV_ID_COVERAGE_CLASS	= 0x0213,
 	QTN_TLV_ID_IFACE_LIMIT		= 0x0214,
 	QTN_TLV_ID_NUM_IFACE_COMB	= 0x0215,
 	QTN_TLV_ID_CHANNEL_STATS	= 0x0216,
-	QTN_TLV_ID_STA_BASIC_COUNTERS	= 0x0300,
-	QTN_TLV_ID_STA_GENERIC_INFO	= 0x0301,
 	QTN_TLV_ID_KEY			= 0x0302,
 	QTN_TLV_ID_SEQ			= 0x0303,
 	QTN_TLV_ID_IE_SET		= 0x0305,
@@ -1038,67 +1066,8 @@ struct qlink_iface_comb_num {
 	__le16 iface_comb_num;
 } __packed;
 
-struct qlink_sta_stat_basic_counters {
-	__le64 rx_bytes;
-	__le64 tx_bytes;
-	__le64 rx_beacons;
-	__le32 rx_packets;
-	__le32 tx_packets;
-	__le32 rx_dropped;
-	__le32 tx_failed;
-} __packed;
-
-enum qlink_sta_info_rate_flags {
-	QLINK_STA_INFO_RATE_FLAG_INVALID	= 0,
-	QLINK_STA_INFO_RATE_FLAG_HT_MCS		= BIT(0),
-	QLINK_STA_INFO_RATE_FLAG_VHT_MCS	= BIT(1),
-	QLINK_STA_INFO_RATE_FLAG_SHORT_GI	= BIT(2),
-	QLINK_STA_INFO_RATE_FLAG_60G		= BIT(3),
-};
-
-enum qlink_sta_info_rate_bw {
-	QLINK_STA_INFO_RATE_BW_5		= 0,
-	QLINK_STA_INFO_RATE_BW_10		= 1,
-	QLINK_STA_INFO_RATE_BW_20		= 2,
-	QLINK_STA_INFO_RATE_BW_40		= 3,
-	QLINK_STA_INFO_RATE_BW_80		= 4,
-	QLINK_STA_INFO_RATE_BW_160		= 5,
-};
-
-/**
- * struct qlink_sta_info_rate - STA rate statistics
- *
- * @rate: data rate in Mbps.
- * @flags: bitmap of &enum qlink_sta_flags.
- * @mcs: 802.11-defined MCS index.
- * nss: Number of Spatial Streams.
- * @bw: bandwidth, one of &enum qlink_sta_info_rate_bw.
- */
-struct qlink_sta_info_rate {
-	__le16 rate;
-	u8 flags;
-	u8 mcs;
-	u8 nss;
-	u8 bw;
-} __packed;
-
-struct qlink_sta_info_state {
-	__le32 mask;
-	__le32 value;
-} __packed;
-
 #define QLINK_RSSI_OFFSET	120
 
-struct qlink_sta_info_generic {
-	struct qlink_sta_info_state state;
-	__le32 connected_time;
-	__le32 inactive_time;
-	struct qlink_sta_info_rate rx_rate;
-	struct qlink_sta_info_rate tx_rate;
-	u8 rssi;
-	u8 rssi_avg;
-} __packed;
-
 struct qlink_tlv_frag_rts_thr {
 	struct qlink_tlv_hdr hdr;
 	__le16 thr;
@@ -1243,4 +1212,105 @@ struct qlink_chan_stats {
 	s8 chan_noise;
 } __packed;
 
+/**
+ * enum qlink_sta_info - station information bitmap
+ *
+ * Used to indicate which statistics values in &struct qlink_sta_stats
+ * are valid. Individual values are used to fill a bitmap carried in a
+ * payload of QTN_TLV_ID_STA_STATS_MAP.
+ *
+ * @QLINK_STA_INFO_CONNECTED_TIME: connected_time value is valid.
+ * @QLINK_STA_INFO_INACTIVE_TIME: inactive_time value is valid.
+ * @QLINK_STA_INFO_RX_BYTES: lower 32 bits of rx_bytes value are valid.
+ * @QLINK_STA_INFO_TX_BYTES: lower 32 bits of tx_bytes value are valid.
+ * @QLINK_STA_INFO_RX_BYTES64: rx_bytes value is valid.
+ * @QLINK_STA_INFO_TX_BYTES64: tx_bytes value is valid.
+ * @QLINK_STA_INFO_RX_DROP_MISC: rx_dropped_misc value is valid.
+ * @QLINK_STA_INFO_BEACON_RX: rx_beacon value is valid.
+ * @QLINK_STA_INFO_SIGNAL: signal value is valid.
+ * @QLINK_STA_INFO_SIGNAL_AVG: signal_avg value is valid.
+ * @QLINK_STA_INFO_RX_BITRATE: rxrate value is valid.
+ * @QLINK_STA_INFO_TX_BITRATE: txrate value is valid.
+ * @QLINK_STA_INFO_RX_PACKETS: rx_packets value is valid.
+ * @QLINK_STA_INFO_TX_PACKETS: tx_packets value is valid.
+ * @QLINK_STA_INFO_TX_RETRIES: tx_retries value is valid.
+ * @QLINK_STA_INFO_TX_FAILED: tx_failed value is valid.
+ * @QLINK_STA_INFO_STA_FLAGS: sta_flags value is valid.
+ */
+enum qlink_sta_info {
+	QLINK_STA_INFO_CONNECTED_TIME,
+	QLINK_STA_INFO_INACTIVE_TIME,
+	QLINK_STA_INFO_RX_BYTES,
+	QLINK_STA_INFO_TX_BYTES,
+	QLINK_STA_INFO_RX_BYTES64,
+	QLINK_STA_INFO_TX_BYTES64,
+	QLINK_STA_INFO_RX_DROP_MISC,
+	QLINK_STA_INFO_BEACON_RX,
+	QLINK_STA_INFO_SIGNAL,
+	QLINK_STA_INFO_SIGNAL_AVG,
+	QLINK_STA_INFO_RX_BITRATE,
+	QLINK_STA_INFO_TX_BITRATE,
+	QLINK_STA_INFO_RX_PACKETS,
+	QLINK_STA_INFO_TX_PACKETS,
+	QLINK_STA_INFO_TX_RETRIES,
+	QLINK_STA_INFO_TX_FAILED,
+	QLINK_STA_INFO_STA_FLAGS,
+	QLINK_STA_INFO_NUM,
+};
+
+/**
+ * struct qlink_sta_info_rate - STA rate statistics
+ *
+ * @rate: data rate in Mbps.
+ * @flags: bitmap of &enum qlink_sta_info_rate_flags.
+ * @mcs: 802.11-defined MCS index.
+ * nss: Number of Spatial Streams.
+ * @bw: bandwidth, one of &enum qlink_channel_width.
+ */
+struct qlink_sta_info_rate {
+	__le16 rate;
+	u8 flags;
+	u8 mcs;
+	u8 nss;
+	u8 bw;
+} __packed;
+
+/**
+ * struct qlink_sta_stats - data for QTN_TLV_ID_STA_STATS
+ *
+ * Carries statistics of a STA. Not all fields may be filled with
+ * valid values. Valid fields should be indicated as such using a bitmap of
+ * &enum qlink_sta_info. Bitmap is carried separately in a payload of
+ * QTN_TLV_ID_STA_STATS_MAP.
+ */
+struct qlink_sta_stats {
+	__le64 rx_bytes;
+	__le64 tx_bytes;
+	__le64 rx_beacon;
+	__le64 rx_duration;
+	__le64 t_offset;
+	__le32 connected_time;
+	__le32 inactive_time;
+	__le32 rx_packets;
+	__le32 tx_packets;
+	__le32 tx_retries;
+	__le32 tx_failed;
+	__le32 rx_dropped_misc;
+	__le32 beacon_loss_count;
+	__le32 expected_throughput;
+	struct qlink_sta_info_state sta_flags;
+	struct qlink_sta_info_rate txrate;
+	struct qlink_sta_info_rate rxrate;
+	__le16 llid;
+	__le16 plid;
+	u8 local_pm;
+	u8 peer_pm;
+	u8 nonpeer_pm;
+	u8 rx_beacon_signal_avg;
+	u8 plink_state;
+	u8 signal;
+	u8 signal_avg;
+	u8 rsvd[1];
+};
+
 #endif /* _QTN_QLINK_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
index 37b78f00e8e5..19981d6440b6 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -164,3 +164,15 @@ enum qlink_hidden_ssid qlink_hidden_ssid_nl2q(enum nl80211_hidden_ssid nl_val)
 		return QLINK_HIDDEN_SSID_NOT_IN_USE;
 	}
 }
+
+bool qtnf_utils_is_bit_set(const u8 *arr, unsigned int bit,
+			   unsigned int arr_max_len)
+{
+	unsigned int idx = bit / BITS_PER_BYTE;
+	u8 mask = 1 << (bit - (idx * BITS_PER_BYTE));
+
+	if (idx >= arr_max_len)
+		return false;
+
+	return arr[idx] & mask;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
index 260383d6d109..6c24561eb41f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
@@ -69,5 +69,7 @@ void qlink_chandef_q2cfg(struct wiphy *wiphy,
 void qlink_chandef_cfg2q(const struct cfg80211_chan_def *chdef,
 			 struct qlink_chandef *qch);
 enum qlink_hidden_ssid qlink_hidden_ssid_nl2q(enum nl80211_hidden_ssid nl_val);
+bool qtnf_utils_is_bit_set(const u8 *arr, unsigned int bit,
+			   unsigned int arr_max_len);
 
 #endif /* _QTN_FMAC_QLINK_UTIL_H_ */
-- 
2.11.0
