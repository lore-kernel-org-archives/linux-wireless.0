Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:40307 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148Ab3GWCTV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:19:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 20/21] mwifiex: remove duplicate structure host_cmd_tlv
Date: Mon, 22 Jul 2013 19:17:57 -0700
Message-ID: <1374545878-15683-21-git-send-email-bzhao@marvell.com> (sfid-20130723_041928_212184_B7907FD8)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We already have 'struct mwifiex_ie_types_header' with same
definition. Hence host_cmd_tlv is removed in this patch.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h      |  41 +++++------
 drivers/net/wireless/mwifiex/ie.c      |   2 +-
 drivers/net/wireless/mwifiex/sta_cmd.c |   5 +-
 drivers/net/wireless/mwifiex/uap_cmd.c | 130 +++++++++++++++++----------------
 4 files changed, 91 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 99c2729..c0dfc4d 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1366,11 +1366,6 @@ struct host_cmd_ds_802_11_eeprom_access {
 	u8 value;
 } __packed;
 
-struct host_cmd_tlv {
-	__le16 type;
-	__le16 len;
-} __packed;
-
 struct mwifiex_assoc_event {
 	u8 sta_addr[ETH_ALEN];
 	__le16 type;
@@ -1396,99 +1391,99 @@ struct host_cmd_11ac_vht_cfg {
 } __packed;
 
 struct host_cmd_tlv_akmp {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	__le16 key_mgmt;
 	__le16 key_mgmt_operation;
 } __packed;
 
 struct host_cmd_tlv_pwk_cipher {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	__le16 proto;
 	u8 cipher;
 	u8 reserved;
 } __packed;
 
 struct host_cmd_tlv_gwk_cipher {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	u8 cipher;
 	u8 reserved;
 } __packed;
 
 struct host_cmd_tlv_passphrase {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	u8 passphrase[0];
 } __packed;
 
 struct host_cmd_tlv_wep_key {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	u8 key_index;
 	u8 is_default;
 	u8 key[1];
 };
 
 struct host_cmd_tlv_auth_type {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	u8 auth_type;
 } __packed;
 
 struct host_cmd_tlv_encrypt_protocol {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	__le16 proto;
 } __packed;
 
 struct host_cmd_tlv_ssid {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	u8 ssid[0];
 } __packed;
 
 struct host_cmd_tlv_rates {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	u8 rates[0];
 } __packed;
 
 struct host_cmd_tlv_bcast_ssid {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	u8 bcast_ctl;
 } __packed;
 
 struct host_cmd_tlv_beacon_period {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	__le16 period;
 } __packed;
 
 struct host_cmd_tlv_dtim_period {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	u8 period;
 } __packed;
 
 struct host_cmd_tlv_frag_threshold {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	__le16 frag_thr;
 } __packed;
 
 struct host_cmd_tlv_rts_threshold {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	__le16 rts_thr;
 } __packed;
 
 struct host_cmd_tlv_retry_limit {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	u8 limit;
 } __packed;
 
 struct host_cmd_tlv_mac_addr {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	u8 mac_addr[ETH_ALEN];
 } __packed;
 
 struct host_cmd_tlv_channel_band {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	u8 band_config;
 	u8 channel;
 } __packed;
 
 struct host_cmd_tlv_ageout_timer {
-	struct host_cmd_tlv tlv;
+	struct mwifiex_ie_types_header header;
 	__le32 sta_ao_timer;
 } __packed;
 
diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index e38342f..220af4f 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -87,7 +87,7 @@ mwifiex_update_autoindex_ies(struct mwifiex_private *priv,
 	u8 *tmp;
 
 	input_len = le16_to_cpu(ie_list->len);
-	travel_len = sizeof(struct host_cmd_tlv);
+	travel_len = sizeof(struct mwifiex_ie_types_header);
 
 	ie_list->len = 0;
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 8ece485..9b75ed8 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -707,8 +707,9 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 		if (priv->bss_type == MWIFIEX_BSS_TYPE_UAP) {
 			tlv_mac = (void *)((u8 *)&key_material->key_param_set +
 					   key_param_len);
-			tlv_mac->tlv.type = cpu_to_le16(TLV_TYPE_STA_MAC_ADDR);
-			tlv_mac->tlv.len = cpu_to_le16(ETH_ALEN);
+			tlv_mac->header.type =
+					cpu_to_le16(TLV_TYPE_STA_MAC_ADDR);
+			tlv_mac->header.len = cpu_to_le16(ETH_ALEN);
 			memcpy(tlv_mac->mac_addr, enc_key->mac_addr, ETH_ALEN);
 			cmd_size = key_param_len + S_DS_GEN +
 				   sizeof(key_material->action) +
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 2de882d..64424c8 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -293,9 +293,9 @@ mwifiex_uap_bss_wpa(u8 **tlv_buf, void *cmd_buf, u16 *param_size)
 	u8 *tlv = *tlv_buf;
 
 	tlv_akmp = (struct host_cmd_tlv_akmp *)tlv;
-	tlv_akmp->tlv.type = cpu_to_le16(TLV_TYPE_UAP_AKMP);
-	tlv_akmp->tlv.len = cpu_to_le16(sizeof(struct host_cmd_tlv_akmp) -
-					sizeof(struct host_cmd_tlv));
+	tlv_akmp->header.type = cpu_to_le16(TLV_TYPE_UAP_AKMP);
+	tlv_akmp->header.len = cpu_to_le16(sizeof(struct host_cmd_tlv_akmp) -
+					sizeof(struct mwifiex_ie_types_header));
 	tlv_akmp->key_mgmt_operation = cpu_to_le16(bss_cfg->key_mgmt_operation);
 	tlv_akmp->key_mgmt = cpu_to_le16(bss_cfg->key_mgmt);
 	cmd_size += sizeof(struct host_cmd_tlv_akmp);
@@ -303,10 +303,10 @@ mwifiex_uap_bss_wpa(u8 **tlv_buf, void *cmd_buf, u16 *param_size)
 
 	if (bss_cfg->wpa_cfg.pairwise_cipher_wpa & VALID_CIPHER_BITMAP) {
 		pwk_cipher = (struct host_cmd_tlv_pwk_cipher *)tlv;
-		pwk_cipher->tlv.type = cpu_to_le16(TLV_TYPE_PWK_CIPHER);
-		pwk_cipher->tlv.len =
+		pwk_cipher->header.type = cpu_to_le16(TLV_TYPE_PWK_CIPHER);
+		pwk_cipher->header.len =
 			cpu_to_le16(sizeof(struct host_cmd_tlv_pwk_cipher) -
-				    sizeof(struct host_cmd_tlv));
+				    sizeof(struct mwifiex_ie_types_header));
 		pwk_cipher->proto = cpu_to_le16(PROTOCOL_WPA);
 		pwk_cipher->cipher = bss_cfg->wpa_cfg.pairwise_cipher_wpa;
 		cmd_size += sizeof(struct host_cmd_tlv_pwk_cipher);
@@ -315,10 +315,10 @@ mwifiex_uap_bss_wpa(u8 **tlv_buf, void *cmd_buf, u16 *param_size)
 
 	if (bss_cfg->wpa_cfg.pairwise_cipher_wpa2 & VALID_CIPHER_BITMAP) {
 		pwk_cipher = (struct host_cmd_tlv_pwk_cipher *)tlv;
-		pwk_cipher->tlv.type = cpu_to_le16(TLV_TYPE_PWK_CIPHER);
-		pwk_cipher->tlv.len =
+		pwk_cipher->header.type = cpu_to_le16(TLV_TYPE_PWK_CIPHER);
+		pwk_cipher->header.len =
 			cpu_to_le16(sizeof(struct host_cmd_tlv_pwk_cipher) -
-				    sizeof(struct host_cmd_tlv));
+				    sizeof(struct mwifiex_ie_types_header));
 		pwk_cipher->proto = cpu_to_le16(PROTOCOL_WPA2);
 		pwk_cipher->cipher = bss_cfg->wpa_cfg.pairwise_cipher_wpa2;
 		cmd_size += sizeof(struct host_cmd_tlv_pwk_cipher);
@@ -327,10 +327,10 @@ mwifiex_uap_bss_wpa(u8 **tlv_buf, void *cmd_buf, u16 *param_size)
 
 	if (bss_cfg->wpa_cfg.group_cipher & VALID_CIPHER_BITMAP) {
 		gwk_cipher = (struct host_cmd_tlv_gwk_cipher *)tlv;
-		gwk_cipher->tlv.type = cpu_to_le16(TLV_TYPE_GWK_CIPHER);
-		gwk_cipher->tlv.len =
+		gwk_cipher->header.type = cpu_to_le16(TLV_TYPE_GWK_CIPHER);
+		gwk_cipher->header.len =
 			cpu_to_le16(sizeof(struct host_cmd_tlv_gwk_cipher) -
-				    sizeof(struct host_cmd_tlv));
+				    sizeof(struct mwifiex_ie_types_header));
 		gwk_cipher->cipher = bss_cfg->wpa_cfg.group_cipher;
 		cmd_size += sizeof(struct host_cmd_tlv_gwk_cipher);
 		tlv += sizeof(struct host_cmd_tlv_gwk_cipher);
@@ -338,13 +338,15 @@ mwifiex_uap_bss_wpa(u8 **tlv_buf, void *cmd_buf, u16 *param_size)
 
 	if (bss_cfg->wpa_cfg.length) {
 		passphrase = (struct host_cmd_tlv_passphrase *)tlv;
-		passphrase->tlv.type = cpu_to_le16(TLV_TYPE_UAP_WPA_PASSPHRASE);
-		passphrase->tlv.len = cpu_to_le16(bss_cfg->wpa_cfg.length);
+		passphrase->header.type =
+				cpu_to_le16(TLV_TYPE_UAP_WPA_PASSPHRASE);
+		passphrase->header.len = cpu_to_le16(bss_cfg->wpa_cfg.length);
 		memcpy(passphrase->passphrase, bss_cfg->wpa_cfg.passphrase,
 		       bss_cfg->wpa_cfg.length);
-		cmd_size += sizeof(struct host_cmd_tlv) +
+		cmd_size += sizeof(struct mwifiex_ie_types_header) +
 			    bss_cfg->wpa_cfg.length;
-		tlv += sizeof(struct host_cmd_tlv) + bss_cfg->wpa_cfg.length;
+		tlv += sizeof(struct mwifiex_ie_types_header) +
+				bss_cfg->wpa_cfg.length;
 	}
 
 	*param_size = cmd_size;
@@ -403,16 +405,17 @@ mwifiex_uap_bss_wep(u8 **tlv_buf, void *cmd_buf, u16 *param_size)
 		    (bss_cfg->wep_cfg[i].length == WLAN_KEY_LEN_WEP40 ||
 		     bss_cfg->wep_cfg[i].length == WLAN_KEY_LEN_WEP104)) {
 			wep_key = (struct host_cmd_tlv_wep_key *)tlv;
-			wep_key->tlv.type = cpu_to_le16(TLV_TYPE_UAP_WEP_KEY);
-			wep_key->tlv.len =
+			wep_key->header.type =
+				cpu_to_le16(TLV_TYPE_UAP_WEP_KEY);
+			wep_key->header.len =
 				cpu_to_le16(bss_cfg->wep_cfg[i].length + 2);
 			wep_key->key_index = bss_cfg->wep_cfg[i].key_index;
 			wep_key->is_default = bss_cfg->wep_cfg[i].is_default;
 			memcpy(wep_key->key, bss_cfg->wep_cfg[i].key,
 			       bss_cfg->wep_cfg[i].length);
-			cmd_size += sizeof(struct host_cmd_tlv) + 2 +
+			cmd_size += sizeof(struct mwifiex_ie_types_header) + 2 +
 				    bss_cfg->wep_cfg[i].length;
-			tlv += sizeof(struct host_cmd_tlv) + 2 +
+			tlv += sizeof(struct mwifiex_ie_types_header) + 2 +
 				    bss_cfg->wep_cfg[i].length;
 		}
 	}
@@ -449,16 +452,17 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 
 	if (bss_cfg->ssid.ssid_len) {
 		ssid = (struct host_cmd_tlv_ssid *)tlv;
-		ssid->tlv.type = cpu_to_le16(TLV_TYPE_UAP_SSID);
-		ssid->tlv.len = cpu_to_le16((u16)bss_cfg->ssid.ssid_len);
+		ssid->header.type = cpu_to_le16(TLV_TYPE_UAP_SSID);
+		ssid->header.len = cpu_to_le16((u16)bss_cfg->ssid.ssid_len);
 		memcpy(ssid->ssid, bss_cfg->ssid.ssid, bss_cfg->ssid.ssid_len);
-		cmd_size += sizeof(struct host_cmd_tlv) +
+		cmd_size += sizeof(struct mwifiex_ie_types_header) +
 			    bss_cfg->ssid.ssid_len;
-		tlv += sizeof(struct host_cmd_tlv) + bss_cfg->ssid.ssid_len;
+		tlv += sizeof(struct mwifiex_ie_types_header) +
+				bss_cfg->ssid.ssid_len;
 
 		bcast_ssid = (struct host_cmd_tlv_bcast_ssid *)tlv;
-		bcast_ssid->tlv.type = cpu_to_le16(TLV_TYPE_UAP_BCAST_SSID);
-		bcast_ssid->tlv.len =
+		bcast_ssid->header.type = cpu_to_le16(TLV_TYPE_UAP_BCAST_SSID);
+		bcast_ssid->header.len =
 				cpu_to_le16(sizeof(bcast_ssid->bcast_ctl));
 		bcast_ssid->bcast_ctl = bss_cfg->bcast_ssid_ctl;
 		cmd_size += sizeof(struct host_cmd_tlv_bcast_ssid);
@@ -466,13 +470,13 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	}
 	if (bss_cfg->rates[0]) {
 		tlv_rates = (struct host_cmd_tlv_rates *)tlv;
-		tlv_rates->tlv.type = cpu_to_le16(TLV_TYPE_UAP_RATES);
+		tlv_rates->header.type = cpu_to_le16(TLV_TYPE_UAP_RATES);
 
 		for (i = 0; i < MWIFIEX_SUPPORTED_RATES && bss_cfg->rates[i];
 		     i++)
 			tlv_rates->rates[i] = bss_cfg->rates[i];
 
-		tlv_rates->tlv.len = cpu_to_le16(i);
+		tlv_rates->header.len = cpu_to_le16(i);
 		cmd_size += sizeof(struct host_cmd_tlv_rates) + i;
 		tlv += sizeof(struct host_cmd_tlv_rates) + i;
 	}
@@ -482,10 +486,10 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	    (bss_cfg->band_cfg == BAND_CONFIG_A &&
 	     bss_cfg->channel <= MAX_CHANNEL_BAND_A))) {
 		chan_band = (struct host_cmd_tlv_channel_band *)tlv;
-		chan_band->tlv.type = cpu_to_le16(TLV_TYPE_CHANNELBANDLIST);
-		chan_band->tlv.len =
+		chan_band->header.type = cpu_to_le16(TLV_TYPE_CHANNELBANDLIST);
+		chan_band->header.len =
 			cpu_to_le16(sizeof(struct host_cmd_tlv_channel_band) -
-				    sizeof(struct host_cmd_tlv));
+				    sizeof(struct mwifiex_ie_types_header));
 		chan_band->band_config = bss_cfg->band_cfg;
 		chan_band->channel = bss_cfg->channel;
 		cmd_size += sizeof(struct host_cmd_tlv_channel_band);
