Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:32482 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755AbbGTTnY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 15:43:24 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: sara.sharon@intel.com, Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 06/10] iwlwifi: mvm: move TX PN assignment for CCMP to the driver
Date: Mon, 20 Jul 2015 22:43:00 +0300
Message-Id: <1437421384-19884-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150720_214331_355164_BA439D6D)
In-Reply-To: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move the TX PN assignment (for CCMP only) to the driver. This prepares
the driver for future DSO (driver segmentation offload) where it will
split an SKB into multiple MPDUs by itself.

For TDLS, split out the CCMP TX command handling so that it won't get
a PN assigned, the firmware assigns the PN in that case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  5 ++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 15 ++++++++---
 drivers/net/wireless/iwlwifi/mvm/tdls.c     | 12 ++++++---
 drivers/net/wireless/iwlwifi/mvm/tx.c       | 40 +++++++++++++++++++----------
 4 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 2be6f32..def314e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2872,10 +2872,11 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-		/* fall-through */
-	case WLAN_CIPHER_SUITE_CCMP:
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
+		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		WARN_ON_ONCE(!ieee80211_hw_check(hw, MFP_CAPABLE));
 		break;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 767880b..c8b9d88 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -990,10 +990,6 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb);
 void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 			struct iwl_tx_cmd *tx_cmd,
 			struct ieee80211_tx_info *info, u8 sta_id);
-void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
-			       struct ieee80211_tx_info *info,
-			       struct iwl_tx_cmd *tx_cmd,
-			       struct sk_buff *skb_frag);
 void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
 			    struct ieee80211_tx_info *info,
 			    struct ieee80211_sta *sta, __le16 fc);
@@ -1005,6 +1001,17 @@ static inline const char *iwl_mvm_get_tx_fail_reason(u32 status) { return ""; }
 int iwl_mvm_flush_tx_path(struct iwl_mvm *mvm, u32 tfd_msk, bool sync);
 void iwl_mvm_async_handlers_purge(struct iwl_mvm *mvm);
 
+static inline void iwl_mvm_set_tx_cmd_ccmp(struct ieee80211_tx_info *info,
+					   struct iwl_tx_cmd *tx_cmd)
+{
+	struct ieee80211_key_conf *keyconf = info->control.hw_key;
+
+	tx_cmd->sec_ctl = TX_CMD_SEC_CCM;
+	memcpy(tx_cmd->key, keyconf->key, keyconf->keylen);
+	if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		tx_cmd->tx_flags |= cpu_to_le32(TX_CMD_FLG_CCMP_AGG);
+}
+
 static inline void iwl_mvm_wait_for_async_handlers(struct iwl_mvm *mvm)
 {
 	flush_work(&mvm->async_handlers_wk);
diff --git a/drivers/net/wireless/iwlwifi/mvm/tdls.c b/drivers/net/wireless/iwlwifi/mvm/tdls.c
index d44d02d..fe2fa56 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tdls.c
@@ -460,13 +460,19 @@ iwl_mvm_tdls_config_channel_switch(struct iwl_mvm *mvm,
 	cmd.frame.switch_time_offset = cpu_to_le32(ch_sw_tm_ie + 2);
 
 	info = IEEE80211_SKB_CB(skb);
-	if (info->control.hw_key)
-		iwl_mvm_set_tx_cmd_crypto(mvm, info, &cmd.frame.tx_cmd, skb);
+	hdr = (void *)skb->data;
+	if (info->control.hw_key) {
+		if (info->control.hw_key->cipher != WLAN_CIPHER_SUITE_CCMP) {
+			rcu_read_unlock();
+			ret = -EINVAL;
+			goto out;
+		}
+		iwl_mvm_set_tx_cmd_ccmp(info, &cmd.frame.tx_cmd);
+	}
 
 	iwl_mvm_set_tx_cmd(mvm, skb, &cmd.frame.tx_cmd, info,
 			   mvmsta->sta_id);
 
-	hdr = (void *)skb->data;
 	iwl_mvm_set_tx_cmd_rate(mvm, &cmd.frame.tx_cmd, info, sta,
 				hdr->frame_control);
 	rcu_read_unlock();
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index fa3eaf9..3243d73 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -268,19 +268,28 @@ void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
 /*
  * Sets the fields in the Tx cmd that are crypto related
  */
-void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
-			       struct ieee80211_tx_info *info,
-			       struct iwl_tx_cmd *tx_cmd,
-			       struct sk_buff *skb_frag)
+static void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
+				      struct ieee80211_tx_info *info,
+				      struct iwl_tx_cmd *tx_cmd,
+				      struct sk_buff *skb_frag,
+				      int hdrlen)
 {
 	struct ieee80211_key_conf *keyconf = info->control.hw_key;
+	u8 *crypto_hdr = skb_frag->data + hdrlen;
+	u64 pn;
 
 	switch (keyconf->cipher) {
 	case WLAN_CIPHER_SUITE_CCMP:
-		tx_cmd->sec_ctl = TX_CMD_SEC_CCM;
-		memcpy(tx_cmd->key, keyconf->key, keyconf->keylen);
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
-			tx_cmd->tx_flags |= cpu_to_le32(TX_CMD_FLG_CCMP_AGG);
+		iwl_mvm_set_tx_cmd_ccmp(info, tx_cmd);
+		pn = atomic64_inc_return(&keyconf->tx_pn);
+		crypto_hdr[0] = pn;
+		crypto_hdr[2] = 0;
+		crypto_hdr[3] = 0x20 | keyconf->keyidx;
+		crypto_hdr[1] = pn >> 8;
+		crypto_hdr[4] = pn >> 16;
+		crypto_hdr[5] = pn >> 24;
+		crypto_hdr[6] = pn >> 32;
+		crypto_hdr[7] = pn >> 40;
 		break;
 
 	case WLAN_CIPHER_SUITE_TKIP:
@@ -308,7 +317,7 @@ void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
  */
 static struct iwl_device_cmd *
 iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
-		      struct ieee80211_sta *sta, u8 sta_id)
+		      int hdrlen, struct ieee80211_sta *sta, u8 sta_id)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -325,7 +334,7 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 	tx_cmd = (struct iwl_tx_cmd *)dev_cmd->payload;
 
 	if (info->control.hw_key)
