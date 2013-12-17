Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:61816 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3LQUou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:44:50 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so3103537eaj.21
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:44:49 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Max Stepanov <Max.Stepanov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/36] iwlwifi: mvm: add a generic cipher scheme support
Date: Tue, 17 Dec 2013 22:44:06 +0200
Message-Id: <1387313079-28123-3-git-send-email-egrumbach@gmail.com> (sfid-20131217_214455_507011_426416F0)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Max Stepanov <Max.Stepanov@intel.com>

This patch adds a cipher scheme support to extend a set of
the supported ciphers. The driver reads a cipher scheme list TLV
from FW image and passes it to mac80211 on hw registration.
After the cipher schemes are registered the driver handles key
installation and Tx/Rx calls related to the new ciphers.

Signed-off-by: Max Stepanov <Max.Stepanov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c        |   39 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-fw.h         |   41 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h |   10 +++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h  |    1 +
 drivers/net/wireless/iwlwifi/mvm/fw-api.h     |    1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   |   13 +++++++-
 drivers/net/wireless/iwlwifi/mvm/rx.c         |    6 ++++
 drivers/net/wireless/iwlwifi/mvm/sta.c        |    8 ++---
 drivers/net/wireless/iwlwifi/mvm/tx.c         |    3 +-
 10 files changed, 115 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index ff57002..4bebfb5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -322,6 +322,41 @@ static void set_sec_offset(struct iwl_firmware_pieces *pieces,
 	pieces->img[type].sec[sec].offset = offset;
 }
 
+static int iwl_store_cscheme(struct iwl_fw *fw, const u8 *data, const u32 len)
+{
+	int i, j;
+	struct iwl_fw_cscheme_list *l = (struct iwl_fw_cscheme_list *)data;
+	struct iwl_fw_cipher_scheme *fwcs;
+	struct ieee80211_cipher_scheme *cs;
+	u32 cipher;
+
+	if (len < sizeof(*l) ||
+	    len < sizeof(l->size) + l->size * sizeof(l->cs[0]))
+		return -EINVAL;
+
+	for (i = 0, j = 0; i < IWL_UCODE_MAX_CS && i < l->size; i++) {
+		fwcs = &l->cs[j];
+		cipher = le32_to_cpu(fwcs->cipher);
+
+		/* we skip schemes with zero cipher suite selector */
+		if (!cipher)
+			continue;
+
+		cs = &fw->cs[j++];
+		cs->cipher = cipher;
+		cs->iftype = BIT(NL80211_IFTYPE_STATION);
+		cs->hdr_len = fwcs->hdr_len;
+		cs->pn_len = fwcs->pn_len;
+		cs->pn_off = fwcs->pn_off;
+		cs->key_idx_off = fwcs->key_idx_off;
+		cs->key_idx_mask = fwcs->key_idx_mask;
+		cs->key_idx_shift = fwcs->key_idx_shift;
+		cs->mic_len = fwcs->mic_len;
+	}
+
+	return 0;
+}
+
 /*
  * Gets uCode section from tlv.
  */
@@ -729,6 +764,10 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				return -EINVAL;
 			}
 			break;
+		case IWL_UCODE_TLV_CSCHEME:
+			if (iwl_store_cscheme(&drv->fw, tlv_data, tlv_len))
+				goto invalid_tlv_len;
+			break;
 		default:
 			IWL_DEBUG_INFO(drv, "unknown TLV: %d\n", tlv_type);
 			break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 6c6c35c..4f95734 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -125,6 +125,7 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_SECURE_SEC_INIT	= 25,
 	IWL_UCODE_TLV_SECURE_SEC_WOWLAN	= 26,
 	IWL_UCODE_TLV_NUM_OF_CPU	= 27,
