Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42141 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbcCaREP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 13:04:15 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 01/10] mac80211: allow passing transmitter station on RX
Date: Thu, 31 Mar 2016 20:02:02 +0300
Message-Id: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160331_190418_558002_F59AF2AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Sometimes drivers already looked up, or know out-of-band
from their device, which station transmitted a given RX
frame. Allow them to pass the station pointer to mac80211
to save the extra lookup.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     |  2 +-
 include/net/mac80211.h                            |  7 ++++---
 net/mac80211/rx.c                                 | 18 +++++++++++++-----
 6 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index 52ab1e0..27ea61e 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -686,7 +686,7 @@ static void iwlagn_pass_packet_to_mac80211(struct iwl_priv *priv,
 
 	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
 
-	ieee80211_rx_napi(priv->hw, skb, priv->napi);
+	ieee80211_rx_napi(priv->hw, NULL, skb, priv->napi);
 }
 
 static u32 iwlagn_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 535134d..4918d5e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1497,5 +1497,5 @@ void iwl_mvm_rx_stored_beacon_notif(struct iwl_mvm *mvm,
 	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
 
 	/* pass it as regular rx to mac80211 */
-	ieee80211_rx_napi(mvm->hw, skb, NULL);
+	ieee80211_rx_napi(mvm->hw, NULL, skb, NULL);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 145ec68..29dbfaf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -130,7 +130,7 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 				fraglen, rxb->truesize);
 	}
 
-	ieee80211_rx_napi(mvm->hw, skb, napi);
+	ieee80211_rx_napi(mvm->hw, NULL, skb, napi);
 }
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 615dea1..00d90e9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -194,7 +194,7 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 	if (iwl_mvm_check_pn(mvm, skb, queue, sta))
 		kfree_skb(skb);
 	else
-		ieee80211_rx_napi(mvm->hw, skb, napi);
+		ieee80211_rx_napi(mvm->hw, NULL, skb, napi);
 }
 
 static void iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6e34675..fd5ec44 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3855,11 +3855,12 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw);
  * This function must be called with BHs disabled.
  *
  * @hw: the hardware this frame came in on
+ * @sta: the station the frame was received from, or %NULL
  * @skb: the buffer to receive, owned by mac80211 after this call
  * @napi: the NAPI context
  */
-void ieee80211_rx_napi(struct ieee80211_hw *hw, struct sk_buff *skb,
-		       struct napi_struct *napi);
+void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+		       struct sk_buff *skb, struct napi_struct *napi);
 
 /**
  * ieee80211_rx - receive frame
@@ -3883,7 +3884,7 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct sk_buff *skb,
  */
 static inline void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
-	ieee80211_rx_napi(hw, skb, NULL);
+	ieee80211_rx_napi(hw, NULL, skb, NULL);
 }
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 57a0ccd..6c3829d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3533,6 +3533,7 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
  * be called with rcu_read_lock protection.
  */
 static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
+					 struct ieee80211_sta *pubsta,
 					 struct sk_buff *skb,
 					 struct napi_struct *napi)
 {
@@ -3542,7 +3543,6 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	__le16 fc;
 	struct ieee80211_rx_data rx;
 	struct ieee80211_sub_if_data *prev;
-	struct sta_info *sta, *prev_sta;
 	struct rhash_head *tmp;
 	int err = 0;
 
@@ -3578,7 +3578,14 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		     ieee80211_is_beacon(hdr->frame_control)))
 		ieee80211_scan_rx(local, skb);
 
-	if (ieee80211_is_data(fc)) {
+	if (pubsta) {
+		rx.sta = container_of(pubsta, struct sta_info, sta);
+		rx.sdata = rx.sta->sdata;
+		if (ieee80211_prepare_and_rx_handle(&rx, skb, true))
+			return;
+		goto out;
+	} else if (ieee80211_is_data(fc)) {
+		struct sta_info *sta, *prev_sta;
 		const struct bucket_table *tbl;
 
 		prev_sta = NULL;
@@ -3652,8 +3659,8 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
  * This is the receive path handler. It is called by a low level driver when an
  * 802.11 MPDU is received from the hardware.
  */
-void ieee80211_rx_napi(struct ieee80211_hw *hw, struct sk_buff *skb,
-		       struct napi_struct *napi)
+void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
+		       struct sk_buff *skb, struct napi_struct *napi)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate = NULL;
@@ -3752,7 +3759,8 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct sk_buff *skb,
 	ieee80211_tpt_led_trig_rx(local,
 			((struct ieee80211_hdr *)skb->data)->frame_control,
 			skb->len);
-	__ieee80211_rx_handle_packet(hw, skb, napi);
+
+	__ieee80211_rx_handle_packet(hw, pubsta, skb, napi);
 
 	rcu_read_unlock();
 
-- 
2.5.0

