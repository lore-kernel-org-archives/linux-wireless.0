Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083AbbHDU7P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:15 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/37] iwlwifi: mvm: move TX PN assignment for CCMP to the driver
Date: Tue,  4 Aug 2015 23:43:22 +0300
Message-Id: <1438721007-23283-32-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_225931_478966_7FF1F5CF)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
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
 drivers/net/wireless/iwlwifi/mvm/tx.c       | 41 +++++++++++++++++++----------
 4 files changed, 50 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 4264c52..5a4bf84 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2873,10 +2873,11 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
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
index c1f84ec..95f326d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1000,10 +1000,6 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb);
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
@@ -1015,6 +1011,17 @@ static inline const char *iwl_mvm_get_tx_fail_reason(u32 status) { return ""; }
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
index fa3eaf9..eac511a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -268,19 +268,29 @@ void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
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
+	case WLAN_CIPHER_SUITE_CCMP_256:
+		iwl_mvm_set_tx_cmd_ccmp(info, tx_cmd);
+		pn = atomic64_inc_return(&keyconf->tx_pn);
+		crypto_hdr[0] = pn;
+		crypto_hdr[2] = 0;
+		crypto_hdr[3] = 0x20 | (keyconf->keyidx << 6);
+		crypto_hdr[1] = pn >> 8;
+		crypto_hdr[4] = pn >> 16;
+		crypto_hdr[5] = pn >> 24;
+		crypto_hdr[6] = pn >> 32;
+		crypto_hdr[7] = pn >> 40;
 		break;
 
 	case WLAN_CIPHER_SUITE_TKIP:
@@ -308,7 +318,7 @@ void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
  */
 static struct iwl_device_cmd *
 iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
-		      struct ieee80211_sta *sta, u8 sta_id)
+		      int hdrlen, struct ieee80211_sta *sta, u8 sta_id)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -325,7 +335,7 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 	tx_cmd = (struct iwl_tx_cmd *)dev_cmd->payload;
 
 	if (info->control.hw_key)
-		iwl_mvm_set_tx_cmd_crypto(mvm, info, tx_cmd, skb);
+		iwl_mvm_set_tx_cmd_crypto(mvm, info, tx_cmd, skb, hdrlen);
 
 	iwl_mvm_set_tx_cmd(mvm, skb, tx_cmd, info, sta_id);
 
@@ -346,6 +356,7 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	struct iwl_device_cmd *dev_cmd;
 	struct iwl_tx_cmd *tx_cmd;
 	u8 sta_id;
+	int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 	if (WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_AMPDU))
 		return -1;
@@ -393,7 +404,7 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 
 	IWL_DEBUG_TX(mvm, "station Id %d, queue=%d\n", sta_id, info->hw_queue);
 
-	dev_cmd = iwl_mvm_set_tx_params(mvm, skb, NULL, sta_id);
+	dev_cmd = iwl_mvm_set_tx_params(mvm, skb, hdrlen, NULL, sta_id);
 	if (!dev_cmd)
 		return -1;
 
@@ -401,7 +412,7 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	tx_cmd = (struct iwl_tx_cmd *)dev_cmd->payload;
 
 	/* Copy MAC header from skb into command buffer */
-	memcpy(tx_cmd->hdr, hdr, ieee80211_hdrlen(hdr->frame_control));
+	memcpy(tx_cmd->hdr, hdr, hdrlen);
 
 	if (iwl_trans_tx(mvm->trans, skb, dev_cmd, info->hw_queue)) {
 		iwl_trans_free_tx_cmd(mvm->trans, dev_cmd);
@@ -427,9 +438,11 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 	u8 tid = IWL_MAX_TID_COUNT;
 	u8 txq_id = info->hw_queue;
 	bool is_data_qos = false, is_ampdu = false;
+	int hdrlen;
 
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	fc = hdr->frame_control;
+	hdrlen = ieee80211_hdrlen(fc);
 
 	if (WARN_ON_ONCE(!mvmsta))
 		return -1;
@@ -437,7 +450,7 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (WARN_ON_ONCE(mvmsta->sta_id == IWL_MVM_STATION_COUNT))
 		return -1;
 
-	dev_cmd = iwl_mvm_set_tx_params(mvm, skb, sta, mvmsta->sta_id);
+	dev_cmd = iwl_mvm_set_tx_params(mvm, skb, hdrlen, sta, mvmsta->sta_id);
 	if (!dev_cmd)
 		goto drop;
 
@@ -469,7 +482,7 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 	}
 
 	/* Copy MAC header from skb into command buffer */
-	memcpy(tx_cmd->hdr, hdr, ieee80211_hdrlen(fc));
+	memcpy(tx_cmd->hdr, hdr, hdrlen);
 
 	WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM);
 
-- 
2.1.4

