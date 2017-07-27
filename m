Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0075.outbound.protection.outlook.com ([104.47.41.75]:28032
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751593AbdG0XHd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 19:07:33 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 04/12] qtnfmac: implement cfg80211 dump_survey handler
Date: Fri, 28 Jul 2017 02:06:46 +0300
Message-Id: <20170727230654.30850-5-sergey.matyukevich.os@quantenna.com> (sfid-20170728_010738_758283_7F2ECBE4)
In-Reply-To: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
References: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements cfg80211 dump_survey handler enabling
per-channel survey data reports.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Avinash Patil <avinashp@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |  69 +++++++++++++-
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 107 ++++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.h |   2 +
 drivers/net/wireless/quantenna/qtnfmac/core.h     |   9 ++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  31 +++++++
 5 files changed, 217 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index e288b1d4432a..23f180b7d43c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -677,6 +677,72 @@ qtnf_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int
+qtnf_dump_survey(struct wiphy *wiphy, struct net_device *dev,
+		 int idx, struct survey_info *survey)
+{
+	struct qtnf_wmac *mac = wiphy_priv(wiphy);
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *chan;
+	struct qtnf_chan_stats stats;
+	int ret;
+
+	sband = wiphy->bands[NL80211_BAND_2GHZ];
+	if (sband && idx >= sband->n_channels) {
+		idx -= sband->n_channels;
+		sband = NULL;
+	}
+
+	if (!sband)
+		sband = wiphy->bands[NL80211_BAND_5GHZ];
+
+	if (!sband || idx >= sband->n_channels)
+		return -ENOENT;
+
+	chan = &sband->channels[idx];
+	memset(&stats, 0, sizeof(stats));
+
+	survey->channel = chan;
+	survey->filled = 0x0;
+
+	ret = qtnf_cmd_get_chan_stats(mac, chan->hw_value, &stats);
+	switch (ret) {
+	case 0:
+		if (unlikely(stats.chan_num != chan->hw_value)) {
+			pr_err("received stats for channel %d instead of %d\n",
+			       stats.chan_num, chan->hw_value);
+			ret = -EINVAL;
+			break;
+		}
+
+		survey->filled = SURVEY_INFO_TIME |
+				 SURVEY_INFO_TIME_SCAN |
+				 SURVEY_INFO_TIME_BUSY |
+				 SURVEY_INFO_TIME_RX |
+				 SURVEY_INFO_TIME_TX |
+				 SURVEY_INFO_NOISE_DBM;
+
+		survey->time_scan = stats.cca_try;
+		survey->time = stats.cca_try;
+		survey->time_tx = stats.cca_tx;
+		survey->time_rx = stats.cca_rx;
+		survey->time_busy = stats.cca_busy;
+		survey->noise = stats.chan_noise;
+		break;
+	case -ENOENT:
+		pr_debug("no stats for channel %u\n", chan->hw_value);
+		ret = 0;
+		break;
+	default:
+		pr_debug("failed to get chan(%d) stats from card\n",
+			 chan->hw_value);
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
 static struct cfg80211_ops qtn_cfg80211_ops = {
 	.add_virtual_intf	= qtnf_add_virtual_intf,
 	.change_virtual_intf	= qtnf_change_virtual_intf,
@@ -697,7 +763,8 @@ static struct cfg80211_ops qtn_cfg80211_ops = {
 	.set_default_mgmt_key	= qtnf_set_default_mgmt_key,
 	.scan			= qtnf_scan,
 	.connect		= qtnf_connect,
-	.disconnect		= qtnf_disconnect
+	.disconnect		= qtnf_disconnect,
+	.dump_survey		= qtnf_dump_survey
 };
 
 static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy_in,
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index f5a294f3c2a4..a1ce12082e10 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1333,6 +1333,62 @@ static int qtnf_cmd_resp_proc_phy_params(struct qtnf_wmac *mac,
 	return 0;
 }
 
+static int
+qtnf_cmd_resp_proc_chan_stat_info(struct qtnf_chan_stats *stats,
+				  const u8 *payload, size_t payload_len)
+{
+	struct qlink_chan_stats *qlink_stats;
+	const struct qlink_tlv_hdr *tlv;
+	size_t tlv_full_len;
+	u16 tlv_value_len;
+	u16 tlv_type;
+
+	tlv = (struct qlink_tlv_hdr *)payload;
+	while (payload_len >= sizeof(struct qlink_tlv_hdr)) {
+		tlv_type = le16_to_cpu(tlv->type);
+		tlv_value_len = le16_to_cpu(tlv->len);
+		tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
+		if (tlv_full_len > payload_len) {
+			pr_warn("malformed TLV 0x%.2X; LEN: %u\n",
+				tlv_type, tlv_value_len);
+			return -EINVAL;
+		}
+		switch (tlv_type) {
+		case QTN_TLV_ID_CHANNEL_STATS:
+			if (unlikely(tlv_value_len != sizeof(*qlink_stats))) {
+				pr_err("invalid CHANNEL_STATS entry size\n");
+				return -EINVAL;
+			}
+
+			qlink_stats = (void *)tlv->val;
+
+			stats->chan_num = le32_to_cpu(qlink_stats->chan_num);
+			stats->cca_tx = le32_to_cpu(qlink_stats->cca_tx);
+			stats->cca_rx = le32_to_cpu(qlink_stats->cca_rx);
+			stats->cca_busy = le32_to_cpu(qlink_stats->cca_busy);
+			stats->cca_try = le32_to_cpu(qlink_stats->cca_try);
+			stats->chan_noise = qlink_stats->chan_noise;
+
+			pr_debug("chan(%u) try(%u) busy(%u) noise(%d)\n",
+				 stats->chan_num, stats->cca_try,
+				 stats->cca_busy, stats->chan_noise);
+			break;
+		default:
+			pr_warn("Unknown TLV type: %#x\n",
+				le16_to_cpu(tlv->type));
+		}
+		payload_len -= tlv_full_len;
+		tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
+	}
+
+	if (payload_len) {
+		pr_warn("malformed TLV buf; bytes left: %zu\n", payload_len);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int qtnf_cmd_get_mac_info(struct qtnf_wmac *mac)
 {
 	struct sk_buff *cmd_skb, *resp_skb = NULL;
@@ -2176,3 +2232,54 @@ int qtnf_cmd_reg_notify(struct qtnf_bus *bus, struct regulatory_request *req)
 
 	return ret;
 }
+
+int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, u16 channel,
+			    struct qtnf_chan_stats *stats)
+{
+	struct sk_buff *cmd_skb, *resp_skb = NULL;
+	struct qlink_cmd_get_chan_stats *cmd;
+	struct qlink_resp_get_chan_stats *resp;
+	size_t var_data_len;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
+					    QLINK_CMD_CHAN_STATS,
+					    sizeof(*cmd));
+	if (!cmd_skb)
+		return -ENOMEM;
+
+	qtnf_bus_lock(mac->bus);
+
+	cmd = (struct qlink_cmd_get_chan_stats *)cmd_skb->data;
+	cmd->channel = cpu_to_le16(channel);
+
+	ret = qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb, &res_code,
+				       sizeof(*resp), &var_data_len);
+	if (unlikely(ret)) {
+		qtnf_bus_unlock(mac->bus);
+		return ret;
+	}
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		switch (res_code) {
+		case QLINK_CMD_RESULT_ENOTFOUND:
+			ret = -ENOENT;
+			break;
+		default:
+			pr_err("cmd exec failed: 0x%.4X\n", res_code);
+			ret = -EFAULT;
+			break;
+		}
+		goto out;
+	}
+
+	resp = (struct qlink_resp_get_chan_stats *)resp_skb->data;
+	ret = qtnf_cmd_resp_proc_chan_stat_info(stats, resp->info,
+						var_data_len);
+
+out:
+	qtnf_bus_unlock(mac->bus);
+	consume_skb(resp_skb);
+	return ret;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/net/wireless/quantenna/qtnfmac/commands.h
index 155b265d42bf..41e2d50988b7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -71,5 +71,7 @@ int qtnf_cmd_send_disconnect(struct qtnf_vif *vif,
 int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif,
 			      bool up);
 int qtnf_cmd_reg_notify(struct qtnf_bus *bus, struct regulatory_request *req);
+int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, u16 channel,
+			    struct qtnf_chan_stats *stats);
 
 #endif /* QLINK_COMMANDS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 31b7ec2bfd3e..b2d050c4f1e2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -124,6 +124,15 @@ struct qtnf_mac_info {
 	size_t n_limits;
 };
 
