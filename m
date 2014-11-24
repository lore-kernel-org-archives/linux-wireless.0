Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:44530 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaKXOfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:04 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so5948674wiw.16
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:02 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/75] iwlwifi: mvm: expose some static APIs for use by TDLS code
Date: Mon, 24 Nov 2014 16:33:40 +0200
Message-Id: <1416839691-28533-4-git-send-email-egrumbach@gmail.com> (sfid-20141124_153510_837335_34523171)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Mostly functions related to building Tx-commands for sending to FW.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 12 ++++++++++++
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/tx.c       | 22 ++++++++++------------
 3 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 256765a..1fc94e1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -831,6 +831,16 @@ int __must_check iwl_mvm_send_cmd_pdu_status(struct iwl_mvm *mvm, u8 id,
 int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 		   struct ieee80211_sta *sta);
 int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb);
+void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
+			struct iwl_tx_cmd *tx_cmd,
+			struct ieee80211_tx_info *info, u8 sta_id);
+void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
+			       struct ieee80211_tx_info *info,
+			       struct iwl_tx_cmd *tx_cmd,
+			       struct sk_buff *skb_frag);
+void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
+			    struct ieee80211_tx_info *info,
+			    struct ieee80211_sta *sta, __le16 fc);
 #ifdef CONFIG_IWLWIFI_DEBUG
 const char *iwl_mvm_get_tx_fail_reason(u32 status);
 #else
@@ -900,6 +910,8 @@ void iwl_mvm_phy_ctxt_ref(struct iwl_mvm *mvm,
 void iwl_mvm_phy_ctxt_unref(struct iwl_mvm *mvm,
 			    struct iwl_mvm_phy_ctxt *ctxt);
 int iwl_mvm_phy_ctx_count(struct iwl_mvm *mvm);
+u8 iwl_mvm_get_channel_width(struct cfg80211_chan_def *chandef);
+u8 iwl_mvm_get_ctrl_pos(struct cfg80211_chan_def *chandef);
 
 /* MAC (virtual interface) programming */
 int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index 12283b5..1c0d4a4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -68,7 +68,7 @@
 #include "mvm.h"
 
 /* Maps the driver specific channel width definition to the the fw values */
-static inline u8 iwl_mvm_get_channel_width(struct cfg80211_chan_def *chandef)
+u8 iwl_mvm_get_channel_width(struct cfg80211_chan_def *chandef)
 {
 	switch (chandef->width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
@@ -90,7 +90,7 @@ static inline u8 iwl_mvm_get_channel_width(struct cfg80211_chan_def *chandef)
  * Maps the driver specific control channel position (relative to the center
  * freq) definitions to the the fw values
  */
-static inline u8 iwl_mvm_get_ctrl_pos(struct cfg80211_chan_def *chandef)
+u8 iwl_mvm_get_ctrl_pos(struct cfg80211_chan_def *chandef)
 {
 	switch (chandef->chan->center_freq - chandef->center_freq1) {
 	case -70:
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 8d84873..4789c77 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -73,9 +73,9 @@
 /*
  * Sets most of the Tx cmd's fields
  */
-static void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
-			       struct iwl_tx_cmd *tx_cmd,
-			       struct ieee80211_tx_info *info, u8 sta_id)
+void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
+			struct iwl_tx_cmd *tx_cmd,
+			struct ieee80211_tx_info *info, u8 sta_id)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	__le16 fc = hdr->frame_control;
@@ -149,11 +149,9 @@ static void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 /*
  * Sets the fields in the Tx cmd that are rate related
  */
-static void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm,
-				    struct iwl_tx_cmd *tx_cmd,
-				    struct ieee80211_tx_info *info,
-				    struct ieee80211_sta *sta,
-				    __le16 fc)
+void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
+			    struct ieee80211_tx_info *info,
+			    struct ieee80211_sta *sta, __le16 fc)
 {
 	u32 rate_flags;
 	int rate_idx;
@@ -232,10 +230,10 @@ static void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm,
 /*
  * Sets the fields in the Tx cmd that are crypto related
  */
-static void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
-				      struct ieee80211_tx_info *info,
-				      struct iwl_tx_cmd *tx_cmd,
-				      struct sk_buff *skb_frag)
+void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
+			       struct ieee80211_tx_info *info,
+			       struct iwl_tx_cmd *tx_cmd,
+			       struct sk_buff *skb_frag)
 {
 	struct ieee80211_key_conf *keyconf = info->control.hw_key;
 
-- 
1.9.1