@@ -494,11 +498,11 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	if (bss_cfg->beacon_period >= MIN_BEACON_PERIOD &&
 	    bss_cfg->beacon_period <= MAX_BEACON_PERIOD) {
 		beacon_period = (struct host_cmd_tlv_beacon_period *)tlv;
-		beacon_period->tlv.type =
+		beacon_period->header.type =
 					cpu_to_le16(TLV_TYPE_UAP_BEACON_PERIOD);
-		beacon_period->tlv.len =
+		beacon_period->header.len =
 			cpu_to_le16(sizeof(struct host_cmd_tlv_beacon_period) -
-				    sizeof(struct host_cmd_tlv));
+				    sizeof(struct mwifiex_ie_types_header));
 		beacon_period->period = cpu_to_le16(bss_cfg->beacon_period);
 		cmd_size += sizeof(struct host_cmd_tlv_beacon_period);
 		tlv += sizeof(struct host_cmd_tlv_beacon_period);
@@ -506,21 +510,22 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	if (bss_cfg->dtim_period >= MIN_DTIM_PERIOD &&
 	    bss_cfg->dtim_period <= MAX_DTIM_PERIOD) {
 		dtim_period = (struct host_cmd_tlv_dtim_period *)tlv;
-		dtim_period->tlv.type = cpu_to_le16(TLV_TYPE_UAP_DTIM_PERIOD);
-		dtim_period->tlv.len =
+		dtim_period->header.type =
+			cpu_to_le16(TLV_TYPE_UAP_DTIM_PERIOD);
+		dtim_period->header.len =
 			cpu_to_le16(sizeof(struct host_cmd_tlv_dtim_period) -
-				    sizeof(struct host_cmd_tlv));
+				    sizeof(struct mwifiex_ie_types_header));
 		dtim_period->period = bss_cfg->dtim_period;
 		cmd_size += sizeof(struct host_cmd_tlv_dtim_period);
 		tlv += sizeof(struct host_cmd_tlv_dtim_period);
 	}
 	if (bss_cfg->rts_threshold <= MWIFIEX_RTS_MAX_VALUE) {
 		rts_threshold = (struct host_cmd_tlv_rts_threshold *)tlv;
-		rts_threshold->tlv.type =
+		rts_threshold->header.type =
 					cpu_to_le16(TLV_TYPE_UAP_RTS_THRESHOLD);
-		rts_threshold->tlv.len =
+		rts_threshold->header.len =
 			cpu_to_le16(sizeof(struct host_cmd_tlv_rts_threshold) -
-				    sizeof(struct host_cmd_tlv));
+				    sizeof(struct mwifiex_ie_types_header));
 		rts_threshold->rts_thr = cpu_to_le16(bss_cfg->rts_threshold);
 		cmd_size += sizeof(struct host_cmd_tlv_frag_threshold);
 		tlv += sizeof(struct host_cmd_tlv_frag_threshold);
