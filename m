Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:23612 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935604AbcCQND2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 09:03:28 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211: fix cipher scheme function name
Date: Thu, 17 Mar 2016 15:02:55 +0200
Message-Id: <1458219775-24450-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160317_140333_311856_5C9C3653)
In-Reply-To: <1458219775-24450-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1458219775-24450-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code is only used with iwlwifi, but still should have proper
mac80211 naming scheme; fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3746ba5..57a0ccd 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -722,8 +722,8 @@ static int ieee80211_get_mmie_keyidx(struct sk_buff *skb)
 	return -1;
 }
 
-static int iwl80211_get_cs_keyid(const struct ieee80211_cipher_scheme *cs,
-				 struct sk_buff *skb)
+static int ieee80211_get_cs_keyid(const struct ieee80211_cipher_scheme *cs,
+				  struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc;
@@ -1586,7 +1586,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 
 		if (ieee80211_has_protected(fc) && rx->sta->cipher_scheme) {
 			cs = rx->sta->cipher_scheme;
-			keyid = iwl80211_get_cs_keyid(cs, rx->skb);
+			keyid = ieee80211_get_cs_keyid(cs, rx->skb);
 			if (unlikely(keyid < 0))
 				return RX_DROP_UNUSABLE;
 		}
@@ -1670,7 +1670,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		hdrlen = ieee80211_hdrlen(fc);
 
 		if (cs) {
-			keyidx = iwl80211_get_cs_keyid(cs, rx->skb);
+			keyidx = ieee80211_get_cs_keyid(cs, rx->skb);
 
 			if (unlikely(keyidx < 0))
 				return RX_DROP_UNUSABLE;
-- 
2.5.0

