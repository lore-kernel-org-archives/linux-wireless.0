Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34400 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751090AbdFTVFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2017 17:05:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: don't put null-data frames on the normal TXQ
Date: Tue, 20 Jun 2017 23:05:27 +0200
Message-Id: <20170620210527.2298-1-johannes@sipsolutions.net> (sfid-20170620_230533_996028_855E0484)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since (QoS) NDP frames shouldn't be put into aggregation nor are
assigned real sequence numbers, etc. it's better to treat them as
non-data packets and not put them on the normal TXQs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d1cef5ad91ee..726fb3b02a23 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1256,7 +1256,7 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 		return NULL;
 	} else if (!sta) {
 		txq = vif->txq;
-	} else if (!ieee80211_is_data(hdr->frame_control)) {
+	} else if (!ieee80211_is_data_present(hdr->frame_control)) {
 		if (!sta->uploaded)
 			return NULL;
 
-- 
2.11.0
