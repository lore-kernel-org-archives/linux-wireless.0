Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:13169 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab2GDQLj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 12:11:39 -0400
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211: restructure key selection
Date: Wed,  4 Jul 2012 18:10:07 +0200
Message-Id: <1341418208-28663-1-git-send-email-cavallar@lri.fr> (sfid-20120704_181142_733964_3723E132)
In-Reply-To: <1341408545.12432.10.camel@jlt3.sipsolutions.net>
References: <1341408545.12432.10.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The "no key" case in key selection that decides
whether to drop the frame or not is impossible
to understand, restructure the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[cavallar@lri.fr: removed blank line and restructured action frame clause]
Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>
---
 net/mac80211/tx.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4990f4f..cdd4ac6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -523,7 +523,7 @@ ieee80211_tx_h_check_control_port_protocol(struct ieee80211_tx_data *tx)
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_key *key = NULL;
+	struct ieee80211_key *key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
@@ -542,16 +542,20 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	else if (!is_multicast_ether_addr(hdr->addr1) &&
 		 (key = rcu_dereference(tx->sdata->default_unicast_key)))
 		tx->key = key;
-	else if (tx->sdata->drop_unencrypted &&
-		 (tx->skb->protocol != tx->sdata->control_port_protocol) &&
-		 !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
-		 (!ieee80211_is_robust_mgmt_frame(hdr) ||
-		  (ieee80211_is_action(hdr->frame_control) &&
-		   tx->sta && test_sta_flag(tx->sta, WLAN_STA_MFP)))) {
+	else if (info->flags & IEEE80211_TX_CTL_INJECTED)
+		tx->key = NULL;
+	else if (!tx->sdata->drop_unencrypted)
+		tx->key = NULL;
+	else if (tx->skb->protocol == tx->sdata->control_port_protocol)
+		tx->key = NULL;
+	else if (ieee80211_is_robust_mgmt_frame(hdr) &&
+		 !(ieee80211_is_action(hdr->frame_control) &&
+		  tx->sta && test_sta_flag(tx->sta, WLAN_STA_MFP)))
+		tx->key = NULL;
+	else {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
 		return TX_DROP;
-	} else
-		tx->key = NULL;
+	}
 
 	if (tx->key) {
 		bool skip_hw = false;
-- 
1.7.10.4