@@ -528,21 +533,22 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	if ((bss_cfg->frag_threshold >= MWIFIEX_FRAG_MIN_VALUE) &&
 	    (bss_cfg->frag_threshold <= MWIFIEX_FRAG_MAX_VALUE)) {
 		frag_threshold = (struct host_cmd_tlv_frag_threshold *)tlv;
-		frag_threshold->tlv.type =
+		frag_threshold->header.type =
 				cpu_to_le16(TLV_TYPE_UAP_FRAG_THRESHOLD);
-		frag_threshold->tlv.len =
+		frag_threshold->header.len =
 			cpu_to_le16(sizeof(struct host_cmd_tlv_frag_threshold) -
-				    sizeof(struct host_cmd_tlv));
+				    sizeof(struct mwifiex_ie_types_header));
 		frag_threshold->frag_thr = cpu_to_le16(bss_cfg->frag_threshold);
 		cmd_size += sizeof(struct host_cmd_tlv_frag_threshold);
 		tlv += sizeof(struct host_cmd_tlv_frag_threshold);
 	}
 	if (bss_cfg->retry_limit <= MWIFIEX_RETRY_LIMIT) {
 		retry_limit = (struct host_cmd_tlv_retry_limit *)tlv;
-		retry_limit->tlv.type = cpu_to_le16(TLV_TYPE_UAP_RETRY_LIMIT);
-		retry_limit->tlv.len =
+		retry_limit->header.type =
+			cpu_to_le16(TLV_TYPE_UAP_RETRY_LIMIT);
+		retry_limit->header.len =
 			cpu_to_le16(sizeof(struct host_cmd_tlv_retry_limit) -
-				    sizeof(struct host_cmd_tlv));
+				    sizeof(struct mwifiex_ie_types_header));
 		retry_limit->limit = (u8)bss_cfg->retry_limit;
 		cmd_size += sizeof(struct host_cmd_tlv_retry_limit);
 		tlv += sizeof(struct host_cmd_tlv_retry_limit);
