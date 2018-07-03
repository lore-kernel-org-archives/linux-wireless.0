Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:43928 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752686AbeGCMrc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 08:47:32 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't put null-data frames on the normal TXQ
Date: Tue,  3 Jul 2018 14:47:25 +0200
Message-Id: <20180703124725.30917-1-johannes@sipsolutions.net> (sfid-20180703_144735_517894_2ED1606E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since (QoS) NDP frames shouldn't be put into aggregation nor are
assigned real sequence numbers, etc. it's better to treat them as
non-data packets and not put them on the normal TXQs, for example
when building A-MPDUs they need to be treated specially, and they
are more used for management (e.g. to see if the station is alive)
anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index fa1f1e63a264..5a60832052dc 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1247,7 +1247,7 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
 		return NULL;
 
-	if (!ieee80211_is_data(hdr->frame_control))
+	if (!ieee80211_is_data_present(hdr->frame_control))
 		return NULL;
 
 	if (sta) {
-- 
2.14.4
