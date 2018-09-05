Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:41194 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbeIEM3q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 08:29:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use non-zero TID only for QoS frames
Date: Wed,  5 Sep 2018 10:00:36 +0200
Message-Id: <20180905080036.9177-1-johannes@sipsolutions.net> (sfid-20180905_100116_813934_EDA72491)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some frames may have a non-zero skb->priority assigned by
mac80211 internally, e.g. TDLS setup frames, regardless of
support for QoS.

Currently, we set skb->priority to 0 for all data frames.
Note that there's a comment that this is "required for
correct WPA/11i MIC", but that doesn't seem true as we use

        if (ieee80211_is_data_qos(hdr->frame_control))
                qos_tid = ieee80211_get_tid(hdr);
        else
                qos_tid = 0;

in the code there. We could therefore reconsider this, but
it seems like unnecessary complexity for the unlikely (and
not very useful) case of not having QoS on the connection.

This situation then causes something strange - most data
frames will go on TXQ for TID 0 for non-QoS connections,
but very few exceptions that are internally generated will
go on another TXQ, possibly causing confusion.

Avoid this confusion by putting non-QoS data frames into
TID 0 regardless of the skb->priority.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5b6e06ad35ff..6540595addd1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1260,7 +1260,10 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 			txq = sta->sta.txq[IEEE80211_NUM_TIDS];
 		}
 	} else if (sta) {
-		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
+		u8 tid = 0;
+
+		if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA))
+			tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 
 		if (!sta->uploaded)
 			return NULL;
-- 
2.14.4