@@ -557,21 +563,21 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	if ((bss_cfg->auth_mode <= WLAN_AUTH_SHARED_KEY) ||
 	    (bss_cfg->auth_mode == MWIFIEX_AUTH_MODE_AUTO)) {
 		auth_type = (struct host_cmd_tlv_auth_type *)tlv;
-		auth_type->tlv.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
-		auth_type->tlv.len =
+		auth_type->header.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
+		auth_type->header.len =
 			cpu_to_le16(sizeof(struct host_cmd_tlv_auth_type) -
-			sizeof(struct host_cmd_tlv));
+			sizeof(struct mwifiex_ie_types_header));
 		auth_type->auth_type = (u8)bss_cfg->auth_mode;
 		cmd_size += sizeof(struct host_cmd_tlv_auth_type);
 		tlv += sizeof(struct host_cmd_tlv_auth_type);
 	}
 	if (bss_cfg->protocol) {
 		encrypt_protocol = (struct host_cmd_tlv_encrypt_protocol *)tlv;
-		encrypt_protocol->tlv.type =
+		encrypt_protocol->header.type =
 			cpu_to_le16(TLV_TYPE_UAP_ENCRY_PROTOCOL);
-		encrypt_protocol->tlv.len =
+		encrypt_protocol->header.len =
 			cpu_to_le16(sizeof(struct host_cmd_tlv_encrypt_protocol)
-			- sizeof(struct host_cmd_tlv));
+			- sizeof(struct mwifiex_ie_types_header));
 		encrypt_protocol->proto = cpu_to_le16(bss_cfg->protocol);
 		cmd_size += sizeof(struct host_cmd_tlv_encrypt_protocol);
 		tlv += sizeof(struct host_cmd_tlv_encrypt_protocol);
