Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36950 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932196AbdABKYa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 05:24:30 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: initialize fast-xmit 'info' later
Date: Mon,  2 Jan 2017 11:24:26 +0100
Message-Id: <20170102102426.15121-1-johannes@sipsolutions.net> (sfid-20170102_112432_877167_E1F796B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In ieee80211_xmit_fast(), 'info' is initialized to point to the skb
that's passed in, but that skb may later be replaced by a clone (if
it was shared), leading to an invalid pointer.

This can lead to use-after-free and also later crashes since the
real SKB's info->hw_queue doesn't get initialized properly.

Fix this by assigning info only later, when it's needed, after the
skb replacement (may have) happened.

Cc: stable@vger.kernel.org
Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4dea18be385c..3182e0c4e157 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3288,7 +3288,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	int extra_head = fast_tx->hdr_len - (ETH_HLEN - 2);
 	int hw_headroom = sdata->local->hw.extra_tx_headroom;
 	struct ethhdr eth;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_info *info;
 	struct ieee80211_hdr *hdr = (void *)fast_tx->hdr;
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result r;
@@ -3352,6 +3352,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	memcpy(skb->data + fast_tx->da_offs, eth.h_dest, ETH_ALEN);
 	memcpy(skb->data + fast_tx->sa_offs, eth.h_source, ETH_ALEN);
 
+	info = IEEE80211_SKB_CB(skb);
 	memset(info, 0, sizeof(*info));
 	info->band = fast_tx->band;
 	info->control.vif = &sdata->vif;
-- 
2.9.3
