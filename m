Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab3CDQnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 11:43:00 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: provide ieee80211_sta_eosp()
Date: Mon,  4 Mar 2013 17:42:54 +0100
Message-Id: <1362415374-25460-1-git-send-email-johannes@sipsolutions.net> (sfid-20130304_174314_786594_53C4E86E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The irqsafe version ieee80211_sta_eosp_irqsafe() exists, but
drivers must not mix calls to any irqsafe/non-irqsafe function.
Both ath9k and iwlwifi, the likely first users of this interface,
use non-irqsafe RX/TX/TX status so must also use a non-irqsafe
version of this function. Since no driver uses the _irqsafe()
version, remove that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     | 19 +++++++++++--------
 net/mac80211/ieee80211_i.h |  5 -----
 net/mac80211/main.c        | 14 --------------
 net/mac80211/sta_info.c    | 20 +++-----------------
 4 files changed, 14 insertions(+), 44 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e48ff2e..3161675 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3862,14 +3862,17 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
  * %IEEE80211_TX_STATUS_EOSP bit and call this function instead.
  * This applies for PS-Poll as well as uAPSD.
  *
- * Note that there is no non-_irqsafe version right now as
- * it wasn't needed, but just like _tx_status() and _rx()
- * must not be mixed in irqsafe/non-irqsafe versions, this
- * function must not be mixed with those either. Use the
- * all irqsafe, or all non-irqsafe, don't mix! If you need
- * the non-irqsafe version of this, you need to add it.
- */
-void ieee80211_sta_eosp_irqsafe(struct ieee80211_sta *pubsta);
+ * Note that just like with _tx_status() and _rx() drivers must
+ * not mix calls to irqsafe/non-irqsafe versions, this function
+ * must not be mixed with those either. Use the all irqsafe, or
+ * all non-irqsafe, don't mix!
+ *
+ * NB: the _irqsafe version of this function doesn't exist, no
+ *     driver needs it right now. Don't call this function if
+ *     you'd need the _irqsafe version, look at the git history
+ *     and restore the _irqsafe version!
+ */
+void ieee80211_sta_eosp(struct ieee80211_sta *pubsta);
 
 /**
  * ieee80211_iter_keys - iterate keys programmed into the device
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a58c033..2f3ba09 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -799,11 +799,6 @@ enum sdata_queue_type {
 enum {
 	IEEE80211_RX_MSG	= 1,
 	IEEE80211_TX_STATUS_MSG	= 2,
-	IEEE80211_EOSP_MSG	= 3,
-};
-
-struct skb_eosp_msg_data {
-	u8 sta[ETH_ALEN], iface[ETH_ALEN];
 };
 
 enum queue_stop_reason {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6f429f3..5b0753e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -226,8 +226,6 @@ u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata)
 static void ieee80211_tasklet_handler(unsigned long data)
 {
 	struct ieee80211_local *local = (struct ieee80211_local *) data;
-	struct sta_info *sta, *tmp;
-	struct skb_eosp_msg_data *eosp_data;
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
@@ -243,18 +241,6 @@ static void ieee80211_tasklet_handler(unsigned long data)
 			skb->pkt_type = 0;
 			ieee80211_tx_status(&local->hw, skb);
 			break;
-		case IEEE80211_EOSP_MSG:
-			eosp_data = (void *)skb->cb;
-			for_each_sta_info(local, eosp_data->sta, sta, tmp) {
-				/* skip wrong virtual interface */
-				if (memcmp(eosp_data->iface,
-					   sta->sdata->vif.addr, ETH_ALEN))
-					continue;
-				clear_sta_flag(sta, WLAN_STA_SP);
-				break;
-			}
-			dev_kfree_skb(skb);
-			break;
 		default:
 			WARN(1, "mac80211: Packet is of unknown type %d\n",
 			     skb->pkt_type);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 0141e49..0f975e6 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1385,30 +1385,16 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_sta_block_awake);
 
-void ieee80211_sta_eosp_irqsafe(struct ieee80211_sta *pubsta)
+void ieee80211_sta_eosp(struct ieee80211_sta *pubsta)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	struct ieee80211_local *local = sta->local;
-	struct sk_buff *skb;
-	struct skb_eosp_msg_data *data;
 
 	trace_api_eosp(local, pubsta);
 
-	skb = alloc_skb(0, GFP_ATOMIC);
-	if (!skb) {
-		/* too bad ... but race is better than loss */
-		clear_sta_flag(sta, WLAN_STA_SP);
-		return;
-	}
-
-	data = (void *)skb->cb;
-	memcpy(data->sta, pubsta->addr, ETH_ALEN);
-	memcpy(data->iface, sta->sdata->vif.addr, ETH_ALEN);
-	skb->pkt_type = IEEE80211_EOSP_MSG;
-	skb_queue_tail(&local->skb_queue, skb);
-	tasklet_schedule(&local->tasklet);
+	clear_sta_flag(sta, WLAN_STA_SP);
 }
-EXPORT_SYMBOL(ieee80211_sta_eosp_irqsafe);
+EXPORT_SYMBOL(ieee80211_sta_eosp);
 
 void ieee80211_sta_set_buffered(struct ieee80211_sta *pubsta,
 				u8 tid, bool buffered)
-- 
1.8.0

