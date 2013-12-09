Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40210 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761659Ab3LIV75 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 16:59:57 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2] mac80211: add helper functions for tracking P2P NoA state
Date: Mon,  9 Dec 2013 22:59:48 +0100
Message-Id: <1386626388-45880-1-git-send-email-nbd@openwrt.org> (sfid-20131209_230008_147863_5FE1F969)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h |  45 +++++++++++++++++
 net/mac80211/util.c    | 135 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 180 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3cd408b..e698d5d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4625,4 +4625,49 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif, struct sk_buff *skb,
 			      int band, struct ieee80211_sta **sta);
 
+/**
+ * struct ieee80211_noa_data - holds temporary data for tracking P2P NoA state
+ *
+ * @next_tsf: TSF timestamp of the next absent state change
+ * @has_next_tsf: next absent state change event pending
+ *
+ * @absent: descriptor bitmask, set if GO is currently absent
+ *
+ * private:
+ *
+ * @count: count fields from the NoA descriptors
+ * @desc: adjusted data from the NoA
+ */
+struct ieee80211_noa_data {
+	u32 next_tsf;
+	bool has_next_tsf;
+
+	u8 absent;
+
+	u8 count[IEEE80211_P2P_NOA_DESC_MAX];
+	struct {
+		u32 start;
+		u32 duration;
+		u32 interval;
+	} desc[IEEE80211_P2P_NOA_DESC_MAX];
+};
+
+/**
+ * ieee80211_parse_p2p_noa - initialize NoA tracking data from P2P IE
+ *
+ * @attr: P2P NoA IE
+ * @data: NoA tracking data
+ * @tsf: current TSF timestamp
+ */
+int ieee80211_parse_p2p_noa(const struct ieee80211_p2p_noa_attr *attr,
+			    struct ieee80211_noa_data *data, u32 tsf);
+
+/**
+ * ieee80211_update_p2p_noa - get next pending P2P GO absent state change
+ *
+ * @data: NoA tracking data
+ * @tsf: current TSF timestamp
+ */
+void ieee80211_update_p2p_noa(struct ieee80211_noa_data *data, u32 tsf);
+
 #endif /* MAC80211_H */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 875e172..b7a8326 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2554,3 +2554,138 @@ int ieee80211_cs_headroom(struct ieee80211_local *local,
 
 	return headroom;
 }
+
+static bool
+ieee80211_extend_noa_desc(struct ieee80211_noa_data *data, u32 tsf, int i)
+{
+	s32 end = data->desc[i].start + data->desc[i].duration - (tsf + 1);
+	int skip;
+
+	if (end > 0)
+		return false;
+
+	/* End time is in the past, check for repetitions */
+	skip = DIV_ROUND_UP(-end, data->desc[i].interval);
+	if (data->count[i] < 255) {
+		if (data->count[i] <= skip) {
+			data->count[i] = 0;
+			return false;
+		}
+
+		data->count[i] -= skip;
+	}
+
+	data->desc[i].start += skip * data->desc[i].interval;
+
+	return true;
+}
+
+static bool
+ieee80211_extend_absent_time(struct ieee80211_noa_data *data, u32 tsf,
+			     s32 *offset)
+{
+	bool ret = false;
+	int i;
+
+	for (i = 0; i < IEEE80211_P2P_NOA_DESC_MAX; i++) {
+		s32 cur;
+
+		if (!data->count[i])
+			continue;
+
+		if (ieee80211_extend_noa_desc(data, tsf + *offset, i))
+			ret = true;
+
+		cur = data->desc[i].start - tsf;
+		if (cur > *offset)
+			continue;
+
+		cur = data->desc[i].start + data->desc[i].duration - tsf;
+		if (cur > *offset)
+			*offset = cur;
+	}
+
+	return ret;
+}
+
+static u32
+ieee80211_get_noa_absent_time(struct ieee80211_noa_data *data, u32 tsf)
+{
+	s32 offset = 0;
+	int tries = 0;
+
+	ieee80211_extend_absent_time(data, tsf, &offset);
+	do {
+		if (!ieee80211_extend_absent_time(data, tsf, &offset))
+			break;
+
+		tries++;
+	} while (tries < 5);
+
+	return offset;
+}
+
+void ieee80211_update_p2p_noa(struct ieee80211_noa_data *data, u32 tsf)
+{
+	u32 next_offset = BIT(31) - 1;
+	int i;
+
+	data->absent = 0;
+	data->has_next_tsf = false;
+	for (i = 0; i < IEEE80211_P2P_NOA_DESC_MAX; i++) {
+		s32 start;
+
+		if (!data->count[i])
+			continue;
+
+		ieee80211_extend_noa_desc(data, tsf, i);
+		start = data->desc[i].start - tsf;
+		if (start <= 0)
+			data->absent |= BIT(i);
+
+		if (next_offset > start)
+			next_offset = start;
+
+		data->has_next_tsf = true;
+	}
+
+	if (data->absent)
+		next_offset = ieee80211_get_noa_absent_time(data, tsf);
+
+	data->next_tsf = tsf + next_offset;
+}
+EXPORT_SYMBOL(ieee80211_update_p2p_noa);
+
+int ieee80211_parse_p2p_noa(const struct ieee80211_p2p_noa_attr *attr,
+			    struct ieee80211_noa_data *data, u32 tsf)
+{
+	int ret = 0;
+	int i;
+
+	memset(data, 0, sizeof(*data));
+
+	for (i = 0; i < IEEE80211_P2P_NOA_DESC_MAX; i++) {
+		const struct ieee80211_p2p_noa_desc *desc = &attr->desc[i];
+
+		if (!desc->count || !desc->duration)
+			continue;
+
+		data->count[i] = desc->count;
+		data->desc[i].start = le32_to_cpu(desc->start_time);
+		data->desc[i].duration = le32_to_cpu(desc->duration);
+		data->desc[i].interval = le32_to_cpu(desc->interval);
+
+		if (data->count[i] > 1 &&
+		    data->desc[i].interval < data->desc[i].duration)
+			continue;
+
+		ieee80211_extend_noa_desc(data, tsf, i);
+		ret++;
+	}
+
+	if (ret)
+		ieee80211_update_p2p_noa(data, tsf);
+
+	return ret;
+}
+EXPORT_SYMBOL(ieee80211_parse_p2p_noa);
-- 
1.8.3.4 (Apple Git-47)

