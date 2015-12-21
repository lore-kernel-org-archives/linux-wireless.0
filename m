Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbbLUUwM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:12 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/45] iwlwifi: mvm: prepare the code towards TSO implementation
Date: Mon, 21 Dec 2015 22:50:26 +0200
Message-Id: <1450731046-2796-25-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215219_653221_FD637C4A)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Differentiate between the cases where the skb is a large
send and the other cases.
Advertise TSO even if, at this stage, skb_gso_segment will
be called and it will do all the work.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 78 ++++++++++++++++++++++-
 2 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 0227b29..d239e97 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -668,7 +668,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->netdev_features &= ~NETIF_F_RXCSUM;
 
 	if (IWL_MVM_SW_TX_CSUM_OFFLOAD)
-		hw->netdev_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		hw->netdev_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+			NETIF_F_TSO | NETIF_F_TSO6;
 
 	ret = ieee80211_register_hw(mvm->hw);
 	if (ret)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 4d13df1..04e921f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -64,6 +64,7 @@
  *****************************************************************************/
 #include <linux/ieee80211.h>
 #include <linux/etherdevice.h>
+#include <linux/tcp.h>
 
 #include "iwl-trans.h"
 #include "iwl-eeprom-parse.h"
@@ -425,11 +426,39 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	return 0;
 }
 
+static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb_gso,
+			  struct ieee80211_sta *sta,
+			  struct sk_buff_head *mpdus_skb)
+{
+	struct sk_buff *tmp, *next;
+	char cb[sizeof(skb_gso->cb)];
+
+	memcpy(cb, skb_gso->cb, sizeof(cb));
+	next = skb_gso_segment(skb_gso, 0);
+	if (IS_ERR(next))
+		return -EINVAL;
+	else if (next)
+		consume_skb(skb_gso);
+
+	while (next) {
+		tmp = next;
+		next = tmp->next;
+		memcpy(tmp->cb, cb, sizeof(tmp->cb));
+
+		tmp->prev = NULL;
+		tmp->next = NULL;
+
+		__skb_queue_tail(mpdus_skb, tmp);
+	}
+
+	return 0;
+}
+
 /*
  * Sets the fields in the Tx cmd that are crypto related
  */
-int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
-		   struct ieee80211_sta *sta)
+static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
+			   struct ieee80211_sta *sta)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -525,6 +554,51 @@ drop:
 	return -1;
 }
 
+int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
+		   struct ieee80211_sta *sta)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct sk_buff_head mpdus_skbs;
+	unsigned int payload_len;
+	int ret;
+
+	if (WARN_ON_ONCE(!mvmsta))
+		return -1;
+
+	if (WARN_ON_ONCE(mvmsta->sta_id == IWL_MVM_STATION_COUNT))
+		return -1;
+
+	if (!skb_is_gso(skb))
+		return iwl_mvm_tx_mpdu(mvm, skb, sta);
+
+	payload_len = skb_tail_pointer(skb) - skb_transport_header(skb) -
+		tcp_hdrlen(skb) + skb->data_len;
+
+	if (payload_len <= skb_shinfo(skb)->gso_size)
+		return iwl_mvm_tx_mpdu(mvm, skb, sta);
+
+	__skb_queue_head_init(&mpdus_skbs);
+
+	ret = iwl_mvm_tx_tso(mvm, skb, sta, &mpdus_skbs);
+	if (ret)
+		return ret;
+
+	if (WARN_ON(skb_queue_empty(&mpdus_skbs)))
+		return ret;
+
+	while (!skb_queue_empty(&mpdus_skbs)) {
+		struct sk_buff *skb = __skb_dequeue(&mpdus_skbs);
+
+		ret = iwl_mvm_tx_mpdu(mvm, skb, sta);
+		if (ret) {
+			__skb_queue_purge(&mpdus_skbs);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static void iwl_mvm_check_ratid_empty(struct iwl_mvm *mvm,
 				      struct ieee80211_sta *sta, u8 tid)
 {
-- 
2.5.0

