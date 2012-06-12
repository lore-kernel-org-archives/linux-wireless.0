Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:54406 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753070Ab2FLWLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 18:11:24 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/4 RESEND] mwifiex: separate uAP WPA/WPA2 parsing from other BSS parameters
Date: Tue, 12 Jun 2012 15:02:27 -0700
Message-Id: <1339538547-14558-4-git-send-email-bzhao@marvell.com> (sfid-20120613_001126_617748_EE0213CE)
In-Reply-To: <1339538547-14558-1-git-send-email-bzhao@marvell.com>
References: <1339538547-14558-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

To enhance readability, create a separate function for parsing
WPA/WPA2 related parameters from cfg80211_ap_settings.
There is no functional change in this patch.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_cmd.c |  145 +++++++++++++++++---------------
 1 files changed, 78 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index f13982d..4b39551 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -171,6 +171,82 @@ void mwifiex_set_sys_config_invalid_data(struct mwifiex_uap_bss_param *config)
 }
 
 /* This function parses BSS related parameters from structure
+ * and prepares TLVs specific to WPA/WPA2 security.
+ * These TLVs are appended to command buffer.
+ */
+static void
+mwifiex_uap_bss_wpa(u8 **tlv_buf, void *cmd_buf, u16 *param_size)
+{
+	struct host_cmd_tlv_pwk_cipher *pwk_cipher;
+	struct host_cmd_tlv_gwk_cipher *gwk_cipher;
+	struct host_cmd_tlv_passphrase *passphrase;
+	struct host_cmd_tlv_akmp *tlv_akmp;
+	struct mwifiex_uap_bss_param *bss_cfg = cmd_buf;
+	u16 cmd_size = *param_size;
+	u8 *tlv = *tlv_buf;
+
+	tlv_akmp = (struct host_cmd_tlv_akmp *)tlv;
+	tlv_akmp->tlv.type = cpu_to_le16(TLV_TYPE_UAP_AKMP);
+	tlv_akmp->tlv.len = cpu_to_le16(sizeof(struct host_cmd_tlv_akmp) -
+					sizeof(struct host_cmd_tlv));
+	tlv_akmp->key_mgmt_operation = cpu_to_le16(bss_cfg->key_mgmt_operation);
+	tlv_akmp->key_mgmt = cpu_to_le16(bss_cfg->key_mgmt);
+	cmd_size += sizeof(struct host_cmd_tlv_akmp);
+	tlv += sizeof(struct host_cmd_tlv_akmp);
+
+	if (bss_cfg->wpa_cfg.pairwise_cipher_wpa & VALID_CIPHER_BITMAP) {
+		pwk_cipher = (struct host_cmd_tlv_pwk_cipher *)tlv;
+		pwk_cipher->tlv.type = cpu_to_le16(TLV_TYPE_PWK_CIPHER);
+		pwk_cipher->tlv.len =
+			cpu_to_le16(sizeof(struct host_cmd_tlv_pwk_cipher) -
+				    sizeof(struct host_cmd_tlv));
+		pwk_cipher->proto = cpu_to_le16(PROTOCOL_WPA);
+		pwk_cipher->cipher = bss_cfg->wpa_cfg.pairwise_cipher_wpa;
+		cmd_size += sizeof(struct host_cmd_tlv_pwk_cipher);
+		tlv += sizeof(struct host_cmd_tlv_pwk_cipher);
+	}
+
+	if (bss_cfg->wpa_cfg.pairwise_cipher_wpa2 & VALID_CIPHER_BITMAP) {
+		pwk_cipher = (struct host_cmd_tlv_pwk_cipher *)tlv;
+		pwk_cipher->tlv.type = cpu_to_le16(TLV_TYPE_PWK_CIPHER);
+		pwk_cipher->tlv.len =
+			cpu_to_le16(sizeof(struct host_cmd_tlv_pwk_cipher) -
+				    sizeof(struct host_cmd_tlv));
+		pwk_cipher->proto = cpu_to_le16(PROTOCOL_WPA2);
+		pwk_cipher->cipher = bss_cfg->wpa_cfg.pairwise_cipher_wpa2;
+		cmd_size += sizeof(struct host_cmd_tlv_pwk_cipher);
+		tlv += sizeof(struct host_cmd_tlv_pwk_cipher);
+	}
+
+	if (bss_cfg->wpa_cfg.group_cipher & VALID_CIPHER_BITMAP) {
+		gwk_cipher = (struct host_cmd_tlv_gwk_cipher *)tlv;
+		gwk_cipher->tlv.type = cpu_to_le16(TLV_TYPE_GWK_CIPHER);
+		gwk_cipher->tlv.len =
+			cpu_to_le16(sizeof(struct host_cmd_tlv_gwk_cipher) -
+				    sizeof(struct host_cmd_tlv));
+		gwk_cipher->cipher = bss_cfg->wpa_cfg.group_cipher;
+		cmd_size += sizeof(struct host_cmd_tlv_gwk_cipher);
+		tlv += sizeof(struct host_cmd_tlv_gwk_cipher);
+	}
+
+	if (bss_cfg->wpa_cfg.length) {
+		passphrase = (struct host_cmd_tlv_passphrase *)tlv;
+		passphrase->tlv.type = cpu_to_le16(TLV_TYPE_UAP_WPA_PASSPHRASE);
+		passphrase->tlv.len = cpu_to_le16(bss_cfg->wpa_cfg.length);
+		memcpy(passphrase->passphrase, bss_cfg->wpa_cfg.passphrase,
+		       bss_cfg->wpa_cfg.length);
+		cmd_size += sizeof(struct host_cmd_tlv) +
+			    bss_cfg->wpa_cfg.length;
+		tlv += sizeof(struct host_cmd_tlv) + bss_cfg->wpa_cfg.length;
+	}
+
+	*param_size = cmd_size;
+	*tlv_buf = tlv;
+
+	return;
+}
+
+/* This function parses BSS related parameters from structure
  * and prepares TLVs. These TLVs are appended to command buffer.
 */
 static int