-		iwl_mvm_set_tx_cmd_crypto(mvm, info, tx_cmd, skb);
+		iwl_mvm_set_tx_cmd_crypto(mvm, info, tx_cmd, skb, hdrlen);
 
 	iwl_mvm_set_tx_cmd(mvm, skb, tx_cmd, info, sta_id);
 
@@ -346,6 +355,7 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	struct iwl_device_cmd *dev_cmd;
 	struct iwl_tx_cmd *tx_cmd;
 	u8 sta_id;
+	int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 	if (WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_AMPDU))
 		return -1;
@@ -393,7 +403,7 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 
 	IWL_DEBUG_TX(mvm, "station Id %d, queue=%d\n", sta_id, info->hw_queue);
 
-	dev_cmd = iwl_mvm_set_tx_params(mvm, skb, NULL, sta_id);
+	dev_cmd = iwl_mvm_set_tx_params(mvm, skb, hdrlen, NULL, sta_id);
 	if (!dev_cmd)
 		return -1;
 
@@ -401,7 +411,7 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	tx_cmd = (struct iwl_tx_cmd *)dev_cmd->payload;
 
 	/* Copy MAC header from skb into command buffer */
-	memcpy(tx_cmd->hdr, hdr, ieee80211_hdrlen(hdr->frame_control));
+	memcpy(tx_cmd->hdr, hdr, hdrlen);
 
 	if (iwl_trans_tx(mvm->trans, skb, dev_cmd, info->hw_queue)) {
 		iwl_trans_free_tx_cmd(mvm->trans, dev_cmd);
@@ -427,9 +437,11 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 	u8 tid = IWL_MAX_TID_COUNT;
 	u8 txq_id = info->hw_queue;
 	bool is_data_qos = false, is_ampdu = false;
+	int hdrlen;
 
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	fc = hdr->frame_control;
+	hdrlen = ieee80211_hdrlen(fc);
 
 	if (WARN_ON_ONCE(!mvmsta))
 		return -1;
@@ -437,7 +449,7 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (WARN_ON_ONCE(mvmsta->sta_id == IWL_MVM_STATION_COUNT))
 		return -1;
 
-	dev_cmd = iwl_mvm_set_tx_params(mvm, skb, sta, mvmsta->sta_id);
+	dev_cmd = iwl_mvm_set_tx_params(mvm, skb, hdrlen, sta, mvmsta->sta_id);
 	if (!dev_cmd)
 		goto drop;
 
@@ -469,7 +481,7 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 	}
 
 	/* Copy MAC header from skb into command buffer */
-	memcpy(tx_cmd->hdr, hdr, ieee80211_hdrlen(fc));
+	memcpy(tx_cmd->hdr, hdr, hdrlen);
 
 	WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM);
 
-- 
2.1.4

