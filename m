Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0084.outbound.protection.outlook.com ([104.47.32.84]:52980
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751201AbdJEBiU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 21:38:20 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 2/8] qtnfmac: pass all AP settings to wireless card for processing
Date: Wed,  4 Oct 2017 18:38:07 -0700
Message-Id: <20171005013813.13332-3-igor.mitsyanko.os@quantenna.com> (sfid-20171005_033840_781110_96C2375F)
In-Reply-To: <20171005013813.13332-1-igor.mitsyanko.os@quantenna.com>
References: <20171005013813.13332-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Modify QLINK START_AP command payload to pass all AP settings
contained within struct cfg80211_ap_settings.
Make most of settings a constant part of "config AP" command
instead of passing it as an optional TLVs.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 52 ++++++++-------
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     | 78 ++++++++++++++++------
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    | 13 ++++
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |  1 +
 4 files changed, 101 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 88fdf7d..493c3f8 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -187,27 +187,34 @@ int qtnf_cmd_send_config_ap(struct qtnf_vif *vif,
 	struct sk_buff *cmd_skb;
 	struct cfg80211_chan_def *chandef = &vif->mac->chandef;
 	struct qlink_tlv_channel *qchan;
-	struct qlink_auth_encr aen;
+	struct qlink_cmd_config_ap *cmd;
+	struct qlink_auth_encr *aen;
 	u16 res_code = QLINK_CMD_RESULT_OK;
 	int ret;
 	int i;
 
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_CONFIG_AP,
-					    sizeof(struct qlink_cmd));
+					    sizeof(*cmd));
 	if (unlikely(!cmd_skb))
 		return -ENOMEM;
 
-	qtnf_bus_lock(vif->mac->bus);
+	cmd = (struct qlink_cmd_config_ap *)cmd_skb->data;
+	cmd->dtim_period = s->dtim_period;
+	cmd->beacon_interval = cpu_to_le16(s->beacon_interval);
+	cmd->hidden_ssid = qlink_hidden_ssid_nl2q(s->hidden_ssid);
+	cmd->inactivity_timeout = cpu_to_le16(s->inactivity_timeout);
+	cmd->smps_mode = s->smps_mode;
+	cmd->p2p_ctwindow = s->p2p_ctwindow;
+	cmd->p2p_opp_ps = s->p2p_opp_ps;
+	cmd->pbss = s->pbss;
+	cmd->ht_required = s->ht_required;
+	cmd->vht_required = s->vht_required;
 
 	if (s->ssid && s->ssid_len > 0 && s->ssid_len <= IEEE80211_MAX_SSID_LEN)
 		qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_SSID, s->ssid,
 					 s->ssid_len);
 