@@ -608,9 +614,9 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 
 	if (bss_cfg->sta_ao_timer) {
 		ao_timer = (struct host_cmd_tlv_ageout_timer *)tlv;
-		ao_timer->tlv.type = cpu_to_le16(TLV_TYPE_UAP_AO_TIMER);
-		ao_timer->tlv.len = cpu_to_le16(sizeof(*ao_timer) -
-						sizeof(struct host_cmd_tlv));
+		ao_timer->header.type = cpu_to_le16(TLV_TYPE_UAP_AO_TIMER);
+		ao_timer->header.len = cpu_to_le16(sizeof(*ao_timer) -
+					sizeof(struct mwifiex_ie_types_header));
 		ao_timer->sta_ao_timer = cpu_to_le32(bss_cfg->sta_ao_timer);
 		cmd_size += sizeof(*ao_timer);
 		tlv += sizeof(*ao_timer);
@@ -618,9 +624,10 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 
 	if (bss_cfg->ps_sta_ao_timer) {
 		ps_ao_timer = (struct host_cmd_tlv_ageout_timer *)tlv;
-		ps_ao_timer->tlv.type = cpu_to_le16(TLV_TYPE_UAP_PS_AO_TIMER);
-		ps_ao_timer->tlv.len = cpu_to_le16(sizeof(*ps_ao_timer) -
-						   sizeof(struct host_cmd_tlv));
+		ps_ao_timer->header.type =
+				cpu_to_le16(TLV_TYPE_UAP_PS_AO_TIMER);
+		ps_ao_timer->header.len = cpu_to_le16(sizeof(*ps_ao_timer) -
+				sizeof(struct mwifiex_ie_types_header));
 		ps_ao_timer->sta_ao_timer =
 					cpu_to_le32(bss_cfg->ps_sta_ao_timer);
 		cmd_size += sizeof(*ps_ao_timer);
@@ -636,16 +643,17 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 static int mwifiex_uap_custom_ie_prepare(u8 *tlv, void *cmd_buf, u16 *ie_size)
 {
 	struct mwifiex_ie_list *ap_ie = cmd_buf;
-	struct host_cmd_tlv *tlv_ie = (struct host_cmd_tlv *)tlv;
+	struct mwifiex_ie_types_header *tlv_ie = (void *)tlv;
 
 	if (!ap_ie || !ap_ie->len || !ap_ie->ie_list)
 		return -1;
 
-	*ie_size += le16_to_cpu(ap_ie->len) + sizeof(struct host_cmd_tlv);
+	*ie_size += le16_to_cpu(ap_ie->len) +
+			sizeof(struct mwifiex_ie_types_header);
 
 	tlv_ie->type = cpu_to_le16(TLV_TYPE_MGMT_IE);
 	tlv_ie->len = ap_ie->len;
-	tlv += sizeof(struct host_cmd_tlv);
+	tlv += sizeof(struct mwifiex_ie_types_header);
 
 	memcpy(tlv, ap_ie->ie_list, le16_to_cpu(ap_ie->len));
 
-- 
1.8.2.3

