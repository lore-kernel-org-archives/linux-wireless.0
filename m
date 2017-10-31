Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0048.outbound.protection.outlook.com ([104.47.42.48]:45504
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752905AbdJaBFN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 21:05:13 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, vulyanov@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 9/9] qtnfmac: pass all CONNECT cmd params to wireless card for processing
Date: Mon, 30 Oct 2017 18:04:55 -0700
Message-Id: <20171031010455.27772-10-igor.mitsyanko.os@quantenna.com> (sfid-20171031_020523_173323_46DE12A6)
In-Reply-To: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
References: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Specifically, following parameters are needed for wireless device
configuration but were not available to it before:
- HT/VHT capabilities and capabilities masks.
- full channel info (not just IEEE number)
- BSSID hint
- previous BSSID for reassoc request

Move Management Frame Protection setting from common encr info
structure into STA-specific .connect command parameters.

Make sure that all new qlink structure definitions are alignment-safe.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 63 +++++++++++++++--------
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 32 +++++++++---
 2 files changed, 65 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index c2f0b75..8bc8dd6 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -221,7 +221,6 @@ int qtnf_cmd_send_start_ap(struct qtnf_vif *vif,
 	aen = &cmd->aen;
 	aen->auth_type = s->auth_type;
 	aen->privacy = !!s->privacy;
-	aen->mfp = 0;
 	aen->wpa_versions = cpu_to_le32(s->crypto.wpa_versions);
 	aen->cipher_group = cpu_to_le32(s->crypto.cipher_group);
 	aen->n_ciphers_pairwise = cpu_to_le32(s->crypto.n_ciphers_pairwise);
@@ -2029,17 +2028,36 @@ int qtnf_cmd_send_del_sta(struct qtnf_vif *vif,
 	return ret;
 }
 
+static void qtnf_cmd_channel_tlv_add(struct sk_buff *cmd_skb,
+				     const struct ieee80211_channel *sc)
+{
+	struct qlink_tlv_channel *qchan;
+	u32 flags = 0;
+
+	qchan = skb_put_zero(cmd_skb, sizeof(*qchan));
+	qchan->hdr.type = cpu_to_le16(QTN_TLV_ID_CHANNEL);
+	qchan->hdr.len = cpu_to_le16(sizeof(*qchan) - sizeof(qchan->hdr));
+	qchan->center_freq = cpu_to_le16(sc->center_freq);
+	qchan->hw_value = cpu_to_le16(sc->hw_value);
+
+	if (sc->flags & IEEE80211_CHAN_NO_IR)
+		flags |= QLINK_CHAN_NO_IR;
+
+	if (sc->flags & IEEE80211_CHAN_RADAR)
+		flags |= QLINK_CHAN_RADAR;
+
+	qchan->flags = cpu_to_le32(flags);
+}
+
 int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 {
 	struct sk_buff *cmd_skb;
 	u16 res_code = QLINK_CMD_RESULT_OK;
 	struct ieee80211_channel *sc;
 	struct cfg80211_scan_request *scan_req = mac->scan_req;
-	struct qlink_tlv_channel *qchan;
 	int n_channels;
 	int count = 0;
 	int ret;
-	u32 flags;
 
 	if (scan_req->n_ssids > QTNF_MAX_SSID_LIST_LENGTH) {
 		pr_err("MAC%u: too many SSIDs in scan request\n", mac->macid);
@@ -2081,22 +2099,8 @@ int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 			pr_debug("MAC%u: scan chan=%d, freq=%d, flags=%#x\n",
 				 mac->macid, sc->hw_value, sc->center_freq,
 				 sc->flags);
-			qchan = skb_put_zero(cmd_skb, sizeof(*qchan));
-			flags = 0;
-
-			qchan->hdr.type = cpu_to_le16(QTN_TLV_ID_CHANNEL);
-			qchan->hdr.len = cpu_to_le16(sizeof(*qchan) -
-					sizeof(struct qlink_tlv_hdr));
-			qchan->center_freq = cpu_to_le16(sc->center_freq);
-			qchan->hw_value = cpu_to_le16(sc->hw_value);
-
-			if (sc->flags & IEEE80211_CHAN_NO_IR)
-				flags |= QLINK_CHAN_NO_IR;
 
-			if (sc->flags & IEEE80211_CHAN_RADAR)
-				flags |= QLINK_CHAN_RADAR;
-
-			qchan->flags = cpu_to_le32(flags);
+			qtnf_cmd_channel_tlv_add(cmd_skb, sc);
 			n_channels--;
 			count++;
 		}
@@ -2140,10 +2144,15 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 
 	ether_addr_copy(cmd->bssid, vif->bssid);
 
-	if (sme->channel)
-		cmd->channel = cpu_to_le16(sme->channel->hw_value);
+	if (sme->bssid_hint)
+		ether_addr_copy(cmd->bssid_hint, sme->bssid_hint);
 	else
-		cmd->channel = 0;
+		eth_zero_addr(cmd->bssid_hint);
+
+	if (sme->prev_bssid)
+		ether_addr_copy(cmd->prev_bssid, sme->prev_bssid);
+	else
+		eth_zero_addr(cmd->prev_bssid);
 
 	if ((sme->bg_scan_period > 0) &&
 	    (sme->bg_scan_period <= QTNF_MAX_BG_SCAN_PERIOD))
@@ -2161,11 +2170,18 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 		connect_flags |= QLINK_STA_CONNECT_USE_RRM;
 
 	cmd->flags = cpu_to_le32(connect_flags);
+	memcpy(&cmd->ht_capa, &sme->ht_capa, sizeof(cmd->ht_capa));
+	memcpy(&cmd->ht_capa_mask, &sme->ht_capa_mask,
+	       sizeof(cmd->ht_capa_mask));
+	memcpy(&cmd->vht_capa, &sme->vht_capa, sizeof(cmd->vht_capa));
+	memcpy(&cmd->vht_capa_mask, &sme->vht_capa_mask,
+	       sizeof(cmd->vht_capa_mask));
+	cmd->pbss = sme->pbss;
 
 	aen = &cmd->aen;
 	aen->auth_type = sme->auth_type;
 	aen->privacy = !!sme->privacy;
-	aen->mfp = sme->mfp;
+	cmd->mfp = sme->mfp;
 	aen->wpa_versions = cpu_to_le32(sme->crypto.wpa_versions);
 	aen->cipher_group = cpu_to_le32(sme->crypto.cipher_group);
 	aen->n_ciphers_pairwise = cpu_to_le32(sme->crypto.n_ciphers_pairwise);
@@ -2192,6 +2208,9 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 		qtnf_cmd_tlv_ie_set_add(cmd_skb, QLINK_IE_SET_ASSOC_REQ,
 					sme->ie, sme->ie_len);
 
+	if (sme->channel)
+		qtnf_cmd_channel_tlv_add(cmd_skb, sme->channel);
+
 	qtnf_bus_lock(vif->mac->bus);
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index e07f776..a432fb0 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -19,7 +19,7 @@
 
 #include <linux/ieee80211.h>
 
-#define QLINK_PROTO_VER		5
+#define QLINK_PROTO_VER		6
 
 #define QLINK_MACID_RSVD		0xFF
 #define QLINK_VIFID_RSVD		0xFF
@@ -148,9 +148,9 @@ struct qlink_auth_encr {
 	__le16 control_port_ethertype;
 	u8 auth_type;
 	u8 privacy;
-	u8 mfp;
 	u8 control_port;
 	u8 control_port_no_encrypt;
+	u8 rsvd[2];
 } __packed;
 
 /* QLINK Command messages related definitions
@@ -404,20 +404,36 @@ enum qlink_sta_connect_flags {
 /**
  * struct qlink_cmd_connect - data for QLINK_CMD_CONNECT command
  *
- * @flags: for future use.
- * @channel: channel which should be used to connect.
+ * @bssid: BSSID of the BSS to connect to.
+ * @bssid_hint: recommended AP BSSID for initial connection to the BSS or
+ *	00:00:00:00:00:00 if not specified.
+ * @prev_bssid: previous BSSID, if specified (not 00:00:00:00:00:00) indicates
+ *	a request to reassociate.
  * @bg_scan_period: period of background scan.
+ * @flags: one of &enum qlink_sta_connect_flags.
+ * @ht_capa: HT Capabilities overrides.
+ * @ht_capa_mask: The bits of ht_capa which are to be used.
+ * @vht_capa: VHT Capability overrides
+ * @vht_capa_mask: The bits of vht_capa which are to be used.
  * @aen: authentication information.
- * @bssid: BSSID of the BSS to connect to.
+ * @mfp: whether to use management frame protection.
  * @payload: variable portion of connection request.
  */
 struct qlink_cmd_connect {
 	struct qlink_cmd chdr;
-	__le32 flags;
-	__le16 channel;
+	u8 bssid[ETH_ALEN];
+	u8 bssid_hint[ETH_ALEN];
+	u8 prev_bssid[ETH_ALEN];
 	__le16 bg_scan_period;
+	__le32 flags;
+	struct ieee80211_ht_cap ht_capa;
+	struct ieee80211_ht_cap ht_capa_mask;
+	struct ieee80211_vht_cap vht_capa;
+	struct ieee80211_vht_cap vht_capa_mask;
 	struct qlink_auth_encr aen;
-	u8 bssid[ETH_ALEN];
+	u8 mfp;
+	u8 pbss;
+	u8 rsvd[2];
 	u8 payload[0];
 } __packed;
 
-- 
2.9.5
