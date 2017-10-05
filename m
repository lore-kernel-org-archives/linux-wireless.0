Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0084.outbound.protection.outlook.com ([104.47.32.84]:52980
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751259AbdJEBiZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 21:38:25 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 7/8] qtnfmac: make encryption info a part of CONNECT command.
Date: Wed,  4 Oct 2017 18:38:12 -0700
Message-Id: <20171005013813.13332-8-igor.mitsyanko.os@quantenna.com> (sfid-20171005_033840_039931_9A5D9CC3)
In-Reply-To: <20171005013813.13332-1-igor.mitsyanko.os@quantenna.com>
References: <20171005013813.13332-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Encryption info is a constant part of STA settings, no point
to pass it as an optional TLV.
Remove QTN_TLV_ID_CRYPTO type as it's not used anymore.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 42 ++++++++++-------------
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  5 +--
 2 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index b65d705..babdc60 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2037,7 +2037,7 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 {
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_connect *cmd;
-	struct qlink_auth_encr aen;
+	struct qlink_auth_encr *aen;
 	u16 res_code = QLINK_CMD_RESULT_OK;
 	int ret;
 	int i;
@@ -2049,8 +2049,6 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 	if (unlikely(!cmd_skb))
 		return -ENOMEM;
 
-	qtnf_bus_lock(vif->mac->bus);
-
 	cmd = (struct qlink_cmd_connect *)cmd_skb->data;
 
 	ether_addr_copy(cmd->bssid, vif->bssid);
@@ -2077,41 +2075,39 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 
 	cmd->flags = cpu_to_le32(connect_flags);
 
-	memset(&aen, 0, sizeof(aen));
-	aen.auth_type = sme->auth_type;
-	aen.privacy = !!sme->privacy;
-	aen.mfp = sme->mfp;
-	aen.wpa_versions = cpu_to_le32(sme->crypto.wpa_versions);
-	aen.cipher_group = cpu_to_le32(sme->crypto.cipher_group);
-	aen.n_ciphers_pairwise = cpu_to_le32(
-		sme->crypto.n_ciphers_pairwise);
+	aen = &cmd->aen;
+	aen->auth_type = sme->auth_type;
+	aen->privacy = !!sme->privacy;
+	aen->mfp = sme->mfp;
+	aen->wpa_versions = cpu_to_le32(sme->crypto.wpa_versions);
+	aen->cipher_group = cpu_to_le32(sme->crypto.cipher_group);
+	aen->n_ciphers_pairwise = cpu_to_le32(sme->crypto.n_ciphers_pairwise);
 
 	for (i = 0; i < QLINK_MAX_NR_CIPHER_SUITES; i++)
-		aen.ciphers_pairwise[i] = cpu_to_le32(
-			sme->crypto.ciphers_pairwise[i]);
+		aen->ciphers_pairwise[i] =
+			cpu_to_le32(sme->crypto.ciphers_pairwise[i]);
 
-	aen.n_akm_suites = cpu_to_le32(sme->crypto.n_akm_suites);
+	aen->n_akm_suites = cpu_to_le32(sme->crypto.n_akm_suites);
 
 	for (i = 0; i < QLINK_MAX_NR_AKM_SUITES; i++)
-		aen.akm_suites[i] = cpu_to_le32(
-			sme->crypto.akm_suites[i]);
+		aen->akm_suites[i] = cpu_to_le32(sme->crypto.akm_suites[i]);
 
-	aen.control_port = sme->crypto.control_port;
-	aen.control_port_no_encrypt =
+	aen->control_port = sme->crypto.control_port;
+	aen->control_port_no_encrypt =
 		sme->crypto.control_port_no_encrypt;
-	aen.control_port_ethertype = cpu_to_le16(be16_to_cpu(
-		sme->crypto.control_port_ethertype));
+	aen->control_port_ethertype =
+		cpu_to_le16(be16_to_cpu(sme->crypto.control_port_ethertype));
 
 	qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_SSID, sme->ssid,
-		sme->ssid_len);
-	qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_CRYPTO, (u8 *)&aen,
-				 sizeof(aen));
+				 sme->ssid_len);
 
 	if (sme->ie_len != 0)
 		qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_IE_SET,
 					 sme->ie,
 					 sme->ie_len);
 
+	qtnf_bus_lock(vif->mac->bus);
+
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
 
 	if (unlikely(ret))
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 641d252..7b313d3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -417,8 +417,9 @@ enum qlink_sta_connect_flags {
  * struct qlink_cmd_connect - data for QLINK_CMD_CONNECT command
  *
  * @flags: for future use.
- * @freq: center frequence of a channel which should be used to connect.
+ * @channel: channel which should be used to connect.
  * @bg_scan_period: period of background scan.
+ * @aen: authentication information.
  * @bssid: BSSID of the BSS to connect to.
  * @payload: variable portion of connection request.
  */
@@ -427,6 +428,7 @@ struct qlink_cmd_connect {
 	__le32 flags;
 	__le16 channel;
 	__le16 bg_scan_period;
+	struct qlink_auth_encr aen;
 	u8 bssid[ETH_ALEN];
 	u8 payload[0];
 } __packed;
@@ -950,7 +952,6 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_STA_GENERIC_INFO	= 0x0301,
 	QTN_TLV_ID_KEY			= 0x0302,
 	QTN_TLV_ID_SEQ			= 0x0303,
-	QTN_TLV_ID_CRYPTO		= 0x0304,
 	QTN_TLV_ID_IE_SET		= 0x0305,
 };
 
-- 
2.9.5
