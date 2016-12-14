Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54209 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756510AbcLNTrM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 14:47:12 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas.huehn@evernet-eg.de
Subject: [PATCH 04/10] mac80211: check for MCS in ieee80211_duration before fetching chanctx
Date: Wed, 14 Dec 2016 20:46:57 +0100
Message-Id: <20161214194703.33429-4-nbd@nbd.name> (sfid-20161214_204724_712238_B0EF9543)
In-Reply-To: <20161214194703.33429-1-nbd@nbd.name>
References: <20161214194703.33429-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Makes the code a bit more efficient

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 058652d..4dea18b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -64,6 +64,10 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	u32 rate_flags = 0;
 
+	/* assume HW handles this */
+	if (tx->rate.flags & (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_VHT_MCS))
+		return 0;
+
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(tx->sdata->vif.chanctx_conf);
 	if (chanctx_conf) {
@@ -72,10 +76,6 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 	}
 	rcu_read_unlock();
 
-	/* assume HW handles this */
-	if (tx->rate.flags & (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_VHT_MCS))
-		return 0;
-
 	/* uh huh? */
 	if (WARN_ON_ONCE(tx->rate.idx < 0))
 		return 0;
-- 
2.10.1
