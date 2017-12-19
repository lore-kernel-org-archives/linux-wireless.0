Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0052.outbound.protection.outlook.com ([104.47.42.52]:40224
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965110AbdLSL3W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 06:29:22 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 02/10] qtnfmac: pass complete channel data between driver and firmware
Date: Tue, 19 Dec 2017 14:28:48 +0300
Message-Id: <20171219112856.22463-3-sergey.matyukevich.os@quantenna.com> (sfid-20171219_122928_559191_552DE69B)
In-Reply-To: <20171219112856.22463-1-sergey.matyukevich.os@quantenna.com>
References: <20171219112856.22463-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Center frequency is not enough to describe the channel in HT and VHT
modes. For 40MHz and 80MHz channels both primary channel and center
frequency should be specified in order to qualify channel completely.
This change adds primary channel info into qlink_chandef structure.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  3 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 14 +++---
 drivers/net/wireless/quantenna/qtnfmac/event.c     |  3 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     | 57 ++++++++++++++++------
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    | 48 ++++++++----------
 5 files changed, 74 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 63d274c3f2f7..b8e5f32cebdf 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -717,7 +717,8 @@ qtnf_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 	}
 
 	if (!cfg80211_chandef_valid(chandef)) {
-		pr_err("%s: bad chan freq1=%u freq2=%u bw=%u\n", ndev->name,
+		pr_err("%s: bad channel freq=%u cf1=%u cf2=%u bw=%u\n",
+		       ndev->name, chandef->chan->center_freq,
 		       chandef->center_freq1, chandef->center_freq2,
 		       chandef->width);
 		ret = -ENODATA;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 8bc8dd637315..bed81f0cb1cd 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -247,7 +247,7 @@ int qtnf_cmd_send_start_ap(struct qtnf_vif *vif,
 		chtlv->hdr.type = cpu_to_le16(QTN_TLV_ID_CHANDEF);
 		chtlv->hdr.len = cpu_to_le16(sizeof(*chtlv) -
 					     sizeof(chtlv->hdr));
-		qlink_chandef_cfg2q(&s->chandef, &chtlv->chan);
+		qlink_chandef_cfg2q(&s->chandef, &chtlv->chdef);
 	}
 
 	qtnf_cmd_tlv_ie_set_add(cmd_skb, QLINK_IE_SET_BEACON_HEAD,
@@ -1186,7 +1186,7 @@ qtnf_cmd_resp_fill_band_info(struct ieee80211_supported_band *band,
 	size_t tlv_len;
 	size_t tlv_dlen;
 	const struct qlink_tlv_hdr *tlv;
-	const struct qlink_tlv_channel *qchan;
+	const struct qlink_channel *qchan;
 	struct ieee80211_channel *chan;
 	unsigned int chidx = 0;
 	u32 qflags;
@@ -1232,7 +1232,7 @@ qtnf_cmd_resp_fill_band_info(struct ieee80211_supported_band *band,
 
 		switch (tlv_type) {
 		case QTN_TLV_ID_CHANNEL:
-			if (unlikely(tlv_len != sizeof(*qchan))) {
+			if (unlikely(tlv_dlen != sizeof(*qchan))) {
 				pr_err("invalid channel TLV len %zu\n",
 				       tlv_len);
 				goto error_ret;
@@ -1243,7 +1243,7 @@ qtnf_cmd_resp_fill_band_info(struct ieee80211_supported_band *band,
 				goto error_ret;
 			}
 
-			qchan = (const struct qlink_tlv_channel *)tlv;
+			qchan = (const struct qlink_channel *)tlv->val;
 			chan = &band->channels[chidx++];
 			qflags = le32_to_cpu(qchan->flags);
 
@@ -2037,8 +2037,8 @@ static void qtnf_cmd_channel_tlv_add(struct sk_buff *cmd_skb,
 	qchan = skb_put_zero(cmd_skb, sizeof(*qchan));
 	qchan->hdr.type = cpu_to_le16(QTN_TLV_ID_CHANNEL);
 	qchan->hdr.len = cpu_to_le16(sizeof(*qchan) - sizeof(qchan->hdr));
-	qchan->center_freq = cpu_to_le16(sc->center_freq);
-	qchan->hw_value = cpu_to_le16(sc->hw_value);
+	qchan->chan.center_freq = cpu_to_le16(sc->center_freq);
+	qchan->chan.hw_value = cpu_to_le16(sc->hw_value);
 
 	if (sc->flags & IEEE80211_CHAN_NO_IR)
 		flags |= QLINK_CHAN_NO_IR;
@@ -2046,7 +2046,7 @@ static void qtnf_cmd_channel_tlv_add(struct sk_buff *cmd_skb,
 	if (sc->flags & IEEE80211_CHAN_RADAR)
 		flags |= QLINK_CHAN_RADAR;
 
-	qchan->flags = cpu_to_le32(flags);
+	qchan->chan.flags = cpu_to_le32(flags);
 }
 
 int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index 4abc6d9ed560..a3a18d8469ae 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -369,7 +369,8 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
 	qlink_chandef_q2cfg(wiphy, &data->chan, &chandef);
 
 	if (!cfg80211_chandef_valid(&chandef)) {
-		pr_err("MAC%u: bad channel f1=%u f2=%u bw=%u\n", mac->macid,
+		pr_err("MAC%u: bad channel freq=%u cf1=%u cf2=%u bw=%u\n",
+		       mac->macid, chandef.chan->center_freq,
 		       chandef.center_freq1, chandef.center_freq2,
 		       chandef.width);
 		return -EINVAL;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index a432fb001c41..534d11e4175a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -19,7 +19,7 @@
 
 #include <linux/ieee80211.h>
 
-#define QLINK_PROTO_VER		6
+#define QLINK_PROTO_VER		7
 
 #define QLINK_MACID_RSVD		0xFF
 #define QLINK_VIFID_RSVD		0xFF
@@ -122,17 +122,49 @@ enum qlink_channel_width {
 };
 
 /**
+ * struct qlink_channel - qlink control channel definition
+ *
+ * @hw_value: hardware-specific value for the channel
+ * @center_freq: center frequency in MHz
+ * @flags: channel flags from &enum qlink_channel_flags
+ * @band: band this channel belongs to
+ * @max_antenna_gain: maximum antenna gain in dBi
+ * @max_power: maximum transmission power (in dBm)
+ * @max_reg_power: maximum regulatory transmission power (in dBm)
+ * @dfs_state: current state of this channel.
+ *      Only relevant if radar is required on this channel.
+ * @beacon_found: helper to regulatory code to indicate when a beacon
+ *	has been found on this channel. Use regulatory_hint_found_beacon()
+ *	to enable this, this is useful only on 5 GHz band.
+ */
+struct qlink_channel {
+	__le16 hw_value;
+	__le16 center_freq;
+	__le32 flags;
+	u8 band;
+	u8 max_antenna_gain;
+	u8 max_power;
+	u8 max_reg_power;
+	__le32 dfs_cac_ms;
+	u8 dfs_state;
+	u8 beacon_found;
+	u8 rsvd[2];
+} __packed;
+
+/**
  * struct qlink_chandef - qlink channel definition
  *
+ * @chan: primary channel definition
  * @center_freq1: center frequency of first segment
  * @center_freq2: center frequency of second segment (80+80 only)
  * @width: channel width, one of @enum qlink_channel_width
  */
 struct qlink_chandef {
+	struct qlink_channel chan;
 	__le16 center_freq1;
 	__le16 center_freq2;
 	u8 width;
-	u8 rsvd[3];
+	u8 rsvd;
 } __packed;
 
 #define QLINK_MAX_NR_CIPHER_SUITES            5
@@ -1113,19 +1145,16 @@ enum qlink_dfs_state {
 	QLINK_DFS_AVAILABLE,
 };
 
+/**
+ * struct qlink_tlv_channel - data for QTN_TLV_ID_CHANNEL TLV
+ *
+ * Channel settings.
+ *
+ * @channel: ieee80211 channel settings.
+ */
 struct qlink_tlv_channel {
 	struct qlink_tlv_hdr hdr;
-	__le16 hw_value;
-	__le16 center_freq;
-	__le32 flags;
-	u8 band;
-	u8 max_antenna_gain;
-	u8 max_power;
-	u8 max_reg_power;
-	__le32 dfs_cac_ms;
-	u8 dfs_state;
-	u8 beacon_found;
-	u8 rsvd[2];
+	struct qlink_channel chan;
 } __packed;
 
 /**
@@ -1137,7 +1166,7 @@ struct qlink_tlv_channel {
  */
 struct qlink_tlv_chandef {
 	struct qlink_tlv_hdr hdr;
-	struct qlink_chandef chan;
+	struct qlink_chandef chdef;
 } __packed;
 
 enum qlink_ie_set_type {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
index 61d999affb09..37b78f00e8e5 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -100,34 +100,6 @@ static enum nl80211_chan_width qlink_chanwidth_to_nl(u8 qlw)
 	}
 }
 
-void qlink_chandef_q2cfg(struct wiphy *wiphy,
-			 const struct qlink_chandef *qch,
-			 struct cfg80211_chan_def *chdef)
-{
-	chdef->center_freq1 = le16_to_cpu(qch->center_freq1);
-	chdef->center_freq2 = le16_to_cpu(qch->center_freq2);
-	chdef->width = qlink_chanwidth_to_nl(qch->width);
-
-	switch (chdef->width) {
-	case NL80211_CHAN_WIDTH_20_NOHT:
-	case NL80211_CHAN_WIDTH_20:
-	case NL80211_CHAN_WIDTH_5:
-	case NL80211_CHAN_WIDTH_10:
-		chdef->chan = ieee80211_get_channel(wiphy, chdef->center_freq1);
-		break;
-	case NL80211_CHAN_WIDTH_40:
-	case NL80211_CHAN_WIDTH_80:
-	case NL80211_CHAN_WIDTH_80P80:
-	case NL80211_CHAN_WIDTH_160:
-		chdef->chan = ieee80211_get_channel(wiphy,
-						    chdef->center_freq1 - 10);
-		break;
-	default:
-		chdef->chan = NULL;
-		break;
-	}
-}
-
 static u8 qlink_chanwidth_nl_to_qlink(enum nl80211_chan_width nlwidth)
 {
 	switch (nlwidth) {
@@ -152,9 +124,29 @@ static u8 qlink_chanwidth_nl_to_qlink(enum nl80211_chan_width nlwidth)
 	}
 }
 
+void qlink_chandef_q2cfg(struct wiphy *wiphy,
+			 const struct qlink_chandef *qch,
+			 struct cfg80211_chan_def *chdef)
+{
+	struct ieee80211_channel *chan;
+
+	chan = ieee80211_get_channel(wiphy, le16_to_cpu(qch->chan.center_freq));
+
+	chdef->chan = chan;
+	chdef->center_freq1 = le16_to_cpu(qch->center_freq1);
+	chdef->center_freq2 = le16_to_cpu(qch->center_freq2);
+	chdef->width = qlink_chanwidth_to_nl(qch->width);
+}
+
 void qlink_chandef_cfg2q(const struct cfg80211_chan_def *chdef,
 			 struct qlink_chandef *qch)
 {
+	struct ieee80211_channel *chan = chdef->chan;
+
+	qch->chan.hw_value = cpu_to_le16(chan->hw_value);
+	qch->chan.center_freq = cpu_to_le16(chan->center_freq);
+	qch->chan.flags = cpu_to_le32(chan->flags);
+
 	qch->center_freq1 = cpu_to_le16(chdef->center_freq1);
 	qch->center_freq2 = cpu_to_le16(chdef->center_freq2);
 	qch->width = qlink_chanwidth_nl_to_qlink(chdef->width);
-- 
2.11.0
