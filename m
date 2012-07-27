Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51443 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab2G0LRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 09/20] mac80211: remove almost unused local variable
Date: Fri, 27 Jul 2012 13:16:45 +0200
Message-Id: <1343387816-9414-10-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131733_449746_35DA8F7E)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In ieee80211_beacon_get_tim() we can use the
txrc.sband instead of a separate local variable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 385c280..7da1fa5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2299,12 +2299,9 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	struct ieee80211_sub_if_data *sdata = NULL;
 	struct ieee80211_if_ap *ap = NULL;
 	struct beacon_data *beacon;
-	struct ieee80211_supported_band *sband;
 	enum ieee80211_band band = local->oper_channel->band;
 	struct ieee80211_tx_rate_control txrc;
 
-	sband = local->hw.wiphy->bands[band];
-
 	rcu_read_lock();
 
 	sdata = vif_to_sdata(vif);
@@ -2451,12 +2448,12 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 
 	memset(&txrc, 0, sizeof(txrc));
 	txrc.hw = hw;
-	txrc.sband = sband;
+	txrc.sband = local->hw.wiphy->bands[band];
 	txrc.bss_conf = &sdata->vif.bss_conf;
 	txrc.skb = skb;
 	txrc.reported_rate.idx = -1;
 	txrc.rate_idx_mask = sdata->rc_rateidx_mask[band];
-	if (txrc.rate_idx_mask == (1 << sband->n_bitrates) - 1)
+	if (txrc.rate_idx_mask == (1 << txrc.sband->n_bitrates) - 1)
 		txrc.max_rate_idx = -1;
 	else
 		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
-- 
1.7.10.4

