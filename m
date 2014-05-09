Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44356 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756505AbaEILMJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 07:12:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	andrei.otcheretianski@intel.com
Date: Fri,  9 May 2014 14:11:45 +0300
Message-Id: <1399633911-12788-3-git-send-email-luca@coelho.fi> (sfid-20140509_131234_991038_D6BBF815)
In-Reply-To: <1399633911-12788-1-git-send-email-luca@coelho.fi>
References: <1399633911-12788-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 2/8] mac80211: Update CSA counters in mgmt frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Track current csa counter value and use it
to update mgmt frames at the provided offsets.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c         | 16 +++++++++++++++-
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/tx.c          |  5 +++--
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7c56445..86c20a8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3338,6 +3338,7 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	sdata->csa_radar_required = params->radar_required;
 	sdata->csa_chandef = params->chandef;
 	sdata->csa_block_tx = params->block_tx;
+	sdata->csa_current_counter = params->count;
 	sdata->vif.csa_active = true;
 
 	if (sdata->csa_block_tx)
@@ -3382,6 +3383,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	bool need_offchan = false;
 	u32 flags;
 	int ret;
+	u8 *data;
 
 	if (params->dont_wait_for_ack)
 		flags = IEEE80211_TX_CTL_NO_ACK;
@@ -3475,8 +3477,20 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 
-	memcpy(skb_put(skb, params->len), params->buf, params->len);
+	data = skb_put(skb, params->len);
+	memcpy(data, params->buf, params->len);
 
+	/* Update CSA counters*/
+	if (sdata->vif.csa_active &&
+	    (sdata->vif.type == NL80211_IFTYPE_AP ||
+	     sdata->vif.type == NL80211_IFTYPE_ADHOC) &&
+	    params->n_csa_offsets) {
+		int i;
+
+		for (i = 0; i < params->n_csa_offsets; i++)
+			data[params->csa_offsets[i]] =
+					sdata->csa_current_counter;
+	}
 	IEEE80211_SKB_CB(skb)->flags = flags;
 
 	skb->dev = sdata->dev;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4668ce9..fb2d9e7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -766,6 +766,7 @@ struct ieee80211_sub_if_data {
 	struct ieee80211_chanctx *reserved_chanctx;
 	struct cfg80211_chan_def reserved_chandef;
 	bool reserved_radar_required;
+	u8 csa_current_counter;
 
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 19d36d4..263dea5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2449,7 +2449,8 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
 	if (WARN_ON(beacon_data[counter_offset_beacon] == 1))
 		return;
 
-	beacon_data[counter_offset_beacon]--;
+	sdata->csa_current_counter--;
+	beacon_data[counter_offset_beacon] = sdata->csa_current_counter;
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP && counter_offset_presp) {
 		rcu_read_lock();
@@ -2460,7 +2461,7 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
 			rcu_read_unlock();
 			return;
 		}
-		resp->data[counter_offset_presp]--;
+		resp->data[counter_offset_presp] = sdata->csa_current_counter;
 		rcu_read_unlock();
 	}
 }
-- 
2.0.0.rc0

