Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:43532 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaIUTW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:29 -0400
Received: by mail-wi0-f175.google.com with SMTP id r20so1819677wiv.14
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:22:27 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/17] iwlwifi: mvm: Update TX power in TPC reports
Date: Sun, 21 Sep 2014 22:22:03 +0300
Message-Id: <1411327338-23099-2-git-send-email-egrumbach@gmail.com> (sfid-20140921_212232_905034_8120DC88)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Introduce new tx command flag (TX_CMD_FLG_WRITE_TX_POWER) which requests the
fw to update the tx power value at some constant offset.
Set this flag when transmitting either TPC report or Link measurement report
action frames.
In addition, introduce new tlv which indicates whether the fw supports power
insertion (IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT) and publish the
corresponding nl80211 feature.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h        | 4 ++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h | 2 ++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  | 4 ++++
 drivers/net/wireless/iwlwifi/mvm/tx.c        | 5 +++++
 4 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 62c46eb..6ab40bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -145,9 +145,13 @@ enum iwl_ucode_tlv_api {
 /**
  * enum iwl_ucode_tlv_capa - ucode capabilities
  * @IWL_UCODE_TLV_CAPA_D0I3_SUPPORT: supports D0i3
+ * @IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT: supports insertion of current
+ *	tx power value into TPC Report action frame and Link Measurement Report
+ *	action frame
  */
 enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT		= BIT(0),
+	IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT = BIT(8),
 };
 
 /* The default calibrate table size if not specified by firmware file */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
index d6073f6..5bca1f8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
@@ -66,6 +66,7 @@
 /**
  * enum iwl_tx_flags - bitmasks for tx_flags in TX command
  * @TX_CMD_FLG_PROT_REQUIRE: use RTS or CTS-to-self to protect the frame
+ * @TX_CMD_FLG_WRITE_TX_POWER: update current tx power value in the mgmt frame
  * @TX_CMD_FLG_ACK: expect ACK from receiving station
  * @TX_CMD_FLG_STA_RATE: use RS table with initial index from the TX command.
  *	Otherwise, use rate_n_flags from the TX command
@@ -97,6 +98,7 @@
  */
 enum iwl_tx_flags {
 	TX_CMD_FLG_PROT_REQUIRE		= BIT(0),
+	TX_CMD_FLG_WRITE_TX_POWER	= BIT(1),
 	TX_CMD_FLG_ACK			= BIT(3),
 	TX_CMD_FLG_STA_RATE		= BIT(4),
 	TX_CMD_FLG_BAR			= BIT(6),
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 5f5a893..ba029f6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -412,6 +412,10 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 			       NL80211_FEATURE_DYNAMIC_SMPS |
 			       NL80211_FEATURE_STATIC_SMPS;
 
+	if (mvm->fw->ucode_capa.capa[0] &
+	    IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT)
+		hw->wiphy->features |= NL80211_FEATURE_TX_POWER_INSERTION;
+
 	mvm->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
 
 	/* currently FW API supports only one optional cipher scheme */
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index c67296e..d84f3ca 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -133,6 +133,11 @@ static void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 	    !is_multicast_ether_addr(ieee80211_get_DA(hdr)))
 		tx_flags |= TX_CMD_FLG_PROT_REQUIRE;
 
+	if ((mvm->fw->ucode_capa.capa[0] &
+	     IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT) &&
+	    ieee80211_action_contains_tpc(skb))
+		tx_flags |= TX_CMD_FLG_WRITE_TX_POWER;
+
 	tx_cmd->tx_flags = cpu_to_le32(tx_flags);
 	/* Total # bytes to be transmitted */
 	tx_cmd->len = cpu_to_le16((u16)skb->len);
-- 
1.9.1