-	qtnf_cmd_skb_put_tlv_u16(cmd_skb, QTN_TLV_ID_BCN_PERIOD,
-				 s->beacon_interval);
-	qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_DTIM, s->dtim_period);
-
 	qchan = skb_put_zero(cmd_skb, sizeof(*qchan));
 	qchan->hdr.type = cpu_to_le16(QTN_TLV_ID_CHANNEL);
 	qchan->hdr.len = cpu_to_le16(sizeof(*qchan) -
@@ -215,26 +222,25 @@ int qtnf_cmd_send_config_ap(struct qtnf_vif *vif,
 	qchan->hw_value = cpu_to_le16(
 		ieee80211_frequency_to_channel(chandef->chan->center_freq));
 
-	memset(&aen, 0, sizeof(aen));
-	aen.auth_type = s->auth_type;
-	aen.privacy = !!s->privacy;
-	aen.mfp = 0;
-	aen.wpa_versions = cpu_to_le32(s->crypto.wpa_versions);
-	aen.cipher_group = cpu_to_le32(s->crypto.cipher_group);
-	aen.n_ciphers_pairwise = cpu_to_le32(s->crypto.n_ciphers_pairwise);
+	aen = &cmd->aen;
+	aen->auth_type = s->auth_type;
+	aen->privacy = !!s->privacy;
+	aen->mfp = 0;
+	aen->wpa_versions = cpu_to_le32(s->crypto.wpa_versions);
+	aen->cipher_group = cpu_to_le32(s->crypto.cipher_group);
+	aen->n_ciphers_pairwise = cpu_to_le32(s->crypto.n_ciphers_pairwise);
 	for (i = 0; i < QLINK_MAX_NR_CIPHER_SUITES; i++)
-		aen.ciphers_pairwise[i] =
-			cpu_to_le32(s->crypto.ciphers_pairwise[i]);
-	aen.n_akm_suites = cpu_to_le32(s->crypto.n_akm_suites);
+		aen->ciphers_pairwise[i] =
+				cpu_to_le32(s->crypto.ciphers_pairwise[i]);
+	aen->n_akm_suites = cpu_to_le32(s->crypto.n_akm_suites);
 	for (i = 0; i < QLINK_MAX_NR_AKM_SUITES; i++)
-		aen.akm_suites[i] = cpu_to_le32(s->crypto.akm_suites[i]);
-	aen.control_port = s->crypto.control_port;
-	aen.control_port_no_encrypt =s->crypto.control_port_no_encrypt;
-	aen.control_port_ethertype =
+		aen->akm_suites[i] = cpu_to_le32(s->crypto.akm_suites[i]);
+	aen->control_port = s->crypto.control_port;
+	aen->control_port_no_encrypt = s->crypto.control_port_no_encrypt;
+	aen->control_port_ethertype =
 		cpu_to_le16(be16_to_cpu(s->crypto.control_port_ethertype));
 
-	qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_CRYPTO, (u8 *)&aen,
-				 sizeof(aen));
+	qtnf_bus_lock(vif->mac->bus);
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index fb88f3e..6814254 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -132,6 +132,24 @@ struct qlink_chandef {
 	u8 rsvd[3];
 } __packed;
 
+#define QLINK_MAX_NR_CIPHER_SUITES            5
+#define QLINK_MAX_NR_AKM_SUITES               2
+
+struct qlink_auth_encr {
+	__le32 wpa_versions;
+	__le32 cipher_group;
+	__le32 n_ciphers_pairwise;
+	__le32 ciphers_pairwise[QLINK_MAX_NR_CIPHER_SUITES];
+	__le32 n_akm_suites;
+	__le32 akm_suites[QLINK_MAX_NR_AKM_SUITES];
+	__le16 control_port_ethertype;
+	u8 auth_type;
+	u8 privacy;
+	u8 mfp;
+	u8 control_port;
+	u8 control_port_no_encrypt;
+} __packed;
+
 /* QLINK Command messages related definitions
  */
 
@@ -521,6 +539,46 @@ struct qlink_cmd_chan_switch {
 	u8 beacon_count;
 } __packed;
 
+/**
+ * enum qlink_hidden_ssid - values for %NL80211_ATTR_HIDDEN_SSID
+ *
+ * Refer to &enum nl80211_hidden_ssid
+ */
+enum qlink_hidden_ssid {
+	QLINK_HIDDEN_SSID_NOT_IN_USE,
+	QLINK_HIDDEN_SSID_ZERO_LEN,
+	QLINK_HIDDEN_SSID_ZERO_CONTENTS
+};
+
+/**
+ * struct qlink_cmd_config_ap - data for QLINK_CMD_CONFIG_AP command
+ *
+ * @beacon_interval: beacon interval
+ * @inactivity_timeout: station's inactivity period in seconds
+ * @dtim_period: DTIM period
+ * @hidden_ssid: whether to hide the SSID, one of &enum qlink_hidden_ssid
+ * @smps_mode: SMPS mode
+ * @ht_required: stations must support HT
+ * @vht_required: stations must support VHT
+ * @aen: encryption info
+ * @info: variable configurations
+ */
+struct qlink_cmd_config_ap {
+	struct qlink_cmd chdr;
+	__le16 beacon_interval;
+	__le16 inactivity_timeout;
+	u8 dtim_period;
+	u8 hidden_ssid;
+	u8 smps_mode;
+	u8 p2p_ctwindow;
+	u8 p2p_opp_ps;
+	u8 pbss;
+	u8 ht_required;
+	u8 vht_required;
+	struct qlink_auth_encr aen;
+	u8 info[0];
+} __packed;
+
 /* QLINK Command Responses messages related definitions
  */
 
@@ -881,8 +939,6 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_RTS_THRESH		= 0x0202,
 	QTN_TLV_ID_SRETRY_LIMIT		= 0x0203,
 	QTN_TLV_ID_LRETRY_LIMIT		= 0x0204,
-	QTN_TLV_ID_BCN_PERIOD		= 0x0205,
-	QTN_TLV_ID_DTIM			= 0x0206,
 	QTN_TLV_ID_REG_RULE		= 0x0207,
 	QTN_TLV_ID_CHANNEL		= 0x020F,
 	QTN_TLV_ID_COVERAGE_CLASS	= 0x0213,
@@ -1072,24 +1128,6 @@ struct qlink_tlv_channel {
 	u8 rsvd[2];
 } __packed;
 
-#define QLINK_MAX_NR_CIPHER_SUITES            5
-#define QLINK_MAX_NR_AKM_SUITES               2
-
-struct qlink_auth_encr {
-	__le32 wpa_versions;
-	__le32 cipher_group;
-	__le32 n_ciphers_pairwise;
-	__le32 ciphers_pairwise[QLINK_MAX_NR_CIPHER_SUITES];
-	__le32 n_akm_suites;
-	__le32 akm_suites[QLINK_MAX_NR_AKM_SUITES];
-	__le16 control_port_ethertype;
-	u8 auth_type;
-	u8 privacy;
-	u8 mfp;
-	u8 control_port;
-	u8 control_port_no_encrypt;
-} __packed;
-
 struct qlink_chan_stats {
 	__le32 chan_num;
 	__le32 cca_tx;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
index 3c1db5b..63a74b2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -127,3 +127,16 @@ void qlink_chandef_q2cfg(struct wiphy *wiphy,
 		break;
 	}
 }
+
+enum qlink_hidden_ssid qlink_hidden_ssid_nl2q(enum nl80211_hidden_ssid nl_val)
+{
+	switch (nl_val) {
+	case NL80211_HIDDEN_SSID_ZERO_LEN:
+		return QLINK_HIDDEN_SSID_ZERO_LEN;
+	case NL80211_HIDDEN_SSID_ZERO_CONTENTS:
+		return QLINK_HIDDEN_SSID_ZERO_CONTENTS;
+	case NL80211_HIDDEN_SSID_NOT_IN_USE:
+	default:
+		return QLINK_HIDDEN_SSID_NOT_IN_USE;
+	}
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
index 5e49a8a..416f11d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
@@ -66,5 +66,6 @@ u8 qlink_chan_width_mask_to_nl(u16 qlink_mask);
 void qlink_chandef_q2cfg(struct wiphy *wiphy,
 			 const struct qlink_chandef *qch,
 			 struct cfg80211_chan_def *chdef);
+enum qlink_hidden_ssid qlink_hidden_ssid_nl2q(enum nl80211_hidden_ssid nl_val);
 
 #endif /* _QTN_FMAC_QLINK_UTIL_H_ */
-- 
2.9.5