+	IWL_UCODE_TLV_CSCHEME		= 28,
 };
 
 struct iwl_ucode_tlv {
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 75db0871..b2a4c1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -209,6 +209,44 @@ enum iwl_fw_phy_cfg {
 	FW_PHY_CFG_RX_CHAIN = 0xf << FW_PHY_CFG_RX_CHAIN_POS,
 };
 
+#define IWL_UCODE_MAX_CS		1
+
+/**
+ * struct iwl_fw_cipher_scheme - a cipher scheme supported by FW.
+ * @cipher: a cipher suite selector
+ * @flags: cipher scheme flags (currently reserved for a future use)
+ * @hdr_len: a size of MPDU security header
+ * @pn_len: a size of PN
+ * @pn_off: an offset of pn from the beginning of the security header
+ * @key_idx_off: an offset of key index byte in the security header
+ * @key_idx_mask: a bit mask of key_idx bits
+ * @key_idx_shift: bit shift needed to get key_idx
+ * @mic_len: mic length in bytes
+ * @hw_cipher: a HW cipher index used in host commands
+ */
+struct iwl_fw_cipher_scheme {
+	__le32 cipher;
+	u8 flags;
+	u8 hdr_len;
+	u8 pn_len;
+	u8 pn_off;
+	u8 key_idx_off;
+	u8 key_idx_mask;
+	u8 key_idx_shift;
+	u8 mic_len;
+	u8 hw_cipher;
+} __packed;
+
+/**
+ * struct iwl_fw_cscheme_list - a cipher scheme list
+ * @size: a number of entries
+ * @cs: cipher scheme entries
+ */
+struct iwl_fw_cscheme_list {
+	u8 size;
+	struct iwl_fw_cipher_scheme cs[];
+} __packed;
+
 /**
  * struct iwl_fw - variables associated with the firmware
  *
@@ -224,6 +262,7 @@ enum iwl_fw_phy_cfg {
  * @inst_evtlog_size: event log size for runtime ucode.
  * @inst_errlog_ptr: error log offfset for runtime ucode.
  * @mvm_fw: indicates this is MVM firmware
+ * @cipher_scheme: optional external cipher scheme.
  */
 struct iwl_fw {
 	u32 ucode_ver;
@@ -243,6 +282,8 @@ struct iwl_fw {
 	u32 phy_config;
 
 	bool mvm_fw;
+
+	struct ieee80211_cipher_scheme cs[IWL_UCODE_MAX_CS];
 };
 
 static inline u8 iwl_fw_valid_tx_ant(const struct iwl_fw *fw)
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
index 4aca593..8c73ba7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
@@ -138,7 +138,14 @@ enum iwl_sta_flags {
 
 /**
  * enum iwl_sta_key_flag - key flags for the ADD_STA host command
- * @STA_KEY_FLG_EN_MSK: mask for encryption algorithm
+ * @STA_KEY_FLG_NO_ENC: no encryption
+ * @STA_KEY_FLG_WEP: WEP encryption algorithm
+ * @STA_KEY_FLG_CCM: CCMP encryption algorithm
+ * @STA_KEY_FLG_TKIP: TKIP encryption algorithm
+ * @STA_KEY_FLG_EXT: extended cipher algorithm (depends on the FW support)
+ * @STA_KEY_FLG_CMAC: CMAC encryption algorithm
+ * @STA_KEY_FLG_ENC_UNKNOWN: unknown encryption algorithm
+ * @STA_KEY_FLG_EN_MSK: mask for encryption algorithmi value
  * @STA_KEY_FLG_WEP_KEY_MAP: wep is either a group key (0 - legacy WEP) or from
  *	station info array (1 - n 1X mode)
  * @STA_KEY_FLG_KEYID_MSK: the index of the key
@@ -152,6 +159,7 @@ enum iwl_sta_key_flag {
 	STA_KEY_FLG_WEP			= (1 << 0),
 	STA_KEY_FLG_CCM			= (2 << 0),
 	STA_KEY_FLG_TKIP		= (3 << 0),
+	STA_KEY_FLG_EXT			= (4 << 0),
 	STA_KEY_FLG_CMAC		= (6 << 0),
 	STA_KEY_FLG_ENC_UNKNOWN		= (7 << 0),
 	STA_KEY_FLG_EN_MSK		= (7 << 0),
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
index d606197..2286467 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
@@ -132,6 +132,7 @@ enum iwl_tx_flags {
 #define TX_CMD_SEC_WEP			0x01
 #define TX_CMD_SEC_CCM			0x02
 #define TX_CMD_SEC_TKIP			0x03
+#define TX_CMD_SEC_EXT			0x04
 #define TX_CMD_SEC_MSK			0x07
 #define TX_CMD_SEC_WEP_KEY_IDX_POS	6
 #define TX_CMD_SEC_WEP_KEY_IDX_MSK	0xc0
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 3af4133..c9cfaad 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1053,6 +1053,7 @@ enum iwl_mvm_rx_status {
 	RX_MPDU_RES_STATUS_SEC_WEP_ENC			= (1 << 8),
 	RX_MPDU_RES_STATUS_SEC_CCM_ENC			= (2 << 8),
 	RX_MPDU_RES_STATUS_SEC_TKIP_ENC			= (3 << 8),
+	RX_MPDU_RES_STATUS_SEC_EXT_ENC			= (4 << 8),
 	RX_MPDU_RES_STATUS_SEC_CCM_CMAC_ENC		= (6 << 8),
 	RX_MPDU_RES_STATUS_SEC_ENC_ERR			= (7 << 8),
 	RX_MPDU_RES_STATUS_SEC_ENC_MSK			= (7 << 8),
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index f0f8b2c..8a99ecc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -261,6 +261,12 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	mvm->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
 
+	/* currently FW API supports only one optional cipher scheme */
+	if (mvm->fw->cs && mvm->fw->cs->cipher) {
+		mvm->hw->n_cipher_schemes = 1;
+		mvm->hw->cipher_schemes = mvm->fw->cs;
+	}
+
 #ifdef CONFIG_PM_SLEEP
 	if (mvm->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
 	    mvm->trans->ops->d3_suspend &&
@@ -1342,7 +1348,12 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 		 */
 		return 0;
 	default:
-		return -EOPNOTSUPP;
+		/* currently FW supports only one optional cipher scheme */
+		if (hw->n_cipher_schemes &&
+		    hw->cipher_schemes->cipher == key->cipher)
+			key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
+		else
+			return -EOPNOTSUPP;
 	}
 
 	mutex_lock(&mvm->mutex);
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 3a1f398..454341c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -251,6 +251,12 @@ static u32 iwl_mvm_set_mac80211_rx_flag(struct iwl_mvm *mvm,
 		stats->flag |= RX_FLAG_DECRYPTED;
 		return 0;
 
+	case RX_MPDU_RES_STATUS_SEC_EXT_ENC:
+		if (!(rx_pkt_status & RX_MPDU_RES_STATUS_MIC_OK))
+			return -1;
+		stats->flag |= RX_FLAG_DECRYPTED;
+		return 0;
+
 	default:
 		IWL_ERR(mvm, "Unhandled alg: 0x%x\n", rx_pkt_status);
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 7a5b747..4ea00da 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1123,8 +1123,8 @@ static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 		memcpy(cmd.key, keyconf->key, keyconf->keylen);
 		break;
 	default:
-		WARN_ON(1);
-		return -EINVAL;
+		key_flags |= cpu_to_le16(STA_KEY_FLG_EXT);
+		memcpy(cmd.key, keyconf->key, keyconf->keylen);
 	}
 
 	if (!(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE))
@@ -1288,8 +1288,8 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 					   0, NULL, CMD_SYNC);
 		break;
 	default:
-		IWL_ERR(mvm, "Unknown cipher %x\n", keyconf->cipher);
-		ret = -EINVAL;
+		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf,
+					   sta_id, 0, NULL, CMD_SYNC);
 	}
 
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index d87649a..735f86d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -253,8 +253,7 @@ static void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
 		memcpy(&tx_cmd->key[3], keyconf->key, keyconf->keylen);
 		break;
 	default:
-		IWL_ERR(mvm, "Unknown encode cipher %x\n", keyconf->cipher);
-		break;
+		tx_cmd->sec_ctl |= TX_CMD_SEC_EXT;
 	}
 }
 
-- 
1.7.9.5