+struct qtnf_chan_stats {
+	u32 chan_num;
+	u32 cca_tx;
+	u32 cca_rx;
+	u32 cca_busy;
+	u32 cca_try;
+	s8 chan_noise;
+};
+
 struct qtnf_wmac {
 	u8 macid;
 	u8 wiphy_registered;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index e27833b78940..dd01c0b4f632 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -164,6 +164,7 @@ enum qlink_cmd_type {
 	QLINK_CMD_CHANGE_STA		= 0x0051,
 	QLINK_CMD_DEL_STA		= 0x0052,
 	QLINK_CMD_SCAN			= 0x0053,
+	QLINK_CMD_CHAN_STATS		= 0x0054,
 	QLINK_CMD_CONNECT		= 0x0060,
 	QLINK_CMD_DISCONNECT		= 0x0061,
 };
@@ -434,6 +435,16 @@ struct qlink_cmd_chans_info_get {
 } __packed;
 
 /**
+ * struct qlink_cmd_get_chan_stats - data for QLINK_CMD_CHAN_STATS command
+ *
+ * @channel: channel number according to 802.11 17.3.8.3.2 and Annex J
+ */
+struct qlink_cmd_get_chan_stats {
+	struct qlink_cmd chdr;
+	__le16 channel;
+} __packed;
+
+/**
  * enum qlink_reg_initiator - Indicates the initiator of a reg domain request
  *
  * See &enum nl80211_reg_initiator for more info.
@@ -635,6 +646,16 @@ struct qlink_resp_phy_params {
 	u8 info[0];
 } __packed;
 
+/**
+ * struct qlink_resp_get_chan_stats - response for QLINK_CMD_CHAN_STATS cmd
+ *
+ * @info: variable-length channel info.
+ */
+struct qlink_resp_get_chan_stats {
+	struct qlink_cmd rhdr;
+	u8 info[0];
+} __packed;
+
 /* QLINK Events messages related definitions
  */
 
@@ -807,6 +828,7 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_COVERAGE_CLASS	= 0x0213,
 	QTN_TLV_ID_IFACE_LIMIT		= 0x0214,
 	QTN_TLV_ID_NUM_IFACE_COMB	= 0x0215,
+	QTN_TLV_ID_CHANNEL_STATS	= 0x0216,
 	QTN_TLV_ID_STA_BASIC_COUNTERS	= 0x0300,
 	QTN_TLV_ID_STA_GENERIC_INFO	= 0x0301,
 	QTN_TLV_ID_KEY			= 0x0302,
@@ -1008,4 +1030,13 @@ struct qlink_auth_encr {
 	u8 control_port_no_encrypt;
 } __packed;
 
+struct qlink_chan_stats {
+	__le32 chan_num;
+	__le32 cca_tx;
+	__le32 cca_rx;
+	__le32 cca_busy;
+	__le32 cca_try;
+	s8 chan_noise;
+} __packed;
+
 #endif /* _QTN_QLINK_H_ */
-- 
2.11.0
