Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36661 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933000AbdBVPQO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Feb 2017 10:16:14 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: don't handle filtered frames within a BA session
Date: Wed, 22 Feb 2017 16:16:07 +0100
Message-Id: <20170222151607.80472-1-nbd@nbd.name> (sfid-20170222_161705_204861_28B0FB2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running a BA session, the driver (or the hardware) already takes
care of retransmitting failed frames, since it has to keep the receiver
reorder window in sync.

Adding another layer of retransmit around that does not improve
anything. In fact, it can only lead to some strong reordering with huge
latency.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/status.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index b6a5394fa4c4..9d19d8698ac0 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -51,7 +51,8 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	int ac;
 
-	if (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER) {
+	if (info->flags & (IEEE80211_TX_CTL_NO_PS_BUFFER |
+			   IEEE80211_TX_CTL_AMPDU)) {
 		ieee80211_free_txskb(&local->hw, skb);
 		return;
 	}
-- 
2.11.0
