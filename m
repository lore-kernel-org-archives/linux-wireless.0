Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:61440
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754450AbdHYCaw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:30:52 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 06/27] qtnfmac: pass full channel definition to device on start_ap command
Date: Thu, 24 Aug 2017 19:30:03 -0700
Message-Id: <20170825023024.10565-7-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043149_379092_275F1695)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Introduce chandef TLV and pass it to wireless card on start_ap
command processing.
No need to cache chandef in driver private structure as it is
not used anywhere.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  9 ------
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 27 +++++++++---------
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     | 13 +++++++++
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    | 32 ++++++++++++++++++++++
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |  2 ++
 5 files changed, 61 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index f6eb681..858c24f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -266,17 +266,8 @@ static int qtnf_start_ap(struct wiphy *wiphy, struct net_device *dev,
 			 struct cfg80211_ap_settings *settings)
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
-	struct qtnf_wmac *mac = wiphy_priv(wiphy);
 	int ret;
 
-	if (!cfg80211_chandef_identical(&mac->chandef, &settings->chandef)) {
-		memcpy(&mac->chandef, &settings->chandef, sizeof(mac->chandef));
-		if (vif->vifid != 0)
-			pr_warn("%s: unexpected chan %u (%u MHz)\n", dev->name,
-				settings->chandef.chan->hw_value,
-				settings->chandef.chan->center_freq);
-	}
-
 	ret = qtnf_cmd_send_config_ap(vif, settings);
 	if (ret) {
 		pr_err("VIF%u.%u: failed to push config to FW\n",
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index cddbb5d..7b24d37 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -185,8 +185,6 @@ int qtnf_cmd_send_config_ap(struct qtnf_vif *vif,
 			    const struct cfg80211_ap_settings *s)
 {
 	struct sk_buff *cmd_skb;
-	struct cfg80211_chan_def *chandef = &vif->mac->chandef;
-	struct qlink_tlv_channel *qchan;
 	struct qlink_cmd_config_ap *cmd;
 	struct qlink_auth_encr *aen;
 	u16 res_code = QLINK_CMD_RESULT_OK;
@@ -211,17 +209,6 @@ int qtnf_cmd_send_config_ap(struct qtnf_vif *vif,
 	cmd->ht_required = s->ht_required;
 	cmd->vht_required = s->vht_required;
 
-	if (s->ssid && s->ssid_len > 0 && s->ssid_len <= IEEE80211_MAX_SSID_LEN)
-		qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_SSID, s->ssid,
-					 s->ssid_len);
-
-	qchan = skb_put_zero(cmd_skb, sizeof(*qchan));
-	qchan->hdr.type = cpu_to_le16(QTN_TLV_ID_CHANNEL);
-	qchan->hdr.len = cpu_to_le16(sizeof(*qchan) -
-			sizeof(struct qlink_tlv_hdr));
-	qchan->hw_value = cpu_to_le16(
-		ieee80211_frequency_to_channel(chandef->chan->center_freq));
-
 	aen = &cmd->aen;
 	aen->auth_type = s->auth_type;
 	aen->privacy = !!s->privacy;
@@ -240,6 +227,20 @@ int qtnf_cmd_send_config_ap(struct qtnf_vif *vif,
 	aen->control_port_ethertype =
 		cpu_to_le16(be16_to_cpu(s->crypto.control_port_ethertype));
 
+	if (s->ssid && s->ssid_len > 0 && s->ssid_len <= IEEE80211_MAX_SSID_LEN)
+		qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_SSID, s->ssid,
+					 s->ssid_len);
+
+	if (cfg80211_chandef_valid(&s->chandef)) {
+		struct qlink_tlv_chandef *chtlv =
+			(struct qlink_tlv_chandef *)skb_put(cmd_skb,
+							    sizeof(*chtlv));
+
+		chtlv->hdr.type = cpu_to_le16(QTN_TLV_ID_CHANDEF);
+		chtlv->hdr.len = sizeof(*chtlv) - sizeof(chtlv->hdr);
+		qlink_chandef_cfg2q(&s->chandef, &chtlv->chan);
+	}
+
 	qtnf_bus_lock(vif->mac->bus);
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 6814254..641d252 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -941,6 +941,7 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_LRETRY_LIMIT		= 0x0204,
 	QTN_TLV_ID_REG_RULE		= 0x0207,
 	QTN_TLV_ID_CHANNEL		= 0x020F,
+	QTN_TLV_ID_CHANDEF		= 0x0210,
 	QTN_TLV_ID_COVERAGE_CLASS	= 0x0213,
 	QTN_TLV_ID_IFACE_LIMIT		= 0x0214,
 	QTN_TLV_ID_NUM_IFACE_COMB	= 0x0215,
@@ -1128,6 +1129,18 @@ struct qlink_tlv_channel {
 	u8 rsvd[2];
 } __packed;
 
+/**
+ * struct qlink_tlv_chandef - data for QTN_TLV_ID_CHANDEF TLV
+ *
+ * Channel definition.
+ *
+ * @chan: channel definition data.
+ */
+struct qlink_tlv_chandef {
+	struct qlink_tlv_hdr hdr;
+	struct qlink_chandef chan;
+} __packed;
+
 struct qlink_chan_stats {
 	__le32 chan_num;
 	__le32 cca_tx;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
index 63a74b2..61d999a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -128,6 +128,38 @@ void qlink_chandef_q2cfg(struct wiphy *wiphy,
 	}
 }
 
+static u8 qlink_chanwidth_nl_to_qlink(enum nl80211_chan_width nlwidth)
+{
+	switch (nlwidth) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		return QLINK_CHAN_WIDTH_20_NOHT;
+	case NL80211_CHAN_WIDTH_20:
+		return QLINK_CHAN_WIDTH_20;
+	case NL80211_CHAN_WIDTH_40:
+		return QLINK_CHAN_WIDTH_40;
+	case NL80211_CHAN_WIDTH_80:
+		return QLINK_CHAN_WIDTH_80;
+	case NL80211_CHAN_WIDTH_80P80:
+		return QLINK_CHAN_WIDTH_80P80;
+	case NL80211_CHAN_WIDTH_160:
+		return QLINK_CHAN_WIDTH_160;
+	case NL80211_CHAN_WIDTH_5:
+		return QLINK_CHAN_WIDTH_5;
+	case NL80211_CHAN_WIDTH_10:
+		return QLINK_CHAN_WIDTH_10;
+	default:
+		return -1;
+	}
+}
+
+void qlink_chandef_cfg2q(const struct cfg80211_chan_def *chdef,
+			 struct qlink_chandef *qch)
+{
+	qch->center_freq1 = cpu_to_le16(chdef->center_freq1);
+	qch->center_freq2 = cpu_to_le16(chdef->center_freq2);
+	qch->width = qlink_chanwidth_nl_to_qlink(chdef->width);
+}
+
 enum qlink_hidden_ssid qlink_hidden_ssid_nl2q(enum nl80211_hidden_ssid nl_val)
 {
 	switch (nl_val) {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
index 416f11d..260383d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
@@ -66,6 +66,8 @@ u8 qlink_chan_width_mask_to_nl(u16 qlink_mask);
 void qlink_chandef_q2cfg(struct wiphy *wiphy,
 			 const struct qlink_chandef *qch,
 			 struct cfg80211_chan_def *chdef);
+void qlink_chandef_cfg2q(const struct cfg80211_chan_def *chdef,
+			 struct qlink_chandef *qch);
 enum qlink_hidden_ssid qlink_hidden_ssid_nl2q(enum nl80211_hidden_ssid nl_val);
 
 #endif /* _QTN_FMAC_QLINK_UTIL_H_ */
-- 
2.9.5