@@ -184,12 +260,8 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	struct host_cmd_tlv_frag_threshold *frag_threshold;
 	struct host_cmd_tlv_rts_threshold *rts_threshold;
 	struct host_cmd_tlv_retry_limit *retry_limit;
-	struct host_cmd_tlv_pwk_cipher *pwk_cipher;
-	struct host_cmd_tlv_gwk_cipher *gwk_cipher;
 	struct host_cmd_tlv_encrypt_protocol *encrypt_protocol;
 	struct host_cmd_tlv_auth_type *auth_type;
-	struct host_cmd_tlv_passphrase *passphrase;
-	struct host_cmd_tlv_akmp *tlv_akmp;
 	struct mwifiex_ie_types_htcap *htcap;
 	struct mwifiex_uap_bss_param *bss_cfg = cmd_buf;
 	u16 cmd_size = *param_size;
@@ -280,70 +352,9 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	}
 	if ((bss_cfg->protocol & PROTOCOL_WPA) ||
 	    (bss_cfg->protocol & PROTOCOL_WPA2) ||
-	    (bss_cfg->protocol & PROTOCOL_EAP)) {
-		tlv_akmp = (struct host_cmd_tlv_akmp *)tlv;
-		tlv_akmp->tlv.type = cpu_to_le16(TLV_TYPE_UAP_AKMP);
-		tlv_akmp->tlv.len =
-		    cpu_to_le16(sizeof(struct host_cmd_tlv_akmp) -
-				sizeof(struct host_cmd_tlv));
-		tlv_akmp->key_mgmt_operation =
-			cpu_to_le16(bss_cfg->key_mgmt_operation);
-		tlv_akmp->key_mgmt = cpu_to_le16(bss_cfg->key_mgmt);
-		cmd_size += sizeof(struct host_cmd_tlv_akmp);
-		tlv += sizeof(struct host_cmd_tlv_akmp);
-
-		if (bss_cfg->wpa_cfg.pairwise_cipher_wpa &
-				VALID_CIPHER_BITMAP) {
-			pwk_cipher = (struct host_cmd_tlv_pwk_cipher *)tlv;
-			pwk_cipher->tlv.type =
-				cpu_to_le16(TLV_TYPE_PWK_CIPHER);
-			pwk_cipher->tlv.len = cpu_to_le16(
-				sizeof(struct host_cmd_tlv_pwk_cipher) -
-				sizeof(struct host_cmd_tlv));
-			pwk_cipher->proto = cpu_to_le16(PROTOCOL_WPA);
-			pwk_cipher->cipher =
-				bss_cfg->wpa_cfg.pairwise_cipher_wpa;
-			cmd_size += sizeof(struct host_cmd_tlv_pwk_cipher);
-			tlv += sizeof(struct host_cmd_tlv_pwk_cipher);
-		}
-		if (bss_cfg->wpa_cfg.pairwise_cipher_wpa2 &
-				VALID_CIPHER_BITMAP) {
-			pwk_cipher = (struct host_cmd_tlv_pwk_cipher *)tlv;
-			pwk_cipher->tlv.type = cpu_to_le16(TLV_TYPE_PWK_CIPHER);
-			pwk_cipher->tlv.len = cpu_to_le16(
-				sizeof(struct host_cmd_tlv_pwk_cipher) -
-				sizeof(struct host_cmd_tlv));
-			pwk_cipher->proto = cpu_to_le16(PROTOCOL_WPA2);
-			pwk_cipher->cipher =
-				bss_cfg->wpa_cfg.pairwise_cipher_wpa2;
-			cmd_size += sizeof(struct host_cmd_tlv_pwk_cipher);
-			tlv += sizeof(struct host_cmd_tlv_pwk_cipher);
-		}
-		if (bss_cfg->wpa_cfg.group_cipher & VALID_CIPHER_BITMAP) {
-			gwk_cipher = (struct host_cmd_tlv_gwk_cipher *)tlv;
-			gwk_cipher->tlv.type = cpu_to_le16(TLV_TYPE_GWK_CIPHER);
-			gwk_cipher->tlv.len = cpu_to_le16(
-				sizeof(struct host_cmd_tlv_gwk_cipher) -
-				sizeof(struct host_cmd_tlv));
-			gwk_cipher->cipher = bss_cfg->wpa_cfg.group_cipher;
-			cmd_size += sizeof(struct host_cmd_tlv_gwk_cipher);
-			tlv += sizeof(struct host_cmd_tlv_gwk_cipher);
-		}
-		if (bss_cfg->wpa_cfg.length) {
-			passphrase = (struct host_cmd_tlv_passphrase *)tlv;
-			passphrase->tlv.type =
-				cpu_to_le16(TLV_TYPE_UAP_WPA_PASSPHRASE);
-			passphrase->tlv.len =
-				cpu_to_le16(bss_cfg->wpa_cfg.length);
-			memcpy(passphrase->passphrase,
-			       bss_cfg->wpa_cfg.passphrase,
-			       bss_cfg->wpa_cfg.length);
-			cmd_size += sizeof(struct host_cmd_tlv) +
-				    bss_cfg->wpa_cfg.length;
-			tlv += sizeof(struct host_cmd_tlv) +
-			       bss_cfg->wpa_cfg.length;
-		}
-	}
+	    (bss_cfg->protocol & PROTOCOL_EAP))
+		mwifiex_uap_bss_wpa(&tlv, cmd_buf, &cmd_size);
+
 	if ((bss_cfg->auth_mode <= WLAN_AUTH_SHARED_KEY) ||
 	    (bss_cfg->auth_mode == MWIFIEX_AUTH_MODE_AUTO)) {
 		auth_type = (struct host_cmd_tlv_auth_type *)tlv;
-- 
1.7.0.2

