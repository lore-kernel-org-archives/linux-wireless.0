Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53036 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751884AbdFUXu0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 19:50:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 4/6] mac80211: don't put null-data frames on the normal TXQ
Date: Thu, 22 Jun 2017 01:50:20 +0200
Message-Id: <20170621235022.25362-4-johannes@sipsolutions.net> (sfid-20170622_015029_401105_5DD7E2F0)
In-Reply-To: <20170621235022.25362-1-johannes@sipsolutions.net>
References: <20170621235022.25362-1-johannes@sipsolutions.net>
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
index 1b3ac635fbdd..d2a91594312d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1252,7 +1252,7 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
 		return NULL;
 
-	if (!ieee80211_is_data(hdr->frame_control)) {
+	if (!ieee80211_is_data_present(hdr->frame_control)) {
 		if ((!ieee80211_is_mgmt(hdr->frame_control) ||
 		     ieee80211_is_bufferable_mmpdu(hdr->frame_control)) &&
 		    sta && sta->uploaded)
-- 
2.11.0
