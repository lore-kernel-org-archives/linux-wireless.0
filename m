Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33568 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753917AbcGFKqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:46:05 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Ayala Beker <ayala.beker@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:20 +0300
Message-Id: <1467801651-1816-25-git-send-email-luca@coelho.fi> (sfid-20160706_124610_750392_6C3EAF1B)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 25/56] iwlwifi: mvm: add support for GCMP encryption
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Newer hardware supports GCMP and GCMP 256-bit ciphers.
Add support for adding/setting GCMP key for TX mode.

In the TX command handling GCMP-256 is handled in a different
way as the key size should be up to 128-bits:
Set the key value to the key index in the key table,
and specify that this key should be taken form the key table
instead of from the TX command.

While at it - convert security control flags to an enum.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/fw-api-sta.h    |  8 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h | 31 ++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 19 +++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  9 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 39 +++++++++++++++++-----
 6 files changed, 85 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
index 38b1d04..d1c4fb8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
@@ -141,6 +141,7 @@ enum iwl_sta_flags {
  * @STA_KEY_FLG_CCM: CCMP encryption algorithm
  * @STA_KEY_FLG_TKIP: TKIP encryption algorithm
  * @STA_KEY_FLG_EXT: extended cipher algorithm (depends on the FW support)
+ * @STA_KEY_FLG_GCMP: GCMP encryption algorithm
  * @STA_KEY_FLG_CMAC: CMAC encryption algorithm
  * @STA_KEY_FLG_ENC_UNKNOWN: unknown encryption algorithm
  * @STA_KEY_FLG_EN_MSK: mask for encryption algorithmi value
@@ -149,6 +150,7 @@ enum iwl_sta_flags {
  * @STA_KEY_FLG_KEYID_MSK: the index of the key
  * @STA_KEY_NOT_VALID: key is invalid
  * @STA_KEY_FLG_WEP_13BYTES: set for 13 bytes WEP key
+ * @STA_KEY_FLG_KEY_32BYTES for non-wep key set for 32 bytes key
  * @STA_KEY_MULTICAST: set for multical key
  * @STA_KEY_MFP: key is used for Management Frame Protection
  */
@@ -158,6 +160,7 @@ enum iwl_sta_key_flag {
 	STA_KEY_FLG_CCM			= (2 << 0),
 	STA_KEY_FLG_TKIP		= (3 << 0),
 	STA_KEY_FLG_EXT			= (4 << 0),
+	STA_KEY_FLG_GCMP		= (5 << 0),
 	STA_KEY_FLG_CMAC		= (6 << 0),
 	STA_KEY_FLG_ENC_UNKNOWN		= (7 << 0),
 	STA_KEY_FLG_EN_MSK		= (7 << 0),
@@ -167,6 +170,7 @@ enum iwl_sta_key_flag {
 	STA_KEY_FLG_KEYID_MSK		= (3 << STA_KEY_FLG_KEYID_POS),
 	STA_KEY_NOT_VALID		= BIT(11),
 	STA_KEY_FLG_WEP_13BYTES		= BIT(12),
+	STA_KEY_FLG_KEY_32BYTES		= BIT(12),
 	STA_KEY_MULTICAST		= BIT(14),
 	STA_KEY_MFP			= BIT(15),
 };
@@ -388,7 +392,6 @@ struct iwl_mvm_add_sta_cmd {
  * @key_offset: key offset in key storage
  * @key_flags: type %iwl_sta_key_flag
  * @key: key material data
- * @key2: key material data
  * @rx_secur_seq_cnt: RX security sequence counter for the key
  * @tkip_rx_tsc_byte2: TSC[2] for key mix ph1 detection
  * @tkip_rx_ttak: 10-byte unicast TKIP TTAK for Rx
@@ -397,8 +400,7 @@ struct iwl_mvm_add_sta_key_cmd {
 	u8 sta_id;
 	u8 key_offset;
 	__le16 key_flags;
-	u8 key[16];
-	u8 key2[16];
+	u8 key[32];
 	u8 rx_secur_seq_cnt[16];
 	u8 tkip_rx_tsc_byte2;
 	u8 reserved;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index ee59511..4144623 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -137,17 +137,32 @@ enum iwl_tx_pm_timeouts {
 	PM_FRAME_ASSOC		= 3,
 };
 
-/*
- * TX command security control
- */
-#define TX_CMD_SEC_WEP			0x01
-#define TX_CMD_SEC_CCM			0x02
-#define TX_CMD_SEC_TKIP			0x03
-#define TX_CMD_SEC_EXT			0x04
 #define TX_CMD_SEC_MSK			0x07
 #define TX_CMD_SEC_WEP_KEY_IDX_POS	6
 #define TX_CMD_SEC_WEP_KEY_IDX_MSK	0xc0
-#define TX_CMD_SEC_KEY128		0x08
+
+/**
+ * enum iwl_tx_cmd_sec_ctrl - bitmasks for security control in TX command
+ * @TX_CMD_SEC_WEP: WEP encryption algorithm.
+ * @TX_CMD_SEC_CCM: CCM encryption algorithm.
+ * @TX_CMD_SEC_TKIP: TKIP encryption algorithm.
+ * @TX_CMD_SEC_EXT: extended cipher algorithm.
+ * @TX_CMD_SEC_GCMP: GCMP encryption algorithm.
+ * @TX_CMD_SEC_KEY128: set for 104 bits WEP key.
+ * @TC_CMD_SEC_KEY_FROM_TABLE: for a non-WEP key, set if the key should be taken
+ *	from the table instead of from the TX command.
+ *	If the key is taken from the key table its index should be given by the
+ *	first byte of the TX command key field.
+ */
+enum iwl_tx_cmd_sec_ctrl {
+	TX_CMD_SEC_WEP			= 0x01,
+	TX_CMD_SEC_CCM			= 0x02,
+	TX_CMD_SEC_TKIP			= 0x03,
+	TX_CMD_SEC_EXT			= 0x04,
+	TX_CMD_SEC_GCMP			= 0x05,
+	TX_CMD_SEC_KEY128		= 0x08,
+	TC_CMD_SEC_KEY_FROM_TABLE	= 0x08,
+};
 
 /* TODO: how does these values are OK with only 16 bit variable??? */
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index af1d266..6b158f0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -465,11 +465,20 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	hw->uapsd_queues = IWL_MVM_UAPSD_QUEUES;
 	hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
 
-	BUILD_BUG_ON(ARRAY_SIZE(mvm->ciphers) < ARRAY_SIZE(mvm_ciphers) + 2);
+	BUILD_BUG_ON(ARRAY_SIZE(mvm->ciphers) < ARRAY_SIZE(mvm_ciphers) + 4);
 	memcpy(mvm->ciphers, mvm_ciphers, sizeof(mvm_ciphers));
 	hw->wiphy->n_cipher_suites = ARRAY_SIZE(mvm_ciphers);
 	hw->wiphy->cipher_suites = mvm->ciphers;
 
+	if (iwl_mvm_has_new_rx_api(mvm)) {
+		mvm->ciphers[hw->wiphy->n_cipher_suites] =
+			WLAN_CIPHER_SUITE_GCMP;
+		hw->wiphy->n_cipher_suites++;
+		mvm->ciphers[hw->wiphy->n_cipher_suites] =
+			WLAN_CIPHER_SUITE_GCMP_256;
+		hw->wiphy->n_cipher_suites++;
+	}
+
 	/*
 	 * Enable 11w if advertised by firmware and software crypto
 	 * is not enabled (as the firmware will interpret some mgmt
@@ -2721,6 +2730,8 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 		key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
 		key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
@@ -2782,7 +2793,8 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 		    sta && iwl_mvm_has_new_rx_api(mvm) &&
 		    key->flags & IEEE80211_KEY_FLAG_PAIRWISE &&
 		    (key->cipher == WLAN_CIPHER_SUITE_CCMP ||
-		     key->cipher == WLAN_CIPHER_SUITE_GCMP)) {
+		     key->cipher == WLAN_CIPHER_SUITE_GCMP ||
+		     key->cipher == WLAN_CIPHER_SUITE_GCMP_256)) {
 			struct ieee80211_key_seq seq;
 			int tid, q;
 
@@ -2836,7 +2848,8 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 		if (sta && iwl_mvm_has_new_rx_api(mvm) &&
 		    key->flags & IEEE80211_KEY_FLAG_PAIRWISE &&
 		    (key->cipher == WLAN_CIPHER_SUITE_CCMP ||
-		     key->cipher == WLAN_CIPHER_SUITE_GCMP)) {
+		     key->cipher == WLAN_CIPHER_SUITE_GCMP ||
+		     key->cipher == WLAN_CIPHER_SUITE_GCMP_256)) {
 			mvmsta = iwl_mvm_sta_from_mac80211(sta);
 			ptk_pn = rcu_dereference_protected(
 						mvmsta->ptk_pn[keyidx],
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 6092af2..e240f19 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -707,6 +707,7 @@ enum iwl_mvm_queue_status {
 };
 
 #define IWL_MVM_DQA_QUEUE_TIMEOUT	(5 * HZ)
+#define IWL_MVM_NUM_CIPHERS             8
 
 struct iwl_mvm {
 	/* for logger access */
@@ -1015,7 +1016,7 @@ struct iwl_mvm {
 
 	struct iwl_mvm_shared_mem_cfg shared_mem_cfg;
 
-	u32 ciphers[6];
+	u32 ciphers[IWL_MVM_NUM_CIPHERS];
 	struct iwl_mvm_tof_data tof_data;
 
 	struct ieee80211_vif *nan_vif;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index cf06817..7321bb6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2243,6 +2243,13 @@ static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 		key_flags |= cpu_to_le16(STA_KEY_FLG_WEP);
 		memcpy(cmd.key + 3, keyconf->key, keyconf->keylen);
 		break;
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		key_flags |= cpu_to_le16(STA_KEY_FLG_KEY_32BYTES);
+		/* fall through */
+	case WLAN_CIPHER_SUITE_GCMP:
+		key_flags |= cpu_to_le16(STA_KEY_FLG_GCMP);
+		memcpy(cmd.key, keyconf->key, keyconf->keylen);
+		break;
 	default:
 		key_flags |= cpu_to_le16(STA_KEY_FLG_EXT);
 		memcpy(cmd.key, keyconf->key, keyconf->keylen);
@@ -2363,6 +2370,8 @@ static int __iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
 		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, mcast,
 					   0, NULL, 0, key_offset);
 		break;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 1f23cee..2373142 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -388,6 +388,23 @@ void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
 	tx_cmd->rate_n_flags = cpu_to_le32((u32)rate_plcp | rate_flags);
 }
 
+static inline void iwl_mvm_set_tx_cmd_pn(struct ieee80211_tx_info *info,
+					 u8 *crypto_hdr)
+{
+	struct ieee80211_key_conf *keyconf = info->control.hw_key;
+	u64 pn;
+
+	pn = atomic64_inc_return(&keyconf->tx_pn);
+	crypto_hdr[0] = pn;
+	crypto_hdr[2] = 0;
+	crypto_hdr[3] = 0x20 | (keyconf->keyidx << 6);
+	crypto_hdr[1] = pn >> 8;
+	crypto_hdr[4] = pn >> 16;
+	crypto_hdr[5] = pn >> 24;
+	crypto_hdr[6] = pn >> 32;
+	crypto_hdr[7] = pn >> 40;
+}
+
 /*
  * Sets the fields in the Tx cmd that are crypto related
  */
@@ -405,15 +422,7 @@ static void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
 		iwl_mvm_set_tx_cmd_ccmp(info, tx_cmd);
-		pn = atomic64_inc_return(&keyconf->tx_pn);
-		crypto_hdr[0] = pn;
-		crypto_hdr[2] = 0;
-		crypto_hdr[3] = 0x20 | (keyconf->keyidx << 6);
-		crypto_hdr[1] = pn >> 8;
-		crypto_hdr[4] = pn >> 16;
-		crypto_hdr[5] = pn >> 24;
-		crypto_hdr[6] = pn >> 32;
-		crypto_hdr[7] = pn >> 40;
+		iwl_mvm_set_tx_cmd_pn(info, crypto_hdr);
 		break;
 
 	case WLAN_CIPHER_SUITE_TKIP:
@@ -433,6 +442,18 @@ static void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
 
 		memcpy(&tx_cmd->key[3], keyconf->key, keyconf->keylen);
 		break;
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		/* TODO: Taking the key from the table might introduce a race
+		 * when PTK rekeying is done, having an old packets with a PN
+		 * based on the old key but the message encrypted with a new
+		 * one.
+		 * Need to handle this.
+		 */
+		tx_cmd->sec_ctl |= TX_CMD_SEC_GCMP | TC_CMD_SEC_KEY_FROM_TABLE;
+		tx_cmd->key[0] = keyconf->hw_key_idx;
+		iwl_mvm_set_tx_cmd_pn(info, crypto_hdr);
+		break;
 	default:
 		tx_cmd->sec_ctl |= TX_CMD_SEC_EXT;
 	}
-- 
2.8.1

